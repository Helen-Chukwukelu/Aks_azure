output "redis_host" {
  value       = module.redis.host
  description = "The IP address of the instance."
}

output "redis_dns" {
  description = "The Private Assigned DNS Record to The redis instance"
  value       = "redis.${module.private_dns_zone.domain}"
}
