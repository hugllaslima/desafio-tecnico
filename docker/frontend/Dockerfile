FROM node:18-alpine as builder

WORKDIR /app

# Copia package.json e instala dependências
COPY app/frontend/package*.json ./
RUN npm install


# Copia código fonte
COPY app/frontend/ ./

# Build da aplicação
RUN npm run build

# Serve com nginx
FROM nginx:alpine
COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /app/dist /usr/share/nginx/html

# Expõe porta
EXPOSE 80

# Comando para iniciar aplicação
CMD ["nginx", "-g", "daemon off;"]
