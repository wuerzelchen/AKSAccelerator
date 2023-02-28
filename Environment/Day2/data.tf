# data resource for azure container registry
data "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# data resource for azure resource group
data "azurerm_resource_group" "rg" {
  name = "rg"
}

# current user object id
data "azurerm_client_config" "current" {}
