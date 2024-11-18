resource "google_service_account" "github_actions_pmqs_cloud" {
  account_id   = "github-actions-pmqs-cloud"
  display_name = "GitHub Actions (pmqs-cloud)"
  description  = "The account through which GitHub Actions can publish artifacts"
  project      = google_project.primus_infrastructure.project_id
}

resource "google_service_account" "cloud_run_pitt" {
  account_id   = "cloud-run-pitt"
  display_name = "Cloud Run (pitt)"
  description  = "A service account which provides access to GCS buckets for the pitt service"
  project      = google_project.primus_infrastructure.project_id
}