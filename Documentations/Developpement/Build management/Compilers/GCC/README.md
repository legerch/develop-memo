**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. GCC Options](#2-gcc-options)
  - [2.1. Detailled useful warnings options](#21-detailled-useful-warnings-options)
  - [2.2. Detailled useful optimization options](#22-detailled-useful-optimization-options)
- [3. GCC Attributes](#3-gcc-attributes)
- [4. GCC Version](#4-gcc-version)
- [5. GCC extensions](#5-gcc-extensions)
  - [5.1. POSIX extensions](#51-posix-extensions)
    - [5.1.1. Details](#511-details)
    - [5.1.2. GCC support](#512-gcc-support)
  - [5.2. GNU extensions](#52-gnu-extensions)
- [6. Build project with GCC](#6-build-project-with-gcc)
- [7. Ressources](#7-ressources)

# 1. Introduction

Official GCC documentation can be found here : [GCC documentation][gcc-doc-home].  
> Note than a custom header for compiler attributes is available at [Compilers/custom_compiler.h][repo-compilers-custom-header]

# 2. GCC Options
## 2.1. Detailled useful warnings options

List of warnings options to look at, official documentation can be found at [Warning options][gcc-doc-warnings]:
- `-Wall`  
This enables all the warnings about constructions that some users consider questionable, and that are easy to avoid (or modify to prevent the warning), even in conjunction with macros. See official documentation for detailled list of enabled warnings.

- `-Wextra`  
This enables some extra warning flags that are not enabled by `-Wall`. (This option used to be called `-W`. The older name is still supported, but the newer name is more descriptive.). See official documentation for detailled list of enabled warnings.

- `-Werror`   
Make all warnings into errors.

- `-Werror=`  
Make the specified warning into an error. The specifier for a warning is appended; for example `-Werror=switch` turns the warnings controlled by `-Wswitch` into errors.

- `-Wreturn-type`  
Warn about any return statement with no return value in a function whose return type is not void (falling off the end of the function body is considered returning without a value). This warning is enabled by `-Wall`

- `-Wimplicit-function-declaration`  
This option controls warnings when a function is used before being declared. This warning is enabled by default in C99 and later dialects of C, and also by -Wall

- `-Wstrict-prototypes`  
This option is only available for C and Objective-C : warn if a function is declared or defined without specifying the argument types.  
In C, function without argument are equivalent to : `void myFynction(...)`. This means that function can take any parameter, that can lead to an unepected behaviour... To actually set to non-arg function, used `void myFunction(void)`.  
In C++, a function without specify argument is implicitely convert to `void myFunction(void)` because C++ doesn't allow function without specified argument type.

- `-Wimplicit-fallthrough`  
Warn when a switch case falls through (a case doesn't have `break` keyword). This warning is enabled by `-Wextra`.

- `-Wshadow`  
Warn whenever a local variable or type declaration shadows another variable, parameter, type, class member (in C++), or instance variable (in Objective-C) or whenever a built-in function is shadowed.
    > Example : local variable had same name as a global variable

- `-Wformat=2`  
By default, `-Wall` enables `-Wformat`, which is equivalent to using `-Wformat=1`. Increasing level verification can help to catch others issues.

- `-Wlogical-op`  
Warn when a logical operator is suspiciously always evaluating to true or false.

- `-Wduplicated-cond`  
Warn about duplicated conditions in an if-else-if chain.

- `-Wduplicated-branches`  
Warn about duplicated branches in if-else statements.

- `-pedantic`  
Issue all the warnings demanded by strict ISO C and ISO C++; reject all programs that use forbidden extensions, and some other programs that do not follow ISO C and ISO C++. For ISO C, follows the version of the ISO C standard specified by any -std option used.  
In absence of -pedantic, even when a specific standard is requested, GCC will still allow some extensions that are not acceptable in the C standard.
    > See this thread for more info : [thread-so-purpose-of-using-pedantic]

- `-ansi`  
This option refers to _1989 ANSI C Standard_ (or equivalently the _1990 ISO C standard_). This option is **obsolete** and if _1989 ANSI C Standard_ is required in a program, use `-std=c89` instead (they both do same thing, but using option `-std=` is prefered instead of `-ansi`).
    > **Note :** In C++, `-ansi` is equivalent to `-std=c++98`

- `-std=`  
Refer to official documentation for more information about this option : [GCC dialect option][gcc-doc-dialects].  
Standard value can be found at : [GCC Standard][gcc-doc-standards]
    > Currently (05/2021), `-std=` default value is :
    > - **C** : `-std=gnu17`
    > - **C++** : `-std=gnu++17`

**All warnings options** had a negative flag used to disable them of form : `-Wno-concerned-warning`.  
> Examples : `-Wno-format`, `-Wno-missing-braces`, `-Wno-unused-variable`, `-Wno-ignored-qualifiers`, etc...

## 2.2. Detailled useful optimization options

List of optimizations options to look at, official documentation can be found at [Optimization options][gcc-doc-optimizations]:
- `-O0`  
**Default optimization option**, reduce compilation time and make debugging produce the expected results.

- `-O<level>`  
Optimization for speed from level 1 to 3, please don't use level 3 `-O3` which is known for being "instable" (code must be very well written to be correctly optimize because optimisation applied are aggressive, also can have "inverse effect" due to heavy binaries which gonna use more memory, see documentation for more details).  
Consider `-O2` like maximum level. 
    > See also [Linux kernel contributors are against `-O3` flag in the project][news-phoronix-linux-kernel-against-o3-flag].

- `-Os`  
Optimize for size. `-Os` enables all `-O2` optimizations except those that often increase code size.

**Warning :** Please refer to doc before using non-default optimization flags. For example, with flag `-O2` (and `-Os` by extension), option `-fno-gcse` must be used for programs using GCC extension **Computed goto** ([official doc][gcc-doc-computed-goto] and [tutorial][tutorial-greenplace-computed-goto])

# 3. GCC Attributes

GCC also provides somes attributes used for example to disable a warning in this specific case, that tells to the compiler "this is the expected behaviour, don't warn about it", sometimes it can also make optimisation (it's the case for unused variables for example).  
Useful attributes (they are defined as macro here to be easily portable with another compiler):

- **Unused function**
```C
#define COMPILER_FCT_UNUSED __attribute__((unused))

// This can be used like (in  .c file):
static int COMPILER_FCT_UNUSED myUnusedFunction(void){}
```

- **Deprecated function** : can be useful to easily tell to developers who used yout library that this function is now deprecated, warning `-Wdeprecated-declarations` will be thrown.
```C
#define COMPILER_FCT_DEPRECATED __attribute__((deprecated))

// This can be used like (in  .c file):
static int COMPILER_FCT_DEPRECATED myDeprecatedFunction(void){}
```

- **Unused variable**
```C
#define COMPILER_VAR_UNUSED __attribute__((unused))

// This can be used like (in  .c file):
static void myFunction(int COMPILER_VAR_UNUSED intArgNotUsed){}
```

- **Deprecated variable** : can be useful on global/extern variables that are now deprecated.
```C
#define COMPILER_VAR_DEPRECATED __attribute__((deprecated))

// This can be used like :
extern int old_var COMPILER_VAR_DEPRECATED;
int new_fn() { return old_var; }
```
> Warning will be thrown for function `new_fn()`.

- **Implicit fallthrough** : Since there are occasions where a switch case fall through is desirable, GCC provides an attribute, `__attribute__ ((fallthrough))`, that is to be used along with a null statement to suppress this warning that would normally occur.
```C
#define COMPILER_FALLTHROUGH __attribute__((fallthrough))

// This can be used like :
switch(cond)
{
    case 1:
        bar(0);
        COMPILER_FALLTHROUGH;
    default:
    …
}
```

> All describes attributes can be found at :
> - [GCC function attributes][gcc-doc-functions-attributes]
> - [GCC variables attributes][gcc-doc-variables-attributes]
> - [GCC implicit-fallthrough warning and attribute][gcc-doc-warnings-implicit-fallthrough]
  
# 4. GCC Version

GCC provide somes predefined macros ([GCC common predefined macros][gcc-doc-common-predefined-macros]). Here we gonna take a look at _version macro_.

```C
/* Compute GCC version at compilation time */
#define GCC_VERSION (__GNUC__ * 10000         \
                       + __GNUC_MINOR__ * 100 \
                       + __GNUC_PATCHLEVEL__)

/* Test target GCC version */
#if GCC_VERSION < 30200
# error "Please use a GCC version superior or equal to 3.2.0"
#endif

#if GCC_VERSION == 50301
# error "GCC version 5.3.1 not compatible with project"
#endif
```

# 5. GCC extensions

For reference, you can find detailled documentation of all extensions quote below at [manpage - feature_test_macros][manpage-feature-test-macros]

## 5.1. POSIX extensions
### 5.1.1. Details

_POSIX extensions_ allows you to use functions that are not part of the standard C library but are part of the [POSIX standard][wiki-posix-standard].  
If your application/library need POSIX extension, define macro `_POSIX_C_SOURCE` (`_POSIX_SOURCE` is obsolete) at the needed version.  
Example:
```c
#define _POSIX_C_SOURCE 200809L
```
> Note than this is better to define this macro in your build system (_Makefile_, _CMake_). If part of your project need those extensions, then your entire project need it...

### 5.1.2. GCC support

By default, **GCC** use `-std=gnu<std_version>` which enable **POSIX extensions** (_gnu_ part set it), you can easily verify this by printing `_POSIX_C_SOURCE` value:
```c
printf("POSIX standard used: %ld\n", _POSIX_C_SOURCE)
```
> So, if using `-sdt=gnu<std_version>`, you don't even need to define this macro yourself!

In order to disable this extension, you need to use options:
- `-std=<std_version>`: Set to a C standard (note the missing _gnu_)
- `-pedantic`: Issue all the warnings demanded by strict ISO C and ISO C++

## 5.2. GNU extensions

_GNU extensions_ can be useful for **GNU and/or Linux** specific stuff support.  

In order to enable this extension, you must:
1. Set build option `-std=gnu<std_version>` (with _gnu_ part): this will enable part of GNU extension
2. Define macro `_GNU_SOURCE` in your build system (makefile, cmake, etc...): This will enable all GNU extension features

# 6. Build project with GCC

An example of GCC flags than can be used to build a project:
```shell
CFLAGS_WARNING			:=	-Wall -Wextra -Werror=format -Werror=return-type -Werror=implicit-function-declaration \
							-Wformat=2 -Wstrict-prototypes -Wshadow \
							-Wlogical-op -Wduplicated-cond -Wduplicated-branches \
							-Wno-ignored-qualifiers  \
							\
							-fdiagnostics-color=auto # -Werror -W -ansi -pedantic

# For arch x64/x86
CFLAGS_OPTIMIZATION = -O2

# For embedded devices
CFLAGS_OPTIMIZATION = -Os
```

This means:
- Enable all warnings and extra warnings
- `-Wreturn-type` and `-Wimplicit-function-declaration` must be considered as errors. 
- Some warnings has been added: `-Wstrict-prototypes` and `-Wshadow`.  
- Warning `-Wignored-qualifiers` is disable (was added by `-Wextra`) because this warning is only useful in C++ (it is available in C for library wrote in C compatible in C++ for example).
> `-pedantic` is not enabled, but it could be useful if you want to stick to standard C (without _POSIX_ or _GNU_ extensions)

For more details on _"how to build a project"_, see [Makefile tutorial][repo-makefile] which provide multiple examples.

# 7. Ressources

- Official documentation
  - [GCC options documentation][gcc-doc-home]
  - [GCC dialect option][gcc-doc-dialects]
  - [GCC Standard][gcc-doc-standards]
  - [GCC Warnings][gcc-doc-warnings]
  - [GCC common predefined macros][gcc-doc-common-predefined-macros]
  - [GCC function attributes][gcc-doc-functions-attributes]
  - [GCC variables attributes][gcc-doc-variables-attributes]
  - [GCC implicit-fallthrough warning and attribute][gcc-doc-warnings-implicit-fallthrough]
  - [GCC optimization options][gcc-doc-optimizations]
  - [GCC computed goto][gcc-doc-computed-goto]
- Extensions
  - [Manpage - Features test macros][manpage-feature-test-macros]
  - [POSIX standards][wiki-posix-standard]
  - [POXIX macro][thread-so-posix-extension-macro]
  - [Disable GCC GNU (and POSIX) extensions][thread-so-disable-extensions]
- Interesting articles :
  - [`Werror` is not your friend][article-embeddedartitry-werror-is-not-your-friend]
  - [The Best and Worst GCC Compiler Flags For Embedded][article-interruptmemfault-best-worst-compiler-flags-embedded]
  - [Airbus - Getting the maximum of your C compiler, for security][article-airbus-compiler-security-gcc]
  - [Upstream Linux Developers Against "-O3" Optimizing The Kernel][news-phoronix-linux-kernel-against-o3-flag]
- Tutorials
  - [Build shared and static libraries][tutorial-edu-c-libs]
  - [Computed goto for efficient dispatch tables][tutorial-greenplace-computed-goto]
- Thread
  - [thread-so--wimplicit-fallthrough-warnings-and-portable-way-to-clear-them]
  - [thread-so-purpose-of-using-pedantic]

<!-- Links of this repository -->
[repo-compilers-custom-header]: ../custom_compiler.h
[repo-makefile]: ../../Build%20systems/MakeFile/

<!-- Links to external ressources -->
[gcc-doc-home]: https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html

[gcc-doc-common-predefined-macros]: https://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html
[gcc-doc-computed-goto]: https://gcc.gnu.org/onlinedocs/gcc/Labels-as-Values.html
[gcc-doc-dialects]: https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html
[gcc-doc-functions-attributes]: https://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html
[gcc-doc-optimizations]: https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
[gcc-doc-standards]: https://gcc.gnu.org/onlinedocs/gcc/Standards.html#Standards
[gcc-doc-variables-attributes]: https://gcc.gnu.org/onlinedocs/gcc/Variable-Attributes.html
[gcc-doc-warnings]: https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
[gcc-doc-warnings-implicit-fallthrough]: https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wimplicit-fallthrough

[article-embeddedartitry-werror-is-not-your-friend]: https://embeddedartistry.com/blog/2017/05/22/werror-is-not-your-friend/
[article-interruptmemfault-best-worst-compiler-flags-embedded]: https://interrupt.memfault.com/blog/best-and-worst-gcc-clang-compiler-flags
[article-airbus-compiler-security-gcc]: https://airbus-seclab.github.io/c-compiler-security/gcc_compilation.html
[news-phoronix-linux-kernel-against-o3-flag]: https://www.phoronix.com/scan.php?page=news_item&px=Linux-Upstream-Against-O3-Kern

[thread-so-purpose-of-using-pedantic]: https://stackoverflow.com/questions/2855121/what-is-the-purpose-of-using-pedantic-in-gcc-g-compiler/40580407
[thread-so--wimplicit-fallthrough-warnings-and-portable-way-to-clear-them]: https://stackoverflow.com/questions/45129741/gcc-7-wimplicit-fallthrough-warnings-and-portable-way-to-clear-them
[thread-so-posix-extension-macro]: https://stackoverflow.com/questions/48332332/what-does-define-posix-source-mean
[thread-so-disable-extensions]: https://stackoverflow.com/questions/38939991/how-to-disable-gnu-c-extensions

[tutorial-greenplace-computed-goto]: https://eli.thegreenplace.net/2012/07/12/computed-goto-for-efficient-dispatch-tables
[tutorial-edu-c-libs]: https://docencia.ac.upc.edu/FIB/USO/Bibliografia/unix-c-libraries.html

[manpage-feature-test-macros]: https://man7.org/linux/man-pages/man7/feature_test_macros.7.html

[wiki-posix-standard]: https://en.wikipedia.org/wiki/POSIX