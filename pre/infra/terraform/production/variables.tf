variable project_id {
  type    = string
  default = "dcp-enterprise-optty-prod"
}

variable credentials {
  description = "Path to service account file(.json)"
  type        = string
  default     = "sa.json"
}

variable "location" {
  default     = "EU"
  description = "The location of the Region"
}

variable "region" {
  description = "The GCP Project Region"
  default     = "europe-west1"
}

variable "zones" {
  description = "The GCP Project Region"
  default     = ["europe-west1-b", "europe-west1-c"]
  # default     = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
}

variable "project_name" {
  type    = string
  default = "optty"
}

variable "environment" {
  default     = "prod"
  type        = string
  description = "Current project environment"
}

variable "internal_system_namespace" {
  default     = "internal-system"
  type        = string
  description = "The Namespace to deploy internal/devops kubernetes objects to"
}
