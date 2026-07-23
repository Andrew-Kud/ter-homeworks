# #.1
# resource "yandex_vpc_network" "develop" {
#   name = var.vpc_name
# }


# #.2
# resource "yandex_vpc_subnet" "develop_a" {
#   name           = "${var.vpc_name}-central1-a"
#   zone           = var.default_zone_a
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = var.default_cidr_a
# }
# resource "yandex_vpc_subnet" "develop_b" {
#   name           = "${var.vpc_name}-central1-b"
#   zone           = var.default_zone_b
#   network_id     = yandex_vpc_network.develop.id
#   v4_cidr_blocks = var.default_cidr_b
# }


#.3
module "vpc_dev" {
  source           = "./vpc"
  vpc_network_name = var.vpc_network_name
  vpc_zone         = var.vpc_zone
  vpc_cidr         = var.vpc_cidr
}


#VM-1
module "test-vm-1" {
  source   = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name = "develop"
  #  network_id     = yandex_vpc_network.develop.id
  network_id   = module.vpc_dev.network_id
#  subnet_zones = ["ru-central1-a", "ru-central1-b"]
  subnet_zones = [var.vpc_zone]
  #  subnet_ids     = [yandex_vpc_subnet.develop_a.id, yandex_vpc_subnet.develop_b.id]
  subnet_ids     = [module.vpc_dev.subnet.id]
  instance_name  = "webs"
  instance_count = 1
  image_family   = "ubuntu-2404-lts-oslogin"
  public_ip      = true

  labels = {
    owner   = "a.test",
    project = "marketing"
  }

  # metadata = {
  #   user-data          = local.userdata
  #   serial-port-enable = 1
  # }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yml", {
      username       = var.username
      ssh_public_key = file(var.ssh_public_key)
      #      packages       = jsonencode(var.packages)
    })
    serial-port-enable = 1
  }

}
#VM-2
module "test-vm-2" {
  source   = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name = "stage"
  #  network_id     = yandex_vpc_network.develop.id
  network_id   = module.vpc_dev.network_id
#  subnet_zones = ["ru-central1-a"]
  subnet_zones = [var.vpc_zone]
  #  subnet_ids     = [yandex_vpc_subnet.develop_a.id]
  subnet_ids     = [module.vpc_dev.subnet.id]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = "ubuntu-2404-lts-oslogin"
  public_ip      = true

  # metadata = {
  #   user-data          = local.userdata
  #   serial-port-enable = 1
  # }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.yml", {
      username       = var.username
      ssh_public_key = file(var.ssh_public_key)
      #      packages       = jsonencode(var.packages)
    })
    serial-port-enable = 1
  }

  labels = {
    owner   = "b.test",
    project = "analytics"
  }

}

#Пример передачи cloud-config.
#data "template_file" "cloudinit" {
#  template = file("./cloud-init.yml")
#}
