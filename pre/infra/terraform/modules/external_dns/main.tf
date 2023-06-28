locals {
  provider = var.dns_provider
  values = {
    domainFilters = var.domain_filters
    provider      = local.provider
    txtOwnerId    = "my-identifier"
    policy        = "sync"
    google = {
      project = var.project_id
    }
    cloudflare = {
      apiToken = var.cloudflare_api_token
      proxied  = var.cloudflare_proxied
    }
    serviceAccount = {
      name   = var.service_account
      create = var.create_service_account
    }
  }
}


resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  values           = [yamlencode(local.values)]
}
