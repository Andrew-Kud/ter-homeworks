locals {
  all_vms = concat(
#count
    [for vm in yandex_compute_instance.web[*] : {
      name = vm.name
      id   = vm.id
      fqdn = "${vm.id}"
    }],

#for_ech
    [for name, vm in yandex_compute_instance.db : {
      name = name
      id   = vm.id
      fqdn = "${vm.id}"
    }],

#single
    [{
      name = yandex_compute_instance.storage.name
      id   = yandex_compute_instance.storage.id
      fqdn = "${yandex_compute_instance.storage.id}"
    }]
  )
}

#call function name
output "all_vms" {
  value = local.all_vms
}