###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

###

variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2404-lts"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v3"
}

variable "vm_preemptible" {
  type        = bool
  default     = true
}

variable "vm_disk_type" {
  type    = string
  default = "network-hdd"
}

###

variable "each_vm" {
  description = "Конфигурация DB"
  type = list(object({
    vm_name      = string
    cpu          = number
    ram          = number
    disk_volume  = number
    core_f       = number
  }))

  default = [
    {
      vm_name     = "main-db"
      cpu         = 4
      ram         = 4
      core_f      = 20
      disk_volume = 30
    },
    {
      vm_name     = "replica-db"
      cpu         = 2
      ram         = 2
      core_f      = 20
      disk_volume = 20
    }
  ]
}
