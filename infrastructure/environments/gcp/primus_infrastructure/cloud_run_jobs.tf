locals {
  cloudrun_jobs = {
    pitt_weekly = {
      docker_image   = "us-central1-docker.pkg.dev/primus-infrastructure/stone/pitt:prod"
      cron_expresion = "0 14 * * 3"
      args           = "--num-weeks 4"
      description    = "A weekly job that looks back over the previous month to capture new PMQs instances"
    },
    pitt_monthly = {
      docker_image   = "us-central1-docker.pkg.dev/primus-infrastructure/stone/pitt:prod"
      cron_expresion = "* 2 15 * *"
      args           = "--start-date 01-11-1989"
      description    = "A monthly job that looks back over all time (from when PMQs was first televised) to ensure we have everything"
    }
  }
}

resource "google_cloud_run_v2_job" "primus_jobs" {
  for_each = local.cloudrun_jobs
  name     = each.key
  location = "us-central1"

  template {
    task_count = 1
    template {
      containers {
        name  = "main"
        image = value.docker_image
        args  = value.args
      }
      service_account = google_service_account.cloud_run_pitt.email
    }
  }

  depends_on = [
    google_project_service.enabled_apis["run.googleapis.com"]
  ]
}

resource "google_cloud_scheduler_job" "primus_scheduler" {
  for_each    = local.cloudrun_jobs
  name        = each.key
  region      = "us-central1"
  description = each.value.description
  schedule    = each.value.cron_expresion
  time_zone   = "Europe/London"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "POST"
    uri         = "https://${google_cloud_run_v2_job.primus_jobs[each.key].location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${google_project.primus_infrastructure.number}/jobs/${google_cloud_run_v2_job.primus_jobs[each.key].name}:run"

    oauth_token {
      service_account_email = google_service_account.cloud_run_pitt.email
    }
  }

  depends_on = [
    google_project_service.enabled_apis["cloudscheduler.googleapis.com"]
  ]
}