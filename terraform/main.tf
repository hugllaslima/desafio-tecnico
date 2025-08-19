terraform {
  required_version = ">= 1.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

# Redes Docker
resource "docker_network" "frontend_network" {
  name = "${var.app_name}-frontend-net"
}

resource "docker_network" "backend_network" {
  name = "${var.app_name}-backend-net"
  internal = true
}

# Volume para persistência do banco
resource "docker_volume" "postgres_data" {
  name = "${var.app_name}-postgres-data"
}

# Imagens Docker
resource "docker_image" "postgres" {
  name         = "postgres:15.8"
  keep_locally = false
}

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = false
}

# Build das imagens da aplicação
resource "docker_image" "frontend" {
  name = "${var.app_name}-frontend:latest"
  build {
    context    = "../"
    dockerfile = "docker/frontend/Dockerfile"
    tag        = ["${var.app_name}-frontend:latest"]
  }
}

resource "docker_image" "backend" {
  name = "${var.app_name}-backend:latest"
  build {
    context    = "../"
    dockerfile = "docker/backend/Dockerfile"
    tag        = ["${var.app_name}-backend:latest"]
  }
}

# Container PostgreSQL
resource "docker_container" "postgres" {
  name  = "${var.app_name}-postgres-db"
  image = docker_image.postgres.image_id
  
  env = [
    "POSTGRES_DB=${var.db_name}",
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_INITDB_ARGS=--encoding=UTF-8 --lc-collate=C --lc-ctype=C"
  ]
  
  ports {
    internal = var.postgres_port
    external = var.postgres_port
  }
  
  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
  
  volumes {
    host_path      = abspath("${path.root}/../app/database")
    container_path = "/docker-entrypoint-initdb.d"
    read_only      = true
  }
  
  networks_advanced {
    name = docker_network.backend_network.name
    aliases = ["postgres-db"]
  }
  
  restart = "unless-stopped"
  
  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U ${var.db_user} -d ${var.db_name}"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
  }
}

# Container Backend
resource "docker_container" "backend" {
  name  = "${var.app_name}-backend-api"
  image = docker_image.backend.image_id
  
  env = [
    "DB_HOST=postgres-db",
    "DB_PORT=${var.postgres_port}",
    "DB_USER=${var.db_user}",
    "DB_PASSWORD=${var.db_password}",
    "DB_NAME=${var.db_name}",
    "NODE_ENV=production",
    "PORT=${var.backend_port}"
  ]
  
  ports {
    internal = var.backend_port
    external = var.backend_port
  }
  
  networks_advanced {
    name = docker_network.backend_network.name
    aliases = ["backend-api"]  # ✅ Alias para nginx encontrar
  }
  
  depends_on = [docker_container.postgres]
  restart    = "unless-stopped"
  
  healthcheck {
    test     = ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:${var.backend_port}"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }
}

# Container Frontend
resource "docker_container" "frontend" {
  name  = "${var.app_name}-frontend-app"
  image = docker_image.frontend.image_id
  
  ports {
    internal = 80
    external = 3000
  }
  
  networks_advanced {
    name = docker_network.frontend_network.name
    aliases = ["frontend-app"]  # ✅ Alias para nginx encontrar
  }
  
  restart = "unless-stopped"
}

# Container Nginx (Proxy Reverso)
resource "docker_container" "nginx" {
  name  = "${var.app_name}-nginx-proxy"
  image = docker_image.nginx.image_id
  
  ports {
    internal = 80
    external = var.app_port
  }
  
  volumes {
    host_path      = abspath("${path.root}/../docker/nginx/nginx.conf")
    container_path = "/etc/nginx/nginx.conf"
    read_only      = true
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
