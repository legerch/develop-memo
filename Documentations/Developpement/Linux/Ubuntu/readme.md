**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. PPA - Personal Package Archives](#2-ppa---personal-package-archives)
  - [2.1. Description](#21-description)
  - [2.2. Usage](#22-usage)
    - [2.2.1. Terminal](#221-terminal)
    - [2.2.2. Graphical interface](#222-graphical-interface)
  - [2.3. Softwares](#23-softwares)
- [3. Ressources](#3-ressources)

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
- [teamviewer](https://community.teamviewer.com/English/kb/articles/30666-how-to-update-teamviewer-on-linux-via-repository)
- [vscode](https://code.visualstudio.com/docs/setup/linux)
  
# 3. Ressources

- Official documentation :
  - [FR Ubuntu - PPA](https://doc.ubuntu-fr.org/ppa)
- Tutorials
  - _Y PPA Manager_
    - [Repository **Y PPA Manager**](https://launchpad.net/~webupd8team/+archive/ubuntu/y-ppa-manager)
    - https://fostips.com/y-ppa-manager-graphical-tool-manage-ubuntu-ppas/
    - https://itsfoss.com/y-ppa-manager/
    - https://www.addictivetips.com/ubuntu-linux-tips/update-ubuntu-ppa-to-20-04-release/
  - _Gimp_
    - https://ubuntuhandbook.org/index.php/2020/07/ppa-install-gimp-2-10-20-ubuntu-20-04/
  