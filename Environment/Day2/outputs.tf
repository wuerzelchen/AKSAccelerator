# add an output for the aks name
output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
# add an output for the aks resource group name
output "aks_rg" {
  value = azurerm_kubernetes_cluster.aks.resource_group_name
}
