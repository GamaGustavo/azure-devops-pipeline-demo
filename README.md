# Azure DevOps Pipeline Demo
![CI/CD Pipeline](https://github.com/GamaGustavo/azure-devops-pipeline-demo/actions/workflows/ci-cd.yml/badge.svg)

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

---

## 🛠️ Configuração Local
### Clonar repositório

```bash
git clone https://github.com/seu-usuario/azure-devops-pipeline-demo.git
cd azure-devops-pipeline-demo
```

### Instalar dependências

```bash
cd app
pip install -r requirements.txt
```

### Executar localmente

```bash
python src/main.py
```
Acesse: http://localhost:5000

### Executar testes

```bash
python -m pytest tests/ -v
```

### Build Docker

```bash
docker build -t devops-demo-app app/
docker run -p 5000:5000 devops-demo-app
```

---

## 🔄 CI/CD Pipeline

### Azure DevOps

1. Criar projeto no Azure DevOps
1. Conectar repositório GitHub
1. Criar Service Connection com Azure
1. Criar environments: staging e production
1. Configurar pipeline apontando para azure-pipelines.yml

> ⚠️ Importante: Para repositórios privados, solicite parallelism grant:
> https://aka.ms/azpipelines-parallelism-request

### GitHub Actions

Pipeline automático configurado em `.github/workflows/ci-cd.yml`:

- **Stage 1**: Build & Test (Python + pytest)
- **Stage 2**: Terraform Plan (validação de infra)
- **Stage 3**: Deploy to Staging (automático)
- **Stage 4**: Deploy to Production (requer aprovação manual)

#### Configurar Secrets no GitHub

1. Acesse: **Settings → Secrets and variables → Actions**
2. Adicione os seguintes secrets:

| Nome                 | Valor                                  |
|----------------------|----------------------------------------|
| AZURE_CLIENT_ID      | Client ID do Service Principal         |
| AZURE_CLIENT_SECRET  | Client Secret do Service Principal     |
| AZURE_SUBSCRIPTION_ID| ID da sua assinatura Azure             |
| AZURE_TENANT_ID      | Tenant ID do Azure                     |
| AZURE_CREDENTIALS    | JSON com todas as credenciais          |

**Formato de `AZURE_CREDENTIALS`**:

```json
{
  "clientId": "SEU_CLIENT_ID_AQUI",
  "clientSecret": "SEU_CLIENT_SECRET_AQUI",
  "subscriptionId": "sua_subscription_id",
  "tenantId": "seu_tenant_id"
}
```

---

## 🌐 Deploy com Terraform

### Inicializar

```bash
terraform init
```

### Validar

```bash
terraform validate
```

### Planejar

```bash
terraform plan \
  -var="location=brazilsouth" \
  -var="acr_username=seu-client-id" \
  -var="acr_password=seu-client-secret" \
  -var="image_tag=latest"
```

### Aplicar

```bash
terraform apply \
  -var="location=brazilsouth" \
  -var="acr_username=seu-client-id" \
  -var="acr_password=seu-client-secret" \
  -var="image_tag=latest"
```

### Destruir (para evitar custos)

```bash
terraform destroy
```
---

## 💰 Controle de Custos

- **ACR Basic:** ~R$0,16/hora (~R$115/mês se 24/7)
- **ACI:** ~R$0,01/hora por CPU (~R$7/mês por instância)

**Recomendação:** Só crie recursos quando for testar. Delete após validação:

```bash
# Delete ACR
az acr delete --name devopsdemoacr --resource-group devops-demo-rg --yes

# Delete Resource Group (remove TUDO)
az group delete --name devops-demo-rg --yes --no-wait
```

---

## 📝 Autor
Gustavo Avila Gama
DevOps Engineer | gamagustavo.com.br

