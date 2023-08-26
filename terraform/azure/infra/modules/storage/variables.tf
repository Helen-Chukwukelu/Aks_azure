variable "storage_account_Name" {
  type    = string
  default = ""
}

variable "resource_group_name" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = ""
}

variable "accounttier" {
  type    = string
  default = ""
}

variable "accountreplicationtype" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {
    env = "test"
  }
}

variable "containter_name" {
  type    = string
  default = "tfstate"
}