This file list all needed packages for **Ubuntu OS** according to each usage.

**Table of contents :**
- [1. Mandatory commands](#1-mandatory-commands)
- [2. Developer tools](#2-developer-tools)
  - [2.1. Standard](#21-standard)
  - [2.2. Serial communication](#22-serial-communication)
    - [2.2.1. Installation](#221-installation)
    - [2.2.2. Usage](#222-usage)
    - [2.2.3. Configuration](#223-configuration)
      - [2.2.3.1. Fail to write](#2231-fail-to-write)
      - [2.2.3.2. Enable colors output](#2232-enable-colors-output)
  - [2.3. Logs](#23-logs)
  - [2.4. File comparaison viewer](#24-file-comparaison-viewer)
  - [2.5. Documentation](#25-documentation)
  - [2.6. CTRL-C memory](#26-ctrl-c-memory)
- [3. Buildroot/kernels requirements](#3-buildrootkernels-requirements)
  - [3.1. Mandatory packages](#31-mandatory-packages)
  - [3.2. Optional packages](#32-optional-packages)
- [4. Edition tools](#4-edition-tools)
  - [4.1. Qt](#41-qt)
  - [4.2. Visual Studio Code](#42-visual-studio-code)
  - [4.3. Gedit](#43-gedit)
  - [4.4. Vi](#44-vi)
- [5. Git UI](#5-git-ui)
- [6. System management](#6-system-management)
- [7. Networking tools](#7-networking-tools)
- [8. Emails](#8-emails)
- [9. Multimedia tools](#9-multimedia-tools)
- [10. GNOME Customization](#10-gnome-customization)
  - [10.1. GNOME Plugins](#101-gnome-plugins)
  - [10.2. GNOME Editor](#102-gnome-editor)

# 1. Mandatory commands

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

# 2. Developer tools
## 2.1. Standard

```shell
sudo apt install build-essential git tree
```

## 2.2. Serial communication
### 2.2.1. Installation
```shell
sudo apt install minicom
```

### 2.2.2. Usage
```shell
sudo minicom -D /dev/ttyUSB0 -b 115200 -c on
```

### 2.2.3. Configuration

#### 2.2.3.1. Fail to write

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

#### 2.2.3.2. Enable colors output

To enable color output with _minicom_, you need to use option : `minicom -c on`
> Ressources used :
> - [debian.org : color for minicom ?][minicom-color-option-thread-debianorg]

## 2.3. Logs

```shell
sudo apt install glogg
```

## 2.4. File comparaison viewer

```shell
sudo apt install meld
```

## 2.5. Documentation

```shell
sudo apt install doxygen doxygen-gui doxygen-doc
```

## 2.6. CTRL-C memory

See [CopyQ][copyq-official] official doumentation for more details.

# 3. Buildroot/kernels requirements

In order to use [Buildroot][br-getting-started] framework to build _custom Linux OS_ and to compile [Linux kernel][kernel-index], some packages are needed.  
List of packages are based on manuals available at :
- [Buildroot - requirements][br-requirements]
- [Kernel - requirements][kernel-requirements]

## 3.1. Mandatory packages

[Standard developer tools][anchor-dev-tools-std] are needed, then install :
```shell
sudo apt install patch gzip bzip2 perl cpio unzip rsync python3 python-is-python3 # Buildroot
sudo apt install jfsutils flex bison util-linux reiserfsprogs xfsprogs btrfs-progs quota libssl-dev fakeroot #kernel
```

## 3.2. Optional packages

- Buildroot GUI with _ncurses5_ : `sudo apt install libncurses-dev`
- Buildroot GUI with _qt_ : `sudo apt install qtbase5-dev`
- Buildroot GUI with _gtk_ : `sudo apt install libglade2-dev libglib2.0-dev libgtk2.0-dev`

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

- [GitKraken][gitkraken-doc-install]

# 6. System management

```shell
sudo apt install htop lm-sensors udisks2
sudo apt install y-ppa-manager # a PPA exist for this package
```

# 7. Networking tools

```shell
sudo apt install net-tools libpcap-dev libnet1-dev rpcbind openssh-server nmap
sudo apt install wireshark
sudo apt install filezilla
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

# 9. Multimedia tools

```shell
sudo apt install vlc gimp mediainfo-gui
sudo apt install ffmpeg
sudo apt install gthumb
sudo apt install libreoffice # a PPA also exist for libreoffice
``` 

# 10. GNOME Customization
## 10.1. GNOME Plugins
```shell
sudo apt install gnome-tweaks chrome-gnome-shell
sudo apt install gnome-shell-extension-freon # See https://github.com/UshakovVasilii/gnome-shell-extension-freon
```

## 10.2. GNOME Editor

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

<!-- Anchor of this page -->
[anchor-dev-tools-std]: #21-standard

<!-- Links of this repository -->
[doc-qt]: https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Qt
[doc-vscode]: https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/IDE/VsCode

<!-- External links -->
[br-getting-started]: https://buildroot.org/downloads/manual/manual.html#_getting_started
[br-requirements]: https://buildroot.org/downloads/manual/manual.html#requirement

[kernel-index]: https://www.kernel.org/doc/html/v5.15/index.html
[kernel-requirements]: https://www.kernel.org/doc/html/v5.15/process/changes.html#minimal-requirements-to-compile-the-kernel

[theme-gedit-dracula]: https://draculatheme.com/gedit

[copyq-official]: https://hluk.github.io/CopyQ/
[gitkraken-doc-install]: https://support.gitkraken.com/how-to-install/

[minicom-write-failure-thread-askubuntu]: https://askubuntu.com/questions/638378/minicom-doesnt-work
[minicom-write-failure-tutorial]: https://www.centennialsoftwaresolutions.com/post/configure-minicom-for-a-usb-to-serial-converter
[minicom-color-option-thread-debianorg]: https://lists.debian.org/debian-user/1996/10/msg00239.html

[dconf-editor]: https://doc.ubuntu-fr.org/dconf-editor
