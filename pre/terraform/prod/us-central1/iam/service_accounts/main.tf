
module "dns_solver_sa" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0.1"
  description   = "Service Account Used by Cert-Manager for DNS Resolution (Managed By Terraform)"
  display_name  = "Terraform Managed DNS Admin Service Account"
  generate_keys = true
  project_id    = var.project_id
  prefix        = "dns01"
  names         = ["solver"]
  project_roles = [
    "${var.project_id}=>roles/dns.admin",
  ]
}
