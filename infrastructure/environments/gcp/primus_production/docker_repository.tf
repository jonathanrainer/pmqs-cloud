resource "google_artifact_registry_repository" "commons" {
  location      = "us-central1"
  repository_id = "commons"
  description   = "A repository of the Docker Images required to run the Primus system"
  format        = "DOCKER"
}