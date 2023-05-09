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

In this tutorial, [UDHCPD][udhcpd-git] from **Busybox** will be used.

# 2. Prepare network informations needed

**Under construction**

## 2.1. Find IP range

> More details here : [Get IP range from subnet mask][ip-range-doc]  
> If you get lazy : [IP subnet calculator][ip-range-calculator]

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
A default configuration file can be found at : [busybox/udhcpd.conf][udhcpd-conf-default].  
Take a look at variables :
- `start` : First IP address to use
- `end` : Last IP address to use
- `interface` : Interface to use with the DHCP daemon
Others values can be left to default, documentation of each field can be found at [Manpage udhcpd][udhcpd-doc-ubuntu].
> **Be carefull**, host IP address must be exclude !  
> An example is available under [udhcpd/udhcpd.conf][repo-udhcpd-conf-example]

## 3.3. Init script 

To start DHCP Daemon at startup, a init script must be created in `/etc/init.d`.
> An example is available under [udhcpd/S46dhcp][repo-udhcpd-script-init].  
> Note that interfaces must be **up** before starting DHCP daemon.

# 4. Ressources

- Officials
  - [udhcpd-doc-man]
  - [udhcpd-doc-ubuntu]
- Examples
  - [busybox/udhcpd.conf][udhcpd-conf-default]
  - [yocto/init-busybox-udhcpd][udhcpd-script-init-yocto]
- Tutorials
  - UDHCPD
    - [udhcpd-tutorial-iotbytes]
    - [udhcpd-tutorial-blog-grouik]
  - Network
    - [ip-range-doc]
    - [ip-range-calculator]

<!-- Ressources links -->
[repo-udhcpd-conf-example]: udhcpd.conf
[repo-udhcpd-script-init]: S46dhcp

[udhcpd-conf-default]: https://udhcp.busybox.net/udhcpd.conf
[udhcpd-doc-man]: https://www.unix.com/man-page/suse/8/udhcpd/
[udhcpd-doc-ubuntu]: https://manpages.ubuntu.com/manpages/bionic/man5/udhcpd.conf.5.html
[udhcpd-git]: https://git.busybox.net/busybox/tree/networking/udhcp
[udhcpd-script-init-yocto]: https://git.yoctoproject.org/cgit.cgi/poky/plain/meta/recipes-core/busybox/files/busybox-udhcpd

[udhcpd-tutorial-iotbytes]: https://iotbytes.wordpress.com/configure-dhcp-server-on-microcore-tiny-linux/
[udhcpd-tutorial-blog-grouik]: https://blog-du-grouik.tinad.fr/post/2013/03/08/serveur-dhcp-vite-fait-sous-d%C3%A9bian

[ip-range-doc]: https://www.baeldung.com/cs/get-ip-range-from-subnet-mask
[ip-range-calculator]: https://www.omnicalculator.com/other/ip-subnet