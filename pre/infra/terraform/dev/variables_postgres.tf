locals {
  db_user_name    = "${var.project_name}-user"
  db_name         = "${var.project_name}-default-db-${var.environment}"
  ratings_db_name = "${var.project_name}-ratings-db-${var.environment}"

  # Additional Databases for Ratings Service
  additional_databases = [
    {
      name      = local.ratings_db_name
      charset   = ""
      collation = ""
    }
  ]

  postgres_ip_configuration = {
    authorized_networks = []
    ipv4_enabled        = var.postgres_assign_public_ip
    private_network     = module.vpc.network
    require_ssl         = var.postgres_require_ssl
  }
}

variable "database_version" {
  description = "the database version to use"
  default     = "POSTGRES_12"
}

variable "database_tier" {
  description = "the tier of the master instance"
  default     = "db-f1-micro"
}

variable "database_availability" {
  description = "The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance"
  default     = "ZONAL"
}

variable "postgres_master_disk_type" {
  description = "The disk type for the master instance."
  default     = "PD_HDD"
}

variable "postgres_assign_public_ip" {
  description = "Set to true if the master instance should also have a public IP (less secure)."
  # Set to true to be able to use BigQuery Federation
  default = true
}

variable "postgres_require_ssl" {
  description = "Set to true if SSL certificates is required to connect to master instance (more secure)."
  default     = false
}
