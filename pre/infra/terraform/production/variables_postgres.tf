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

  # https://cloud.google.com/bigquery/docs/cloud-sql-federated-queries#public_ip
  # Setting authorized to empty after enabling public access to limit attack surface
  postgres_authorized_network = []

  read_replicas = [
    {
      name            = "-1" # Serve as suffix. Fullname: ${master-instance}-replica-${replica-name}
      tier            = var.replica_database_tier
      zone            = var.zones[0]
      disk_type       = null
      disk_autoresize = null
      disk_size       = null
      user_labels     = null
      database_flags  = []
      ip_configuration = {
        authorized_networks = local.postgres_authorized_network
        ipv4_enabled        = var.replica_postgres_assign_public_ip
        private_network     = module.vpc.network
        require_ssl         = var.postgres_require_ssl
      }
    }
  ]

  postgres_ip_configuration = {
    authorized_networks = local.postgres_authorized_network
    ipv4_enabled        = var.postgres_assign_public_ip
    private_network     = module.vpc.network
    require_ssl         = var.postgres_require_ssl
  }
}

variable "database_version" {
  description = "the database version to use"
  default     = "POSTGRES_12"
}

variable "replica_database_tier" {
  description = "the tier of the replica instance"
  default     = "db-f1-micro"
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
  default     = false
}

variable "replica_postgres_assign_public_ip" {
  description = "Set to true if the master instance should also have a public IP (less secure)."
  default     = true
}

variable "postgres_require_ssl" {
  description = "Set to true if SSL certificates is required to connect to master instance (more secure)."
  default     = false
}

variable "database_backup_enabled" {
  description = "True if backup configuration is enabled."
  default     = true
}

variable "database_backup_start_time" {
  description = "HH:MM format time indicating when backup configuration starts."
  default     = "23:00"
}

variable "database_backup_location" {
  default = null
}
