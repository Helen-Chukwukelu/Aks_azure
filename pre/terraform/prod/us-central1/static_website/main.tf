#------------------------------------
# STATIC WEBSITES START
#-------------------------------------

#------------------------------------
# Static Websites
#-------------------------------------
module "static_website" {
  source                = "../modules/terraform-gcp-static-website"
  website_domain_name   = var.static_website_domain_name
  location              = var.location
  enable_ssl            = var.static_website_enable_ssl
  enable_http           = var.static_website_enable_http
  ssl_name              = var.static_website_ssl_name
  dns_managed_zone_name = module.dns_public_zone.name
  force_destroy         = var.static_website_force_destroy
  not_found_page        = var.static_website_not_found_page
  labels                = local.common_labels
}

#------------------------------------
# STATIC WEBSITES END
#-------------------------------------

