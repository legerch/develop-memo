**Sommaire :**

- [Git command-line](#git-command-line)
  - [Général](#général)
  - [Patch](#patch)
- [Git UI](#git-ui)

# Git command-line

## Général 

- Lister les branches : `git branch -a`
- Supprimer une branche locale : `git branch -d <branchname>`
- Supprimer une branche distante : `git push <remote-name> --delete <branch-name>`
- Créer une branche sur un commit spécifique : `git branch <branchname> <sha1-of-commit>`
- Hard reset sur la HEAD : `git reset --hard HEAD`
- Supprimer les fichiers locaux non trackés de la branche courante :
```shell
# If you want to see which files will be deleted you can use the -n option
git clean -n

# Delete them for real
git clean -f
git clean -fd   # To remove directories
git clean -fX   # To remove ignored files
git clean -fx   # To remove ignored and non-ignored files
```

## Patch

Générer un patch pour chaque commit depuis le commit <SHA1> spécifié :
```shell
git format-patch <SHA1>
```

Générer un patch pour un commit spécifique :
```shell
git format-patch -1 <SHA1>
```

Appliquer un patch à un dépôt GIT :
```shell
git am <my-patch.patch>
git am path/*.patch
```

# Git UI

Plusieurs projets GIT UI sont disponibles :
- GitKraken (compatible Windows, Mac, Linux) : https://www.gitkraken.com/download
  - UI user-friendly : branches disponibles facilement visibles et différenciables, historique complet, modification non validées affichées, etc... 
  - Permet le multi-compte
  - Gère les submodules
  - Ne gère pas les patchs
  - Ne permet pas de travailler avec un gros dépôt type _kernel linux_ par exemple

- Git-cola (compatible Windows, Mac, Linux) : https://git-cola.github.io/downloads.html
  - UI simple : branches difficilement visibles, historique complet difficilement visible, modification non validées affichées
  - Ne permet pas le multi-compte
  - Gère les submodules
  - Gère les patchs (et utilise la commande `git am` pour les appliquer en interne)
  - Permet de travailler les dépôts volumineux types _kernel linux_