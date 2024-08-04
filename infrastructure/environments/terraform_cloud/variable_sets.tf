resource "tfe_variable_set" "gcp_workload_identity_federation" {
  name         = "GCP Workload Identity Variables"
  description  = "Variables to enable a connection to GCP via WIF"
  organization = tfe_organization.pmqs_cloud.id
}

resource "tfe_variable" "gcp_provider_auth" {
  category        = "env"
  key             = "TFC_GCP_PROVIDER_AUTH"
  value           = "true"
  description     = "Tells Terraform Cloud to use WIF to try and connect to GCP"
  variable_set_id = tfe_variable_set.gcp_workload_identity_federation.id
}

resource "tfe_variable" "gcp_run_service_account_email" {
  category        = "env"
  key             = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value           = "terraform@pmqs-cloud-foundation.iam.gserviceaccount.com"
  description     = "The service account to use inside of GCP"
  variable_set_id = tfe_variable_set.gcp_workload_identity_federation.id
}

resource "tfe_variable" "gcp_workload_provider_name" {
  category        = "env"
  key             = "TFC_GCP_WORKLOAD_PROVIDER_NAME"
  value           = "projects/35888650815/locations/global/workloadIdentityPools/terraform-cloud/providers/terraform-cloud"
  description     = "The service account to use inside of GCP"
  variable_set_id = tfe_variable_set.gcp_workload_identity_federation.id
}