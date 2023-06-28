variable "dns_public_zone_name" {
  description = "The name for the dns public zone"
  type        = string
  default     = "optty-dot-com-prod"
}

variable "dns_public_zone_domain" {
  description = "The domain for the dns public zone, without the trailing period"
  type        = string
  default     = "optty.com"
}

variable "private_dns" {
  description = "The Private DNS Managed Zone to create in Cloud DNS (with the appended period(.))"
  default     = "private.optty.net."
}


variable "cloudflare_api_token" {
  description = "When using the Cloudflare provider, CF_API_TOKEN to set (optional)"
}
