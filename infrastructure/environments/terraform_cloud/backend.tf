terraform {
  backend "gcs" {
    bucket = "foundation-state"
    prefix = "terraform-cloud"
  }
}