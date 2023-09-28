data "azurerm_virtual_network" "aks_vnet" {
  name                = var.aks_vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_user_assigned_identity" "main" {
  name                = azurerm_user_assigned_identity.main.name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  resource_group_name = var.kv_rg
}

data "azurerm_key_vault_certificate" "main" {
  name         = var.cert_name
  key_vault_id = data.azurerm_key_vault.main.id
}
