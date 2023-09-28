provider "azurerm" {
  features {}
}

/* provider "azuread" {
  # Configuration options
} */

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.70.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.41.0"
    }
    random = {
        source = "hashicorp/random"
        version = "~> 3.0"
    }
  }
}