# NDP Automation

Toolset for creating NDP templates on Proxmox via HashiCorp Packer and then deploying VMs from those templates using Ansible.

## Requirements

Ansible controller:
1. Python 3.12
1. [HashiCorp Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) v1.12 (or newer)
1. `sshpass` (for Ansible SSH config)
1. Open firewall port `9000/tcp` to limited audience (e.g. the IPs for the VMs to be provisioned).

## Steps
1. Initialize the project.

   ```console
   make init
   ```
1. Populate `./inventory.yml` with real-world hosts and variable values using [the inventory guide](./docs/inventory/README.md).
   * **Note:** Once this local file is in place it cannot be overridden again by the command above.
1. Build the VM template using Hashicorp Packer.

   ```console
   make build
   ```
1. Create clones from the VM template using Ansible.

   ```console
   make clone
   ```
1. Provision the clones using Ansible.

   ```console
   make provision
   ```

## Resources

HashiCorp Packer:
* [github: packer-proxmox-iso-templates](https://github.com/rkoosaar/packer-proxmox-iso-templates)
* [Proxmox ISO](https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/iso)
* [Create VM templates on Proxmox with Packer](https://medium.com/@saderi/create-vm-templates-on-proxmox-with-packer-84723b7e3919)
* [Ubuntu 24.04 Packer Template for VMware](https://www.virtualizationhowto.com/2024/04/ubuntu-24-04-packer-template-for-vmware/)
* [github: ChristianLempa/boilerplates](https://github.com/ChristianLempa/boilerplates)
* [Autoinstall configuration reference manual](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html)
* [curtin storage examples](https://curtin.readthedocs.io/en/latest/topics/storage.html#lvm)

Ansible:
* [Proxmox forums: Provision VM from template using ansible.](https://forum.proxmox.com/threads/provision-vm-from-template-using-ansible.130596/)
* [community.general.proxmox_kvm module](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_kvm_module.html)
* [community.general.proxmox_vm_info module](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_vm_info_module.html)
* [community.general.proxmox_disk module – Management of a disk of a Qemu(KVM) VM in a Proxmox VE cluster](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_disk_module.html)
* [community.general.lvol module – Configure LVM logical volumes](https://docs.ansible.com/ansible/latest/collections/community/general/lvol_module.html)
