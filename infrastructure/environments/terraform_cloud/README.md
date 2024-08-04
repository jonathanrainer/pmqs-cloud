# Terraform Cloud

We use Terraform Cloud to orchestrate the planning and application of the Terraform
we use for all of PMQs Cloud.

We divide down the resources we manage into Workspaces which roughly correspond to a GCP
Project's worth of stuff. For some providers we might not divide down that far, but we can
make that decision as and when we need to support multiple clouds.

**Note:** The Terraform here has to be manually applied, similarly to [`gcp/foundation`](../gcp/foundation) as Terraform
Cloud cannot be managed from Terraform Cloud.