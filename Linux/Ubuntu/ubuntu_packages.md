This file list all needed packages for **Ubuntu OS** according to each usage.

**Table of contents :**
- [1. Mandatory commands](#1-mandatory-commands)
  - [1.1. Apt manager](#11-apt-manager)
  - [1.2. Snap](#12-snap)
  - [1.3. Flatpak](#13-flatpak)
  - [1.4. Firmware update](#14-firmware-update)
- [2. Developer tools](#2-developer-tools)
  - [2.1. Standard](#21-standard)
  - [2.2. Terminal](#22-terminal)
  - [2.3. Serial communication](#23-serial-communication)
    - [2.3.1. Installation](#231-installation)
    - [2.3.2. Usage](#232-usage)
    - [2.3.3. Configuration](#233-configuration)
      - [2.3.3.1. Fail to write](#2331-fail-to-write)
      - [2.3.3.2. Enable colors output](#2332-enable-colors-output)
      - [2.3.3.3. Enable wrapping long lines](#2333-enable-wrapping-long-lines)
  - [2.4. Logs](#24-logs)
    - [2.4.1. Installation](#241-installation)
    - [2.4.2. Custom configuration](#242-custom-configuration)
      - [2.4.2.1. glogg](#2421-glogg)
  - [2.5. File comparaison viewer](#25-file-comparaison-viewer)
  - [2.6. Hexadecimal viewer](#26-hexadecimal-viewer)
  - [2.7. Documentation](#27-documentation)
  - [2.8. CTRL-C memory](#28-ctrl-c-memory)
  - [2.9. Charts tools](#29-charts-tools)
  - [2.10. Box of tools for developers](#210-box-of-tools-for-developers)
  - [2.11. Color picker](#211-color-picker)
  - [2.12. QrCode](#212-qrcode)
  - [2.13. Arduino development](#213-arduino-development)
- [3. Buildroot/kernels requirements](#3-buildrootkernels-requirements)
  - [3.1. Mandatory packages](#31-mandatory-packages)
  - [3.2. Optional packages](#32-optional-packages)
- [4. Edition tools](#4-edition-tools)
  - [4.1. Qt](#41-qt)
  - [4.2. Visual Studio Code](#42-visual-studio-code)
  - [4.3. Gedit](#43-gedit)
  - [4.4. Vi](#44-vi)
- [5. Git UI](#5-git-ui)
  - [5.1. Generic](#51-generic)
  - [5.2. Compatibe 50/72 rule](#52-compatibe-5072-rule)
- [6. System management](#6-system-management)
- [7. Networking tools](#7-networking-tools)
- [8. Emails](#8-emails)
- [9. Graphics libraries](#9-graphics-libraries)
- [10. Multimedia tools](#10-multimedia-tools)
- [11. GNOME Customization](#11-gnome-customization)
  - [11.1. GNOME Plugins](#111-gnome-plugins)
  - [11.2. GNOME Editor](#112-gnome-editor)
- [12. Microsoft tools](#12-microsoft-tools)

# 1. Mandatory commands

## 1.1. Apt manager
- Update your system :
```shell
sudo apt update
sudo apt full-upgrade
```

- Install/uninstall package :
```shell
sudo apt install <package_name>
sudo apt purge --autoremove <package_name>
```

## 1.2. Snap

List of available package can be found at [snapcraft repositories][snapcraft-repositories].  
Official documentation can be found at [snapcraft documentation][snapcraft-documentation].  

- Update all packages :
```shell
sudo snap refresh
```

- Revert to a previous snap version package :
```shell
sudo snap revert <package_name>
```

- Install/uninstall package :
```shell
sudo snap install <package_name>
sudo snap remove --purge <package_name>
```

- List installed packages :
```shell
snap list
```

## 1.3. Flatpak

Official documentation can be found at [flatpak documentation][flatpak-documentation].  
One main flatpak repository is [flathub][flatpak-repositories]

- Update all packages :
```shell
flatpak update
```

- Install/uninstall package :
```shell
flatpak install <package_name>
```

- List installed packages :
```shell
flatpak list --app
```

## 1.4. Firmware update

Host firmware can be updated too (bios, device firmware, etc...).  
This is possible thanks to [Linux Vendor Firmware Service][lvfs-official] which is a secure portal which allows hardware vendors to upload firmware.

In order to update host firmware, _firmware update daemon_ must be installed :
```shell
sudo apt install fwupd
```
> _fwupd_ versions are also available through **Snap** and **Flatpack**

- Display supported devices :
```shell
fwupdmgr get-devices
```

- Update firmwares of supported devices :
```shell
fwupdmgr refresh        # This option will download the latest metadata from LVFS
fwupdmgr get-updates    # This option will display the available updates for any devices on the system

fwupdmgr update         # This option download and apply all updates for your system
```
> Tutorials used to write this section :
> - [lvfs-official]
> - [lvfs-repository]
> - [lvfs-ubuntu]
> - [lvfs-tutorial-linoxide]

# 2. Developer tools
## 2.1. Standard

```shell
sudo apt install build-essential git git-email tree
```
> If you intend to contribute to mainline project, use a git editor which allow to follow 50/72 rule (see [git editor compatible with 50/72 rule][anchor-git-ui-50-72]

## 2.2. Terminal

Terminal is shipped by default but some customizations can help for development :
- General
  - **Theme** : `Dark`
- Keyboard shortcut :
  - **New tab** : `CTRL + T`
  - **Previous tab** : `CTRL + LEFT`
  - **Next tab** : `CTRL + RIGHT`
- Profils
  - Colors
    - **Use system theme** : `true`
    - **Palette** : `Tango`

## 2.3. Serial communication
### 2.3.1. Installation
```shell
sudo apt install minicom
```

### 2.3.2. Usage

- Start a session :
```shell
sudo minicom -D /dev/ttyUSB0 -b 115200 -c on -w
```

- Display help : `CTRL+A Z`
> **Warning** : be careful, in some distributions, keyboard shortcut terminal has `CTRL+A` set for _select all_.  
> `minicom` command will not be available if this shortcut is set.

- Exit session : `CTRL+A X`
- Send file by using protocol _zmodem_, _ymodem_, _xmodem_ or _kermit_ : `CTRL+A S`
> Ressources used :
> - [StackExchange - File transfer using YMODEM sz][minicom-send-file]

### 2.3.3. Configuration

#### 2.3.3.1. Fail to write

Minicom **read** properly but **writing** failed (no entry is written when pressing keyboard) :
1. Start _minicom_ configuration : `sudo minicom -o -s`
2. Select `Serial port setup` entry with **ENTER** :
   1. Disable _Hardware flow control_ option (under _minicom 2.8_, key to set this value is **F**)
   2. Press **ENTER** to go back to main menu
3. Save setup as default setup with `Save setup as dfl` entry with **ENTER**
4. Go to `Exit from Minicom` to quit minicom configuration

> Ressources used to resolve the issue :
> - [AskUbuntu - Minicom doesn't work][minicom-write-failure-thread-askubuntu]
> - [Tutorial : Configure minicom for a USB-to-Serial Converter][minicom-write-failure-tutorial]

#### 2.3.3.2. Enable colors output

To enable color output with _minicom_, you need to use option : `minicom -c on`
> Ressources used :
> - [debian.org : color for minicom ?][minicom-color-option-thread-debianorg]

#### 2.3.3.3. Enable wrapping long lines

To enable wrap with _minicom_, use option `-w` (`--wrap`).

## 2.4. Logs
### 2.4.1. Installation
```shell
sudo apt install glogg
```
> [glogg][glogg-repository] hasn't been updated since _august 2018_, [klogg][klogg-repository] seems to be a really good fork but doesn't provide any `apt` packaging yet...

### 2.4.2. Custom configuration
#### 2.4.2.1. glogg

| Description | Filters | Ignore case | Fore Color | Back Color |
|:-:|:-:|:-:|:-:|:-:|
| Debug messages | `.debug` | false | blue | white |
| Warnings messages | `.warn` | false | white | orange |
| Any warnings messages | `warning` | true | white | orange |
| Critical messages | `.crit` | false | white | red |
| Error messages | `.err` | false | white | red |
| Any error messages | `error` | true | white | red |
| Any failure messages | `fail` | true | red | white |
| Board is started | `syslog.info syslogd started` | false | black | lime |
| Application is restarted | `Scheduling for restart` | false | black | fuchsia |

## 2.5. File comparaison viewer

```shell
sudo apt install meld
```

## 2.6. Hexadecimal viewer

- [Gnome hex editor][gnome-hex-editor]
```shell
sudo apt install ghex
```

## 2.7. Documentation

```shell
sudo apt install doxygen doxygen-gui doxygen-doc
```

## 2.8. CTRL-C memory

See [CopyQ][copyq-official] official doumentation for more details.

## 2.9. Charts tools

```shell
sudo snap install drawio
```

## 2.10. Box of tools for developers

- [Dev toolbox][developer-toolbox]
```shell
flatpak install flathub me.iepure.devtoolbox
```

## 2.11. Color picker

- [eyedropper][eyedropper-repository] :
```shell
flatpak install flathub com.github.finefindus.eyedropper
```

- [ColorPicker][colorpicker-repository] :
```shell
sudo snap install color-picker
```

## 2.12. QrCode

- [qrencode][qrencode-man] :
```shell
sudo apt install qrencode
```

## 2.13. Arduino development

See [Doc - Arduino development][doc-arduino] for more details.

# 3. Buildroot/kernels requirements

In order to use [Buildroot][br-getting-started] framework to build _custom Linux OS_ and to compile [Linux kernel][kernel-index], some packages are needed.  
List of packages are based on manuals available at :
- [Buildroot - requirements][br-requirements]
- [Kernel - requirements][kernel-requirements]

## 3.1. Mandatory packages

[Standard developer tools][anchor-dev-tools-std] are needed, then install :
```shell
sudo apt install patch gzip bzip2 perl cpio unzip rsync python3 python-is-python3 # Buildroot
sudo apt install jfsutils flex bison util-linux reiserfsprogs xfsprogs btrfs-progs quota libssl-dev fakeroot u-boot-tools #kernel
```

## 3.2. Optional packages

- Buildroot GUI with _ncurses5_ : `sudo apt install libncurses-dev`
- Buildroot GUI with _qt_ : `sudo apt install qtbase5-dev`
- Buildroot GUI with _gtk_ : `sudo apt install libglade2-dev libglib2.0-dev libgtk2.0-dev`
> Note than `buildroot GUI` is `KConfig` which is also used in others projects: kernel, busybox, u-boot, etc...

# 4. Edition tools
## 4.1. Qt

See [Doc - Qt][doc-qt] for more details

## 4.2. Visual Studio Code

See [Doc - Visual Studio Code][doc-vscode] for more details

## 4.3. Gedit

Install & plugins :
```shell
sudo apt install gedit gedit-plugins
```

Themes :
- [Dracula][theme-gedit-dracula]

## 4.4. Vi

**Vi** is already installed by default, but doesn't have color support and navigation is not easy (characters are added when using arrow keys), so we need to use **Vim** instead :
```shell
sudo apt install vim
```
> **Note :** Command to use will still be `vi mydoc-to-edit.txt`.

# 5. Git UI
## 5.1. Generic

- [GitKraken][gitkraken-doc-install]

## 5.2. Compatibe 50/72 rule

To get more infomations about **50/72 rule**, see [git commit message][doc-git-commit-message].
- [GNOME Commit][git-app-commit]

# 6. System management

```shell
sudo apt install htop lm-sensors udisks2
sudo apt install y-ppa-manager # a PPA exist for this package
```

# 7. Networking tools

```shell
sudo apt install net-tools libpcap-dev libnet1-dev rpcbind openssh-client openssh-server nmap
sudo apt install wireshark
sudo apt install filezilla
sudo apt install iperf3
```

# 8. Emails

- Thunderbird :
```shell
sudo apt install thunderbird thunderbird-locale-fr
```

- GNOME Evolution :
```shell
sudo apt install evolution
```

# 9. Graphics libraries

[OpenGL][opengl] :
```shell
sudo apt install freeglut3 libopengl0
```

Mesa :
```shell
sudo apt install mesa-utils
```

# 10. Multimedia tools

```shell
sudo apt install vlc gimp mediainfo-gui
sudo apt install ffmpeg
sudo apt install gthumb
sudo apt install libreoffice # a PPA also exist for libreoffice

sudo snap install discord
``` 

# 11. GNOME Customization
## 11.1. GNOME Plugins
```shell
sudo apt install gnome-tweaks chrome-gnome-shell
sudo apt install gnome-shell-extension-freon # See https://github.com/UshakovVasilii/gnome-shell-extension-freon
```

## 11.2. GNOME Editor

GNOME allow preferences customization of properties with `gsettings` tool :
```shell
# To get value
gsettings get <path_element> <property>
# To set value
gsettings set <path_element> <property>
```
> If GUI solution is preferred, you can use [dconf-editor] tool.

Useful properties :
- Show hidden files : `gsettings set org.gnome.nautilus.preferences show-hidden-files true`
- Remove trash icon from the dock : `gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false`

# 12. Microsoft tools

- Microsoft teams : `sudo snap install teams`

<!-- Anchor of this page -->
[anchor-dev-tools-std]: #21-standard
[anchor-git-ui]: #5-git-ui
[anchor-git-ui-50-72]: #52-compatibe-5072-rule

<!-- Links of this repository -->
[doc-arduino]: ../../Arduino/
[doc-git-commit-message]: ../../Git/git-commit-message.md
[doc-qt]: ../../Qt/
[doc-vscode]: ../../IDE/VsCode/

<!-- External links -->
[br-getting-started]: https://buildroot.org/downloads/manual/manual.html#_getting_started
[br-requirements]: https://buildroot.org/downloads/manual/manual.html#requirement

[copyq-official]: https://hluk.github.io/CopyQ/
[colorpicker-repository]: https://github.com/keshavbhatt/ColorPicker
[dconf-editor]: https://doc.ubuntu-fr.org/dconf-editor
[developer-toolbox]: https://beta.flathub.org/apps/me.iepure.devtoolbox
[eyedropper-repository]: https://github.com/FineFindus/eyedropper
[git-app-commit]: https://apps.gnome.org/fr/app/re.sonny.Commit/
[gitkraken-doc-install]: https://support.gitkraken.com/how-to-install/
[gnome-hex-editor]: https://wiki.gnome.org/Apps/Ghex
[qrencode-man]: https://linux.die.net/man/1/qrencode

[glogg-repository]: https://github.com/nickbnf/glogg
[klogg-repository]: https://github.com/variar/klogg

[flatpak-documentation]: https://docs.flatpak.org/en/latest/using-flatpak.html
[flatpak-repositories]: https://flathub.org/home

[lvfs-official]: https://fwupd.org/
[lvfs-repository]: https://github.com/fwupd/fwupd
[lvfs-ubuntu]: https://doc.ubuntu-fr.org/lvfs
[lvfs-tutorial-linoxide]: https://linoxide.com/how-to-update-firmware-on-ubuntu-using-fwupd/

[kernel-index]: https://www.kernel.org/doc/html/v5.15/index.html
[kernel-requirements]: https://www.kernel.org/doc/html/v5.15/process/changes.html#minimal-requirements-to-compile-the-kernel

[minicom-write-failure-thread-askubuntu]: https://askubuntu.com/questions/638378/minicom-doesnt-work
[minicom-write-failure-tutorial]: https://www.centennialsoftwaresolutions.com/post/configure-minicom-for-a-usb-to-serial-converter
[minicom-color-option-thread-debianorg]: https://lists.debian.org/debian-user/1996/10/msg00239.html
[minicom-send-file]: https://unix.stackexchange.com/questions/273178/file-transfer-using-ymodem-sz

[opengl]: https://doc.ubuntu-fr.org/opengl

[snapcraft-repositories]: https://snapcraft.io/
[snapcraft-documentation]: https://snapcraft.io/docs
[theme-gedit-dracula]: https://draculatheme.com/gedit

