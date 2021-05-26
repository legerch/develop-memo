**Table of contents :**
- [1. Introduction](#1-introduction)
- [2. GCC Options](#2-gcc-options)
  - [2.1. Detailled useful warnings options](#21-detailled-useful-warnings-options)
  - [2.2. GCC options line to use in Cobra Project](#22-gcc-options-line-to-use-in-cobra-project)
- [3. GCC Attributes](#3-gcc-attributes)
- [4. GCC Version](#4-gcc-version)
- [5. Links](#5-links)

# 1. Introduction

Official GCC documentation can be found here : [GCC documentation](https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html)

# 2. GCC Options
## 2.1. Detailled useful warnings options

List of warnings options to look at, official documentation can be found at [Warning options](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html) :
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

- `-pedantic`  
Issue all the warnings demanded by strict ISO C and ISO C++; reject all programs that use forbidden extensions, and some other programs that do not follow ISO C and ISO C++. For ISO C, follows the version of the ISO C standard specified by any -std option used.  
In absence of -pedantic, even when a specific standard is requested, GCC will still allow some extensions that are not acceptable in the C standard.
    > See this thread for more info : https://stackoverflow.com/questions/2855121/what-is-the-purpose-of-using-pedantic-in-gcc-g-compiler/40580407

- `-ansi`  
This option refers to _1989 ANSI C Standard_ (or equivalently the _1990 ISO C standard_). This option is **obsolete** and if _1989 ANSI C Standard_ is required in a program, use `-std=c89` instead (they both do same thing, but using option `-std=` is prefered instead of `-ansi`).
    > **Note :** In C++, `-ansi` is equivalent to `-std=c++98`

- `-std=`  
Refer to official documnetation for more information about this option : [GCC dialect option](https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html).  
Standard value can be found at : [GCC Standard](https://gcc.gnu.org/onlinedocs/gcc/Standards.html#Standards)
    > Currently (05/2021), `-std=` default value is :
    > - **C** : `-std=gnu17`
    > - **C++** : `-std=gnu++17`

**All warnings options** had a negative flag used to disable them of form : `-Wno-concerned-warning`.  
> Examples : `-Wno-format`, `-Wno-missing-braces`, `-Wno-unused-variable`, `-Wno-ignored-qualifiers`, etc...

## 2.2. GCC options line to use in Cobra Project

```shell
EXTRA_CFLAGS  = -Wall -Wextra -Werror=format -Werror=return-type -Werror=implicit-function-declaration \
				-Wstrict-prototypes -Wshadow \
				-Wno-ignored-qualifiers
```

This means we enables all warnings, `-Wreturn-type` and `-Wimplicit-function-declaration` must be considered as errors. Plus, we added 2 more warnings : `-Wstrict-prototypes` and `-Wshadow`.  
Warning `-Wignored-qualifiers` is disable (was added by `-Wextra`) because this warning is only useful in C++ (it is available in C for library wrote in C compatible in C++ for example).
> `-pedantic` is not enable, but it could be useful !

# 3. GCC Attributes

GCC also provides somes attributes used for example to disable a warning in this specific case, that tells to the compiler "this is the expected behaviour, don't warn about it", sometimes it can also make optimisation (it's the case for unused variables for example).  
Useful attributes (they are defined as macro here to be easily portable with another compiler) :
- **Unused function**
```C
#define COMPILER_FCT_UNUSED __attribute__((unused))

// This can be used like (in .cpp file):
static int COMPILER_FCT_UNUSED myUnusedFunction(void){}
```

- **Deprecated function** : can be useful to easily tell to developers who used yout library that this function is now deprecated, warning `-Wdeprecated-declarations` will be thrown.
```C
#define COMPILER_FCT_DEPRECATED __attribute__((deprecated))

// This can be used like (in .cpp file):
static int COMPILER_FCT_DEPRECATED myDeprecatedFunction(void){}
```

- **Unused variable**
```C
#define COMPILER_VAR_UNUSED __attribute__((unused))

// This can be used like (in .cpp file):
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
> - [GCC function attributes](https://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html)
> - [GCC variables attributes](https://gcc.gnu.org/onlinedocs/gcc/Variable-Attributes.html)
> - [GCC implicit-fallthrough warning and attribute](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wimplicit-fallthrough)
  
# 4. GCC Version

GCC provide somes predefined macros ([GCC common predefined macros](https://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html)). Here we gonna take a look at _version macro_.

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

# 5. Links

- Official documentation
  - [GCC options documentation](https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html)
  - [GCC dialect option](https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html)
  - [GCC Standard](https://gcc.gnu.org/onlinedocs/gcc/Standards.html#Standards)
  - [GCC common predefined macros](https://gcc.gnu.org/onlinedocs/cpp/Common-Predefined-Macros.html)
  - [GCC function attributes](https://gcc.gnu.org/onlinedocs/gcc/Function-Attributes.html)
  - [GCC variables attributes](https://gcc.gnu.org/onlinedocs/gcc/Variable-Attributes.html)
  - [GCC implicit-fallthrough warning and attribute](https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wimplicit-fallthrough)
- Interessant articles :
  - [`Werror` is not your friend](https://embeddedartistry.com/blog/2017/05/22/werror-is-not-your-friend/)
- Thread
  - https://stackoverflow.com/questions/45129741/gcc-7-wimplicit-fallthrough-warnings-and-portable-way-to-clear-them