**Sommaire :**
- [1. Introduction](#1-introduction)
- [2. Coté serveur](#2-coté-serveur)
  - [2.1. IMX6](#21-imx6)
    - [2.1.1. Source caméra](#211-source-caméra)
    - [2.1.2. Source simulée](#212-source-simulée)
  - [2.2. IMX8MM](#22-imx8mm)
    - [2.2.1. Source simulée](#221-source-simulée)
- [3. Coté client](#3-coté-client)
  - [3.1. Via GStreamer](#31-via-gstreamer)
  - [3.2. Via fichier `.sdp`](#32-via-fichier-sdp)
- [4. Informations importantes](#4-informations-importantes)
  - [4.1. Mode bayer](#41-mode-bayer)
- [5. Ressources](#5-ressources)

# 1. Introduction

_Under construction_

# 2. Coté serveur

## 2.1. IMX6

L'IMX6 possède un VPU hardware pour l'encodage x264.

### 2.1.1. Source caméra

- Démarrer le streaming vidéo en le diffusant au framebuffer et via UDP :
```shell
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,width=632,height=632 ! tee name=t ! queue ! videoconvert ! videoscale method=0 ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0 t. ! queue ! videoconvert ! v4l2h264enc output-io-mode=4 ! rtph264pay ! udpsink host=192.168.0.157 port=1234
```

- Démarrer le streaming vidéo en le diffusant seulement sur le framebuffer :
```shell
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,width=632,height=632 ! queue ! videoconvert ! videoscale ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0
```

- Démarrer le streaming vidéo en le diffusant seulement via UDP :
```shell
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,width=632,height=632 ! queue ! videoconvert ! v4l2h264enc output-io-mode=4 ! rtph264pay ! udpsink host=192.168.0.157 port=1234
```

### 2.1.2. Source simulée

- Démarrer le streaming vidéo en le diffusant au framebuffer et via UDP :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-raw,width=632,height=632 ! tee name=t ! queue ! videoconvert ! videoscale method=0 ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0 t. ! queue ! videoconvert ! v4l2h264enc output-io-mode=4 ! rtph264pay ! udpsink host=192.168.0.157 port=1234
```
> L'élément `videotestsrc` dispose de plusieurs mode : _smpte_ (bande de couleurs + neige), _ball_ (balle en mouvement), etc...  
> Pour la liste complète, se référer à la documentation : [GStreamer videotestsrc](https://gstreamer.freedesktop.org/documentation/videotestsrc/index.html)

- Démarrer le streaming vidéo en le diffusant seulement sur le framebuffer :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-raw,width=632,height=632 ! queue ! videoconvert ! videoscale ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0
```

- Démarrer le streaming vidéo en le diffusant seulement via UDP :
```shell
gst-launch-1.0 -v v4l2src videotestsrc pattern=ball is-live=true ! video/x-raw,width=632,height=632 ! queue ! videoconvert ! v4l2h264enc output-io-mode=4 ! rtph264pay ! udpsink host=192.168.0.157 port=1234
```

## 2.2. IMX8MM

L'IMX8M Mini ne possède pas d'encodeur H264 hardware, il utilise un encodeur software, il est donné pour un encodage H264 `1080@60fps` d'après la documentation.
> Documentation NXP : https://www.nxp.com/products/processors-and-microcontrollers/arm-processors/i-mx-applications-processors/i-mx-8-processors:IMX8-SERIES  
> Ici, nous utilisons le plugin `x264enc` qui est le plugin générique GStreamer pour un encodage x264. Il y a l'air d'exister un plugin x264 spécifique à l'IMX8, à savoir : `vpuenc_h264` -> **Creuser la piste !**  
> D'autres threads intéressants concernant la problématique "encodeurs H264 IMX8" sont disponibles dans la section [Ressources](#ressources)

Ici, nous sommes obligé d'utiliser un encodeur avec les paramètres à la qualité la plus basse, sinon trop de latence ou trop de bruit.

### 2.2.1. Source simulée

- Démarrer le streaming vidéo en le diffusant au framebuffer et via UDP :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-raw,width=600,height=600 ! tee name=t ! queue ! videoconvert ! videoscale method=0 ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0 t. ! queue ! videoconvert ! x264enc quantizer=25 speed-preset=ultrafast tune=zerolatency ! rtph264pay ! udpsink host=192.168.0.157 port=1234
```

- Démarrer le streaming vidéo en le diffusant seulement sur le framebuffer :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-raw,width=600,height=600 ! queue ! videoconvert ! videoscale method=0 ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0
```

- Démarrer le streaming vidéo en le diffusant seulement via UDP :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-raw,width=600,height=600 ! queue ! videoconvert ! x264enc quantizer=25 speed-preset=ultrafast tune=zerolatency ! rtph264pay ! udpsink host=192.168.0.157 port=1234
```

# 3. Coté client

## 3.1. Via GStreamer
On peut recuperer le flux sur le PC connecte via la commande GStreamer (UNIX) :
```shell
# 1ere version
LIBVA_DRIVER_NAME=iHD gst-launch-1.0 -v udpsrc address=192.168.0.157 port=1234 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, payload=(int)96, encoding-name=(string)H264" ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink

# 2nde version : la commande peut être lente due au fait que le "caps" est "parsé" par GStreamer, en utilisant les éléments drectement, on gagne en performance
LIBVA_DRIVER_NAME=iHD gst-launch-1.0 -v udpsrc address=192.168.0.157 port=1234 ! application/x-rtp,media=video,clock-rate=90000,encoding-name=H264 ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! autovideosink

# 3eme version basée sur la 2nde en n'étant plus dépendant de l'adresse IP cliente
LIBVA_DRIVER_NAME=iHD gst-launch-1.0 -v udpsrc address=0.0.0.0 port=1234 ! application/x-rtp,media=video,clock-rate=90000,encoding-name=H264 ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! autovideosink
```
> Le paramètre `LIBVA_DRIVER_NAME=iHD` peut être nécessaire si présence de 2 cartes graphiques sur le PC récepteur.  
> Ici, on demande à utiliser la carte graphique Intel.

## 3.2. Via fichier `.sdp`
On peut également spécifier les détails du flux dans un fichier SDP :
```shell
v=0
m=video 1234 RTP/AVP 96
c=IN IP4 192.168.0.157
a=rtpmap:96 H264/90000
```

On pourra l'ouvrir via VLC :
```shell
vlc myStreamFile.sdp
```
> La configuration par défaut de VLC peut donner du délai, réduire le temps de cache réseau permet de limiter cela.

Ou via GStreamer :
```shell
LIBVA_DRIVER_NAME=iHD gst-launch-1.0 -v filesrc location=myStreamFile.sdp ! sdpdemux ! decodebin ! videoconvert ! autovideosink
```

# 4. Informations importantes
## 4.1. Mode bayer

- Exemple de pipeline en mode bayer (diffusion sur framebuffer) :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-bayer,format=grbg,width=432,height=432,framerate=30/1 ! bayer2rgb ! queue ! videoconvert ! videoscale method=0 ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0
```
> Note that gstreamer may only be able to handle 8 bits bayer frames, so you may try first to get it working in this mode. Note however that you would have to debayer frames with a gstreamer plugin bayer2rgb that runs on CPU.  
> Note that bayer2rgb is in gst plugins bad package if not yet installed. It may be slow, so it may be better to boost your jetson with MAXN nvpmodel and max clocks.
bayer2rgb debayers on CPU.

# 5. Ressources

- Documentation officielle **GStreamer**:
  - [Accès à tous les plugins](https://gstreamer.freedesktop.org/documentation/plugins_doc.html?gi-language=c)
  - Gestion pipeline
    - [tee](https://gstreamer.freedesktop.org/documentation/coreelements/tee.html?gi-language=c)
    - [queue](https://gstreamer.freedesktop.org/documentation/coreelements/queue.html?gi-language=c)
    - [decodebin](https://gstreamer.freedesktop.org/documentation/playback/decodebin.html?gi-language=c)
  - Source
    - [videotestsrc](https://gstreamer.freedesktop.org/documentation/videotestsrc/index.html?gi-language=c)
    - [v4l2src](https://gstreamer.freedesktop.org/documentation/video4linux2/v4l2src.html?gi-language=c)
    - [uvch264src](https://gstreamer.freedesktop.org/documentation/uvch264/uvch264src.html?gi-language=c)
    - [filesrc](https://gstreamer.freedesktop.org/documentation/coreelements/filesrc.html?gi-language=c)
  - Transformation
    - [videocrop](https://gstreamer.freedesktop.org/documentation/videocrop/videocrop.html?gi-language=c)
    - [videoscale](https://gstreamer.freedesktop.org/documentation/videoscale/index.html?gi-language=c)
  - Convertion
    - [videoconvert](https://gstreamer.freedesktop.org/documentation/videoconvert/index.html?gi-language=c)
    - [bayer2rgb](https://gstreamer.freedesktop.org/documentation/bayer/bayer2rgb.html?gi-language=c)
  - Encodeurs
    - v4l2h264enc
    - [x264enc](https://gstreamer.freedesktop.org/documentation/x264/index.html?gi-language=c)
  - Decodeurs
    - [h264parse](https://gstreamer.freedesktop.org/documentation/videoparsersbad/h264parse.html?gi-language=c)
    - [avdec_h264](https://gstreamer.freedesktop.org/documentation/libav/avdec_h264.html?gi-language=c)
  - Réseau
    - [rtph264pay](https://gstreamer.freedesktop.org/documentation/rtp/rtph264pay.html?gi-language=c)
    - [rtph264depay](https://gstreamer.freedesktop.org/documentation/rtp/rtph264depay.html?gi-language=c)
    - [udpsink](https://gstreamer.freedesktop.org/documentation/udp/udpsink.html?gi-language=c)
    - [udpsrc](https://gstreamer.freedesktop.org/documentation/udp/udpsrc.html?gi-language=c)
  - Ecran
    - [fbdevsink](https://gstreamer.freedesktop.org/documentation/fbdevsink/index.html?gi-language=c)
  - SDP
    - [sdpdemux](https://gstreamer.freedesktop.org/documentation/sdpelem/sdpdemux.html?gi-language=c)
  - Autres
    - [autovideosink](https://gstreamer.freedesktop.org/documentation/autodetect/autovideosink.html?gi-language=c)
- Documentation officielle **NXP** :
  - [Processeurs IMX8](https://www.nxp.com/products/processors-and-microcontrollers/arm-processors/i-mx-applications-processors/i-mx-8-processors:IMX8-SERIES)
- Documentation officielle fichier `.sdp` : https://developer.ridgerun.com/wiki/index.php/Introduction_to_network_streaming_using_GStreamer
- Threads
  - Fichiers `.sdp`
    - [Pipeline GStreamer pour lire le flux depuis fichier `.sdp`](http://gstreamer-devel.966125.n4.nabble.com/Unable-to-play-a-rtp-stream-td4675068.html)
    - [Générer un fichier .sdp depuis GStreamer](https://developer.ridgerun.com/wiki/index.php/Introduction_to_network_streaming_using_GStreamer)
  - IMX8 encodeurs :
    - https://community.nxp.com/t5/i-MX-Processors/iMX8M-Software-H-264-Encoding-Speed-Not-as-Advertised/m-p/981332/highlight/true
    - https://community.nxp.com/t5/i-MX-Processors/i-MX8M-SW-Video-Encoder-Linux/td-p/748960
    - 
  - Autres
    - https://stackoverflow.com/questions/65996592/gstreamer-pipeline-gets-warning-from-fbdevsink-buffers-being-dropped-while-doin
    - https://forums.developer.nvidia.com/t/streaming-issues-with-gst-launch-1-0-with-a-custom-camera-device/73505/3

<!-- Images -->
[icon-valid]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
[icon-invalid]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
[icon-slow]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
[icon-lag]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"