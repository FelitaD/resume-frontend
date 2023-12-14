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
  bucket_name = google_storage_bucket.static_website.name
  enable_cdn  = true
}

# Create URL map from hostname to backend bucket (instead of default backend service)
resource "google_compute_url_map" "resume-urlmap" {
  name        = "resume-urlmap"
  description = "Maps resume website to backend bucket"

  default_service = google_compute_backend_bucket.resume-backend-bucket.id
}

# Create Network Endpoint Group
resource "google_compute_region_network_endpoint_group" "resume-neg" {
  name        = "resume-neg"
  region      = var.region
}

# Setup HTTPS Load Balancer
module "lb-http" {
  source            = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version           = "~> 10.0"

  name                            = "frontend-resume-lb"
  project                         = var.project

  ssl                             = true
  managed_ssl_certificate_domains = ["felitadonor.com"]
  create_address                  = true # create a new IPv4 address
  https_redirect                  = true
  load_balancing_scheme           = "EXTERNAL"
  url_map                         = google_compute_url_map.resume-urlmap.name

  backends = {
    default = {
      protocol                        = "HTTPS"
      port_name                       = var.service_port_name
      enable_cdn                      = true

      cdn_policy = {
        cache_mode                   = optional(string)
        signed_url_cache_max_age_sec = optional(string)
        default_ttl                  = optional(number)
        max_ttl                      = optional(number)
        client_ttl                   = optional(number)
        negative_caching             = optional(bool)
        negative_caching_policy = {
          code = optional(number)
          ttl  = optional(number)
      }

      log_config = {
        enable = true
        sample_rate = 1.0
      }

      groups = [
        {
          # Your serverless service should have a NEG created that's referenced here.
          group = google_compute_region_network_endpoint_group.resume-neg.id
        }
      ]

      iap_config = {
        enable               = false
      }
    }
  }
}