## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.13.0 |
| google | ~>3.40 |
| google-beta | ~>3.40 |
| random | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| google | ~>3.40 |
| kubernetes | n/a |
| random | 2.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| credentials | Path to service account file(.json) | `string` | `"sa.json"` | no |
| db\_charset | The charset for the default database | `string` | `""` | no |
| db\_collation | The collation for the default database. Example: 'en\_US.UTF8' | `string` | `""` | no |
| db\_name | The name of the default database to create | `string` | `"optty-staging-db-dev"` | no |
| db\_user\_name | The name of the user to create | `string` | `"staging-user"` | no |
| dns\_zone\_name | n/a | `string` | `"optty-deimos-app-staging"` | no |
| enable\_http | n/a | `string` | `"false"` | no |
| enable\_ssl | n/a | `string` | `"true"` | no |
| environment | Current project environment | `string` | `"staging"` | no |
| gke\_cluster | the name of the already provisioned GKE cluster | `string` | `"optty-gke-dev"` | no |
| internal\_system\_namespace | The Namespace to deploy internal/devops kubernetes objects to | `string` | `"internal-system"` | no |
| location | The location of the Region | `string` | `"EU"` | no |
| merchant\_portal\_domain\_name | The domain name for merchant portal website | `string` | `"merchant-portal.staging.optty.deimos.co.za"` | no |
| merchant\_portal\_ssl\_name | The domain name for merchant portal website | `string` | `"merchant-portal-ssl-staging"` | no |
| not\_found\_page | n/a | `string` | `"index.html"` | no |
| postgres\_instance | The Name of the existing cloudsql instance | `string` | `"dev-optty-postgres"` | no |
| project\_id | n/a | `string` | `"dcp-enterprise-optty"` | no |
| project\_name | n/a | `string` | `"optty"` | no |
| public\_dns\_zone | n/a | `string` | `"staging.optty.deimos.co.za."` | no |
| redis\_name | The name of the redis instance | `string` | `"optty-memory-store-dev-3ab02cdfbedd5342"` | no |
| region | The GCP Project Region | `string` | `"europe-west1"` | no |
| static\_website\_force\_destroy | n/a | `string` | `"true"` | no |
| widgets\_domain\_name | The domain name for merchant portal website | `string` | `"magento-widgets.staging.optty.deimos.co.za"` | no |
| widgets\_ssl\_name | The domain name for merchant portal website | `string` | `"magento-widgets-ssl-staging"` | no |
| workload\_identity\_roles | The roles to be given to the workload identity | `list` | <pre>[<br>  "roles/secretmanager.admin",<br>  "roles/container.developer",<br>  "roles/iam.serviceAccountAdmin"<br>]</pre> | no |
| zones | The GCP Project Region | `list` | <pre>[<br>  "europe-west1-b"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| dns\_name\_servers | zone name servers. |
| merchant\_portal\_bucket | The bucket name for merchant portal |
| merchant\_portal\_website\_url | The IP Address of the loadbalancer |
| postgres\_connection\_name | The connection name of the master instance to be used in connection strings |
| postgres\_db\_name | n/a |
| postgres\_instance\_name | The instance name for the master instance |
| postgres\_private\_ip\_address | n/a |
| postgres\_user | n/a |
| postgres\_user\_password | n/a |
| public\_dns\_domain | n/a |
| public\_dns\_name | n/a |
| widgets\_bucket | The bucket name for Widgets |
| widgets\_website\_url | The IP Address of the loadbalancer |
