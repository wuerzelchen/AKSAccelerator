# output for aci server
output "aci_server" {
  value = azurerm_container_group.aci.ip_address
}

# output for aci fqdn
output "aci_fqdn" {
  value = azurerm_container_group.aci.fqdn
}
