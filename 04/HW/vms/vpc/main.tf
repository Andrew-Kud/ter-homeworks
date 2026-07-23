resource "yandex_vpc_network" "network" {
  name = var.vpc_network_name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "${var.vpc_network_name}-${var.vpc_zone}"
  zone           = var.vpc_zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.vpc_cidr
}