output "app_url" {
  value = "http://${azurerm_container_group.demo_app.fqdn}:5000"
}
