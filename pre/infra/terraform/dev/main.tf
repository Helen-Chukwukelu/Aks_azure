locals {
  project  = var.project_name
  vpc_name = "${var.project_name}-vpc-${var.environment}-network"

  common_labels = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }

  registry_server    = "eu.gcr.io/${var.project_id}"
  apps_namespace     = "apps"
  internal_namespace = "internal-system"
  pull_secret_name   = "${var.project_name}-pull-secret"


}

resource "random_id" "this" {
  byte_length = "8"
}

#------------------------------
# Remote State Locking
#------------------------------
module "remote_state" {
  source              = "../modules/remote-state-gcp"
  name_prefix         = "${var.project_name}-tfstate-${var.environment}"
  location            = var.region
  project_id          = var.project_id
  backend_output_path = "${path.module}/backend.tf"

  labels = local.common_labels
}

#------------------------------
# Ensure GCR Bucket Exists
#------------------------------
module "gcr" {
  source   = "../modules/gcr"
  project  = var.project_id
  location = var.location
}

#------------------------------------
# PUBLIC DNS ZONE
#-------------------------------------
module "dns_public_zone" {
  source     = "terraform-google-modules/cloud-dns/google"
  version    = "~>3.0.2"
  project_id = var.project_id
  type       = "public"
  name       = var.dns_zone_name
  domain     = "${var.public_dns_zone}."
}


#------------------------------
# VPC
#------------------------------
module "vpc" {
  source               = "gruntwork-io/network/google//modules/vpc-network"
  version              = "~>0.6.0"
  name_prefix          = "${var.project_name}-vpc-${var.environment}"
  project              = var.project_id
  region               = var.region
  cidr_block           = var.vpc_cidr_block
  secondary_cidr_block = var.vpc_secondary_cidr_block
}


#------------------------------------------------------------------
# Private Service Access for allowing private connections to a VPC
#------------------------------------------------------------------
module "private_service_access" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version = "~> 4.5.0"

  project_id  = var.project_id
  vpc_network = local.vpc_name

  depends_on = [module.vpc]
}


# ---------------------------------------------------------------------------------------------------------------------
# START GKE SETUP
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# PUBLIC GKE WITH NODE POOL AND SERVICE ACCOUNT
# ---------------------------------------------------------------------------------------------------------------------
module "gke_cluster" {
  source                       = "gruntwork-io/gke/google//modules/gke-cluster"
  version                      = "~>0.7.0"
  name                         = "${var.project_name}-gke-${var.environment}"
  project                      = var.project_id
  location                     = var.region
  network                      = module.vpc.network
  subnetwork                   = module.vpc.public_subnetwork
  cluster_secondary_range_name = module.vpc.public_subnetwork_secondary_range_name
  # TODO Swap out with Release_channel `regular` once regular releases versions higher or equal to this
  kubernetes_version = "1.18.14-gke.1600"

  alternative_default_service_account = var.override_default_node_pool_service_account ? module.gke_service_account.email : null
  enable_vertical_pod_autoscaling     = var.enable_vertical_pod_autoscaling
  enable_workload_identity            = var.enable_workload_identity
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
  zones      = ["${var.region}-c", "${var.region}-d"]

  initial_node_count = "1"
  min_node_count     = "0"
  max_node_count     = "3"

  machine_type = var.machine_type
  image_type   = var.gke_node_pool_image_type
  disk_type    = var.gke_node_pool_disk_type

  service_account = module.gke_service_account.email
  oauth_scopes    = var.gke_node_pool_oauth_scopes
  tags            = var.gke_node_pool_tags

  labels = local.common_labels
}

// To properly use the docker cache for inter-stage build jobs, all CI-jobs should be executed on
// a specific node. Where all docker caches are stored to prevent issues with jobs not finding images
// because images are on a separate node
module "gke_node_pool_gitlab" {
  source     = "../modules/gke-node-pool"
  project_id = var.project_id
  name       = substr("${local.project}-gke-nodepool-gitlab-${var.environment}-${random_id.this.hex}", 0, 39)
  cluster    = module.gke_cluster.name
  location   = var.region
  zones      = ["${var.region}-b"]

  initial_node_count = "1"
  min_node_count     = "0"
  max_node_count     = "1"

  machine_type = var.runner_machine_type
  image_type   = var.gke_node_pool_image_type
  disk_type    = var.gke_node_pool_disk_type

  service_account = module.gke_service_account.email
  oauth_scopes    = var.gke_node_pool_oauth_scopes
  tags            = var.gke_node_pool_tags

  labels = merge(local.common_labels, {
    gitlab-runner = "true"
  })
}

