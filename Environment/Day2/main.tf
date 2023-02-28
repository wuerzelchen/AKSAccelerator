# locals with random string
locals {
  # create a random 5 character suffix
  random_string = {
    length  = 5
    special = false
    upper   = false
  }
  # use random_string as a suffix for dns_name_label
  dns_prefix                 = format("aci-%s", random_string.random_string.result)
  acr_name                   = var.acr_name
  aks_name                   = format("aks-%s", random_string.random_string.result)
  aad_admin_group_object_ids = var.aad_admin_group_object_ids
  aad_rbac_enabled           = var.aad_rbac_enabled
}
# add random_string resource
resource "random_string" "random_string" {
  length  = local.random_string.length
  special = local.random_string.special
  upper   = local.random_string.upper
}
# add azure kubernetes service
resource "azurerm_kubernetes_cluster" "aks" {
  name                = local.aks_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = local.dns_prefix
  kubernetes_version  = "1.25.4"

  #http routing enabled
  http_application_routing_enabled = true
  # automatic upgrade channel patching
  automatic_channel_upgrade = "patch"
  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
    # define node pool version
    orchestrator_version = "1.25.4"
  }
  # AKS Cluster login definition
  role_based_access_control_enabled = true
  local_account_disabled            = true
  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = local.aad_rbac_enabled
    admin_group_object_ids = local.aad_admin_group_object_ids
  }
  identity {
    type = "SystemAssigned"
  }
}
# assign acr to aks, in order to pull container from own acr
resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}


