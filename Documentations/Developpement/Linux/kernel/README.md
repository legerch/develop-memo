This document will resume multiple kernel repositories

- [Kernel.org](#kernelorg)
- [Codeaurora](#codeaurora)

# Kernel.org

Kernel repositories :
- Mainline kernel : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/
- Stable kernel : https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/

> Useful informations : https://stackoverflow.com/questions/18557690/why-kernel-repositories-tags-are-different

Kernels move from **prepatch** to **mainline** to **stable** (as described in https://www.kernel.org/releases.html and https://www.kernel.org/doc/Documentation/development-process/2.Process) :
- The **prepatch** (3.X-rc) and **mainline** (3.X) tags are in the `torvalds` repository maintained by _Linus Torvalds_ himself. 
- The **stable** (3.X.Y) and **longterm** (3.X.Y) tags are in the `stable` repository, maintained by designated maintainers.

> The Torvalds **mainline** repository represents the latest patches and fixes. Kernel versions that pass some degree of testing are moved to the **stable** repository and tagged. Afterwards, bug fixes are sometimes backported from mainline versions to tagged **stable** versions.

# Codeaurora

Ces informations proviennent de _M.Pinchart_ (mail 26/01/2022) lorsque j'ai demandé plus d'informations sur la façon dont était géré le dépôt _Freescale_ (`linux-imx`).

Le commit que vous citez ci-dessus correspond à la branchee du noyau NXP `imx_5.4.24_2.1.0`. Ma branche est quand à elle déjà basée sur la branche `imx_5.4.70_2.3.0`. Il y a donc plusieurs milliers de patches entre les deux.

Passer à une version plus récente du noyau peut se faire de deux manières, soit avec un merge, soit avec un rebase.

La première option n'est possible que si la nouvelle version du noyau est basée sur la version actuelle (par exemple, `imx_5.4.70_2.3.0`. est basée sur `imx_5.4.24_2.1.0`, sans rebase). Vous pouvez partir de votre noyau basé sur `imx_5.4.24_2.1.0`, et exécuter :
```shell
git commit merge imx_5.4.70_2.3.0
```

Il y a un faible risque de conflit, si les changements propres à votre branche entrent en conflit avec les changements effectués par NXP entre `imx_5.4.24_2.1.0` et `imx_5.4.70_2.3.0`. Dans ce cas, vous devrez résoudre les conflits.

Si le nouveau noyau n'est pas basé directement sur le précédent, un merge est impossible. C'est généralement le cas lorsque vous passez à une nouvelle version majeure d'un noyau BSP, par exemple lorsque NXP publiera un noyau BSP basé sur le v5.10, car les BSPs sont typiquement réécrit lors du passage à la version majeure suivante.  Dans ce cas, l'ancien BSP et le nouveau BSP contiennent plusieurs milliers de commits différents (juste pour les modifications apportées par NXP, sans compter les différences venant du noyau mainline), ce qui générerait des conflits partout, impossibles à résoudre. Dans ce cas de figure, un rebase est nécessaire.

Prenons un exemple concret. Lorsque NXP a commencé le développement de leur **BSP v5.4.x**, ils sont partis du noyau upstream **v5.4.0** et ont créé une branche appelée `lf-5.4.y`. Il y ont ajouté 3644 commits, un nombre important de commits par-dessus :
```shell
 v5.4.0
    |
    | 3644 commits de NXP
    |
    - lf-5.4.y
```

En parallèle, le noyau **v5.4** a continué à être développé par la communauté dans la branche stable **5.4.x** :
```shell
 v5.4.0
    |\
    | \
    |  |
    |  - v5.4.1
    |  |
    |  - v5.4.2
    |  |
    |  - v5.4.3
    -    lf-5.4.y
```

La version **v5.4.3** upstream a ensuite été intégrée dans la branche `lf-5.4.y` avec un merge, et NXP a continué le développement par-dessus :
```shell
 v5.4.0
    |\
    | \
    |  |
    |  - v5.4.1
    |  |
    |  - v5.4.2
    |  |
    |  - v5.4.3
    | /
    |/
    +
    |
    | xxxx commits supplémentaires de NXP
    |
    - lf-5.4.y
```

La procédure a été répétée tout au long du développement, en passant par les tags `rel_imx_5.4.24_2.1.0` et `rel_imx_5.4.70_2.3.0`. Le tag `rel_imx_5.4.24_2.1.0` est donc un ancêtre direct de `rel_imx_5.4.70_2.3.0`.

En pratique, c'est encore un peu plus compliqué, car il y a également des branches qui partent des différents tags (par example, la branche `imx_5.4.70_2.3.0` est basée sur le tag `rel_imx_5.4.70_2.3.0` et diverge ensuite avec quelques correctifs).

Puisque le tag `rel_imx_5.4.70_2.3.0` est basé sur le tag `rel_imx_5.4.24_2.1.0`, si vous disposez d'une branche basée sur `rel_imx_5.4.24_2.1.0`, vous pouvez y intégrer `rel_imx_5.4.70_2.3.0` par un merge :
```shell
       v5.4.0
          |
	      | 8494 commits (NXP & mainline)
          |
 rel_imx_5.4.24_2.1.0
          |\
 commits  | \
  Borea   |  |
          |  | 6076 commits (NXP & mainline)
          |  - rel_imx_5.4.70_2.3.0
	      | /
	      |/
	      +
```

La branche de droite contient plusieurs milliers de commits, combinant des commits de NXP, et des commits mainline, et votre branche à gauche contient très certainement un nombre beaucoup plus restreint de commits.

Lorsque NXP passera au noyau **5.10** (ou à un noyau plus récent), ils recommenceront le développement à partir du noyau **v5.10.0**, et aboutiront à une branche nommée par exemple `imx_5.10.54_1.0.0` :
```shell
       v5.10.0
          |
	      | xxxxx commits (NXP & mainline)
          |
 rel_imx_5.10.54_1.0.0
```

Si vous tentez d'intégrer cette version avec un merge, git va combiner plusieurs milliers commits NXP basés sur **v5.4** (entre `v5.4.0` et `rel_imx_5.4.70_2.3.0`), avec plusieurs milliers de commits NXP basés sur **v5.10** (entre `v5.10.0` et `rel_imx_5.10.54_1.0.0`). Ces commits auront été développés indépendemment, ils entreront en conflit partout.

Si vous tentez un rebase, en rebasant votre branch sur `rel_imx_5.10.54_1.0.0`, git va identifier tous les commits inclus dans votre branche qui ne sont pas inclus dans `rel_imx_5.10.54_1.0.0`. Il y aura des milliers de commits, qui entreront également en conflit avec `rel_imx_5.10.54_1.0.0`.

Ce problème peut être résolu par le fait que les commits de NXP, sur lesquels votre branche est basée, n'ont pas besoin d'être appliqués sur `rel_imx_5.10.54_1.0.0` puisque NXP garantit que `rel_imx_5.10.54_1.0.0` supporte l'i.MX8MM. Vous pouvez alors n'appliquer que les commits qui vous sont propres.

Ceci nécessite d'abord d'identifier ces commits. Si votre branche est basée directement sur `rel_imx_5.4.70_2.3.0`, les commits en question seront sur le dessus de la branche, et donc facilement identifiables :
```shell
 rel_imx_5.4.70_2.3.0
          |
	      | xx commits (Borea)
          |
          - borea_1.0.0
```

Vous pouvez utiliser l'option --onto de git rebase :
```shell
git rebase --onto rel_imx_5.10.54_1.0.0 rel_imx_5.4.70_2.3.0
```

git va appliquer sur `rel_imx_5.10.54_1.0.0` (argument passé à --onto) les commits entre `rel_imx_5.4.70_2.3.0` (second argument) et la branche courante.

Si votre branche a intégré différentes branches du noyau NXP (par exemple, avec des commits qui vous sont propres basés sur `rel_imx_5.4.24_2.1.0`, puis un merge de `rel_imx_5.4.70_2.3.0`, et ensuite d'autres commits qui vous sont propres), la situation est plus complexe, puisque les commits que vous devez appliquer sur `rel_imx_5.10.54_1.0.0` sont dispersés dans l'historique. Une option est de commencer par un rebase sur `rel_imx_5.4.70_2.3.0` pour isoler les commits propres sur le dessus de la branche, et ensuite d'utiliser `git rebase --onto`. En fonction de l'historique de développement, ce procédé peut générer un nombre plus ou moins important de conflits lors du rebase.

Il n'y a pas de solution miracle lorsque les branches divergent, en particulier lorqu'elles sont basées sur un noyau BSP. C'est la raison pour laquelle je conseille d'utiliser un noyau mainline lorsque c'est possible, et d'upstreamer au maximum le code développé (par exemple le driver _mt9m114_, et les correctifs pour les drivers NXP).

Pour revenir à votre première question, nous pouvons procéder de deux manières :
- Par rebase : en réécrivant l'historique, pour obtenir une branche linéaire basée sur le noyau NXP. Cette méthode facilitera le passage à une nouvelle version majeure du noyau NXP, mais rend le développement plus complexe si vous devez coordonner plusieurs développeurs avec un nombre important de commits.
- Par merge : cette méthode est plus facile lorsque plusieurs développeurs travaillent de manière concurrente, mais rend l'historique plus opaque et le passage à une nouvelle version majeure du noyau plus difficile.