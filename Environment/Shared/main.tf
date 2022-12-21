# add azure container registry
resource "azurerm_container_registry" "acr" {
  name                = "acrtest1dfsa23"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"
  admin_enabled       = true
}

# add azure resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg"
  location = "westeurope"
}
