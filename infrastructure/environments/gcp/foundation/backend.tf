terraform {
  backend "gcs" {
    bucket = "foundation-state"
    prefix = "state"
  }
}