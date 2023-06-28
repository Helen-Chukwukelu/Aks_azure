variable "website_domain_name" {
  description = "The domain name for merchant portal website"
  default     = "retailer.optty.com"
}

variable "merchant_portal_ssl_name" {
  description = "The domain name for merchant portal website"
  default     = "merchant-portal-ssl"
}

variable "static_website_domain_name" {
  description = "The domain name for merchant portal website"
  default     = "widgets.optty.com"
}

variable "dns_managed_zone_name" {
  type    = string
  default = "optty-app-prod"
}

variable "static_website_ssl_name" {
  description = "The domain name for merchant portal website"
  default     = "static-website-ssl"
}

variable "static_website_enable_ssl" {
  type    = string
  default = "true"
}

variable "static_website_enable_http" {
  type    = string
  default = "false"
}

variable "static_website_force_destroy" {
  type    = string
  default = "true"
}

variable "static_website_not_found_page" {
  type    = string
  default = "index.html"
}
