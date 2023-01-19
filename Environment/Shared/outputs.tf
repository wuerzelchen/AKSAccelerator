# output for acr login server
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

# output for acr name
output "acr_name" {
  value = azurerm_container_registry.acr.name
}

# output for resource group name
output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}