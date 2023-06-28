# Terraform GCP Booster Pack

A booster pack to deploy a single environment using terraform and Terragrunt.

### Directory structure
```bash
.
└── prod
    └── us-central1
        ├── buckets
        ├── cloud_armor
        ├── cloudsql
        ├── dns_zone
        ├── gcr
        ├── gitlab_runner
        ├── gke
        │   ├── argocd
        │   ├── cluster
        │   ├── external-dns
        │   └── namespaces
        ├── iam
        │   └── service_accounts
        ├── memory_store
        ├── static_website
        ├── vpc
        └── vpn

```
Each directory corresponds to a stack (a single unit of terraform deployment that can stand on its own).


## Usage
### Requirements
- [Terraform](https://www.terraform.io/downloads.html). Consider using [tfenv](https://github.com/tfutils/tfenv) to manage terraform versions on your workstation instead of having to download new terraform versions each time.
- [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
- [Helm](https://helm.sh/docs/intro/install/)
- Service Account credentials (sa.json) in the root directory

### Creating the infrastructure
- ** Apply Single Resource **
```bash
$ cd <resource-to-create>
$ terragrunt init
$ terragrunt apply
```

- ** Apply All Resource **
```bash
$ cd <root-directory>
$ terragrunt run-all
```

### Destroying
- ** Destroy Single Resource **
```bash
$ cd <resource-to-create>
$ terragrunt destroy
```

## Module sources
Modules are sourced from [the official Deimos Terraform Registry](https://registry.terraform.io/namespaces/DeimosCloud) and official registries