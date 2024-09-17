**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. PPA - Personal Package Archives](#2-ppa---personal-package-archives)
  - [2.1. Description](#21-description)
  - [2.2. Usage](#22-usage)
    - [2.2.1. Terminal](#221-terminal)
    - [2.2.2. Graphical interface](#222-graphical-interface)
  - [2.3. Softwares](#23-softwares)
- [3. Standalone packages](#3-standalone-packages)
- [4. `tracker` process](#4-tracker-process)
- [5. Graphics cards support](#5-graphics-cards-support)
  - [5.1. Nvidia](#51-nvidia)
- [6. Switch GCC version to use](#6-switch-gcc-version-to-use)
- [7. System freeze](#7-system-freeze)
- [8. Ressources](#8-ressources)

# 1. Introduction

In this files, all advices for an Ubuntu OS

# 2. PPA - Personal Package Archives

## 2.1. Description

[What is a _PPA_ ?][doc-ppa-ubuntu]

## 2.2. Usage
### 2.2.1. Terminal

- Add **PPA** repository :
```shell
# Add package
sudo add-apt-repository ppa:<repository_name>
# Reload package list
sudo apt update
```

- Remove **PPA** repository
  - Without uninstall already installed packages
```shell
sudo add-apt-repository --remove ppa:<repository_name>
```
  - Uninstall all packages installed with this repository
```shell
sudo ppa-purge ppa:<repository_name>
```

- List all added **PPA** repository :
```shell
ls -l /etc/apt/sources.list.d/
```

### 2.2.2. Graphical interface

A graphical interface solution is available for easily manage **PPA** repository : [`Y PPA Manager`][doc-ppa-manager-official]
> - [Fostips - Y-PPA-Manager : Graphical tool manage Ubuntu PPAs][doc-ppa-manager-fostips]
> - [Itsfoss - Y-PPA-Manager][doc-ppa-manager-itsfoss]
> - [Addictive Tips - Update Ubuntu PPA to 20.04 release][doc-ppa-manager-addictivetips]

## 2.3. Softwares

List of softwares using PPA repository :
- [Gimp][ppa-gimp]
- [lazygit][ppa-lazygit]
- [node][ppa-node]
- [copyq][ppa-copyq]
- [mainline][ppa-kernel-mainline]
- [teamviewer][ppa-teamviewer]
- [thunderbird][ppa-thunderbird]
- [vscode][ppa-vscode]

# 3. Standalone packages

Some package can be installed without using package manager (apt, snapd, etc...). This become a problem when we need to uninstall the package.  
> Section under construction, check this tutorial : [Install/Uninstall packages in Ubuntu from tar.gz][tutorial-package-tar-gz]

# 4. `tracker` process

`tracker` was introduced in _Ubuntu 19.10_ (it's a **Gnome** dependency). It indexes your files to allow for fast searching for content in files from Files or Gnome Documents, find pictures in Gnome Photos, allow to rename files based on metadata, and so on.

Many users have complain about tracker taking a lot of CPU ressources. If you don't need global research, you can disable tracker (research in a directory will still be available and even faster...)

To disable tracker for current user :
```shell
systemctl --user mask tracker-store.service tracker-miner-fs.service tracker-miner-rss.service tracker-extract.service tracker-miner-apps.service tracker-writeback.service
tracker reset --hard
sudo reboot
```

To undo, reenable the services :
```shell
systemctl --user unmask tracker-store.service tracker-miner-fs.service tracker-miner-rss.service tracker-extract.service tracker-miner-apps.service tracker-writeback.service
sudo reboot
```
> More details on this procedure in the concerned thread from Ubuntu forum : [Tracker process taking lot of CPU][thread-tracker-process-cpu].  
> **Don't forget** to re-enable services before performing major upgrades of Ubuntu OS to prevent from unexpected behaviour.

# 5. Graphics cards support
## 5.1. Nvidia

_Under construction_ 
> Use this tutorial : [Ubuntu - Install NVidia driver latest proprietary driver][tutorial-nvidia-driver]

# 6. Switch GCC version to use

_Under construction_
> In the meantime, please refer to:
> - https://linuxconfig.org/how-to-switch-between-multiple-gcc-and-g-compiler-versions-on-ubuntu-20-04-lts-focal-fossa
> - https://askubuntu.com/questions/26498/how-to-choose-the-default-gcc-and-g-version  
> Note that if you need a custom compiler for a Qt toolkit for example, installing GCC (`gcc` and `g++`) version associated package will be enough !

# 7. System freeze

_under construction_
> - [How to properly shutdown Ubuntu even if all is freezed][doc-os-freeze-ubuntu]
> - [magic keys (impr'ecran)][doc-os-freeze-ubuntu-magic-keys]
> - [doc-os-freeze-thread]
> - [doc-os-freeze-configuration] (by default only SUB part of REISUB cmd is enable, so you need to configure it before this command is needed...)  
> **Note :** don't forget to print those pages...  

# 8. Ressources

- Official documentation :
  - [FR Ubuntu - PPA][doc-ppa-ubuntu]
- Tutorials
  - _Y PPA Manager_
    - [Repository **Y PPA Manager**][doc-ppa-manager-official]
    - [doc-ppa-manager-fostips]
    - [doc-ppa-manager-itsfoss]
    - [doc-ppa-manager-addictivetips]
  - Packages
    - [Install/Uninstall packages in Ubuntu from tar.gz][tutorial-package-tar-gz]
    - [How to use checkinstall][doc-checkinstall-ubuntu]
- Threads
  - [Tracker process taking lot of CPU][thread-tracker-process-cpu]

<!-- External links -->
[doc-ppa-ubuntu]: https://doc.ubuntu-fr.org/ppa
[doc-ppa-manager-official]: https://launchpad.net/~webupd8team/+archive/ubuntu/y-ppa-manager
[doc-ppa-manager-fostips]: https://fostips.com/y-ppa-manager-graphical-tool-manage-ubuntu-ppas/
[doc-ppa-manager-itsfoss]: https://itsfoss.com/y-ppa-manager/
[doc-ppa-manager-addictivetips]: https://www.addictivetips.com/ubuntu-linux-tips/update-ubuntu-ppa-to-20-04-release/

[doc-os-freeze-ubuntu]: https://doc.ubuntu-fr.org/tutoriel/lorsque_le_systeme_gele
[doc-os-freeze-ubuntu-magic-keys]: https://doc.ubuntu-fr.org/touches_magiques
[doc-os-freeze-configuration]: https://linuxconfig.org/how-to-enable-all-sysrq-functions-on-linux
[doc-os-freeze-thread]: https://askubuntu.com/questions/4408/what-should-i-do-when-ubuntu-freezes

[doc-checkinstall-ubuntu]: https://doc.ubuntu-fr.org/checkinstall

[ppa-gimp]: https://doc.ubuntu-fr.org/gimp
[ppa-lazygit]: https://github.com/jesseduffield/lazygit
[ppa-node]: https://doc.ubuntu-fr.org/nodejs
[ppa-copyq]: https://copyq.readthedocs.io/en/latest/installation.html
[ppa-kernel-mainline]: https://github.com/bkw777/mainline
[ppa-teamviewer]: https://community.teamviewer.com/English/kb/articles/30666-how-to-update-teamviewer-on-linux-via-repository
[ppa-thunderbird]: https://doc.ubuntu-fr.org/thunderbird
[ppa-vscode]: https://code.visualstudio.com/docs/setup/linux

[tutorial-package-tar-gz]: https://ajinkya007.in/linux/install-packages-in-ubuntu-from-tar-gz/
[tutorial-nvidia-driver]: https://www.cyberciti.biz/faq/ubuntu-linux-install-nvidia-driver-latest-proprietary-driver/

[thread-tracker-process-cpu]: https://askubuntu.com/questions/1187191/tracker-process-taking-lot-of-cpu