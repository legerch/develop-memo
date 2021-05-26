**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. First thing to do](#2-first-thing-to-do)
  - [2.1. Set **Tab** parameter](#21-set-tab-parameter)
- [3. Plugins](#3-plugins)
- [4. Snippets](#4-snippets)
  - [4.1. How to use ?](#41-how-to-use-)
  - [4.2. Particular case](#42-particular-case)
    - [4.2.1. C language](#421-c-language)
- [5. Ressources](#5-ressources)

# 1. Introduction

Official website : https://code.visualstudio.com/

# 2. First thing to do

## 2.1. Set **Tab** parameter

With default settings, _VsCode_ will try to guess which behaviour to applied with keystroke **tab** by reading content of file.  
This is not the best option and can lead to an uncoherent workspace (header is configured with _space + 4_ and source file is configured with _tab + 8_).

To manage this behaviour, go to `settings` :
1. `File`
2. `Preferences` -> `Settings`
3. `Text editor`
4. Set indentation settings
   1. `Editor: Detect indentation` : **False**
   2. `Editor: Tab size` : **4**
   3. `Editor: Insert spaces` : **True**

> Better to insert _spaces_ instead of _tab_ because all editors have different behaviour with _tab_ character (gedit, git, etc...). With space, behaviour is well known.

In result, `settings.json` will result :
```json
// The number of spaces a tab is equal to. This setting is overridden
// based on the file contents when `editor.detectIndentation` is true.
"editor.tabSize": 4,

// Insert spaces when pressing Tab. This setting is overriden
// based on the file contents when `editor.detectIndentation` is true.
"editor.insertSpaces": true,

// When opening a file, `editor.tabSize` and `editor.insertSpaces`
// will be detected based on the file contents. Set to false to keep
// the values you've explicitly set, above.
"editor.detectIndentation": false

```

# 3. Plugins

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

# 4. Snippets

## 4.1. How to use ?

_VsCode_ allow us to create custom snippets for each supported languages : https://code.visualstudio.com/docs/editor/userdefinedsnippets.  
Furthermore, some useful variables are available : `TM_FILENAME`, `CURRENT_DATE`, etc...

Generate our snippets at _VsCode_ format can become difficult, use [Snippet generator](https://snippet-generator.app/) to do so.
> An exemple for C language snippets can be found at : [dev/ide/vscode/res/c.json](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/IDE/VsCode/ressources/c.json)

## 4.2. Particular case
### 4.2.1. C language

In _VsCode_, `.h` are considered like **C++** files. Snippets defined for **C** header will not be trigger if they are in `c.json`. To do so, change default configuration to considered `.h` as **C** files (for **C++** header, use `hpp` extension) :  
1. `File` -> `Preferences`
2. `Settings`
3. `Text Editor` -> `Files`
4. Go to `Associations` fields
   1. Add in `Item` value : _*.h_
   2. Add in `Value` value : _c_
> Link of the associated issue : https://github.com/Microsoft/vscode-cpptools/issues/1476

# 5. Ressources

- Official documentation : 
  - Website : https://code.visualstudio.com/
  - Snippets : https://code.visualstudio.com/docs/editor/userdefinedsnippets
- Tutorials
  - https://sqldbawithabeard.com/2017/04/24/setting-the-default-file-type-for-a-new-file-in-vs-code/
- Threads :
  - https://stackoverflow.com/questions/50571130/how-can-i-create-templates-for-file-extensions-in-visual-studio-code
  - https://github.com/Microsoft/vscode-cpptools/issues/1476