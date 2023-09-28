data "azurerm_kubernetes_cluster" "main" {
  name                = "neyo-aks-cluster"
  resource_group_name = "test-neyo-rg"
}

output "identity_principal_id" {
  value = data.azurerm_kubernetes_cluster.main.identity.0.principal_id
}

/* output "secret_identity" {
  value = data.azurerm_kubernetes_cluster.main.secret_identity[0].principal_id
}

output "wep_app_identity" {
  value = data.azurerm_kubernetes_cluster.main.web_application_routing_identity[0].object_id
} */