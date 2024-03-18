**Sommaire :**
- [1. Git command-line](#1-git-command-line)
  - [1.1. Général](#11-général)
  - [1.2. Merge](#12-merge)
  - [1.3. Réecriture de l'historique](#13-réecriture-de-lhistorique)
    - [1.3.1. Modifier le contenu d'un commit](#131-modifier-le-contenu-dun-commit)
      - [1.3.1.1. Remplacer un commit : **fixup**](#1311-remplacer-un-commit--fixup)
      - [1.3.1.2. Editer un commit : **rebase interactive**](#1312-editer-un-commit--rebase-interactive)
    - [1.3.2. Retrouver un index perdu](#132-retrouver-un-index-perdu)
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
- Hard reset sur un commit spécifique : `git reset --hard <commid_id> && git clean -f`
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

## 1.3. Réecriture de l'historique
### 1.3.1. Modifier le contenu d'un commit

Il peut parfois être utile de modifier un commit alors que d'autres commits ont été créé depuis (gestion de patchs par exemple, pour éviter les patchs qui corrigent les patchs...). 

#### 1.3.1.1. Remplacer un commit : **fixup**

> Le principal est résumé ci-dessous, pour un tutoriel plus complet, voir [Medium - Git Commit Fixup, ou comment garder un historique propre][tutorial-edit-commit-fixup]   
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

5. Si ces modifications doivent être pousser sur un dépôt distant, l'option `--force` de `git push` sera nécessaire pour pouvoir réécrire l'historique du dépôt. Utiliser cette option avec **précaution !**

#### 1.3.1.2. Editer un commit : **rebase interactive**

Le cas précédent montrait comment remplacer un commit, que faire si on veut _éditer_ un commit ?

> Le tutoriel suivant est fortement inspiré de la réponse acceptée du post suivant [Stackoverflow - How do I modify a specific commit ?][tutorial-edit-commit-rebase-interactive]

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

1. Use [`git rebase`][tutorial-git-rebase] on `<sha1>` commit :
```shell
$ git rebase --interactive 'a45f953ccffc^'
```
> Please note the caret `^` at the end of the command, because you need actually to rebase back [to the commit before the one you wish to modify][thread-so-caret-git-usage].

2. This will open the default editor with the list of commit to rebase. All have the keywork `pick` (for `cherrypick`), modify `pick` to `edit` in the line mentioning `a45f953ccffc`.  
Save the file and exit. Git will interpret and automatically execute the commands in the file. You will find yourself in the previous situation in which you just had created commit `a45f953ccffc`.  
At this point, `a45f953ccffc` is your last commit. 

3. Make your changes and save.
4. Then, we can [easily amend commit][tutorial-git-amend] with the command:
```shell
$ git commit --all --amend --no-edit
```

5. After that, return back to the previous `HEAD` commit using:
```shell
$ git rebase --continue
```
> Note that this will change the SHA-1 of that commit as well as all children -- in other words, this rewrites the history from that point forward.

6. Since history has been rewritten, if push must be done to a remote repository, you need to use option `--force` from `git push` command. Use this command **carefully !**

### 1.3.2. Retrouver un index perdu

Après une réecriture de l'historique, il peut arriver d'avoir besoin de retourner à l'état initial... le problème étant : que faire si aucune autre copie locale et que la version remote a elle aussi été réécrite ?
Pour pouvoir retourner sur un index particulier, il faut connaître son _SHA-1_ ou sa référence _HEAD@{?}_

> Ressources utilisées :
> - [Stackoverflow - How can I recover from an erronous git push -f origin master?][thread-so-recover-err-git-push]
> - [Git reflog][git-cmd-reflog]

Pour cela, on peut utiliser la commande `git reflog` qui va lister toutes les actions git effectuées (checkout, rebase, etc...):
```shell
$ git reflog

# ...
afaa73d0 HEAD@{78}: rebase (pick): [clb::pp] Add support for P/P color reference values
08f3edf4 HEAD@{79}: rebase (pick): [clib:pp] Create custom type to store P/P coefficients
d5546c69 HEAD@{80}: rebase (start): checkout dev/4.1.x
815b94f8 HEAD@{81}: checkout: moving from dev/4.1.x to dev/add-pp-ref-white-rgb
# ...
```

Dans notre cas, nous souhaitons revenir à l'état avant le `rebase`, nous pouvons ainsi utiliser la commande:
```shell
git reset --hard HEAD@{81}
```

A partir d'ici, il est alors possible de créer une branche pour ensuite l'envoyer sur notre dépôt.
> Il est à noté que le résultat de `git reflog` peut varier selon la configuration/utilisation de `git gc` ou `git prune`

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

[git-cmd-reflog]: https://git-scm.com/docs/git-reflog
[git-merge-strategies]: https://git-scm.com/docs/git-merge/en#_merge_strategies
[git-merge-strategy-ours]: https://git-scm.com/docs/git-merge/en#_merge_strategies

[git-ui-gitkraken]: https://www.gitkraken.com/download
[git-ui-sourcetree]: https://www.sourcetreeapp.com/
[git-ui-gitcola]: https://git-cola.github.io/downloads.html
[git-tui-lazygit]: https://github.com/jesseduffield/lazygit
[git-tui-gitui]: https://github.com/extrawurst/gitui

[tutorial-linuxize-rename-branch]: https://linuxize.com/post/how-to-rename-local-and-remote-git-branch/
[tutorial-edit-commit-fixup]: https://medium.com/just-tech-it-now/git-commit-fixup-corriger-editer-un-commit-simplement-dd6c7d9026cd
[tutorial-edit-commit-rebase-interactive]: https://stackoverflow.com/questions/1186535/how-do-i-modify-a-specific-commit
[tutorial-git-amend]: https://www.atlassian.com/git/tutorials/rewriting-history#git-commit--amend
[tutorial-git-rebase]: https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase
[tutorial-git-overwriting-master-with-another-branch]: https://knasmueller.net/git-overwriting-master-with-another-branch

[thread-so-print-commit-message-of-a-given-commit]: https://stackoverflow.com/questions/3357280/print-commit-message-of-a-given-commit-in-git
[thread-so-caret-git-usage]: https://stackoverflow.com/questions/1955985/what-does-the-caret-character-mean-in-git
[thread-so-recover-err-git-push]: https://stackoverflow.com/questions/3973994/how-can-i-recover-from-an-erronous-git-push-f-origin-master