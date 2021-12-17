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
- [6. System freeze](#6-system-freeze)
- [7. Ressources](#7-ressources)

# 1. Introduction

In this files, all advices for an Ubuntu OS

# 2. PPA - Personal Package Archives

## 2.1. Description

https://doc.ubuntu-fr.org/ppa

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

A graphical interface solution is available for easily manage **PPA** repository : `Y PPA Manager`
> - https://fostips.com/y-ppa-manager-graphical-tool-manage-ubuntu-ppas/
> - https://itsfoss.com/y-ppa-manager/
> - https://www.addictivetips.com/ubuntu-linux-tips/update-ubuntu-ppa-to-20-04-release/
> - https://launchpad.net/~webupd8team/+archive/ubuntu/y-ppa-manager

## 2.3. Softwares

List of softwares using PPA repository :
- [Gimp](https://doc.ubuntu-fr.org/gimp)
- [lazygit](https://github.com/jesseduffield/lazygit)
- [node](https://doc.ubuntu-fr.org/nodejs)
- [copyq](https://copyq.readthedocs.io/en/latest/installation.html)
- [mainline](https://github.com/bkw777/mainline)
- [teamviewer](https://community.teamviewer.com/English/kb/articles/30666-how-to-update-teamviewer-on-linux-via-repository)
- [thunderbird](https://doc.ubuntu-fr.org/thunderbird)
- [vscode](https://code.visualstudio.com/docs/setup/linux)

# 3. Standalone packages

Some package can be installed without using package manager (apt, snapd, etc...). This become a problem when we need to uninstall the package.  
> Section under construction, check this tutorial : [Install/Uninstall packages in Ubuntu from tar.gz](https://ajinkya007.in/linux/install-packages-in-ubuntu-from-tar-gz/)

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
> More details on this procedure in the concerned thread from Ubuntu forum : [Tracker process taking lot of CPU](https://askubuntu.com/questions/1187191/tracker-process-taking-lot-of-cpu).  
> **Don't forget** to re-enable services before performing major upgrades of Ubuntu OS to prevent from unexpected behaviour.

# 5. Graphics cards support
## 5.1. Nvidia

_Under construction_ 
> Use this tutorial : https://www.cyberciti.biz/faq/ubuntu-linux-install-nvidia-driver-latest-proprietary-driver/

# 6. System freeze

_under construction_
> How to properly shutdown Ubuntu even if all is freezed : https://doc.ubuntu-fr.org/tutoriel/lorsque_le_systeme_gele
> https://askubuntu.com/questions/4408/what-should-i-do-when-ubuntu-freezes (intresting memory helper !)
> https://linuxconfig.org/how-to-enable-all-sysrq-functions-on-linux (by default only SUB part of REISUB cmd is enable, so you need to configure it before this command is needed...)
> Note : don't forget to print those pages...  
> magic keys (impr'ecran) : https://doc.ubuntu-fr.org/touches_magiques

# 7. Ressources

- Official documentation :
  - [FR Ubuntu - PPA](https://doc.ubuntu-fr.org/ppa)
- Tutorials
  - _Y PPA Manager_
    - [Repository **Y PPA Manager**](https://launchpad.net/~webupd8team/+archive/ubuntu/y-ppa-manager)
    - https://fostips.com/y-ppa-manager-graphical-tool-manage-ubuntu-ppas/
    - https://itsfoss.com/y-ppa-manager/
    - https://www.addictivetips.com/ubuntu-linux-tips/update-ubuntu-ppa-to-20-04-release/
  - Packages
    - [Install/Uninstall packages in Ubuntu from tar.gz](https://ajinkya007.in/linux/install-packages-in-ubuntu-from-tar-gz/)
    - [How to use checkinstall](https://doc.ubuntu-fr.org/checkinstall)
  - _Gimp_
    - https://ubuntuhandbook.org/index.php/2020/07/ppa-install-gimp-2-10-20-ubuntu-20-04/
- Threads
  - [Tracker process taking lot of CPU](https://askubuntu.com/questions/1187191/tracker-process-taking-lot-of-cpu)
  