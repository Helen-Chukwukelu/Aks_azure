variable "domain_filters" {
  type        = list(string)
  description = "List of Domains to watch"
}

variable "project_id" {
  type        = string
  description = "The Google Project ID"
}

variable "namespace" {
  description = "The namespace to deploy the external DNS kubernetes object"
  default     = "default"
}

variable "chart_version" {
  description = "The version of External DNS to install"
  default     = "4.5.1"
}

variable "service_account" {
  default     = "external-dns"
  description = "The service Account to user"
}

variable "create_service_account" {
  default     = true
  description = "Determine whether a Service Account should be created or it should reuse a exiting one."
}

variable "dns_provider" {
  default     = "google"
  description = "DNS provider where the DNS records will be created (Default: google)"
}

variable "cloudflare_api_token" {
  default     = null
  description = "When using the Cloudflare provider, CF_API_TOKEN to set (optional)"
}

variable "cloudflare_proxied" {
  default     = false
  description = "When using the Cloudflare provider, enable the proxy feature (DDOS protection, CDN...) (optional)"
}
