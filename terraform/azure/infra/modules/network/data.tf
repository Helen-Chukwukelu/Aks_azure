data "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "main" {
  name                = azurerm_user_assigned_identity.main.name
  resource_group_name = var.resource_group_name
}
