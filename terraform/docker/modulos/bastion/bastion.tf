# Contenedor para Ansible (Bastion)
resource "docker_container" "bastion" {
  image        = var.image
  name         = var.name
  privileged = true
  command      = ["sh", "-c", "apt update && apt install -y ansible vim && apt install -y isc-dhcp-client && ip addr flush dev eth0 && dhclient -v eth0 && sleep infinity"]

  provisioner "local-exec" {
    command = <<EOT
sleep 15 && \
docker cp ${var.ssh_keys_path} bastion:/root/.ssh && \
docker exec bastion chown -R root:root /root/.ssh && \
docker exec bastion chmod 700 /root/.ssh && \
docker exec bastion chmod 600 /root/.ssh/id_bastion && \
docker exec bastion chmod 644 /root/.ssh/id_bastion.pub && \
docker exec bastion chmod 600 /root/.ssh/authorized_keys 
docker exec bastion mkdir -p /etc/ansible && \
docker exec bastion touch /etc/ansible/ansible.cfg && \
docker exec bastion sh -c 'echo "[defaults]" > /etc/ansible/ansible.cfg' && \
docker exec bastion sh -c 'echo "inventory = /root/shared_playbooks/ansible_inventory.ini" >> /etc/ansible/ansible.cfg'
EOT
  }

  mounts {
    type   = "bind"
    source = "/home/miguel/Escritorio/tfg/shared_playbooks"
    target = "/root/shared_playbooks"
  }

  ports {
    internal = 22
    external = 2222
  }

  networks_advanced {
  name = var.network_name
  ipv4_address  = "192.168.0.3"
}

}