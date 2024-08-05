data "google_billing_account" "pmqs_cloud_billing_account" {
  billing_account = "01F9E6-4D1C8A-58271E"
}

data "google_folder" "primus" {
  folder              = "66231054798"
  lookup_organization = true
}

data "google_client_config" "this" {}

resource "google_project" "primus_infrastructure" {
  name                = "Primus Infrastructure"
  project_id          = data.google_client_config.this.project
  billing_account     = data.google_billing_account.pmqs_cloud_billing_account.id
  auto_create_network = false
  folder_id           = data.google_folder.primus.id
}

moved {
  from = google_project.pmqs_cloud_foundation
  to   = google_project.primus_infrastructure
}