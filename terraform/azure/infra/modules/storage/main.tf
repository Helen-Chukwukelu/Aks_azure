resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_Name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.accounttier
  account_replication_type = var.accountreplicationtype

  tags = var.tags
}  

resource "azurerm_storage_container" "container" {
  name                  = var.containter_name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}