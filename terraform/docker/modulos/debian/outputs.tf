output "container_names" {
  value = docker_container.debian[*].name
}