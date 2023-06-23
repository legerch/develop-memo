Sommaire :
- [1. Instructions de débuggage - Débugguer sur une cible _remote_](#1-instructions-de-débuggage---débugguer-sur-une-cible-remote)
  - [1.1. Configuration Buildroot](#11-configuration-buildroot)
  - [1.2. Utilisation](#12-utilisation)
    - [1.2.1. Machine cible](#121-machine-cible)
    - [1.2.2. Machine hôte](#122-machine-hôte)
- [2. Instructions de débuggage - Fichier _core dump_](#2-instructions-de-débuggage---fichier-core-dump)
  - [2.1. Configuration de la cible](#21-configuration-de-la-cible)
  - [2.2. Configuration de l'hôte](#22-configuration-de-lhôte)
    - [2.2.1. Configuration de GDB](#221-configuration-de-gdb)
      - [2.2.1.1. Fichier .gdbinit](#2211-fichier-gdbinit)
    - [2.2.2. Configuration des ressources à debugger](#222-configuration-des-ressources-à-debugger)
- [3. Utilisation de GDB](#3-utilisation-de-gdb)
- [4. Ressources](#4-ressources)

# 1. Instructions de débuggage - Débugguer sur une cible _remote_

Remote debugging is the process of debugging a program running on a different system (called target) from a different system (called host).  
To start remote debugging, a debugger running on host machine connects to a program which is running on the target via network.  
The debugger in the host can then control the execution of the program on the remote system and retrieve information about its state.  

Remote debugging is often useful in case of embedded applications where the resources are limited.  

In this tutorial, we will see how we can debug programs running on a different system using GDB Server.  
We need the following two utilities to perform a remote debugging :
- `gdbserver` : Run this on your target system
- `GDB` : Execute this on your host system to connect to your target system
> `GDB` and `gdbserver` communicate via either a serial line or a network, using the standard gdb remote serial protocol.

## 1.1. Configuration Buildroot

Pour pouvoir utiliser `gdbserver` depuis la machine cible, il est nécessaire d'activer sa configuration dans **Buildroot** :
- `BR2_PACKAGE_HOST_GDB=y`
- `BR2_PACKAGE_GDB=y`
> Il n'y a pas besoin de compiler avec les symboles de débugguage ou de désactiver le "strip" pour les fichiers binaires pour la machine cible, `GDB` utilisera les ressources de l'host pour procéder au debuggage.

## 1.2. Utilisation
### 1.2.1. Machine cible

Pour lancer une session `gdbserver` depuis la machine cible :
```shell
gdbserver localhost:2000 myApplication
```
> Ici, l'execution de l'application `myApplication` sera suspendue jusqu'à ce qu'un debuggeur se connecte sur le port **2000**

### 1.2.2. Machine hôte

Pour se connecter au `gdbserver` distant :

1. Lancer `GDB` :
```shell
# Target used same toolchain as host
gdb myApplication
# Target used different toolchain from the host
arm-buildroot-linux-gnueabihf_sdk-buildroot//bin//arm-buildroot-linux-gnueabihf-gdb myApplication
```

2. Se connecter :
```shell
target remote 192.168.1.10:2000
```

Désormais, nous pouvons utiliser les [commandes classiques de `GDB`][anchor-gd-cmds].
> You can also use [VsCode to debug remotely][repo-vscode-dgb-remote]

# 2. Instructions de débuggage - Fichier _core dump_

Lorsque qu'une erreur se produit dans une application amenant à un "crash" de cette dernière (**SEGFAULT** par exemple), la cible est capable de créer fichier _core_ permettant un débuggage.

## 2.1. Configuration de la cible
  
Par défaut, cette fonctionnalité est désactivée, due à la taille qu'un _dump_ induit.  
Pour activer cette fonctionnalité, il est nécessaire d'augmenter la taille limite :
```shell
ulimit -c <unlimited|soft|hard>
```

Il est possible de lister toutes les limites avec la commande :
```
ulimit -a
```

Il est également possible de modifier l'une des limites directement dans l'application :
```C
#include <sys/resource.h>

struct rlimit core_limits;

core_limits.rlim_cur = RLIM_INFINITY    /* Soft limit */
core_limits.rlim_max = RLIM_INFINITY;   /* Hard limit */

setrlimit(RLIMIT_CORE, &core_limits);   /* RLIMIT_CORE is the macro associated to the size of core dumped */
```
> Voir [man setrlimit][doc-man-setrlimit] pour plus de details

## 2.2. Configuration de l'hôte

Le débuggeur utilisé est **GDB**.
> Note : Si l'application a été compilée avec une toolchain, il est nécessaire d'utiliser le debuggeur de cette même toolchain

### 2.2.1. Configuration de GDB

#### 2.2.1.1. Fichier .gdbinit

Pour utiliser GDB avec une application qui nécessite des librairies partagées, il est préférable de créer un `.gdbinit` de façon à configurer l'environnement GDB pour ce projet:
1. Créer le fichier `.gdbinit` dans le dossier de **Debug**
2. Spécifier le chemins vers les librairies partagées :
```
set solib-search-path [Directories]
show solib-search-path
```
> Il est possible de spécifier un ou plusieurs répertoires séparés par `:` sous **Linux** ou `;` sous **Windows**
> Pour plus de détails, voir la documentation officielle de [`set solib-search-path`][gdb-cmd-lib-search-path]

3. Démarrer la session de débuggage :
```shell
gdb pathToBin pathToCoreFile                            # Read default GDB configuration locate to ~/.gdbinit
gdb --init-command=./.gdbinit pathToBin pathToCoreFile  # Read default GDB configuration locate to ~/.gdbinit + specified .gdbinit

# Launch command example
arm-linux-gnueabihf-gdb --init-command=./.gdbinit  ./bin/rp2_core core_overlayGStreamer
```

### 2.2.2. Configuration des ressources à debugger

Pour pouvoir debbuguer un fichier _core_, il est nécessaire d'avoir : 
- un binaire de l'application en question, qui a été compilée avec les symboles de debuggage (le binaire générant le fichier _core_ n'a pas besoin d'avoir ces symboles de debuggage)
- les librairies partagées, compilées également avec les symboles de Debug  

Cas particuliers rencontrés :  
- **Buildroot** : Sous Buildroot, activer la compilation avec les symboles de debuggage ne suffit pas si l'on utilise les librairies utilisées par la cible, il faut également désactiver l'option d'optimisation des fichiers binaires de la cible, ci-dessous les 3 options à activer/modifier pour un debuggage plus simple :  
- `Build-options` -> `build packages with debugging symbols` (BR2_ENABLE_DEBUG) : `yes`
- `Build-options` -> `build packages with debugging symbols` (BR2_ENABLE_DEBUG) -> `strip target binaries` (BR2_STRIP_strip) : `none`
- `Build-options` -> `build packages with debugging symbols` (BR2_ENABLE_DEBUG) -> `optimize for debugging` (BR2_OPTIMIZE_G) : `yes`
> Ressources used to resolv this:
> - [thread-busybox-br-ddbg-strip]

# 3. Utilisation de GDB

Les **principales** commandes :
- Backtrace : `backtrace` ou `bt` (`bt full` pour une backtrace détaillée)
Permet d'obtenir une trace de la mémoire au moment du crash (_stack trace_).  
Chaque invocation de fonctions comportera un identifiant, il est possible d'utiliser `frame <identifiant>` pour sélectionner une fonction particulière.  
Il est ensuite possible d'utiliser `list` pour voir le code associé et `info locals``pour voir les variables locales. 

- Démarrer le programme : `run` ou `r`
- Continuer jusqu'à la fin du programme ou le prochain _breakpoint_: `continue` ou `c`
- Step over : `next` ou `n`
- Step into : `step` ou `s`
- Afficher la valeur d'une variable : `print <nomVariable>` ou `p <nomVariable>`
- Lister les fonctions du programme : `info functions`
- Voir l'état du programme : `info frame`
- Vérifier si les librairies partagées (_shared libraries_) ont pu être chargées correctement ou non : `info sharedlibrary`
- Lister les registres : `info registers`
- Lister le mappage mémoire : `info target`
- Afficher l'aide : `help`
- Quitter GDB : `quit` ou `q`
> Ressources used:
> - [Command list][gdb-cmd-list]
> - [Continuing and stepping][gdb-continuing-stepping]

Les **breakpoints**, via le mot-clé `break` ou `b` :
- `break <function>` : Placer un breakpoint sur une fonction
- `break <linenum>` : Placer un breakpoint à un numéro de ligne
- `break <filename:linenum>` : Placer un breakpoint à un numéro de ligne d'un fichier (utile lors du débuggage d'une application utilisant une librairie par exemple) 
> Voir la documentation officielle pour plus de commandes liées aux [breakpoint][gdb-breakpoints]

Enfin, il est également possible de gérer les signaux liés à l'application. En effet GDB a son propre _signal handler_, ce qui fait que l'application ne les recevra pas, plusieurs solutions sont possibles :
- Désactiver la gestion d'un signal `<id-signal>` de GDB
```shell
handle <id-signal> noprint nostop pass
```
- Lancer un signal de GDB vers l'application :
```shell
signal <id-signal>
```

- On peut tout simplement envoyer un signal via `kill` dans un second terminal :
```
kill -<id-signal> <id-process-app>
```
> Ressources used to resolv this:
> - [thread-so-dbg-signal-handler]

# 4. Ressources

- Official:
  - GDB:
    - [Command list][gdb-cmd-list]
    - [Breakpoints][gdb-breakpoints]
    - [Continuing and stepping][gdb-continuing-stepping]
    - [`Set solib-search-path`][gdb-cmd-lib-search-path]
  - Linux:
    - [man `setrlimit`][doc-man-setrlimit]
- Tutorials:
  - [How to Debug Programs on Remote Server using GDBServer][tutorial-geekstuff-gdbserver-example]
  - [Analyze **core dump** file (FR)][tutorial-jlbicquelet-analyze-core-dump]
- Threads:
  - [thread-busybox-br-ddbg-strip]
  - [thread-so-analyze-core-dump]
  - [thread-so-dbg-signal-handler]

<!-- Anchor -->
[anchor-gd-cmds]: #3-utilisation-de-gdb

<!-- Links of this repository -->
[repo-vscode-dgb-remote]: ../../IDE/VsCode/README.md

<!-- External links -->
[doc-man-setrlimit]: https://linux.die.net/man/2/setrlimit

[gdb-cmd-list]: https://visualgdb.com/gdbreference/commands/
[gdb-cmd-lib-search-path]: https://visualgdb.com/gdbreference/commands/set_solib-search-path
[gdb-breakpoints]: https://ftp.gnu.org/old-gnu/Manuals/gdb/html_node/gdb_28.html#SEC29
[gdb-continuing-stepping]: https://sourceware.org/gdb/download/onlinedocs/gdb/Continuing-and-Stepping.html

[thread-busybox-br-ddbg-strip]: http://lists.busybox.net/pipermail/buildroot/2012-May/053310.html
[thread-so-analyze-core-dump]: https://stackoverflow.com/questions/5115613/core-dump-file-analysis
[thread-so-dbg-signal-handler]: https://stackoverflow.com/questions/36993909/debugging-a-program-that-uses-sigint-with-gdb

[tutorial-jlbicquelet-analyze-core-dump]: http://jlbicquelet.free.fr/aix/procedures/core_aix.php
[tutorial-geekstuff-gdbserver-example]: https://www.thegeekstuff.com/2014/04/gdbserver-example/