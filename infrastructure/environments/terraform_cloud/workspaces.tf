locals {
  workspaces = [
    "gcp-organisation-structure",
    "primus-production"
  ]
}

module "gcp_organisation_structure" {
  source   = "./modules/pmqs-cloud-workspace"
  for_each = toset(local.workspaces)

  organization_name = tfe_organization.pmqs_cloud.name
  workspace_name    = each.value
}