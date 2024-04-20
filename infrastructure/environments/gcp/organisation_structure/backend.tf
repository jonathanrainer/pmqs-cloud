terraform {
  cloud {
    organization = "pmqs-cloud"

    workspaces {
      name = "gcp-organisation-structure"
    }
  }
}