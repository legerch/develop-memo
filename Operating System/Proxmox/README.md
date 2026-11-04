**Table of contents:**
- [1. Installing Proxmox](#1-installing-proxmox)
- [2. Configure proxmox](#2-configure-proxmox)
  - [2.1. Repositories](#21-repositories)
  - [2.2. Configure backups](#22-configure-backups)
    - [2.2.1. Configure rclone](#221-configure-rclone)
    - [2.2.2. Create backups Jobs](#222-create-backups-jobs)
    - [2.2.3. Access backups](#223-access-backups)
    - [2.2.4. Sync with rclone](#224-sync-with-rclone)
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
curl https://rclone.org/install.sh | bash
```
> [!WARNING]
> Don't use `apt install rclone` since package is very old (v1.60.1-DEV where we are today at 1.75.0)
> https://rclone.org/install/
> We could later update it with: rclone selfupdate

Then, perform the configuration via:
```shell
rclone config
```

Multiples steps configuration will appears, follow them.  
For **OneDrive**, we have some specifics behaviours:
- Client ID: simply skip it (use this [doc][rclone-doc-onedrive-key] if custom ID is required)
- Edit advanced config: to simply manage backups, we can skip this part
- Use auto config: Here, since we are on a headless remote session, we must answer **no** in order to open a web-browser on an other machine with rclone available on it.

### 2.2.2. Create backups Jobs

In order to easily restore our VMs in case of issues, we will use _Proxmox_ backup feature.  
To do so:
1. Go to: `datacenter -> backup -> add`
2. Fill backups properties in **General** tab
3. Don't forget to set retention

![img-prox-backup-setup]

### 2.2.3. Access backups

Backups are accessible via: 
- **GUI:** `Proxmox-node → local -> Backups`
- **Cmd:** `ls -lh /var/lib/vz/dump/`

![img-prox-backup-dir]

### 2.2.4. Sync with rclone

Create scheduled job tasks using _systemd timer_ ([french tutorial][tuto-systemd-timer]) instead of _cron_.

1. Define the **service** file (the task):
```shell
cat /etc/systemd/system/proxmox-sync-backups.service

[Unit]
Description=Sync Proxmox backups with rclone
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/bin/rclone sync /var/lib/vz/dump/ your_rclone_remote:Path/To/Proxmox/Backups/Dst/
```

2. Define the **timer** file (when):
```shell
cat /etc/systemd/system/proxmox-sync-backups.timer

[Unit]
Description=Synchronize Proxmox backups directory with external storage

[Timer]
# 3. Syntax: weedDay Year-Month-Day Hour:Minute:Second
# 4. Every day at 22:00:00 (10 PM)
OnCalendar=*-*-* 22:00:00

# 5. If instance is shutdown at that hour, setting "persistent" to true
# 6. allow to start the job at next reboot
Persistent=true

[Install]
WantedBy=timers.target
```

3. Reload _systemd_ with: `systemctl daemon-reload`
4. Activate timer with: `systemctl enable --now proxmox-sync-backups.timer`
5. Verify by checkig list of timers: `systemctl list-timers`
6. To test it without waiting: `systemctl start proxmox-sync-backups.service`
7. Check status: `systemctl status proxmox-sync-backups.service`
8. Verify log of the script: `journalctl -u proxmox-sync-backups.service`

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
[tuto-systemd-timer]: https://rdr-it.com/systemd-timer-une-alternative-moderne-a-cron/

<!-- Assets -->
[img-prox-backup-dir]: assets/proxmox_backup_directory.png
[img-prox-backup-setup]: assets/proxmox_backup_setup.png