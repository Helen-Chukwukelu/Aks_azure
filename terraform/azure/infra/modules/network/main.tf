resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.21.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = var.frontend_sub
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.21.0.0/24"]
}

/* resource "azurerm_subnet" "backend" {
  name                 = var.backend_sub
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.21.1.0/24"]
} */

resource "azurerm_public_ip" "pip" {
  name                = var.pip
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_user_assigned_identity" "main" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = var.user_identity
}

resource "azurerm_application_gateway" "main" {
  name                = var.appgw
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  identity {
    type         = "UserAssigned" # For TLS termination with Key Vault certificates to work properly existing user-assigned managed identity, which Application Gateway uses to retrieve certificates from Key Vault, should be defined via identity block. Additionally, access policies in the Key Vault to allow the identity to be granted get access to the secret should be defined.
    identity_ids = ["${azurerm_user_assigned_identity.main.id}"]
  }

  /* autoscale_configuration = {
    min_capacity = 1
    max_capacity = 3
  } */

  gateway_ip_configuration {
    name      = var.gw_ip_conf
    subnet_id = azurerm_subnet.frontend.id
  }

  frontend_port {
    name = var.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip.id
  }

  backend_address_pool {
    name = var.backend_address_pool_name
  }

  backend_http_settings {
    name                  = var.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    /* enable_https          = true
    probe_name            = "appgw-testgateway-eastus-probe1" # Remove this if `health_probes` object is not defined. */
  }

  http_listener {
    name                           = var.listener_name
    frontend_ip_configuration_name = var.frontend_ip_configuration_name
    frontend_port_name             = var.frontend_port_name
    protocol                       = "Http"
    /* ssl_certificate_name = "appgw-testgateway-eastus-ssl01" */
  }

  request_routing_rule {
    name                       = var.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = var.listener_name
    backend_address_pool_name  = var.backend_address_pool_name
    backend_http_settings_name = var.http_setting_name
    priority                   = 1
  }

  /* ssl_certificate {
    name = "appgw-testgateway-eastus-ssl01"
    data = filebase64("path/to/file") # encode the contents of the file
    key_vault_secret_id = "https://test-neyo-kv-101.vault.azure.net/secrets/neyo-test-ca/919e7f3f30c9425a81cf8beb7036c7d4"
  } */

}

# When you use an application gateway in a different resource group, 
# the managed identity created ingressapplicationgateway-{AKSNAME} 
# once this add-on is enabled in the AKS nodes resource group must 
# have Contributor role set in the Application Gateway resource as 
# well as Reader role set in the Application Gateway resource group.

resource "azurerm_role_assignment" "appgwidentity" {

  scope                = "/subscriptions/c7159b76-0836-4a8d-99df-ab0ef217acb0/resourceGroups/test-neyo-rg-nrg"
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_user_assigned_identity.main.principal_id

  depends_on = [
    azurerm_user_assigned_identity.main
  ]
}

resource "azurerm_virtual_network_peering" "aks-vnet" {
  name                      = var.AKStoAppGWVnetPeering_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.aks_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_virtual_network_peering" "appgw-vnet" {
  name                      = var.AppGWtoAKSVnetPeering_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.aks_vnet.id
}