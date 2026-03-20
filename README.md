# Azure DevOps Pipeline Demo

Projeto demonstrando uma pipeline CI/CD completa com Azure DevOps, Terraform e Docker.

## 🎯 Objetivo
Automatizar build, testes, containerização e deploy de uma aplicação Flask em ambiente Azure.

## 🏗️ Arquitetura
- **App**: Flask (Python 3.11)
- **Testes**: pytest
- **Container**: Docker
- **CI/CD**: Azure DevOps Pipelines
- **Infra**: Terraform + Azure Container Instances + Azure Container Registry
- **Ambientes**: Staging (automático) + Production (aprovação manual)

## 🚀 Como executar localmente

```bash
cd app
pip install -r requirements.txt
python src/main.py
```
Acesse: http://localhost:5000

## 🧪 Testes

```bash
python -m pytest app/tests/ -v
```
## 📦 Build Docker

```bash
docker build -t devops-demo-app app/
docker run -p 5000:5000 devops-demo-app
```

## 📝 Autor
Gustavo Avila Gama
DevOps Engineer | gamagustavo.com.br

