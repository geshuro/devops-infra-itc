terraform {
  required_version = ">= 1.0"

  required_providers {
    aws   = "~> 3.63"
    tls   = "~> 3.1"
    local = "~> 2.1"
    null  = "~> 3.1"
  }
}