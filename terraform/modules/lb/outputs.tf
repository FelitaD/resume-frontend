output "lb_ip_address" {
  value = google_compute_global_address.resume-lb-ip.address
  description = "The IP address of the load balancer"
}