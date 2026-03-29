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
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "demo"
    Project     = "devops-pipeline"
    Owner       = "Gustavo Avila Gama"
  }
}

resource "azurerm_container_registry" "demo_acr" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.demo_rg.name
  location            = azurerm_resource_group.demo_rg.location
  sku                 = "Basic"
  admin_enabled       = false  # Segurança: usar service principal em vez de admin

  tags = {
    Environment = "demo"
    Project     = "devops-pipeline"
  }
}

resource "azurerm_container_group" "demo_staging" {
  count               = var.create_staging ? 1 : 0
  name                = "devops-demo-staging"
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "devops-demo-staging-${random_string.suffix[0].result}"
  os_type             = "Linux"

  container {
    name   = "app"
    image  = "${azurerm_container_registry.demo_acr.login_server}/${var.image_name}:${var.image_tag}"
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
    Environment = "staging"
    Project     = "devops-pipeline"
  }
}

resource "azurerm_container_group" "demo_production" {
  count               = var.create_production ? 1 : 0
  name                = "devops-demo-production"
  location            = azurerm_resource_group.demo_rg.location
  resource_group_name = azurerm_resource_group.demo_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "devops-demo-prod-${random_string.suffix[0].result}"
  os_type             = "Linux"

  container {
    name   = "app"
    image  = "${azurerm_container_registry.demo_acr.login_server}/${var.image_name}:${var.image_tag}"
    cpu    = "1.0"
    memory = "2.0"

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
    Environment = "production"
    Project     = "devops-pipeline"
  }
}

resource "random_string" "suffix" {
  count   = 1
  length  = 6
  special = false
  upper   = false
}
