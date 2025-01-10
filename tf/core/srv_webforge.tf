# System name: webforge
# Main FQDN: webforge.tahoe-lafs.org
# Provider: Hetzner
# OS: NixOS
# Description: Web-based collaborative version control server for Tahoe-LAFS
resource "hcloud_server" "webforge" {
  name        = "webforge"
  server_type = "cx32"
  image       = "debian-12"
  location    = "hel1"
  backups     = true
  labels = {
    "env" : "prod"
    "source" : "tf-tahoe-lafs-core"
  }
  ssh_keys    = [for k, v in local.ssh_keys : "tf-${v.name}"]
  user_data   = <<EOF
#cloud-config

runcmd:
  - curl https://raw.githubusercontent.com/elitak/nixos-infect/5ef3f953d32ab92405b280615718e0b80da2ebe6/nixos-infect | PROVIDER=hetznercloud NIX_CHANNEL=nixos-24.11 bash 2>&1 | tee /tmp/infect.log
EOF
  # Wait for the ssh key(s)
  depends_on = [
     hcloud_ssh_key.ssh_keys
  ]
  lifecycle {
    ignore_changes = [
      # Ignore changes to ssh_keys post installation
      ssh_keys,
    ]
  }
}

# System PTR records
resource "hcloud_rdns" "webforge_ipv4" {
  server_id  = hcloud_server.webforge.id
  ip_address = hcloud_server.webforge.ipv4_address
  dns_ptr    = "${hcloud_server.webforge.name}.${data.gandi_domain.tl-org.name}"
}

resource "hcloud_rdns" "webforge_ipv6" {
  server_id  = hcloud_server.webforge.id
  ip_address = hcloud_server.webforge.ipv6_address
  dns_ptr    = "${hcloud_server.webforge.name}.${data.gandi_domain.tl-org.name}"
}

# System A and AAAA records
resource "gandi_livedns_record" "webforge_ipv4" {
  name = "${hcloud_server.webforge.name}"
  type = "A"
  values = [
    hcloud_server.webforge.ipv4_address
  ]
  ttl  = 3600
  zone = data.gandi_domain.tl-org.name
}

resource "gandi_livedns_record" "webforge_ipv6" {
  name = "${hcloud_server.webforge.name}"
  type = "AAAA"
  values = [
    hcloud_server.webforge.ipv6_address
  ]
  ttl  = 3600
  zone = data.gandi_domain.tl-org.name
}

# Functional CNAMES records
resource "gandi_livedns_record" "webforge_aliases" {
  for_each = toset(["forge", "preview", "live"])

  name = each.value
  type = "CNAME"
  values = [
    "${hcloud_server.webforge.name}.${data.gandi_domain.tl-org.name}."
  ]
  ttl  = 3600
  zone = data.gandi_domain.tl-org.name
}
