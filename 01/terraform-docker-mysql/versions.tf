terraform {
  required_version = "~> 1.14.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8"
    }
  }
}
