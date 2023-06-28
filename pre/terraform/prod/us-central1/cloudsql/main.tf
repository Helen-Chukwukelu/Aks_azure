#------------------------------
# PostgreSQL: Cloud SQL
#------------------------------
module "postgres" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 4.0.0"

  name                 = "${var.environment}-${var.project_name}-postgres"
  project_id           = var.project_id
  region               = var.region
  zone                 = "b"
  db_name              = local.db_name
  additional_databases = local.additional_databases
  database_version     = var.database_version
  user_name            = local.db_user_name
  tier                 = var.database_tier
  create_timeout       = "25m"
  availability_type    = var.database_availability

  read_replicas = local.read_replicas

  backup_configuration = {
    enabled                        = var.database_backup_enabled
    start_time                     = var.database_backup_start_time
    location                       = null
    point_in_time_recovery_enabled = null
  }

  ip_configuration = local.postgres_ip_configuration

  user_labels = local.common_labels


  depends_on = [module.private_vpc_service_access.peering_completed, module.vpc]
}
