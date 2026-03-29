terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "demo_rg" {
  name     = "devops-demo-rg"
  location = "brazilsouth"

  tags = {
    Environment = "demo"
    Project     = "devops-pipeline"
  }
}

resource "azurerm_container_registry" "demo_acr" {
  name                = "devopsdemoacr"
  resource_group_name = azurerm_resource_group.demo_rg.name
  location            = azurerm_resource_group.demo_rg.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    Environment = "demo"
  }
}

resource "azurerm_container_group" "demo_app" {
  name                = "devops-demo-app"
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "devops-demo-app-${substr(sha256(timestamp()), 0, 6)}"
  os_type             = "Linux"

  container {
    name   = "app"
    image  = "${azurerm_container_registry.demo_acr.login_server}/devops-demo-app:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 5000
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = azurerm_container_registry.demo_acr.login_server
    username = var.acr_username
    password = var.acr_password
  }

  tags = {
    Environment = "demo"
  }
}
