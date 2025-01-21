terraform {
  required_version = "~> 1.4"

  required_providers {
    gandi = {
      source  = "go-gandi/gandi"
      version = "= 2.3.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "= 1.45.0"
    }
  }
}

provider "gandi" {
  url                   = var.gandi_url
  personal_access_token = var.gandi_token
}

provider "hcloud" {
  token = var.hcloud_token
}
