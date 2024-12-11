By default, Windows OS doesn't include all codecs (VP9, H265, etc...), some libraries directly includes those (FFmpeg, VLC, etc...) but when working with _Windows native backend_, codecs installation will be required.  
We will use [K-Lite codecs packages][klite-home] which can be hard to install/configure for _lambda users_, so this page will describe how to create a custom installer

**Table of contents :**
- [1. Create custom installer](#1-create-custom-installer)
- [2. Use custom installer](#2-use-custom-installer)
- [3. Uninstall custom installer](#3-uninstall-custom-installer)
- [4. Ressources](#4-ressources)

# 1. Create custom installer

1. Download [K-Lite basic package][klite-download] (_ex: K-Lite_Codec_Pack_1870_Basic.exe_ )
2. Open a terminal with admin privileges
3. Run setup file with `/unattended` options
```shell
K-Lite_Codec_Pack_1870_Basic.exe /unattended
```
4. This command will open the GUI installer, configure all needed options
5. At the end, installer will generate 2 files:
- `klcp_basic_unattended.bat`
- `klcp_basic_unattended.ini`  
> [!NOTE]
> Those scripts are gonna be used to install **K-Lite Codec Package** on target

# 2. Use custom installer

To use custom installer, open a terminal (doesn't need to be admin), then two solutions:
- Using the generated `.bat` file:
```shell
klcp_basic_unattended.bat
```

- Running manually with args:
```shell
"K-Lite_Codec_Pack_1870_Basic.exe" /VERYSILENT /NORESTART /SUPPRESSMSGBOXES /LOADINF="klcp_basic_unattended.ini"
```

# 3. Uninstall custom installer

```shell
# On 32-bits platforms
"%ProgramFiles%\K-Lite Codec Pack\unins000.exe" /VERYSILENT /NORESTART

# On 64-bits platforms
"%ProgramFiles(x86)%\K-Lite Codec Pack\unins000.exe" /VERYSILENT /NORESTART
```

# 4. Ressources

- Official :
  - [K-Lite Codec Package][klite-download]
  - [K-Lite Codec custom installation][klite-install]
- Tutorials
  - https://www.rarst.net/software/k-lite-silent-install/
  - https://silentinstallhq.com/k-lite-codec-pack-silent-install-how-to-guide/
  - http://www.technical-recipes.com/2014/creating-silent-installs-of-audio-and-video-codecs-using-k-lite/
- Scripts
  - https://silentinstallhq.com/k-lite-codec-pack-install-and-uninstall-powershell/

<!-- External links -->
[klite-home]: https://codecguide.com/index.html
[klite-download]: https://www.codecguide.com/download_kl.htm
[klite-install]: https://www.codecguide.com/silentinstall.htm