resource "tfe_workspace" "gcp_organisation_structure" {
  name         = "gcp-organisation-structure"
  organization = tfe_organization.pmqs_cloud.name
}

resource "tfe_workspace" "production" {
  name         = "production"
  organization = tfe_organization.pmqs_cloud.name
}

