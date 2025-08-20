FROM node:18-alpine as builder

WORKDIR /app

# Copia package.json e instala dependências
COPY package*.json ./
RUN npm ci --only=production

# Copia código fonte
COPY . .

# Build da aplicação
RUN npm run build

# Serve com nginx
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf

# Expõe porta
EXPOSE 80

# Comando para iniciar aplicação
CMD ["nginx", "-g", "daemon off;"]
