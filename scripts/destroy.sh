#!/bin/bash

set -e

echo "🧹 Destruindo infraestrutura..."

# Vai para o diretório do projeto
cd "$(dirname "$0")/.."

cd terraform
terraform destroy -auto-approve

echo "🧽 Limpando recursos Docker órfãos..."
docker system prune -f

echo "✅ Infraestrutura removida com sucesso!"

