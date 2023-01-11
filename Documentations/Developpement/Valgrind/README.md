**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. Valgrind tools](#2-valgrind-tools)
  - [2.1. Memcheck](#21-memcheck)
    - [2.1.1. Overview](#211-overview)
    - [2.1.2. Alias command](#212-alias-command)
    - [2.1.3. Particular case : false-positive](#213-particular-case--false-positive)
      - [2.1.3.1. How to get "suppression file" ?](#2131-how-to-get-suppression-file-)
        - [2.1.3.1.1. List of existant _suppression file_](#21311-list-of-existant-suppression-file)
        - [2.1.3.1.2. Generate own _suppression file_](#21312-generate-own-suppression-file)
      - [2.1.3.2. How to apply "suppression file" ?](#2132-how-to-apply-suppression-file-)
  - [2.2. Helgrind](#22-helgrind)
    - [2.2.1. Overview](#221-overview)
    - [2.2.2. Alias command](#222-alias-command)
  - [2.3. DRD](#23-drd)
    - [2.3.1. Overview](#231-overview)
- [3. Links](#3-links)

# 1. Introduction

[Valgrind](https://valgrind.org/info/tools.html) is an instrumentation framework for building dynamic analysis tools. There are Valgrind tools that can automatically detect many memory management and threading bugs, and profile your programs in detail. You can also use Valgrind to build new tools.  

# 2. Valgrind tools

## 2.1. Memcheck
### 2.1.1. Overview

[Memcheck](https://www.valgrind.org/info/tools.html#memcheck) is used to help detection of memory-management problems.  
This tools can used many options, we show here the best command-line option to used or somes particular cases, please see [Memcheck documentation](https://valgrind.org/docs/manual/mc-manual.html) for more details.  

Interesting options :
- `--leak-check`
- `--show-reachable`
- `--show-leak-kinds`
- `--track-origins`

Options detailled below : [Particular case - false-positive](#particular-case--false-positive)
- `--suppressions`
- `--gen-suppression`

### 2.1.2. Alias command
An alias commands for _Valgrind memcheck_ can be added in order to not taping all options at each time (see more details here : [Linux - Custom terminal commands](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Linux#8-custom-terminal-commands)) :
```shell
# Valgrind memcheck alias
alias vg-memcheck='valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --track-fds=yes'
```

In this way, we can use :
```shell
# equivalent to : valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --track-fds=yes ./bin/myapp
vg-memcheck ./bin/myapp
```
> **Note:** option `--track-fds=yes` is used to follow file descriptors

### 2.1.3. Particular case : false-positive 

Sometimes, we want to perform a memory-management test on a application who used external libraries, sometimes those "memory leaks" are in reality false-positive due to some optimisation (example with _GStreamer_).  
So, how to ignore memory leaks from others libraries ? Use options `--suppression` !  

When valgrind runs _Memcheck_ tool, it automatically tries to read a file called `$PREFIX/lib/valgrind/default.supp` ($PREFIX will normally be /usr). However you can make it use additional suppression files of your choice by adding `--suppressions=<filename>` to your command-line invocation :
```shell
vg-memcheck='valgrind --tool=memcheck --suppressions=supfile1.supp --suppressions=supfile2.supp
```

In this section, we gonna used an example, where all files can be found here : [Example - Suppression file](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Valgrind/example-suppression_file)

#### 2.1.3.1. How to get "suppression file" ?
##### 2.1.3.1.1. List of existant _suppression file_
Some libraries already have a suppression file :
- GLib : [glib.supp][vg-sup-file-glib] (also installed in `/usr/share/glib-2.0/valgrind/glib.supp`)
- GStreamer : [gst.supp][vg-sup-file-gstreamer] (note than you need to define `G_SLICE=always-malloc G_DEBUG=gc-friendly` to use GStreamer with Valgrind)

##### 2.1.3.1.2. Generate own _suppression file_

Be sure that those memory leaks are **REALLY** false-positive !  
Run valgrind as usual, but with the extra option `--gen-suppressions=all`. This tells valgrind to print a suppression after every error it finds.  
Example output :
```shell
==10977== Conditional jump or move depends on uninitialised value(s)
==10977==    at 0x9279BA4: __GI_strlen (strlen.S:37)
==10977==    by 0x97C27EB: ??? (in /usr/lib/libX11.so.6.3.0)
==10977==    by 0x97C2A8C: _XlcCreateLocaleDataBase (in /usr/lib/libX11.so.6.3.0)
==10977==    by 0x97C7B16: ??? (in /usr/lib/libX11.so.6.3.0)
==10977==    by 0x97C6EB2: ??? (in /usr/lib/libX11.so.6.3.0)
==10977==    by 0x97C7735: _XlcCreateLC (in /usr/lib/libX11.so.6.3.0)
==10977==    by 0x97EA8FF: _XlcUtf8Loader (in /usr/lib/libX11.so.6.3.0)
==10977==    by 0x97CF69A: _XOpenLC (in /usr/lib/libX11.so.6.3.0)
==10977==    by 0x97CF787: _XlcCurrentLC (in /usr/lib/libX11.so.6.3.0)
==10977==    by 0x97CFB78: XSupportsLocale (in /usr/lib/libX11.so.6.3.0)
==10977==    by 0x604B0B5: ??? (in /usr/lib/libgdk-x11-2.0.so.0.2000.1)
==10977==    by 0x604B1AE: gdk_set_locale (in /usr/lib/libgdk-x11-2.0.so.0.2000.1)
==10977== 
{
   <insert_a_suppression_name_here>
   Memcheck:Cond
   fun:__GI_strlen
   obj:/usr/lib/libX11.so.6.3.0
   fun:_XlcCreateLocaleDataBase
   obj:/usr/lib/libX11.so.6.3.0
   obj:/usr/lib/libX11.so.6.3.0
   fun:_XlcCreateLC
   fun:_XlcUtf8Loader
   fun:_XOpenLC
   fun:_XlcCurrentLC
   fun:XSupportsLocale
   obj:/usr/lib/libgdk-x11-2.0.so.0.2000.1
   fun:gdk_set_locale
}
```

Printing the suppressions inline like this means you have to cut/paste each to the suppression file by hand.  
A more realistic solution is to save the output to a file. You can do this with a standard unix redirection, or by using the `--log-file=<filename>` option. With large numbers of errors, you also need to tell valgrind to process them all, with the option `--error-limit=no`.  
So, for the 'minimal' sample (which is a good place to start) you might write : 
```shell
valgrind --leak-check=full --show-leak-kinds=all --error-limit=no --gen-suppressions=all --log-file=minimalraw.log ./bin/myapp
```

By using custom commands valgrind described on top :
```shell
valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --error-limit=no --gen-suppressions=all --log-file=minimalraw.log ./bin/myapp
```
> This last command will generate file that can be found here : [vg-rp2_core.log](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Valgrind/example-suppression_file/vg-rp2_core.log)

You now have a file containing the raw output, with the suppressions mingled with the errors and other stuff. Also, as errors are usually multiple, there'll usually be multiple instances of each suppression. So the next is to generate a valid _suppression file_ from the raw log file, to do so, use script [vg-parse-suppressions.sh](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Valgrind/scripts/vg-parse-suppressions.sh) :
```shell
cat vg-rp2_core.log | ./vg-parse-suppressions.sh > vg-rp2_core-full.suppr
```
> Generated file can be found here : [vg-rp2_core-full.suppr](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Valgrind/example-suppression_file/vg-rp2_core-full.suppr)

So, in this generated file, we have all memory-leaks (or errors) throws by _Valgrind Memcheck tool_, but we don't want to actually turn-off all reported errors, only those from external libraries, in this case, main goal was to turn-off all errors from library `/lib/ld-2.25.so` (which is the linker library). So we deleted all _suppress instructions_ and keep only those from library `/lib/ld-2.25.so`.
> Final suppresion file can be found here : [vg-rp2_core.suppr](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Valgrind/example-suppression_file/vg-rp2_core.suppr)

#### 2.1.3.2. How to apply "suppression file" ?

We now have all suppressions file we needed, so we can use :
```shell
valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes -s --suppressions=vg-rp2_core.suppr --suppressions=glib.supp ./rp2_core
```
This way, we know fore sure that all thrown errors are neither from `library GLib` and neither from `/lib/ld-2.25.so`

> Links used to resolv this issue :
> - https://stackoverflow.com/questions/2375726/how-do-you-tell-valgrind-to-completely-suppress-a-particular-so-file/4226706#4226706
> - https://stackoverflow.com/questions/56218885/how-to-get-rid-of-the-memory-leaks-in-third-party-frameworkgstreamer
> - https://wiki.wxwidgets.org/Valgrind_Suppression_File_Howto
> - https://wiki.wxwidgets.org/Parse_valgrind_suppressions.sh
> - https://developer.ridgerun.com/wiki/index.php?title=How_to_Analyze_GStreamer_with_Valgrind

## 2.2. Helgrind
### 2.2.1. Overview

[Hellgrind](https://www.valgrind.org/info/tools.html#helgrind) is a thread debugger which finds data races in multithreaded programs. It looks for memory locations which are accessed by more than one (POSIX p-)thread, but for which no consistently used (pthread_mutex_) lock can be found. Such locations are indicative of missing synchronisation between threads, and could cause hard-to-find timing-dependent problems. It is useful for any program that uses pthreads.  
This tools can used many options, please refer to [Hellgrind documentation](https://valgrind.org/docs/manual/hg-manual.html) for more details.

### 2.2.2. Alias command
An alias commands for _Valgrind helgrind_ can be added in order to not taping all options at each time (see more details here : [Linux - Custom terminal commands](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Linux#8-custom-terminal-commands)) :
```shell
# Valgrind helgrind alias
alias vg-helgrind='valgrind --tool=helgrind
```

In this way, we can use :
```shell
# equivalent to : valgrind --tool=helgrind ./bin/myapp
vg-helgrind ./bin/myapp
```

## 2.3. DRD
### 2.3.1. Overview

[DRD](https://www.valgrind.org/info/tools.html#drd) is used to help detection of memory-management problems.  
DRD is a tool for detecting errors in multithreaded C and C++ programs. The tool works for any program that uses the POSIX threading primitives or that uses threading concepts built on top of the POSIX threading primitives. While Helgrind can detect locking order violations, for most programs DRD needs less memory to perform its analysis.  
This tools can used many options, please refer to [DRD documentation](https://valgrind.org/docs/manual/drd-manual.html) for more details.

# 3. Links
- Official documentation : 
  - Valgrind overview : https://valgrind.org/info/tools.html
  - Valgrind memcheck documentation : https://valgrind.org/docs/manual/mc-manual.html
  - Valgrind helgrind documentation : https://valgrind.org/docs/manual/hg-manual.html
  - Valgrind DRD documentation : https://valgrind.org/docs/manual/drd-manual.html
- Tutorials
  - Valgrind : https://www.cprogramming.com/debugging/valgrind.html
  - Valgrind suppressions files : https://wiki.wxwidgets.org/Valgrind_Suppression_File_Howto
  - Script to manage suppressions files : https://wiki.wxwidgets.org/Parse_valgrind_suppressions.sh
  - Use Valgrind with GStreamer : https://developer.ridgerun.com/wiki/index.php?title=How_to_Analyze_GStreamer_with_Valgrind
- Threads forums used to resolves issues :
  - https://stackoverflow.com/questions/2375726/how-do-you-tell-valgrind-to-completely-suppress-a-particular-so-file/4226706#4226706
  - https://stackoverflow.com/questions/56218885/how-to-get-rid-of-the-memory-leaks-in-third-party-frameworkgstreamer

<!-- Links -->
[vg-sup-file-glib]: https://github.com/GNOME/glib/blob/main/tools/glib.supp
[vg-sup-file-gstreamer]: https://gitlab.freedesktop.org/gstreamer/common/-/blob/master/gst.supp