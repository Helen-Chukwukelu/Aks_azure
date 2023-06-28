#------------------------------
# ARGOCD
#------------------------------
module "argocd" {
  source       = "DeimosCloud/argocd/kubernetes"
  version      = "~>1.0.0"
  repositories = local.argocd_repositories
  manifests    = [local.gitops_manifest_link]
}


