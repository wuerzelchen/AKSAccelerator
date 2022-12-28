# add azure kubernetes service
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "aks132asde2"
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
  name                = "acrtest1dfsa23"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# data resource for azure resource group
data "azurerm_resource_group" "rg" {
  name = "rg"
}
