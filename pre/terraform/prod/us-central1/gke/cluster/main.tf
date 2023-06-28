# ---------------------------------------------------------------------------------------------------------------------
# PUBLIC GKE WITH NODE POOL AND SERVICE ACCOUNT START
# ---------------------------------------------------------------------------------------------------------------------
module "gke_cluster" {
  # Switch to remote URL after https://github.com/gruntwork-io/terraform-google-gke/pull/115 is merged
  # source                       = "gruntwork-io/gke/google//modules/gke-cluster"
  # version                      = "~>0.7.0"
  source                       = "../modules/gke-cluster"
  name                         = "${var.project_name}-gke-${var.environment}-${random_id.this.hex}"
  project                      = var.project_id
  location                     = var.region
  network                      = module.vpc.network
  subnetwork                   = module.vpc.public_subnetwork
  cluster_secondary_range_name = module.vpc.public_subnetwork_secondary_range_name

  enable_vertical_pod_autoscaling = var.enable_vertical_pod_autoscaling
  enable_workload_identity        = var.enable_workload_identity
  release_channel                 = var.gke_release_channel
}

#------------------------------
# NODE POOL
#------------------------------
module "gke_node_pool" {
  source     = "../modules/gke-node-pool"
  project_id = var.project_id
  name       = "${local.project}-gke-nodepool-${var.environment}"
  cluster    = module.gke_cluster.name
  location   = var.region

  initial_node_count = "1"
  min_node_count     = "0"
  max_node_count     = "2"

  image_type   = "COS"
  machine_type = var.machine_type
  disk_type    = var.gke_node_pool_disk_type

  oauth_scopes = var.gke_node_pool_oauth_scopes
  tags         = var.gke_node_pool_tags
  labels = {
    all-pools     = "true"
    gitlab-runner = "true"
  }

  depends_on = [module.gke_cluster]
}

# ---------------------------------------------------------------------------------------------------------------------
# PUBLIC GKE WITH NODE POOL AND SERVICE ACCOUNT END
# ---------------------------------------------------------------------------------------------------------------------
