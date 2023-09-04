output "gateway_frontend_ip" {
  value = "http://${azurerm_public_ip.pip.ip_address}"
}

output "uai_principal_id" {
  value = data.azurerm_user_assigned_identity.main.principal_id
}