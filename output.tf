# Query the domain's interface addresses
# This data source can be used at any time to retrieve current IP addresses
# without blocking operations like Delete
data "libvirt_domain_interface_addresses" "vm_ip" {
  for_each = var.os_images
  domain   = libvirt_domain.vm[each.key].name
  source   = "lease" # optional: "lease" (DHCP), "agent" (qemu-guest-agent), or "any"
}

# Output all interface information
output "vm_interfaces" {
  value = {
    for key, vm in data.libvirt_domain_interface_addresses.vm_ip :
    key => vm.interfaces
  }
}
