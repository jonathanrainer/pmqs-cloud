data "google_iam_role" "artifactregistry_administrator" {
  name = "roles/artifactregistry.repoAdmin"
}

resource "google_project_iam_binding" "artifactregistry_administrator" {
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.artifactregistry_administrator.name
}