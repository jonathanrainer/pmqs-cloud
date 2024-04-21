resource "tfe_workspace" "workspace" {
  name         = var.workspace_name
  organization = var.organization_name
}