locals {
  required_providers = {
    helm       = "~> 1.3"
    kubernetes = "~> 1.13"
  }

  providers = <<EOF
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
    cluster_ca_certificate = module.gke_cluster.cluster_ca_certificate
    load_config_file       = false
  }
}
EOF

}
