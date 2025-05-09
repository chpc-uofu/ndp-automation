packer {
    required_version = ">= 1.10.0"

    required_plugins {
      proxmox-iso = {
        version = "~> 1"
        source  = "github.com/hashicorp/proxmox"
      }
    }

}
