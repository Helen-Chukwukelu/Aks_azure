#------------------------------
# Ensure GCR Bucket Exists
#------------------------------
module "gcr" {
  source   = "../modules/gcr"
  project  = var.project_id
  location = var.location
}

module "gcr_reader_sa" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0.1"
  description   = "Service Account Used by Kubernetes for Read Registry Access (Managed By Terraform)"
  display_name  = "Terraform Managed GCR Reader Service Account"
  generate_keys = true
  project_id    = var.project_id
  prefix        = "${var.project_name}-gcr-sa-${var.environment}"
  names         = ["gcr"]
  project_roles = [
    "${var.project_id}=>roles/storage.objectViewer",
    "${var.project_id}=>roles/storage.admin",
    "${var.project_id}=>roles/container.developer",
    "${var.project_id}=>roles/container.admin",
  ]
}
