# output for acr login server
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

# output for acr name
output "acr_name" {
  value = azurerm_container_registry.acr.name
}

# output for acr login username
output "acr_username" {
  value = azurerm_container_registry.acr.admin_username
}

# output for acr login password
output "acr_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}
