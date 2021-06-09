**Sommaire :**
- [1. Git command-line](#1-git-command-line)
  - [1.1. Général](#11-général)
  - [1.2. Patch](#12-patch)
- [2. Git UI](#2-git-ui)

# 1. Git command-line

## 1.1. Général 

- Lister les branches locales : `git branch`
- Lister les branches locales + remotes : `git branch -all`
- Lister les tags : `git tag`
- Supprimer une branche locale : `git branch -d <branchname>`
- Supprimer une branche distante : `git push <remote-name> --delete <branch-name>`
- Renommer une branche locale : `git branch -m <new_name>`
- Créer une branche remote à partir d'une branche locale : `git push origin -u <name>`
- Renommer une branche remote : Nécessaire de push la branche renommée et de supprimer l'ancienne
> Plus de détails ici : https://linuxize.com/post/how-to-rename-local-and-remote-git-branch/

- Créer une branche depuis un tag : `git branch <name-branch> <tag : origin/2021.02.x>`
- Créer une branche depuis un tag et checkout dessus : `git checkout tags/2020.02.3 -b 2020.02.3`
- Créer une branche depuis une branche locale : `git checkout -b <branch-name>`
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

- Obtenir historique de la branche courante : `git log`
- Obtenir historique de la branche courante en limitant nb commits et auteur : `git log -n 5 --author=Salvador`
- Obtenir historique de la branche courante en limitant nb commits et seule une ligne : `git log -n 5 --oneline`

- Obtenir les changement courants : `git diff` ou `git diff --staged` (si déjà _staged_)
- Committer avec description et message : utiliser `git commit` (ouvrira vim et permettra de renseigner un titre et une description)

## 1.2. Patch

https://stackoverflow.com/questions/2249852/how-to-apply-a-patch-generated-with-git-format-patch/50329788
(git apply applies changes as a patch, not as a commit, while git am assumes that the text of the email is the commit message (with some exceptions) and applies changes creating a commit (and it can try to resolve conflicts with 3-way merge with git am --3way)

Générer un patch pour chaque commit depuis le commit <SHA1> spécifié (non inclus) :
```shell
git format-patch <SHA1>
```

Générer un patch pour un commit spécifique :
```shell
git format-patch -1 <SHA1>
```

Générer un patch depuis un commit _Github_ :
Ajouter `.patch` (ou `.diff`) à l'URL du commit permet de le formatter :
```shell
https://github.com/foo/bar/commit/${SHA}.patch
```
> Reference : https://stackoverflow.com/questions/21903805/how-to-download-a-single-commit-diff-from-github


Appliquer un patch à un dépôt GIT :
```shell
git am <my-patch.patch>
git am path/*.patch
```

# 2. Git UI

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