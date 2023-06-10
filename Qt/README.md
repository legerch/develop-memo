**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. Installation](#2-installation)
- [3. Customization](#3-customization)
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

# 1. Introduction

In this folder, you will find all Qt relatives informations

# 2. Installation

Qt official installer is available at [Qt - Installer][qt-installer]
> Qt can be obtained through tree licences : **GPL**, **LGPL** and **Commercial**. Please review all available modules and conditions of each at [Qt - Licenses][qt-licenses] 

# 3. Customization

Available themes :
- [QDarksky][theme-qdarsky-official] (a [Pull request][theme-qdarsky-pr-qtc5] is in pending to make this theme compatible with QtCreator 5 and later)

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

<!-- External link -->
[qt-installer]: https://www.qt.io/download-qt-installer
[qt-licenses]: https://www.qt.io/product/features

[theme-qdarsky-official]: https://github.com/foxoman/qDarkSky
[theme-qdarsky-pr-qtc5]: https://github.com/foxoman/qDarkSky/pull/2

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