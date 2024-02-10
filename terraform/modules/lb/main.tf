module "gcs" {
  source = "../gcs"
}

# Google-managed SSL certificate

resource "google_compute_managed_ssl_certificate" "resume-ssl-cert" {
  name = "resume-ssl-cert"

  managed {
    domains = ["felitadonor.com"]
  }
}

# Static IPv4 address

resource "google_compute_global_address" "resume-lb-ip" {
  name = "resume-lb-ip"
}

# Backend bucket

resource "google_compute_backend_bucket" "resume-backend-bucket" {
  name        = "backend-bucket"
  description = "Contains resume website files"
  bucket_name = module.gcs.bucket_name
  enable_cdn  = true
}

# URL map: route HTTPS requests to backend bucket

resource "google_compute_url_map" "resume-urlmap" {
  name        = "resume-urlmap"
  description = "Maps resume website to backend bucket"

  default_service = google_compute_backend_bucket.resume-backend-bucket.id
}

# HTTPS target proxy

resource "google_compute_target_https_proxy" "resume-lb-https-proxy" {
  name             = "resume-lb-https-proxy"
  url_map          = google_compute_url_map.resume-urlmap.id
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
