locals {
  web_inventory = [for vm in yandex_compute_instance.web[*] :
    "${vm.name} ansible_host=${vm.network_interface[0].nat_ip_address} fqdn=${vm.id}.auto.internal"
  ]

  db_inventory = [for name, vm in yandex_compute_instance.db :
    "${name} ansible_host=${vm.network_interface[0].nat_ip_address} fqdn=${vm.id}.auto.internal"
  ]

#  storage_inventory = ["${yandex_compute_instance.storage.name} ansible_host=${yandex_compute_instance.storage.network_interface[0].nat_ip_address} fqdn=${yandex_compute_instance.storage.id}.auto.internal"]

  storage_inventory = length(yandex_compute_instance.storage[*]) > 0 ? [
    for vm in yandex_compute_instance.storage[*] :
    "${vm.name} ansible_host=${vm.network_interface[0].nat_ip_address} fqdn=${vm.id}.auto.internal"
  ] : []

}

resource "local_file" "ansible_inventory" {
  content = <<-EOT
[webservers]
${join("\n", local.web_inventory)}

[databases]
${join("\n", local.db_inventory)}

[storage]
${join("\n", local.storage_inventory)}

[all:vars]
ansible_user = ubuntu
ansible_ssh_private_key_file = "~/.ssh/id_ed25519"
EOT

  filename = "${path.module}/inventory.ini"
}
