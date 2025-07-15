
# Ansible Inventory Guide

When you initialize this project via `make init` an `./inventory.yml` file will be generated if one does not already exist.

**_Note:_** Once this local file is in place it cannot be overridden again by the command above. To create a new Ansible inventory file, remove or rename the existing `./inventory.yml` file beforehand.

## Host Groups

| Name | Description |
| ---  | ---         |
| `ndp_management` | VMs to create and configure from a VM template as management nodes capable of running code in this repository. |
| `ndp_vms` | VMs to create and configure from a VM template as boilerplate nodes. |

## Variables

All variables described below are required and many may be specified at the host group and host levels as well.

### Ansible Connection

| Name | Description | Specification Levels |
| ---  | ---         | ---                  |
| `ansible_user` | The user Ansible ‘logs in’ as. | inventory |
| `ansible_ssh_private_key_file` | The private key file Ansible uses during login. | inventory |
| `ansible_sudo_pass` | The password Ansible uses with `sudo`. | inventory |

### Proxmox

| Name | Description | Specification Levels |
| ---  | ---         | ---                  |
| `proxmox_api_host` | The target host URL of the Proxmox cluster API. | inventory |
| `proxmox_api_token_id` | The token ID used to authenticate with Proxmox API. | inventory |
| `proxmox_api_token_secret` | The token secret used when interacting with the Proxmox API. | inventory |
| `proxmox_api_user` | The password used to authenticate with Proxmox API. | inventory |
| `proxmox_node` | The Proxmox cluster node on which to operate. | inventory, host group, host |
| `proxmox_storage_pool` | The Proxmox storage pool. | inventory, host group, host |
| `proxmox_vm_cidr` | The CIDR for the VMs on Proxmox. Used by the firewall configuration of the `ndp_management` hosts. | inventory, host group, host |

### Additional

| Name | Description | Example | Specification Levels |
| ---  | ---         | ---     | ---                  |
| `dns_domains` | List of DNS domain(s) to apply to the `resolved` configuration. | `["dept.my.domain","my.domain"]` | inventory, host group, host |
| `firewall_ports` | List of firewall ports to apply (beyond SSH & monitoring). | `["80/tcp", "443/tcp"]` | inventory, host group, host |
| `firewall_trusted_ipsets` | List of trusted IP sets allowed as SSH sources for the `ndp_management` hosts (`ndp_vms` will only trust `ndp_management` hosts). | `["192.168.0.0/24", "10.0.0.0/24"]` | inventory, host group, host |
| `krb5_realm` | Kerberos realm to apply to the `sssd` configuration. | `ad.my.domain` | inventory, host group, host |
| `krb5_servers` | List of Kerberos servers to apply to the `sssd` configuration. | `["kdc1.my.domain:88","kdc2.my.domain:88"]` | inventory, host group, host |
| `ldap_search_base` | LDAP search base to apply to the `sssd` configuration. | `dc=dept,dc=my,dc=domain` | inventory, host group, host |
| `ldap_uris` | List of LDAP URIs to apply to the `sssd` configuration. | `["ldap://ldap.my.domain","ldap://ldap2.my.domain"]` | inventory, host group, host |
| `mail_relayhost` | Relayhost to apply to `postfix`. | `mail.my.domain` | inventory, host group, host |
| `mail_root_email` | The email setting to be applied to the host's `root` account. | `root@my.domain` | inventory, host group, host |
| `monitoring_cidr` | The source CIDR allowed access to the hosts for monitoring needs (e.g. Prometheus Node Exporter). | `192.168.0.0/24` | inventory, host group, host |
| `motd_body` | The Bash script used to generate the MOTD. | `printf "Lorem Ipsum"` | inventory, host group, host |
| `ssh_admin_group` | The group allowed SSH and provisioned with administrative `sudo` capabilities. | `myadmingroup` | inventory, host group, host |
| `ssh_allow_groups` | List of groups allowed SSH access. | `["mygroup"]` | inventory, host group, host |
| `sudoers` | List of users with administrative `sudo` capabilities. | `["user1","user2"]` | inventory, host group, host |
| `syslog_ipv4` | The IPv4 for a centralized Syslog server. | `192.168.0.22` | inventory, host group, host |
| `tanium_client_custom_tags` | List of custom tags to apply to the Tanium Client configuration. | `["tag1","tag2"]` | inventory, host group, host | inventory, host group, host |
| `tanium_client_download_endpoint` | Endpoint where the Tanium Client binary and data file may be found. | `https://mirror.my.domain/tanium` | inventory, host group, host |
| `vm_cpu_cores` | Number of CPU cores to apply to the virtual host. | `4` | inventory, host group, host |
| `vm_cpu_type` | Type of CPU to emulate on the virtual host. | `4` | inventory, host group, host |
| `vm_description` | Description to apply to the virtual host in Proxmox. | `My VM` |
| `vm_id` | ID of the virtual host. | `100` | inventory, host group, host |
| `vm_memory` | Amount of memory (in megabytes) to apply to the virtual host | `8192` | inventory, host group, host |
| `vm_network_adapters_mac_address` | MAC address for the virtual host's NIC. | `00:1A:2B:3C:4D:5E or 00-1A-2B-3C-4D-5E` | host |
| `vm_os_disk_size` | Disk size for the virtual host. | `10G` | inventory, host group, host |