// This node Pool is used solely for testing. Only Locus pods should be scheduled on the pod, that means when not in used, it should scale down to 0.
module "gke_node_pool_locust_load_test" {
  source     = "../modules/gke-node-pool"
  project_id = var.project_id
  name       = substr("${local.project}-nodepool-locust-${var.environment}-${random_id.this.hex}", 0, 39)
  location   = var.region
  cluster    = module.gke_cluster.name

  initial_node_count = "0"
  min_node_count     = "0"
  max_node_count     = "3" # Setting this to 3. The region consist of 3 Zones, thus it'll scale to 9 nodes with 3 in each zone

  machine_type = "n1-standard-4"
  image_type   = var.gke_node_pool_image_type
  disk_size_gb = "10"

  service_account = module.gke_service_account.email
  oauth_scopes    = var.gke_node_pool_oauth_scopes
  tags            = var.gke_node_pool_tags
  taints = [{
    key    = "locust"
    value  = "enabled"
    effect = "NO_SCHEDULE"
  }]

  labels = merge(local.common_labels, {
    kind = "locust-pool"
  })
}

#------------------------------
# SERVICE ACCOUNTS
#------------------------------
module "gke_service_account" {
  source                = "gruntwork-io/gke/google//modules/gke-service-account"
  version               = "~>0.6.0"
  name                  = "${local.project}-gke-${var.environment}"
  project               = var.project_id
  service_account_roles = var.service_account_roles
  description           = var.cluster_service_account_description
}

#------------------------------
# ARGOCD
#------------------------------
module "argocd" {
  source       = "../modules/terraform-argocd"
  repositories = local.argocd_repositories
  manifests    = [local.gitops_manifest_link]

  depends_on = [module.gke_cluster]
}

# Service account for DNS access
module "dns_solver_sa" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0.1"
  description   = "Service Account Used by Cert-Manager for DNS Resolution (Managed By Terraform)"
  display_name  = "Terraform Managed DNS Admin Service Account"
  generate_keys = true
  project_id    = var.project_id
  prefix        = "dns01"
  names         = ["solver"]
  project_roles = [
    "${var.project_id}=>roles/dns.admin",
  ]
}

#----------------------------------------------------------------------------------------------------------------------
# GITLAB RUNNER START
#----------------------------------------------------------------------------------------------------------------------
module "gitlab_runner" {
  source                    = "../modules/gitlab-runner"
  release_name              = "${var.project_name}-runner-${var.environment}"
  runner_tags               = var.runner_tags
  runner_registration_token = data.google_secret_manager_secret_version.runner_registration_token.secret_data
  default_runner_image      = var.default_runner_image

  depends_on = [module.gke_cluster]
}

# module "gitlab_runner_service_account" {
#   source       = "terraform-google-modules/service-accounts/google"
#   version      = "~> 3.0.1"
#   description  = "Service Account Used by Gitlab Runner for Registry Access (Managed By Terraform)"
#   display_name = "Terraform Managed Gitlab-Runner Service Account"
#   project_id   = var.project_id
#   prefix       = "${var.project_name}-sa-${var.environment}"
#   names        = ["gitlab-runner"]
#   project_roles = [
#     "${var.project_id}=>roles/storage.admin",
#     "${var.project_id}=>roles/container.developer",
#   ]
# }


#----------------------------------------------------------------------------------------------------------------------
#   Service Account with read Access to GCR
#----------------------------------------------------------------------------------------------------------------------
module "gcr_reader_service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0.1"
  description   = "Service Account Used by Kubernetes for Read Registry Access (Managed By Terraform)"
  display_name  = "Terraform Managed GCR Reader Service Account"
  generate_keys = true
  project_id    = var.project_id
  prefix        = "${var.project_name}-svca-${var.environment}"
  names         = ["gcr-reader"]
  project_roles = [
    "${var.project_id}=>roles/storage.objectViewer",
    "${var.project_id}=>roles/storage.admin",
    "${var.project_id}=>roles/container.developer",
    "${var.project_id}=>roles/container.admin",

  ]
}

#------------------------------------------------------------
# Sets Up Apps namespace where services will be deployed
# Creates:
# - `Apps` namespace
# - Adds Linkerd annotations to the apps namespace
# - Creates Pull secret using service account with access to GCR
# - Creates Secrets containing Postgres and Redis Credentials
#------------------------------------------------------------
module "apps_namespace_setup" {
  source = "../modules/terraform-kubernetes-namespace-setup"
  labels = local.common_labels

