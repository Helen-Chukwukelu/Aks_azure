variable "roles" {
  description = "The roles to be given to the workload identity"
  type        = list(any)
  default = [
    "roles/secretmanager.admin",
    "roles/container.developer",
    "roles/iam.serviceAccountAdmin"
  ]
}

variable "workload_namespace" {
  description = "The namoespace where the kubernetes service account would be created"
  type        = string
  default     = "default"
}

variable "workload_identity_config" {
  description = "The namespaces to enable Workload Identity For"
  default = [
    {
      name      = "optty-apps"
      namespace = "apps"
      roles = [
        "roles/secretmanager.admin",
        "roles/container.developer",
        "roles/iam.serviceAccountAdmin",
        "roles/storage.admin",
      ],
    },
  ]
}

variable "sealed_secret_keys" {
  type    = list(map(string))
  default = []
}

variable "sealed_secret_labels" {
  type = map(string)
  default = {
    "sealedsecrets.bitnami.com/sealed-secrets-key" = "active"
  }
}

variable "sealed_secret_namespace" {
  type    = string
  default = "kube-system"
}
