locals {
  all_vms = concat(
    #count
    [for vm in yandex_compute_instance.web[*] : {
      name = vm.name
      id   = vm.id
      fqdn = "${vm.id}"
      internal_ip       = vm.network_interface[0].ip_address
      external_ip       = length(vm.network_interface[0].nat_ip_address) > 0 ? vm.network_interface[0].nat_ip_address : null
    }],

    #for_each
    [for name, vm in yandex_compute_instance.db : {
      name = name
      id   = vm.id
      fqdn = "${vm.id}"
      internal_ip       = vm.network_interface[0].ip_address
      external_ip       = length(vm.network_interface[0].nat_ip_address) > 0 ? vm.network_interface[0].nat_ip_address : null
    }],

    #single
    [{
      name = yandex_compute_instance.storage.name
      id   = yandex_compute_instance.storage.id
      fqdn = "${yandex_compute_instance.storage.id}"
      internal_ip       = yandex_compute_instance.storage.network_interface[0].ip_address
      external_ip       = length(yandex_compute_instance.storage.network_interface[0].nat_ip_address) > 0 ? yandex_compute_instance.storage.network_interface[0].nat_ip_address : null
    }],

    [{
      name = yandex_compute_instance.bastion.name
      id   = yandex_compute_instance.bastion.id
      fqdn = "${yandex_compute_instance.bastion.id}"
      internal_ip       = yandex_compute_instance.bastion.network_interface[0].ip_address
      external_ip       = length(yandex_compute_instance.bastion.network_interface[0].nat_ip_address) > 0 ? yandex_compute_instance.bastion.network_interface[0].nat_ip_address : null
    }]
  )

  bastion_vm = [for vm in local.all_vms : vm if vm.name == "bastion"][0]
  ssh_user   = "ubuntu"
}

output "all_vms" {
  value = local.all_vms
}

output "bastion" {
  value = local.bastion_vm
}

output "ssh_vm" {
  value = {
    for vm in local.all_vms : vm.name =>
      vm.name == "bastion" ?
      "ssh ${local.ssh_user}@${vm.external_ip}" :
      "ssh -J ${local.ssh_user}@${local.bastion_vm.external_ip} ${local.ssh_user}@${vm.internal_ip}"
  }
}
