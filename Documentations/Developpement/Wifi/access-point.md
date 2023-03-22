This file will resume how to create an access point.

**Table of contents :**
- [1. IEEE802.11 specifications](#1-ieee80211-specifications)
  - [1.1. Major protocols](#11-major-protocols)
  - [1.2. Useful amendment](#12-useful-amendment)
- [2. Configuration](#2-configuration)
  - [2.1. Driver support](#21-driver-support)
  - [2.2. Setup interface](#22-setup-interface)
  - [2.3. Setup hostapd](#23-setup-hostapd)
  - [2.4. Ressources used](#24-ressources-used)

# 1. IEEE802.11 specifications

[IEEE 802.11][doc-wiki-ieee80211] have gone through many specifications. We gonna describe some of them.

## 1.1. Major protocols

| Protocol | Alternative name | Creation date | Frequency (GHz) | Bandwith (MHz) | MIMO support |
|:-:|:-:|:-:|:-:|:-:|:-:|
| 802.11b | Wifi 1 | 1999 | 2.4 | 20 | :x: |
| 802.11a | Wifi 2 | 1999 | 5 | 5 / 10 / 20 | :x: |
| 802.11g | Wifi 3 | 2003 | 2.4 | 5 / 10 / 20 | :x: |
| 802.11n | Wifi 4 | 2009 | 2.4 / 5 | 20 / 40 | :heavy_check_mark: |
| 802.11ac | Wifi 5 | 2013 | 5 | 20 / 40 / 80 / 160 | :heavy_check_mark: |
| 802.11ax | Wifi 6 | 2021 | 2.4 / 5 | 20 / 40 / 80 | :heavy_check_mark: |
| 802.11ax | Wifi 6E | 2021 | 2.4 / 5 / 6 | 20 / 40 / 80 | :heavy_check_mark: |

## 1.2. Useful amendment


# 2. Configuration
## 2.1. Driver support

First, we need to verify that driver of our network interface support access point.  
Documentation have been written for some chipset, please check folder [documentation/drivers/wifi][doc-drivers-wifi].

## 2.2. Setup interface

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

2. Enable interface
```shell
$ /sbin/ifdown -a
$ /sbin/ifup -a # Use /etc/network/interfaces file
```
> Some chipsets required more instructions before calling `ifdown/ifup` :
> - _Example :_ `iw dev mlan0 interface add uap0 type __ap # We should have : lo, mlan0 and uap0 with $ifconfig`.

## 2.3. Setup hostapd

1. Configure `/etc/hostapd.conf` (an example can be found at [hostapd example][doc-hostapd-conf-example])
2. Start **hostapd**
```shell
hostapd -B /etc/hostapd.conf
```
> `-B` here is for : _run daemon in the background_

## 2.4. Ressources used

- Ubuntu
  - [Hostapd][doc-ubuntu-hostapd]
- Wikipedia :
  - [IEEE 802.11][doc-wiki-ieee80211]
  - [IEEE 802.11d][doc-wiki-ieee80211d]
  - [IEEE 802.11n][doc-wiki-ieee80211n]
  - [ISO 3166-1][doc-wiki-iso-3166-1] (use for `country_code` field)
- Others
  - [Hostapd - Configuration file details][doc-hostapd-conf-details]
  - [Wifi country code and channel division][doc-wifi-country-channel-division]
  - [802.11 b/g/n][doc-wifi-bgn-normes]
- Threads
  - [StackExchange - How to set up wifi hotspot with 802.11n mode ?][thread-se-how-to-setup-wifi-hostspot-with-80211n-mode]
- Useful apps
  - **Linux:**
    - [Sparrow-wifi][app-sparrow-wifi] : Sparrow-wifi has been built from the ground up to be the next generation 2.4 GHz and 5 GHz Wifi spectral awareness tool
  - **Windows:**
    - [Wifi Analyzer][app-wifi-analyzer]

<!-- Documentation links -->
[doc-hostapd-conf-example]: https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Wifi/examples/hostapd.conf
[doc-drivers-wifi]: https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Drivers/wifi

<!-- External links -->
[app-sparrow-wifi]: https://github.com/ghostop14/sparrow-wifi
[app-wifi-analyzer]: https://apps.microsoft.com/store/detail/wifi-analyzer/9NBLGGH33N0N?hl=fr-fr&gl=fr

[doc-ubuntu-hostapd]: https://doc.ubuntu-fr.org/hostapd

[doc-wiki-ieee80211]: https://fr.wikipedia.org/wiki/IEEE_802.11
[doc-wiki-ieee80211d]: https://fr.wikipedia.org/wiki/IEEE_802.11d
[doc-wiki-ieee80211n]: https://fr.wikipedia.org/wiki/IEEE_802.11n
[doc-wiki-iso-3166-1]: https://fr.wikipedia.org/wiki/ISO_3166-1

[doc-hostapd-conf-details]: https://w1.fi/cgit/hostap/plain/hostapd/hostapd.conf
[doc-wifi-country-channel-division]: https://chowdera.com/2021/01/20210128110913670Y.html
[doc-wifi-bgn-normes]: https://fr.ihowto.tips/did-you-know/ce-reprezinta-standardele-wi-fi-ieee-802-11a-802-11b-g-n-si-802-11ac-ale-unui-router-wireless.html

[thread-se-how-to-setup-wifi-hostspot-with-80211n-mode]: https://unix.stackexchange.com/questions/184175/how-to-set-up-wifi-hotspot-with-802-11n-mode
