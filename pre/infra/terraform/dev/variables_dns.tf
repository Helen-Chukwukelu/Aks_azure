variable "dns_zone_name" {
  type    = string
  default = "optty-dot-com-dev"
}

variable "public_dns_zone_old" {
  type    = string
  default = "dev.optty.deimos.co.za"
}

variable "public_dns_zone_staging_old" {
  type    = string
  default = "staging.optty.deimos.co.za"
}

variable "public_dns_zone" {
  type    = string
  default = "dev.optty.com"
}

variable "public_dns_zone_staging" {
  type    = string
  default = "staging.optty.com"
}
