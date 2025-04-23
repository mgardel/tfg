#!/bin/bash
#
#Nombre fichero inventario
INVENTORY_FILE="/home/miguel/shared_playbooks/ansible_inventory.ini"

#Obtener lista de contenedores en red bridge
containers=$(docker network inspect bridge -f '{{range .Containers}}{{.Name}} {{.IPv4Address}}{{"\n"}}{{end}}')

#Crear archivo de inventario
echo "[bridge_network]" > $INVENTORY_FILE

#Añadir contenedores al inventario
while read -r container; do
	name=$(echo $container | awk '{print $1}')
	ip=$(echo $container | awk '{print $2}' | cut -d'/' -f1)
	if [[ "$name" != *"bastion"* ]];then
		echo "$name ansible_host=$ip ansible_user=root ansible_ssh_private_key_file=/root/.ssh/id_bastion ansible_python_interpreter=/usr/bin/python3" >> $INVENTORY_FILE
	else
		name_bastion=$name
		ip_bastion=$ip
	fi
done <<< "$containers"

echo "[bastion]" >> $INVENTORY_FILE
echo "$name_bastion ansible_host=$ip_bastion ansible_user=root ansible_ssh_private_key_file=/root/.ssh/id_bastion ansible_python_interpreter=/usr/bin/python3" >> $INVENTORY_FILE

echo "Inventario de ansible generado en $INVENTORY_FILE"
