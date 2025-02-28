In this folder, you will find all Qt relatives informations

**Table of contents :**
- [1. Installation](#1-installation)
- [2. Qt Creator](#2-qt-creator)
  - [2.1. Themes](#21-themes)
  - [2.2. Kit](#22-kit)
  - [2.3. Compiler](#23-compiler)
  - [2.4. Analyzers](#24-analyzers)
- [3. Miscellaneous behaviour](#3-miscellaneous-behaviour)
  - [3.1. Qt creator based on Qt kits \> 6.7.0](#31-qt-creator-based-on-qt-kits--670)
  - [3.2. Install older versions of Qt Creator](#32-install-older-versions-of-qt-creator)
- [4. OS specific](#4-os-specific)
- [5. Installer](#5-installer)

# 1. Installation

Qt official installer is available at [Qt - Installer][qt-installer]
> Qt can be obtained through tree licences : **GPL**, **LGPL** and **Commercial**. Please review all available modules and conditions of each at [Qt - Licenses][qt-licenses] 

# 2. Qt Creator
## 2.1. Themes

Available themes :
- [QDarksky][theme-qdarsky-official] (a [fork][theme-qdarsky-fork] is maintained to be compatible with QtCreator 5 and later)

## 2.2. Kit

_in construction_

## 2.3. Compiler

To use a custom compiler, you have to set compiler used in toolkit preferences. Custom compilers is set only for a specific Qt kit.
> See [Qt Creator - Add compiler][qt-creator-doc-add-compiler]

## 2.4. Analyzers

QtCreator allow to perform multiple analyze:

| Analyze type | Tool | Linux | Windows | Mac |
|:-:|:-:|:-:|:-:|:-:|
| Memory | [**Valgrind**][qt-creator-doc-analyze-valgrind] | :white_check_mark: | :dizzy: | :dizzy: |
| Performance (CPU) | [**perf**][qt-creator-doc-analyze-perf] | :white_check_mark: | :x: | :x: |

> Support:
> - :white_check_mark: Complete support
> - :dizzy: Partial support
> - :x: No support

# 3. Miscellaneous behaviour
## 3.1. Qt creator based on Qt kits > 6.7.0

For _Qt Creator_ versions built with Qt kits superior to `6.7.0`, **Qt Designer** lost ability to properly generate `.ui` files for Qt `5.15.x` projects.  
Below, we can find list of things to manually manage in order to keep compatibility:
- **Spacer** elements: replace `Qt::Orientation` with `Qt::`

> [!NOTE]
> We can find related issues at:
> - https://forum.qt.io/topic/157569
> - https://forum.qt.io/topic/158064
> 
> And the registered tickets issues at:
> - https://bugreports.qt.io/browse/QTBUG-126966 
> - https://bugreports.qt.io/browse/QTBUG-127179

## 3.2. Install older versions of Qt Creator

Qt keep archives of older Qt Creator versions which can be find at:
- [Latest 3 releases][qt-creator-archives-recent]
- [Old releases][qt-creator-archives-old]

> [!TIP]
> In order to not break current installation, it will be better to use the one inside `qtcreator/MAJOR.0/MAJOR.Minor.patch/installer_source/` which contains standalone version.

# 4. OS specific

Under this section, all documentation related to each OSes for their **deployment, specific behaviours, etc...** will be available:
- [Linux][doc-qt-linux]
- [MacOS][doc-qt-macos]
- [Windows][doc-qt-windows]

# 5. Installer

We can create an installer with [Qt Installer Framework][qt-installer-fw]

<!-- Assets link -->

[doc-qt-linux]: qt_linux.md
[doc-qt-macos]: qt_mac.md
[doc-qt-windows]: qt_windows.md

<!-- External link -->
[qt-installer]: https://www.qt.io/download-qt-installer
[qt-installer-fw]: https://doc.qt.io/qtinstallerframework/
[qt-licenses]: https://www.qt.io/product/features

[qt-creator-doc-add-compiler]: https://doc.qt.io/qtcreator/creator-tool-chains.html
[qt-creator-doc-analyze-valgrind]: https://doc.qt.io/qtcreator/creator-valgrind-overview.html
[qt-creator-doc-analyze-perf]: https://doc.qt.io/qtcreator/creator-cpu-usage-analyzer.html

[qt-creator-archives-recent]: https://download.qt.io/official_releases/qtcreator/
[qt-creator-archives-old]: https://download.qt.io/archive/qtcreator/

[theme-qdarsky-official]: https://github.com/foxoman/qDarkSky
[theme-qdarsky-pr-qtc5]: https://github.com/foxoman/qDarkSky/pull/2
[theme-qdarsky-fork]: https://github.com/legerch/qDarkSky