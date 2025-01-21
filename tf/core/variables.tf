# The API URL and token to interact with Gandi
variable "gandi_url" {
  type = string
}

variable "gandi_token" {
  type = string
}

# The API token to interact with Hetzner Cloud
variable "hcloud_token" {
  type      = string
  sensitive = true
}