  namespace = local.apps_namespace
  namespace_labels = {
    "argocd.argoproj.io/instance" = "argocd-applications" # Allow Argocd admit it without destruction
  }
  namespace_annotations = {
    # "linkerd.io/inject"                     = "enabled"
    "config.linkerd.io/skip-outbound-ports" = "4222,3306,6379" #nats, mysql and redis
  }

  secret_data = {
    "postgres-user"      = local.db_user_name
    "postgres-password"  = module.postgres.generated_user_password
    "postgres-host"      = module.postgres.private_ip_address
    "postgres-database"  = local.db_name
    "ratings-database"   = local.ratings_db_name
    "redis-host"         = module.redis.host
    "dns_solver.json"    = module.dns_solver_sa.key
    "elastic_apm_secret" = data.google_secret_manager_secret_version.elastic_apm_secret.secret_data
  }

  pull_secret_name     = "${var.project_name}-pull-secret"
  pull_secret_registry = local.registry_server
  pull_secret          = module.gcr_reader_service_account.key
  depends_on           = [module.gke_cluster]
}


#----------------------------------
# EXTERNAL DNS
#----------------------------------
module "external_dns" {
  source    = "../modules/external_dns"
  namespace = var.internal_system_namespace
  domain_filters = [
    var.public_dns_zone,
    var.public_dns_zone_staging,
    var.public_dns_zone_old,
    var.public_dns_zone_staging_old
  ]

  project_id             = var.project_id
  service_account        = "svc-gke-external-dns-${var.environment}"
  create_service_account = false

  depends_on = [module.gke_cluster, module.workload_identity]
}

#------------------------------
# WORKLOAD IDENTITY
#------------------------------
module "workload_identity" {
  count                           = length(var.workload_identity_config)
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version                         = "~>12.1.0"
  project_id                      = var.project_id
  cluster_name                    = module.gke_cluster.name
  location                        = var.region
  name                            = ! lookup(var.workload_identity_config[count.index], "use_existing_k8s_sa", false) ? "svc-gke-${var.workload_identity_config[count.index]["name"]}-${var.environment}" : var.workload_identity_config[count.index]["name"]
  namespace                       = var.workload_identity_config[count.index]["namespace"]
  roles                           = var.workload_identity_config[count.index]["roles"]
  use_existing_k8s_sa             = lookup(var.workload_identity_config[count.index], "use_existing_k8s_sa", false)
  automount_service_account_token = true

  # depends_on = [module.apps_namespace_setup]
}

# ---------------------------------------------------------------------------------------------------------------------
# END GKE SETUP
# ---------------------------------------------------------------------------------------------------------------------




#------------------------------------------------------------
# PostgreSQL: Cloud SQL
#
# it creates both staging and dev databases
#------------------------------------------------------------
module "postgres" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 4.5.0"

  name                 = "${var.environment}-${var.project_name}-postgres"
  project_id           = var.project_id
  region               = var.region
  zone                 = "${var.region}-b"
  db_name              = local.db_name
  additional_databases = local.additional_databases
  database_version     = var.database_version
  user_name            = local.db_user_name
  tier                 = var.database_tier
  create_timeout       = "25m"
  availability_type    = var.database_availability
  ip_configuration     = local.postgres_ip_configuration

  user_labels = local.common_labels


  depends_on = [module.private_service_access.peering_completed, module.vpc]
}


#------------------------------
# Redis: Memory Store
#------------------------------
module "redis" {
  source  = "terraform-google-modules/memorystore/google"
  version = "~> 1.3.0"

  name               = "${var.project_name}-memory-store-${var.environment}-${random_id.this.hex}"
  project            = var.project_id
  tier               = var.redis_tier
  connect_mode       = var.redis_connect_mode
  authorized_network = local.vpc_name
  memory_size_gb     = var.redis_memory_size_gb

  labels = local.common_labels

  depends_on = [module.private_service_access.peering_completed, module.vpc]
}



#------------------------------
# Google Cloud Storage
#------------------------------
module "gcs_buckets" {
  source        = "terraform-google-modules/cloud-storage/google"
  version       = "~> 1.7.2"
  project_id    = var.project_id
  location      = var.region
  storage_class = "STANDARD"
  names         = ["helm-${random_id.this.hex}", "static-media-${random_id.this.hex}"]
  prefix        = "${var.project_name}-gcs-${var.environment}"

  force_destroy = {
    "helm-${random_id.this.hex}"         = true
    "static-media-${random_id.this.hex}" = true
  }
  versioning = {
    "helm-${random_id.this.hex}"         = true
    "static-media-${random_id.this.hex}" = true
  }
  bucket_viewers = {
    "static-media-${random_id.this.hex}" = "allUsers"
  }
  labels = local.common_labels
}


