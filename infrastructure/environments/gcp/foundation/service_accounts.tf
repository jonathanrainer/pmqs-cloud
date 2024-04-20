data "google_iam_role" "folder_admin" {
  name = "roles/resourcemanager.folderAdmin"
}

data "google_iam_role" "project_creator" {
  name = "roles/resourcemanager.projectCreator"
}

data "google_iam_role" "project_deleter" {
  name = "roles/resourcemanager.projectDeleter"
}

data "google_iam_role" "billing_viewer" {
  name = "roles/billing.viewer"
}

resource "google_service_account" "terraform_service_account" {
  account_id   = "terraform"
  display_name = "Terraform"
  description  = "The account through which our Terraform is applied to the organisation"
  project      = google_project.pmqs_cloud_foundation.project_id
}

resource "google_organization_iam_binding" "folder_admin" {
  members = [google_service_account.terraform_service_account.member]
  org_id  = data.google_organization.pmqs_cloud_org.org_id
  role    = data.google_iam_role.folder_admin.id
}

resource "google_organization_iam_binding" "project_creator" {
  members = [google_service_account.terraform_service_account.member]
  org_id  = data.google_organization.pmqs_cloud_org.org_id
  role    = data.google_iam_role.project_creator.id
}

resource "google_organization_iam_binding" "project_deleter" {
  members = [google_service_account.terraform_service_account.member]
  org_id  = data.google_organization.pmqs_cloud_org.org_id
  role    = data.google_iam_role.project_deleter.id
}

resource "google_organization_iam_binding" "billing_viewer" {
  members = [google_service_account.terraform_service_account.member]
  org_id  = data.google_organization.pmqs_cloud_org.org_id
  role    = data.google_iam_role.billing_viewer.id
}