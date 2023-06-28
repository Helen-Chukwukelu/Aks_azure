variable "redis_tier" {
  default     = "BASIC"
  description = "The service tier of the instance. cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Tier"
}

variable "redis_connect_mode" {
  default     = "PRIVATE_SERVICE_ACCESS"
  description = "The connection mode of the Redis instance. Can be either DIRECT_PEERING or PRIVATE_SERVICE_ACCESS"
}

variable "redis_memory_size_gb" {
  default     = "2"
  description = "Redis memory size in GiB"
}
