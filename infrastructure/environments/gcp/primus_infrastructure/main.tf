terraform {
  cloud {
    organization = "pmqs-cloud"

    workspaces {
      name = "primus-infrastructure"
    }
  }
}

