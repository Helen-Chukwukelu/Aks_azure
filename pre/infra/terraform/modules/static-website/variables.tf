variable "website_domain_name" {
  description = "The domain name for merchant portal website"
  default     = ""
}

variable dns_managed_zone_name {
  description = " The name of the Cloud DNS Managed Zone in which to create the DNS CNAME Record specified in var.website_domain_name."
  type        = string
}

variable project_id {
  description = "The GCP project ID"
  type        = string
  default     = null
}

variable enable_ssl {
  type    = string
  default = true
}

variable enable_http {
  type    = string
  default = true
}

variable ssl_name {
  type    = string
  default = null
}

variable location {
  type = string
}

variable force_destroy {
  type    = string
  default = true
}

variable not_found_page {
  type    = string
  default = "404.html"
}

variable "labels" {
  default = {}
}
