resource "yandex_compute_instance" "db" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name        = each.value.vm_name
  zone        = var.default_zone
  platform_id = var.vm_platform_id
  folder_id   = var.folder_id

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_f
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.default.id
      size     = each.value.disk_volume
      type     = var.vm_disk_type
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = local.vm_metadata

}
