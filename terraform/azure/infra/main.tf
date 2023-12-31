resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.location
}

module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [
    azurerm_resource_group.rg1
  ]
}

resource "azurerm_role_assignment" "rolespn" {

  scope                = "/subscriptions/c7159b76-0836-4a8d-99df-ab0ef217acb0"
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal
  ]
}

resource "azurerm_role_assignment" "spn_kv" {

  scope                = "/subscriptions/c7159b76-0836-4a8d-99df-ab0ef217acb0"
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal
  ]
}

resource "azurerm_role_assignment" "sys_ass" {

  scope                = "/subscriptions/c7159b76-0836-4a8d-99df-ab0ef217acb0"
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_kubernetes_cluster.main.identity.0.principal_id

  depends_on = [
    module.aks
  ]
}

resource "azurerm_role_assignment" "secret_kv_role" {

  scope                = "/subscriptions/c7159b76-0836-4a8d-99df-ab0ef217acb0/resourceGroups/test-neyo-rg/providers/Microsoft.KeyVault/vaults/test-neyo-kv-101"
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_kubernetes_cluster.main.identity.0.principal_id

  depends_on = [
    module.aks
  ]
}

resource "azurerm_role_assignment" "secret_identity_role" {

  scope                = "/subscriptions/c7159b76-0836-4a8d-99df-ab0ef217acb0/resourceGroups/test-neyo-rg/providers/Microsoft.KeyVault/vaults/test-neyo-kv-101"
  role_definition_name = "Key Vault Administrator"
  principal_id         = "19e0c761-bc4b-4bb8-a78f-35558fa035d1"

  depends_on = [
    module.aks
  ]
}

resource "azurerm_role_assignment" "wep_app_identity_role" {

  scope                = "/subscriptions/c7159b76-0836-4a8d-99df-ab0ef217acb0/resourceGroups/domainrg/providers/Microsoft.Network/dnsZones/solarwhize.com"
  role_definition_name = "DNS Zone Contributor"
  principal_id         = "6ede99ef-fd53-4b9c-84ec-1083485631ae"

  depends_on = [
    module.aks
  ]
}

module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

  depends_on = [
    module.ServicePrincipal
  ]
}

resource "azurerm_key_vault_secret" "testsecret" {
  name         = module.ServicePrincipal.client_id
  value        = module.ServicePrincipal.client_secret
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [
    module.keyvault
  ]

}

#create Azure Kubernetes Service
module "aks" {
  source                 = "./modules/aks/"
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  location               = var.location
  resource_group_name    = var.rgname

  depends_on = [
    module.ServicePrincipal
  ]

}

resource "local_file" "kubeconfig" {
  depends_on = [module.aks]
  filename   = "./kubeconfig"
  content    = module.aks.config

}

#create Azure Storage account
module "storageacct" {
  source                 = "./modules/storage"
  storage_account_Name   = var.storage_account_name
  resource_group_name    = var.rgname
  location               = var.location
  accounttier            = var.accoun_tier
  accountreplicationtype = var.act_repl_type
}

#create Azure Application Gateway
/* module "appgw" {
  source                 = "./modules/network"
  resource_group_name    = var.node_rg
  location               = var.location
} */



