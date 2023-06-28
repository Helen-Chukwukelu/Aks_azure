output "bucket_names" {
  description = "the name of the GKE cluster created"
  value       = module.gcs_buckets.names
}
