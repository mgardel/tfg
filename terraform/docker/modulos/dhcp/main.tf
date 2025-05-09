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
    sleep 20 && \
    docker cp /home/miguel/Escritorio/tfg/terraform/docker/modulos/dhcp/dhcpd.conf dhcp_server:/etc/dhcp/dhcpd.conf
EOT
  }

}
