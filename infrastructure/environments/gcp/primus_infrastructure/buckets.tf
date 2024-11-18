resource "google_storage_bucket" "raw_events" {
  name          = "pmqs-raw-events"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  autoclass {
    enabled = false
  }
}