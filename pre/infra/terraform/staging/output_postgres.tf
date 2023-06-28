output "postgres_instance_name" {
  value       = data.google_sql_database_instance.default.name
  description = "The instance name for the master instance"
}

output "postgres_connection_name" {
  value       = data.google_sql_database_instance.default.connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "postgres_private_ip_address" {
  value = data.google_sql_database_instance.default.private_ip_address
}

output "postgres_user" {
  value = google_sql_user.default.name
}

output "postgres_user_password" {
  value = google_sql_user.default.password

}

output "postgres_db_name" {
  value = google_sql_database.default.name
}

output "postgres_databases" {
  value = [google_sql_database.default.name, google_sql_database.ratings.name]
}
