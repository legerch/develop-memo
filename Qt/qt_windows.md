This file will provide all informations related to [Qt Framework][qt-home] under **Windows OS**

**Table of contents**
- [1. Miscellaneous behaviour](#1-miscellaneous-behaviour)
  - [1.1. UTF-8 issues](#11-utf-8-issues)
    - [1.1.1. Terminal](#111-terminal)
    - [1.1.2. Compiler warnings](#112-compiler-warnings)
    - [1.1.3. Source files](#113-source-files)
- [2. Deploy](#2-deploy)
  - [2.1. Set metadata ressources](#21-set-metadata-ressources)
  - [2.2. Deploy Application](#22-deploy-application)
  - [2.3. Sign application](#23-sign-application)

# 1. Miscellaneous behaviour
## 1.1. UTF-8 issues

Those UTF-8 issues are not really related to Qt but mainly due to how **MSVC compiler** works (and do not use UTF-8 encoding by default)

> [!NOTE]
> If anyone want to know why UTF-16 is used by default by Windows (instead of UTF-8), here is a [great explanation from a Microsoft Developer][windows-dev-blog-utf8] which give them some credits, being the first to implement something is not always an advantage!

### 1.1.1. Terminal

Weird characters when displaying something on the terminal ?    
To fix that:
1. Go to `Edit` -> `Preferences`
2. In section `Environment` -> `Interface`
3. Set codec section from `System` to `UTF-8`

![Image which demonstrate UTF-8 setting for terminal under Qt Creator][asset-img-qtc-utf8-terminal]

### 1.1.2. Compiler warnings

Weird characters when reading compiler warnings/errors ?  
To fix that:
1. Go to `Edit` -> `Preferences`
2. In section `Kits` -> Used kit
3. Under `Environment` -> enable checkbox `Force UTF-8`

![Image which demonstrate UTF-8 setting for compiler warnings/errors under Qt Creator][asset-img-qtc-utf8-warns]

### 1.1.3. Source files

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

# 2. Deploy
## 2.1. Set metadata ressources
_TODO: Details how to set rc file, see: https://forum.qt.io/topic/122430/setting-up-the-application-information-in-cmake/4_

## 2.2. Deploy Application
Under windows, libraries are needed next to executable, otherwise it cannot be launch.  
To do so, you must launch `cmd.exe` with the Qt environment to used :
```shell
# Cmd line to use (can be used as a shortcut) - This example is for MSVC 2019 - Qt 5.15.2 - 64bits
C:\Windows\System32\cmd.exe /A /Q /K C:\Qt\5.15.2\msvc2019_64\bin\qtenv2.bat
```

Then we can use `windeployqt` to deploy our application :
```shell
cd path/to/dir/of/app/executable/
windeployqt --release myApp.exe myLibUsingQt.dll
```
> We can also used option `--no-translations` if the application doesn't provide translations

Now, the directory must contains our application `myApp.exe` and all needed Qt libraries (`Qt5Core.dll`, `Qt5Widgets.dll`, etc...)

## 2.3. Sign application

_TODO: Add details on how to sign app under Windows_

<!-- Assets link -->

[asset-img-qtc-utf8-terminal]: assets/qt-creator-utf8-terminal.png
[asset-img-qtc-utf8-warns]: assets/qt-creator-utf8-warns.png

<!-- External links -->

[qt-home]: https://www.qt.io/

[windows-dev-blog-utf8]: https://devblogs.microsoft.com/oldnewthing/20190830-00/?p=102823