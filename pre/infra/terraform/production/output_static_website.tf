output "merchant_portal_website_url" {
  description = "The IP Address of the loadbalancer"
  value       = module.merchant_portal_static_website.website_url
}

output "merchant_portal_bucket" {
  description = "The bucket name for merchant portal"
  value       = module.merchant_portal_static_website.website_bucket_name
}

output "widgets_website_url" {
  description = "The IP Address of the loadbalancer"
  value       = module.widgets_static_website.website_url
}

output "widgets_bucket" {
  description = "The bucket name for Widgets"
  value       = module.widgets_static_website.website_bucket_name
}
