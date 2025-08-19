FROM node:18-alpine

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
COPY --from=0 /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
