variable "workload_identity_config" {
  description = "The namespaces to enable Workload Identity For"
  default = [
    {
      name      = "optty-apps"
      namespace = "apps-staging"
      roles = [
        "roles/secretmanager.admin",
        "roles/container.developer",
        "roles/iam.serviceAccountAdmin",
        "roles/storage.admin",
      ],
    },
  ]
}
