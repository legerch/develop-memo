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
- [2. Generate an access point (AP mode)](#2-generate-an-access-point-ap-mode)
- [3. Connect to an access point (STATION mode)](#3-connect-to-an-access-point-station-mode)
- [4. Ressources used](#4-ressources-used)

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

# 2. Generate an access point (AP mode)

Please refer to [create an access point tutorial][doc-ap-creation] for more details.

# 3. Connect to an access point (STATION mode)

Please refer to [connect to an access point tutorial][doc-ap-connection] for more details.

# 4. Ressources used

- Wikipedia :
  - [IEEE 802.11][doc-wiki-ieee80211]
  - [IEEE 802.11n][doc-wiki-ieee80211n]
  - [IEEE 802.11d][doc-wiki-ieee80211d] (used for `country_code` field)
  - [IEEE 802.11e][doc-wiki-ieee80211e] (used for **QoS** service)
  - [IEEE 802.11h][doc-wiki-ieee80211h] (used for **UNII2** and **UNII2-extended** support on 5GHz band)
- Others
  - [Wifi country code and channel division][doc-wifi-country-channel-division]
  - [802.11 b/g/n][doc-wifi-bgn-normes]
  - Understand 5GHz band
    - [FR - Comprendre et configurer le DFS][doc-wifi-5-dfs-fr]  
    - [EN - Introduction to 5 GHz WiFi Channels][doc-wifi-5-dfs-en]
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
[doc-ap-creation]: mode-ap.md
[doc-ap-connection]: mode-sta.md

<!-- External links -->
[app-sparrow-wifi]: https://github.com/ghostop14/sparrow-wifi
[app-wifi-analyzer]: https://apps.microsoft.com/store/detail/wifi-analyzer/9NBLGGH33N0N?hl=fr-fr&gl=fr

[doc-wiki-ieee80211]: https://fr.wikipedia.org/wiki/IEEE_802.11
[doc-wiki-ieee80211d]: https://fr.wikipedia.org/wiki/IEEE_802.11d
[doc-wiki-ieee80211n]: https://fr.wikipedia.org/wiki/IEEE_802.11n
[doc-wiki-ieee80211e]: https://en.wikipedia.org/wiki/IEEE_802.11e-2005
[doc-wiki-ieee80211h]: https://en.wikipedia.org/wiki/IEEE_802.11h-2003
[doc-wiki-list-wlan-channels]: https://en.wikipedia.org/wiki/List_of_WLAN_channels

[doc-wifi-country-channel-division]: https://chowdera.com/2021/01/20210128110913670Y.html
[doc-wifi-bgn-normes]: https://fr.ihowto.tips/did-you-know/ce-reprezinta-standardele-wi-fi-ieee-802-11a-802-11b-g-n-si-802-11ac-ale-unui-router-wireless.html

[doc-wifi-5-dfs-fr]: https://toubox.fr/wi-fi-comprendre-et-configurer-le-dfs/
[doc-wifi-5-dfs-en]: https://www.accessagility.com/blog/introduction-to-5-ghz-wifi-channels
