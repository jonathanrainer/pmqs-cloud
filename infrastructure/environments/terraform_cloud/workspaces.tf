locals {
  workspaces = [
    "gcp-organisation-structure",
    "primus-infrastructure"
  ]
}

module "gcp_organisation_structure" {
  source   = "./modules/pmqs-cloud-workspace"
  for_each = toset(local.workspaces)

  organization_name                 = tfe_organization.pmqs_cloud.name
  workspace_name                    = each.value
  workload_identity_variable_set_id = tfe_variable_set.gcp_workload_identity_federation.id
}