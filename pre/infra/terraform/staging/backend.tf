terraform {
  backend "gcs" {
    bucket      = "optty-tfstate-dev-f8edbb0e3520b25d7c9f"
    prefix      = "staging/terrform.tfstate"
    credentials = "sa.json"
  }
}
