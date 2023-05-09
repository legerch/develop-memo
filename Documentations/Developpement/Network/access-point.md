This file will resume how to create an access point.

**Table of contents :**
- [1. IEEE802.11 specifications](#1-ieee80211-specifications)
  - [1.1. Major protocols](#11-major-protocols)
  - [1.2. Useful amendments](#12-useful-amendments)
    - [1.2.1. 802.11d](#121-80211d)
    - [1.2.2. 802.11e](#122-80211e)
    - [1.2.3. 802.11h](#123-80211h)
  - [1.3. Band Channels](#13-band-channels)
    - [1.3.1. 2.4GHz](#131-24ghz)
    - [1.3.2. 5GHz](#132-5ghz)
- [2. Create an access point](#2-create-an-access-point)
  - [2.1. Driver support](#21-driver-support)
  - [2.2. Setup interface](#22-setup-interface)
  - [2.3. Setup hostapd](#23-setup-hostapd)
  - [2.4. Setup DHCP server](#24-setup-dhcp-server)
  - [2.5. Ressources used](#25-ressources-used)

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

## 1.2. Useful amendments
### 1.2.1. 802.11d

**IEEE 802.11d-2001** is an amendment to the IEEE 802.11 specification that adds support for "additional regulatory domains". This support includes the addition of a country information element to beacons (channels that can be used differs from one country to an other), probe requests, and probe responses.  

> **Hostapd keywork:** _ieee80211d_  
> **Availability:** With any protocols, any band

### 1.2.2. 802.11e

**IEEE 802.11e-2005** or **802.11e** is an amendment to the IEEE 802.11 standard that defines a set of _quality of service_ (QoS) enhancements for wireless LAN applications through modifications to the media access control (MAC) layer. The standard is considered of critical importance for delay-sensitive applications, such as **Voice over Wireless LAN** and **streaming multimedia**.  

In others words, when this amendment is enabled, priority is set to delay sensitive operation (like an ambulance on the highway).

> **Hostapd keyword:** _wmm_enabled_  
> **Availability:** With protocols **n/ac/ax**, any band

### 1.2.3. 802.11h

This amendment provides **Dynamic Frequency Selection (DFS)** and **Transmit Power Control (TPC)** for 5Ghz band. It addresses problems like interference with satellites and radar using the same 5 GHz frequency band. It was originally designed to address European regulations but is now applicable in many other countries.  
If **DFS** is not enabled, your device will only have access to **UNII-1** channels, see [band-5Ghz section][anchor-band-5ghz-channels] for more details.

> **Hostapd keyword:** _ieee80211h_  
> **Availability:** With protocols **n/ac/ax**, **5GHz** band

## 1.3. Band Channels
### 1.3.1. 2.4GHz

![List of 2.4GHz channels][asset-img-list-channel-24]

> **Source:** [List of WLAN channels][doc-wiki-list-wlan-channels]

### 1.3.2. 5GHz

![List of 5GHz channels][asset-img-list-channel-5]

> **Source:** [FR - Comprendre et configurer le DFS][doc-wifi-5-dfs-fr]  
> **Alternative:** [EN - Introduction to 5 GHz WiFi Channels][doc-wifi-5-dfs-en]

# 2. Create an access point
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

## 2.4. Setup DHCP server

**DHCP server** will allow to give _IP addresses_ to devices connected to the generated access point, please refer to [DHCP documentation][doc-dhcp] for more details.

## 2.5. Ressources used

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
  - [Wifi country code and channel division][doc-wifi-country-channel-division]
  - [802.11 b/g/n][doc-wifi-bgn-normes]
  - Understand 5GHz band
    - [FR - Comprendre et configurer le DFS][doc-wifi-5-dfs-fr]  
    - [EN - Introduction to 5 GHz WiFi Channels][doc-wifi-5-dfs-en]
- Threads
  - [StackExchange - How to set up wifi hotspot with 802.11n mode ?][thread-se-how-to-setup-wifi-hostspot-with-80211n-mode]
- Useful apps
  - **Linux:**
    - [Sparrow-wifi][app-sparrow-wifi] : Sparrow-wifi has been built from the ground up to be the next generation 2.4 GHz and 5 GHz Wifi spectral awareness tool
  - **Windows:**
    - [Wifi Analyzer][app-wifi-analyzer]

<!-- Anchor of this file -->
[anchor-band-5ghz-channels]: #132-5ghz

<!-- Asset ressources -->
[asset-img-list-channel-24]: images/list-channels-2.4GHz.png
[asset-img-list-channel-5]: images/list-channels-5GHz-background.png

<!-- Documentation links -->
[doc-hostapd-conf-example]: examples/hostapd.conf
[doc-dhcp]: ../DHCP/
[doc-drivers-wifi]: ../../Drivers/wifi/

<!-- External links -->
[app-sparrow-wifi]: https://github.com/ghostop14/sparrow-wifi
[app-wifi-analyzer]: https://apps.microsoft.com/store/detail/wifi-analyzer/9NBLGGH33N0N?hl=fr-fr&gl=fr

[doc-gentoo-hostapd]: https://wiki.gentoo.org/wiki/Hostapd
[doc-ubuntu-hostapd]: https://doc.ubuntu-fr.org/hostapd

[doc-wiki-ieee80211]: https://fr.wikipedia.org/wiki/IEEE_802.11
[doc-wiki-ieee80211d]: https://fr.wikipedia.org/wiki/IEEE_802.11d
[doc-wiki-ieee80211n]: https://fr.wikipedia.org/wiki/IEEE_802.11n
[doc-wiki-ieee80211e]: https://en.wikipedia.org/wiki/IEEE_802.11e-2005
[doc-wiki-ieee80211h]: https://en.wikipedia.org/wiki/IEEE_802.11h-2003
[doc-wiki-list-wlan-channels]: https://en.wikipedia.org/wiki/List_of_WLAN_channels

[doc-hostapd-conf-details]: https://w1.fi/cgit/hostap/plain/hostapd/hostapd.conf
[doc-wifi-country-channel-division]: https://chowdera.com/2021/01/20210128110913670Y.html
[doc-wifi-bgn-normes]: https://fr.ihowto.tips/did-you-know/ce-reprezinta-standardele-wi-fi-ieee-802-11a-802-11b-g-n-si-802-11ac-ale-unui-router-wireless.html

[doc-wifi-5-dfs-fr]: https://toubox.fr/wi-fi-comprendre-et-configurer-le-dfs/
[doc-wifi-5-dfs-en]: https://www.accessagility.com/blog/introduction-to-5-ghz-wifi-channels

[thread-se-how-to-setup-wifi-hostspot-with-80211n-mode]: https://unix.stackexchange.com/questions/184175/how-to-set-up-wifi-hotspot-with-802-11n-mode
