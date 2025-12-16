# main.tf

# Define base volumes for different OS images
resource "libvirt_volume" "base_volumes" {
  for_each = var.os_images
  name     = "${each.key}-base"
  source   = each.value.image_path
  pool     = "default"
}

# Create VM volumes from base images
resource "libvirt_volume" "vm_volumes" {
  for_each       = var.os_images
  name           = "${each.key}-volume"
  base_volume_id = libvirt_volume.base_volumes[each.key].id
  pool           = "default"
  size           = each.value.disk_size
}

# Cloud-init configs for each OS
resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each = var.os_images
  name     = "cloudinit-${each.key}.iso"
  user_data = templatefile("${path.module}/cloud-inits/${each.key}.yaml", {
    hostname = "${each.key}"
  })
  pool = "default"
}

# Create the VMs
resource "libvirt_domain" "vm" {
  for_each   = var.os_images
  name       = each.key
  memory     = each.value.memory
  vcpu       = each.value.vcpu
  qemu_agent = true

  # Conditional CPU block – works because all attributes are optional in the provider
  cpu {
    mode = try(each.value.cpu.mode, null) # null = libvirt default
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit[each.key].id

  network_interface {
    network_name   = "terraform-network"
    wait_for_lease = true
    hostname       = each.key
  }

  disk {
    volume_id = libvirt_volume.vm_volumes[each.key].id
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }


}
