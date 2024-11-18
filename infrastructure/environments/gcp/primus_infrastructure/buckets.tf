resource "google_storage_bucket" "raw_events" {
  name          = "pmqs-raw-events"
  location      = "US"
  force_destroy = true

  autoclass {
    enabled = false
  }
}