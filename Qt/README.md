In this folder, you will find all Qt relatives informations

**Table of contents :**
- [1. Installation](#1-installation)
- [2. Qt Creator](#2-qt-creator)
  - [2.1. Themes](#21-themes)
  - [2.2. Kit](#22-kit)
  - [2.3. Compiler](#23-compiler)
  - [2.4. Analyzers](#24-analyzers)
- [3. Miscellaneous behaviour](#3-miscellaneous-behaviour)
  - [3.1. UTF-8 issues under Windows OS](#31-utf-8-issues-under-windows-os)
    - [3.1.1. Terminal](#311-terminal)
    - [3.1.2. Compiler warnings](#312-compiler-warnings)
    - [3.1.3. Source files](#313-source-files)
  - [3.2. Qt creator based on Qt kits \> 6.7.0](#32-qt-creator-based-on-qt-kits--670)
  - [3.3. Install older versions of Qt Creator](#33-install-older-versions-of-qt-creator)
- [4. Deploy](#4-deploy)
  - [4.1. Windows OS](#41-windows-os)
  - [4.2. Linux OS](#42-linux-os)
    - [4.2.1. Create _AppDir_ structure](#421-create-appdir-structure)
      - [4.2.1.1. Preparing your application](#4211-preparing-your-application)
      - [4.2.1.2. Using `linuxdeploy` tool](#4212-using-linuxdeploy-tool)
    - [4.2.2. Generate _AppImage_ application](#422-generate-appimage-application)
      - [4.2.2.1. linuxdeploy-plugin-appimage](#4221-linuxdeploy-plugin-appimage)
      - [4.2.2.2. AppImageKit](#4222-appimagekit)
- [5. Ressources](#5-ressources)

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
## 3.1. UTF-8 issues under Windows OS

Those UTF-8 issues are not really related to Qt but mainly due to how **MSVC compiler** works (and do not use UTF-8 encoding by default)

> [!NOTE]
> If anyone want to know why UTF-16 is used by default by Windows (instead of UTF-8), here is a [great explanation from a Microsoft Developer][windows-dev-blog-utf8] which give them some credits, being the first to implement something is not always an advantage!

### 3.1.1. Terminal

Weird characters when displaying something on the terminal ?    
To fix that:
1. Go to `Edit` -> `Preferences`
2. In section `Environment` -> `Interface`
3. Set codec section from `System` to `UTF-8`

![Image which demonstrate UTF-8 setting for terminal under Qt Creator][asset-img-qtc-utf8-terminal]

### 3.1.2. Compiler warnings

Weird characters when reading compiler warnings/errors ?  
To fix that:
1. Go to `Edit` -> `Preferences`
2. In section `Kits` -> Used kit
3. Under `Environment` -> enable checkbox `Force UTF-8`

![Image which demonstrate UTF-8 setting for compiler warnings/errors under Qt Creator][asset-img-qtc-utf8-warns]

### 3.1.3. Source files

Issues when managing litteral UTF-8 string directly in source code, even if your source file is encoded using UTF-8 ?  
By default, MSVC consider that source code is encoded in the system codec (often "UTF-16") even if source files are indeed encoded in UTF-8.
This is because MSVC can't detect UTF-8 encoding without the BOM informations (UTF-8 BOM), so using `/utf-8` MSVC specific option will allow us to force to consider source file as UTF-8 files.  
We can use this option like this:
```cmake
# Manage global compiler options
## For MSVC: force to read source code as UTF-8 file (already default behaviour on GCC and Clang)
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
```
> [!TIP]
> This is better to add this option before calling `add_library()` or `add_executable()`

## 3.2. Qt creator based on Qt kits > 6.7.0

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

## 3.3. Install older versions of Qt Creator

Qt keep archives of older Qt Creator versions which can be find at:
- [Latest 3 releases][qt-creator-archives-recent]
- [Old releases][qt-creator-archives-old]

> [!TIP]
> In order to not break current installation, it will be better to use the one inside `qtcreator/MAJOR.0/MAJOR.Minor.patch/installer_source/` which contains standalone version.

# 4. Deploy

## 4.1. Windows OS

Under windows, libraries are needed next to executable, otherwise it cannot be launch.  
To do so, you must launch `cmd.exe` with the Qt environment to used :
```shell
# Cmd line to use (can be used as a shortcut) - This example is for MSVC 2019 - Qt 5.15.2 - 64bits
C:\Windows\System32\cmd.exe /A /Q /K C:\Qt\5.15.2\msvc2019_64\bin\qtenv2.bat
```

Then we can use `windeployqt` to deploy our application :
```shell
cd path/to/dir/of/app/executable/
windeployqt --release myApp.exe
```
> We can also used option `--no-translations` if the application doesn't provide translations

Now, the directory must contains our application `myApp.exe` and all needed Qt libraries (`Qt5Core.dll`, `Qt5Widgets.dll`, etc...)

## 4.2. Linux OS

Under Linux OS, if you have needed libraries installed on the target, you can use the generated release file without problem. This solution can be useful for a developper desktop but for average users, this can't work, we need to bundle all needed libraries.  
Tutorial below applies for all linux application bundle into an _AppImage_ file, not only for _Qt_ applications.

### 4.2.1. Create _AppDir_ structure

To create an _AppDir_ structure, we can use the dedicated project [linuxdeploy] (don't confuse with the other project [linuxdeployqt].    
To create _AppDir_ structure of your application :

#### 4.2.1.1. Preparing your application

1. Create basic structure of an **AppDir** which should look something like this :
```shell
└── usr
    ├── bin
    │   └── your_app
    ├── lib
    └── share
        ├── applications
        │   └── your_app.desktop
        └── icons
            └── <theme>
                └── <resolution> 
                    └── apps 
                        └── your_app.png
```
> Replace `<theme>` and `<resolution>` with (for example) `hicolor` and `256x256` respectively; see [icon theme spec][linux-specs-icon] for more details.

1. Create the `.desktop` file :
```shell
[Desktop Entry]
Type=Application
Name=Amazing App
Comment=The best Application Ever
Exec=your_app
Icon=your_app
Categories=Office;
```
> See [`.desktop specs`][linux-specs-desktop] for more details about available fields.  
> To assure good bundle with other tools like `linuxdeploy`, use the name application for **binary**, **icon** and **desktop** files.

#### 4.2.1.2. Using `linuxdeploy` tool

Official documentation of this tool is available at [_linuxdeploy_ : User guide][linuxdeploy-doc]

1. Download release file from [linuxdeploy/releases][linuxdeploy-releases]
> If you need plugins, download them too, alongside this application [(list of available plugins for _linuxdeploy_)][linuxdeploy-plugins-list]

1. Create _AppDir_ of your application :
```shell
# Generic command
./linuxdeploy-x86_64.AppImage --appdir ~/path/to/my/appdir/

# Use Qt plugin
LD_LIBRARY_PATH=/home/<user>/Qt/5.15.2/gcc_64/lib QMAKE=/home/<user>/Qt/5.15.2/gcc_64/bin/qmake ./linuxdeploy-x86_64.AppImage --appdir ~/path/to/my/appdir/ --plugin qt
```
> Documentation for **Qt plugin** can be found at [linuxdeploy-qt-plugin][linuxdeploy-plugin-qt].   
> By default, plugin will use `QMake` installed in `/usr/lib/` (when Qt is installed with distribution packages). If you installed Qt with official installer (recommended !), then Qt files will be located at `/home/<user>/Qt`.  
> If plugin `linuxdeploy-plugin-appimage` is installed, you can add `--output appimage` to the command line to generate the **AppImage** after creation of **AppDir**

### 4.2.2. Generate _AppImage_ application

Once your **AppDir** is created and complete, we can create our **AppImage** file, to do so, two solutions :
- [linuxdeploy-plugin-appimage][linuxdeploy-plugin-appimage]
- [AppImageKit application][appimagekit-repo]

When generate binary files, it is recommended to include the arch build on the generated _AppImage_ :
- myApp-v1.0.0-i386.AppImage
- myApp-v1.0.0-x86_64.AppImage
- myApp-v1.0.0-aarch64.AppImage
- myApp-v1.0.0-armhf.AppImage
> Don't forget to add executable right on the file if needed with `chmod +x ./myApp.AppImage`.  

#### 4.2.2.1. linuxdeploy-plugin-appimage

1. Download plugin file from [linuxdeploy-plugin-appimage/releases][linuxdeploy-plugin-appimage-releases] and put it next to `linuxdeploy` main app
2. When building **AppDir**, add command `--output appimage`

#### 4.2.2.2. AppImageKit

1. Download release file from [AppImageKit/releases][appimagekit-releases]
2. Create your `AppImage` file :
```shell
./appimagetool-x86_64.AppImage ~/path/to/my/appdir/ myApp.AppImage
```
3. Run your application
```shell
./myApp.AppImage
```

# 5. Ressources

- Software :
  - [linuxdeploy]
  - [List of plugins for _linuxdeploy_)][linuxdeploy-plugins-list]
  - [AppImageKit][appimagekit-repo]
- Specifications
  - [Icon theme specs][linux-specs-icon]
  - [Desktop file specs][linux-specs-desktop]

<!-- Assets link -->
[asset-img-qtc-utf8-terminal]: assets/qt-creator-utf8-terminal.png
[asset-img-qtc-utf8-warns]: assets/qt-creator-utf8-warns.png

<!-- External link -->
[qt-installer]: https://www.qt.io/download-qt-installer
[qt-licenses]: https://www.qt.io/product/features

[qt-creator-doc-add-compiler]: https://doc.qt.io/qtcreator/creator-tool-chains.html
[qt-creator-doc-analyze-valgrind]: https://doc.qt.io/qtcreator/creator-valgrind-overview.html
[qt-creator-doc-analyze-perf]: https://doc.qt.io/qtcreator/creator-cpu-usage-analyzer.html

[qt-creator-archives-recent]: https://download.qt.io/official_releases/qtcreator/
[qt-creator-archives-old]: https://download.qt.io/archive/qtcreator/

[theme-qdarsky-official]: https://github.com/foxoman/qDarkSky
[theme-qdarsky-pr-qtc5]: https://github.com/foxoman/qDarkSky/pull/2
[theme-qdarsky-fork]: https://github.com/legerch/qDarkSky

[linuxdeploy-repo]: https://github.com/linuxdeploy/linuxdeploy
[linuxdeploy-doc]: https://docs.appimage.org/packaging-guide/from-source/linuxdeploy-user-guide.html
[linuxdeploy-releases]: https://github.com/linuxdeploy/linuxdeploy/releases
[linuxdeploy-plugins-list]: https://github.com/linuxdeploy/awesome-linuxdeploy
[linuxdeploy-plugin-qt]: https://github.com/linuxdeploy/linuxdeploy-plugin-qt
[linuxdeploy-plugin-appimage]: https://github.com/linuxdeploy/linuxdeploy-plugin-appimage
[linuxdeploy-plugin-appimage-releases]: https://github.com/linuxdeploy/linuxdeploy-plugin-appimage/releases

[linuxdeployqt-repo]: https://github.com/probonopd/linuxdeployqt

[appimagekit-repo]: https://github.com/AppImage/AppImageKit
[appimagekit-releases]: https://github.com/AppImage/AppImageKit/releases

[linux-specs-desktop]: https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
[linux-specs-icon]: https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html

[windows-dev-blog-utf8]: https://devblogs.microsoft.com/oldnewthing/20190830-00/?p=102823