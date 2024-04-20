#!/bin/bash

set -euo pipefail

# This bootstrap script creates the absolute minimum resources required to allow us to use Terraform to manage
# resources here-after inside of GCP.
#
# - A project within a GCP account called PMQs Cloud Foundation
# - A bucket into which the Terraform State can be stored

if ! jq --version &> /dev/null; then
  echo "❌jq is not installed, please install to continue"
  exit 1
fi

if ! gcloud --version &> /dev/null; then
  echo "❌gcloud cli is not installed, please install to continue"
  exit 1
fi

echo "🔐 Logging into gcloud account to begin bootstrap process..."
gcloud auth login --activate --brief
echo "✅ Logged in as $(gcloud config list account --format "value(core.account)")"
read -rp "Press enter to continue"

echo "🌎 Creating foundation project..."
BILLING_ACCOUNT_ID=$(gcloud billing accounts list --format json | jq -r '.[0].name')
BILLING_ACCOUNT_ID=${BILLING_ACCOUNT_ID##*/}
PROJECT_ID="pmqs-cloud-foundation"
gcloud projects create $PROJECT_ID --name "PMQs Cloud Foundation" --set-as-default
gcloud beta billing projects link $PROJECT_ID --billing-account="$BILLING_ACCOUNT_ID"
echo "✅ Foundation project created"
read -rp "Press enter to continue"

echo "🪣 Create Foundation Terraform Bucket"
gcloud services enable storage.googleapis.com
gcloud storage buckets create gs://foundation-state --public-access-prevention --project $PROJECT_ID
gcloud storage buckets update gs://foundation-state --versioning
echo "✅ Foundation Terraform Bucket Created"
read -rp "Press enter to continue"
