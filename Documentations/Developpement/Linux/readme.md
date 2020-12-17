# Linux tips

Table of contents :
- [Linux tips](#linux-tips)
  - [Hardware properties](#hardware-properties)
  - [Process](#process)
  - [Devices](#devices)
  - [Directories](#directories)
  - [Compilation](#compilation)
  - [Modules](#modules)
  - [Custom terminal commands](#custom-terminal-commands)

## Hardware properties 
- List hardwares properties and driver informations
```shell
lshw -h

# Example with network hardware
lshw -C network
```
> See also :
- https://www.binarytides.com/linux-lshw-command/
- https://www.geeksforgeeks.org/lshw-command-in-linux-with-examples/

## Process
- Watch processus :
```shell
watch -n 0.1 cat /pro/interrupts
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

## Devices
- List all devices :
```shell
cat /proc/bus/input/devices
```

## Directories
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

## Compilation
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

## Modules
- List all availables modules
```shell
find /lib/modules/$(uname -r) -type f -name '*.ko*'
```

## Custom terminal commands

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

4. To reload `~/.bashrc` file :
- Open new tab
- Or : `source ~/.bashrc`