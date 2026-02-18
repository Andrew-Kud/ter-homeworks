resource "yandex_compute_disk" "additional" {
  count = 3

  name     = "disk-${count.index + 1}"
  zone     = var.default_zone
  folder_id = var.folder_id
  size     = 1
  type     = "network-hdd"
}


resource "yandex_compute_instance" "storage" {
  name        = "storage"
  zone        = var.default_zone
  platform_id = var.vm_platform_id
  folder_id   = var.folder_id

  resources {
    cores         = var.vm_resource.vm1.cores
    memory        = var.vm_resource.vm1.memory
    core_fraction = var.vm_resource.vm1.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.default.id
      size     = var.vm_resource.vm1.size
      type     = var.vm_resource.vm1.type
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

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.additional[*].id
    content {
      disk_id = secondary_disk.value
    }
  }
}