data "google_billing_account" "pmqs_cloud_billing_account" {
  billing_account = "01F9E6-4D1C8A-58271E"
}

data "google_folder" "primus" {
  folder              = "66231054798"
  lookup_organization = true
}

resource "google_project" "pmqs_cloud_foundation" {
  name                = "Primus Production"
  project_id          = "primus-production"
  org_id              = data.google_folder.primus.organization
  billing_account     = data.google_billing_account.pmqs_cloud_billing_account.id
  auto_create_network = false
  folder_id           = data.google_folder.primus.id
}