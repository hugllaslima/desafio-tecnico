# Desafio Técnico

Este projeto implementa uma aplicação web completa usando infraestrutura como código com OpenTofu, Docker e conceitos de rede seguros.

🏗️ Arquitetura
Frontend: Aplicação React servida via Nginx
Backend: API Node.js com acesso restrito
Banco: PostgreSQL com volume persistente
Proxy: Nginx como proxy reverso
Redes: Segregação entre redes interna e externa

📋 Dependências Software Necessário:
Docker Engine 24.0+
Docker Compose 2.0+
OpenTofu 1.6+
Git
Instalação Ubuntu/Debian:
bash

# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# OpenTofu
curl -Lo tofu.deb https://github.com/opentofu/opentofu/releases/download/v1.6.0/tofu_1.6.0_linux_amd64.deb
sudo dpkg -i tofu.deb

🚀 Como Executar
1. Clone o repositório:
bash
Copiar

git clone <seu-repositorio>
cd desafio-devops
2. Execute o deploy:
bash
Copiar

chmod +x scripts/deploy.sh
./scripts/deploy.sh
3. Acesse a aplicação:
Frontend: http://localhost:8080
API: http://localhost:8080/api (apenas via proxy)
🛠️ Comandos Manuais
Inicializar infraestrutura:
bash
Copiar

cd terraform
tofu init
tofu plan
tofu apply
Verificar containers:
bash
Copiar

docker ps
docker network ls
docker volume ls
Logs dos serviços:
bash
Copiar

docker logs nginx-proxy
docker logs backend-api  
docker logs frontend-app
docker logs postgres-db
Destruir infraestrutura:
bash
Copiar

cd terraform
tofu destroy
🔒 Segurança
Rede interna: Backend e banco isolados
Rede externa: Apenas proxy e frontend expostos
Variáveis de ambiente: Credenciais seguras
Volumes: Dados persistentes e seguros
🔍 Troubleshooting
Aplicação não carrega:
bash
Copiar

# Verifique containers
docker ps -a

# Verifique redes
docker network inspect frontend-net backend-net

# Verifique logs
docker logs nginx-proxy
Banco não conecta:
bash
Copiar

# Teste conexão
docker exec -it postgres-db psql -U app_user -d app_db

# Verifique variáveis
docker inspect backend-api | grep -A 10 Env
7. Comandos Passo a Passo
Agora vou explicar cada comando em detalhes:

Comandos de Preparação:
bash
Copiar

# 1. Preparar diretório
mkdir desafio-devops && cd desafio-devops
# Cria pasta para o projeto e entra nela

# 2. Clonar recursos
git clone https://github.com/cubos-devops/desafio-tecnico.git resources
# Baixa os arquivos fornecidos no desafio

# 3. Copiar arquivos para estrutura
cp -r resources/* app/
# Organiza os arquivos na estrutura do projeto
Comandos OpenTofu:
bash
Copiar

# 1. Inicializar
tofu init
# Baixa providers necessários (Docker provider)
# Configura backend local para state

# 2. Validar
tofu validate  
# Verifica sintaxe dos arquivos .tf
# Confirma que configuração está correta

# 3. Planejar
tofu plan
# Mostra o que será criado/modificado
# Permite revisar antes de aplicar

# 4. Aplicar
tofu apply
# Executa as mudanças planejadas
# Cria toda a infraestrutura
Comandos Docker (explicação):
bash
Copiar

# Ver containers rodando
docker ps
# Lista todos os containers ativos

# Ver redes criadas  
docker network ls
# Mostra redes Docker (interna e externa)

# Inspecionar rede
docker network inspect backend-net
# Detalha configuração da rede interna

# Ver volumes
docker volume ls
# Lista volumes para persistência

# Logs de container
docker logs -f nginx-proxy
# Mostra logs em tempo real do proxy