# main.tf

# Define base volumes for different OS images
resource "libvirt_volume" "base_volumes" {
  for_each = var.os_images
  name     = "${each.key}-base.qcow2"
  pool     = "default"
  format   = "qcow2"
  create = {
    content = {
      url = "file://${each.value.image_path}"
    }
  }
}

# Writable copy-on-write layer for the VM.
resource "libvirt_volume" "vm_volumes" {
  for_each = var.os_images
  name     = "${each.key}-volume.qcow2"
  pool     = "default"
  format   = "qcow2"
  capacity = each.value.disk_size
  backing_store = {
    path   = libvirt_volume.base_volumes[each.key].path
    format = "qcow2"
  }
}

# # Cloud-init seed ISO.
resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each = var.os_images
  name     = "${each.key}-cloudinit"
  # pool = "default"
  user_data = templatefile("${path.module}/cloud-inits/${each.key}.cfg", {
    username = var.vm_username
    ssh_key  = var.ssh_public_key
    password = var.vm_password
  })
  meta_data = yamlencode({
    instance-id    = "${each.key}"
    local-hostname = "${each.key}"
  })
}

# Upload the cloud-init ISO into the pool.
resource "libvirt_volume" "cloudinit" {
  for_each = var.os_images
  name     = "${each.key}-cloudinit.iso"
  pool     = "default"
  format   = "iso"
  create = {
    content = {
      url = "file://${libvirt_cloudinit_disk.cloudinit[each.key].path}"
    }
  }
}
resource "libvirt_domain" "vm" {
  for_each = var.os_images
  name     = each.key
  memory   = each.value.memory
  unit     = "MiB"
  vcpu     = each.value.vcpu
  type     = "kvm"

  os = {
    type    = "hvm"
    arch    = "x86_64"
    machine = "q35"
  }

  devices = {
    disks = [
      {
        source = {
          pool   = libvirt_volume.vm_volumes[each.key].pool
          volume = libvirt_volume.vm_volumes[each.key].name
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
      },
      {
        device = "cdrom"
        source = {
          pool   = libvirt_volume.cloudinit[each.key].pool
          volume = libvirt_volume.cloudinit[each.key].name
        }
        target = {
          dev = "sda"
          bus = "sata"
        }
        readonly = true
      }
    ]
    interfaces = [
      {
        type  = "network"
        model = "virtio"
        source = {
          network = "${var.network_name}"
        }
      }
    ]
    graphics = {
      vnc = {
        autoport = "yes"
        listen   = "127.0.0.1"
      }
    }
  }
  running = true
}
