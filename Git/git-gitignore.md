**Sommaire :**

# Syntaxe

1. Permet de filtrer tous les fichiers portant l'extension `.so` de manière récursive (qui tient compte des _subdirectories_) :
```shell
06-app_layer/03-libs/*/.so
```

2. Permet d'ajouter une exception  
Exemple avec le répertoire d'une toolchain : nous souhaitons conserver le _Readme_ et le _Makefile_ mais pas les fichiers binaires
```shell
*               # Ignore all files
!Makefile       # Add exception on `Makefile`
!README.md      # Add exception on `README.md`
```
> **Note :** Il est également possible d'ajouter une exception sur les sous-dossiers :  
> ```shell
> !06-app_layer/03-libs/lib/board_armadeus/*
> ```

# Générateur de `Gitignore`

Un générateur selon le type de projet est également disponible sous le nom [gitignore.io](https://www.toptal.com/developers/gitignore), il est très complet :
- Projet C++
- Projet Java
- Projet Qt
- Projet Android
- etc...