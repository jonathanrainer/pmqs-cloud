data "google_iam_role" "workload_identity_user" {
  name = "roles/iam.workloadIdentityUser"
}

resource "google_iam_workload_identity_pool" "github_actions_pmqs_cloud" {
  workload_identity_pool_id = "github-actions-pmqs-cloud"
  display_name              = "GitHub Actions (pmqs-cloud)"
  description               = "Identity pool to authenticate from GitHub Actions running in pmqs-cloud repo"
}

resource "google_iam_workload_identity_pool_provider" "github_actions_pmqs_cloud" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_pmqs_cloud.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-pmqs-cloud"
  display_name                       = "GitHub Actions (pmqs-cloud)"
  description                        = "Identity Pool Provider for publishing to Artifact Registry from GitHub Actions"
  oidc {
    issuer_uri = "GitHub Actions (pmqs-cloud)"
  }
  attribute_mapping = {
    "google.subject" : "assertion.sub"
    "attribute.actor" : "assertion.actor"
    "attribute.aud" : "assertion.aud"
    "attribute.repository" : "assertion.repository"
  }
  attribute_condition = "assertion.repository == \"jonathanrainer/pmqs-cloud\""
}

resource "google_service_account_iam_binding" "github_actions_workload_identity_user" {
  members = [
    "principalSet://iam.googleapis.com/projects/${google_project.primus_infrastructure.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.github_actions_pmqs_cloud.workload_identity_pool_id}/attribute.repository/jonathanrainer/pmqs-cloud"
  ]
  role               = data.google_iam_role.workload_identity_user.name
  service_account_id = google_service_account.github_actions_pmqs_cloud.id
}