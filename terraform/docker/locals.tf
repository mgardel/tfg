locals {
  ssh_keys_path = "/home/miguel/ssh_keys/.ssh"
  command       = <<EOT
    sleep 30 && \
    docker cp ${local.ssh_keys_path}/id_bastion.pub {name_prefix}-{index}:/root/.ssh/ && \
    docker cp ${local.ssh_keys_path}/authorized_keys {name_prefix}-{index}:/root/.ssh/ && \
    sleep 5 && \
    docker exec {name_prefix}-{index} chown -R root:root /root/.ssh && \
    docker exec {name_prefix}-{index} chmod 700 /root/.ssh && \
    docker exec {name_prefix}-{index} chmod 644 /root/.ssh/id_bastion.pub && \
    docker exec {name_prefix}-{index} chmod 600 /root/.ssh/authorized_keys
EOT
}