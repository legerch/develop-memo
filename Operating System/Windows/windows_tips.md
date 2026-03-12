This files will list multiple _tips_ related to **Windows OS**

**Table of contents:**
- [1. Network](#1-network)
  - [1.1. Wifi password](#11-wifi-password)
  - [1.2. Set network as public/private network](#12-set-network-as-publicprivate-network)
    - [1.2.1. Via GUI](#121-via-gui)
    - [1.2.2. Via command-line](#122-via-command-line)
    - [1.2.3. Via Windows Registry](#123-via-windows-registry)
  - [1.3. Retrieve IPs configurations](#13-retrieve-ips-configurations)

# 1. Network
## 1.1. Wifi password

To see already known WIFI password, use the command:
```shell
netsh wlan show profile name="Wifi name" key=clear
```

## 1.2. Set network as public/private network

By default, any new network will be considered as **Public** network by **Windows OS**, that cannot be changed, that is user responsibility to properly set it.  
Multiples methods are available.

### 1.2.1. Via GUI

Simply go to `parameters -> Network` and select your network, then you have access to multiple properties (including _public/private_ field):

![img-status-set-gui]

### 1.2.2. Via command-line

- See current status: `Get-NetConnectionProfile`

![img-status-get]

- Set public/private property:
```powershell
# Via name (stay accross disconnection)
Set-NetConnectionProfile -Name "My Network" -NetworkCategory Private

# Via index (stay only for current connection since index can be changed)
Set-NetConnectionProfile -InterfaceIndex 12 -NetworkCategory Private
```

### 1.2.3. Via Windows Registry

We can also use **Windows Registry** via:  
`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles`

Each _key_ represent a network, so find out the network to set and set the field `Category`:
- **0**: Public
- **1**: Private
- **2**: Domain

![img-status-set-registry]

## 1.3. Retrieve IPs configurations

Multiple methods available:
- Via _powershell_:

```powershell
Get-NetIPConfiguration
```

- Via _terminal_:

```bash
ipconfig
ipconfig /all
```

<!-- Images -->
[img-status-get]: assets/network_status_connection_get.png
[img-status-set-gui]: assets/network_status_connection_set_gui.png
[img-status-set-registry]: assets/network_status_connection_set_registry.png

<!-- Links -->