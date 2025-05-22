source "proxmox-iso" "ubuntu-server-noble" {

  # Connection Configuration
  proxmox_url               = "${var.proxmox_url}"
  username                  = "${var.proxmox_user}"
  password                  = "${var.proxmox_password}"
  insecure_skip_tls_verify  = "true"
  node                      = "${var.proxmox_node}"
  task_timeout              = "1m"

  # Location Configuration
  vm_name                   = "${var.vm_name_ubuntu}"
  vm_id                     = "${var.vm_id}"

  # Boot Configuration
  bios                      = "ovmf"
  boot_command = [
    "<spacebar><wait>",
    "e<wait>",
    "<down><down><down><end>",
    " autoinstall 'ds=nocloud;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ip=dhcp",
    "<f10>"
  ]
  boot_wait                 = "5s"
  boot_iso {          
    type                    = "scsi"
    iso_checksum            = "file:https://releases.ubuntu.com/24.04/SHA256SUMS"
    iso_file                = "local:iso/ubuntu-24.04.2-live-server-amd64.iso"
    unmount                 = true
  }
  efi_config {
    efi_storage_pool        = "${var.proxmox_storage_pool}"
    efi_format              = "raw"
    efi_type                = "4m"
  }
  # machine                   = "pc"

  # Communicator Configuration
  communicator              = "ssh"
  ssh_username              = "${var.linuxadmin_username}"
  ssh_password              = "${var.linuxadmin_password}"
  ssh_handshake_attempts    = "20"
  ssh_pty                   = true
  ssh_timeout               = "300m"

  # Hardware Configuration
  cpu_type                  = "${var.vm_cpu_type}"
  sockets                   = "${var.vm_cpu_sockets}"
  cores                     = "${var.vm_cpu_cores}"
  memory                    = "${var.vm_memory}"

  # VM Configuration
  disks {
    type                    = "scsi"
    disk_size               = "${var.vm_os_disk_size}"
    storage_pool            = "${var.proxmox_storage_pool}"
    format                  = "raw"
  }
  network_adapters {
    model                   = "${var.vm_network_adapters_model}"
    mac_address             = "${var.vm_network_adapters_mac_address}"
    mtu                     = 0
    bridge                  = "${var.vm_network_adapters_bridge}"
    vlan_tag                = "${var.vm_network_adapters_vlan_tag}"
    firewall                = false
  }
  os                        = "l26"
  qemu_agent                = "true"
  scsi_controller           = "virtio-scsi-pci"
  template_name             = "${var.vm_name_ubuntu}"
  template_description      = "${var.vm_description_ubuntu}"
  vga {
    type                    =  "std"
  }

  # Http directory Configuration
  http_directory            = "http"
  http_port_max             = 9000
  http_port_min             = 9000

}
