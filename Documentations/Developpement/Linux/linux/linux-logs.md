**Table of contents :**

# Introduction

This tutorial is about : _How to manage logs in Linux OS ?_

# Syslog daemon

Linux already have a built-in logs manager, called **syslog**. 

## OS utilities

On **Busybox** configuration, by default, all logs will be written to `/var/logs/message` file (which is a symlink to `/tmp`).
It is possible to change this behaviour by setting _syslog_ option at starting process :
- `-O <file>` : Use to set default file to write log in
- `-s <int>` : Use to set maximal size in **Kb** of a log file
- `-b <int>` : Use to set number of log file to use. If more than one, when maximal size is reached, file `message` is rename to `message.0` and a new `message` file is created. Furthermore, more the index is high, more the log file is old. (example : `message.4` is older than `message.0`) 

## C Program

It is also possible to call _syslog_ method in a C program to log application : [syslog API documentation](https://man7.org/linux/man-pages/man3/syslog.3.html)
