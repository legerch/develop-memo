Dans ce document seront décrit toutes les procédures liées à la gestion de patch.

**Sommaire :**
- [1. Management](#1-management)
  - [1.1. Générer un patch](#11-générer-un-patch)
  - [1.2. Appliquer un patch](#12-appliquer-un-patch)
- [2. Contribuer à un projet open-source](#2-contribuer-à-un-projet-open-source)
  - [2.1. Configuration Git](#21-configuration-git)
  - [2.2. Projets](#22-projets)
- [3. Ressources](#3-ressources)

# 1. Management
## 1.1. Générer un patch

- Générer un patch pour chaque commit depuis le commit <SHA1> spécifié (non inclus) :
```shell
# Patch will be generated in current directory
git format-patch <SHA1>

# Patch will be numbered by starting at 500 instead of 1
git format-patch --start-number 500 <SHA1>

# Patch will be generated in directory "outgoing"
git format-patch -o outgoing/ <SHA1>

# Patch will be generated in directory "outgoing" and have a version
git format-patch -v2 -o outgoing/ <SHA1>
git format-patch --reroll-count=2 -o outgoing/ <SHA1>
```
> See [git format-patch][doc-git-format-patch] doumentation for more details

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

## 1.2. Appliquer un patch

- Appliquer un patch à un dépôt _Git_ :
```shell
git am -3 <my-patch.patch>
git am -3 path/*.patch
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

# 2. Contribuer à un projet open-source

Les projets open-source utilisent ce que l'on appelle une _mailing list_ qui permet de mettre les développeurs du projet en relation, leur permettant de procéder à une _review_ du ou des patchs proposés.

## 2.1. Configuration Git

Pour pouvoir _contribuer_ à un projet, il est nécessaire que _Git_ soit correctement configuré pour pouvoir envoyer les patchs par email.
> **Note :** Pour voir la configuration actuelle de Git, on peux afficher son fichier de configuration :
> - _Ubuntu path_ : `~/.gitconfig`

1. S'assurer que la commande `git send-email` est disponible
    ```shell
    git send-email --help
    ```

2. Installer l'extension si la commande n'est pas reconnue
    - **Ubuntu** :
    ```shell
    sudo apt install git-email
    ```

3. Configurer les paramètres globaux **Git**
    ```shell
    git config --global user.name "My Name"
    git config --global user.email "myemail@example.com"
    ```

4. Configuration les paramètres d'envoi de mails
   1. Commandes génériques 
        ```shell
        git config --global sendemail.smtpencryption tls
        git config --global sendemail.smtpserver mail.messagingengine.com
        git config --global sendemail.smtpuser myemail@example.com
        git config --global sendemail.smtpserverport 587
        git config --global sendemail.smtppass hackme
        ```
        > Storing the password in the git configuration file is obviously a security risk. It's not mandatory to configure the password. If it's not configured, `git send-email` will ask it every time the command is used.
    
    2. Exemple de serveur SMTP

    | Service | SMTP server | SMTP server port | Encryption |
    |:-:|:-:|:-:|:-:|
    | Office 365 | smtp.office365.com | 587 | tls |

5. Envoyer les patchs via email
    ```shell
    git send-email --to destination@address.com outgoing/*  # Will sent all patches of directory "outgoing"
    ```

## 2.2. Projets

- [Buildroot][br-contribute]
- [Linux][linux-contribute]

# 3. Ressources

- Git :
  - [format-patch][doc-git-format-patch]
  - [send-email][doc-git-send-email]
- [Patch][man-patch]
- Projects / Mailing lists
  - [Buildroot][br-contribute]
  - [Linux][linux-contribute]
- Tutoriels
  - [Freedesktop.org : How to use git send email ?][tutorial-how-to-use-git-send-email]
- Threads
  - [StackOverflow : How to download a single commit diff from github ?][thread-so-dl-patch-github]

<!-- External links -->
[br-contribute]: https://buildroot.org/downloads/manual/manual.html#submitting-patches
[linux-contribute]: https://docs.kernel.org/process/index.html

[doc-git-format-patch]: https://git-scm.com/docs/git-format-patch
[doc-git-send-email]: https://git-scm.com/docs/git-send-email

[man-patch]: https://man7.org/linux/man-pages/man1/patch.1.html

[tutorial-how-to-use-git-send-email]: https://www.freedesktop.org/wiki/Software/PulseAudio/HowToUseGitSendEmail/

[thread-so-dl-patch-github]: https://stackoverflow.com/questions/21903805/how-to-download-a-single-commit-diff-from-github