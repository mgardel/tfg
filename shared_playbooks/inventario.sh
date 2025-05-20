#!/bin/bash

# Nombre del fichero de inventario
INVENTORY_FILE="/home/miguel/Escritorio/tfg/shared_playbooks/ansible_inventory.ini"

# Obtener nombres de contenedores
containers=$(docker ps --format '{{.Names}}')

# Inicializar inventarios por grupo
cat > "$INVENTORY_FILE" << EOF
[bridge_network]

[dhcp]

[bastion]

[debian]

[ubuntu]

[bbdd]
EOF

for name in $containers; do
  # Saltar contenedores que no están en la red bridge_network
  if ! docker inspect "$name" | grep -q "bridge_network"; then
    continue
  fi

  # Obtener la IP real desde dentro del contenedor
  ip=$(docker exec "$name" hostname -I 2>/dev/null | awk '{print $1}')

  if [[ -z "$ip" ]]; then
    echo "No se pudo obtener IP para $name"
    continue
  fi

  entry="$name ansible_host=$ip ansible_user=root ansible_ssh_private_key_file=/root/.ssh/id_bastion ansible_python_interpreter=/usr/bin/python3"

  # Añadir siempre al grupo bridge_network
  sed -i "/^\[bridge_network\]/a $entry" "$INVENTORY_FILE"

  # Añadir también a su grupo específico si aplica
  if [[ "$name" == *"bastion"* ]]; then
    sed -i "/^\[bastion\]/a $entry" "$INVENTORY_FILE"
  elif [[ "$name" == *"dhcp_server"* ]]; then
    sed -i "/^\[dhcp\]/a $entry" "$INVENTORY_FILE"
  elif [[ "$name" == *"debian"* ]]; then
    sed -i "/^\[debian\]/a $entry" "$INVENTORY_FILE"
  elif [[ "$name" == *"ubuntu"* ]]; then
    sed -i "/^\[ubuntu\]/a $entry" "$INVENTORY_FILE"
  elif [[ "$name" == *"postgresql"* ]] || [[ "$name" == *"bbdd"* ]]; then
    sed -i "/^\[bbdd\]/a $entry" "$INVENTORY_FILE"
  fi
done

