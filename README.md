# Azure DevOps Pipeline Demo

Projeto demonstrando uma pipeline CI/CD completa com Azure DevOps, GitHub Actions, Terraform e Docker.

## 🎯 Objetivo

Automatizar build, testes, containerização e deploy de uma aplicação Flask em ambiente Azure, demonstrando habilidades DevOps reais.

## 🏗️ Arquitetura

- **App**: Flask (Python 3.11)
- **Testes**: pytest
- **Container**: Docker
- **CI/CD**: Azure DevOps Pipelines + GitHub Actions
- **Infra**: Terraform + Azure Container Instances + Azure Container Registry
- **Ambientes**: Staging (automático) + Production (aprovação manual)

## ☁️ Azure Integration

Este projeto demonstra automação de infraestrutura Azure usando:

- **Terraform**: Provisionamento de Resource Group, ACR e ACI
- **Azure CLI**: Deploy via `az container create`
- **Azure Container Registry**: Armazenamento de imagens Docker
- **Azure Container Instances**: Runtime serverless para a aplicação

> ✅ Certificações relacionadas: AZ-900, MS-900, AWS Academy Cloud Architecting

---

## 🚀 Provisionamento de Infraestrutura

### Pré-requisitos

- Conta Azure ativa
- Azure CLI instalado
- Terraform instalado (opcional, pipeline faz automaticamente)

### Passo 1: Login no Azure

```bash
az login
```
### Passo 2: Criar Resource Group
```bash
az provider register --namespace Microsoft.ContainerRegistry

# Verificar status
az provider show --namespace Microsoft.ContainerRegistry --query registrationState -o tsv
# Aguardar até retornar "Registered"
```
### Passo 4: Criar Azure Container Registry (ACR)

```bash
az acr create \
  --resource-group devops-demo-rg \
  --name devopsdemoacr \
  --sku Basic \
  --admin-enabled false
```

### Passo 5: Criar Service Principal (para autenticação segura)

```bash
# Criar SP com acesso ao ACR
ACR_ID=$(az acr show --name devopsdemoacr --query id --output tsv)

az ad sp create-for-rbac \
  --name "devops-demo-sp" \
  --role "AcrPush" \
  --scopes $ACR_ID \
  --query "{client_id:appId, client_secret:password, tenant_id:tenant}" \
  --output json
```

> ⚠️ Salve as credenciais — você precisará delas para configurar os secrets do GitHub.






## 📝 Autor
Gustavo Avila Gama
DevOps Engineer | gamagustavo.com.br

