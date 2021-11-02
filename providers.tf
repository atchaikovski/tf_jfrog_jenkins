terraform {
  required_version = "~> 1.0.3"

  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.5.3"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
}