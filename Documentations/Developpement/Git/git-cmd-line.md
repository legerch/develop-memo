**Sommaire :**
- [1. Git command-line](#1-git-command-line)
  - [1.1. Général](#11-général)
  - [1.2. Merge](#12-merge)
  - [1.3. Patch](#13-patch)
  - [1.4. Réecriture de l'historique](#14-réecriture-de-lhistorique)
    - [1.4.1. Modifier le contenu d'un commit](#141-modifier-le-contenu-dun-commit)
- [2. Git UI](#2-git-ui)
  - [2.1. Real UI](#21-real-ui)
  - [2.2. Terminal UI](#22-terminal-ui)

# 1. Git command-line

## 1.1. Général 

1. Gestion des branches :
- Lister les branches locales : `git branch`
- Lister les branches locales + remotes : `git branch -all`
- Lister les tags : `git tag`
- Lister les tags et appliquer un filtre : `git tag -l <pattern-with-quotes>`
- Supprimer une branche locale : `git branch -d <branchname>`
- Supprimer une branche distante : `git push <remote-name> --delete <branch-name>`
- Renommer une branche locale : `git branch -m <new_name>`
- Créer une branche remote à partir d'une branche locale : `git push origin -u <name>`
- Renommer une branche remote : Nécessaire de push la branche renommée et de supprimer l'ancienne
> Plus de détails ici : [Linuxsize - How to rename local and remote git branch][tutorial-linuxize-rename-branch]

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

2. Etude des commits
- Obtenir historique de la branche courante : `git log`
- Obtenir historique de la branche courante en limitant nb commits et auteur : `git log -n 5 --author=Salvador`
- Obtenir historique de la branche courante en limitant nb commits et seule une ligne : `git log -n 5 --oneline`
- Obtenir détails d'un tag en particulier : `git show <tag>` or `git log -1 <tag>`
- Obtenir détails d'un commit en particulier : `git show <sha1>` or `git log --format=%B -n 1 <sha1>`
- Chercher un commit contenant un pattern : `git log --all --grep='<pattern>'` (`--all` for all branches)

- Obtenir les changement courants : `git diff` ou `git diff --staged` (si déjà _staged_)
- Committer avec description et message : utiliser `git commit` (ouvrira vim et permettra de renseigner un titre et une description)

3. Gestion des remotes
- Lister les remotes : `git remote`
- Ajouter une remote : `git remote add <remote name> <remote url>`
- Supprimer une remote : `git remote remove <remote name>`
- Obtenir l'url d'une remote : `git remote show <remote name>`
- Récupérer (**pull**) une branche distante d'une remote spécifique vers une branche locale : `git pull <remote_name> <remote_branch_name>:<local_branch_name>` ou `git pull <remote_name> <branch_name>` si la branche de la remote possède le même nom que celle en local.
- Pousser (**push**) une branche locale sur une remote spécifique : `git push <remote_name> <local_branch_name>:<remote_branch_name>` ou `git push <remote_name> <branch_name>` si la branche de la remote possède le même nom que celle en local.
- Paramétrer une branche locale pour suivre une branche distante : `git branch --set-upstream-to=<remote>/<remote_branch> <local_branch>`
- Savoir à quel branche distante est associée une branche locale : `git branch -vv`
- Créer une branche locale depuis une branche distante d'une remote différente : `git fetch <remote> <remote_branch>:<local_branch>`

4. Add multiple push URLs to a single git remote 

Sometimes you need to keep two upstreams in sync with eachother. For example, you might need to both push to your testing environment and your GitHub repo at the same time. In order to do this simultaneously in one git command, here's a little trick to add multiple push URLs to a single remote.

Once you have a remote set up for one of your upstreams, run these commands with :
```shell
git remote set-url --add --push [remote] [original repo URL]
git remote set-url --add --push [remote] [second repo URL]
```

Once set up, `git remote -v` should show two (push) URLs and one (fetch) URL. Something like this :
```shell
$ git remote -v
origin git@github.com:username/original-repo.git (fetch)
origin git@github.com:username/original-repo.git (push)
origin git@github.com:username/second-repo.git (push)
```

Now, pushing to this remote will push to both upstreams simultaneiously. Fetch and pull from this remote will still pull from the original repo only.
> To delete an URL of remote : `git remote set-url --delete --push origin git@github.com:username/project.git`

5. Debugguage
- Activer le mode verbose : `GIT_TRACE=1` avant la commande git à utiliser (certaines nécessiterons le flag `--verbose` ou `-v` comme pour `git fetch -v`)

6. Comparaisons
- Comparer deux branches : `git diff branch1..branch2` 
- Comparer les commits de deux branches : `git log branch1..branch2`
- Obtenir le nombre de commits entre deux branches : `git rev-list --count branch1..branch2`

## 1.2. Merge

Plusieurs stratégies de merge existent, voir [git merge strategy][git-merge-strategies] pour plus de détails. Les stratégies _resolve_ (merge deux branches) et _octopus_ (merge plusieurs branches) sont les stratégies utilisées par défaut selon les cas.

Nous détaillerons ici une autre stratégie pouvant parfois être utile : [_ours strategy_][git-merge-strategy-ours].  
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

- Générer un patch pour chaque commit depuis le commit <SHA1> spécifié (non inclus) :
```shell
# Patch will be generated in current directory
git format-patch <SHA1>

# Path will be generated in directory "tmp-patch"
git format-patch -o tmp-patch/ <SHA1> 
```

- Générer un patch pour un commit spécifique :
```shell
git format-patch -1 <SHA1>
```

- Générer un patch depuis un commit _Github_ :
Ajouter `.patch` (ou `.diff`) à l'URL du commit permet de le formatter :
```shell
https://github.com/foo/bar/commit/${SHA}.patch
```
> Reference : [StackOverflow - How to download a single commit from Github][thread-so-dl-patch-github]

- Appliquer un patch à un dépôt GIT :
```shell
git am <my-patch.patch>
git am path/*.patch
```
> Better to use `git am -3` to perform 3-way merge

- Vérifier si un patch n'a pas déjà été appliqué : 
```shell
# If we could reverse the patch, then it has already been applied; skip it
if patch --dry-run --reverse --force < patchfiles/foo.patch >/dev/null 2>&1; then
  echo "Patch already applied - skipping."
else # patch not yet applied
  echo "Patching..."
  patch -Ns < patchfiles/foo.patch || echo "Patch failed" >&2 && exit 1
fi
```
> L'option `--dry-run` permet d'effectuer la commande sans les appliquer, elle simule l'action.    
> `patch` documentation : [man patch][man-patch]


## 1.4. Réecriture de l'historique
### 1.4.1. Modifier le contenu d'un commit

Il peut parfois être utile de modifier un commit alors que d'autres commits ont été créé depuis (gestion de patchs par exemple, pour éviter les patchs qui corrigent les patchs...).  
> Le principal est résumé ci-dessous, pour un tutoriel plus complet, voir [Medium - Git Commit Fixup, ou comment garder un historique propre][tutorial-medium-edit-commit]  
> Les commandes pour mémo :
> 1. `git commit -a --fixup=<sha1_commit>`
> 2. `git rebase -i --autosquash <sha1_commit>~`
> 3. `git push --force`

Admettons l'historique _git_ suivant :
```shell
charlie@charlie-B660M:~/Documents/workspaces/workspace-cobra/kernels/linux-imx$ git log -n 5 --oneline
ff07367f27fd (HEAD -> borea/imx8/5.4.70_2.3.2) media: i2c: mt9m114: Add debug timer on method used to set stream status
a45f953ccffc media: videobuf2-core: Add debug timer to track dequeue operation
d9cfc3d3d563 (upstream/borea/imx8/5.4.70_2.3.2) arm64: dts: Add missing DTS file in Freescale makefile
a9105b0b6636 arm64: dts: imx8mm-rayplicker: enable VPU and GPU
9371217537e3 arm64: dts: imx8mm-rayplicker: set DISP clocks
```

Je souhaite modifier le commit `a45f953ccffc media: videobuf2-core: Add debug timer to track dequeue operation`, comment procéder ? :
1. Faire les modifications nécessaires du code
2. Commiter ces modifications en utilisant l'option `--fixup=` permettant de préciser que l'on souhaite corriger un commit :
```shell
charlie@charlie-B660M:~/Documents/workspaces/workspace-cobra/kernels/linux-imx$ git commit -a --fixup=a45f953ccffc
[borea/imx8/5.4.70_2.3.2 d96725f13885] fixup! media: videobuf2-core: Add debug timer to track dequeue operation
 1 file changed, 8 insertions(+), 20 deletions(-)
```
3. Mettre à jour les commits dépendants en réécrivant l'historique via la commande _git_ `rebase` en précisant le commit qui a été fixé (sur lequel "rebaser") :
```shell
charlie@charlie-B660M:~/Documents/workspaces/workspace-cobra/kernels/linux-imx$ git rebase -i --autosquash a45f953ccffc~
Rebasage et mise à jour de refs/heads/borea/imx8/5.4.70_2.3.2 avec succès.
```
4. Le commit a correctement été modifié :
```shell
charlie@charlie-B660M:~/Documents/workspaces/workspace-cobra/kernels/linux-imx$ git log -n 10 --oneline
974cd5daed7b (HEAD -> borea/imx8/5.4.70_2.3.2) media: i2c: mt9m114: Add debug timer on method used to set stream status
48de28a6d6ed media: videobuf2-core: Add debug timer to track dequeue operation
d9cfc3d3d563 (upstream/borea/imx8/5.4.70_2.3.2) arm64: dts: Add missing DTS file in Freescale makefile
a9105b0b6636 arm64: dts: imx8mm-rayplicker: enable VPU and GPU
9371217537e3 arm64: dts: imx8mm-rayplicker: set DISP clocks
```
> Nous pouvons faire un `git show 48de28a6d6ed` pour véfifier le contenu du commit modifié.  
> On notera que les hash ont été modifiés.

5. Si ces modifications doivent être pousser sur un dépôt distant, l'option `--force` de `git push` sera nécessaire pour pouvoir réécrire l'historique du dépôt.

# 2. Git UI

## 2.1. Real UI

Plusieurs projets GIT UI sont disponibles :
- [GitKraken][git-ui-gitkraken] (compatible Windows, Mac, Linux)
  - UI user-friendly : branches disponibles facilement visibles et différenciables, historique complet, modification non validées affichées, etc... 
  - Permet le multi-compte
  - Gère facilement les submodules
  - Ne gère pas les patchs
  - Ne permet pas de travailler avec un gros dépôt type _kernel linux_ par exemple

- [Source-tree][git-ui-sourcetree] (compatible Windows et Mac )
  - UI relativement complète (trop !) : branches et historiques visibles mais pas évident à prendre en main
  - Ne permet pas le multi-compte
  - Gère les submodules 
  - Ne gère pas les patchs
  - Non testé sur dépôt volumineux
  
- [Git-cola][git-ui-gitcola] (compatible Windows, Mac, Linux)
  - UI simple : branches difficilement visibles, historique complet difficilement visible, modification non validées affichées
  - Ne permet pas le multi-compte
  - Gère les submodules
  - Gère les patchs (et utilise la commande `git am` pour les appliquer en interne)
  - Permet de travailler les dépôts volumineux types _kernel linux_

## 2.2. Terminal UI

Plusieurs projets de GIT UI ont également vu le jour pour fonctionner avec le terminal, ils permettent surtout de réduire les soucis de performance sur de gros projets (_ex : Noyau linux_) :
- [Lazygit][git-tui-lazygit]
  - Cross platform : Linux, windows, MacOS

- [gitui][git-tui-gitui]
  - Cross platform : Linux, windows, MacOS
  - Meilleures performances face à _Lazygit_
  - Raccourcis claviers intuitifs
  - **Attention :** Projet en phase beta actuellement (21/09/2021)

<!-- Links -->

[git-merge-strategies]: https://git-scm.com/docs/git-merge/en#_merge_strategies
[git-merge-strategy-ours]: https://git-scm.com/docs/git-merge/en#_merge_strategies

[git-ui-gitkraken]: https://www.gitkraken.com/download
[git-ui-sourcetree]: https://www.sourcetreeapp.com/
[git-ui-gitcola]: https://git-cola.github.io/downloads.html
[git-tui-lazygit]: https://github.com/jesseduffield/lazygit
[git-tui-gitui]: https://github.com/extrawurst/gitui

[man-patch]: https://man7.org/linux/man-pages/man1/patch.1.html

[thread-so-dl-patch-github]: https://stackoverflow.com/questions/21903805/how-to-download-a-single-commit-diff-from-github

[tutorial-linuxize-rename-branch]: https://linuxize.com/post/how-to-rename-local-and-remote-git-branch/
[tutorial-medium-edit-commit]: https://medium.com/just-tech-it-now/git-commit-fixup-corriger-editer-un-commit-simplement-dd6c7d9026cd