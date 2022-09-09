
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

resource "google_project_service" "cloudbuild" {
  project = google_project.smart.id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "artifactregistry" {
  project = google_project.smart.id
  service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "cloudfunctions" {
  project = google_project.smart.id
  service = "cloudfunctions.googleapis.com"
}

resource "google_storage_bucket" "bucket" {
  name     = "lcorbo-smart-test-090822"
  project = "lcorbo-smart-dev"
  location = "US"
  uniform_bucket_level_access = true
}

data "archive_file" "lambda_my_function" {
  type             = "zip"
  source_dir      = "${path.module}/code/helloworld/"
  output_file_mode = "0666"
  output_path      = "${path.module}/bin/index.zip"
}

#pubsub.googleapis.com
