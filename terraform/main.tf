# Google Cloud Storage resources

# Create storage bucket for website's static files
resource "google_storage_bucket" "static_website" {
  name          = "static-website-bucket-fd"
  location      = "EU"
  storage_class = "STANDARD"
  website {
    main_page_suffix = "resume.html"
  }
  
  force_destroy = true
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

# Make bucket public
resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.static_website.id
  role   = "READER"
  entity = "allUsers"
}


# Cloud Load Balancing resources

# Google-managed SSL certificate
resource "google_compute_managed_ssl_certificate" "resume-ssl-cert" {
  name     = "resume-ssl-cert"

  managed {
    domains = ["felitadonor.com"]
  }
}

# Static IPv4 address
resource "google_compute_global_address" "resume-lb-ip" {
  name = "resume-lb-ip"
}

# External Application Load Balancer with backend bucket

# Backend bucket
resource "google_compute_backend_bucket" "resume-backend-bucket" {
  name        = "backend-bucket"
  description = "Contains resume website files"
  bucket_name = google_storage_bucket.static_website.id
  enable_cdn  = false
}

# URL map: route HTTPS requests to backend bucket
resource "google_compute_url_map" "resume-urlmap" {
  name        = "resume-urlmap"
  description = "Maps resume website to backend bucket"

  default_service = google_compute_backend_bucket.resume-backend-bucket.id
}

# HTTPS target proxy
resource "google_compute_target_https_proxy" "resume-lb-https-proxy" {
  name    = "resume-lb-https-proxy"
  url_map = google_compute_url_map.resume-urlmap.id
  ssl_certificates = [google_compute_managed_ssl_certificate.resume-ssl-cert.id]
}

# Forwarding rule
resource "google_compute_global_forwarding_rule" "resume-forwarding-rule" {
  name                  = "resume-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.resume-lb-https-proxy.id
  ip_address            = google_compute_global_address.resume-lb-ip.id
}
