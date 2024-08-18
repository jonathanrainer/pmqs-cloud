use crate::errors::ScanningError;
use reqwest::StatusCode;
use sxd_document::parser;
use sxd_xpath::{evaluate_xpath, Value};
use time::format_description;
use time::{Duration, OffsetDateTime};
use tracing::{debug, info, trace};

const XML_SOURCE_URL: &str = "https://www.theyworkforyou.com/pwdata/scrapedxml/debates";

pub(crate) async fn run_scan(
    earliest_date: OffsetDateTime,
    dry_run: bool,
) -> Result<(), ScanningError> {
    // Build up a loop to iterate over all the dates between the earliest and today
    let mut date = earliest_date;
    let format = format_description::parse("[year]-[month]-[day]").unwrap();
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
                            debug!("Found PMQs instance on {} at URL {}", date.date(), url);
                        } else {
                            info!("Pushing to Pub/Sub")
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
        Ok(Value::Nodeset(nodes)) => nodes.size() > 0,
        Ok(_) => false,
        Err(_) => false,
    }
}
