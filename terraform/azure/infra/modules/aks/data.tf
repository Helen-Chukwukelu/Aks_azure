# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location        = var.location
  include_preview = false
}

/* data "azurerm_application_gateway" "appgw" {
  name                = var.appgw
  resource_group_name = var.AppGw_node_rg
} */

/* data "azurerm_subnet" "front_sub" {
  name                 = var.AppGw_frontend_sub
  virtual_network_name = var.AppGw_vnet_name
  resource_group_name  = var.AppGw_node_rg
} */


