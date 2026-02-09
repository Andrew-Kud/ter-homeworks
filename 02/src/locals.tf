locals {
  web_vm_name = "${var.vpc_name}-web-${var.vm_web_platform_id}"
  db_vm_name  = "${var.vpc_name}-db-${var.vm_web_platform_id}"

vms_metadata = {
    serial-port-enable = "true"
    ssh-keys           = "ubuntu:${var.vms_ssh_root_key}"
  }
}
