# ----------------------------
# Red Docker personalizada
# ----------------------------
resource "docker_network" "bridge_network" {
  name   = "bridge_network"

  ipam_config {
    subnet  = "192.168.0.0/24"
    gateway = "192.168.0.1"
  }
}

# ----------------------------
# Módulo DHCP Server
# ----------------------------
module "dhcp" {
  source       = "./modulos/dhcp"
  name         = "dhcp_server"
  image        = "networkboot/dhcpd"
  ip_address   = "192.168.0.2"
  network_name = docker_network.bridge_network.id
  providers = {
    docker = docker
  }
}

# ----------------------------
# Bastion
# ----------------------------
module "bastion" {
  source        = "./modulos/bastion"
  image         = "ubuntu:latest"
  name          = "bastion"
  ssh_keys_path = local.ssh_keys_path
  network_name  = docker_network.bridge_network.name
  providers = {
    docker = docker
  }
}

# ----------------------------
# Ubuntu Clients
# ----------------------------
module "ubuntu" {
  source         = "./modulos/ubuntu"
  instance_count = 2
  image          = "ubuntu:latest"
  name_prefix    = "ubuntu"
  ssh_keys_path  = local.ssh_keys_path
  network_name   = docker_network.bridge_network.name
  providers = {
    docker = docker
  }
}

# ----------------------------
# Debian Clients
# ----------------------------
module "debian" {
  source         = "./modulos/debian"
  instance_count = 2
  image          = "debian:latest"
  name_prefix    = "debian"
  ssh_keys_path  = local.ssh_keys_path
  network_name   = docker_network.bridge_network.name
  providers = {
    docker = docker
  }
}

# ----------------------------
# Postgres Container
# ----------------------------
module "postgres" {
  source          = "./modulos/bbdd"
  name            = "postgres"
  image           = "postgres:latest"
  ssh_keys_path   = local.ssh_keys_path
  postgres_user   = "miguel"
  postgres_passwd = "miguel"
  postgres_db     = "miguel"
  network_name    = docker_network.bridge_network.name
  providers = {
    docker = docker
  }
}
