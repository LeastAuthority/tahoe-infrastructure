# The domain could be fully defined as code,
# but this could exposed some PII in this repo
# resource "gandi_domain" "tl-org" {
#   name = "tahoe-lafs.org"
#   owner {
#     city            = "Gotham"
#     country         = "US"
#     data_obfuscated = true
#     email           = "contact@example.com"
#     extra_parameters = {
#       birth_city       = ""
#       birth_country    = ""
#       birth_date       = ""
#       birth_department = ""
#     }
#     organisation    = "Tahoe-LAFS"
#     family_name     = "LAFS"
#     given_name      = "Tahoe"
#     mail_obfuscated = true
#     phone           = "+31.234567890"
#     street_addr     = "The place to be, 1"
#     type            = "association"
#     zip             = "12345"
# }

# Accessing domain data
data "gandi_domain" "tl-org" {
  name = "tahoe-lafs.org"
}

# Managing DNS zone
# Imported using `tofu import gandi_livedns_domain.tl-org tahoe-lafs.org`
resource "gandi_livedns_domain" "tl-org" {
  name = data.gandi_domain.tl-org.name
  timeouts {
    default = "10800s"
  }
}

# Managing the NS records of the zone
# Imported using `tofu import gandi_nameservers.tl-org "tahoe-lafs.org"`
resource "gandi_nameservers" "tl-org" {
  domain      = data.gandi_domain.tl-org.name
  nameservers = data.gandi_domain.tl-org.nameservers
}

# Managing other records of the zone
# The main A record for the domain
# Imported using `tofu import gandi_livedns_record.tl-org_A "tahoe-lafs.org/@/A"`
resource "gandi_livedns_record" "tl-org_A" {
  name = "@"
  type = "A"
  values = [
    "74.207.252.227"
  ]
  ttl  = 10800
  zone = data.gandi_domain.tl-org.name
}

# The MX record for the domain
# Imported using `tofu import gandi_livedns_record.tl-org_MX "tahoe-lafs.org/@/MX"`
resource "gandi_livedns_record" "tl-org_MX" {
  name = "@"
  type = "MX"
  values = [
    "50 tahoe-lafs.org."
  ]
  ttl  = 10800
  zone = data.gandi_domain.tl-org.name
}

# The www record for the domain
# Imported using `tofu import gandi_livedns_record.tl-org_www "tahoe-lafs.org/www/CAME"`
resource "gandi_livedns_record" "tl-org_www" {
  name = "www"
  type = "CNAME"
  values = [
    "tahoe-lafs.org."
  ]
  ttl  = 10800
  zone = data.gandi_domain.tl-org.name
}
