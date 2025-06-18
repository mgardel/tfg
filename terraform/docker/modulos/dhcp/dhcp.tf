resource "docker_container" "dhcp_server" {
  name  = var.name
  image = var.image
  restart = "always"
  privileged = true

volumes {
  host_path      = abspath("${path.module}/dhcpd.conf")
  container_path = "/data/dhcpd.conf"
  read_only      = true
}

volumes {
  host_path      = abspath("${path.module}/leases")
  container_path = "/data"
}

  env = [
    "INTERFACES=eth0"
  ]

networks_advanced {
  name         = var.network_name
  ipv4_address = var.ip_address
}

  provisioner "local-exec" {
  command       = <<EOT
    sleep 5 && \
    docker cp /home/miguel/Escritorio/tfg/terraform/docker/modulos/dhcp/dhcpd.conf dhcp_server:/etc/dhcp/dhcpd.conf
    sleep 15 && \
    docker exec dhcp_server mkdir -p /root/.ssh && \
    docker cp ${var.ssh_keys_path}/id_bastion.pub dhcp_server:/root/.ssh/ && \
    docker cp ${var.ssh_keys_path}/authorized_keys dhcp_server:/root/.ssh/ && \
    sleep 25 && \
    docker exec dhcp_server chown -R root:root /root/.ssh && \
    docker exec dhcp_server chmod 700 /root/.ssh && \
    docker exec dhcp_server chmod 644 /root/.ssh/id_bastion.pub && \
    docker exec dhcp_server chmod 600 /root/.ssh/authorized_keys
EOT
  }

}
