output "gke_name" {
  description = "the name of the GKE cluster created"
  value       = module.gke_cluster.name
}