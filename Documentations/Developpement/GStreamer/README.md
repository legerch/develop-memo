**Sommaire :**
- [1. Introduction](#1-introduction)
- [2. Streaming](#2-streaming)
  - [2.1. Coté serveur](#21-coté-serveur)
    - [2.1.1. IMX6](#211-imx6)
      - [2.1.1.1. Source caméra](#2111-source-caméra)
      - [2.1.1.2. Source simulée](#2112-source-simulée)
    - [2.1.2. IMX8MM](#212-imx8mm)
      - [2.1.2.1. Source caméra](#2121-source-caméra)
      - [2.1.2.2. Source simulée](#2122-source-simulée)
  - [2.2. Coté client](#22-coté-client)
    - [2.2.1. Via GStreamer](#221-via-gstreamer)
    - [2.2.2. Via fichier `.sdp`](#222-via-fichier-sdp)
- [3. Informations importantes](#3-informations-importantes)
  - [3.1. Mode bayer](#31-mode-bayer)
- [4. Lecture vidéo](#4-lecture-vidéo)
  - [4.1. Pipeline automatique](#41-pipeline-automatique)
  - [4.2. Pipeline manuel](#42-pipeline-manuel)
- [5. Fonctionnalités](#5-fonctionnalités)
  - [5.1. Obtenir des diagrammes/graphes](#51-obtenir-des-diagrammesgraphes)
- [6. Ressources](#6-ressources)

# 1. Introduction

_Under construction_

# 2. Streaming

## 2.1. Coté serveur

### 2.1.1. IMX6

L'IMX6 possède un VPU hardware pour l'encodage x264.

#### 2.1.1.1. Source caméra

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

#### 2.1.1.2. Source simulée

- Démarrer le streaming vidéo en le diffusant au framebuffer et via UDP :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-raw,width=632,height=632 ! tee name=t ! queue ! videoconvert ! videoscale method=0 ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0 t. ! queue ! videoconvert ! v4l2h264enc output-io-mode=4 ! rtph264pay ! udpsink host=192.168.0.157 port=1234
```
> L'élément `videotestsrc` dispose de plusieurs mode : _smpte_ (bande de couleurs + neige), _ball_ (balle en mouvement), etc...  
> Pour la liste complète, se référer à la documentation : [GStreamer videotestsrc][doc-gst-videotestsrc]

- Démarrer le streaming vidéo en le diffusant seulement sur le framebuffer :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-raw,width=632,height=632 ! queue ! videoconvert ! videoscale ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0
```

- Démarrer le streaming vidéo en le diffusant seulement via UDP :
```shell
gst-launch-1.0 -v v4l2src videotestsrc pattern=ball is-live=true ! video/x-raw,width=632,height=632 ! queue ! videoconvert ! v4l2h264enc output-io-mode=4 ! rtph264pay ! udpsink host=192.168.0.157 port=1234
```

### 2.1.2. IMX8MM

L'i.MX8MMini ne possède pas d'encodeur H264 hardware, il utilise un VPU software, il est donné pour un encodage H264 `1080@60fps` d'après la documentation.
> Documentation NXP : [i.MX8 processors][doc-nxp-imx8]

Par ailleurs, l'i.MX8MM bénéficie de l'API **G2D** devéloppé par **NXP** (nécessite le kernel NXP) permettant d'effectuer la transformation de média (GPU) pour conversion de format, scaling, etc...

#### 2.1.2.1. Source caméra

- Démarrer le streaming vidéo en le diffusant au framebuffer et via UDP :
```shell
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,format=UYVY,width=640,height=640,framerate=20/1 ! tee name=t ! queue ! imxg2dvideotransform ! imxvpuenc_h264 bitrate=0 quantization=25 ! rtph264pay ! udpsink host=192.168.0.20 port=1234 t. ! queue ! imxg2dvideotransform ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0
```
> L'élément `imxg2dvideotransform` remplace les éléments génériques `videoconvert` (conversion de format) et `videoscale`.  
> Cet élement dans la `queue` liée au streaming n'est pas obligatoire mais permet un meilleur rendu des couleurs

- Démarrer le streaming vidéo en le diffusant seulement sur le framebuffer :
```shell
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,format=UYVY,width=640,height=640,framerate=20/1 ! queue ! imxg2dvideotransform ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0
```

- Démarrer le streaming vidéo en le diffusant seulement via UDP :
```shell
gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,format=UYVY,width=640,height=640,framerate=20/1 ! queue ! imxg2dvideotransform ! imxvpuenc_h264 bitrate=0 quantization=25 ! rtph264pay ! udpsink host=192.168.0.20 port=1234
```

#### 2.1.2.2. Source simulée

- Démarrer le streaming vidéo en le diffusant au framebuffer et via UDP :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-raw,width=640,height=640,framerate=20/1 ! tee name=t ! queue ! imxg2dvideotransform ! imxvpuenc_h264 bitrate=0 quantization=25 ! rtph264pay ! udpsink host=192.168.0.20 port=1234 t. ! queue ! imxg2dvideotransform ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0
```

- Démarrer le streaming vidéo en le diffusant seulement sur le framebuffer :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-raw,width=640,height=640,framerate=20/1 ! queue ! imxg2dvideotransform ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0
```

- Démarrer le streaming vidéo en le diffusant seulement via UDP :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-raw,width=640,height=640,framerate=20/1 ! queue ! imxg2dvideotransform ! imxvpuenc_h264 bitrate=0 quantization=25 ! rtph264pay ! udpsink host=192.168.0.20 port=1234
```

## 2.2. Coté client

### 2.2.1. Via GStreamer
On peut recuperer le flux sur le PC connecte via la commande GStreamer (UNIX) :
```shell
LIBVA_DRIVER_NAME=iHD gst-launch-1.0 -v udpsrc port=1234 caps="application/x-rtp, media=(string)video, clock-rate=(int)90000, payload=(int)96, encoding-name=(string)H264" ! queue ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink
```
> Le paramètre `LIBVA_DRIVER_NAME=iHD` peut être nécessaire si présence de 2 cartes graphiques sur le PC récepteur.  
> Ici, on demande à utiliser la carte graphique Intel.

### 2.2.2. Via fichier `.sdp`
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

# 3. Informations importantes
## 3.1. Mode bayer

- Exemple de pipeline en mode bayer (diffusion sur framebuffer) :
```shell
gst-launch-1.0 -v videotestsrc pattern=ball is-live=true ! video/x-bayer,format=grbg,width=432,height=432,framerate=30/1 ! bayer2rgb ! queue ! videoconvert ! videoscale method=0 ! video/x-raw,width=128,height=128 ! fbdevsink device=/dev/fb0
```
> - Note that gstreamer may only be able to handle 8 bits bayer frames, so you may try first to get it working in this mode. Note however that you would have to debayer frames with a gstreamer plugin `bayer2rgb` that runs on CPU.  
> - Note that `bayer2rgb` is in gst plugins bad package if not yet installed. It may be slow, so it may be better to boost your jetson with MAXN nvpmodel and max clocks.  
> - Note that for some ARM and ARM64 platforms (like **IMX** family for example), **NEON** acceleration can be available, so you may test with the plugin `bayer2rgb-neon` instead of `bayer2rgb`

# 4. Lecture vidéo

GStreamer permet la lecture de tous les formats vidéos (à condition d'avoir les plugins ncéessaires à chaque format).  
Afin de vérifier rapidement si votre plateforme possède les éléments nécessaires à la lecture de la vidéo, nous pouvons utiliser le plugin [`playbin`][doc-gst-playbin] qui va automatiquement générer le pipeline nécessaire, en se basant sur les plugins disponibles.

## 4.1. Pipeline automatique
Ainsi, pour lire une vidéo :
```shell
# Format ".mp4"
gst-launch-1.0 -v playbin uri=file:///home/user/media/vid/mp4/SampleVideo_128x128_30mb.mp4 video-sink=fbdevsink audio-sink=fakesink

# Format .mov
gst-launch-1.0 -v playbin uri=file:///home/user/media/vid/mov/file_example_MOV_480_700kB video-sink=fbdevsink audio-sink=fakesink
```
> On notera que la seule différence entre ces deux commandes sont les fichiers d'entrée (les plugins utilisés en interne sont bien différents)  
> Il est possible de ne pas préciser les _sink_ vidéos et audio, les plugins `autovideosink` et `autoaudiosink` seront alors utilisés.

Il est également possible d'utiliser d'autres plugins en plus de `playbin`, pour "scale" la vidéo par exemple avec `videoscale` :
```shell
gst-launch-1.0 playbin uri=file:///home/user/media/vid/mp4/SampleVideo_128x128_30mb.mp4 video-sink="videoscale ! video/x-raw,width=128,height=128 ! fbdevsink" audio-sink=fakesink
```
> Pour utiliser d'autres plugins, on notera l'utilisation des guillemets `"` dans le _sink_ de sortie.

## 4.2. Pipeline manuel

L'élément `playbin`, permet de construire rapidement son pipeline, mais il peut également être sujet à des soucis de performances. Il devient alors nécessaire de construire manuellement le pipeline.  
La construction manuelle du pipeline peut être nécessaire aussi par exemple si certains flux ne sont pas nécessaires (audio par exemple) ou si certaines méthodes peuvent être améliorées (choix du décodeur par exemple).  
Nous réutiliserons ici l'exemple avec le fichier `.mp4` précédent.

En étudiant les diagrammes générés par **GStreamer**, on peut constater que certains plugins peuvent ne pas être nécessaires.  
Ainsi pour lire un fichier `.mp4` :
```shell
gst-launch-1.0 filesrc location=/home/user/media/vid/mp4/SampleVideo_128x128_30mb.mp4 ! qtdemux name=demux  demux.audio_0 ! queue ! decodebin ! audioconvert ! fakesink  demux.video_0 ! queue ! avdec_h264 ! videoconvert ! fbdevsink
```
> Le format `.mp4` est un conteneur de flux, on dit qu'ils sont "muxés", il faut alors les "démuxer" (pour un fichier `.mp4`, on va séparer les flux vidéos, audios et sous-titres). C'est le rôle du plugin [`qtdemux`][doc-gst-qtdemux] (pour QuickTime Demuxer).  
> Il faut ensuite décoder la vidéo, dans notre cas, la vidéo était encodée avec le codec **x264**. C'est le rôle du plugin [`avdec_h264`][doc-gst-avdec_h264] (_libav h264 decoder_).

Dans notre cas, seule la vidéo nous intéresse, il est possible d'ignorer l'audio :
```shell
gst-launch-1.0 filesrc location=/home/user/media/vid/mp4/SampleVideo_128x128_30mb.mp4 ! qtdemux name=demux  demux.video_0 ! queue ! avdec_h264 ! videoconvert ! fbdevsink
```
> **Note 1** : `avdec_h264` n'est pas le seul plugin décodeur _h264_ disponible, il y a également `v4l2h264dec` (et plein d'autres !).  
> **Note 2** : Si possible, toujours utiliser le plugin `h264parse` avant d'encoder/décoder une vidéo en h264.  
> It does the following :
> - Handles stream format conversion.
> - Handles alignment conversion.
> - Implements  periodic SPS/PPS insertion via the config-interval property. You can use this to ensure seeking works correctly in some circumstances.  
> You don't necessarily need to have this plugin in your pipeline, but if you have a variety of source content, or you don't have a say in how the source content is created, then you probably want it in your pipeline. 

# 5. Fonctionnalités
## 5.1. Obtenir des diagrammes/graphes

GStreamer est capable de générer les graphes de chacun des éléments utilisés dans un pipeline, ce qui peut être utile pour savoir quelle a été la configuration exacte utilisée.  
Cette fonctionnalité est également très intéressante lorsque nous utilisons des éléments comme [`playbin`][doc-gst-playbin] ou [`decodebin`][doc-gst-decodebin] qui vont automatiquement utiliser les éléments nécessaires pour la lectrure d'un flux.  
Nous axerons ce tutoriel au travers de `playbin` avec la lecture d'un fichier vidéo.
> Ressources utilisées :
> - [Which elements are contained in decodebin ?][thread-others-which-elt-contained-decodebin]
> - [How to generate a GStreamer pipeline diagram (graph)][tutorial-gst-pipeline-diagram]

Pour la commande suivante permettant la lecture d'un fichier `.mp4` :
```shell
gst-launch-1.0 -v playbin uri=file:///home/user/media/vid/mp4/SampleVideo_128x128_30mb.mp4 video-sink=fbdevsink audio-sink=fakesink
```

Pour générer les diagrammes **GStreamer** :
1. Définir la variable `GST_DEBUG_DUMP_DOT_DIR`  
Cette variable permet de définir où devront être enregistrés les fichier `.dot`, qui sont les diagrammes. Si aucune valeur, aucun diagramme ne sera généré. Ainsi, un diagramme sera généré à chaque changements d'état du pipeline :
```shell
GST_DEBUG_DUMP_DOT_DIR=/home/user gst-launch-1.0 -v playbin uri=file:///home/ciele/media/vid/mp4/SampleVideo_128x128_30mb.mp4 video-sink=fbdevsink audio-sink=fakesink
```
> Ici, nous avons obtenu :
> - 0.00.00.122276333-gst-launch.NULL_READY
> - 0.00.00.545431666-gst-launch.READY_PAUSED
> - 0.00.02.171714000-gst-launch.PAUSED_PLAYING
> - 0.00.13.888280001-gst-launch.PLAYING_READY

2. Convertir les fichiers `.dot` en fichiers `.png` via le paquet `ghraphviz` :
```shell
# Convert only one file
dot -Tpng 0.00.00.545431666-gst-launch.READY_PAUSED.dot -o0.00.00.545431666-gst-launch.READY_PAUSED.png

# Convert multiple files in one command (for current directory)
ls -1 *.dot | xargs -I{} dot -Tpng {} -o{}.png
```
> Les fichiers obtenues sont disponibles dans [Gstreamer/res/graphs][repo-gst-graphs]

# 6. Ressources

- Documentation officielle **GStreamer**:
  - [Accès à tous les plugins][doc-gst-all-plugins]
  - Gestion pipeline
    - [tee][doc-gst-tee]
    - [queue][doc-gst-queue]
    - [decodebin][doc-gst-decodebin]
    - [`playbin`][doc-gst-playbin]
  - Source
    - [videotestsrc][doc-gst-videotestsrc]
    - [v4l2src][doc-gst-v4l2src]
    - [uvch264src][doc-gst-uvch264src]
    - [filesrc][doc-gst-filesrc]
  - Transformation
    - [videocrop][doc-gst-videocrop]
    - [videoscale][doc-gst-videoscale]
  - Convertion
    - [videoconvert][doc-gst-videoconvert]
    - [bayer2rgb][doc-gst-bayer2rgb]
  - Transformation & convertion
    - imxg2dvideotransform
  - Demuxers
    - [`qtdemux`][doc-gst-qtdemux]
  - Codec parser
    - [h264parse][doc-gst-h264parse]
  - Encodeurs
    - imxvpuenc_h264
    - v4l2h264enc
    - [x264enc][doc-gst-x264enc]
  - Decodeurs
    - v4l2h264dec
    - [avdec_h264][doc-gst-avdec_h264]
  - Réseau
    - [rtph264pay][doc-gst-rtph264pay]
    - [rtph264depay][doc-gst-rtph264depay]
    - [udpsink][doc-gst-udpsink]
    - [udpsrc][doc-gst-udpsrc]
  - Ecran
    - [fbdevsink][doc-gst-fbdevsink]
  - SDP
    - [sdpdemux][doc-gst-sdpdemux]
  - Autres
    - [autovideosink][doc-gst-autovideosink]
- Documentation officielle **NXP** :
  - [Processeurs IMX8][doc-nxp-imx8]
  - [i.IMX8 GStreamer User Guide][doc-nxp-imx8-gst] (If link unavailable, this PDF can be found in **Datasheets** directory of Borea)
- Documentation pour **Instructions NEON** :
  - [ARM Developer - Instruction sets - NEON][doc-armdev-neon-instructions-sets]
  - [ARM Developer - NEON Architecture overview][doc-armdev-neon-arch]
- Tutoriels
  - [Introduction to network streaming using GStreamer][tutorial-gst-stream-network]
  - [How to generate a Gstreamer pipeline diagram (graph)][tutorial-gst-pipeline-diagram]
  - [GStreamer cheatsheet][tutorial-gst-cheatsheet]
- Threads
  - Fichiers `.sdp`
    - [Pipeline GStreamer pour lire le flux depuis fichier `.sdp`](http://gstreamer-devel.966125.n4.nabble.com/Unable-to-play-a-rtp-stream-td4675068.html)
  - IMX8 encodeurs :
    - https://community.nxp.com/t5/i-MX-Processors/iMX8M-Software-H-264-Encoding-Speed-Not-as-Advertised/m-p/981332/highlight/true
    - https://community.nxp.com/t5/i-MX-Processors/i-MX8M-SW-Video-Encoder-Linux/td-p/748960
  - Détails concernant le plugin `h264parse` :
    - [Usage of h264parse](http://gstreamer-devel.966125.n4.nabble.com/Usage-of-h264parse-td4671122.html)
    - [What's the difference between h264parse and x264enc](http://gstreamer-devel.966125.n4.nabble.com/What-s-the-difference-between-h264parse-and-x264enc-td4665616.html)
    - [h264parse element needed to play video in VLC after encoding with nvh264enc](http://gstreamer-devel.966125.n4.nabble.com/h264parse-element-needed-to-play-video-in-VLC-after-encoding-with-nvh264enc-td4692147.html)
    - [Usage of h264parse and rtph264pay](http://gstreamer-devel.966125.n4.nabble.com/Usage-of-h264parse-and-rtph264pay-td4683943.html)
    - [How to demux a mp4 file to a encoded 264 video file by qtdemux ?](http://gstreamer-devel.966125.n4.nabble.com/How-to-demux-a-mp4-file-to-a-encoded-264-video-file-by-qtdemux-td4670615.html)
  - Autres
    - [GStreamer pipeline gets warning from FBDevSink: buffers being dropped while doing Tee with h264 encoding](https://stackoverflow.com/questions/65996592/gstreamer-pipeline-gets-warning-from-fbdevsink-buffers-being-dropped-while-doin)
    - [Streaming issues with gst-launch-1.0 with a custom camera device](https://forums.developer.nvidia.com/t/streaming-issues-with-gst-launch-1-0-with-a-custom-camera-device/73505/3)
    - [Which elements are contained in decodebin ?](https://stackoverflow.com/questions/42297360/which-elements-are-contained-in-decodebin)
    - [Decode a mp4 video with gstreamer](https://stackoverflow.com/questions/13500893/decode-a-mp4-video-with-gstreamer)
    - [v4l2h264dec instead of omxh264dec](https://www.raspberrypi.org/forums/viewtopic.php?t=240274)

<!-- Images -->
[icon-valid]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
[icon-invalid]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
[icon-slow]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
[icon-lag]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"

<!-- Anchor of this file -->
[anchor-ressources]: #6-ressources

<!-- Link to this repository -->
[repo-gst-graphs]: https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/GStreamer/res/graphs

<!-- External links -->
[doc-gst-all-plugins]: https://gstreamer.freedesktop.org/documentation/plugins_doc.html?gi-language=c
[doc-gst-autovideosink]: https://gstreamer.freedesktop.org/documentation/autodetect/autovideosink.html?gi-language=c
[doc-gst-avdec_h264]: https://gstreamer.freedesktop.org/documentation/libav/avdec_h264.html?gi-language=c
[doc-gst-bayer2rgb]: https://gstreamer.freedesktop.org/documentation/bayer/bayer2rgb.html?gi-language=c
[doc-gst-decodebin]: https://gstreamer.freedesktop.org/documentation/playback/decodebin.html?gi-language=c
[doc-gst-fbdevsink]: https://gstreamer.freedesktop.org/documentation/fbdevsink/index.html?gi-language=c
[doc-gst-filesrc]: https://gstreamer.freedesktop.org/documentation/coreelements/filesrc.html?gi-language=c
[doc-gst-h264parse]: https://gstreamer.freedesktop.org/documentation/videoparsersbad/h264parse.html?gi-language=c
[doc-gst-playbin]: https://gstreamer.freedesktop.org/documentation/playback/playbin.html
[doc-gst-qtdemux]: https://gstreamer.freedesktop.org/documentation/isomp4/qtdemux.html?gi-language=c
[doc-gst-queue]: https://gstreamer.freedesktop.org/documentation/coreelements/queue.html?gi-language=c
[doc-gst-rtph264pay]: https://gstreamer.freedesktop.org/documentation/rtp/rtph264pay.html?gi-language=c
[doc-gst-rtph264depay]: https://gstreamer.freedesktop.org/documentation/rtp/rtph264depay.html?gi-language=c
[doc-gst-sdpdemux]: https://gstreamer.freedesktop.org/documentation/sdpelem/sdpdemux.html?gi-language=c
[doc-gst-tee]: https://gstreamer.freedesktop.org/documentation/coreelements/tee.html?gi-language=c
[doc-gst-udpsink]: https://gstreamer.freedesktop.org/documentation/udp/udpsink.html?gi-language=c
[doc-gst-udpsrc]: https://gstreamer.freedesktop.org/documentation/udp/udpsrc.html?gi-language=c
[doc-gst-uvch264src]: https://gstreamer.freedesktop.org/documentation/uvch264/uvch264src.html?gi-language=c
[doc-gst-v4l2src]: https://gstreamer.freedesktop.org/documentation/video4linux2/v4l2src.html?gi-language=c
[doc-gst-videoconvert]: https://gstreamer.freedesktop.org/documentation/videoconvert/index.html?gi-language=c
[doc-gst-videocrop]: https://gstreamer.freedesktop.org/documentation/videocrop/videocrop.html?gi-language=c
[doc-gst-videoscale]: https://gstreamer.freedesktop.org/documentation/videoscale/index.html?gi-language=c
[doc-gst-videotestsrc]: https://gstreamer.freedesktop.org/documentation/videotestsrc/index.html
[doc-gst-x264enc]: https://gstreamer.freedesktop.org/documentation/x264/index.html?gi-language=c

[doc-nxp-imx8]: https://www.nxp.com/products/processors-and-microcontrollers/arm-processors/i-mx-applications-processors/i-mx-8-processors:IMX8-SERIES
[doc-nxp-imx8-gst]: https://community.nxp.com/t5/i-MX-Processors-Knowledge-Base/i-MX-8-GStreamer-User-Guide/ta-p/1098942?attachment-id=101553

[doc-armdev-neon-instructions-sets]: https://developer.arm.com/architectures/instruction-sets/simd-isas/neon
[doc-armdev-neon-arch]: https://developer.arm.com/documentation/dht0002/a/Introducing-NEON/NEON-architecture-overview/NEON-instructions

[tutorial-gst-cheatsheet]: https://gist.github.com/strezh/9114204
[tutorial-gst-pipeline-diagram]: https://developer.ridgerun.com/wiki/index.php/How_to_generate_a_Gstreamer_pipeline_diagram_(graph)
[tutorial-gst-stream-network]: https://developer.ridgerun.com/wiki/index.php/Introduction_to_network_streaming_using_GStreamer

[thread-others-which-elt-contained-decodebin]: https://stackoverflow.com/questions/42297360/which-elements-are-contained-in-decodebin