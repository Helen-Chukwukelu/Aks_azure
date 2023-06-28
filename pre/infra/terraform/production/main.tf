locals {
  project  = var.project_name
  vpc_name = "${var.project_name}-vpc-${var.environment}-${random_id.this.hex}-network"

  common_labels = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }

  registry_server  = "eu.gcr.io/${var.project_id}"
  apps_namespace   = "apps"
  pull_secret_name = "optty-pull-secret"
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
# VPC
#------------------------------
# "The Virtual Network for the Optty Applications"
module "vpc" {
  source               = "gruntwork-io/network/google//modules/vpc-network"
  version              = "~>0.6.0"
  name_prefix          = "${var.project_name}-vpc-${var.environment}-${random_id.this.hex}"
  project              = var.project_id
  region               = var.region
  cidr_block           = var.vpc_cidr_block
  secondary_cidr_block = var.vpc_secondary_cidr_block
}

#------------------------------------------------------------------
# Private Service Access for allowing private connections to a VPC
#------------------------------------------------------------------
module "private_vpc_service_access" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version = "~> 4.0.0"

  project_id  = var.project_id
  vpc_network = local.vpc_name

  depends_on = [module.vpc]
}

# ---------------------------------------------------------------------------------------------------------------------
# START GKE AND GKE APPLICATIONS SETUP
# ---------------------------------------------------------------------------------------------------------------------

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
  #  namespace_annotations = {
  #    "linkerd.io/inject"                     = "enabled"
  #    "config.linkerd.io/skip-outbound-ports" = "4222,3306,6379" #nats, mysql and redis
  #  }
  namespace_labels = {
    "argocd.argoproj.io/instance" = "namespaces" # Allow Argocd admit it without destruction
  }

  secret_data = {
    "postgres-user"     = local.db_user_name
    "postgres-password" = module.postgres.generated_user_password
    "postgres-host"     = module.postgres.private_ip_address
    "postgres-database" = local.db_name
    "ratings-database"  = local.ratings_db_name
    "redis-host"        = module.redis.host
    "dns_solver.json"   = module.dns_solver_sa.key
  }

  pull_secret_name     = "${var.project_name}-pull-secret"
  pull_secret_registry = local.registry_server
  pull_secret          = module.gcr_reader_sa.key
  depends_on           = [module.gke_cluster]
}

#-------------------------------------
# WORKLOAD IDENTITY FOR SECRET MANAGER
#-------------------------------------
module "workload_identity" {
  count                           = length(var.workload_identity_config)
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version                         = "~>12.1.0"
  project_id                      = var.project_id
  name                            = "svc-gke-${var.workload_identity_config[count.index]["name"]}-${var.environment}"
  namespace                       = var.workload_identity_config[count.index]["namespace"]
  roles                           = var.workload_identity_config[count.index]["roles"]
  automount_service_account_token = true

  depends_on = [module.gke_cluster, module.apps_namespace_setup]
}

#----------------------------------------------------------------------------------------------------------------------
# GITLAB RUNNER START
#----------------------------------------------------------------------------------------------------------------------
module "gitlab_runner" {
  source                    = "../modules/gitlab-runner"
  release_name              = "${var.project_name}-runner-${var.environment}"
  runner_tags               = var.runner_tags
  runner_registration_token = var.runner_registration_token
  default_runner_image      = var.default_runner_image

  depends_on = [module.gke_cluster]
}

#----------------------------------
# EXTERNAL DNS
#----------------------------------
module "external_dns" {
  source               = "../modules/external_dns"
  namespace            = var.internal_system_namespace
  domain_filters       = [module.dns_public_zone.domain]
  project_id           = var.project_id
  cloudflare_api_token = var.cloudflare_api_token
  dns_provider         = "cloudflare"

  depends_on = [module.gke_cluster]
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

#------------------------------------
# PUBLIC DNS ZONE
#-------------------------------------
module "dns_public_zone" {
  source     = "terraform-google-modules/cloud-dns/google"
  version    = "~>3.0.2"
  project_id = var.project_id
  type       = "public"
  name       = var.dns_public_zone_name
  domain     = "${var.dns_public_zone_domain}."
}



#------------------------------------
# STATIC WEBSITES START
#-------------------------------------

#------------------------------------
# MERCHANT PORTAL
#-------------------------------------
module "merchant_portal_static_website" {
  source                = "../modules/static-website"
  website_domain_name   = var.website_domain_name
  location              = var.location
  enable_ssl            = var.enable_ssl
  enable_http           = var.enable_http
  ssl_name              = var.merchant_portal_ssl_name
  dns_managed_zone_name = module.dns_public_zone.name
  force_destroy         = var.force_destroy
  not_found_page        = var.not_found_page
  labels                = local.common_labels
}

#------------------------------------
# MAGENTO WIDGETS
#-------------------------------------
module "widgets_static_website" {
  source                = "../modules/static-website"
  website_domain_name   = var.widgets_domain_name
  location              = var.location
  enable_ssl            = var.enable_ssl
  enable_http           = var.enable_http
  ssl_name              = var.widgets_ssl_name
  dns_managed_zone_name = module.dns_public_zone.name
  force_destroy         = var.force_destroy
  not_found_page        = var.not_found_page
  labels                = local.common_labels
}

#------------------------------------
# STATIC WEBSITES END
#-------------------------------------



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

