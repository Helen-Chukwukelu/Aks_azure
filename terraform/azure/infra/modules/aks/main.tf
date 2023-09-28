/* resource "azurerm_role_assignment" "role_acrpull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks-cluster.service_principal.0.client_id
  skip_service_principal_aad_check = true
} */

/* resource "azurerm_role_assignment" "role_acrpull_sys" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks-cluster.identity.0.principal_id
  skip_service_principal_aad_check = true
} */

/* resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
} */

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_group_name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-nrg"

  default_node_pool {
    name                = "defaultpool"
    vm_size             = "Standard_DS2_v2"
    zones               = [1, 2, 3]
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 1
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
    tags = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
  }

  /* service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  } */

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  /* ingress_application_gateway {
    gateway_name = var.appgw
    gateway_id    = data.azurerm_application_gateway.appgw.id
    subnet_id = data.azurerm_subnet.front_sub.id
    subnet_cidr = "10.21.0.0/24"
  } */

  web_app_routing {
    dns_zone_id = "/subscriptions/c7159b76-0836-4a8d-99df-ab0ef217acb0/resourceGroups/domainrg/providers/Microsoft.Network/dnsZones/solarwhize.com"
  }
}

