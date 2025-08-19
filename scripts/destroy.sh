cat > scripts/destroy.sh << 'EOF'
#!/bin/bash
set -e

echo "🧹 Destruindo infraestrutura..."

# Vai para o diretório do projeto
cd "$(dirname "$0")/.."

echo "📁 Navegando para diretório terraform..."
cd terraform

echo "🗑️ Destruindo recursos OpenTofu..."
tofu destroy -auto-approve

echo "🧽 Limpando recursos Docker órfãos..."
docker system prune -f

echo "📦 Removendo volumes não utilizados..."
docker volume prune -f

echo "🌐 Removendo redes não utilizadas..."
docker network prune -f

echo "✅ Infraestrutura removida com sucesso!"
EOF
