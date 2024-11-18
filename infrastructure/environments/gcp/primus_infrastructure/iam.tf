data "google_iam_role" "security_reviewer" {
  name = "roles/iam.securityReviewer"
}

resource "google_project_iam_binding" "security_reviewer" {
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.security_reviewer.name
}