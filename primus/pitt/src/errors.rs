use google_cloud_storage::client::google_cloud_auth;
use thiserror::Error;
use tracing_subscriber::filter::FromEnvError;

#[derive(Error, Debug)]
pub enum PittError {
    #[error("Logging Environment Variable Contains Invalid Directives")]
    EnvironmentVariableIncorrectDirectives(#[from] FromEnvError),
    #[error("Could not scan occurrences correctly")]
    ScanningError(#[from] ScanningError),
    #[error("Could not create config correctly")]
    ConfigError(#[from] google_cloud_auth::error::Error),
}

#[derive(Error, Debug)]
pub enum ScanningError {
    #[error("Could not parse date correctly")]
    UnparsableDate(#[from] time::error::Format),
    #[error("Could not upload data to GCS")]
    UploadFailed(#[from] google_cloud_storage::http::Error),
}
