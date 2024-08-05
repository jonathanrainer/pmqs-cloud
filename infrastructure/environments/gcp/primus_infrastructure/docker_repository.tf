resource "google_artifact_registry_repository" "stone" {
  location      = "us-central1"
  repository_id = "stone"
  description   = "A repository of the Docker Images required to run the services in Primus. Named after Sir Benjamin Stone."
  format        = "DOCKER"
  project       = google_project.primus_infrastructure.id
}