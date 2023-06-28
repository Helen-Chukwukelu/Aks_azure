#------------------------------
# VPC
#------------------------------
# "The Virtual Network for the Optty Applications"
module "vpc" {
  source               = "gruntwork-io/network/google//modules/vpc-network"
  version              = "~>0.6.0"
  name_prefix          = "${var.project_name}-vpc-${var.environment}-${random_id.this.hex}"
  project              = var.project_id
  region               = var.region
  cidr_block           = var.vpc_cidr_block
  secondary_cidr_block = var.vpc_secondary_cidr_block
}

#------------------------------------------------------------------
# Private Service Access for allowing private connections to a VPC
#------------------------------------------------------------------
module "private_vpc_service_access" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version = "~> 4.0.0"

  project_id  = var.project_id
  vpc_network = local.vpc_name

  depends_on = [module.vpc]
}
