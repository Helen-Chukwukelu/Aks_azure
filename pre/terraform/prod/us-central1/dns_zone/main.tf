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

