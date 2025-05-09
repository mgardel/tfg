variable "name" {
  description = "Nombre del docker dhcp"
  type        = string
}

variable "image" {
  description = "Imagen de docker"
  type        = string
}

variable "ip_address" {
  description = "IP del servidor DHCP"
  type        = string
}

variable "network_name" {
  description = "ID de la red Docker"
  type        = string
}
