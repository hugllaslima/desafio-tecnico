output "application_url" {
  description = "URL da aplicação"
  value       = "http://localhost:${var.app_port}"
}

output "api_url" {
  description = "URL da API"
  value       = "http://localhost:${var.app_port}/api"
}

output "database_host" {
  description = "Host do banco de dados"
  value       = "${var.app_name}-postgres-db"
}

output "database_port" {
  description = "Porta do banco de dados"
  value       = var.postgres_port
}

output "container_names" {
  description = "Nomes dos containers criados"
  value = {
    nginx    = docker_container.nginx.name
    frontend = docker_container.frontend.name
    backend  = docker_container.backend.name
    postgres = docker_container.postgres.name
  }
}

output "network_names" {
  description = "Nomes das redes criadas"
  value = {
    frontend = docker_network.frontend_network.name
    backend  = docker_network.backend_network.name
  }
}

output "volume_names" {
  description = "Nomes dos volumes criados"
  value = {
    postgres_data = docker_volume.postgres_data.name
  }
}

output "docker_images" {
  description = "Imagens Docker utilizadas"
  value = {
    nginx    = docker_image.nginx.name
    postgres = docker_image.postgres.name
    frontend = docker_image.frontend.name
    backend  = docker_image.backend.name
  }
}

output "environment_info" {
  description = "Informações do ambiente"
  value = {
    app_name    = var.app_name
    environment = var.environment
    app_port    = var.app_port
  }
}

output "health_check_commands" {
  description = "Comandos para verificar saúde da aplicação"
  value = {
    application = "curl -f http://localhost:${var.app_port}"
    api         = "curl -f http://localhost:${var.app_port}/api"
    nginx       = "docker logs ${var.app_name}-nginx-proxy"
    backend     = "docker logs ${var.app_name}-backend-api"
    frontend    = "docker logs ${var.app_name}-frontend-app"
    postgres    = "docker logs ${var.app_name}-postgres-db"
  }
}
