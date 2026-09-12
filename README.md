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
| <a name="input_os_images"></a> [os\_images](#input\_os\_images) | Map of OS configurations and their base images | <pre>map(object({<br/>    image_path = string<br/>    memory     = number<br/>    vcpu       = number<br/>    disk_size  = number<br/>    cpu = optional(object({<br/>      mode = optional(string, "host-model")<br/>    }))<br/>  }))</pre> | see in [`variables.tf`][variables-tf] | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key for the VM user | `string` | n/a | yes |
| <a name="input_vm_password"></a> [vm\_password](#input\_vm\_password) | Password for the VM user | `string` | n/a | yes |
| <a name="input_vm_username"></a> [vm\_username](#input\_vm\_username) | Username for the VM user | `string` | `"adminuser"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_ips"></a> [vm\_ips](#output\_vm\_ips) | The IP addresses of the created VMs |

## Commands

```bash
ansible -m ping -i dynamic-inventory.py all -u ali
```

```bash
terraform validate
```

```bash
terraform fmt -recursive
```

```bash
terraform plan
```

```bash
terrafom apply
```

[variables-tf]: https://github.com/cod3mas0n/qemu-kvm-terraform/blob/main/variables.tf#L30-L61