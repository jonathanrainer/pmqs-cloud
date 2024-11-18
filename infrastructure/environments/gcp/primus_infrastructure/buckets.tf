resource "google_storage_bucket" "raw_events" {
  name          = "pmqs-raw-events"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  autoclass {
    enabled = false
  }
}

data "google_iam_role" "storage_object_creator" {
  name = "roles/storage.objectCreator"
}

resource "google_storage_bucket_iam_binding" "pitt_access" {
  bucket = google_storage_bucket.raw_events.name
  members = [
    google_service_account.cloud_run_pitt.member
  ]
  role = data.google_iam_role.storage_object_creator.name
}

data "google_iam_role" "storage_object_viewer" {
  name = "roles/storage.objectViewer"
}

resource "google_storage_bucket_iam_binding" "personal_access" {
  bucket = google_storage_bucket.raw_events.name
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  role = data.google_iam_role.storage_object_viewer.name
}