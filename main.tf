
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

resource "google_project_service" "run" {
  project = google_project.smart.id
  service = "run.googleapis.com"
}


resource "google_storage_bucket" "bucket" {
  name                        = "lcorbo-smart-test-090822"
  project                     = "lcorbo-smart-dev"
  location                    = "US"
  uniform_bucket_level_access = true
}

data "archive_file" "cloud_function_code" {
  type             = "zip"
  source_dir       = "${path.module}/code/helloworld/"
  output_file_mode = "0666"
  output_path      = "${path.module}/bin/index.zip"
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = google_storage_bucket.bucket.name
  source = "${path.module}/bin/index.zip"
}

/* resource "google_cloudfunctions_function" "function" {
  region                = "us-central1"
  project               = google_project.smart.id
  name                  = "nodejs-http-function"
  description           = "nodejs-http-function"
  runtime               = "nodejs16"
  ingress_settings      = "ALLOW_ALL"
  trigger_http          = true
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  entry_point           = "helloGET"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "allUsers"
}  */

resource "google_cloudfunctions2_function" "function" {
  project               = "lcorbo-smart-dev"
  name = "function-v2"
  location = "us-east1"
  description = "a new function"

  build_config {
    runtime = "nodejs16"
    entry_point = "helloGET"  # Set the entry point 
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.archive.name
      }
    }
  }

  service_config {
    max_instance_count  = 1
    available_memory    = "256M"
    timeout_seconds     = 60
  }
}

output "function_uri" { 
  value = google_cloudfunctions2_function.function.service_config[0].uri
}

#pubsub.googleapis.com
