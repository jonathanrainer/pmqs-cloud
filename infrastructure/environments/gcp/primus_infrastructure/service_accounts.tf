resource "google_service_account" "github_actions_pmqs_cloud" {
  account_id   = "github-actions-pmqs-cloud"
  display_name = "GitHub Actions (pmqs-cloud)"
  description  = "The account through which GitHub Actions can publish artifacts"
  project      = google_project.primus_infrastructure.id
}