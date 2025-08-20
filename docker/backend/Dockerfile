FROM node:18-alpine

WORKDIR /app

# Instala dependências
COPY app/backend/package*.json ./
RUN npm install --only=production

# Copia código fonte
COPY app/backend/ ./

# Expõe porta
EXPOSE 3000

# Comando para iniciar aplicação
CMD ["npm", "start"]
