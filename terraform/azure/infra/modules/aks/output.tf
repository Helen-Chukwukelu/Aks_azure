output "config" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
}

output "aks_id" {
  value = azurerm_kubernetes_cluster.aks-cluster.id
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aks-cluster.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aks-cluster.node_resource_group
}

output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "id" {
  value = data.azurerm_application_gateway.appgw.id
}

/* output "subnet_id" {
  value = data.azurerm_subnet.front_sub.id
} */