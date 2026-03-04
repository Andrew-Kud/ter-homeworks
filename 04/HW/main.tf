#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}



locals {
  ssh_public_key = file(var.ssh_public_key_file)
  userdata = templatefile("${path.module}/cloud-init.yml", {
    username       = var.username
    ssh_public_key = local.ssh_public_key
    packages = jsonencode(var.packages)
  })
}


#best practice
# locals {
#   ssh_public_key = file(var.ssh_public_key_file)

#   userdata = yamlencode({
#     users = [{
#       name                = var.username
#       groups              = "sudo"
#       shell               = "/bin/bash"
#       sudo                = ["ALL=(ALL) NOPASSWD:ALL"]
#       ssh_authorized_keys = [local.ssh_public_key]
#     }]

#     package_update  = true
#     package_upgrade = false
#     packages        = var.packages
#   })
# }



#создаем подсеть
resource "yandex_vpc_subnet" "develop_a" {
  name           = "${var.vpc_name}-central1-a"
  zone           = var.default_zone_a
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr_a
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.vpc_name}-central1-b"
  zone           = var.default_zone_b
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr_b
}



module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = ["ru-central1-a","ru-central1-b"]
  subnet_ids     = [yandex_vpc_subnet.develop_a.id,yandex_vpc_subnet.develop_b.id]
  instance_name  = "webs"
  instance_count = 2
  image_family   = "ubuntu-2004-lts"
  public_ip      = true
  labels = {
    owner= "i.ivanov",
    project = "marketing"
  }
  metadata = {
    user-data          = local.userdata
    serial-port-enable = 1
  }
}


module "example-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "stage"
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [yandex_vpc_subnet.develop_a.id]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true
  labels = {
    owner= "i.ivanov",
    project = "analitycs"
  }
  metadata = {
    user-data          = local.userdata
    serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ для демонстрации №3
#data "template_file" "cloudinit" {
#  template = file("./cloud-init.yml")
#}
