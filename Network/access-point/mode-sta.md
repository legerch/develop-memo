This file will resume how to connect to an access point, also called **STATION Mode**.

> Quick memo (only for my own config), files involved for this mode:
> - `etc/network/interfaces`
> - `etc/wpa_supplicant.conf`
> - `etc/init.d/S40netwkork` (load drivers)
> - Command used to start _wpa_supplicant_
> - Command used to refresh DHCP client

**Table of contents:**
- [1. Setup interface](#1-setup-interface)
- [2. Setup _wpa\_supplicant_](#2-setup-wpa_supplicant)
  - [2.1. _wpa\_supplicant_ configuration](#21-wpa_supplicant-configuration)
  - [2.2. Daemon management](#22-daemon-management)
- [3. Setup DHCP client](#3-setup-dhcp-client)
- [4. WPA client](#4-wpa-client)
  - [4.1. Build library](#41-build-library)
    - [4.1.1. Buildroot](#411-buildroot)
    - [4.1.2. Standalone](#412-standalone)
  - [4.2. How to use](#42-how-to-use)
- [5. Ressources used](#5-ressources-used)


This tutorial is written for system using [wpa_supplicant][tutorial-wpa-supplicant-details-arch], multiples methods will be describe.  
Note that needed network driver must be loaded (`modprobe` utility) or directly compiled with kernel to use this feature.

**Warning:** Be careful, use only one network manager at a time ! Here is some of this utilities:
- [NetworkManager][doc-arch-network-manager]: used on modern desktop distribution
- [Wpa Supplicant][tutorial-wpa-supplicant-details-arch]: mainly used in embedded distribution

# 1. Setup interface
1. Interface configuration via `/etc/network/interfaces`:
```shell
auto lo
iface lo inet loopback

auto wlan0
iface wlan0 inet dhcp
```
> Here, we configure our interface `wlan0`:
> - Is brought up at boot (keywork `auto`)
> - Use DHCP for IPv4/IPv6 addresses (keywork `dhcp`)
> 
> For more details about `/etc/network/interfaces`, please see:
> - [Manpage _Interfaces_][doc-file-interfaces-manpage]

2. Enable interface
```shell
$ /sbin/ifdown -a
$ /sbin/ifup -a     # Use /etc/network/interfaces file
```

# 2. Setup _wpa_supplicant_
## 2.1. _wpa_supplicant_ configuration

_WPA Supplicant_ will be configured through [`/etc/wpa_supplicant.conf`][doc-wpa-supplicant-conf]:
```shell
# Documentation about wpa_supplicant.conf : 
# - https://w1.fi/cgit/hostap/plain/wpa_supplicant/wpa_supplicant.conf

# Parameters for the control interface. If this is specified, wpa_supplicant
# will open a control interface that is available for external programs to
# manage wpa_supplicant.
ctrl_interface=/var/run/wpa_supplicant

# Whether to allow wpa_supplicant to update (overwrite) configuration
# Needed if "save_config" request must be performed
update_config=1

# The ISO/IEC alpha2 country code in which the device is operating
country=US

# List of known networks
network={
    ssid="MY_HOME1"
    key_mgmt=WPA-PSK            # This will use pre-shared key ("psk" field)
    #psk="myhome1passphrase"    # Can be in plain text or hashed
    psk=51914c4b74d6b29bfe778ef98ea5dca09979902a45d444506ede710cfc9a83aa
    disabled=0                  # Set to 1 to disable this regisered network (and enable it later via "wpa_cli" or custom utility)
    scan_ssid=0                 # Set to 1 to detect hidden SSIDs (only if needed because this can add some latency)
    priority=1                  # If multiple registered network can be available in same range, use this field (default value is 0 for all networks)
}

network={
    ssid="MY_HOME2"
    key_mgmt=WPA-PSK
    #psk="myhome2passphrase"
    psk=a712aa3ee3c50077932e2283ac3f58a3b1887c5522a6910dae599fb945ce6c06
    priority=0                  # In this configuration, "MY_HOME1" will be checked before "MY_HOME2"
}
```
> **Note :** In our example, we used an encrypted _PSK_ generated via utility `wpa_passphrase`:
> ```shell
> wpa_passphrase "MY_HOME1" "myhome1passphrase"
> ```
> For more details on this utility, see [raspberry documentation][tutorial-wpa-supplicant-raspy]

## 2.2. Daemon management

To start WPA supplicant daemon, use:
```shell
wpa_supplicant -D nl80211 -i wlan0 -c /etc/wpa_supplicant.conf -B -s
```
> Arguments details:
> - `-D`: Specify driver to use, multiple can be added by separating them with comma `,`
> - `-i`: Specify interface to use
> - `-c`: Specify configuration file to use
> - `-B`: Start _wpa_supplicant_ daemon in the background
> - `-s`: Log output to _stdlog_ instead of _stdout_

This will start daemon and load configuration set in file `/etc/wpa_supplicant.conf`. If no network as been registered, nothing more will be done. Otherwise, if one or more are configured and available, connection will be made.

Therefore, to stop WPA supplicant daemon, use:
```shell
wpa_cli -i wlan0 disconnect     # Not mandatory, but just in case...
wpa_cli -i wlan0 terminate
```
> **Note:** 
> - This command will succeed only if `wpa_supplicant.conf` has field `ctrl_interface` configured (more details on _wpa_cli_ can be found in [WPA client section][anchor-wpa-cli]). If not set, you can use `kill` method (alongside `ps` which allow to retrieve **PID**)
> - To automate things at startup, you can refer to [Armadeus documentation][tutorial-wpa-supplicant-armadeus]

# 3. Setup DHCP client

**DHCP client** will allow to device to get an IP address from the connected access point, please refer to [DHCP client documentation][repo-dhcp-client] for more details.

# 4. WPA client

Once _WPA Supplicant Daemon_ is started, it can be controlled via utility [wpa_cli][doc-wpa-cli] or custom application, both will used [libwpa_client][doc-wpa-supplicant-lib] library.
> Note:
> - Field `ctrl_interface` of `wpa_supplicant.conf` file must be set to use this feature
> - [hostapd][repo-hostapd] provide a similar behaviour to be controlled by external applications (library used is also **libwpa_client**)

Once library will be build, you can link it to our application with: `-lwpa_client`

## 4.1. Build library
### 4.1.1. Buildroot

WPA Supplicant configuration:
- `BR2_PACKAGE_WPA_SUPPLICANT`: **needed**
  - `BR2_PACKAGE_WPA_SUPPLICANT_NL80211`: **needed**
  - `BR2_PACKAGE_WPA_SUPPLICANT_AP_SUPPORT`: Use it only if you need to support **AP mode** and don't want to use **hostapd** utility
  - `BR2_PACKAGE_WPA_SUPPLICANT_AUTOSCAN`: **needed**
  - `BR2_PACKAGE_WPA_SUPPLICANT_EAP`: Better to have it enabled
  - `BR2_PACKAGE_WPA_SUPPLICANT_DEBUG_SYSLOG`: Optional
  - `BR2_PACKAGE_WPA_SUPPLICANT_CLI`: **needed**
  - `BR2_PACKAGE_WPA_SUPPLICANT_PASSPHRASE`: **needed**
  - `BR2_PACKAGE_WPA_SUPPLICANT_WPA_CLIENT_SO`: **needed**

### 4.1.2. Standalone

To build **libwpa_client.so**:
1. Clone official git repo
```shell
git clone git://w1.fi/srv/git/hostap.git
```

2. Build library
```shell
cd hostapd/wpa_supplicant/
make libwpa_client.so
```

## 4.2. How to use

To use the library, you can refer to [libwpa_client documentation][doc-wpa-supplicant-lib] and [source code of _wpa_cli_][git-wpa-cli] as an example.
> Tutorials that can be helpful:
> - [Superuser - How to connect to a WiFi from command line under Ubuntu without .conf file?][ask-so-how-use-wpa-cli]
> - [(FR) LinuxEmbedded - Présentation des Wireless Daemon sous Linux][tutorial-wpa-supplicant-details-linuxembedded]

Below, short description of useful commands of _wpa_cli_ (or request that can be used in your custom application):
- Register new network to WPA Supplicant:
  - `add_network`: This command creates a new network with empty configuration. The new network is disabled and once it has been configured it can be enabled with `enable_network` command. `add_network` returns the network ID of the new network or **FAIL status** on failure.
  - `set_network <id> ssid "MY_SSID"`
  - `set_network <id> psk "MY_PRE-SHARED-PASSPHRASE"`
  - `set_network <id> <key-cmd> <value>"`: Multiple value can be set through `key-cmd` arg, please see documentation for more details
  - `enable_network <id>` / `disable_network <id>`
  - `remove_network <id>`
- Manage networks
  - `scan`: Will perform a scan
  - `scan_results`: Will give list of network scanned with previous call to `scan` command
  - `list_networks`: List registered networks
- WPA Supplicant configuration management
  - `save_config`: Save current configuration to registered `wpa_supplicant.conf` file (will succeed only if field `update_config` of this file is set to `1`)
  - `reconfigure`: Reload WPA Supplicant configuration
- WPA Supplicant management
  - `disconnect`
  - `terminate`

# 5. Ressources used

- WPA Supplicant
  - Configuration file
    - [doc-wpa-supplicant-conf]
    - [doc-wpa-supplicant-conf-ubuntu]
  - Details
    - [tutorial-wpa-supplicant-raspy]
    - [tutorial-wpa-supplicant-armadeus]
  - Tutorials
    - [tutorial-wpa-supplicant-details-arch]
    - [tutorial-wpa-supplicant-details-linuxembedded]
    - [tutorial-wpa-supplicant-details-debianfacile]
  - Client / Library
    - [ask-so-how-use-wpa-cli]
    - [doc-wpa-cli]
    - [doc-wpa-supplicant-lib]
  - WPA-EAP related
    - [ask-so-hide-user-eap-credential]
    - [ask-arch-hide-user-eap-credential]
  - Source code
    - [git-wpa-cli]
    - [git-hostapd-cli]
- Network manager
  - [doc-arch-network-manager]
  - [doc-debian-network-manager]
- Interfaces file
  - [doc-file-interfaces-manpage]

<!-- Anchor of this file -->
[anchor-wpa-cli]: #4-wpa-client

<!-- Repository links -->
[repo-hostapd]: mode-ap.md
[repo-dhcp-client]: ../dhcp/client/

<!-- External links -->
[doc-file-interfaces-manpage]: https://man.cx/interfaces(5)

[doc-arch-network-manager]: https://wiki.archlinux.org/title/NetworkManager
[doc-debian-network-manager]: https://wiki.debian.org/fr/NetworkConfiguration#A3_fa.2BAOc-ons_pour_configurer_le_r.2BAOk-seau

[doc-wpa-supplicant-conf]: https://w1.fi/cgit/hostap/plain/wpa_supplicant/wpa_supplicant.conf
[doc-wpa-supplicant-conf-ubuntu]: https://manpages.ubuntu.com/manpages/jammy/man5/wpa_supplicant.conf.5.html
[doc-wpa-supplicant-lib]: https://w1.fi/wpa_supplicant/devel/ctrl_iface_page.html
[doc-wpa-cli]: https://linux.die.net/man/8/wpa_cli

[tutorial-wpa-supplicant-armadeus]: http://www.armadeus.org/wiki/index.php?title=WPA_supplicant
[tutorial-wpa-supplicant-raspy]: https://www.raspberrypi.com/documentation/computers/configuration.html#adding-the-network-details-to-your-raspberry-pi

[tutorial-wpa-supplicant-details-arch]: https://wiki.archlinux.org/title/wpa_supplicant
[tutorial-wpa-supplicant-details-debianfacile]: https://debian-facile.org/doc:reseau:wpasupplicant
[tutorial-wpa-supplicant-details-linuxembedded]: https://www.linuxembedded.fr/2020/07/presentation-des-wireless-daemon-sous-linux

[ask-so-how-use-wpa-cli]: https://superuser.com/questions/341102/how-to-connect-to-a-wifi-from-command-line-under-ubuntu-without-conf-file
[ask-so-hide-user-eap-credential]: https://unix.stackexchange.com/questions/278946/hiding-passwords-in-wpa-supplicant-conf-with-wpa-eap-and-mschap-v2
[ask-arch-hide-user-eap-credential]: https://bbs.archlinux.org/viewtopic.php?id=144471

[git-hostapd-cli]: https://github.com/cozybit/hostap-sae/blob/master/hostapd/hostapd_cli.c
[git-wpa-cli]: https://github.com/cozybit/hostap-sae/blob/master/wpa_supplicant/wpa_cli.c
