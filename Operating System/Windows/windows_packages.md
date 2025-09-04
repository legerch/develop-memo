This file list all needed packages for **Windows OS** according to each usage.

**Table of contents :**
- [1. Developer tools](#1-developer-tools)
  - [1.1. Compilers](#11-compilers)
  - [1.2. VCPKG](#12-vcpkg)
  - [1.3. Git](#13-git)
  - [1.4. Serial communication](#14-serial-communication)
  - [1.5. Analyzers](#15-analyzers)
    - [1.5.1. Include analyzer](#151-include-analyzer)
  - [1.6. Logs](#16-logs)
  - [1.7. File comparaison viewer](#17-file-comparaison-viewer)
  - [1.8. Hexadecimal viewer](#18-hexadecimal-viewer)
  - [1.9. Documentation](#19-documentation)
  - [1.10. Charts tools](#110-charts-tools)
  - [1.11. Color picker](#111-color-picker)
  - [1.12. Compression tools](#112-compression-tools)
  - [1.13. Hash tools](#113-hash-tools)
  - [1.14. Arduino development](#114-arduino-development)
- [2. Edition tools](#2-edition-tools)
  - [2.1. Qt](#21-qt)
  - [2.2. Visual Studio Code](#22-visual-studio-code)
  - [2.3. Others](#23-others)
- [3. Networking tools](#3-networking-tools)
- [4. Emails](#4-emails)
- [5. Multimedia tools](#5-multimedia-tools)
  - [5.1. Video media](#51-video-media)
    - [5.1.1. Player](#511-player)
    - [5.1.2. Metadata informations](#512-metadata-informations)
    - [5.1.3. MKV video files utilities](#513-mkv-video-files-utilities)
    - [5.1.4. Subtitles utilities](#514-subtitles-utilities)
    - [5.1.5. Videos editors](#515-videos-editors)
    - [5.1.6. Downloaders](#516-downloaders)
  - [5.2. Text media](#52-text-media)

# 1. Developer tools
## 1.1. Compilers

- [MSVC][compiler-msvc]

## 1.2. VCPKG

See [VCPKG tutorial][vcpkg-tutorial] for more details

## 1.3. Git

- [Git][git-home]
- [Gitkraken][gitkraken-home]

## 1.4. Serial communication

- [Putty][putty-home]
- [Multi-tab Putty][mtputty-home]

## 1.5. Analyzers
### 1.5.1. Include analyzer

Multiple project can help to remove uneeded includes directives:
- [minclude][minclude]
- [cland][clangd-doc-unused-header]
- [include-what-you-use]

## 1.6. Logs

- [klogg][klogg-home] (A custom _klogg highlighters_ configuration can be found at [klogg-highlighters][res-klogg-highlighter])

## 1.7. File comparaison viewer

- [meld][meld-home]

## 1.8. Hexadecimal viewer

- [ImHex][imhex-home]

## 1.9. Documentation

- [Doxygen][doxygen-home]

## 1.10. Charts tools

- [DrawIO][drawio-home]

## 1.11. Color picker

- [MS Powertools][powertoys-home]

## 1.12. Compression tools

- [7zip][7zip-home]
- [Caesium Image Compressor][caesium-home]

## 1.13. Hash tools

- [OpenHashTab][hashtab-home]

## 1.14. Arduino development

See [Doc - Arduino development][doc-arduino] for more details.

# 2. Edition tools
## 2.1. Qt

See [Doc - Qt][doc-qt] for more details

## 2.2. Visual Studio Code

See [Doc - Visual Studio Code][doc-vscode] for more details

## 2.3. Others

- [Notepad++][notepad-home]

# 3. Networking tools

- Network analyze:
  - [Wireshark][wireshark-home]
  - [Iperf3][iperf-home] (and [iperfbin][iperf-bin])
- Network transfer:
  - [Filezilla][filezilla-home]
- Access-point analyze: see [access-point ressource][doc-net-access-point] documentation

# 4. Emails

- [Thunderbird][thunderbird-home]

# 5. Multimedia tools
## 5.1. Video media
### 5.1.1. Player

- [VLC][vlc-home]
- [Media Player Classic][mpc-be-home]

### 5.1.2. Metadata informations

- Readers:
  - Video:
    - [mediainfo][mediainfo-home]
- Writers:
  - Music:
    - [Mp3Tag][mp3tag-home]

### 5.1.3. MKV video files utilities

- Manage MKVs
  - [MkvToolnix][mkvtoolnix-home]: Create MKV files
  - [gMKVExtractGUI][mkvextract-home]: Extract tracks from MkVs
  - [ChapterMakerMkv][chapter-maker-mkv-home]: Create chapter file for MKV videos
  - [MKVToolNix Batch Tool][mkvtoolnix-batch-tool-home]: Batch multiple MKVs file
- Create MKVs
  - [MakeMKV][makemkv-home]: Create MKV from DVDs, Bluray or ISOs files
  - [HD-DVD/Blu-Ray Stream Extractor][hdbrstreamextractor-home]: GUI application to [eac3to][eac3to-home] utility
- Rename files
  - [Rename My TV Series][rename-tv-series-home]: Use to rename TV series video files
- Manage video database
  - [EMDB][emdb-home]: Manage all your movies/tv series

### 5.1.4. Subtitles utilities

- Editors:
  - [Subtitle Edit][subtitle-edit-home]
- Synchronization
  - [Subtitle Speech Synchronizer][subtitle-speech-sync-home]

### 5.1.5. Videos editors

- [LosslessCut][losslesscut-home]
- [FFMPEG][ffmpeg-home]

### 5.1.6. Downloaders

- [Open Video Downloader][open-video-dl-home]

## 5.2. Text media

- [office365][office365-home]
- [libreoffice][libreoffice-home]

<!-- Anchor of this page -->

<!-- Links of this repository -->
[doc-arduino]: ../../Arduino/
[doc-net-access-point]: ../../Network/access-point/
[doc-qt]: ../../Qt/
[doc-vscode]: ../../IDE/VsCode/

[res-klogg-highlighter]: ../Linux/Ubuntu/ressources/klogg/logs.conf

[vcpkg-tutorial]: ../../Toolchains/Build%20systems/VCPKG/README.md

<!-- External links -->
[7zip-home]: https://www.7-zip.org/
[caesium-home]: https://github.com/Lymphatus/caesium-image-compressor
[clangd-doc-unused-header]: https://clangd.llvm.org/guides/include-cleaner
[compiler-msvc]: https://visualstudio.microsoft.com/fr/downloads/
[doxygen-home]: https://www.doxygen.nl/
[drawio-home]: https://github.com/jgraph/drawio-desktop
[eac3to-home]: https://www.videohelp.com/software/eac3to
[emdb-home]: https://www.emdb.eu/
[ffmpeg-home]: https://ffmpeg.org/
[filezilla-home]: https://filezilla-project.org/
[git-home]: https://git-scm.com/
[gitkraken-home]: https://www.gitkraken.com/
[gitkraken-doc-install]: https://support.gitkraken.com/how-to-install/
[handbrake-home]: https://github.com/HandBrake/HandBrake
[hashtab-home]: https://github.com/namazso/OpenHashTab
[hdbrstreamextractor-home]: https://www.videohelp.com/software/HD-DVD-Blu-Ray-Stream-Extractor
[imhex-home]: https://github.com/WerWolv/ImHex
[include-what-you-use]: https://github.com/include-what-you-use/include-what-you-use
[iperf-home]: https://github.com/esnet/iperf
[iperf-bin]: https://files.budman.pw/
[klogg-home]: https://github.com/variar/klogg
[libdvdcss-home]: https://github.com/allienx/libdvdcss-dll
[libreoffice-home]: https://fr.libreoffice.org/download/telecharger-libreoffice/
[losslesscut-home]: https://github.com/mifi/lossless-cut
[makemkv-home]: https://www.makemkv.com/
[meld-home]: https://meldmerge.org/
[minclude]: https://github.com/jhasse/minclude
[mtputty-home]: https://ttyplus.com/multi-tabbed-putty/
[notepad-home]: https://notepad-plus-plus.org/
[powertoys-home]: https://github.com/microsoft/PowerToys
[putty-home]: https://www.putty.org/
[rename-tv-series-home]: https://www.tweaking4all.com/home-theatre/rename-my-tv-series-v2/
[subtitle-edit-home]: https://github.com/SubtitleEdit/subtitleedit
[subtitle-speech-sync-home]: https://github.com/sc0ty/subsync
[thunderbird-home]: https://www.thunderbird.net
[vlc-home]: https://www.videolan.org/vlc/
[wireshark-home]: https://www.wireshark.org/
