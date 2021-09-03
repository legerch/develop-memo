**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. What is SPL ?](#2-what-is-spl-)
- [3. Host configuration](#3-host-configuration)
- [4. Load SPL file to target](#4-load-spl-file-to-target)
  - [4.1. Network configuration](#41-network-configuration)
  - [4.2. Load new SPL file](#42-load-new-spl-file)
- [5. Ressources](#5-ressources)

# 1. Introduction

This file resume how to update **SPL (Secondary Program Loader)** file of a board using **U-Boot**.

# 2. What is SPL ?

This post provide really complete answer of SPL/Bootloader management : [What is the use of SPL (secondary program loader)](https://stackoverflow.com/questions/31244862/what-is-the-use-of-spl-secondary-program-loader).
> As a memo :  
> Usually boot sequence of embedded board is next : `ROM code` -> `SPL` -> `U-Boot` -> `Kernel`  
> Actually it's very similar to PC boot, which is : `BIOS` -> `MBR` -> `GRUB` -> `Kernel`

# 3. Host configuration

Host device will gonna need a **TFTP server** (**The Trivial File Transfer Protocal**) : [Installing TFTP server](https://wiki.emacinc.com/wiki/Installing_TFTP_server)
> In our example, **TFTP** server will be configured to `/tftpboot`

# 4. Load SPL file to target

> Instructions below were written for Armadeus IMX8 board, some instructions can differ with an other board (because of custom script written by Armadeus).  
> See [Loading Images with U-Boot](https://wiki.emacinc.com/wiki/Loading_Images_with_U-Boot) for more details

## 4.1. Network configuration 

1. Plug micro-usb to the board and connect to the host
2. Start the board on _U-Boot_
   
3. Set host network interface related to u-boot target
```shell
HOST> ifconfig enp4s0u2u4c2 192.168.2.1       # Interface can also be "usbXYZ"
```

4. Configure _U-Boot_ to access network through USB
```shell
U-Boot> setenv ipaddr 192.168.2.2       # Target static IP address
U-Boot> setenv serverip 192.168.2.1     # TFTP server IP address
```

5. Check network configuration
```shell
U-Boot> ping 192.168.2.1
```

## 4.2. Load new SPL file

1. Download new **SPL** file :
```shell
U-Boot> run download_uboot_spl
```
> **SPL** file must be on the **TFTP** server.  
> For armadeus board, file must be named `rayplicker-v2-u-boot.spl`, so complete path is `/tftpboot/rayplicker-v2-u-boot.spl`

2. Write the file on eMMC :
```shell
U-Boot> run flash_uboot_spl
```

3. Reboot the board
   - Unplug alimentation cable
   - Plug alimentation cable and start the board : if **SPL** installation succeed, the board will start properly

# 5. Ressources

- Threads :
  - [What is the use of SPL (secondary program loader)](https://stackoverflow.com/questions/31244862/what-is-the-use-of-spl-secondary-program-loader)
- Tutorials :
  - [Installing TFTP server](https://wiki.emacinc.com/wiki/Installing_TFTP_server)
  - [Loading Images with U-Boot](https://wiki.emacinc.com/wiki/Loading_Images_with_U-Boot)
  - [How to Manually Set Your IP in Linux (including ip/netplan)](https://danielmiessler.com/study/manually-set-ip-linux/)
- Annexes :
  - https://wiki.osdev.org/Bootloader