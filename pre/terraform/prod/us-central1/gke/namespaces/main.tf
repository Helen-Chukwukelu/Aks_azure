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

  # Add required secrets
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
