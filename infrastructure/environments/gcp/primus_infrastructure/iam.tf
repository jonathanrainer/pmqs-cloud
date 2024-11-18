data "google_iam_role" "security_reviewer" {
  name = "roles/iam.securityReviewer"
}

data "google_iam_role" "artifactregistry_administrator" {
  name = "roles/artifactregistry.admin"
}

resource "google_project_iam_binding" "security_reviewer" {
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.security_reviewer.name
}

resource "google_project_iam_binding" "artifactregistry_administrator" {
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.artifactregistry_administrator.name
}