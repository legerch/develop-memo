File which will resume how to find a device on a local network

**Table of contents**
- [1. What protocol to use](#1-what-protocol-to-use)
- [2. How to use mDNS](#2-how-to-use-mdns)
- [3. mDNS publisher](#3-mdns-publisher)
  - [3.1. Setup mDNS publisher on _embedded Linux_](#31-setup-mdns-publisher-on-embedded-linux)
    - [3.1.1. Manage Hostname](#311-manage-hostname)
      - [3.1.1.1. Publish hostname](#3111-publish-hostname)
      - [3.1.1.2. Unique hostname](#3112-unique-hostname)
    - [3.1.2. Configure publisher](#312-configure-publisher)
      - [3.1.2.1. Use Avahi packages](#3121-use-avahi-packages)
      - [3.1.2.2. Create service](#3122-create-service)
      - [3.1.2.3. Configure Avahi](#3123-configure-avahi)
      - [3.1.2.4. Manage Avahi daemon](#3124-manage-avahi-daemon)
- [4. mDNS listener/browser](#4-mdns-listenerbrowser)
  - [4.1. MacOS](#41-macos)
  - [4.2. Linux](#42-linux)


# 1. What protocol to use

There are multiple ways to find device on a local network:
- **UDP brodcast:** Simple to implement but start to being blocked by multiple routers or even some operating systems
- **Multicast DNS (mDNS):** Also known as _Bonjour (Apple implementation)_, _DNS-SD_ or _Zeroconf_ protocols

# 2. How to use mDNS

Each operating system has his own implementation of **mDNS** protocol:
- **Apple (_MacOS_ and _iOS_)** provide native implementation via [Bonjour][apple-bonjour-docs] implementation (they also provide a _Windows Bonjour support_ via their [print service package][apple-bonjour-package-win])
- **Linux** use [Avahi][avahi-home] implementation
- **Windows** was relying on _Apple Bonjour_ package until native implementation has been released with [Windows 10 (version 1511)][stack-mdns-windows]
- **Android** provide native implementation via [NsdManager][android-nsdmanager] class introduced in _API level 16 (Android 4.1)_

In order to simplify management between all those implementations, we can find multiple cross-platforms libraries:
- Qt related
  - [QtZeroConf][qtzeroconf]
  - [Felgo ZeroConf][felgo-zeroconf]

# 3. mDNS publisher

Common things to remind:
- Publisher service must have a unique hostname

## 3.1. Setup mDNS publisher on _embedded Linux_
### 3.1.1. Manage Hostname
#### 3.1.1.1. Publish hostname

Under _Busybox configuration_, be sure to send _hostname_ in DHCP requests:
```shell
CONFIG_IFUPDOWN_UDHCPC_CMD_OPTIONS="-t1 -A3 -b -R -O search -O staticroutes -S -F $(hostname) -x hostname:$(hostname)"
```
> [!TIP]
> `-F $(hostname)`: This option sets the "client hostname" field in the DHCP request. This is a standard way of passing the hostname in DHCP requests, and most DHCP servers support and respond to it.  
> `-x hostname:$(hostname)`: This option explicitly sends the hostname as part of a custom DHCP option (hostname) in the DHCP request. Mainly use for compatibility with some server configurations  
> Other options are default one set by _Busybox_

#### 3.1.1.2. Unique hostname

To configure a unique hostname, we can run a one-time method filling _hostname_ related files:
```shell
NET_INTERFACE="wlan0"

FILE_HOSTNAME="/etc/hostname"
FILE_HOSTS="/etc/hosts"

HOSTNAME_PREFIX="mycustomdevice"

hostname_configure()
{
    log_write info "Try to configure hostname"

    # Verify that MAC address can be retrieved
    local pathInterface="/sys/class/net/${NET_INTERFACE}/address"
    if [ ! -f "${pathInterface}" ]; then
        log_write err "Unable to configure hostname, interface [${NET_INTERFACE}] is not available"
        return ${ERR_NET_DRIVER_NOT_READY}
    fi

    # Define hostname
    local hwAddr=$(cat "${pathInterface}" | tr -d ':' | tr '[:lower:]' '[:upper:]')
    local hostname="${HOSTNAME_PREFIX}-${hwAddr}"

    # Set hostname
    echo "${hostname}" > "${FILE_HOSTNAME}"
    echo "127.0.1.1 ${hostname}" >> "${FILE_HOSTS}"
    
    hostname "${hostname}"
    log_write info "Hostname has been configured to '${hostname}'"

    return ${ERR_NO_ERROR}
}
```
> [!NOTE]
> `log_write()` here is a custom method which use [`logger`][man-logger] utility internally

### 3.1.2. Configure publisher
#### 3.1.2.1. Use Avahi packages

Under Linux, [Avahi][avahi-home] is the implementation reference. Under _Buildroot_, we will use packages:
```shell
BR2_PACKAGE_AVAHI=y
# BR2_PACKAGE_AVAHI_AUTOIPD is not set
BR2_PACKAGE_AVAHI_DAEMON=y
```
> [!TIP]
> Package `AVAHI_AUTOIPD` will be needed if your device **have** to resolves services. Here, we only publish, so we don't need it

#### 3.1.2.2. Create service

A service file will be required, this is the service that will be published (multiple services can be published, so we can have multiple services files). They must be put inside directory `/etc/avahi/services/`:
```xml
<?xml version="1.0" standalone='no'?><!--*-nxml-*-->
<!DOCTYPE service-group SYSTEM "avahi-service.dtd">

<!--
This service file was based on: https://github.com/avahi/avahi/blob/master/avahi-daemon/example.service
Avahi version when this file was written: 0.8
Official documentation: https://linux.die.net/man/5/avahi.service
-->

<service-group>

  <name replace-wildcards="yes">My device %h</name>

  <service protocol="ipv4">
    <type>_mycustomprotocol._tcp</type>
    <port>515</port>
    <txt-record>ver=1.0.0</txt-record>
    <txt-record>id=device_id1234</txt-record>
  </service>

</service-group>
```
> [!TIP]
> `txt-record` fields can be useful to provide more infos on your device, generally we can find:
> - API Version
> - Device serial number or ID
> - Feature supported
> - Etc...

#### 3.1.2.3. Configure Avahi

**Avahi** daemon depends on [`/etc/avahi/avahi-daemon.conf`][avahi-cfg-man] (example available in [their repository][avahi-cfg-ex]).

#### 3.1.2.4. Manage Avahi daemon

To start and stop **Avahi daemon**, we can use those methods inside an _init.d script_:
```shell
NET_MDNS_DAEMON_NAME="avahi-daemon"
NET_MDNS_DAEMON_BIN="/usr/sbin/${NET_MDNS_DAEMON_NAME}"
NET_MDNS_DAEMON_ARGS="-D -s"

mdns_start()
{
    # Verify that discovery daemon is not already running
    mdns_status
    local status=$?
    if [ ${status} -eq ${ERR_NO_ERROR} ]; then
        log_write info "mDNS server already started, nothing to do"
        return ${ERR_NO_ERROR}
    fi

    # Generate discovery services files
    mdns_configure
    status=$?
    if [ ${status} -ne ${ERR_NO_ERROR} ]; then
        return ${status}
    fi

    # Start daemon
    ${NET_MDNS_DAEMON_BIN} ${NET_MDNS_DAEMON_ARGS}
    status=$?
    if [ ${status} -ne ${ERR_NO_ERROR} ]; then
        log_write err "Failed to start mDNS server due to daemon error: ${status}"
        return ${ERR_DAEMON}
    fi

    log_write info "mDNS server has been started"
    return ${ERR_NO_ERROR}
}

mdns_stop()
{
    # Verify that a daemon is currently running
    mdns_status
    local status=$?
    if [ ${status} -eq ${ERR_DAEMON} ]; then
        log_write info "mDNS server already stopped, nothing to do"
        return ${ERR_NO_ERROR}
    fi

    # Stop daemon
    ${NET_MDNS_DAEMON_BIN} -k

    log_write info "mDNS server has been stopped"
    return ${ERR_NO_ERROR}
}

# Use to verify if mDNS daemon is 
# currently running
# 
# Return enum "ERR_NO_ERROR" if running, "ERR_DAEMON"
# otherwise.
mdns_status()
{
    # Retrieve daemon status
    ${NET_MDNS_DAEMON_BIN} -c
    local daemonStatus=$?
    if [ ${daemonStatus} -eq 0 ]; then
        return ${ERR_NO_ERROR}
    fi

    return ${ERR_DAEMON} 
}
```
> [!IMPORTANT]
> **DBus daemon** must be running to run _avahi daemon_

# 4. mDNS listener/browser
## 4.1. MacOS

Under **MacOS**, we can use the command line:
```shell
# List all available services
dns-sd -B _services._dns-sd._udp local.

# List a specific service
dns-sd -B _http._tcp local.
dns-sd -B _mycustomprotocol._tcp local.

# Resolve device
dns-sd -L "MyDevice" _mycustomprotocol._tcp local.
```

We can also use GUI application [Discovery - DNS-SD Browser][apple-mdns-gui] provided on _Apple Store_

## 4.2. Linux

We can use command-line:
```shell
# List all available services
avahi-browse --all

# List a specific service
avahi-browse _http._tcp
avahi-browse _mycustomprotocol._tcp

# Resolve devices of specific service
avahi-browse -r _http._tcp
avahi-browse -r _mycustomprotocol._tcp
```

We can also use GUI utility [avahi-discover][avahi-discover] by simply running:
```shell
avahi-discover
```

<!-- External links -->

[android-nsdmanager]: https://developer.android.com/reference/android/net/nsd/NsdManager
[apple-bonjour-docs]: https://developer.apple.com/bonjour/
[apple-bonjour-package-win]: https://support.apple.com/fr-fr/106380
[apple-mdns-gui]: https://apps.apple.com/fr/app/discovery-dns-sd-browser/id305441017
[avahi-home]: https://avahi.org/
[avahi-cfg-man]: https://linux.die.net/man/5/avahi-daemon.conf
[avahi-cfg-ex]: https://github.com/avahi/avahi/blob/master/avahi-daemon/avahi-daemon.conf
[avahi-discover]: https://linux.die.net/man/1/avahi-discover

[felgo-zeroconf]: https://felgo.com/doc/felgo-zeroconf/
[qtzeroconf]: https://github.com/jbagg/QtZeroConf

[man-logger]: https://linux.die.net/man/1/logger

[stack-mdns-windows]: https://superuser.com/questions/491747/how-can-i-resolve-local-addresses-in-windows

