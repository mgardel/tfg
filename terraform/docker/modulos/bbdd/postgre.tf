resource "docker_container" "postgres" {
  image        = var.image
  name         = var.name
  privileged = true
  command      = ["sh", "-c", "apt update && apt install -y openssh-server python3 && service ssh start && apt install -y isc-dhcp-client && ip addr flush dev eth0 && dhclient -v eth0 && sleep infinity"]

  provisioner "local-exec" {
  command       = <<EOT
    sleep 20 && \
    docker cp ${var.ssh_keys_path}/id_bastion.pub ${var.name}:/root/.ssh/ && \
    docker cp ${var.ssh_keys_path}/authorized_keys ${var.name}:/root/.ssh/ && \
    sleep 10 && \
    docker exec ${var.name} chown -R root:root /root/.ssh && \
    docker exec ${var.name} chmod 700 /root/.ssh && \
    docker exec ${var.name} chmod 644 /root/.ssh/id_bastion.pub && \
    docker exec ${var.name} chmod 600 /root/.ssh/authorized_keys
EOT
  }

  networks_advanced {
  name = var.network_name
  ipv4_address  = "192.168.0.4"
}


  env = [
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_passwd}",
    "POSTGRES_DB=${var.postgres_db}"
  ]

}