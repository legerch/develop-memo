**Table of contents :**
- [1. Arduino boards](#1-arduino-boards)
- [2. Development](#2-development)
  - [2.1. Installation](#21-installation)
    - [2.1.1. Arduino IDE](#211-arduino-ide)
    - [2.1.2. VsCode](#212-vscode)
  - [2.2. Maintenance](#22-maintenance)
  - [2.3. Configure sample project](#23-configure-sample-project)
  - [2.4. Compilation](#24-compilation)
  - [2.5. Upload and run](#25-upload-and-run)
  - [2.6. Manage libraries](#26-manage-libraries)
    - [2.6.1. Arduino-cli](#261-arduino-cli)
    - [2.6.2. VsCode](#262-vscode)
  - [2.7. Use multiples sources files and classes](#27-use-multiples-sources-files-and-classes)
  - [2.8. Documentation](#28-documentation)
  - [2.9. Tips and tricks](#29-tips-and-tricks)
    - [2.9.1. `millis()` overflow](#291-millis-overflow)
    - [2.9.2. Don't manage hardware in class constructors](#292-dont-manage-hardware-in-class-constructors)
  - [2.10. Known issues](#210-known-issues)
    - [2.10.1. Linux - Snap installation](#2101-linux---snap-installation)
      - [2.10.1.1. Cannot find Arduino IDE](#21011-cannot-find-arduino-ide)
      - [2.10.1.2. Unable to list board](#21012-unable-to-list-board)

# 1. Arduino boards

| Board | Guide | Datasheet | Native Port Serial USB | Programming Port Serial |
|:-:|:-:|:-:|:-:|:-:|
| [Arduino Due][arduino-due-store] | [Guide (new)][arduino-due-guide-new]<br>[Guide (old)][arduino-due-guide-old] | [Datasheet][arduino-due-datasheet] | Yes | Yes (next to jack port) |

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

## 2.2. Maintenance

To update all installed _cores_ and _libraries_, you can use:
```shell
arduino-cli update  # Refresh indexes of cores and libraries
arduino-cli upgrade # Proceed to upgrade of all cores and libraries
```

## 2.3. Configure sample project

Just to verify that we can used Arduino setup, let's start a simple project with [provided built-in examples][arduino-builtin-examples].  
We choose [blink][arduino-builtin-example-blink] here:
1. Create directory structure
```shell
.
└── blink
    └── blink.ino
```
> [!CAUTION]
> In order to build a `.ino` file, parent directory **must** be named same as `.ino` file.  
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
    "port": "/dev/ttyACM0",
    "output": "../build-arduino_examples_blink/",
    "buildPreferences": [
        ["compiler.cpp.extra_flags", "-Wall -Wextra -Werror=format -Werror=return-type -Werror=implicit-function-declaration -Wformat=2 -Wshadow -Wlogical-op -Wno-ignored-qualifiers"]
    ]
}
```

3. Paste _blink_ code into `blink.ino` file.

## 2.4. Compilation

To compile a sketch, use command `verify`

## 2.5. Upload and run

To upload (and run) your sketch, use command `upload`.
> [!NOTE]
> Some Arduino boards use two USB ports (**Native Port Serial USB** and **Programming Port Serial**).  
> Upload is only available on **Programming Port Serial** on those boards and serial communication is available on both ports.

Under a _Linux OS_, it may be necessary to proceed to few more steps to be able to upload your sketch to the board, see [Troubleshooting - Fix port access on Linux][arduino-troubleshooting-linux-port-access].

## 2.6. Manage libraries

To manage **Arduino libraries**, please refer to [official libraries documentation][arduino-lib-install-official].  
All registered libraries are referenced at [Arduino - Libraries references][arduino-lib-references]. 

### 2.6.1. Arduino-cli

- List installed libraries:
```shell
arduino-cli lib list
```

- Install a library
```shell
arduino-cli lib install name_of_library
```

- Uninstall a library
```shell
arduino-cli lib uninstall name_of_library
```

### 2.6.2. VsCode

To manage libraries under **VsCode**, use command panel **Arduino: Library manager**

## 2.7. Use multiples sources files and classes

In order to use multiple sources files, you need a `src` folder in your project, a project example is available at [Arduino example - Find Ascii][repo-arduino-example-find-ascii].  
Note that to use _classes_, you need to include `#include <Arduino.h>`.

## 2.8. Documentation

In order to document your **Arduino** project with [Doxygen][doxygen-official] utility, it is needed to configure some others options in order to support `.ino` files :
- Project :
  - `EXTENSION_MAPPING` : Add `ino=C++` (since Arduino sketches are based on the C++ programming language)
- Input :
  - `FILE_PATTERNS` : Add `*.ino` extension

Then, `.ino` file must contains tag `\file` at top of the file, otherwise file will be ignored, examples:
```c
/** @file sketch_1.ino */
```

## 2.9. Tips and tricks
### 2.9.1. `millis()` overflow

Be careful when using time methods since they can overflow:
- `millis()` will overflow after _50 days_ approximately
- `micros` will overflow after _70 minutes_ approximately

> [!NOTE]
> Returned values of those methods are of type `unsigned long` which is **32 bits** value on those platforms.  
> So when on `((2^32) -1)`, value will restart from `0`.

The trick is to simply compare the **time difference** instead of comparing the **two times values**.

> [!TIP]
> More examples can be found at:
> - [Arduino Tutorial: Avoiding the Overflow Issue When Using millis() and micros()][thread-arduino-millis-overflow-1]
> - [Arduino StackExchange: How can I handle the millis() rollover ?][thread-arduino-millis-overflow-2]

### 2.9.2. Don't manage hardware in class constructors

For any class written, always provide a `setup()` method (alternative can be: `begin()`, `init()`, etc...).  
This is in this method that hardware operations will be managed: `pinMode()`, `digitalRead()`, etc... **Don't perform those operations in class constructors !**  
Constructor should be use for minimal configuration or to register pins needed, but setting those only in the `setup` method.  

This behaviour is because Arduino environment is set _just_ before calling the `setup()` method. So if an object is created before (like with a global object), operations from the contructor may not succeed (this is platform dependant).  
This is why Arduino documentation recommend to [always provide a setup() method to your classes][arduino-doc-library-guide]

## 2.10. Known issues
### 2.10.1. Linux - Snap installation
#### 2.10.1.1. Cannot find Arduino IDE

This problem is specific to **snap installation** and **VsCode environment**, it may appears this can of message error: _"Cannot find Arduino IDE. Please specify the 'arduino.path"_ even after [extension configuration][anchor-install-vscode]. To fix this issue, set those parameters in extension parameter:
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

#### 2.10.1.2. Unable to list board

This problem is specific to **snap installation**, it may be issues when listing boards (and sketch upload).  
Please refer to official documentation of [arduino-cli snap][arduino-cli-snap] which **clearly** explain what to do in this case.

Once, board list is working in command-line, you may not be able to use it under  **VsCode**, this issue hasn't been solved yet... this is why I don't use snap anymore.

<!-- Anchor of this file-->
[anchor-install-vscode]: #212-vscode
[anchor-issues-linux-snap]: #291-linux---snap-installation

<!-- Repository links -->
[repo-arduino-example-find-ascii]: arduino-example-find-ascii/
[repo-ide-vscode]: ../IDE/VsCode/
[repo-linux-bash-aliases-custom]: ../Linux/linux/custom_bash_aliases.md

<!-- External links ressources -->
[arduino-builtin-examples]: https://docs.arduino.cc/built-in-examples/
[arduino-builtin-example-blink]: https://docs.arduino.cc/built-in-examples/basics/Blink

[arduino-cli-official]: https://arduino.github.io/arduino-cli/latest/
[arduino-cli-snap]: https://snapcraft.io/arduino-cli

[arduino-doc-library-guide]: https://docs.arduino.cc/learn/contributions/arduino-creating-library-guide/

[arduino-due-store]: https://store.arduino.cc/arduino-due
[arduino-due-guide-new]: https://www.arduino.cc/en/Guide/ArduinoDue
[arduino-due-guide-old]: https://web.archive.org/web/20210723193416/https://www.arduino.cc/en/Guide/ArduinoDue
[arduino-due-datasheet]: http://www.atmel.com/Images/Atmel-11057-32-bit-Cortex-M3-Microcontroller-SAM3X-SAM3A_Datasheet.pdf

[arduino-ide]: https://www.arduino.cc/en/software

[arduino-lib-install-official]: https://docs.arduino.cc/software/ide-v1/tutorials/installing-libraries
[arduino-lib-references]: https://www.arduino.cc/reference/en/libraries/

[arduino-troubleshooting-linux-port-access]: https://support.arduino.cc/hc/en-us/articles/360016495679-Fix-port-access-on-Linux

[arduino-vscode-extension]: https://marketplace.visualstudio.com/items?itemName=vscode-arduino.vscode-arduino-community
[arduino-vscode-extension-issues-1346]: https://github.com/microsoft/vscode-arduino/issues/1346
[arduino-vscode-extension-issues-1346-resolve]: https://github.com/microsoft/vscode-arduino/issues/1346#issuecomment-996972001

[doxygen-official]: https://doxygen.nl/index.html

[thread-arduino-millis-overflow-1]: https://www.norwegiancreations.com/2018/10/arduino-tutorial-avoiding-the-overflow-issue-when-using-millis-and-micros/
[thread-arduino-millis-overflow-2]: https://arduino.stackexchange.com/questions/12587/how-can-i-handle-the-millis-rollover