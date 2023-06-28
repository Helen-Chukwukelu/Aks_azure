output "dns_name_servers" {
  description = "zone name servers."
  value       = module.dns_public_zone.name_servers
}

output "public_dns_domain" {
  value = module.dns_public_zone.domain
}

output "public_dns_name" {
  value = module.dns_public_zone.name
}
