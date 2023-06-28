locals {
  project = "${var.project_name}"

  common_labels = {
    project     = "${var.project_name}",
    environment = "${var.environment}"
    managed_by  = "terraform"
  }
  registry_server  = "eu.gcr.io/${var.project_id}"
  apps_namespace   = "apps-staging"
  pull_secret_name = "optty-pull-secret"
}

resource "random_id" "this" {
  byte_length = "8"
}
#------------------------------------------------------------
# Sets Up Apps namespace where services will be deployed
# Creates:
# - `Apps` namespace
# - Adds Linkerd annotations to the apps namespace
# - Service Account with read Access to GCR
# - Creates Pull secret using service account
# - Creates Secrets containing Postgres and Redis Credentials
#------------------------------------------------------------
module "gcr_reader_service_account" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0.1"
  description   = "Service Account Used by Kubernetes for Read Registry Access (Managed By Terraform)"
  display_name  = "Terraform Managed GCR Reader Service Account"
  generate_keys = true
  project_id    = var.project_id
  prefix        = "${var.project_name}-svc-${var.environment}"
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
  source    = "../modules/terraform-kubernetes-namespace-setup"
  namespace = local.apps_namespace
  namespace_labels = {
    "argocd.argoproj.io/instance" = "argocd-applications" # Allow Argocd admit it without destruction
  }
  namespace_annotations = {
    # "linkerd.io/inject"                     = "enabled"
    "config.linkerd.io/skip-outbound-ports" = "4222,3306,6379" #nats, mysql and redis
  }
  secret_data = {
    "postgres-database" = google_sql_database.default.name
    "postgres-host"     = data.google_sql_database_instance.default.private_ip_address
    "postgres-password" = google_sql_user.default.password
    "postgres-user"     = google_sql_user.default.name
    "ratings-database"  = google_sql_database.ratings.name
    "redis-host"        = data.google_redis_instance.default.host
  }

  pull_secret_name     = "${var.project_name}-pull-secret"
  pull_secret          = module.gcr_reader_service_account.key
  pull_secret_registry = local.registry_server
  labels               = local.common_labels
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
  domain     = var.public_dns_zone
}

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


#------------------------------
# WORKLOAD IDENTITY
#------------------------------
module "workload_identity" {
  count                           = length(var.workload_identity_config)
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version                         = "~>12.1.0"
  project_id                      = var.project_id
  name                            = "svc-gke-${var.workload_identity_config[count.index]["name"]}-${var.environment}"
  namespace                       = var.workload_identity_config[count.index]["namespace"]
  roles                           = var.workload_identity_config[count.index]["roles"]
  automount_service_account_token = true

  depends_on = [module.apps_namespace_setup]
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
  names         = ["static-media-${random_id.this.hex}"]
  prefix        = "${var.project_name}-gcs-${var.environment}"

  force_destroy = {
    "static-media-${random_id.this.hex}" = true
  }
  versioning = {
    "static-media-${random_id.this.hex}" = true
  }
  labels = local.common_labels
}
