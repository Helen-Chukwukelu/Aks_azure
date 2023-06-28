#--------------------------------------
# OPEN VPN
#--------------------------------------
module "openvpn" {
  source     = "../modules/terraform-openvpn-gcp"
  region     = var.region
  project_id = var.project_id
  network    = module.vpc.network
  subnetwork = module.vpc.public_subnetwork
  hostname   = "${var.project_id}-openvpn-${var.environment}"
  output_dir = "${path.module}/openvpn"
  tags       = ["public"]
  users      = var.vpn_users
  labels     = local.common_labels
}
