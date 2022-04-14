This file will resumed how to use **WSL** filesystem

**Table of contents :**
- [1. Installation](#1-installation)
- [2. Known issues](#2-known-issues)
  - [2.1. Unable to access to _Windows_ files under _WSL_](#21-unable-to-access-to-windows-files-under-wsl)
  - [2.2. Invalid chars when compiling](#22-invalid-chars-when-compiling)

# 1. Installation

_Tutorial in construction..._

# 2. Known issues
## 2.1. Unable to access to _Windows_ files under _WSL_

To be able to access to **Windows** folders and files under **WSL**, you need to edit your _WSL configurations_ under `/etc/wsl.conf` :
```shell
[automount]
options="metadata"
```

## 2.2. Invalid chars when compiling

This error happens when `$PATH` contains spaces which are not escaped.  
By default, **WSL** import `$PATH` variable from **Windows** which can contains space sequences and when trying to compile, `$PATH` value will be invalid.  
To disable import of `$PATH` into **WSL**, you need to edit your _WSL configurations_ under `/etc/wsl.conf` :
```shell
[interop]
appendWindowsPath=false # append Windows path to $PATH variable; default is true
```
> This issue was resolved by using stackoverflow thread [How to remove the Win10's PATH from WSL][thread-so-wsl-remove-win-path]

<!-- Links -->
[thread-so-wsl-remove-win-path]: https://stackoverflow.com/questions/51336147/how-to-remove-the-win10s-path-from-wsl