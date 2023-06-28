# terraform-scripts

[![pipeline status](https://gitlab.com/deimosdev/client-project/optty/terraform/badges/master/pipeline.svg)](https://gitlab.com/deimosdev/client-project/optty/terraform/-/commits/master)

Terraform scripts to Setup the Optty Project Infrastructure

[![Architecture Diagram](https://storage.3.basecamp.com/4400303/buckets/16921415/uploads/3034141935/download/infrastructure-high-level-updated.png)(https://3.basecamp.com/4400303/buckets/16921415/uploads/3034141935)]

Documentation about infrastructural specification is located [here](https://3.basecamp.com/4400303/buckets/16921415/vaults/3346837894)

### Environments
- [dev](./dev)
- [staging](./staging)
- [production](./production)


## Contribution

Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform) which uses [terraform-docs](https://github.com/segmentio/terraform-docs).

Follow [these instructions](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) to install pre-commit locally.

And install `terraform-docs` with
```bash
go get github.com/segmentio/terraform-docs
```
or
```bash
brew install terraform-docs.
```

Full contributing guidelines are covered [here](CONTRIBUTING.md).

## Setup
### Requirements
- Terraform >= 0.13
- gcloud command line
- Kubectl
- Helm v3

### Create Service Account
- Visit https://cloud.google.com/iam/docs/creating-managing-service-accounts to see how to create service account
- The Service Account should have `Project IAM Admin`, `Compute Admin`, `Kubernetes Engine Admin` Roles
- Download Service account key
- Place downloaded credentials in terraform directory

### Build and Test

```bash
  $ export GOOGLE_APPLICATION_CREDENTIALS=path/to/service/account/json
  $ terraform init
  $ terraform apply
```

### Clean Up

```bash
  $ terraform destroy
```
