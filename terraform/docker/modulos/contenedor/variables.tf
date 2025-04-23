variable "ssh_keys_path" {
  description = "Ruta a claves ssh"
  type        = string
}

variable "image" {
  description = "Imagen de docker"
  type        = string
}

variable "name_prefix" {
  description = "Prefijo del nombre del docker"
  type        = string
}

variable "command" {
  description = "comandos de locl-exec"
  type        = string
}

variable "instance_count" {
  description = "Numero de instancias a desplegar"
  type        = number
}