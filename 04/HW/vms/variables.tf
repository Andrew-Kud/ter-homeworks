#vpc_name_#.1
variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


#network_#.2
variable "default_zone_a" {
  type    = string
  default = "ru-central1-a"
}
variable "default_zone_b" {
  type    = string
  default = "ru-central1-b"
}

variable "default_cidr_a" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}
variable "default_cidr_b" {
  type    = list(string)
  default = ["10.0.2.0/24"]
}


#vpc_#.3
variable "vpc_network_name" {
  type    = string
  default = "develop-module"
}
variable "vpc_zone" {
  type    = string
  default = "ru-central1-a"
}
variable "vpc_cidr" {
  type    = list(string)
  default = ["10.0.5.0/24"]
}


#cloud-init
variable "username" {
  type    = string
  default = "ubuntu"
}
variable "ssh_public_key" {
  type      = string
  sensitive = true
}
#variable "packages" {
#  type    = list(string)
#  default = ["vim", "nginx", "nano"]
#}


#providers
#variable "token" {
#  type = string
#}
variable "cloud_id" {
  type = string
}
variable "folder_id" {
  type = string
}
variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}
variable "authorized_key" {
  type = string
}
