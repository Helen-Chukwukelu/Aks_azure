# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

data "google_sql_database_instance" "default" {
  name    = var.postgres_instance
  project = var.project_id
}

data "google_container_cluster" "gke_cluster" {
  name     = var.gke_cluster
  location = var.region
}

data "google_redis_instance" "default" {
  name = var.redis_name
}
