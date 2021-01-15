# Instructions de débuggage

Dans ce dossier se trouve des élements de documentation liés au DEBUG sous un environnement linux.

## Configuration de la cible

Lorsque qu'une erreur se produit dans une application amenant à un "crash" de cette dernière (**SEGFAULT** par exemple), la cible est capable de créer fichier _core_ permettant un débuggage.  
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

## Configuration de l'hôte

Le débuggeur utilisé est **GDB**.
> Note : Si l'application a été compilée avec une toolchain, il est nécessaire d'utiliser le debuggeur de cette même toolchain

### Configuration de GDB

#### Fichier .gdbinit

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

### Configuration des ressources à debugger

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


### Utilisation de GDB

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

> Docs :  
> - https://visualgdb.com/gdbreference/commands/
> - https://stackoverflow.com/questions/5115613/core-dump-file-analysis
> - http://jlbicquelet.free.fr/aix/procedures/core_aix.php