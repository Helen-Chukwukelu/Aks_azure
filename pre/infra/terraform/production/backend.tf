terraform {
  backend "gcs" {
    bucket      = "optty-tfstate-prod-b96a8f214e3f08082cd2"
    prefix      = "global/terrform.tfstate"
    credentials = "sa.json"
  }
}
