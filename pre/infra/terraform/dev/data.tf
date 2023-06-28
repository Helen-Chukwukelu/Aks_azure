# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}


data "google_secret_manager_secret_version" "argocd_access_token" {
  secret = "argocd_access_token"
}

data "google_secret_manager_secret_version" "runner_registration_token" {
  secret = "runner_registration_token"
}

data "google_secret_manager_secret_version" "elastic_apm_secret" {
  secret = "dev-elastic-apm-secret"
}
