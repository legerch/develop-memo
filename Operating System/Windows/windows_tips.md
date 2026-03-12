This files will list multiple _tips_ related to **Windows OS**

**Table of contents:**
- [1. Network](#1-network)
  - [1.1. Wifi password](#11-wifi-password)
  - [1.2. Set network as public/private network](#12-set-network-as-publicprivate-network)
    - [1.2.1. Via command-line](#121-via-command-line)
    - [1.2.2. Via Windows Registry](#122-via-windows-registry)

# 1. Network
## 1.1. Wifi password

To see already known WIFI password, use the command:
```shell
netsh wlan show profile name="Wifi name" key=clear
```

## 1.2. Set network as public/private network
### 1.2.1. Via command-line
By default, any new network will be considered as **Public** network by Windows, we often can change it via parameters but we can also use those commands:
- See current status: `Get-NetConnectionProfile`

![img-status-get]

- Set public/private property:
```shell
# Via name (stay accross disconnection)
Set-NetConnectionProfile -Name "My Network" -NetworkCategory Private

# Via index (stay only for current connection since index can be changed)
Set-NetConnectionProfile -InterfaceIndex 12 -NetworkCategory Private
```

### 1.2.2. Via Windows Registry

We can also use **Windows Registry** via:  
`HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles`

Each _key_ represent a network, so find out the network to set and set the field `Category`:
- **0**: Public
- **1**: Private
- **2**: Domain

![img-status-set-registry]

<!-- Images -->
[img-status-get]: assets/network_status_connection_get.png
[img-status-set-registry]: assets/network_status_connection_set_registry.png

<!-- Links -->