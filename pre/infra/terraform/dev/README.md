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
| argocd\_ingress\_annotations | n/a | `map` | <pre>{<br>  "cert-manager.io/cluster-issuer": "lets-encrypt-prod",<br>  "external-dns.alpha.kubernetes.io/hostname": "argocd.dev.optty.deimos.co.za",<br>  "kubernetes.io/ingress.class": "nginx",<br>  "kubernetes.io/tls-acme": "true",<br>  "nginx.ingress.kubernetes.io/backend-protocol": "HTTPS",<br>  "nginx.ingress.kubernetes.io/force-ssl-redirect": "true"<br>}</pre> | no |
| argocd\_ingress\_hostname | The preferred host for the argocd ingress | `string` | `"argocd.dev.optty.deimos.co.za"` | no |
| bastion\_disk\_size\_gb | n/a | `string` | `"30"` | no |
| bastion\_service\_account | Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template.html#service_account. | <pre>object({<br>    email  = string,<br>    scopes = set(string)<br>  })</pre> | <pre>{<br>  "email": "678893936446-compute@developer.gserviceaccount.com",<br>  "scopes": [<br>    "userinfo-email",<br>    "compute-ro",<br>    "storage-ro"<br>  ]<br>}</pre> | no |
| cluster\_service\_account\_description | A description of the custom service account used for the GKE cluster. | `string` | `"Example GKE Cluster Service Account managed by Terraform"` | no |
| credentials | Path to service account file(.json) | `string` | `"sa.json"` | no |
| database\_availability | The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance | `string` | `"ZONAL"` | no |
| database\_tier | the tier of the master instance | `string` | `"db-f1-micro"` | no |
| database\_version | the database version to use | `string` | `"POSTGRES_12"` | no |
| default\_runner\_image | Runner Tags | `string` | `"eu.gcr.io/dcp-enterprise-optty/optty-builder-image"` | no |
| dns\_zone\_name | n/a | `string` | `"optty-deimos-app-dev"` | no |
| enable\_http | n/a | `string` | `"false"` | no |
| enable\_ssl | n/a | `string` | `"true"` | no |
| enable\_vertical\_pod\_autoscaling | Enable vertical pod autoscaling | `string` | `true` | no |
| environment | Current project environment | `string` | `"dev"` | no |
| gitops\_access\_token | Gitlab Private Token for deploying | `string` | `"SXDmmsmrdds8yiKnWg6s"` | no |
| gitops\_repo | The git repository link for argocd | `string` | `"https://gitlab.com/deimosdev/client-project/optty/gitops.git"` | no |
| image\_family | n/a | `string` | `"ubuntu-2004-lts"` | no |
| internal\_system\_namespace | The Namespace to deploy internal/devops kubernetes objects to | `string` | `"internal-system"` | no |
| location | The location of the Region | `string` | `"EU"` | no |
| machine\_type | The type of machine to deploy nodes in | `string` | `"n1-highcpu-8"` | no |
| merchant\_portal\_domain\_name | The domain name for merchant portal website | `string` | `"merchant-portal.dev.optty.deimos.co.za"` | no |
| merchant\_portal\_ssl\_name | The domain name for merchant portal website | `string` | `"merchant-portal-ssl"` | no |
| nat\_ip | Public ip address | `any` | `null` | no |
| network\_tier | Network network\_tier | `string` | `"PREMIUM"` | no |
| not\_found\_page | n/a | `string` | `"index.html"` | no |
| num\_instances | n/a | `string` | `"1"` | no |
| override\_default\_node\_pool\_service\_account | When true, this will use the service account that is created for use with the default node pool that comes with all GKE clusters | `bool` | `false` | no |
| postgres\_assign\_public\_ip | Set to true if the master instance should also have a public IP (less secure). | `bool` | `false` | no |
| postgres\_master\_disk\_type | The disk type for the master instance. | `string` | `"PD_HDD"` | no |
| postgres\_require\_ssl | Set to true if SSL certificates is required to connect to master instance (more secure). | `bool` | `false` | no |
| private\_dns | The Private DNS Managed Zone to create in Cloud DNS (with the appended period(.)) | `string` | `"private.optty.net."` | no |
| project\_id | n/a | `string` | `"dcp-enterprise-optty"` | no |
| project\_name | n/a | `string` | `"optty"` | no |
| public\_dns\_zone | n/a | `string` | `"dev.optty.deimos.co.za."` | no |
| public\_dns\_zone\_staging | n/a | `string` | `"staging.optty.deimos.co.za."` | no |
| redis\_connect\_mode | The connection mode of the Redis instance. Can be either DIRECT\_PEERING or PRIVATE\_SERVICE\_ACCESS | `string` | `"PRIVATE_SERVICE_ACCESS"` | no |
| redis\_memory\_size\_gb | Redis memory size in GiB | `string` | `"1"` | no |
| redis\_tier | The service tier of the instance. cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Tier | `string` | `"BASIC"` | no |
| region | The GCP Project Region | `string` | `"europe-west1"` | no |
| runner\_machine\_type | The type of machine to deploy nodes in | `string` | `"n1-highcpu-8"` | no |
| runner\_registration\_token | Runner Registartaion Token | `string` | `"xLCMQ9T5-eVJK3a2QNaB"` | no |
| runner\_tags | Runner Tags | `string` | `"optty-dev"` | no |
| service\_account\_roles | Additional roles to be added to the service account. | `list(string)` | <pre>[<br>  "roles/dns.admin"<br>]</pre> | no |
| source\_image\_project | n/a | `string` | `"ubuntu-os-cloud"` | no |
| static\_website\_force\_destroy | n/a | `string` | `"true"` | no |
| vpc\_cidr\_block | The IP address range of the VPC in CIDR notation | `string` | `"10.6.0.0/16"` | no |
| vpc\_secondary\_cidr\_block | The IP address range of the VPC's secondary address range in CIDR notation | `string` | `"10.7.0.0/16"` | no |
| widgets\_domain\_name | The domain name for merchant portal website | `string` | `"magento-widgets.dev.optty.deimos.co.za"` | no |
| widgets\_ssl\_name | The domain name for merchant portal website | `string` | `"magento-widgets-ssl"` | no |
| workload\_identity\_roles | The roles to be given to the workload identity | `list` | <pre>[<br>  "roles/secretmanager.admin",<br>  "roles/container.developer",<br>  "roles/iam.serviceAccountAdmin"<br>]</pre> | no |
| zones | The GCP Project Region | `list` | <pre>[<br>  "europe-west1-b"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| dns\_name\_servers | zone name servers. |
| email | Email address of GCP service account. |
| gcs\_bucket\_names | the name of the GKE cluster created |
| gke\_name | the name of the GKE cluster created |
| merchant\_portal\_bucket | The bucket name for merchant portal |
| merchant\_portal\_website\_url | The IP Address of the loadbalancer |
| postgres\_connection\_name | The connection name of the master instance to be used in connection strings |
| postgres\_default\_db\_name | n/a |
| postgres\_dns | The Private Assigned DNS Record to master instance |
| postgres\_instance\_name | The instance name for the master instance |
| postgres\_private\_ip\_address | n/a |
| postgres\_user | n/a |
| postgres\_user\_password | n/a |
| public\_dns\_domain | n/a |
| public\_dns\_name | n/a |
| redis\_dns | The Private Assigned DNS Record to The redis instance |
| redis\_host | The IP address of the instance. |
| widgets\_bucket | The bucket name for Widgets |
| widgets\_website\_url | The IP Address of the loadbalancer |
