resource "tfe_workspace_variable_set" "gcp_workload_identity_variables" {
  variable_set_id = var.workload_identity_variable_set_id
  workspace_id    = tfe_workspace.workspace.id
}