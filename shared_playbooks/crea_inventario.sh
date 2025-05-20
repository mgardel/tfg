#!/bin/bash

# Nombre del fichero de inventario
INVENTORY_FILE="/home/miguel/Escritorio/tfg/shared_playbooks/ansible_inventory.ini"

# Obtener nombres de contenedores
containers=$(docker ps --format '{{.Names}}')

# Inicializar inventarios por grupo
echo "[bridge_network]" > "$INVENTORY_FILE"
echo "" >> "$INVENTORY_FILE"
echo "[dhcp]" >> "$INVENTORY_FILE"
echo "" >> "$INVENTORY_FILE"
echo "[bastion]" >> "$INVENTORY_FILE"
echo "" >> "$INVENTORY_FILE"

for name in $containers; do
  # Saltar contenedores que no est√°n en la red bridge_network
  if ! docker inspect "$name" | grep -q "bridge_network"; then
    continue
  fi

  # Obtener la IP real desde dentro del contenedor
  ip=$(docker exec "$name" hostname -I 2>/dev/null | awk '{print $1}')

  if [[ -z "$ip" ]]; then
    echo "‚ö†Ô∏è  No se pudo obtener IP para $name"
    continue
  fi

  entry="$name ansible_host=$ip ansible_user=root ansible_ssh_private_key_file=/root/.ssh/id_bastion ansible_python_interpreter=/usr/bin/python3"

  if [[ "$name" == *"bastion"* ]]; then
    sed -i "/^\[bastion\]/a $entry" "$INVENTORY_FILE"
  elif [[ "$name" == *"dhcp_server"* ]]; then
    sed -i "/^\[dhcp\]/a $entry" "$INVENTORY_FILE"
  else
    sed -i "/^\[bridge_network\]/a $entry" "$INVENTORY_FILE"
  fi
done

echo "úÖ Inventario de Ansible actualizado en $INVENTORY_FILE"

