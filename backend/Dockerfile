FROM node:18-alpine

WORKDIR /app

# Instala dependências
COPY package*.json ./
RUN npm ci --only=production

# Copia código fonte
COPY . .

# Expõe porta
EXPOSE 3000

# Comando para iniciar aplicação
CMD ["npm", "start"]
