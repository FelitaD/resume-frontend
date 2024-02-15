# Create storage bucket for website's static files

resource "google_storage_bucket" "static_website" {
  name          = "static-website-bucket-fd"
  location      = "EU"
  storage_class = "STANDARD"
  force_destroy = true

  uniform_bucket_level_access = false

  website {
    main_page_suffix = "resume.html"
  }

  cors {
    origin          = ["https://felitadonor.com"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

# Upload pages to the bucket

resource "google_storage_bucket_object" "html" {
  name         = "resume.html"
  source       = "/Users/donor/Code/resume-challenge/resume-frontend/website/resume.html"
  content_type = "text/html"
  bucket       = google_storage_bucket.static_website.name
}

resource "google_storage_bucket_object" "css" {
  name         = "resume.css"
  source       = "/Users/donor/Code/resume-challenge/resume-frontend/website/css/styles.css"
  content_type = "text/css"
  bucket       = google_storage_bucket.static_website.name
}

resource "google_storage_bucket_object" "javascript" {
  name         = "script.js"
  source       = "/Users/donor/Code/resume-challenge/resume-frontend/website/js/scripts.js"
  content_type = "text/javascript"
  bucket       = google_storage_bucket.static_website.name
}

# Make bucket public

resource "google_storage_bucket_acl" "static_website_acl" {
  bucket = google_storage_bucket.static_website.name
  role_entity = [
    "READER:allUsers",
  ]
}
