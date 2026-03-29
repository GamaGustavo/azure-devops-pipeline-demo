output "resource_group_name" {
  value = azurerm_resource_group.demo_rg.name
}

output "acr_login_server" {
  value = azurerm_container_registry.demo_acr.login_server
}

output "acr_name" {
  value = azurerm_container_registry.demo_acr.name
}

output "staging_url" {
  value     = azurerm_container_group.demo_staging[0].fqdn
  sensitive = false
}

output "production_url" {
  value     = azurerm_container_group.demo_production[0].fqdn
  sensitive = false
}
