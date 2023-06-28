terraform {
  required_version = "~> 0.14.0"

  required_providers {
    google      = "~>3.40"
    google-beta = "~>3.40"
    helm        = "~> 1.3"
    kubernetes  = "~> 1.13"
  }
}

provider "google" {
  region = var.region
  #   zone    = var.zones
  project     = var.project_id
  credentials = file(var.credentials)
}

provider "google-beta" {
  region = var.region
  #   zone        = var.zones
  project     = var.project_id
  credentials = file(var.credentials)
}

provider "kubernetes" {
  load_config_file       = false
  host                   = module.gke_cluster.endpoint
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = module.gke_cluster.endpoint
    token                  = data.google_client_config.provider.access_token
    load_config_file       = false
    cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
  }
}
