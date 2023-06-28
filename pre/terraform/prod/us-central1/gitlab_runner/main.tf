#----------------------------------------------------------------------------------------------------------------------
# GITLAB RUNNER START
#----------------------------------------------------------------------------------------------------------------------
module "gitlab_runner" {
  source                    = "../modules/gitlab-runner"
  release_name              = "${var.project_name}-runner-${var.environment}"
  runner_tags               = var.runner_tags
  runner_registration_token = var.runner_registration_token
  default_runner_image      = var.default_runner_image

  depends_on = [module.gke_cluster]
}
