resource "google_billing_budget" "overall_budget" {
  depends_on = [
    google_project_service.enabled_apis["billingbudgets.googleapis.com"]
  ]

  billing_account = data.google_billing_account.pmqs_cloud_billing_account.id
  amount {
    specified_amount {
      currency_code = "GBP"
      units         = "10"
    }
  }
  display_name = "Overall Budget"
  threshold_rules {
    threshold_percent = 0.8
  }
  all_updates_rule {
    monitoring_notification_channels = [
      google_monitoring_notification_channel.email_owner.id
    ]
    disable_default_iam_recipients = true
  }
}

resource "google_monitoring_notification_channel" "email_owner" {
  display_name = "Owner Email Notification Channel"
  type         = "email"

  labels = {
    email_address = var.email
  }
}