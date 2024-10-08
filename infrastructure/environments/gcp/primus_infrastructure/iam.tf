data "google_iam_role" "artifactregistry_administrator" {
  name = "roles/artifactregistry.admin"
}

data "google_iam_role" "workload_identity_pool_viewer" {
  name = "roles/iam.workloadIdentityPoolViewer"
}

data "google_iam_role" "cloudasset_viewer" {
  name = "roles/cloudasset.viewer"
}

resource "google_project_iam_binding" "artifactregistry_administrator" {
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.artifactregistry_administrator.name
}

resource "google_project_iam_binding" "workload_identity_pool_viewer" {
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.workload_identity_pool_viewer.name
}

resource "google_project_iam_binding" "cloudasset_viewer" {
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  project = google_project.primus_infrastructure.project_id
  role    = data.google_iam_role.cloudasset_viewer.name
}