resource "docker_container" "instance" {
  count        = var.instance_count
  image        = var.image
  name         = "${var.name_prefix}-${count.index + 1}"
  network_mode = "bridge"
  command      = ["sh", "-c", "apt update && apt install -y openssh-server python3 && service ssh start && sleep infinity"]

  provisioner "local-exec" {
    command = <<EOT
    ${replace(replace(var.command, "{name_prefix}", var.name_prefix), "{index}", count.index + 1)}
  EOT
  }
}