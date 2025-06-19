
build {
  sources = ["source.proxmox-iso.ubuntu-server-noble" ]

  # # Clean up the machine
  # provisioner "shell" {
  #   execute_command = "echo '${var.proxmox_user}' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
  #   inline = [
  #     "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
  #     "sudo rm /etc/ssh/ssh_host_*",
  #     "sudo truncate -s 0 /etc/machine-id",
  #     "sudo apt -y autoremove --purge",
  #     "sudo apt -y clean",
  #     "sudo apt -y autoclean",
  #     # "sudo cloud-init clean",
  #     "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
  #     "sudo sync"
  #   ]
  # }
}
