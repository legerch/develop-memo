**Table of contents :**
- [1. Arduino boards](#1-arduino-boards)
- [2. Development](#2-development)
  - [2.1. Installation](#21-installation)
    - [2.1.1. Arduino IDE](#211-arduino-ide)
    - [2.1.2. VsCode](#212-vscode)
  - [2.2. Configure sample project](#22-configure-sample-project)
  - [2.3. Compilation](#23-compilation)
  - [2.4. Upload and run](#24-upload-and-run)
  - [2.5. Known issues](#25-known-issues)
    - [2.5.1. Linux - Snap installation](#251-linux---snap-installation)
      - [2.5.1.1. Cannot find Arduino IDE](#2511-cannot-find-arduino-ide)
      - [2.5.1.2. Unable to list board](#2512-unable-to-list-board)

# 1. Arduino boards

| Board | Guide | Datasheet | Native Port Serial USB | Programming Port Serial |
|:-:|:-:|:-:|:-:|:-:|
| [Arduino Due][arduino-due-store] | [Guide (new)][arduino-due-guide-new]<br>[Guide (old)][arduino-due-guide-old] | [Datasheet][arduino-due-datasheet] | Yes | Yes |

# 2. Development
## 2.1. Installation
### 2.1.1. Arduino IDE

1. Install [Arduino IDE][arduino-ide]
2. Configure IDE:
   1. Go to `Preferences`
   2. Set **Compiler warnings** to `all`
   3. Set **Verify code after upload** to `true`
3. Install board toolchain via **Board manager**

### 2.1.2. VsCode

It is also possible to develop for Arduino under [VsCode][repo-ide-vscode]. In order to do so, we need to:
1. Install [arduino-cli][arduino-cli-official]
   1. **Windows**: Use provided setup
   2. **Linux**: Multiple choices are available:
      1. Custom bash functions used to easily update **arduino-cli** binary from `tar.gz` latest archive, those functions and aliases are available in [custom bash aliases][repo-linux-bash-aliases-custom]
      2. Use official install script from [arduino-cli][arduino-cli-official] (this script can fail if trying to install in location own by root, this is why I use a custom bash alias instead)
      3. Use [snap version][arduino-cli-snap] (but currently incompatible to be used with [VsCode][repo-ide-vscode], see [issues related to Linux snap package][anchor-issues-linux-snap])

2. Install _VsCode_ extension [vscode-arduino][arduino-vscode-extension]
3. Configure extension (those parameters will set global `settings.json` of _VsCode_):
    - **Windows :**
    ```json
    "arduino.enableUSBDetection": true,
    "arduino.useArduinoCli": true,
    "arduino.path": "C:\\Users\\<username>\\Downloads\\Setup\\arduino\\arduino-cli_0.26.0_Windows_64bit"
    ```
    - **Linux :**
    ```json
    "arduino.enableUSBDetection": true,
    "arduino.useArduinoCli": true,
    "arduino.path": "/usr/local/bin/",
    "vsicons.dontShowNewVersionMessage": true,
    "arduino.commandPath": "arduino-cli"
    ```
4. Restart _VsCode IDE_
5. Install board toolchain via command panel **Arduino: Board manager**

## 2.2. Configure sample project

Just to verify than we can used Arduino setup, let's start a simple project with [provided built-in examples][arduino-builtin-examples].  
We choose [blink][arduino-builtin-example-blink] here:
1. Create directory structure
```shell
.
└── blink
    └── blink.ino
```
> **Note:** In order to build a `.ino` file, parent directory **must** be named same as `.ino` file.  
> In our case, our main file is `blink.ino`, so it must be added to `blink` folder.

2. Set project properties
   1. Select Arduino board to used via **Board config**
   2. Set port to use, examples
      1. **Windows:** `COM4`
      2. **Linux:** `/dev/ttyACM0`
   3. Output path to used for build files (**Warning:** This folder must be different than project folder !)

Under **VsCode**, those settings will be put in `.vscode/arduino.json` file of the project. For this example, this file is:
```json
{
    "sketch": "blink/blink.ino",
    "board": "arduino:sam:arduino_due_x_dbg",
    "output": "../build-arduino_examples_blink/",
    "port": "/dev/ttyACM0"
}
```

3. Paste _blink_ code into `blink.ino` file.

## 2.3. Compilation

To compile a sketch, use command `verify`

## 2.4. Upload and run

To upload (and run) your sketch, use command `upload`.
> **Note:** Some Arduino boards use two USB ports (**Native Port Serial USB** and **Programming Port Serial**).  
> Upload is only available on **Programming Port Serial** on those boards and serial communication is available on both ports.

Under a _Linux OS_, it may be necessary to proceed to few more steps to be able to upload your sketch to the board, see [Troubleshooting - Fix port access on Linux][arduino-troubleshooting-linux-port-access].

## 2.5. Known issues
### 2.5.1. Linux - Snap installation
#### 2.5.1.1. Cannot find Arduino IDE

This problem is specific to **snap installation** and **VsCode environment**, it may appears this can of message error: _"Cannot find Arduino IDE. Please specify the 'arduino.path"_ even after [extension configuration][#212-vscode]. To fix this issue, set those parameters in extension parameter:
- **Use Arduino Cli**: `true`
- **Path**: `/snap/bin/`
- **Command path**: `arduino-cli`

Global file `settings.json` must have those entries:
```json
"arduino.useArduinoCli": true,
"arduino.path": "/snap/bin/",
"arduino.commandPath": "arduino-cli"
```

> **Related issue :** [issue 1346][arduino-vscode-extension-issues-1346]  
> **Comment used to solve issue:** [issue 1346 - Comment][arduino-vscode-extension-issues-1346-resolve]

#### 2.5.1.2. Unable to list board

This problem is specific to **snap installation**, it may be issues when listing boards (and sketch upload).  
Please refer to official documentation of [arduino-cli snap][arduino-cli-snap] which **clearly** explain what to do in this case.

Once, board list is working in command-line, you may not be able to use it under  **VsCode**, this issue hasn't been solved yet... this is why I don't use snap anymore.

<!-- Anchor of this file-->
[anchor-install-vscode]: #212-vscode
[anchor-issues-linux-snap]: #251-linux---snap-installation

<!-- Repository links -->
[repo-ide-vscode]: https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/IDE/VsCode
[repo-linux-bash-aliases-custom]: https://github.com/BOREA-DENTAL/DocumentationsCobra/blob/master/Documentations/Developpement/Linux/linux/custom_bash_aliases.md

<!-- External links ressources -->
[arduino-builtin-examples]: https://docs.arduino.cc/built-in-examples/
[arduino-builtin-example-blink]: https://docs.arduino.cc/built-in-examples/basics/Blink

[arduino-cli-official]: https://arduino.github.io/arduino-cli/latest/
[arduino-cli-snap]: https://snapcraft.io/arduino-cli

[arduino-due-store]: https://store.arduino.cc/arduino-due
[arduino-due-guide-new]: https://www.arduino.cc/en/Guide/ArduinoDue
[arduino-due-guide-old]: https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwiDl-3QgvH5AhXXwYUKHWd8DlIQFnoECBYQAQ&url=https%3A%2F%2Fwww.arduino.cc%2Fen%2FGuide%2FArduinoDue%2F&usg=AOvVaw2keWTNubni4sdksLhBBk8G]
[arduino-due-datasheet]: http://www.atmel.com/Images/Atmel-11057-32-bit-Cortex-M3-Microcontroller-SAM3X-SAM3A_Datasheet.pdf

[arduino-ide]: https://www.arduino.cc/en/software

[arduino-troubleshooting-linux-port-access]: https://support.arduino.cc/hc/en-us/articles/360016495679-Fix-port-access-on-Linux

[arduino-vscode-extension]: https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.vscode-arduino
[arduino-vscode-extension-issues-1346]: https://github.com/microsoft/vscode-arduino/issues/1346
[arduino-vscode-extension-issues-1346-resolve]: https://github.com/microsoft/vscode-arduino/issues/1346#issuecomment-996972001