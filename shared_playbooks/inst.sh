#!/bin/bash

# Asegurarse de que el sistema esté actualizado
echo "Actualizando los paquetes del sistema..."
sudo apt-get update -y && sudo apt-get upgrade -y

# Instalar dependencias necesarias
echo "Instalando dependencias necesarias..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg2 lsb-release

# Instalar Docker
echo "Instalando Docker..."
# Añadir la clave GPG oficial de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Añadir el repositorio de Docker
echo "Añadiendo el repositorio de Docker..."
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Actualizar el índice de paquetes
sudo apt-get update -y

# Instalar Docker
echo "Instalando Docker..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Añadir el usuario al grupo Docker (para evitar usar sudo cada vez)
echo "Añadiendo el usuario al grupo docker..."
sudo usermod -aG docker $USER

# Instalar LazyDocker
echo "Instalando LazyDocker..."
curl -s https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | \
  jq -r '.assets[] | select(.name | test("Linux-x86_64")) | .browser_download_url' | \
  xargs wget -O lazydocker.tar.xz

# Extraer LazyDocker
tar -xf lazydocker.tar.xz

# Mover a un directorio en el PATH
sudo mv lazydocker /usr/local/bin/

# Verificar la instalación de LazyDocker
lazydocker --version

# Instalar Terraform
echo "Instalando Terraform..."
# Añadir el repositorio de HashiCorp
sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Añadir el repositorio de HashiCorp
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Actualizar el índice de paquetes
sudo apt-get update -y

# Instalar Terraform
sudo apt-get install -y terraform

# Verificar la instalación de Terraform
terraform -v

# Mensaje final
echo "¡Docker, LazyDocker y Terraform han sido instalados con éxito!"
echo "Recuerda reiniciar tu sesión para que los cambios de grupo (docker) tomen efecto."
