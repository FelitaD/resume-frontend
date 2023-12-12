# Create storage bucket for website's static files
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "static_website" {
  name          = "${random_id.bucket_prefix.hex}-static-website-bucket"
  location      = "EU"
  storage_class = "STANDARD"
  website {
    main_page_suffix = "resume.html"
  }
}

# Upload pages to the bucket
resource "google_storage_bucket_object" "html" {
  name         = "resume.html"
  source      = "/Users/donor/Code/resume-challenge/resume-frontend/resume.html"
  content_type = "text/html"
  bucket       = google_storage_bucket.static_website.id
}

resource "google_storage_bucket_object" "css" {
  name         = "resume.css"
  content      = "/Users/donor/Code/resume-challenge/resume-frontend/resume.css"
  content_type = "text/css"
  bucket       = google_storage_bucket.static_website.id
}

resource "google_storage_bucket_object" "javascript" {
  name         = "script.js"
  content      = "/Users/donor/Code/resume-challenge/resume-frontend/script.js"
  content_type = "text/javascript"
  bucket       = google_storage_bucket.static_website.id
}

# Make bucket public by granting allUsers READER access
resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.static_website.id
  role   = "READER"
  entity = "allUsers"
}

# Setup HTTPS Load Balancer

