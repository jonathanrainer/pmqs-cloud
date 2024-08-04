# `foundation`

This folder controls the minimal manual resources we need to bootstrap
a setup that can be used with Terraform Cloud.

**This should never need to be touched under normal operations**

## [`bootstrap.sh`](./bootstrap.sh)
However, if we have to run stuff here, this script will create, manually, the
two resources we need so we can then run Terraform to set up everything else.

This script pre-supposes that we have a suitable GCP Organisation to use.