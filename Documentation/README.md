A small memo on how to manage documentation of projects using [Doxygen][doxy-home].

**Table of contents :**
- [1. Installation](#1-installation)
- [2. Project configuration](#2-project-configuration)
  - [2.1. Generic projects](#21-generic-projects)
  - [2.2. Arduino projects](#22-arduino-projects)
- [3. Document the code](#3-document-the-code)
  - [3.1. How to ?](#31-how-to-)
  - [3.2. Specific behaviour](#32-specific-behaviour)
- [4. Generate documentation](#4-generate-documentation)
  - [4.1. Locally](#41-locally)
  - [4.2. Online](#42-online)
  - [4.3. Manage _public API_ and _internal_ documentation](#43-manage-public-api-and-internal-documentation)
    - [4.3.1. Using fragments](#431-using-fragments)
    - [4.3.2. Using conditions](#432-using-conditions)
- [5. Customization](#5-customization)

# 1. Installation

[Doxygen][doxy-home] can be downloaded at [download section][doxy-dl].  
On Linux distro, you can also use:
```shell
sudo apt install doxygen doxygen-gui doxygen-doc
```
> This will install:
> - Doxygen binaries
> - Doxygen GUI called _Doxywizard_

# 2. Project configuration

Once [Doxygen][doxy-home] is installed, you must create a **Doxyfile** associated to the project we want to document.  
_Doxyfile_ contains all configuration used to generate documentation of the project.  
> Also note that _Doxygen_ also provide [a way][doxy-usage] to update your _Doxyfile_ to a new version easily

## 2.1. Generic projects

Below, a simple reminder of options that are generally useful when configuring a **Doxyfile** for a new project:
- Project :
  - `PROJECT_NAME`
  - `PROJECT_BRIEF`
  - `PROJECT_LOGO`
  - `OUTPUT_DIRECTORY` (example: `docs`)
  - `OPTIMIZE_OUTPUT_FOR_<language_name>`
  - `MARKDOWN_SUPPORT`: Set to enable it
- Input :
  - `INPUT`: Directory or files used as input by Doxygen (example : `src`, `lib`, `doc-mainpage.md`) 
  - `USE_MDFILE_AS_MAINPAGE` (example: `doc-mainpage.md` or `README.md`)
  - `RECURSIVE`: Set the value according to the current project
  - `EXCLUDE`: Set the value according to the current project, this can be external libs for example
  - `EXAMPLE_PATH`: Directory or files to use for examples that can be used with `\include` Doxygen command when writing doxumentation (example: `docs/examples/`)
  - `EXAMPLE_PATTERNS`: (example: `*.cpp *.h`)
  - `IMAGE_PATH`
- `GENERATE_HTML`: Set to enable it 
- Disable generation of: Latex, RTF, Man, XML, Docbook, AutoGen, PerlMod
- Preprocessor:
  - `ENABLE_PREPROCESSING`: Set to enable it (if some code depends to an `ifdef`, this can be useful to add a condition for Doxygen to document it. Doxygen automatically define the macro `DOXYGEN`)
- Dot:
  - `CLASS_DIAGRAMS` : Set to enable it
  - `HAVE_DOT` : Set the value according to the project (you and team members of the project must have **Dot** utility installed on their system to set this value to `true`)

## 2.2. Arduino projects

For Arduino projects, please refer to [Arduino tutorial][tutorial-arduino] for more details.

# 3. Document the code
## 3.1. How to ?

See [Doxygen - Special commands][doxy-commands] for more details.

## 3.2. Specific behaviour

We have previously see that Doxygen define a macro named `DOXYGEN`. This macro will be useful to generate documentation of specific code (like OS function for example).  
Example on how to use:
```cpp
#if defined(WIN32) || defined(DOXYGEN)
static WlanBssType convertBssTypeFromWinApi(DOT11_BSS_TYPE apiBssType);
static WlanAuthAlgorithm convertAuthAlgorithmFromWinApi(DOT11_AUTH_ALGORITHM apiAuthAlgorithm);
static WlanCipherAlgorithm convertCipherAlgorithmFromWinApi(DOT11_CIPHER_ALGORITHM apiCipherAlgorithm);
#endif
```

In this example, those methods are only available for Windows OS but we need to generate documentation for those methods. If we are using a Linux system (like with a server) to generate our documentation, documentation will not be available... So, this is why we need to define this macro for Doxygen.  

Then, when you provide documentation for the concerned method, you can add doxygen `\warning` command :
```cpp
/*!
 * \brief Converts a Windows \b DOT11_BSS_TYPE type to WlanTypeDefs::WlanBssType.
 *
 * \param[in] apiBssType
 * Windows wlan BSS type to convert
 *
 * \warning
 * This function is only for Windows platforms.
 *
 * \return
 * Return associated WlanTypeDefs::WlanBssType
 */
WlanTypeDefs::WlanBssType WlanTypeDefs::convertBssTypeFromWinApi(DOT11_BSS_TYPE apiBssType){...}
```

# 4. Generate documentation
## 4.1. Locally

To generate documentation locally, this is really easy:
```shell
# Run documentation generation
doxygen ./Doxyfile

# Under Windows, maybe doxygen is not added to the $PATH
"C:\Program Files\doxygen\bin\doxygen.exe" ./Doxyfile
```

> [!TIP]
> You can also load the _Doxyfile_ into _Doxywizard_ (Doxygen GUI) and run generation.

## 4.2. Online

An easy way to automatically generate documentation and hosting it is to use **Continuous Integration/Development tools**, please see dedicated [CI/CD tutorial][tutorial-cicd] to know how to deploy it. 

## 4.3. Manage _public API_ and _internal_ documentation

We have multiple ways to manage documentation generation to manage _public API documentation_ and _internal API documentation_.

### 4.3.1. Using fragments

**Doxygen** allow to include an other _Doxyfile_ into it via `@INCLUDE` command.  
We can define a `Doxyfile-common.in` fragment which will contains most _Doxygen_ configuration and then have a _Doxyfile fragment_ for each type of documentation to generate (which will include the _common part_):
- `Doxyfile-internal.in`
- `Doxyfile-public-api.in`

> [!TIP]
> Example of this are available in the [docs fragment][docs-fragments] folder

> [!NOTE]
> We could go further and automatically fill those _Doxyfile files_ (specially the `INPUT` part) via the _build system (like CMake_) or via a _python script_ for example.  
> Library [libcamera][libcamera-home] recently [used this solution][libcamera-patch-doc] to separate internal and public API

### 4.3.2. Using conditions

We can also use [condition][doxy-cmd-cond] command in order to enable/disable sections according to each kind of documentation to generate.  
For example, in our custom class, we can use:
```cpp
/*!
 * \cond INTERNAL
 */

/*!
 * \brief My custom class with a brief description
 * \details
 * Add details to the usage of this class
 */
class MyClass
{
public:
    ...
};

/*!
 * \endcond
 */
```

Then, we can enable/disable section simply by using `ENABLED_SECTIONS` configuration option. For our example, we will add section `INTERNAL` in order to generate documentation for our custom class.

> [!NOTE]
> Note that if your configuration include all files, those conditions must appears for your _headers_ **and** _sources_ files.

# 5. Customization

Generated Doxygen documentation can feel..._outdated!_ I can only recommend the [Doxygen Awesome CSS][doxy-theme-awesome] theme which provide a more modern look to the generated documentation, [highly configurable][doxy-theme-awesome-cfg] and which also provide some really useful [extensions][doxy-theme-awesome-extensions].

<!-- Repository links -->
[docs-fragments]: fragments/

[tutorial-arduino]: ../Arduino/
[tutorial-cicd]: ../CI_CD/

<!-- External links -->
[doxy-home]: https://www.doxygen.nl/index.html
[doxy-dl]: https://www.doxygen.nl/download.html
[doxy-commands]: https://www.doxygen.nl/manual/commands.html
[doxy-cmd-cond]: https://www.doxygen.nl/manual/commands.html#cmdcond
[doxy-usage]: https://www.doxygen.nl/manual/doxygen_usage.html

[doxy-theme-awesome]: https://github.com/jothepro/doxygen-awesome-css
[doxy-theme-awesome-cfg]: https://jothepro.github.io/doxygen-awesome-css/md_docs_2customization.html
[doxy-theme-awesome-extensions]: https://jothepro.github.io/doxygen-awesome-css/md_docs_2extensions.html

[libcamera-home]: https://libcamera.org/
[libcamera-patch-doc]: https://git.libcamera.org/libcamera/libcamera.git/commit/?id=7dc38adcb5b59f5347fcfbcc8b5df261eda704a1