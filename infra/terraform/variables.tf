variable "acr_username" {
  description = "Client ID do Service Principal"
  type        = string
  sensitive   = true
}

variable "acr_password" {
  description = "Client Secret do Service Principal"
  type        = string
  sensitive   = true
}
