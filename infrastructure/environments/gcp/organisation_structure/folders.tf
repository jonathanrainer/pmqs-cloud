data "google_organization" "pmqs_cloud_org" {
  domain = "pmqs.cloud"
}

resource "google_folder" "primus" {
  display_name = "Primus"
  parent       = data.google_organization.pmqs_cloud_org.id
}