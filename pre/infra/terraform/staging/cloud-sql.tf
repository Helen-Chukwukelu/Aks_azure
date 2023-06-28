resource "google_sql_database" "default" {
  name      = "${var.project_name}-${var.environment}-db-dev"
  project   = var.project_id
  instance  = data.google_sql_database_instance.default.name
  charset   = var.db_charset
  collation = var.db_collation
}

resource "google_sql_database" "ratings" {
  name      = "${var.project_name}-${var.environment}-ratings"
  project   = var.project_id
  instance  = data.google_sql_database_instance.default.name
  charset   = var.db_charset
  collation = var.db_collation
}

resource "random_id" "user_password" {
  keepers = {
    name = data.google_sql_database_instance.default.name
  }

  byte_length = 8
}

resource "google_sql_user" "default" {
  name     = var.db_user_name
  project  = var.project_id
  instance = data.google_sql_database_instance.default.name
  password = random_id.user_password.hex
}
