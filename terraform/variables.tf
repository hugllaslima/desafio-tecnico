
variable "app_name" {
  description = "Nome da aplicação"
  type        = string
  default     = "desafio-devops"
}

variable "environment" {
  description = "Ambiente de deploy"
  type        = string
  default     = "development"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "postgres"
}

variable "db_user" {
  description = "Usuário do banco de dados"
  type        = string
  default     = "postgres"
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  default     = "postgres123"
  sensitive   = true
}

variable "app_port" {
  description = "Porta externa da aplicação"
  type        = number
  default     = 8080
}

variable "backend_port" {
  description = "Porta interna do backend"
  type        = number
  default     = 3000
}

variable "postgres_port" {
  description = "Porta do PostgreSQL"
  type        = number
  default     = 5432
}

variable "docker_host" {
  description = "Docker host"
  type        = string
  default     = "unix:///var/run/docker.sock"
}
