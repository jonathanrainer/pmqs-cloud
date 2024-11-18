data "google_iam_role" "security_reviewer" {
  name = "roles/iam.securityReviewer"
}


data "google_iam_role" "cloudrun_developer" {
  name = "roles/run.developer"
}

resource "google_project_iam_binding" "security_reviewer" {
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.security_reviewer.name
}

resource "google_project_iam_binding" "cloudrun_developer" {
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.cloudrun_developer.name
}