output "smart_project_id" { 
  value = local.project_id
}

output "bucket" { 
  value = google_storage_bucket.bucket.name
}
