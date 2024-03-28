This fill will resume all related terminal commands/operations.

**Table of content:**
- [1. How to add custom commands](#1-how-to-add-custom-commands)
- [2. How to set terminal terminal](#2-how-to-set-terminal-terminal)
  - [2.1. Set title of current terminal](#21-set-title-of-current-terminal)
  - [2.2. Set title of a terminal tab to open](#22-set-title-of-a-terminal-tab-to-open)
    - [2.2.1. Why doesn't work](#221-why-doesnt-work)
    - [2.2.2. What solution ?](#222-what-solution-)
    - [2.2.3. What about opening tab programmatically ?](#223-what-about-opening-tab-programmatically-)


# 1. How to add custom commands

Linux operating system allows users to create commands:
1. Check that `~/.bashrc` have routine to load custom commands :
```shell
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
```
> You can create custom commands directly in `~/.bashrc` file, but it's recommanded to export them in specific file (`~/.bash_aliases` in the example)

2. Open file where to put custom commands :
```shell
vi ~/.bash_aliases
```

3. Add functions and aliases :
```shell
##
# Host specific functions
##

function my-custom-function()
{
    printf "This is my custom function\n"
}

##
# Host specific aliases
##

# To perform host updates
alias maj='sudo apt update && sudo apt full-upgrade'
```
> Find complete custom `bash_aliases` here: ["Custom bash aliases"][bash-alias-custom]

4. To reload `~/.bashrc` file :
- Open new tab
- Source alias with: `source ~/.bashrc`

# 2. How to set terminal terminal

Weirdly... setting terminal title is not trivial under recent distribution... let's try it!

## 2.1. Set title of current terminal

We can use a custom function in order to set title of current terminal:
```shell
function set-title()
{
    if [[ -z "$ORIG" ]]; then
        ORIG="$PS1"
    fi
    TITLE="\[\e]2;$*\a\]"
    PS1="${ORIG}${TITLE}"
}
```
> TODO: add details on how things works (related to `$PS1` variable which set a custom escape sequence by default, so we have to "override" it)

## 2.2. Set title of a terminal tab to open
### 2.2.1. Why doesn't work
When trying to open a new tab terminal, we usually use:
```shell
gnome-terminal --tab --title="Custom title" --working-directory="/my/working/dir/"
```

But running this command, we can see that title is not set... why ? This is because some distributions (not all) set a custom escape sequence in `~/.bashrc` file, usually whith those lines:
```shell
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
```
> This sets terminal title everytime prompt text `PS1` is displayed. The part between `\[\e]0;` and `\a\]` determines what the title is going to be.

### 2.2.2. What solution ?

Replace this line to add custom variable:
```shell
PS1="\[\e]0;\${TERM_TITLE:-${debian_chroot:+($debian_chroot)}\u@\h \w}\a\]$PS1"
```

This basically says:
- If variable `TERM_TITLE` is set and not null, then use its value as the title
- Otherwise, use the default title

Now to change title of our tab, we can:
- Set `TERM_TITLE='new title'` whenever you want terminal title to change.
- Use `unset TERM_TITLE` or `TERM_TITLE=` to restore terminal title back to default.

And if you have a custom function in your `~/.bash_aliases` to set title (like in [this section][anchor-set-title-default]), you can replace it with:
```shell
function set-title()
{
    TERM_TITLE="$@"
}
```

### 2.2.3. What about opening tab programmatically ?

Now we can use this command to open a tab with a custom title:
```shell
gnome-terminal --tab -- bash -c "export TERM_TITLE=\"My custom title\"; bash"
```
This command will execute a custom bash command (via `-- bash -c`) to export value of `TERM_TITLE`.
> Note: If you don't want to export value, you can also totally erase(or comment) original `$PS1` line instead of replacing it. This will allow to use original command with:  
> `gnome-terminal --tab --title="Custom title"` 

> Ressources used to resolve this issue:
> - [https://unix.stackexchange.com/questions/177572/how-to-rename-terminal-tab-title-in-gnome-terminal][thread-so-terminal-title-prg]

<!-- Anchor of this file -->
[anchor-set-title-default]: #21-set-title-of-current-terminal

<!-- Repository ressource -->
[bash-alias-custom]: custom_bash_aliases.md

<!-- External links -->
[doc-useful-alias]: https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions
[thread-so-terminal-title-prg]: https://unix.stackexchange.com/a/728153/402010