variable vpc_cidr_block {
  description = "The IP address range of the VPC in CIDR notation"
  type        = string
  default     = "10.6.0.0/16"
}
variable vpc_secondary_cidr_block {
  description = "The IP address range of the VPC's secondary address range in CIDR notation"
  type        = string
  default     = "10.7.0.0/16"
}






# locals {
#   subnet1                      = "${var.project_name}-subnet-1-${var.environment}"
#   subnet1_secondary_1_pods     = "${var.project_name}-subnet-1-secondary-1-pods-${var.environment}-${random_id.this.hex}"
#   subnet1_secondary_1_services = "${var.project_name}-subnet-1-secondary-1-services-${var.environment}-${random_id.this.hex}"
#   subnet2                      = "${var.project_name}-subnet-2-${var.environment}"
#   subnet3                      = "${var.project_name}-subnet-3-${var.environment}"

#   subnets = [
#     {
#       # First Subnet for deploying GKE
#       subnet_name   = local.subnet1
#       subnet_ip     = "10.128.0.0/20"
#       subnet_region = var.region
#     },
#     {
#       # Bastion Host is deployed in this subnet
#       subnet_name   = local.subnet2
#       subnet_ip     = "10.132.0.0/20"
#       subnet_region = var.region
#     },
#     {
#       subnet_name   = local.subnet3
#       subnet_ip     = "10.138.0.0/20"
#       subnet_region = var.region
#     }
#   ]

#   secondary_ranges = {
#     # Subnet 1 needs a secondary IP Range, this is required by GKE
#     # https://cloud.google.com/kubernetes-engine/docs/how-to/alias-ips
#     "${local.subnet1}" = [
#       {
#         range_name    = local.subnet1_secondary_1_pods
#         ip_cidr_range = "10.4.0.0/14"
#       },
#       {
#         range_name    = local.subnet1_secondary_1_services
#         ip_cidr_range = "10.8.0.0/20"
#       },
#     ]
#   }
# }
