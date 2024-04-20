use thiserror::Error;
use tracing_subscriber::filter::FromEnvError;

#[derive(Error, Debug)]
pub enum PittError {
    #[error("Logging Environment Variable Contains Invalid Directives")]
    EnvironmentVariableIncorrectDirectives(#[from] FromEnvError),
    #[error("Could not scan occurrences correctly")]
    ScanningError(#[from] ScanningError),
}

#[derive(Error, Debug)]
pub enum ScanningError {
    #[error("Could not parse date correctly")]
    UnparsableDate(#[from] time::error::Format),
}
