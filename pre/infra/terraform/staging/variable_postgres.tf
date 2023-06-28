variable "db_name" {
  description = "The name of the default database to create"
  type        = string
  default     = "optty-staging-db-dev"
}

variable "db_charset" {
  description = "The charset for the default database"
  type        = string
  default     = ""
}

variable "db_collation" {
  description = "The collation for the default database. Example: 'en_US.UTF8'"
  type        = string
  default     = ""
}

variable "db_user_name" {
  description = "The name of the user to create"
  type        = string
  default     = "staging-user"
}

variable "postgres_instance" {
  description = "The Name of the existing cloudsql instance"
  default     = "dev-optty-postgres"
}
