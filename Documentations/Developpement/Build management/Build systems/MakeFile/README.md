**Table of contents:**

- [1. Introduction](#1-introduction)
- [2. Makefile syntax](#2-makefile-syntax)
- [3. Template for a simple case](#3-template-for-a-simple-case)
  - [3.1. Build an application](#31-build-an-application)
- [4. Custom template for large project](#4-custom-template-for-large-project)

# 1. Introduction

Project build is supposed to be structured as:
```shell
bin/  
include/  
obj/  
src/  
Makefile  
```
> Detailled compilers usage can be found at [compiler documentation][repo-doc-compilers]

# 2. Makefile syntax

Be careful when using **Makefile** syntax, _tab_ characters and _spaces_ have different meaning !
> See this [stackoverflow thread][thread-so-makefile-space-or-tab] for more details

See [makefile cheatsheet][repo-makefile-cheatsheet] for more details

# 3. Template for a simple case
## 3.1. Build an application

```make
# ------------------------------------------------
# Generic Makefile
# Date : 19/10/2020
#
# Memo debug Makefile :
# From https://www.gnu.org/software/make/manual/make.html#Make-Control-Functions
# $(error   VAR is $(VAR))
# $(warning VAR is $(VAR))
# $(info    VAR is $(VAR))
# ------------------------------------------------

# Project configuration
TARGET  := appName

DIR_SRC := src
DIR_HDR := include
DIR_OBJ := obj
DIR_BIN := bin

# Build configuration
ifeq ($(ARCH), arm)
	CCPREFIX        := arm-linux-gnueabihf-
	CFLAGS_TARGET   := -DMY_CUSTOM_MACRO
else
	CCPREFIX        :=
	CFLAGS_TARGET   := 
endif

# Compilation configuration
CC      := $(CCPREFIX)gcc
CFLAGS  := -std=c11 -Wall -I$(DIR_HDR) $(CFLAGS_TARGET)

# linking flags here
LDFLAGS := -lm
LFLAGS  := -Wall -I$(DIR_HDR) $(LDFLAGS)

# Get all files
SOURCES := $(wildcard $(DIR_SRC)/*.c)
OBJECTS := $(SOURCES:$(DIR_SRC)/%.c=$(DIR_OBJ)/%.o)
CMD_RM  := rm -f

# Commands
$(DIR_BIN)/$(TARGET): $(OBJECTS)
	@$(CC) $(OBJECTS) $(LFLAGS) -o $@
	@echo "Linking complete!"

$(OBJECTS): $(DIR_OBJ)/%.o : $(DIR_SRC)/%.c
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully! ($(CC))"

.PHONY: clean
clean:
	@$(CMD_RM) $(OBJECTS)
	@echo "Cleanup complete!"

.PHONY: mrproper
mrproper: clean
	@$(CMD_RM) $(DIR_BIN)/$(TARGET)
	@echo "Executable removed!"
```

# 4. Custom template for large project

For some projects, it can be useful to have a **base** makefile to include in your application or library makefile, this allow to reduce makefile duplication and only set the differences.  
Those templates also allow to manage different boards instructions.

Templates here are based of project following this structure:
```shell
.
├── 01-makefile/
│   ├── app.make
│   ├── base.make
│   ├── lib.make
│   ├── sub.make
│   └── test.make
├── 02-common/
│   └── include/
│       ├── common_header1.h
│       ├── common_header2.h
├── 03-libs/
│   ├── custom_lib1/
│   │   ├── apps/
│   │   │   ├── bin/
│   │   │   ├── include/
│   │   │   │   └── app_custom_lib1.h
│   │   │   ├── Makefile
│   │   │   ├── obj/
│   │   │   └── src
│   │   │       └── app_custom_lib1.c
│   │   ├── bin/
│   │   ├── include/
│   │   │   └── custom_lib1.h
│   │   ├── Makefile
│   │   ├── obj/
│   │   └── src
│   │       └── custom_lib1.c
│   ├── custom_lib2/
│   │   ├── bin/
│   │   ├── include/
│   │   │   └── custom_lib2.h
│   │   ├── Makefile
│   │   ├── obj/
│   │   ├── src/
│   │   │   └── custom_lib2.c
│   │   └── tests/
│   │       ├── bin/
│   │       ├── include
│   │       │   └── test_custom_lib2.h
│   │       ├── Makefile
│   │       ├── obj/
│   │       └── src/
│   │           └── test_custom_lib2.c
│   ├── Makefile
│   ├── libs/
│   │   ├── board_arduino/
│   │   └── board_raspberry/
├── 04-apps/
│   ├── 02-custom_app1/
│   │   ├── bin/
│   │   ├── include/
│   │   │   ├── custom_app1.h
│   │   │   ├── custom_app1_other_header.h
│   │   │   ├── ...
│   │   ├── Makefile
│   │   ├── obj/
│   │   └── src/
│   │       ├── custom_app1.c
│   │   │   ├── custom_app1_other_header.c
│   │   │   ├── ...
│   ├── apps/
│   │   ├── board_arduino/
│   │   └── board_raspberry/
│   └── Makefile

```

Templates are available in [templates/][repo-makefile-templates] directory of this documentation:
- [base.make][repo-makefile-template-base]
  - [app.make][repo-makefile-template-lib]
  - [lib.make][repo-makefile-template-test]
  - [test.make][repo-makefile-template-app]
- [sub.make][repo-makefile-template-sub]
> Note than boards used in this documentation (arduino, raspberry) are just **examples**, _buildroot SDK_ path used may not be accurate (because those infos are board specific), set those templates infos to **your** supported boards.

Makefiles examples which used those templates can be found in [examples/][repo-makefile-examples] directory of this documentation.


<!-- Links of this repository -->

[repo-doc-compilers]: ../../Compilers/

[repo-makefile-cheatsheet]: makefile-cheatsheet.md

[repo-makefile-templates]: templates/
[repo-makefile-template-base]: templates/base.make
[repo-makefile-template-lib]: templates/lib.make
[repo-makefile-template-test]: templates/test.make
[repo-makefile-template-app]: templates/app.make
[repo-makefile-template-sub]: templates/sub.make

[repo-makefile-examples]: examples/

<!-- Links for external ressources -->

[make-file-fct]: https://www.gnu.org/software/make/manual/html_node/File-Function.html

[thread-so-makefile-space-or-tab]: https://stackoverflow.com/questions/28712585/when-to-use-space-or-tab-in-makefile
