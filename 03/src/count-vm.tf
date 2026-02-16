resource "yandex_compute_instance" "web" {
  count = 2

  name = "web-${count.index + 1}"
  zone = "ru-central1-b"
  platform_id = "standard-v3"

  resources {
    cores         = 2
    memory        = 1
    core_fraction = 20
    size          = 10
    type          = "network-hdd"
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"  # стандартный Ubuntu
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.default.id  # твоя подсеть
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example_dynamic.id]
  }
}
