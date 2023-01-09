# locals with random string
locals {
  # create a random 5 character suffix
  random_string = {
    length  = 5
    special = false
    upper   = false
  }
  # use random_string as a suffix for dns_name_label
  dns_prefix = format("aci-%s", random_string.random_string.result)
  acr_name   = var.acr_name
  aks_name   = format("aks-%s", random_string.random_string.result)
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
  kubernetes_version  = "1.24"


  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
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

# data resource for azure container registry
data "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# data resource for azure resource group
data "azurerm_resource_group" "rg" {
  name = "rg"
}
