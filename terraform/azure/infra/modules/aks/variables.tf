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

variable "appgw" {
  default = "testAppGateway"
}

variable "AppGw_node_rg" {
  type = string
  default = "test-neyo-rg-nrg"
}

variable "AppGw_vnet_name" {
  default = "AppGwVnet"
}

variable "AppGw_frontend_sub" {
  default = "frontAGSubnet"
}