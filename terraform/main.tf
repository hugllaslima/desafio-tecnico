terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Redes
resource "docker_network" "frontend_network" {
  name = "frontend-net"
}

resource "docker_network" "backend_network" {
  name = "backend-net"
  internal = true
}

# Volume para persistência do banco
resource "docker_volume" "postgres_data" {
  name = "postgres-data"
}

# Imagens
resource "docker_image" "postgres" {
  name = "postgres:15.8"
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

# Frontend Image
resource "docker_image" "frontend" {
  name = "app-frontend:latest"
  build {
    context = "./app/frontend"
    dockerfile = "../../docker/frontend/Dockerfile"
  }
}

# Backend Image  
resource "docker_image" "backend" {
  name = "app-backend:latest"
  build {
    context = "./app/backend"
    dockerfile = "../../docker/backend/Dockerfile"
  }
}

# Container PostgreSQL
resource "docker_container" "postgres" {
  name  = "postgres-db"
  image = docker_image.postgres.image_id
  
  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]
  
  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
  
  volumes {
    host_path      = "${path.cwd}/app/database"
    container_path = "/docker-entrypoint-initdb.d"
  }
  
  networks_advanced {
    name = docker_network.backend_network.name
  }
  
  restart = "unless-stopped"
}

# Container Backend
resource "docker_container" "backend" {
  name  = "backend-api"
  image = docker_image.backend.image_id
  
  env = [
    "DB_HOST=postgres-db",
    "DB_PORT=5432",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}",
    "NODE_ENV=production"
  ]
  
  networks_advanced {
    name = docker_network.backend_network.name
  }
  
  depends_on = [docker_container.postgres]
  restart = "unless-stopped"
}

# Container Frontend
resource "docker_container" "frontend" {
  name  = "frontend-app"
  image = docker_image.frontend.image_id
  
  networks_advanced {
    name = docker_network.frontend_network.name
  }
  
  restart = "unless-stopped"
}

# Container Nginx (Proxy)
resource "docker_container" "nginx" {
  name  = "nginx-proxy"
  image = docker_image.nginx.image_id
  
  ports {
    internal = 80
    external = 8080
  }
  
  volumes {
    host_path      = "${path.cwd}/docker/nginx/nginx.conf"
    container_path = "/etc/nginx/nginx.conf"
  }
  
  networks_advanced {
    name = docker_network.frontend_network.name
  }
  
  networks_advanced {
    name = docker_network.backend_network.name
  }
  
  depends_on = [
    docker_container.frontend,
    docker_container.backend
  ]
  
  restart = "unless-stopped"
}
