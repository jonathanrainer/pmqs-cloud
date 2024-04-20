mod scanner;

use std::env;
use chrono::{Duration, NaiveDate};
use log4rs::append::console::ConsoleAppender;
use log4rs::Config;
use log4rs::config::{Appender, Logger, Root};
use log::LevelFilter;
use clap::{arg, Args, Parser, value_parser};

#[derive(Parser)]
#[command(version, about, long_about = None)]
struct Cli {
    #[command(flatten)]
    times: Times,
    #[arg(long)]
    dry_run: bool
}

#[derive(Args)]
#[group(required = true, multiple = false)]
struct Times {
    #[arg(long, value_parser = value_parser!(NaiveDate), required_unless_present = "num_weeks")]
    start_date: Option<NaiveDate>,
    #[arg(long, required_unless_present = "start_date")]
    num_weeks: Option<u32>,
}


#[tokio::main]
async fn main() {
    initialise_logging();
    let args = Cli::parse();

    log::info!("Getting earliest date to begin scanning data");
    let earliest_date = if args.times.num_weeks.is_some() {
        (chrono::offset::Local::now() - Duration::days((args.times.num_weeks.unwrap() * 7) as i64)).date_naive()
    } else {
        args.times.start_date.unwrap()
    };
    log::info!("Earliest date to begin scanning data: {}", earliest_date);

    scanner::run_scan(earliest_date, args.dry_run).await;
}

fn initialise_logging() {
    match env::var("HUMPHREY_LOG_CONFIG_PATH") {
        Ok(path) => {
            log4rs::init_file(&path, Default::default()).unwrap();
            log::info!("Logging initialised from file: {}", path);
    },
        Err(_) => {
            let stdout = ConsoleAppender::builder().build();
            let config = Config::builder()
                .appender(
                    Appender::builder()
                        .build("stdout", Box::new(stdout),
                ))
                .logger(Logger::builder().build("reqwest", LevelFilter::Off))
                .logger(Logger::builder().build("hyper_util", LevelFilter::Off))
                .build(
                    Root::builder()
                        .appender("stdout")
                        .build(LevelFilter::Debug),
                )
                .unwrap();
            log4rs::init_config(config).unwrap();
            log::info!("Logging initialised from in-code config");
        }
    }
}