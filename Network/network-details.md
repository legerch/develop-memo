**Table of contents :**
- [1. Perform network measurements](#1-perform-network-measurements)
  - [1.1. Speed measures server/client](#11-speed-measures-serverclient)
    - [1.1.1. Configure server](#111-configure-server)
    - [1.1.2. Configure client](#112-configure-client)
- [2. IP addresses](#2-ip-addresses)
  - [2.1. Private ranges](#21-private-ranges)
  - [2.2. IP tools](#22-ip-tools)

# 1. Perform network measurements

To perform network measurements, we can use tool utility [iPerf3][iperf-official] ([source code repository][iperf-repo]).  
All documentation can be found at [iPerf - documentation][iperf-doc].  

> Note: _iPerf_ provide binaries only for _Linux based OSes_ as we can see in [obtaining iPerf3 section][iperf-binaries].  
> But some people provide **Windows** binaries:
> - [Budman builds][iperf-bin-win-budman] (see [this discussion thread][iperf-bin-win-budman-thread] for details)
> - [ar51an/iperf3-win-builds][iperf-bin-win-ar51an]

## 1.1. Speed measures server/client
### 1.1.1. Configure server

On server, we use command:
```shell
iperf3 -s
```

### 1.1.2. Configure client

On client, we can use commands:
- Client send data to server:
```shell
iperf3 -c <server-ipv4>
```
- Server send data to client:
```shell
iperf3 -c <server-ipv4> -R
```

# 2. IP addresses
## 2.1. Private ranges
The Internet Assigned Numbers Authority (IANA) has reserved the following three blocks of the IP address space for private internets:
| Network | IP address range | Number of addresses |
|:-:|:-:|:-:|
| `10.0.0.0/8` | `10.0.0.0 – 10.255.255.255` | 16 777 216 |
| `172.16.0.0/12` | `172.16.0.0 – 172.31.255.255` | 1 048 576 |
| `192.168.0.0/16` | `192.168.0.0 – 192.168.255.255` | 65 536 |

> Ressources used:
> - Docs:
>   - [ip-doc-private-ranges-wiki]
>   - [ip-doc-private-ranges-avast] 
>   - [ip-doc-private-ranges-helpsystems]
>   - [ip-tutorial-private-ranges-engenius]
> - Forums:
>   - [ip-forum-private-range-serverfault1]
>   - [ip-forum-private-range-serverfault2]

## 2.2. IP tools

To easily calculate properties of a network (possible network addresses, usable host ranges, subnet mask, and IP class, among others), you can use [IP Subnet Calculator][ip-calculator].

<!-- External links -->
[iperf-official]: https://software.es.net/iperf/
[iperf-repo]: https://github.com/esnet/iperf
[iperf-doc]: https://software.es.net/iperf/invoking.html#iperf3-manual-page
[iperf-binaries]: https://software.es.net/iperf/obtaining.html
[iperf-bin-win-budman]: https://files.budman.pw/
[iperf-bin-win-budman-thread]: https://www.neowin.net/forum/topic/1234695-iperf/
[iperf-bin-win-ar51an]: https://github.com/ar51an/iperf3-win-builds

[ip-calculator]: https://www.calculator.net/ip-subnet-calculator.html
[ip-doc-private-ranges-avast]: https://www.avast.com/c-ip-address-public-vs-private
[ip-doc-private-ranges-wiki]: https://en.wikipedia.org/wiki/Private_network
[ip-doc-private-ranges-helpsystems]: https://community.helpsystems.com/kb-nav/kb-article/?id=5bf8247d-6bc3-eb11-bacc-000d3a1fe4c0
[ip-tutorial-private-ranges-engenius]: https://helpcenter.engeniustech.com/hc/en-us/articles/115004072868-Since-static-IP-addressing-is-recommended-in-most-access-point-deployments-is-it-okay-if-I-set-my-access-point-to-obtain-an-IP-address-and-reserve-it-on-the-router-setting-
[ip-forum-private-range-serverfault1]: https://serverfault.com/questions/52631/is-it-better-to-use-the-192-168-x-x-or-10-x-x-x-address-range-for-a-small-busine
[ip-forum-private-range-serverfault2]: https://serverfault.com/questions/117400/best-practice-for-assigning-private-ip-ranges