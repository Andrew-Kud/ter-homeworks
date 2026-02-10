#.1
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}


#.2
resource "yandex_vpc_subnet" "develop_a" {
  name           = "${var.vpc_name}-a"
  zone           = var.vm_web_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_web_cidr
  route_table_id = yandex_vpc_route_table.nat_rt.id
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-b"
  zone           = var.vm_db_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_db_cidr
  route_table_id = yandex_vpc_route_table.nat_rt.id
}


#.3
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "${var.vpc_name}-nat"
  shared_egress_gateway {}
}


#.4
resource "yandex_vpc_route_table" "nat_rt" {
  network_id      = yandex_vpc_network.develop.id
  name            = "${var.vpc_name}-nat-rt"
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}


#.5-1
data "yandex_compute_image" "web-image" {
  family = var.vm_web_image_family
}
resource "yandex_compute_instance" "web" {
  name        = local.web_vm_name
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.web-image.image_id
      type     = var.vms_resources.web.type
      size     = var.vms_resources.web.size
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_a.id
    nat       = false
  }

  metadata = local.vms_metadata
}


#.5-2
data "yandex_compute_image" "db-image" {
  family = var.vm_db_image_family
}
resource "yandex_compute_instance" "db" {
  name        = local.db_vm_name
  platform_id = var.vm_db_platform_id
  zone        = var.vm_db_zone
  resources {
    cores         = var.vms_resources.db.cores
    memory        = var.vms_resources.db.memory
    core_fraction = var.vms_resources.db.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.db-image.image_id
      type     = var.vms_resources.db.type
      size     = var.vms_resources.db.size
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop_b.id
    nat       = false
  }

  metadata = local.vms_metadata
}
