#
# ---  WEB VM ---
#
variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2404-lts"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
}

variable "vm_web_resources" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
}

variable "vm_web_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "default_web_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

#
# --- DB VW ---
#
variable "vm_db_image_family" {
  type        = string
  default     = "ubuntu-2404-lts"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
}

variable "vm_db_resources" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "vm_db_preemptible" {
  type        = bool
  default     = true
}

variable "vm_db_zone" {
  type    = string
  default = "ru-central1-b"
}

variable "default_db_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
}