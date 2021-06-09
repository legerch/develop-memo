**Sommaire :**
- [1. Introduction](#1-introduction)
- [2. Gérer des patchs locaux d'un projet open-source](#2-gérer-des-patchs-locaux-dun-projet-open-source)
  - [2.1. Exemple - Buildroot](#21-exemple---buildroot)
    - [2.1.1. Initial setup](#211-initial-setup)
    - [2.1.2. Generate patches](#212-generate-patches)
    - [2.1.3. Update project from upstream release](#213-update-project-from-upstream-release)
      - [2.1.3.1. Method 1 : Rebase](#2131-method-1--rebase)
      - [2.1.3.2. Method 2 : Use existing patches](#2132-method-2--use-existing-patches)

# 1. Introduction

Ce fichier décrit un possible _workflow_ pour une gestion plus simple de patch locaux d'un projet open-source (kernel linux, buildroot, etc...) qui n'ont pas vocation à être _push_ sur les dépôts officiels (patchs spécifiques au produit, sources fermées, etc...)

# 2. Gérer des patchs locaux d'un projet open-source

Il est possible de créer ses propres patchs sur un projet open-source. Mais il devient difficile de maintenir ces patchs lorsque l'on souhaite par exemple mettre à jour le projet en question avec la dernière version car cela nécessite d'également mettre à jour ses patchs locaux.  
Ici, nous décrirons un possible workflow pour faciliter la mise à jour des patchs locaux lors de la mise à jour du projet.  

## 2.1. Exemple - Buildroot

### 2.1.1. Initial setup

```shell
git clone --origin 'upstream' git.buildroot.net/buildroot/
cd buildroot
git checkout master     # or `git checkout -b 2021.02.x origin/2021.02.x`   or `git checkout tags/2020.02.3 -b 2020.02.3`
git checkout -b patched # or `git checkout -b patched-2021.02.x`            or `git checkout -b patched-2020.02.3`
# Method 1 : Make own changes
git add --all
git commit -m 'internal patches'
# Method 2 : Import existing patches
git am open-sourced-feature.patch
```

### 2.1.2. Generate patches

```shell
# Example : commit since tag 2020.02 of buildroot
git format-patch 1a6bd98fa87996f50f42a27857a9e9f029cc83e0

# Example : only 1 commit
git format-patch -1 <SHA1>
```

### 2.1.3. Update project from upstream release

#### 2.1.3.1. Method 1 : Rebase

```shell
git checkout master     # or `git checkout -b 2021.02.x origin/2021.02.x`   or `git checkout tags/2020.02.3 -b 2020.02.3`
git pull upstream
git checkout patched    # or `git checkout -b patched-2021.02.x`            or `git checkout -b patched-2020.02.3`
git rebase master
```
> **Note :** Le `rebase` peut être une lourde étape nécessitant de résoudre chaque commit (car conflits) depuis la précédente version.

#### 2.1.3.2. Method 2 : Use existing patches

Ici, on utilise les patchs utilsés pour les précédentes versions, ce qui permet de filtrer les commits qui nécessiterait une résolution de conflits, pour se concentrer uniquement sur les patchs locaux.

```shell
git checkout master     # or `git checkout -b 2021.02.x origin/2021.02.x`   or `git checkout tags/2020.02.3 -b 2020.02.3`
git pull upstream
git am my-folder-of-patches/*.patch # On importe les patchs déjà générés pour les mettre à jour : gestion des conflits plus simples
```
> Il est nécessaire par la suite de générer à nouveau les patchs avec la commande `git format-patch <sha1>`