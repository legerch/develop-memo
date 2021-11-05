**Table of contents :**

Table of contents :
- [1. Hardware properties](#1-hardware-properties)
- [2. Process](#2-process)
- [3. Checksum](#3-checksum)
- [4. Devices](#4-devices)
- [5. Directories](#5-directories)
- [6. Compilation](#6-compilation)
- [7. Libraries](#7-libraries)
- [8. Modules](#8-modules)
- [Symlinks](#symlinks)
- [9. Custom terminal commands](#9-custom-terminal-commands)
- [10. Ressources](#10-ressources)

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

# 2. Process
- Watch processus :
```shell
watch -n 0.1 cat /pro/interrupts
```

- Watch PID of an application (here we search application _app_ and _memcheck_)
```shell
watch -d "ps -a | grep 'app\|memcheck'"
```

- Watch ressources used :
```shell
top
htop
```

- Get status of `sync` command :
```shell
watch -d grep -e Dirty: -e Writeback: /proc/meminfo
```

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

# 3. Checksum

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

# 4. Devices
- List all devices :
```shell
cat /proc/bus/input/devices
```

# 5. Directories
- List all partitions
```shell
lsblk
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

# 6. Compilation
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

# 7. Libraries

In _dev_ phase, libraries are not always at their standard destination `/usr/lib` (because it's dev phase !), so to use an application which needed to be link to the library, we need to tell where to find this library. To do so, use :
```shell
# 1 library
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../bin/

# Multiple libraries (':' is the key character)
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:../../helper_tools/bin:../../custom_error/bin:../bin
```

# 8. Modules
- List all availables modules
```shell
find /lib/modules/$(uname -r) -type f -name '*.ko*'
```

# Symlinks

Sometimes, you copy some libraries directories and symlinks are _broken_...so how to spot and repair easily without looping through `ls -l` and `ln -sf <target> <link>`.  

Easy ! Use [symlinks utility](https://linux.die.net/man/8/symlinks).  
**Example :**
```shell
$ rm a
$ ln -s a b
$ symlinks .
dangling: /tmp/b -> a
```

# 9. Custom terminal commands

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
> Find complete custom `bash_aliases` here : ["Custom bash aliases"](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Linux/linux/custom_bash_aliases.md)

4. To reload `~/.bashrc` file :
- Open new tab
- Or : `source ~/.bashrc`

# 10. Ressources

- https://askubuntu.com/questions/318530/generate-md5-checksum-for-all-files-in-a-directory
- https://stackoverflow.com/questions/1341467/find-filenames-not-ending-in-specific-extensions-on-unix
- https://askubuntu.com/questions/662339/sort-files-alphabetically-before-processing
- https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions