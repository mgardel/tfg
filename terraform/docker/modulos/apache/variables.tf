variable "ssh_keys_path" {
  description = "Ruta a claves ssh"
  type        = string
}

variable "image" {
  description = "Imagen de docker"
  type        = string
}

variable "name" {
  description = "Nombre del docker"
  type        = string
}

variable "network_name" {
  description = "Nombre de la red"
  type        = string
}