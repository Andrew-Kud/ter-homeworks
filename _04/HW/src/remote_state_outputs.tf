output "out" {
    value=concat(module.test-vm.fqdn , module.example-vm.fqdn)
}

output "out_passwd" {
    value={ for k,v in random_password.input_vms: k=>nonsensitive(v.result) }
}
