This file will describe how to manage compiler diagnostic directly in source code, not in make (or any others build system) instructions

**Table of contents:**
- [1. Pragma diagnostic](#1-pragma-diagnostic)
- [2. Custom macros](#2-custom-macros)
- [3. Ressources used](#3-ressources-used)

# 1. Pragma diagnostic

In order to disable (or enable) compiler warnings directly in source code, you can use `#pragma` instructions. This can be useful specially when working with external source file. Otherwise if you want to silent warnings from your own code, just fix it or disable it from your build filesystem...  

Pragma instructions will vary according to each compiler ! Main compiler documentation can be found at:
- [GCC][pragma-diag-gcc]
- [Clang][pragma-diag-clang]
- [MSVC][pragma-diag-msvc]

Thankfully, behaviour is pretty much the same whatever compiler used, you always need:
- **push** instruction: This will save current state of compiler diagnostic
- **error/ignore** instructions: Allow to declare a warning as an error or to ignore a warning
- **pop** instruction: Restore latest state saved with **push** instruction

For example, with _GCC_:
```c
#pragma GCC diagnostic push

#pragma GCC diagnostic ignored "-Wuninitialized"
#include "external-header.h"    // No warning "-Wuninitialized" for this one

#pragma GCC diagnostic pop
```

In order to make portable code, it will be better to add custom macros, according to each compiler, for each pragma intructions. You cannot use `#pragma` instruction directly in a `#define` but _C99 standard_ introduced `_Pragma` to manage this special case. Even in non-C99 mode, most compilers support `_Pragma`...except...**MSVC** which has its own `__pragma` keyword with a different syntax. The standard `_Pragma` takes a string, Microsoft's version doesn't:
```c
#if defined(_MSC_VER)
#  define PRAGMA_FOO __pragma(foo)
#else
#  define PRAGMA_FOO _Pragma("foo")

PRAGMA_FOO  // Once processed, will be roughly equivalent to: `#pragma foo`
#endif
```

# 2. Custom macros

In order to make portable code, I added my custom macros in [custom_compiler.h][repo-header-compiler]

# 3. Ressources used

- Compiler documentation:
  - [GCC pragma][pragma-diag-gcc]
  - [Clang pragma][pragma-diag-clang]
  - [MSVC pragma][pragma-diag-msvc]
- Threads:
  - https://stackoverflow.com/questions/3378560/how-to-disable-gcc-warnings-for-a-few-lines-of-code
  - https://stackoverflow.com/questions/6321839/how-to-disable-warnings-for-particular-include-files
  - https://stackoverflow.com/questions/965093/selectively-disable-gcc-warnings-for-only-part-of-a-translation-unit
- Library:
  - [Hedley][lib-hedley]: A C/C++ header to help move `#ifdefs` out of your code

<!-- Repository links -->
[repo-header-compiler]: custom_compiler.h

<!-- External links -->
[lib-hedley]: https://github.com/nemequ/hedley

[pragma-diag-gcc]: https://gcc.gnu.org/onlinedocs/gcc/Diagnostic-Pragmas.html
[pragma-diag-clang]: https://clang.llvm.org/docs/UsersManual.html#controlling-diagnostics-via-pragmas
[pragma-diag-msvc]: https://learn.microsoft.com/en-us/cpp/preprocessor/warning?redirectedfrom=MSDN&view=msvc-170