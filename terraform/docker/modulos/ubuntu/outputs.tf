output "container_names" {
  value = docker_container.ubuntu[*].name
}