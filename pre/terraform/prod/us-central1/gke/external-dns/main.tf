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
  # service_account        = "svc-gke-external-dns-${var.environment}"
  # dns_provider         = "google"

  depends_on = [module.gke_cluster]
}
