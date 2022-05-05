This file will describe some **rule of thumb** used in commit message

**Table of content :**
- [1. Git rule 50/72](#1-git-rule-5072)
- [2. How to format your commit message](#2-how-to-format-your-commit-message)
  - [2.1. Git template](#21-git-template)
  - [2.2. External apps](#22-external-apps)
- [3. Ressources](#3-ressources)

# 1. Git rule 50/72

As a rule of thumb, use the 50/72 Git rule :
- First line is 50 characters or less
- Then a blank line
- Remaining text should be **wrapped** at 72 characters

Multiple projects use this rule : [Linux kernel][git-rule-kernel], Buildroot, etc... In fact, this is a well known rule in open-source community !  
> You can read [this blog post][git-rule-blog1] or this [thread][git-rule-thread] which explain why this can be useful !

# 2. How to format your commit message
## 2.1. Git template

Official documentation about git template can be found [here][doc-git-template-official].

1. Create a git template at `~/.gitmessage`
```shell
# Title: Summary, imperative, don't end with a period
# No more than 50 chars. #### 50 chars is here:  #

# Remember blank line between title and body.

# Body: Explain *what* and *why* (not *how*).
# Wrap at 72 chars. ################################## which is here:  #
```
> _Side note_ : It may be argued that this is, strictly speaking, not a template, as no part of it is actually used/included in the commit message

2. Tell Git to use the template file (globally, not just in the current repo)
```shell
git config --global commit.template ~/.gitmessage
```

3. Use it to commit
```shell
git commit
git commit -a
```
> Don't use `git commit -m "Commit message"`, otherwise template made will not be used.

## 2.2. External apps

Please refer to [list of apps][doc-ubuntu-packages] to get list of usefool tool for this behaviour.

# 3. Ressources

- Blogs
  - [git-rule-blog1]
  - [git-rule-blog2]
  - [git-rule-gist]
  - [git-rule-thread]
- Projects
  - [git-rule-kernel]
- Official
  - [doc-git-template-official]

<!-- Links of this repository -->
[doc-ubuntu-packages]: https://github.com/BOREA-DENTAL/DocumentationsCobra/blob/master/Documentations/Developpement/Linux/Ubuntu/ubuntu_packages.md

<!-- External links -->
[git-rule-blog1]: https://cbea.ms/git-commit/
[git-rule-blog2]: https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[git-rule-gist]: https://gist.github.com/lisawolderiksen/a7b99d94c92c6671181611be1641c733
[git-rule-kernel]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=bc7938deaca7f474918c41a0372a410049bd4e13#n664
[git-rule-thread]: https://stackoverflow.com/questions/2290016/git-commit-messages-50-72-formatting

[doc-git-template-official]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration