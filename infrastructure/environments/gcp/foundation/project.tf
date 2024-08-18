data "google_organization" "pmqs_cloud_org" {
  domain = "pmqs.cloud"
}

data "google_billing_account" "pmqs_cloud_billing_account" {
  billing_account = "01F9E6-4D1C8A-58271E"
}

locals {
  enabled_apis = [
    "iamcredentials.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "billingbudgets.googleapis.com"
  ]
}

resource "google_project" "pmqs_cloud_foundation" {
  name                = "PMQs Cloud Foundation"
  project_id          = "pmqs-cloud-foundation"
  org_id              = data.google_organization.pmqs_cloud_org.org_id
  billing_account     = data.google_billing_account.pmqs_cloud_billing_account.id
  auto_create_network = false
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "enabled_apis" {
  for_each = toset(local.enabled_apis)
  project = google_project.pmqs_cloud_foundation.id
  service = each.value
}