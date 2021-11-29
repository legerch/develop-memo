Sommaire :
- [1. Introduction](#1-introduction)
- [2. Instructions de débuggage - Débugguer sur une cible _remote_](#2-instructions-de-débuggage---débugguer-sur-une-cible-remote)
  - [2.1. Configuration Buildroot](#21-configuration-buildroot)
  - [2.2. Utilisation](#22-utilisation)
    - [2.2.1. Machine cible](#221-machine-cible)
    - [2.2.2. Machine hôte](#222-machine-hôte)
- [3. Instructions de débuggage - Fichier _core dump_](#3-instructions-de-débuggage---fichier-core-dump)
  - [3.1. Configuration de la cible](#31-configuration-de-la-cible)
  - [3.2. Configuration de l'hôte](#32-configuration-de-lhôte)
    - [3.2.1. Configuration de GDB](#321-configuration-de-gdb)
      - [3.2.1.1. Fichier .gdbinit](#3211-fichier-gdbinit)
    - [3.2.2. Configuration des ressources à debugger](#322-configuration-des-ressources-à-debugger)
- [4. Utilisation de GDB](#4-utilisation-de-gdb)
- [5. Ressources](#5-ressources)

# 1. Introduction

Dans ce dossier se trouve des élements de documentation liés au DEBUG sous un environnement linux.

# 2. Instructions de débuggage - Débugguer sur une cible _remote_

Remote debugging is the process of debugging a program running on a different system (called target) from a different system (called host).  
To start remote debugging, a debugger running on host machine connects to a program which is running on the target via network.  
The debugger in the host can then control the execution of the program on the remote system and retrieve information about its state.  

Remote debugging is often useful in case of embedded applications where the resources are limited.  

In this tutorial, we will see how we can debug programs running on a different system using GDB Server.  
We need the following two utilities to perform a remote debugging :
- `gdbserver` : Run this on your target system
- `GDB` : Execute this on your host system to connect to your target system
> `GDB` and `gdbserver` communicate via either a serial line or a network, using the standard gdb remote serial protocol.

## 2.1. Configuration Buildroot

Pour pouvoir utiliser `gdbserver` depuis la machine cible, il est nécessaire d'activer sa configuration dans **Buildroot** :
- `BR2_PACKAGE_HOST_GDB=y`
- `BR2_PACKAGE_GDB=y`
> Il n'y a pas besoin de compiler avec les symboles de débugguage ou de désactiver le "strip" pour les fichiers binaires pour la machine cible, `GDB` utilisera les ressources de l'host pour procéder au debuggage.

## 2.2. Utilisation
### 2.2.1. Machine cible

Pour lancer une session `gdbserver` depuis la machine cible :
```shell
gdbserver localhost:2000 myApplication
```
> Ici, l'execution de l'application `myApplication` sera suspendue jusqu'à ce qu'un debuggeur se connecte sur le port **2000**

### 2.2.2. Machine hôte

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

Désormais, nous pouvons utiliser les commandes classiques de `GDB`.

# 3. Instructions de débuggage - Fichier _core dump_

Lorsque qu'une erreur se produit dans une application amenant à un "crash" de cette dernière (**SEGFAULT** par exemple), la cible est capable de créer fichier _core_ permettant un débuggage.

## 3.1. Configuration de la cible
  
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
> Docs :  
> https://linux.die.net/man/2/setrlimit

## 3.2. Configuration de l'hôte

Le débuggeur utilisé est **GDB**.
> Note : Si l'application a été compilée avec une toolchain, il est nécessaire d'utiliser le debuggeur de cette même toolchain

### 3.2.1. Configuration de GDB

#### 3.2.1.1. Fichier .gdbinit

Pour utiliser GDB avec une application qui nécessite des librairies partagées, il est préférable de créer un `.gdbinit` de façon à configurer l'environnement GDB pour ce projet.

1) Créer le fichier `.gdbinit` dans le dossier de **Debug**
2) Spécifier le chemins vers les librairies partagées :
```
set solib-search-path [Directories]
show solib-search-path
```
Il est possible de spécifier un ou plusieurs répertoires séparés par `:` sous **Linux** ou `;` sous **Windows**
> Pour plus de détails concernant la commande :  
> https://visualgdb.com/gdbreference/commands/set_solib-search-path

3) Démarrer la session de débuggage :
```shell
gdb pathToBin pathToCoreFile                            # Read default GDB configuration locate to ~/.gdbinit
gdb --init-command=./.gdbinit pathToBin pathToCoreFile  # Read default GDB configuration locate to ~/.gdbinit + specified .gdbinit

# Launch command example
arm-linux-gnueabihf-gdb --init-command=./.gdbinit  ./bin/rp2_core core_overlayGStreamer
```

### 3.2.2. Configuration des ressources à debugger

Pour pouvoir debbuguer un fichier _core_, il est nécessaire d'avoir : 
- un binaire de l'application en question, qui a été compilée avec les symboles de debuggage (le binaire générant le fichier _core_ n'a pas besoin d'avoir ces symboles de debuggage)
- les librairies partagées, compilées également avec les symboles de Debug  

Cas particuliers rencontrés :  
1. Buildroot : Sous Buildroot, activer la compilation avec les symboles de debuggage ne suffit pas si l'on utilise les librairies utilisées par la cible, il faut également désactiver l'option d'optimisation des fichiers binaires de la cible, ci-dessous les 3 options à activer/modifier pour un debuggage plus simple :  
- `Build-options` -> `build packages with debugging symbols` (BR2_ENABLE_DEBUG) : `yes`
- `Build-options` -> `build packages with debugging symbols` (BR2_ENABLE_DEBUG) -> `strip target binaries` (BR2_STRIP_strip) : `none`
- `Build-options` -> `build packages with debugging symbols` (BR2_ENABLE_DEBUG) -> `optimize for debugging` (BR2_OPTIMIZE_G) : `yes`

> Liens utilisés :  
> http://lists.busybox.net/pipermail/buildroot/2012-May/053310.html


# 4. Utilisation de GDB

Les **principales** commandes :
- Backtrace : `backtrace` ou `bt` (`bt full` pour une backtrace détaillée)
Permet d'obtenir une trace de la mémoire au moment du crash (_stack trace_).  
Chaque invocation de fonctions comportera un identifiant, il est possible d'utiliser `frame <identifiant>` pour sélectionner une fonction particulière.  
Il est ensuite possible d'utiliser `list` pour voir le code associé et `info locals``pour voir les variables locales. 

- Afficher la valeur d'une variable : `print <nomVariable>` ou `p <nomVariable>`
- Lister les fonctions du programme : `info functions`
- Voir l'état du programme : `info frame`
- Vérifier si les librairies partagées (_shared libraries_) ont pu être chargées correctement ou non : `info sharedlibrary`
- Lister les registres : `info registers`
- Lister le mappage mémoire : `info target`
- Afficher l'aide : `help`
- Quitter GDB : `quit` ou `q`

Les **breakpoints**, via le mot-clé `break` ou `b` :
- `break <function>` : Placer un breakpoint sur une fonction
- `break <linenum>` : Placer un breakpoint à un numéro de ligne
- `break <filename:linenum>` : Placer un breakpoint à un numéro de ligne d'un fichier (utile lors du débuggage d'une application utilisant une librairie par exemple) 
> Pour plus de commandes liées au breakpoint, voir : https://ftp.gnu.org/old-gnu/Manuals/gdb/html_node/gdb_28.html#SEC29

# 5. Ressources

- Officiels :
  - [VisualGDB - GDB Command Reference](https://visualgdb.com/gdbreference/commands/)
- Tutoriels :
  - [How to Debug Programs on Remote Server using GDBServer](https://www.thegeekstuff.com/2014/04/gdbserver-example/)
  - [Analyser un fichier **core dump**](http://jlbicquelet.free.fr/aix/procedures/core_aix.php)
- Threads :
  - https://stackoverflow.com/questions/5115613/core-dump-file-analysis