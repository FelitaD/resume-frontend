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

# Create Load Balancing resources

# Create backend bucket
resource "google_compute_backend_bucket" "resume-backend-bucket" {
  name        = "resume-backend-bucket"
  description = "Contains resume website files"
  bucket_name = google_storage_bucket.static_website.id
  enable_cdn  = true
}

# Create URL map from hostname to backend bucket (instead of default backend service)
resource "google_compute_url_map" "resume-urlmap" {
  name        = "resume-urlmap"
  description = "Maps resume website to backend bucket"

  default_service = google_compute_backend_bucket.resume-backend-bucket.id
}

# Setup HTTPS Load Balancer
module "gce-lb-http" {
  source            = "GoogleCloudPlatform/lb-http/google"
  version           = "~> 10.0"

  name                            = "resume-http-lb"
  project                         = var.project

  ssl                             = true
  managed_ssl_certificate_domains = ["felitadonor.com"]
  create_address                  = true # create a new global IPv4 address
  https_redirect                  = true
  load_balancing_scheme           = "EXTERNAL"
  url_map                         = google_compute_url_map.resume-urlmap.id

  backends = {
    default = {
      port                            = var.service_port
      protocol                        = "HTTPS"
      port_name                       = var.service_port_name
      timeout_sec                     = 10
      enable_cdn                      = false 

      health_check = {
        request_path                  = "/"
        port                          = var.service_port
      }

      log_config = {
        enable = true
        sample_rate = 1.0
      }

      groups = [
        {
          # Each node pool instance group should be added to the backend.
          group                       = var.backend
        },
      ]

      iap_config = {
        enable               = false
      }
    }
  }
}