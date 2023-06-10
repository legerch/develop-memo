This file will resume how to create an access point, also called **AP Mode**.

> Quick memo (only for my own config), files involved for this mode:
> - `etc/network/interfaces`
> - `etc/init.d/S40netwkork` (load drivers)
> - `etc/init.d/S41dhcp` (start DHCP server)
> - `etc/init.d/S42ap` (start hostapd access point from `hostapd.conf`) 
> - `etc/init.d/S98apcheck` (verify AP is enabled, backup if none)

**Table of contents:**
- [1. Driver support](#1-driver-support)
- [2. Setup interface](#2-setup-interface)
- [3. Setup hostapd](#3-setup-hostapd)
- [4. Setup DHCP server](#4-setup-dhcp-server)
- [5. Hostapd client](#5-hostapd-client)
- [6. Ressources used](#6-ressources-used)

# 1. Driver support

First, we need to verify that driver of our network interface support access point.  
Documentation have been written for some chipset, please check folder [documentation/drivers/wifi][repo-drivers-wifi].  
Then, don't forget to load needed drivers via `modprobe` utility (`modprobe -r` to unload)

# 2. Setup interface

1. Interface configuration via `/etc/network/interfaces` :
```shell
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet static
address 192.168.0.5
netmask 255.255.255.0
gateway 192.168.0.1
dns-nameservers 8.8.8.8 8.8.4.4 192.168.0.1
```
> Interface name `wlan0` may vary between chipsets, some required specific name to enable access point capabilities  
> For more details about `/etc/network/interfaces`, please see:
> - [Manpage _Interfaces_][doc-file-interfaces-manpage]

2. Enable interface
```shell
$ /sbin/ifdown -a
$ /sbin/ifup -a # Use /etc/network/interfaces file
```
> Some chipsets required more instructions before calling `ifdown/ifup` :
> - _Example :_ `iw dev mlan0 interface add uap0 type __ap # We should have : lo, mlan0 and uap0 with $ifconfig`.

# 3. Setup hostapd

1. Configure `/etc/hostapd.conf` (an example can be found at [hostapd example][repo-hostapd-conf-example])
2. Start **hostapd**
```shell
hostapd -B /etc/hostapd.conf
```
> `-B` here is for : _run daemon in the background_

# 4. Setup DHCP server

**DHCP server** will allow to give _IP addresses_ to devices connected to the generated access point, please refer to [DHCP server documentation][repo-dhcp-server] for more details.

# 5. Hostapd client

**Hostapd** provide similar behaviour than WPA Supplicant to be managed by external applications (like [hostapd_cli][doc-hostapd-cli]), please refer to [WPA Supplicant client section][repo-wpa-client] to understand principles.  
Library [libwpa_client][doc-wpa-supplicant-hostapd-lib] will also be used.
> Note:
> - Field `ctrl_interface` of `hostapd.conf` file must be set to use this feature

# 6. Ressources used

- Ubuntu
  - [Hostapd][doc-ubuntu-hostapd]
- Gentoo
  - [Hostapd][doc-gentoo-hostapd]
- Wikipedia :
  - [IEEE 802.11][doc-wiki-ieee80211]
  - [IEEE 802.11n][doc-wiki-ieee80211n]
  - [IEEE 802.11d][doc-wiki-ieee80211d] (used for `country_code` field)
  - [IEEE 802.11e][doc-wiki-ieee80211e] (used for **QoS** service)
  - [IEEE 802.11h][doc-wiki-ieee80211h] (used for **UNII2** and **UNII2-extended** support on 5GHz band)
- Others
  - [Hostapd - Configuration file details][doc-hostapd-conf-details]
- Threads
  - [StackExchange - How to set up wifi hotspot with 802.11n mode ?][thread-se-how-to-setup-wifi-hostspot-with-80211n-mode]

<!-- Repository links -->
[repo-hostapd-conf-example]: examples/hostapd.conf
[repo-wpa-client]: mode-sta.md
[repo-dhcp-server]: ../dhcp/server/
[repo-drivers-wifi]: ../../../Drivers/wifi/

<!-- External links -->
[doc-wiki-ieee80211]: https://fr.wikipedia.org/wiki/IEEE_802.11
[doc-wiki-ieee80211d]: https://fr.wikipedia.org/wiki/IEEE_802.11d
[doc-wiki-ieee80211n]: https://fr.wikipedia.org/wiki/IEEE_802.11n
[doc-wiki-ieee80211e]: https://en.wikipedia.org/wiki/IEEE_802.11e-2005
[doc-wiki-ieee80211h]: https://en.wikipedia.org/wiki/IEEE_802.11h-2003

[doc-file-interfaces-manpage]: https://man.cx/interfaces(5)

[doc-gentoo-hostapd]: https://wiki.gentoo.org/wiki/Hostapd
[doc-ubuntu-hostapd]: https://doc.ubuntu-fr.org/hostapd

[doc-hostapd-conf-details]: https://w1.fi/cgit/hostap/plain/hostapd/hostapd.conf
[doc-wpa-supplicant-hostapd-lib]: https://w1.fi/wpa_supplicant/devel/hostapd_ctrl_iface_page.html

[doc-hostapd-cli]: https://manpages.debian.org/stretch/hostapd/hostapd_cli.1.en.html

[thread-se-how-to-setup-wifi-hostspot-with-80211n-mode]: https://unix.stackexchange.com/questions/184175/how-to-set-up-wifi-hotspot-with-802-11n-mode