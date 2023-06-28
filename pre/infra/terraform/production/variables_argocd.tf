variable "gitops_access_token" {
  description = "Gitlab Private Token for deploying"
  type        = string
}

variable "gitops_repo" {
  description = "The git repository link for argocd"
  type        = string
  default     = "https://gitlab.com/deimosdev/client-project/optty/infrastructure/gitops.git"
}

variable "argocd_ingress_hostname" {
  description = "The preferred host for the argocd ingress"
  type        = string
  default     = "argocd.prod.optty.deimos.co.za"
}

variable "argocd_ingress_annotations" {
  default = {
    "kubernetes.io/ingress.class"                    = "nginx"
    "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
    "kubernetes.io/tls-acme"                         = "true"
    "cert-manager.io/cluster-issuer"                 = "lets-encrypt-nginx"
    "external-dns.alpha.kubernetes.io/hostname"      = "argocd.prod.optty.deimos.co.za"
    "nginx.ingress.kubernetes.io/backend-protocol"   = "HTTPS"
    # "nginx.ingress.kubernetes.io/ssl-passthrough"    = "true"
  }
  description = "Annotations to be passed to the ArgoCD ingress Controller"
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
