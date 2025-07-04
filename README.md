# NDP Automation

Toolset for creating VMs using Ansible and PXE.

## Requirements

Ansible controller:
1. Python 3.12

## Steps
1. Initialize the project.

   ```console
   make init
   ```
1. Populate `./inventory.yml` with real-world hosts and variable values using [the inventory guide](./docs/inventory/README.md).
   * **Note:** Once this local file is in place it cannot be overridden again by the command above.
1. Create the VMs using Ansible and PXE.

   ```console
   make create
   ```
1. Provision the VMs using Ansible.

   ```console
   make provision
   ```

## Bugs

* [githug: Support VirtIO RNG to proxmox kvm module](https://github.com/ansible-collections/community.proxmox/issues/87)

## Resources

Ansible:
* [Proxmox forums: Provision VM from template using ansible.](https://forum.proxmox.com/threads/provision-vm-from-template-using-ansible.130596/)
* [community.general.proxmox_kvm module](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_kvm_module.html)
* [community.general.proxmox_vm_info module](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_vm_info_module.html)
* [community.general.proxmox_disk module – Management of a disk of a Qemu(KVM) VM in a Proxmox VE cluster](https://docs.ansible.com/ansible/latest/collections/community/general/proxmox_disk_module.html)
* [community.general.lvol module – Configure LVM logical volumes](https://docs.ansible.com/ansible/latest/collections/community/general/lvol_module.html)
