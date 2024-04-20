data "google_iam_role" "workload_identity_user" {
  name = "roles/iam.workloadIdentityUser"
}

resource "google_iam_workload_identity_pool" "terraform_cloud" {
  workload_identity_pool_id = "terraform-cloud"
  display_name              = "Terraform Cloud"
  description               = "Identity pool to authenticate Terraform Cloud"
}

resource "google_iam_workload_identity_pool_provider" "terraform_cloud" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.terraform_cloud.workload_identity_pool_id
  workload_identity_pool_provider_id = "terraform-cloud"
  display_name                       = "Terraform Cloud"
  description                        = "Identity Pool Provider for automated Terraform applies and plans"
  oidc {
    issuer_uri = "https://app.terraform.io"
  }
  attribute_mapping = {
    "google.subject" : "assertion.sub"
    "attribute.organisation" : "assertion.terraform_organization_name"
  }
  attribute_condition = "assertion.terraform_organization_name.startsWith(\"pmqs-cloud\")"
}

resource "google_service_account_iam_binding" "terraform_workload_identity_user" {
  members = [
    "principalSet://iam.googleapis.com/projects/${google_project.pmqs_cloud_foundation.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.terraform_cloud.workload_identity_pool_id}/attribute.organisation/pmqs-cloud"
  ]
  role               = data.google_iam_role.workload_identity_user.name
  service_account_id = google_service_account.terraform_service_account.id
}