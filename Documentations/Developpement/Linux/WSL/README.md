This file will resumed how to use **WSL** filesystem

**Table of contents :**
- [1. Installation](#1-installation)
- [2. Known issues](#2-known-issues)
  - [2.1. Unable to access to _Windows_ files under _WSL_](#21-unable-to-access-to-windows-files-under-wsl)
  - [2.2. Invalid chars when compiling](#22-invalid-chars-when-compiling)

# 1. Installation
## 1.1. WSL install

Install an Ubuntu WSL by following [this tutorial][wsl-install-doc]. 
To run WSL, simply open a Windows terminal and run WSL. It should get you into the Ubuntu shell.

## 1.2. Sharing data between Windows and WSL

To share data between Windows and WSL, always acces Windows data from WSL, not the other way around. 
Windows files are accessible from WSL in the /mnt directory.

It is possible to create a symbolic link pointing to a Windows folder using :
```
ln -s /mnt/<win-disk>/<path-to-win-folder> ~/<path-to-home-subfolder>
```

## 1.3. Prepare tour WSL system

Setup your Git (GitHub/GitLab) SSH keys and install all the needed Ubuntu dependencies.

For convenience, you can create the folder `C:\Projects\Cobra` to store the projects and link to it from your WSL home directory using :
```
ln -s /mnt/c/Projects ~/Projects
```

You cant then go to `~/Projects/cobra` and clone your projects from there.

# 2. Known issues
## 2.1. Unable to access to _Windows_ files under _WSL_

To be able to access to **Windows** folders and files under **WSL**, you need to edit your _WSL configurations_ under `/etc/wsl.conf` :
```shell
[automount]
options="metadata"
```

## 2.2. Windows PATH spaces breaks compilation

This error happens when `$PATH` contains spaces which are not escaped.  
By default, **WSL** import `$PATH` variable from **Windows** which can contains space sequences and when trying to compile, `$PATH` value will be invalid.  
To disable import of `$PATH` into **WSL**, you need to edit your _WSL configurations_ under `/etc/wsl.conf` :
```shell
[interop]
appendWindowsPath=false # append Windows path to $PATH variable; default is true
```
> This issue was resolved by using stackoverflow thread [How to remove the Win10's PATH from WSL][thread-so-wsl-remove-win-path]

## 2.3. Cloning Git projects from Windows

_TODO: check if problems exist if files are edited from Windows_

Cloning Git projects from Windows seems to cause problems when accessing them from WSL. 
To avoid these problems, clone the projects from inside WSL.

_TODO: check if problems persists when using Windows Git tools on a projects cloned directly inside WSL_

<!-- Links -->
[thread-so-wsl-remove-win-path]: https://stackoverflow.com/questions/51336147/how-to-remove-the-win10s-path-from-wsl
[wsl-install-doc]: https://docs.microsoft.com/fr-fr/windows/wsl/install
