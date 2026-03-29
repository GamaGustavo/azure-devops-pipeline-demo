variable "location" {
  description = "Região do Azure"
  type        = string
  default     = "brazilsouth"
}

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "devops-demo-rg"
}

variable "container_registry_name" {
  description = "Nome do Azure Container Registry"
  type        = string
  default     = "devopsdemoacr"
}

variable "image_name" {
  description = "Nome da imagem Docker"
  type        = string
  default     = "devops-demo-app"
}

variable "image_tag" {
  description = "Tag da imagem Docker"
  type        = string
  default     = "latest"
}

variable "acr_username" {
  description = "Username do ACR (Service Principal)"
  type        = string
  sensitive   = true
}

variable "acr_password" {
  description = "Password do ACR (Service Principal)"
  type        = string
  sensitive   = true
}

variable "create_staging" {
  description = "Criar ambiente de staging?"
  type        = bool
  default     = true
}

variable "create_production" {
  description = "Criar ambiente de produção?"
  type        = bool
  default     = false
}
