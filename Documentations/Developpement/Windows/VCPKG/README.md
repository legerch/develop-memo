**Table of contents:**
- [1. Installation](#1-installation)
  - [1.1. Prerequisites](#11-prerequisites)
  - [1.2. How to ?](#12-how-to-)
  - [1.3. Integration](#13-integration)
    - [1.3.1. Qt projects](#131-qt-projects)
- [2. Usage](#2-usage)
  - [2.1. Search libraries](#21-search-libraries)
  - [2.2. Install libraries](#22-install-libraries)
- [3. Update](#3-update)
  - [3.1. Update VCPKG itself](#31-update-vcpkg-itself)
  - [3.2. Update libraries](#32-update-libraries)

[Vcpkg][vcpkg-repo] helps you manage C and C++ libraries on Windows, Linux and MacOS, official documentation can be found at [vcpkg.io][vcpkg-official].  
This README file is based on repository README itself but with some additionals tips.

# 1. Installation
## 1.1. Prerequisites

In order to use [Vcpkg][vcpkg-repo], you need:
- Windows 7 or newer
- [Git][git-official] (or any git client than can be used to clone vcpkg repository)
- [Visual Studio][visual-studio-official] with the English language pack

## 1.2. How to ?

1. Clone [Vcpkg repository][vcpkg-repo] in a global path, _vcpkg_ itself recommends to install it in `C:\src\vcpkg` or `C:\dev\vcpkg` to prevent from any path issues
```shell
cd C:\dev
git clone git@github.com:microsoft/vcpkg.git
```

2. Bootstrap _vcpkg_ :
```shell
.\vcpkg\bootstrap-vcpkg.bat
```

3. For easier integration of _vcpkg_ installed libraries, you need to open a terminal with administrator rights and run:
```shell
.\vcpkg\vcpkg integrate install
```

Result of this command should print something like:
```
CMake projects should use: "-DCMAKE_TOOLCHAIN_FILE=C:/dev/vcpkg/scripts/buildsystems/vcpkg.cmake"All MSBuild C++ projects can now #include any installed libraries. Linking will be handled automatically. Installing new libraries will make them instantly available.
```
Copy-paste somewhere the `-DCMAKE_TOOLCHAIN_FILE=` part (in a tmp notepad for example).

## 1.3. Integration
### 1.3.1. Qt projects

To use _vcpkg_ with _Qt project_, you need to configure the **CMake toolchain**.  
To do so:
1. Go to `edition` -> `preferences`
2. In `Kits` entry, select _Qt toolchain_ to set for your project, example with _Qt 5.15.2 MSVC2019 64 bit_:
   1. Search for `CMake coniguration` entry and click on `change`
   2. Add `-DCMAKE_TOOLCHAIN_FILE` option

Note that you may need to close _Qt creator_ and manually clean your project (delete build directory and `CMakelist.txt.user` file in source directory) to properly load vcpkg properties.

# 2. Usage
## 2.1. Search libraries

To search libraries, you can use:
```shell
.\vcpkg\vcpkg search [search term]
```
> You can also visit [vcpkg packages][vcpkg-packages]

## 2.2. Install libraries

To install libraries, use `install` subcommand with triplet architecture options (otherwise, **x86** libraries will be installed since they are triplet default value):
```shell
.\vcpkg\vcpkg install [package name]:x64-windows
.\vcpkg\vcpkg install [package name 1]:x64-windows [package name 2]:x64-windows
```

Available triplet values are:
- `x64-windows`
- `x64-windows-static`
- `x86-windows`
- `x64-uwp`
- `x64-osx`
- `x64-linux`
- `arm64-windows`
- `arm-uwp`
> Those are main triplet, others triplet values can be found with: `.\vcpkg help triplet`

# 3. Update
## 3.1. Update VCPKG itself

_in construction_

## 3.2. Update libraries

_in construction_

<!-- External links -->
[git-official]: https://git-scm.com/downloads
[visual-studio-official]: https://visualstudio.microsoft.com/fr/

[vcpkg-official]: https://vcpkg.io/en/index.html
[vcpkg-repo]: https://github.com/microsoft/vcpkg
[vcpkg-packages]: https://vcpkg.io/en/packages.html

[vcpgk-faq]: https://github.com/microsoft/vcpkg/blob/master/docs/about/faq.md
[vcpgk-update-itself]: https://github.com/microsoft/vcpkg/blob/master/docs/about/faq.md#how-do-i-update-vcpkg
[vcpkg-update-lib]: https://github.com/microsoft/vcpkg/blob/master/docs/about/faq.md#how-do-i-update-libraries