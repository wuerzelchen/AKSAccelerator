# local variables
locals {
  # create a random 5 character suffix
  random_string = {
    length  = 5
    special = false
    upper   = false
  }
  # use random_string as a suffix for dns_name_label
  dns_name_label = format("aci-%s", random_string.random_string.result)
  name           = format("aci-%s", random_string.random_string.result)
  acr_name       = var.acr_name
}
# add random_string resource
resource "random_string" "random_string" {
  length  = local.random_string.length
  special = local.random_string.special
  upper   = local.random_string.upper
}

# add azure container instance
resource "azurerm_container_group" "aci" {
  name                = local.name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  os_type             = "Linux"
  dns_name_label      = local.dns_name_label
  image_registry_credential {
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }
  container {
    name   = local.name
    image  = format("%s/%s", data.azurerm_container_registry.acr.login_server, "aci-helloworld")
    cpu    = "0.5"
    memory = "1.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
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
