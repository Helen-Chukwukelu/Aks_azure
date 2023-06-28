variable "website_domain_name" {
  description = "The domain name for merchant portal website"
  default     = "retailer.optty.com"
}

variable "merchant_portal_ssl_name" {
  description = "The domain name for merchant portal website"
  default     = "merchant-portal-ssl"
}

variable "widgets_domain_name" {
  description = "The domain name for merchant portal website"
  default     = "widgets.optty.com"
}

variable "dns_managed_zone_name" {
  type    = string
  default = "optty-app-prod"
}

variable "widgets_ssl_name" {
  description = "The domain name for merchant portal website"
  default     = "magento-widgets-ssl"
}

variable enable_ssl {
  type    = string
  default = "true"
}

variable enable_http {
  type    = string
  default = "false"
}

variable force_destroy {
  type    = string
  default = "true"
}

variable not_found_page {
  type    = string
  default = "index.html"
}
