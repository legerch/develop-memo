**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. Plugins](#2-plugins)
- [3. Snippets](#3-snippets)
  - [3.1. How to use ?](#31-how-to-use-)
  - [3.2. Particular case](#32-particular-case)
    - [3.2.1. C language](#321-c-language)
- [4. Ressources](#4-ressources)

# 1. Introduction

Official website : https://code.visualstudio.com/

# 2. Plugins

_Visual Studio Code_ allow usage of plugin, list of useful plugins :
- [Back & Forth](https://marketplace.visualstudio.com/items?itemName=nick-rudenko.back-n-forth)
- [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
- [Code Runner](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)
- [DeviceTree](https://marketplace.visualstudio.com/items?itemName=plorefice.devicetree)
- [Doxygen Documentation Generator](https://marketplace.visualstudio.com/items?itemName=cschlosser.doxdocgen)
- [Keep a Changelog](https://marketplace.visualstudio.com/items?itemName=RLNT.keep-a-changelog)
- [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
- [Todo Tree](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree)
- [Vscode-icons](https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons)

# 3. Snippets

## 3.1. How to use ?

_VsCode_ allow us to create custom snippets for each supported languages : https://code.visualstudio.com/docs/editor/userdefinedsnippets.  
Furthermore, some useful variables are available : `TM_FILENAME`, `CURRENT_DATE`, etc...

Generate our snippets at _VsCode_ format can become difficult, use [Snippet generator](https://snippet-generator.app/) to do so.
> An exemple for C language snippets can be found at : [dev/ide/vscode/res/c.json](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/IDE/VsCode/ressources/c.json)

## 3.2. Particular case
### 3.2.1. C language

In _VsCode_, `.h` are considered like **C++** files. Snippets defined for **C** header will not be trigger if they are in `c.json`. To do so, change default configuration to considered `.h` as **C** files (for **C++** header, use `hpp` extension) :  
1. `File` -> `Preferences`
2. `Settings`
3. `Text Editor` -> `Files`
4. Go to `Associations` fields
   1. Add in `Item` value : _*.h_
   2. Add in `Value` value : _c_
> Link of the associated issue : https://github.com/Microsoft/vscode-cpptools/issues/1476

# 4. Ressources

- Official documentation : 
  - Website : https://code.visualstudio.com/
  - Snippets : https://code.visualstudio.com/docs/editor/userdefinedsnippets
- Tutorials
  - https://sqldbawithabeard.com/2017/04/24/setting-the-default-file-type-for-a-new-file-in-vs-code/
- Threads :
  - https://stackoverflow.com/questions/50571130/how-can-i-create-templates-for-file-extensions-in-visual-studio-code
  - https://github.com/Microsoft/vscode-cpptools/issues/1476