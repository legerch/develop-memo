**Table of contents :**

Table of contents :
- [1. Hardware properties](#1-hardware-properties)
- [2. Screen](#2-screen)
  - [2.1. Framebuffer](#21-framebuffer)
- [3. Process](#3-process)
  - [3.1. Watch real-time](#31-watch-real-time)
  - [3.2. "Inittab" file](#32-inittab-file)
- [4. Ressources](#4-ressources)
- [5. Checksum](#5-checksum)
- [6. Devices](#6-devices)
- [7. Directories](#7-directories)
- [8. Compilation](#8-compilation)
- [9. Libraries](#9-libraries)
- [10. Modules](#10-modules)
- [11. Symlinks](#11-symlinks)
- [12. Custom terminal commands](#12-custom-terminal-commands)
- [13. Linux versionning](#13-linux-versionning)
- [14. Ressources](#14-ressources)

# 1. Hardware properties 
- List hardwares properties and driver informations
```shell
lshw -h

# Example with network hardware
lshw -C network
```
> See also :
- https://www.binarytides.com/linux-lshw-command/
- https://www.geeksforgeeks.org/lshw-command-in-linux-with-examples/

# 2. Screen
## 2.1. Framebuffer

- Display **RAW** image:
```shell
dd if=/path/my_image.fb of=/dev/fb0 bs=32768 count=1 > /dev/null 2>&1
```

- Display `.png` image :
```shell
fbv -0 /path/my_image.png
```

- Convert `.png` image to **RAW** file:
```shell
fbv -0 /path/exemple.png  > /dev/null 2>&1
dd if=/dev/fb0 of=example.fb
```

# 3. Process
## 3.1. Watch real-time

- Watch processus :
```shell
watch -n 0.1 cat /pro/interrupts
```

- Watch PID of an application (here we search application _app_ and _memcheck_)
```shell
watch -d "ps -a | grep 'app\|memcheck'"
```

## 3.2. "Inittab" file

- Reload `inittab` file :
1. Via `init`
```shell
init q
```

2. Via `telinit` :
```shell
telinit q
```

3. By sending signal **SIGHUP** to the init process (PID 1) :
```shell
kill -1 1
kill -SIGHUP 1
```

# 4. Ressources

- Watch ressources used :
```shell
top
htop
```

- Get memory informations :
```shell
cat /proc/meminfo   # All memory informations
watch -n 1 "cat /proc/meminfo | grep 'MemAvailable:'"
```

- Get status of `sync` command :
```shell
watch -d grep -e Dirty: -e Writeback: /proc/meminfo
```

# 5. Checksum

- Get MD5 of a file :
```shell
md5sum file.txt
```

- Checksum of multiple files :
```shell
# Get all checksum in a file
md5sum * > check.chk
# Verify checksum
md5sum -c checklist.chk

# Get all checksum with sub-directories in a file with filters
find -type f -not -name "*.data*" -not -name "*.bin*" -not -name "*.ppm*" -exec md5sum "{}" + > checklist.chk
# Get all checksum with sub-directories in a file with filters and alphabetically sorted
find -type f -not -name "*.data*" -not -name "*.bin*" -not -name "*.ppm*" -not -name "*.ods*" -not -name "*trace*" -not -name "*chk*" -print0 | sort -z | xargs -r0 md5sum > checklist.chk
```

# 6. Devices
- List all devices :
```shell
cat /proc/bus/input/devices
```

# 7. Directories
- List all partitions
```shell
lsblk
lsblk -o name,mountpoint,label,size,uuid
lsblk -no label /dev/sdh1
```

- Get size of directory
```shell
du -sh <directory>
```

- Create file :
```shell
dd if=/dev/zero of=<name> bs=1M count=20
```

- Make filesystem :
```shell
mkfs.ext3 <name>
```

- Read with hexdump
```shell
hexdump -C <fileName>
```

- Mount partition :
```shell
mount -o loop <name> /mnt/
```

# 8. Compilation
- Get compilation/installation informations :
```shell 
uname -a
```

- Read a binary via disassembly commands (_Ex : see options of applications_)
```shell
strings <filename>
```

- Compile for target
```shell
make sdk
```

# 9. Libraries

In _dev_ phase, libraries are not always at their standard destination `/usr/lib` (because it's dev phase !), so to use an application which needed to be link to the library, we need to tell where to find this library. To do so, use :
```shell
# 1 library
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../bin/

# Multiple libraries (':' is the key character)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../../helper_tools/bin:../../custom_error/bin:../bin
```

# 10. Modules
- List all availables modules
```shell
find /lib/modules/$(uname -r) -type f -name '*.ko*'
```

# 11. Symlinks

Sometimes, you copy some libraries directories and symlinks are _broken_...so how to spot and repair easily without looping through `ls -l` and `ln -sf <target> <link>`.  

Easy ! Use [symlinks utility](https://linux.die.net/man/8/symlinks).  
**Example :**
```shell
$ rm a
$ ln -s a b
$ symlinks .
dangling: /tmp/b -> a
```

# 12. Custom terminal commands

Linux operating system allows users to create commands. To create custom commands :
1. Check that `~/.bashrc` have routine to load custom commands :
```shell
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```
> You can create custom commands directly in `~/.bashrc` file, but it's recommanded to export them in specific file (`~/.bash_aliases` in the example)

2. Open file where to put custom commands :
```shell
vi ~/.bash_aliases
```

3. Add functions and aliases :
```shell
##
# Host specific functions
##

# Function to set terminal title
function set-title(){
  if [[ -z "$ORIG" ]]; then
    ORIG="$PS1"
  fi
  TITLE="\[\e]2;$*\a\]"
  PS1="${ORIG}${TITLE}"
}

##
# Host specific aliases
##

# To perform host updates
alias maj='sudo apt update && sudo apt full-upgrade'
```
> Find complete custom `bash_aliases` here : ["Custom bash aliases"](custom_bash_aliases.md)

1. To reload `~/.bashrc` file :
- Open new tab
- Or : `source ~/.bashrc`

# 13. Linux versionning

Linux distros used a file which contains operating system identification data, this file is `etc/os-release` which is a symlink to `/usr/lib/os-release`

doc of the file : https://www.freedesktop.org/software/systemd/man/os-release.html
check version from your shell : https://unix.stackexchange.com/questions/88644/how-to-check-os-and-version-using-a-linux-command

# 14. Ressources

- https://askubuntu.com/questions/318530/generate-md5-checksum-for-all-files-in-a-directory
- https://stackoverflow.com/questions/1341467/find-filenames-not-ending-in-specific-extensions-on-unix
- https://askubuntu.com/questions/662339/sort-files-alphabetically-before-processing
- https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions