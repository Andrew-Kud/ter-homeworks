resource "random_password" "mysql_root" {
  length      = 16
  special     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "mysql_wp" {
  length      = 16
  special     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = true
}

resource "docker_container" "mysql_wp" {
  image = docker_image.mysql.image_id
  name  = "mysql8_${random_password.random_string.result}"

  ports {
    internal = 3306
    external = 3306
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_wp.result}",
    "MYSQL_ROOT_HOST=%"
  ]

  restart = "always"
}