  depends_on = [module.private_vpc_service_access.peering_completed, module.vpc]
}


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


#------------------------------
# Private: Cloud DNS
#------------------------------
module "private_dns_zone" {
  source = "terraform-google-modules/cloud-dns/google"
  #  version = "3.0.0"
  project_id = var.project_id
  type       = "private"
  name       = "${var.project_name}-private-dns-${var.environment}"
  domain     = var.private_dns

  private_visibility_config_networks = [
    module.vpc.network
  ]

  recordsets = [
    {
      name = module.postgres.instance_name
      type = "A"
      ttl  = 300
      records = [
        module.postgres.private_ip_address,
      ]
    },
    {
      name = "redis"
      type = "A"
      ttl  = 300
      records = [
        module.redis.host,
      ]
    },
  ]
}


#------------------------------
# HELM Google Cloud Storage
#------------------------------
module "gcs_buckets" {
  source = "terraform-google-modules/cloud-storage/google"
  #  version       = "~> 1.6"
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


#------------------------------
# Ensure GCR Bucket Exists
#------------------------------
module "gcr" {
  source   = "../modules/gcr"
  project  = var.project_id
  location = var.location
}

#----------------------------------------------------------------------------------------------------------------------
# APPS NAMESPACE AND SECRETS TO BE AUTOMATICALLY POPULATED BY MODULE OUTPUT START
#----------------------------------------------------------------------------------------------------------------------

module "gcr_reader_sa" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0.1"
  description   = "Service Account Used by Kubernetes for Read Registry Access (Managed By Terraform)"
  display_name  = "Terraform Managed GCR Reader Service Account"
  generate_keys = true
  project_id    = var.project_id
  prefix        = "${var.project_name}-gcr-sa-${var.environment}"
  names         = ["gcr"]
  project_roles = [
    "${var.project_id}=>roles/storage.objectViewer",
    "${var.project_id}=>roles/storage.admin",
    "${var.project_id}=>roles/container.developer",
    "${var.project_id}=>roles/container.admin",
  ]
}

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

# Cloud Armor and WAF Rules
module "cloud-armor" {
  source = "../modules/cloud-armor"
}


# Big Query connection to the merchant api database via the
# read replicas. Used for running Federated Queries
module "bq-connection-merchant-api" {
  source                 = "../modules/big-query-connection"
  location               = var.region
  instance_id            = module.postgres.instance_connection_name
  database_name          = local.db_name
  database_type          = "POSTGRES"
  database_user          = local.db_user_name
  database_user_password = module.postgres.generated_user_password
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

##--------------------------------------
## BASTION CONFIGURATION
## INSTANCE TEMPLATE & BASTION MODULE
##---------------------------------------
#module "instance_template" {
#  source               = "terraform-google-modules/vm/google//modules/instance_template"
#  version              = "~>6.0.0"
#  region               = var.region
#  project_id           = var.project_id
#  network              = module.vpc.network
#  subnetwork           = module.vpc.public_subnetwork
#  service_account      = var.bastion_service_account
#  source_image_family  = var.image_family
#  source_image_project = var.source_image_project
#  disk_size_gb         = var.bastion_disk_size_gb
#  tags                 = ["public"]
#  can_ip_forward       = "false"
#  labels               = local.common_labels
#}

#module "bastion" {
#  source            = "terraform-google-modules/vm/google//modules/compute_instance"
#  version           = "~>6.0.0"
#  region            = var.region
#  network           = module.vpc.network
#  subnetwork        = module.vpc.public_subnetwork
#  num_instances     = var.num_instances
#  hostname          = "${var.project_id}-bastion-${var.environment}-${random_id.this.hex}"
#  instance_template = module.instance_template.self_link

#  access_config = [{
#    nat_ip       = var.nat_ip
#    network_tier = var.network_tier
#  }, ]
#}
