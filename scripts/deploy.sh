#!/bin/bash

set -e

echo "🚀 Iniciando deploy da aplicação..."

# Verifica se Terraform está instalado
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform não encontrado. Por favor, instale primeiro."
    exit 1
fi

# Verifica se Docker está rodando
if ! docker info &> /dev/null; then
    echo "❌ Docker não está rodando. Inicie o Docker primeiro."
    exit 1
fi

# Vai para o diretório do projeto (assumindo que o script está em scripts/)
cd "$(dirname "$0")/.."

echo "📁 Navegando para diretório terraform..."
cd terraform

echo "🔧 Inicializando Terraform..."
terraform init

echo "📋 Validando configuração..."
terraform validate

echo "📊 Planejando infraestrutura..."
terraform plan -out=tfplan

echo "🏗️ Aplicando infraestrutura..."
terraform apply tfplan

echo "✅ Deploy concluído!"
terraform output
