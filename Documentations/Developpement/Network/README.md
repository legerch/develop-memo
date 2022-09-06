**Table of contents :**
- [1. Perform network measurements](#1-perform-network-measurements)
  - [1.1. Speed measures server/client](#11-speed-measures-serverclient)
    - [1.1.1. Configure server](#111-configure-server)
    - [1.1.2. Configure client](#112-configure-client)

# 1. Perform network measurements

To perform network measurements, we can use tool utility [iPerf3][iperf-official].  
All documentation can be found at [iPerf - documentation][iperf-doc].

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

<!-- External links -->
[iperf-official]: https://iperf.fr/
[iperf-doc]: https://iperf.fr/iperf-doc.php#3doc