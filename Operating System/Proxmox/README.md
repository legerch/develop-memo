**Table of contents:**
- [1. Installing Proxmox](#1-installing-proxmox)
- [2. Configure proxmox](#2-configure-proxmox)
  - [2.1. Repositories](#21-repositories)
  - [2.2. Configure backups](#22-configure-backups)
    - [2.2.1. Configure rclone](#221-configure-rclone)
- [3. Manage](#3-manage)
  - [3.1. Updates](#31-updates)
  - [3.2. Useful commands](#32-useful-commands)

# 1. Installing Proxmox

1. Download [Proxmox ISO image][proxmox-isos]
2. Flash it to USB key using [Rufus][rufus-dl] or similar tool
3. Boot from USB device

| Name | Architecture | Key |
|:-:|:-:|:-:|
| AceMagic Kron Mini K1 | x86-64 | `F7` (or `ECHAP`) |

4. Network configuration

- Hostname: <customname>.home.arpa
- IP Address: adress outside our router dhcp range
- Gateway: router adress
- DNS server: router adress

# 2. Configure proxmox
## 2.1. Repositories

For personal usage, repositories must be configured (more details in the [documentation][proxmox-doc-repo]).  
Two repositories must be disabled (via `node -> updates -> repositories`):
- https://enterprise.proxmox.com/debian/pve
- https://enterprise.proxmox.com/debian/ceph-squid

One repository must be added by using `add -> selecting "no subscription"`:
- http://download.proxmox.com/debian/pve

## 2.2. Configure backups
### 2.2.1. Configure rclone

To save backups to cloud storage, we will use [rclone][rclone-home].  
We can install it with:
```shell
apt install rclone
```

Then, perform the configuration via:
```shell
rclone config
```

Multiples steps configuration will appears, follow them.  
For **OneDrive**, we have some specifics behaviours:
- Client ID: simply skip it (use this [doc][rclone-doc-onedrive-key] if custom ID is required)
- Edit advanced config: to simply manage backups, we can skip this part
- Use auto config: Here, since we are on a headless remote session, we must answer **no** in order to open a web-browser on an other machine with rclone available on it.

# 3. Manage
## 3.1. Updates

_Proxmox_ recommends using [_full-upgrade_][proxmox-doc-upd] process in order to update it:
```shell
apt update
apt full-upgrade
```

## 3.2. Useful commands

- Shutdown: `shutdown -h now`

<!-- Links -->
[proxmox-doc-upd]: https://pve.proxmox.com/pve-docs/chapter-sysadmin.html#system_software_updates
[proxmox-doc-repo]: https://pve.proxmox.com/pve-docs/chapter-sysadmin.html#sysadmin_enterprise_repo
[proxmox-isos]: https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso
[rclone-doc-onedrive-key]: https://rclone.org/onedrive/#getting-your-own-client-id-and-key
[rclone-home]: https://rclone.org/
[rufus-dl]: https://rufus.ie/en/#download