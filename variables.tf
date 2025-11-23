# variables.tf
variable "vm_username" {
  description = "Username for the VM user"
  type        = string
  default     = "adminuser"
}

variable "vm_password" {
  description = "Password for the VM user"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for the VM user"
  type        = string
}

variable "os_images" {
  description = "Map of OS configurations and their base images"
  type = map(object({
    image_path = string
    memory     = number
    vcpu       = number
    disk_size  = number
    cpu = optional(object({
      mode = optional(string, "host-model")
    }))
  }))
  default = {
    generic-ubuntu-jammy = {
      image_path = "/path/to/ubuntu-cloud-image.img"
      memory     = 2048
      vcpu       = 2
      disk_size  = 10737418240 # 10GB
    }

    generic-debian-bookworm = {
      image_path = "/path/to/debian-cloud-image.img"
      memory     = 2048
      vcpu       = 2
      disk_size  = 10737418240 # 10GB
    }

    generic-fedora-40 = {
      image_path = "/path/to/fedora-cloud-image.img"
      memory     = 2048
      vcpu       = 2
      disk_size  = 10737418240 # 10GB
    }

    rocky-10 = {
      image_path = "/path/to/rocky-cloud-image.img"
      memory     = 3072
      vcpu       = 2
      disk_size  = 21474836480 # 20GB
      cpu = {
        mode = "host-passthrough" # safest for RHEL9 family
        # mode = ""       # alternative if you prefer migration safety
      }
    }

    centos-stream-10 = {
      image_path = "path/to/centos-cloud-image.img"
      memory     = 3072
      vcpu       = 2
      disk_size  = 21474836480 # 20GB
      cpu = {
        mode = "host-passthrough"
      }
    }
  }
}

# Example of a more advanced config (if you ever need it)
# almalinux-9-custom = {
#   image_path = "..."
#   memory     = 4096
#   vcpu       = 4
#   disk_size  = 32212254720
#   cpu = {
#     mode     = "custom"
#     match    = "exact"
#     model    = "EPYC-Rome"
#     features = ["pcid", "spec-ctrl", "ibpb", "ssbd"]
#   }
# }
