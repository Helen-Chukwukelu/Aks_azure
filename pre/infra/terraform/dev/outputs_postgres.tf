output "postgres_instance_name" {
  value       = module.postgres.instance_name
  description = "The instance name for the master instance"
}

output "postgres_connection_name" {
  value       = module.postgres.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "postgres_private_ip_address" {
  value = module.postgres.private_ip_address
}

output "postgres_user" {
  value = local.db_user_name
}

# output "postgres_user_password" {
#   value = module.postgres.generated_user_password
# }

output "postgres_databases" {
  value = concat([local.db_name], [for i in local.additional_databases : i.name])
}
