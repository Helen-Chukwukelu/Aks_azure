#------------------------------
# Redis: Memory Store
#------------------------------
module "redis" {
  source  = "terraform-google-modules/memorystore/google"
  version = "~> 1.3.0"

  name               = "${var.project_name}-memory-store-${var.environment}-${random_id.this.hex}"
  project            = var.project_id
  tier               = var.redis_tier
  connect_mode       = var.redis_connect_mode
  authorized_network = local.vpc_name
  memory_size_gb     = var.redis_memory_size_gb

  labels = local.common_labels

  depends_on = [module.private_vpc_service_access.peering_completed, module.vpc]
}
