
variable "merchant_portal_domain_name" {
  description = "The domain name for merchant portal website"
  default     = "retailer.staging.optty.com"
}

variable "merchant_portal_ssl_name" {
  description = "The domain name for merchant portal website"
  default     = "retailer-ssl-staging"
}
variable "widgets_domain_name" {
  description = "The domain name for merchant portal website"
  default     = "widgets.staging.optty.com"
}

variable "widgets_ssl_name" {
  description = "The domain name for merchant portal website"
  default     = "widgets-ssl-staging"
}

variable "enable_ssl" {
  type    = string
  default = "true"
}

variable "enable_http" {
  type    = string
  default = "false"
}

variable "static_website_force_destroy" {
  type    = string
  default = "true"
}

variable "not_found_page" {
  type    = string
  default = "index.html"
}
