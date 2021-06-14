**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. Prepare network informations needed](#2-prepare-network-informations-needed)
  - [2.1. Find IP range](#21-find-ip-range)
- [3. Setup UDHCPD](#3-setup-udhcpd)
  - [3.1. Set busybox configuration](#31-set-busybox-configuration)
  - [3.2. Create UDHCPD configuration file](#32-create-udhcpd-configuration-file)
  - [3.3. Init script](#33-init-script)
- [4. Ressources](#4-ressources)

# 1. Introduction

In this tutorial, [UDHCPD](https://git.busybox.net/busybox/tree/networking/udhcp) from **Busybox** will be used.

# 2. Prepare network informations needed

**Under construction**

## 2.1. Find IP range

> More details here : https://www.baeldung.com/cs/get-ip-range-from-subnet-mask  
> If you get lazy : https://www.omnicalculator.com/other/ip-subnet

# 3. Setup UDHCPD

## 3.1. Set busybox configuration

**UDHCPD** applet must be enable :
- `networking/udhcp/UDHCPD` : **needed**
- `networking/udhcp/CONFIG_FEATURE_UDHCPD_BASE_IP_ON_MAC` : **optionnal**
> Under version 1.31.1, this will set those vars configs :
> - CONFIG_UDHCPD=y
> - CONFIG_FEATURE_UDHCPD_WRITE_LEASES_EARLY=y
> - CONFIG_DHCPD_LEASES_FILE="/var/lib/misc/udhcpd.leases"

## 3.2. Create UDHCPD configuration file

Configuration file for **UDHCPD** must be created and placed at `etc/udhcpd.conf`.  
A default configuration file can be found at : [busybox/udhcpd](https://udhcp.busybox.net/udhcpd.conf).  
Take a look at variables :
- `start` : First IP address to use
- `end` : Last IP address to use
- `interface` : Interface to use with the DHCP daemon
Others values can be left to default, documentation of each field can be found at : https://manpages.ubuntu.com/manpages/bionic/man5/udhcpd.conf.5.html.
> **Be carefull**, host IP address must be exclude !  
> An example is available under [udhcpd/udhcpd.conf](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/DHCP/Server/udhcpd/udhcpd.conf)

## 3.3. Init script 

To start DHCP Daemon at startup, a init script must be created in `/etc/init.d`.
> An example is available under [udhcpd/S46dhcp](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/DHCP/Server/udhcpd/S46dhcp).  
> Note that interfaces must be **up** before starting DHCP daemon.

# 4. Ressources

- Officials
  - https://www.unix.com/man-page/suse/8/udhcpd/
  - https://manpages.ubuntu.com/manpages/bionic/man5/udhcpd.conf.5.html
- Examples
  - [busybox/udhcpd.conf](https://udhcp.busybox.net/udhcpd.conf)
  - [yocto/init-busybox-udhcpd](https://git.yoctoproject.org/cgit.cgi/poky/plain/meta/recipes-core/busybox/files/busybox-udhcpd)
- Tutorials
  - UDHCPD
    - https://iotbytes.wordpress.com/configure-dhcp-server-on-microcore-tiny-linux/
    - https://blog-du-grouik.tinad.fr/post/2013/03/08/serveur-dhcp-vite-fait-sous-d%C3%A9bian
  - Network
    - https://www.baeldung.com/cs/get-ip-range-from-subnet-mask
    - https://www.omnicalculator.com/other/ip-subnet