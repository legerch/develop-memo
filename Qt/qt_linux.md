This file will provide all informations related to [Qt Framework][qt-home] under **Linux OSes**

**Table of contents**
- [1. Deploy](#1-deploy)
  - [1.1. AppImage](#11-appimage)
    - [1.1.1. Create _AppDir_ structure](#111-create-appdir-structure)
      - [1.1.1.1. Preparing your application](#1111-preparing-your-application)
      - [1.1.1.2. Using `linuxdeploy` tool](#1112-using-linuxdeploy-tool)
    - [1.1.2. Generate _AppImage_ application](#112-generate-appimage-application)
      - [1.1.2.1. linuxdeploy-plugin-appimage](#1121-linuxdeploy-plugin-appimage)
      - [1.1.2.2. AppImageKit](#1122-appimagekit)

# 1. Deploy

Under Linux OS, if you have needed libraries installed on the target, you can use the generated release file without problem. This solution can be useful for a developper desktop but for average users, this can't work, we need to bundle all needed libraries.  

## 1.1. AppImage

Tutorial below applies for all linux application bundle into an _AppImage_ file, not only for _Qt_ applications.

### 1.1.1. Create _AppDir_ structure

To create an _AppDir_ structure, we can use the dedicated project [linuxdeploy][linuxdeploy-repo] (don't confuse with the other project [linuxdeployqt][linuxdeployqt-repo]).    

#### 1.1.1.1. Preparing your application

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
> [!NOTE]
> Replace `<theme>` and `<resolution>` with (for example) `hicolor` and `256x256` respectively; see [icon theme spec][linux-specs-icon] for more details.

2. Create the `.desktop` file :
```shell
[Desktop Entry]
Type=Application
Name=Amazing App
Comment=The best Application Ever
Exec=your_app
Icon=your_app
Categories=Office;
```
> [!TIP]
> See [`.desktop specs`][linux-specs-desktop] for more details about available fields.  
> To assure good bundle with other tools like `linuxdeploy`, use the name application for **binary**, **icon** and **desktop** files.

#### 1.1.1.2. Using `linuxdeploy` tool

Official documentation of this tool is available at [_linuxdeploy_ : User guide][linuxdeploy-doc]

1. Download release file from [linuxdeploy/releases][linuxdeploy-releases]
> If you need plugins, download them too, alongside this application [(list of available plugins for _linuxdeploy_)][linuxdeploy-plugins-list]

2. Create _AppDir_ of your application :
```shell
# Generic command
./linuxdeploy-x86_64.AppImage --appdir ~/path/to/my/appdir/

# Use Qt plugin
LD_LIBRARY_PATH=/home/<user>/Qt/5.15.2/gcc_64/lib QMAKE=/home/<user>/Qt/5.15.2/gcc_64/bin/qmake ./linuxdeploy-x86_64.AppImage --appdir ~/path/to/my/appdir/ --plugin qt
```
> [!NOTE]
> Documentation for **Qt plugin** can be found at [linuxdeploy-qt-plugin][linuxdeploy-plugin-qt].

> [!TIP]
> By default, plugin will use `QMake` installed in `/usr/lib/` (when Qt is installed with distribution packages). If you installed Qt with official installer (recommended !), then Qt files will be located at `/home/<user>/Qt`.  
> If plugin `linuxdeploy-plugin-appimage` is installed, you can add `--output appimage` to the command line to generate the **AppImage** after creation of **AppDir**

### 1.1.2. Generate _AppImage_ application

Once your **AppDir** is created and complete, we can create our **AppImage** file, to do so, two solutions :
- [linuxdeploy-plugin-appimage][linuxdeploy-plugin-appimage]
- [AppImageKit application][appimagekit-repo]

When generate binary files, it is recommended to include the arch build on the generated _AppImage_ :
- myApp-v1.0.0-i386.AppImage
- myApp-v1.0.0-x86_64.AppImage
- myApp-v1.0.0-aarch64.AppImage
- myApp-v1.0.0-armhf.AppImage
> Don't forget to add executable right on the file if needed with `chmod +x ./myApp.AppImage`.  

#### 1.1.2.1. linuxdeploy-plugin-appimage

1. Download plugin file from [linuxdeploy-plugin-appimage/releases][linuxdeploy-plugin-appimage-releases] and put it next to `linuxdeploy` main app
2. When building **AppDir**, add command `--output appimage`

#### 1.1.2.2. AppImageKit

1. Download release file from [AppImageKit/releases][appimagekit-releases]
2. Create your `AppImage` file :
```shell
./appimagetool-x86_64.AppImage ~/path/to/my/appdir/ myApp.AppImage
```
3. Run your application
```shell
./myApp.AppImage
```

<!-- External links -->

[appimagekit-repo]: https://github.com/AppImage/AppImageKit
[appimagekit-releases]: https://github.com/AppImage/AppImageKit/releases

[linuxdeploy-repo]: https://github.com/linuxdeploy/linuxdeploy
[linuxdeploy-doc]: https://docs.appimage.org/packaging-guide/from-source/linuxdeploy-user-guide.html
[linuxdeploy-releases]: https://github.com/linuxdeploy/linuxdeploy/releases
[linuxdeploy-plugins-list]: https://github.com/linuxdeploy/awesome-linuxdeploy
[linuxdeploy-plugin-qt]: https://github.com/linuxdeploy/linuxdeploy-plugin-qt
[linuxdeploy-plugin-appimage]: https://github.com/linuxdeploy/linuxdeploy-plugin-appimage
[linuxdeploy-plugin-appimage-releases]: https://github.com/linuxdeploy/linuxdeploy-plugin-appimage/releases

[linuxdeployqt-repo]: https://github.com/probonopd/linuxdeployqt

[linux-specs-desktop]: https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
[linux-specs-icon]: https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html

[qt-home]: https://www.qt.io/
