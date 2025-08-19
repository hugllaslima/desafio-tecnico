variable "db_password" {
  description = "Password para o PostgreSQL"
  type        = string
  sensitive   = true
  default     = "senha_segura_123"
}

variable "db_user" {
  description = "Usuário do PostgreSQL"
  type        = string
  default     = "app_user"
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "app_db"
}
