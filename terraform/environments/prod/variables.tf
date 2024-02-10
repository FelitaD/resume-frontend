variable "project" {}

variable "region" {
  default = "europe-west9"
}

variable "zone" {
  default = "europe-west9-c"
}

variable "service_port_name" {
  default = "lb-port"
}

variable "service_port" {
  default = "443"
}
