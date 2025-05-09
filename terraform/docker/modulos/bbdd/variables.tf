variable "ssh_keys_path" {
  description = "Ruta a claves ssh"
  type        = string
}


variable "postgres_user" {
  description = "Usuario de postgresql"
  type        = string
}

variable "postgres_passwd" {
  description = "contra de postgresql"
  type        = string
}

variable "postgres_db" {
  description = "db de postgresql"
  type        = string
}

variable "image" {
  description = "Imagen de docker"
  type        = string
}

variable "name" {
  description = "Nombre del docker db"
  type        = string
}

variable "network_name" {
  description = "Nombre de la red"
  type        = string
}