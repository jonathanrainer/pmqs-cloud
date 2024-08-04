# Google Cloud Platform (GCP)

We deploy all of our services that actually run PMQs Cloud into GCP and
their infrastructure is defined here. The folders roughly correspond to the 
Terraform Cloud workspaces we've defined however, and are named accordingly.
The two that are not `foundation` and `organisation_structure` are slightly different.

## `foundation`
This corresponds to the infrastructure required to bootstrap our Terraform. It's 
very unlikely this will ever need to be touched unless we suffer a catastrophic loss
of service. This Terraform is applied manually via a GCS Bucket that is created
manually within the `PMQ's Cloud Foundation` Project.

# `organisation_structure`
This is simply a workspace that defines the structure of folders that exists for 
the organisation.