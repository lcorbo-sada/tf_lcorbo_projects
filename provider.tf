
terraform {
  backend "gcs" {
    bucket  = "lcorbo-smart-dev-090822"
    prefix  = "projects"
  }
}

provider "google" {
    project = "lcorbo-smart-dev"
}

