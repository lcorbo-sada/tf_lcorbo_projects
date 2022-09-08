
resource "google_folder" "lcorbo" {
  display_name = "Lcorbo Projects"
  parent       = "folders/618814784533"
}

resource "google_project" "smart" {
  name       = "Lcorbo SMART Dev"
  project_id = "lcorbo-smart-dev"
  folder_id  = google_folder.lcorbo.name
}

resource "google_project_service" "project" {
  project = google_project.smart.id
  service = "iam.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}