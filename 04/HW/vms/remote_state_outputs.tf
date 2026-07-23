output "out" {

  value = concat(module.test-vm-1.fqdn, module.test-vm-2.fqdn)
}
