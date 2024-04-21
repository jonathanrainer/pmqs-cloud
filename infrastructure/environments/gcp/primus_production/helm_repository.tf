resource "google_artifact_registry_repository" "lords" {
  location      = "us-central1"
  repository_id = "lords"
  description   = "A repository of the Helm Charts required to run the Primus system"
  format        = "HELM"
}

