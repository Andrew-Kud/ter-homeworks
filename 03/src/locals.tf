locals {
  public_key = file("~/.ssh/id_ed25519.pub")

  vm_metadata = {
    serial-port-enable = "true"
    ssh-keys           = "ubuntu:${local.public_key}"
  }
}