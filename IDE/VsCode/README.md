**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. First thing to do](#2-first-thing-to-do)
  - [2.1. Set **Tab** parameter](#21-set-tab-parameter)
  - [2.2. Disable _Preview Mode_](#22-disable-preview-mode)
  - [2.3. Set keyboard shortcuts](#23-set-keyboard-shortcuts)
    - [2.3.1. How to ?](#231-how-to-)
    - [2.3.2. Which one ?](#232-which-one-)
    - [2.3.3. Reminders](#233-reminders)
  - [2.4. Set open editors panel order](#24-set-open-editors-panel-order)
- [3. Plugins](#3-plugins)
- [4. Snippets](#4-snippets)
  - [4.1. How to use ?](#41-how-to-use-)
  - [4.2. Particular case](#42-particular-case)
    - [4.2.1. C language](#421-c-language)
- [5. File association](#5-file-association)
  - [5.1. How to set](#51-how-to-set)
  - [5.2. Which to set](#52-which-to-set)
- [6. Debug session](#6-debug-session)
  - [6.1. Remote debug using gdbserver](#61-remote-debug-using-gdbserver)
- [7. Ressources used](#7-ressources-used)

# 1. Introduction

Official website : [VsCode][vscode-home]  
Variables reference of VsCode: [VsCode - Variable reference][vscode-vars-refs]

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

## 2.2. Disable _Preview Mode_

By default, when a tab is opened, if we don't modify it and open a new file, this new file will not open in a new tab but instead it will be put in replacement of first file, this is the _Preview Mode_.

To disable it, go to `setting` :
1. `File`
2. `Preferences` -> `Settings`
3. `Workbench`
4. Disable _Preview_ :
   1. `Editor: Enable Preview` : **False**

## 2.3. Set keyboard shortcuts

### 2.3.1. How to ?

Go to :
1. `File`
2. `Preferences` -> `Keyboard Shortcuts`
3. Click on _edit_ icon
4. Press new shortcut to use, this key can be already use, so be sure this new shortcut will not conflict.
5. Press `Enter` to save

### 2.3.2. Which one ?
List of default keyboard shortcut to change:

| Title | Default | Custom |
|:-:|:-:|:-:|
| Switch between Header/Source | `Alt + O` | `F4` |

### 2.3.3. Reminders

| Title | Shortcut |
|:-:|:-|
| Open panel control | `Ctrl + Shitf + P` |
| Preview markdown file | `Ctrl + Shitf + V` |
| Multiline selection | `Alt + Shift + Mouse Left` |
| Set cursor to end of all lines | - Select all: `CTRL + A`<br>- Set cursor to end of lines: `ALT + SHIFT + I` |
| Move line down | `Alt + DownArrow` |
| Move line up | `Alt + UpArrow` |

## 2.4. Set open editors panel order

Open editors panel by defult sort by latest used (I've encountered case when even this order wasn't respected). So change it to sort it **alphabetically**:
- In `Settings` panel
- Search for `explorer.openEditors.sortOrder`
- Change value from `editorOrder` to `fullPath`

# 3. Plugins

_Visual Studio Code_ allow usage of plugin, list of useful plugins and somes associated settings :
- [Arduino][plugin-arduino] (a [tutorial][repo-arduino] is available in this repository)
- [Back & Forth][plugin-back-forth]
- [C/C++][plugin-c-cpp]
- [Native Debug][plugin-native-debug]
- [Doxygen Documentation Generator][plugin-doxygen]
- [Doxyfile integration][plugin-doxyfile] (a [tutorial][repo-doxygen] is available in this repository)
- [Keep a Changelog][plugin-changelog]
- [Markdown All in One][plugin-markdown]
  - `Mardown/extension/print/Absolute Img Path`: By default, this setting is enable, disable it to make your `.html` **moveable** when using an `images` folder
  - `Mardown/extension/print/Img To Base64`: Can be useful to include images directly into `.html` files to get ride of the `images` folder when generate `.html`
- [Markdown emoji][plugin-markdown-emoji]: Use to add support for emoji in markdwon files (see [Github emoji cheat-sheet][github-list-emoji] for available emoji)
- [Todo Tree][plugin-todo-tree]
- [Vscode-icons][plugin-vscode-icons]
- [Color Highlight][plugin-color-highlight]
- [Workspace Storage Cleanup][plugin-workspace-cleanup]: To use it, you can use palette command `workspaces: cleanup storage`
- [Embedded Linux Kernel Dev][plugin-kernel-dev]: Useful to support _device-tree_ files and to find associated documentation (bindings and drivers). Be careful, this extension have dependencies packages, check `README` of it to install them !

# 4. Snippets

## 4.1. How to use ?

_VsCode_ allow us to create custom snippets for each supported languages : [VsCode - User snippets][vscode-snippets].  
Furthermore, some useful variables are available : `TM_FILENAME`, `CURRENT_DATE`, etc...

Generate our snippets at _VsCode_ format can become difficult, use [Snippet generator][snippet-generator] to do so.
> An exemple for C language snippets can be found at : [dev/ide/vscode/res/c.json][repo-snippets-c]

## 4.2. Particular case
### 4.2.1. C language

In _VsCode_, `.h` are considered like **C++** files. Snippets defined for **C** header will not be trigger if they are in `c.json`. To do so, change default configuration to considered `.h` as **C** files (for **C++** header, use `hpp` extension).  
See section [File association][anchor-file-assocation] for more details.
> Link of the associated [issue][issue-c-headers-not-triggered]

# 5. File association
## 5.1. How to set

To set language associated to a file extension:
1. `File` -> `Preferences`
2. `Settings`
3. `Text Editor` -> `Files`
4. Go to `Associations` fields
   1. Add in `Item` value : <my_extension>
   2. Add in `Value` value : <associated_language>

## 5.2. Which to set

| Item (extension) | Value (language) |
|:-:|:-:|
| `*.h` | `c` |
| `*.make` | `makefile` |

# 6. Debug session

To help to debug, plugin [Native Debug][plugin-native-debug] will be needed.  
Please read plugin documentation since this tutorial will concentrate on the `launch.json` configuration file.

## 6.1. Remote debug using gdbserver

If not already set, take a look to [how to debug remotely tutorial][repo-debug-gdbserver].  

1. To debug your remote directly inside VsCode instead of your terminal, set one `configuration` element of your `launch.json` as below:
```json
{
    "name": "DBG - SDK Remote - MyApp",
    "type": "gdb",
    
    "request": "attach",
    "remote": true,
    "target": "192.168.10.130:2000",
    
    "cwd": "${workspaceRoot}",
    "executable": "./relative-path-from-cwd/my_custom_app",
    "gdbpath": "native-path-to-my-compiler-debugger/aarch64-buildroot-linux-gnu-gdb",

    "stopAtEntry": true
}
```
This will attach to the running process managed by gdbserver on `192.168.10.130:2000`.
> Note for some specific variables of this example:
> - `gdbpath`: Set to a custom toolchain but if native _GDB_ must be used, use `/usr/bin/gdb`.  
> - `cwd`: This value is set to `${workspaceRoot}` which is part of [variables reference][vscode-vars-refs] automatically set by VsCode
> - `executable`: Path of application set here must be relative to path set in `cwd` field
> - `stopAtEntry`: Setting this value to `true` allow us to set breakpoint when debug session is started (since program will not start right away, it is paused at entry)

2. Set your breakpoints. Note that breakpoint can be added when debug session is active but you must **pause** current session, otherwise breakpoint will fail to be set.
3. Run debug session

# 7. Ressources used

- VsCode
  - [Home][vscode-home]
  - [Snippets][vscode-snippets]
  - [Variables reference][vscode-vars-refs]
- Tools
  - [snippet-generator]
- Threads
  - [VsCode - CppTools - Snippet can not work in C header file][issue-c-headers-not-triggered]
  - [Stackoverflow - How can I create templates for file extensions in Visual Studio Code ?][thread-so-create-templates-for-file-with-vscode]
  - [Stackoverflow - When creating a VSCode snippet, how can I transform a variable to title-case (like TitleCase) ?][thread-so-transform-vars-of-vscode]
  - [Stackoverflow - Open files always in a new tab][thread-so-vscode-open-files-new-tab]
  - [Stackoverflow - Is it possible to attach to a remote gdb target with vscode ?][thread-so-attach-to-remote-gdb-with-vscode1]
  - [Stackoverflow - How to attach to remote gdb with vscode ?][thread-so-attach-to-remote-gdb-with-vscode2]

<!-- Anchor to this file -->
[anchor-file-assocation]: #5-file-association

<!-- Links to this repository -->
[repo-arduino]: ../../Arduino/
[repo-doxygen]: ../../Documentation/
[repo-snippets-c]: ../../IDE/VsCode/ressources/c.json
[repo-debug-gdbserver]: ../../Toolchains/Debuggers/README.md#1-instructions-de-débuggage---débugguer-sur-une-cible-remote

<!-- External links -->
[vscode-home]: https://code.visualstudio.com/
[vscode-snippets]: https://code.visualstudio.com/docs/editor/userdefinedsnippets
[vscode-vars-refs]: https://code.visualstudio.com/docs/editor/variables-reference

[plugin-arduino]: https://marketplace.visualstudio.com/items?itemName=vscode-arduino.vscode-arduino-community
[plugin-back-forth]: https://marketplace.visualstudio.com/items?itemName=nick-rudenko.back-n-forth
[plugin-c-cpp]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools
[plugin-changelog]: https://marketplace.visualstudio.com/items?itemName=RLNT.keep-a-changelog
[plugin-color-highlight]: https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight
[plugin-doxyfile]: https://marketplace.visualstudio.com/items?itemName=samubarb.vscode-doxyfile
[plugin-doxygen]: https://marketplace.visualstudio.com/items?itemName=cschlosser.doxdocgen
[plugin-kernel-dev]: https://marketplace.visualstudio.com/items?itemName=microhobby.linuxkerneldev
[plugin-markdown]: https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
[plugin-markdown-emoji]: https://marketplace.visualstudio.com/items?itemName=bierner.markdown-emoji
[plugin-native-debug]: https://marketplace.visualstudio.com/items?itemName=webfreak.debug
[plugin-todo-tree]: https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree
[plugin-vscode-icons]: https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons
[plugin-workspace-cleanup]: https://marketplace.visualstudio.com/items?itemName=mehyaa.workspace-storage-cleanup

[github-list-emoji]: https://github.com/ikatyang/emoji-cheat-sheet

[snippet-generator]: https://snippet-generator.app/

[thread-so-create-templates-for-file-with-vscode]: https://stackoverflow.com/questions/50571130/how-can-i-create-templates-for-file-extensions-in-visual-studio-code
[thread-so-transform-vars-of-vscode]: https://stackoverflow.com/questions/52874954/when-creating-a-vscode-snippet-how-can-i-transform-a-variable-to-title-case-li
[thread-so-vscode-open-files-new-tab]: https://stackoverflow.com/questions/38713405/open-files-always-in-a-new-tab
[thread-so-attach-to-remote-gdb-with-vscode1]: https://stackoverflow.com/questions/38089178/is-it-possible-to-attach-to-a-remote-gdb-target-with-vscode
[thread-so-attach-to-remote-gdb-with-vscode2]: https://stackoverflow.com/questions/53519668/how-to-attach-to-remote-gdb-with-vscode

[issue-c-headers-not-triggered]: https://github.com/Microsoft/vscode-cpptools/issues/1476