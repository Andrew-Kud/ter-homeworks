resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop_a" {
  name           = "${var.vpc_name}-a"
  zone           = var.vm_web_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_web_cidr
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-b"
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_db_cidr
}


# --- vw web ---
data "yandex_compute_image" "web-image" {
  family = var.vm_web_image_family
}
resource "yandex_compute_instance" "web" {
  name        = local.web_vm_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_resources.cores
    memory        = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.web-image.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_a.id
    nat       = true
  }

  metadata = {
    serial-port-enable = true
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}

# --- vw db ---
data "yandex_compute_image" "db-image" {
  family = var.vm_db_image_family
}
resource "yandex_compute_instance" "db" {
  name        = local.db_vm_name
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone
  resources {
    cores         = var.vm_db_resources.cores
    memory        = var.vm_db_resources.memory
    core_fraction = var.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.db-image.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = true
  }

  metadata = {
    serial-port-enable = true
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }

}
