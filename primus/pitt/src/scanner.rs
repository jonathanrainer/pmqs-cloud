use crate::errors::ScanningError;
use google_cloud_storage::client::Client;
use google_cloud_storage::http::objects::upload::{Media, UploadObjectRequest, UploadType};
use google_cloud_storage::http::Error;
use reqwest::StatusCode;
use serde_json::json;
use sxd_document::parser;
use sxd_xpath::evaluate_xpath;
use time::format_description;
use time::{Duration, OffsetDateTime};
use tracing::{info, trace};

const XML_SOURCE_URL: &str = "https://www.theyworkforyou.com/pwdata/scrapedxml/debates";
const BUCKET_NAME: &str = "pmqs-raw-events";

pub(crate) async fn run_scan(
    earliest_date: OffsetDateTime,
    dry_run: bool,
    gcs_client: &Client,
) -> Result<(), ScanningError> {
    // Build up a loop to iterate over all the dates between the earliest and today
    let mut date = earliest_date;
    let format = format_description::parse("[year]-[month]-[day]").unwrap();
    let scan_timestamp = OffsetDateTime::now_utc().unix_timestamp();
    while date <= OffsetDateTime::now_utc() {
        trace!("Scanning date {}...", date.date());
        for letter in 'a'..='z' {
            // Build up the URL for the XML file for this date
            let date_portion = date.date().format(&format)?;
            let url = format!("{}/debates{}{}.xml", XML_SOURCE_URL, date_portion, letter);
            // Fetch the XML file
            let fetched_xml = fetch_xml(&url).await;
            match fetched_xml {
                Ok(xml) => {
                    // Parse the XML file
                    if xml_contains_pmqs_instance(&xml) {
                        if dry_run {
                            info!("Found PMQs instance on {} at URL {}", date.date(), url);
                        } else {
                            let key = format!(
                                "{}/{}-{}-{}.json",
                                scan_timestamp,
                                date.day(),
                                date.month() as u8,
                                date.year()
                            );
                            info!(
                                "Found PMQs instance on {} - Uploading to GCS at key {}",
                                date.date(),
                                key
                            );
                            upload_event_to_gcs(
                                gcs_client,
                                key,
                                json!({
                                    "date": date.format(&format)?,
                                    "xml_link": url
                                }),
                            )
                            .await?
                        }
                    }
                }
                Err(_) => {
                    // If we get an error here, i.e. the URL doesn't exist, then we've reached the end of the debates for this date
                    // so move onto the next date
                    break;
                }
            }
        }
        date += Duration::days(1)
    }
    Ok(())
}

async fn fetch_xml(url: &str) -> Result<String, String> {
    // Fetch the XML file
    let response = reqwest::get(url).await.unwrap();
    // Check the response code
    match response.status() {
        StatusCode::OK => Ok(response.text().await.unwrap()),
        _ => Err("Error fetching XML file".parse().unwrap()),
    }
}

fn xml_contains_pmqs_instance(xml: &str) -> bool {
    let package = parser::parse(xml).expect("failed to parse the XML");
    let document = package.as_document();

    match evaluate_xpath(
        &document,
        "//publicwhip/minor-heading[contains(text(),\"Engagements\")]",
    ) {
        Ok(sxd_xpath::Value::Nodeset(nodes)) => nodes.size() > 0,
        Ok(_) => false,
        Err(_) => false,
    }
}

async fn upload_event_to_gcs(
    gcs_client: &Client,
    key: String,
    data: serde_json::Value,
) -> Result<(), Error> {
    // Upload the file
    let upload_type = UploadType::Simple(Media::new(key));
    gcs_client
        .upload_object(
            &UploadObjectRequest {
                bucket: BUCKET_NAME.to_string(),
                ..Default::default()
            },
            data.to_string().into_bytes(),
            &upload_type,
        )
        .await
        .map(|_| ())
}
