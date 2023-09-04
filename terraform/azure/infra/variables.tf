variable "rgname" {
  type        = string
  description = "resource group name"
}

variable "location" {
  type = string
}

variable "service_principal_name" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}
variable "accoun_tier" {
  type = string
}
variable "act_repl_type" {
  type = string
}

variable "node_rg" {
  type = string
  default = "test-neyo-rg-nrg"
}