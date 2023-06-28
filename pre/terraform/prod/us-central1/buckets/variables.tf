variable "project_id" {
  type = string
}

variable "credentials" {
  description = "Path to service account file(.json)"
  type        = string
}

variable "location" {
  description = "The location of the Region"
  type        = string
}

variable "region" {
  description = "The GCP Project Region"
  type        = string
}

variable "zones" {
  description = "The GCP Project Region"
  type        = list(string)
}

variable "project_name" {
  type = string
}

variable "environment" {
  description = "Current project environment"
  type        = string
}
