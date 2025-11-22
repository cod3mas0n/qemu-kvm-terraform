# Output IP addresses
output "vm_ips" {
  value = {
    for key, vm in libvirt_domain.vm :
    key => vm.network_interface[0].addresses
  }
  description = "The IP addresses of the created VMs"
}
