# QEMU/KVM Terraform

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | 0.8.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | 0.8.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [libvirt_cloudinit_disk.cloudinit](https://registry.terraform.io/providers/dmacvicar/libvirt/0.8.1/docs/resources/cloudinit_disk) | resource |
| [libvirt_domain.vm](https://registry.terraform.io/providers/dmacvicar/libvirt/0.8.1/docs/resources/domain) | resource |
| [libvirt_volume.base_volumes](https://registry.terraform.io/providers/dmacvicar/libvirt/0.8.1/docs/resources/volume) | resource |
| [libvirt_volume.vm_volumes](https://registry.terraform.io/providers/dmacvicar/libvirt/0.8.1/docs/resources/volume) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_os_images"></a> [os\_images](#input\_os\_images) | Map of OS configurations and their base images | <pre>map(object({<br/>    image_path = string<br/>    memory     = number<br/>    vcpu       = number<br/>    disk_size  = number<br/>    cpu = optional(object({<br/>      mode = optional(string, "host-model")<br/>    }))<br/>  }))</pre> | <pre>{<br/>  "centos-stream-10": {<br/>    "cpu": {<br/>      "mode": "host-passthrough"<br/>    },<br/>    "disk_size": 21474836480,<br/>    "image_path": "/var/lib/libvirt/images/CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2",<br/>    "memory": 3072,<br/>    "vcpu": 2<br/>  },<br/>  "generic-debian-bookworm": {<br/>    "disk_size": 10737418240,<br/>    "image_path": "/path/to/debian-cloud-image.img",<br/>    "memory": 2048,<br/>    "vcpu": 2<br/>  },<br/>  "generic-fedora-40": {<br/>    "disk_size": 10737418240,<br/>    "image_path": "/path/to/fedora-cloud-image.img",<br/>    "memory": 2048,<br/>    "vcpu": 2<br/>  },<br/>  "generic-ubuntu-jammy": {<br/>    "disk_size": 10737418240,<br/>    "image_path": "/path/to/ubuntu-cloud-image.img",<br/>    "memory": 2048,<br/>    "vcpu": 2<br/>  },<br/>  "rocky-10": {<br/>    "cpu": {<br/>      "mode": "host-passthrough"<br/>    },<br/>    "disk_size": 21474836480,<br/>    "image_path": "/var/lib/libvirt/images/Rocky-10-GenericCloud-Latest.x86_64.qcow2",<br/>    "memory": 3072,<br/>    "vcpu": 2<br/>  }<br/>}</pre> | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key for the VM user | `string` | n/a | yes |
| <a name="input_vm_password"></a> [vm\_password](#input\_vm\_password) | Password for the VM user | `string` | n/a | yes |
| <a name="input_vm_username"></a> [vm\_username](#input\_vm\_username) | Username for the VM user | `string` | `"adminuser"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_ips"></a> [vm\_ips](#output\_vm\_ips) | The IP addresses of the created VMs |

ansible -m ping -i dynamic-inventory.py all -u ali

terraform validate
terraform fmt -recursive
terraform plan
terrafom apply
