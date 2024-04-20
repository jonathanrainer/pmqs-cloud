mod errors;
mod scanner;

use crate::errors::PittError;
use clap::{arg, Args, Parser};
use time::{format_description, Duration, OffsetDateTime};
use tracing::info;
use tracing::level_filters::LevelFilter;
use tracing_subscriber::filter::FromEnvError;
use tracing_subscriber::EnvFilter;

const K_SERVICE_ENV_VAR: &str = "K_SERVICE";

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
    #[command(flatten)]
    times: Times,
    #[arg(long)]
    dry_run: bool,
}

#[derive(Args)]
#[group(required = true, multiple = false)]
struct Times {
    #[arg(long, value_parser = parse_start_date, required_unless_present = "num_weeks")]
    start_date: Option<OffsetDateTime>,
    #[arg(long, required_unless_present = "start_date")]
    num_weeks: Option<u32>,
}

fn parse_start_date(raw_date: &str) -> Result<OffsetDateTime, String> {
    let format = format_description::parse("[year]-[month]-[day]").unwrap();
    OffsetDateTime::parse(raw_date, &format).map_err(|e| e.to_string())
}

#[tokio::main]
async fn main() -> Result<(), PittError> {
    let args = Cli::parse();
    configure_tracing()?;

    info!("Getting earliest date to begin scanning data");
    let earliest_date = if args.times.num_weeks.is_some() {
        OffsetDateTime::now_utc() - Duration::days((args.times.num_weeks.unwrap() * 7) as i64)
    } else {
        args.times.start_date.unwrap()
    };
    info!(
        "Earliest date to begin scanning data: {}",
        earliest_date.date()
    );

    scanner::run_scan(earliest_date, args.dry_run)
        .await
        .map_err(|e| e.into())
}

fn configure_tracing() -> Result<(), FromEnvError> {
    let filter = EnvFilter::builder()
        .with_default_directive(LevelFilter::INFO.into())
        .from_env()?;
    let sub = tracing_subscriber::fmt().with_env_filter(filter);
    if std::env::var_os(K_SERVICE_ENV_VAR).is_some() {
        sub.json().init();
    } else {
        sub.pretty().init();
    }
    Ok(())
}
