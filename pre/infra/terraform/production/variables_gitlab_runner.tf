variable runner_registration_token {
  description = "Runner Registartaion Token"
  type        = string
}

variable runner_tags {
  description = "Runner Tags"
  type        = string
  default     = "optty-prod"
}


variable default_runner_image {
  description = "Runner Tags"
  type        = string
  default     = "eu.gcr.io/dcp-enterprise-optty-prod/optty-builder-image"
}
