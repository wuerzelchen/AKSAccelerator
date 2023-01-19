# output for aci server
output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}