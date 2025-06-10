# Proxmox related
variable "proxmox_url" {
  type    = string
  default = "https://xxxx:8006/api2/json"
}

variable "proxmox_user" {
  type      = string
  default   = "xxxx"
  sensitive = true
}

variable "proxmox_token" {
  type      = string
  default   = "supersecret"
  sensitive = true
}

variable "proxmox_node" {
  type    = string
  default = "xxxx"
}

variable "proxmox_storage_pool" {
  type    = string
  default = "xxxx"
}

# VM generic
variable "vm_cpu_sockets" {
  type    = number
  default = "1"
}

variable "vm_cpu_cores" {
  type    = number
  default = "2"
}

variable "vm_cpu_type" {
  type    = string
  default = "host"
}

variable "vm_id" {
  type    = number
  default = "9201"
}

variable "vm_memory" {
  type    = number
  default = "4096"
}

variable "vm_os_disk_size" {
  type    = string
  default = "10G"
}

variable "vm_network_adapters_mac_address" {
  type    = string
  default = ""
}

variable "vm_network_adapters_model" {
  type    = string
  default = "virtio"
}

variable "vm_network_adapters_bridge" {
  type    = string
  default = "vmbr1"
}

variable "vm_network_adapters_vlan_tag" {
  type    = number
  default = "1702"
}

# Ubuntu Specific
variable "linuxadmin_password" {
  type      = string
  default   = "supersecret"
  sensitive = true
}

variable "linuxadmin_username" {
  type      = string
  default   = "supersecret"
  sensitive = true
}

variable "vm_name_ubuntu" {
  type    = string
  default = "pkr-template-ubuntu"
}

variable "vm_description_ubuntu" {
  type    = string
  default = ""
}