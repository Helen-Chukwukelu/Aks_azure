provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  description = "Name of the existing Azure resource group"
}

variable "location" {
  description = "Azure region where resources will be created"
  default     = "East US"
}

variable "application_gateway_name" {
  description = "Name of the Azure Application Gateway"
}

variable "kube_config_path" {
  description = "Path to the kubeconfig file for your Kubernetes cluster"
}

resource "azurerm_application_gateway" "example" {
  name                = var.application_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

  # Configure other settings like frontend IP configs, backend pools, listeners, etc.
}

provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}

resource "helm_release" "ingress_controller" {
  name       = "appgw-ingress"
  repository = "https://appgwingress.blob.core.windows.net/ingress-azure"
  chart      = "ingress-azure"
  namespace  = "appgw-ingress"
  depends_on = [azurerm_application_gateway.example]
  
  set {
    name  = "appgw.name"
    value = azurerm_application_gateway.example.name
  }

  set {
    name  = "appgw.resourceGroup"
    value = azurerm_application_gateway.example.resource_group_name
  }

  # Set other values as needed
}
