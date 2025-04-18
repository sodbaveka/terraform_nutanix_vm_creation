terraform {
  required_providers {
    nutanix = {
      source = "nutanix/nutanix"
      version = "2.1.1"
    }
  }
}

provider "nutanix" {
  username     = var.nutanix_username
  password     = var.nutanix_password
  endpoint     = var.nutanix_endpoint
  #port         = var.nutanix_port
  insecure     = true
  wait_timeout = 10
}