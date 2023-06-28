resource "random_id" "this" {
  byte_length = "8"
}

locals {
  buckets = [
    "helm",
    "static-media"
  ]
}
#------------------------------
# HELM Google Cloud Storage
#------------------------------
module "gcs_buckets" {
  source = "terraform-google-modules/cloud-storage/google"
  #  version       = "~> 1.6"
  project_id    = var.project_id
  location      = var.region
  storage_class = "STANDARD"
  names         = local.buckets
  prefix        = "${var.project_name}-gcs-${var.environment}"

  force_destroy = {
    "helm"         = true
    "static-media" = true
  }
  versioning = {
    "helm"         = true
    "static-media" = true
  }
  bucket_viewers = {
    "static-media" = "allUsers"
  }
  labels = local.default_labels
}
