data "google_iam_role" "artifact_registry_writer" {
  name = "roles/artifactregistry.writer"
}

data "google_iam_role" "artifactregistry_administrator" {
  name = "roles/artifactregistry.admin"
}

resource "google_artifact_registry_repository" "stone" {
  location      = "us-central1"
  repository_id = "stone"
  description   = "A repository of the Docker Images required to run the services in Primus. Named after Sir Benjamin Stone."
  format        = "DOCKER"
  project       = google_project.primus_infrastructure.project_id
  docker_config {
    immutable_tags = true
  }
}

resource "google_project_iam_binding" "artifact_registry_writer" {
  members = [
    google_service_account.github_actions_pmqs_cloud.member
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.artifact_registry_writer.name
}

resource "google_project_iam_binding" "artifactregistry_administrator" {
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.artifactregistry_administrator.name
}