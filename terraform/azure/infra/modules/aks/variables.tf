variable "location" {

}
variable "resource_group_name" {}

variable "service_principal_name" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "neyo-aks-cluster"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "client_id" {}

variable "client_secret" {
  type      = string
  sensitive = true
}

variable "acr_name" {
  type    = string
  default = "neyoacr"
}