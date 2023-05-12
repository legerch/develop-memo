**Table of contents :**

# 1. Introduction

In this tutorial, [UDHCPC][udhcpc-git] from **Busybox** will be used.

to add:
- Option bubybox (cfg file) : CONFIG_IFUPDOWN_UDHCPC_CMD_OPTIONS (+ autre champs)
- `udhcpc -i wlan0` (udhcp client)
- lien **udhcpc** avec fichier /etc/interfaces (le lien est plutôt avec **ifup**)

https://github.com/buildroot/buildroot/blob/next/package/busybox/udhcpc.script
https://github.com/buildroot/buildroot/blob/next/package/busybox/busybox.config

UDHCPC related:
https://github.com/buildroot/buildroot/commit/80291c3e9c591ee8cfb9262523cd5151ed0b747a
https://github.com/buildroot/buildroot/commit/2f33654365ffa8fc1b3d8f9e5394a81abb776f66
https://github.com/buildroot/buildroot/commit/c343e01ac4908f76520cf9a405ed87650e78dc62
https://github.com/buildroot/buildroot/commit/10aab0aaf62ab73014fb77d47105ff09acdba403
https://github.com/buildroot/buildroot/commit/b153345beca555164a11dae4f2c77862d4fb76b6

Update busybox config to 1.36.0
https://github.com/buildroot/buildroot/commit/d68b617993bd2f5c82a4936ed1e24e4fec6b94a2

<!-- Ressources links -->
[udhcpc-git]: https://git.busybox.net/busybox/tree/networking/udhcp