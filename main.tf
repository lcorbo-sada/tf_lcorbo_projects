
resource "google_folder" "lcorbo" {
  display_name = "Lcorbo Projects"
  parent       = "folders/618814784533"
}

resource "google_project" "smart" {
  name            = "Lcorbo SMART Dev"
  project_id      = "lcorbo-smart-dev"
  billing_account = "01C805-AC04C5-836F50"
  folder_id       = google_folder.lcorbo.name
}

locals {
  project_id = trimprefix(google_project.smart.id, "projects/")
}

resource "google_project_service" "cloudbuild" {
  project = local.project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "artifactregistry" {
  project = local.project_id
  service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "cloudfunctions" {
  project = local.project_id
  service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "run" {
  project = google_project.smart.id
  service = "run.googleapis.com"
}

#pubsub.googleapis.com

resource "google_storage_bucket" "bucket" {
  name                        = "${local.project_id}-090822"
  project                     = local.project_id
  location                    = "US"
  uniform_bucket_level_access = true
}
