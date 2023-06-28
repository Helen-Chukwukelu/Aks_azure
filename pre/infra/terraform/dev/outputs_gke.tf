output "gke_name" {
  description = "the name of the GKE cluster created"
  value       = module.gke_cluster.name
}

output "workload-identites" {
  description = "Email address of GCP service account."
  value       = [for idx, sa in module.workload_identity.*.k8s_service_account_name : "${module.workload_identity[idx].k8s_service_account_namespace}:  ${sa}"]
}
