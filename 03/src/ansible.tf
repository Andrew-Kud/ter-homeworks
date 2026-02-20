locals {

#с внешним ip
#  web_inventory = [for vm in yandex_compute_instance.web[*] :
#    "${vm.name} ansible_host=${vm.network_interface[0].nat_ip_address} fqdn=${vm.id}"
#  ]

  web_inventory = [for vm in yandex_compute_instance.web[*] :
    "${vm.name} ansible_host=${vm.network_interface[0].ip_address} fqdn=${vm.id}"
  ]

  db_inventory = [for name, vm in yandex_compute_instance.db :
    "${name} ansible_host=${vm.network_interface[0].ip_address} fqdn=${vm.id}"
  ]

#  storage_inventory = ["${yandex_compute_instance.storage.name} ansible_host=${yandex_compute_instance.storage.network_interface[0].nat_ip_address} fqdn=${yandex_compute_instance.storage.id}.auto.internal"]

  storage_inventory = length(yandex_compute_instance.storage[*]) > 0 ? [
    for vm in yandex_compute_instance.storage[*] :
    "${vm.name} ansible_host=${vm.network_interface[0].ip_address} fqdn=${vm.id}"
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
ansible_ssh_common_args = '-o ProxyCommand="ssh -W %h:%p -i ~/.ssh/id_ed25519 ubuntu@${yandex_compute_instance.bastion.network_interface[0].nat_ip_address}"'
EOT
  filename = "${path.module}/inventory.ini"
}

###
variable "provision_ansible" {
  type    = bool
  default = true
  description = "Run Ansible playbook after VM creation"
}

resource "null_resource" "ansible_provision" {
  count = var.provision_ansible ? 1 : 0

  depends_on = [
    local_file.ansible_inventory,
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    yandex_compute_instance.storage,
    yandex_compute_instance.bastion
  ]

  provisioner "local-exec" {
    command = "eval $(ssh-agent) && ssh-add ~/.ssh/id_ed25519"
    on_failure = continue
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.ini test.yml"
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    on_failure = continue
  }

  triggers = {
    inventory_hash = filesha256(local_file.ansible_inventory.filename)
    playbook_hash  = filesha256("${path.module}/test.yml")
  }
}