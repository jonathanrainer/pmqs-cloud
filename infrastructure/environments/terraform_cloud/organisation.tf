resource "tfe_organization" "pmqs_cloud" {
  email = var.owner_email
  name  = "pmqs-cloud"
}