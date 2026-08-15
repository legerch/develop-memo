**Table of contents:**
- [1. Installing Proxmox](#1-installing-proxmox)
- [2. Configure proxmox](#2-configure-proxmox)
  - [2.1. Repositories](#21-repositories)
- [3. Manage](#3-manage)
  - [3.1. Commands](#31-commands)
  - [3.2. Updates](#32-updates)

# 1. Installing Proxmox

1. Download [Proxmox ISO image][proxmox-isos]
2. Flash it to USB key using [Rufus][rufus-dl] or similar tool
3. Boot from USB device

| Name | Architecture | Key |
|:-:|:-:|:-:|
| AceMagic Kron Mini K1 | x86-64 | `F7` (or `ECHAP`) |

4. Network configuration

hostname: <customname>.home.arpa
ipaddress: adress outside our router dhcp range
gateway: router adress
dns server: router adress

# 2. Configure proxmox
## 2.1. Repositories

For personal usage, repositories but be configured (more details in the [documentation][proxmox-doc-repo]).  
Two repositories must be disabled (via `node -> updates -> repositories`):
- https://enterprise.proxmox.com/debian/pve
- https://enterprise.proxmox.com/debian/ceph-squid

One repository must be added by using `add -> selecting "no subscription"`:
- http://download.proxmox.com/debian/pve
   
# 3. Manage
## 3.1. Commands
Shutdown : `shutdown -h now`

## 3.2. Updates

Proxmox recommends using [_full-upgrade_][proxmox-doc-upd] process in order to update it:
```shell
apt update
apt full-upgrade
```

<!-- Links -->
[proxmox-doc-upd]: https://pve.proxmox.com/pve-docs/chapter-sysadmin.html#system_software_updates
[proxmox-doc-repo]: https://pve.proxmox.com/pve-docs/chapter-sysadmin.html#sysadmin_enterprise_repo
[proxmox-isos]: https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso
[rufus-dl]: https://rufus.ie/en/#download