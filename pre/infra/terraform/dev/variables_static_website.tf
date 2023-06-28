
variable "merchant_portal_domain_name" {
  description = "The domain name for merchant portal website"
  default     = "retailer.dev.optty.com"
}

variable "merchant_portal_ssl_name" {
  description = "The domain name for merchant portal website"
  default     = "merchant-portal-ssl"
}
variable "widgets_domain_name" {
  description = "The domain name for merchant portal website"
  default     = "widgets.dev.optty.com"
}

variable "widgets_ssl_name" {
  description = "The domain name for merchant portal website"
  default     = "magento-widgets-ssl"
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
