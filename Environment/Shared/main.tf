# locals with random
locals {
  # create a random 5 character suffix
  random_string = {
    length  = 5
    special = false
    upper   = false
  }
  # use random_string as a suffix for dns_name_label
  acr_name = format("acr%s", random_string.random_string.result)
}
# add random_string resource
resource "random_string" "random_string" {
  length  = local.random_string.length
  special = local.random_string.special
  upper   = local.random_string.upper
}
# add azure container registry
resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
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
