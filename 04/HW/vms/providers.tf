# terraform {
#   required_providers {
#     yandex = {
#       source = "yandex-cloud/yandex"
#     }
#   }
#   required_version = "~>1.14"
# }

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.217"
    }
  }
}

provider "yandex" {
  #  token                    = var.token
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.authorized_key
  zone                     = var.default_zone
}
