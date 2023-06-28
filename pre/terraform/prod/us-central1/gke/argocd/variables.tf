variable "gitops_access_token" {
  description = "Gitlab Private Token for deploying"
  type        = string
}

variable "gitops_repo" {
  description = "The git repository link for argocd"
  type        = string
  default     = "https://gitlab.com/deimosdev/client-project/optty/infrastructure/gitops.git"
}

locals {
  # TODO
  # Update URL to use Deploy tokens to reduce priviledge given by private tokens
  gitops_manifest_link = "https://gitlab.com/api/v4/projects/21335917/repository/files/production%2Fargocd%2Fargocd.yaml/raw?private_token=${var.gitops_access_token}&ref=master"

  argocd_repositories = [
    {
      url          = var.gitops_repo
      access_token = var.gitops_access_token
    },
  ]
}
