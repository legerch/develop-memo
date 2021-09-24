**Sommaire :**
- [1. Git command-line](#1-git-command-line)
  - [1.1. Général](#11-général)
  - [1.2. Merge](#12-merge)
  - [1.3. Patch](#13-patch)
- [2. Git UI](#2-git-ui)
  - [2.1. Real UI](#21-real-ui)
  - [2.2. Terminal UI](#22-terminal-ui)

# 1. Git command-line

## 1.1. Général 

- Lister les branches locales : `git branch`
- Lister les branches locales + remotes : `git branch -all`
- Lister les tags : `git tag`
- Lister les tags et appliquer un filtre : `git tag -l <pattern-with-quotes>`
- Supprimer une branche locale : `git branch -d <branchname>`
- Supprimer une branche distante : `git push <remote-name> --delete <branch-name>`
- Renommer une branche locale : `git branch -m <new_name>`
- Créer une branche remote à partir d'une branche locale : `git push origin -u <name>`
- Renommer une branche remote : Nécessaire de push la branche renommée et de supprimer l'ancienne
> Plus de détails ici : https://linuxize.com/post/how-to-rename-local-and-remote-git-branch/

- Créer une branche depuis un tag : `git branch <name-branch> <tag : origin/2021.02.x>`
- Créer une branche depuis un tag et checkout dessus : `git checkout tags/2020.02.3 -b 2020.02.3`
- Créer une branche depuis une branche locale : `git checkout -b <branch-name>`
- Créer une branche depuis une branche distante : `git checkout -b <branch-name> <remote-branch>` (ex : `git checkout -b 2021.02.x origin/2021.02.x`)
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
- Obtenir détails d'un tag en particulier : `git show <tag>` or `git log -1 <tag>`
- Obtenir détails d'un commit en particulier : `git show <sha1>` or `git log --format=%B -n 1 <sha1>`

- Obtenir les changement courants : `git diff` ou `git diff --staged` (si déjà _staged_)
- Committer avec description et message : utiliser `git commit` (ouvrira vim et permettra de renseigner un titre et une description)

- Ajouter une remote : `git remote add <remote name> <remote url>`
- Supprimer une remote : `git remote remove <remote name>`
- Obtenir l'url d'une remote : `git remote show <remote name>`
- Pousser une branche locale sur une remote spécifique : `git push <remote_name> <local_branch_name>:<remote_branch_name>` ou `git push <remote_name> <branch_name>` si la branche de la remote possède le même nom que celle en local.

- Comparer deux branches : `git diff branch1..branch2` 
- Comparer les commits de deux branches : `git log branch1..branch2`
- Obtenir le nombre de commits entre deux branches : `git rev-list --count branch1..branch2`

## 1.2. Merge

Plusieurs stratégies de merge existent, voir [git merge strategy](https://git-scm.com/docs/git-merge/en#_merge_strategies) pour plus de détails. Les stratégies _resolve_ (merge deux branches) et _octopus_ (merge plusieurs branches) sont les stratégies utilisées par défaut selon les cas.

Nous détaillerons ici une autre stratégie pouvant parfois être utile : [_ours strategy_](https://git-scm.com/docs/git-merge/en#_merge_strategies).  
> **Attention :** On parle bien ici de la stratégie **ours merge strategy** et non pas de l'option _ours_ de la stratégie **recursive merge strategy** qui sont deux choses distinctes.
 
Prenons l'exemple d'un projet possédant une branche `master` et `dev`, les modifications effectuées dans `dev` sont normalement dédiées à être merge dans `master`. Or, parfois, il y a eu tellement de changements dans la branche `dev` (restructuration du projet, nouvelle techno, etc...) qu'un merge classique n'est plus pertinent (surtout s'il y a eu d'autres commits en parallèle sur le master...).

Mais comment conserver l'historique de `master` mais en se rebasant sur la branche `dev`. Tout d'abord, l'option de _rebase_ ici est hors de question puisque l'on réécrirait l'historique `master` avec celui de `dev`, on souhaite conserver chacun des historiques.  
C'est là que la stratégie _ours_ devient utile !

Ainsi, nous pouvons utiliser les commandes suivantes pour appliquer la stratégie _ours_ pour merge `dev` dans la branche `master` :
```shell
git checkout develop
git merge -s ours master
git checkout master
git merge develop
```
> The resulting master should now contain the contents of your previous develop and ignore all changes in master.

## 1.3. Patch

https://stackoverflow.com/questions/2249852/how-to-apply-a-patch-generated-with-git-format-patch/50329788
(git apply applies changes as a patch, not as a commit, while git am assumes that the text of the email is the commit message (with some exceptions) and applies changes creating a commit (and it can try to resolve conflicts with 3-way merge with git am --3way)

Générer un patch pour chaque commit depuis le commit <SHA1> spécifié (non inclus) :
```shell
# Patch will be generated in current directory
git format-patch <SHA1>

# Path will be generated in directory "tmp-patch"
git format-patch -o tmp-patch/ <SHA1> 
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
> Better to use `git am -3` to perform 3-way merge

# 2. Git UI

## 2.1. Real UI

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

## 2.2. Terminal UI

Plusieurs projets de GIT UI ont également vu le jour pour fonctionner avec le terminal, ils permettent surtout de réduire les soucis de performance sur de gros projets (_ex : Noyau linux_) :
- [Lazygit](https://github.com/jesseduffield/lazygit)
  - Cross platform : Linux, windows, MacOS

- [gitui](https://github.com/extrawurst/gitui)
  - Cross platform : Linux, windows, MacOS
  - Meilleures performances face à _Lazygit_
  - Raccourcis claviers intuitifs
  - **Attention :** Projet en phase beta actuellement (21/09/2021)