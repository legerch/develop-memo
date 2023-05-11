**This file is under construction**

Ressources (seems overkill or hard to maintain):
- https://raspberrypi.stackexchange.com/questions/44184/switch-between-ap-and-client-mode
- https://forums.raspberrypi.com/viewtopic.php?t=317642 (celui-ci parle de mapper le nom pour une même interface)
  - La suite: https://forums.raspberrypi.com//viewtopic.php?f=66&t=291311
- https://github.com/Autodrop3d/raspiApWlanScripts/tree/main

Idées à la volée:
- WPA Supplicant et Hostapd peuvent se gérer via `libpwa_client`
- La seule réserve resterai le fichier `interfaces` (utiliser liens symboliques ? `interfaces-ap` / `interfaces-lan`)