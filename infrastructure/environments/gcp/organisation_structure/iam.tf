data "google_iam_role" "browser" {
  name = "roles/browser"
}

resource "google_folder_iam_binding" "folder_browser" {
  folder = google_folder.primus.id
  members = [
    "user:jonathan@pmqs.cloud"
  ]
  role = data.google_iam_role.browser.name
}