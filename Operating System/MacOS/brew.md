This file will resume all [Brew][brew-home] related informations

- [1. Manage Brew on multi-user setup](#1-manage-brew-on-multi-user-setup)

# 1. Manage Brew on multi-user setup

**Brew** must be installed for each user inside each _User Home_ folder. That way all packages are going to stay inside your user folder, and will not be visible or affect other users. As a good side effect if you delete that user, no trash is left behind on your system. So system wide pollution is minimised.

How to:

1. If you currently have brew installed on your system **globally**, I recommend [uninstalling brew][brew-uninstall] first. (You can see where brew is installed running `which brew`)
   
2. If you don't have **Command Line Tools** installed, you have to run this first:
```shell
xcode-select --install
```

3. Install _homebrew_:
```shell
cd $HOME
mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
```

4. Register path to _homebrew_ ressources to your global path
   1. MacOS Catalina 10.15 or newer:
    ```shell
    echo 'export PATH="$HOME/homebrew/bin:$PATH"' >> .zprofile
    ```
    2. MacOS Mojave 10.14 or older:
    ```shell
    echo 'export PATH="$HOME/homebrew/bin:$PATH"' >> .bash_profile
    ```

5. Close terminal and open a new (to reload configuration):
```shell
which brew
```
> [!IMPORTANT]
> Should display:
> ```shell
> /Users/<your_username>/brew/bin/brew
> ```

6. Ensure your installation is correct by running:
```shell
brew doctor
```

> [!NOTE]
> To resolve the issue, those ressources were used:
> - https://stackoverflow.com/questions/41840479/how-to-use-homebrew-on-a-multi-user-macos-sierra-setup
> - [Brew install docs][brew-install]

<!-- Links -->
[brew-home]: https://brew.sh/
[brew-install]: https://github.com/Homebrew/install
[brew-uninstall]: https://github.com/homebrew/install#uninstall-homebrew