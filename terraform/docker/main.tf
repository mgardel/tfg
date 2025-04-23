module "bastion" {
  source        = "./modulos/bastion"
  image         = "ubuntu:latest"
  name          = "bastion"
  ssh_keys_path = local.ssh_keys_path
  providers = {
    docker = docker
  }
}

module "ubuntu" {
  source         = "./modulos/contenedor"
  instance_count = 2
  image          = "ubuntu:latest"
  name_prefix    = "ubuntu"
  ssh_keys_path  = local.ssh_keys_path
  command        = local.command
  providers = {
    docker = docker
  }
}

module "debian" {
  source         = "./modulos/contenedor"
  instance_count = 2
  image          = "debian:latest"
  name_prefix    = "debian"
  ssh_keys_path  = local.ssh_keys_path
  command        = local.command
  providers = {
    docker = docker
  }
}

module "postgres" {
  source          = "./modulos/bbdd"
  name            = "postgres"
  image           = "postgres:latest"
  ssh_keys_path   = local.ssh_keys_path
  command         = local.command
  postgres_user   = "miguel"
  postgres_passwd = "miguel"
  postgres_db     = "miguel"
  providers = {
    docker = docker
  }
}