variable "machine_type" {
  description = "The type of machine to deploy nodes in"
  default     = "n1-standard-4"
}

variable "runner_machine_type" {
  description = "The type of machine to deploy nodes in"
  default     = "n1-standard-4"
}

variable "override_default_node_pool_service_account" {
  description = "When true, this will use the service account that is created for use with the default node pool that comes with all GKE clusters"
  type        = bool
  default     = false
}

variable "enable_vertical_pod_autoscaling" {
  description = "Enable vertical pod autoscaling"
  type        = string
  default     = true
}

variable "cluster_service_account_description" {
  description = "A description of the custom service account used for the GKE cluster."
  type        = string
  default     = "Example GKE Cluster Service Account managed by Terraform"
}

variable "service_account_roles" {
  description = "Additional roles to be added to the service account."
  type        = list(string)
  default     = ["roles/dns.admin"]
}

variable "workload_identity_roles" {
  description = "The roles to be given to the workload identity"
  type        = list(any)
  default = [
    "roles/secretmanager.admin",
    "roles/container.developer",
    "roles/iam.serviceAccountAdmin",
  ]
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
    {
      name      = "external-dns"
      namespace = "internal-system"
      roles     = ["roles/dns.admin"],
    },
    {
      name      = "kubernetes-external-secret"
      namespace = "kube-system"
      roles     = ["roles/secretmanager.secretAccessor"],
    },
    {
      name                = "cert-manager"
      namespace           = "cert-manager"
      use_existing_k8s_sa = true
      roles               = ["roles/dns.admin"],
    },
  ]
}

variable "enable_workload_identity" {
  description = "Enable Workload Identity on the cluster"
  default     = true
  type        = bool
}


variable "gke_release_channel" {
  default     = "STABLE"
  description = "The release channel to fetch upgrades from"
  type        = string
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

variable "gke_node_pool_oauth_scopes" {
  default = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/devstorage.full_control",
    "https://www.googleapis.com/auth/devstorage.read_write",
    "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol"
  ]
}

variable "gke_node_pool_tags" {
  default = [
    "public",
    "public-pool",
  ]
}

variable "gke_node_pool_image_type" {
  default = "COS"
}

variable "gke_node_pool_disk_type" {
  default = "pd-ssd"
}
