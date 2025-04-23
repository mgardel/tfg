resource "docker_container" "postgres" {
  image        = var.image
  name         = var.name
  network_mode = "bridge"
  command      = ["sh", "-c", "apt update && apt install -y openssh-server python3 && service ssh start && sleep infinity"]

  provisioner "local-exec" {
    command = <<EOT
    ${replace(var.command, "{name_prefix}-{index}", "postgres")}
  EOT
  }

  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_passwd}",
    "POSTGRES_DB=${var.postgres_db}"
  ]

}