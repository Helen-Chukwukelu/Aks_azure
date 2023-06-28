# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

# data.google_compute_network.main.self_link

data "google_container_cluster" "my_cluster" {
  name     = module.gke_cluster.name
  location = var.region
}