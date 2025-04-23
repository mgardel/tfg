output "container_names" {
  value = docker_container.instance[*].name
}