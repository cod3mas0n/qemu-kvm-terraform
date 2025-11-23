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

variable "network_name" {
  description = "Network for VM"
  type        = string
  default     = "default"
}

variable "os_images" {
  description = "Map of OS configurations and their base images"
  type = map(object({
    image_path = string
    memory     = number
    vcpu       = number
    disk_size  = number
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
  }
}
