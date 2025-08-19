output "application_url" {
  description = "URL da aplicação"
  value       = "http://localhost:8080"
}

output "frontend_network" {
  description = "Nome da rede frontend"
  value       = docker_network.frontend_network.name
}

output "backend_network" {
  description = "Nome da rede backend"
  value       = docker_network.backend_network.name
}