#------------------------------------
# START STATIC WEBSITES SETUP
#-------------------------------------


#------------------------------------
# MERCHANT PORTAL STATIC WEBSITE
#-------------------------------------
module "merchant_portal_static_website" {
  source                = "../modules/static-website"
  website_domain_name   = var.merchant_portal_domain_name
  location              = var.location
  enable_ssl            = var.enable_ssl
  enable_http           = var.enable_http
  ssl_name              = var.merchant_portal_ssl_name
  dns_managed_zone_name = module.dns_public_zone.name
  force_destroy         = var.static_website_force_destroy
  not_found_page        = var.not_found_page
  labels                = local.common_labels
}

#------------------------------------
# MAGENTO WIDGETS STATIC WEBSITE
#-------------------------------------
module "widgets_static_website" {
  source                = "../modules/static-website"
  website_domain_name   = var.widgets_domain_name
  location              = var.location
  enable_ssl            = var.enable_ssl
  enable_http           = var.enable_http
  ssl_name              = var.widgets_ssl_name
  dns_managed_zone_name = module.dns_public_zone.name
  force_destroy         = var.static_website_force_destroy
  not_found_page        = var.not_found_page
  labels                = local.common_labels
}

#------------------------------------
# START STATIC WEBSITES SETUP
#-------------------------------------



#--------------------------------------
# BASTION CONFIGURATION
# INSTANCE TEMPLATE & BASTION MODULE
#---------------------------------------
# module "instance_template" {
#   source               = "terraform-google-modules/vm/google"
#   version              = "5.1.0"
#   region               = var.region
#   project_id           = var.project_id
#   network              = module.vpc.network
#   subnetwork           = module.vpc.public_subnetwork
#   service_account      = var.bastion_service_account
#   source_image_family  = var.image_family
#   source_image_project = var.source_image_project
#   disk_size_gb         = var.bastion_disk_size_gb
#   tags                 = ["public"]
#   can_ip_forward       = "false"
# }

# module "bastion" {
#   source            = "terraform-google-modules/vm/google"
#   version           = "5.1.0"
#   region            = var.region
#   network           = module.vpc.network
#   subnetwork        = module.vpc.public_subnetwork
#   num_instances     = var.num_instances
#   hostname          = "${var.project_id}-bastion-${var.environment}-${random_id.this.hex}"
#   instance_template = module.instance_template.self_link

#   access_config = [{
#     nat_ip       = var.nat_ip
#     network_tier = var.network_tier
#   }, ]
# }
#
#

#--------------------------------------
# CLOUD ARMOR
#--------------------------------------
module "cloud-armor" {
  source = "../modules/cloud-armor"
}

#--------------------------------------
# OPEN VPN
#--------------------------------------
module "openvpn" {
  source     = "../modules/terraform-openvpn-gcp"
  region     = var.region
  project_id = var.project_id
  network    = module.vpc.network
  subnetwork = module.vpc.public_subnetwork
  hostname   = "${var.project_id}-openvpn-${var.environment}"
  output_dir = "${path.module}/openvpn"
  tags       = ["public"]
  users      = var.vpn_users
  labels     = local.common_labels
}

#---------------------------------------------------------------------------------------------------
# Sets Up Kube-system namespace by adding sealed-secret keys
# Sealed-Secret Keys are necessary for decoding existing secrets sealed by Sealed-Secret COntroller
#---------------------------------------------------------------------------------------------------
module "sealed_secret_namespace_setup" {
  count  = length(var.sealed_secret_keys)
  source = "../modules/terraform-kubernetes-namespace-setup"
  labels = var.sealed_secret_labels

  namespace        = var.sealed_secret_namespace
  create_namespace = false

  secret_data          = var.sealed_secret_keys[count.index]
  secret_type          = "kubernetes.io/tls"
  secret_generate_name = "sealed-secrets-key-"

  depends_on = [module.gke_cluster]
}


locals {
  secrets = {
    "${var.environment}-ratings-database" = local.ratings_db_name
    "${var.environment}-redis-host"       = module.redis.host
    "${var.environment}-merchant-database" = jsonencode({
      "user"     = local.db_user_name
      "password" = module.postgres.generated_user_password
      "host"     = module.postgres.private_ip_address
      "database" = local.db_name
    })
  }
}
module "google_secrets" {
  for_each = local.secrets
  source   = "../modules/terraform-google-secret"
  id       = each.key
  value    = each.value
  labels   = local.common_labels
}
