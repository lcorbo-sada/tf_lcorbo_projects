
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



#pubsub.googleapis.com
