terraform {
  cloud {
    organization = "pmqs-cloud"

    workspaces {
      name = "primus-production"
    }
  }
}

