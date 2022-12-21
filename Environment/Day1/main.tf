# add azure container instance
resource "azurerm_container_group" "aci" {
  name                = "aci"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = "public"
  os_type             = "linux"
  dns_name_label      = "aci-ds324dsf"
  image_registry_credential {
    server   = data.azurerm_container_registry.acr.login_server
    username = data.azurerm_container_registry.acr.admin_username
    password = data.azurerm_container_registry.acr.admin_password
  }
  container {
    name   = "aci"
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
  name                = "acrtest1dfsa23"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# data resource for azure resource group
data "azurerm_resource_group" "rg" {
  name = "rg"
}
