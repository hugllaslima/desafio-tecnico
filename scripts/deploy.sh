cat > scripts/deploy.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Iniciando deploy da aplicação..."

# Verifica se OpenTofu está instalado
if ! command -v tofu &> /dev/null; then
    echo "❌ OpenTofu não encontrado. Por favor, instale primeiro."
    echo "📖 Instruções: https://opentofu.org/docs/intro/install/"
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

echo "🔧 Inicializando OpenTofu..."
tofu init

echo "📋 Validando configuração..."
tofu validate

echo "📊 Planejando infraestrutura..."
tofu plan -out=tfplan

echo "🏗️ Aplicando infraestrutura..."
tofu apply tfplan

echo "✅ Deploy concluído!"
echo "🌐 Aplicação disponível em: http://localhost:8080"
echo ""
echo "📋 Para verificar os containers:"
echo "   docker ps"
echo ""
echo "📋 Para ver logs:"
echo "   docker logs nginx-proxy"
echo "   docker logs backend-api"
echo "   docker logs frontend-app"
EOF
