**Sommaire :**

- [1. Introduction](#1-introduction)
- [2. Templates pour une application](#2-templates-pour-une-application)
  - [2.1. Template 1 : simple](#21-template-1--simple)
  - [2.2. Template 2 : Gestion des différences d'architectures](#22-template-2--gestion-des-différences-darchitectures)
- [3. Template pour une librairie](#3-template-pour-une-librairie)
  - [3.1. Template 1 : Gestion des différences d'architectures](#31-template-1--gestion-des-différences-darchitectures)

# 1. Introduction

Le projet devra être structuré de la façon suivante :
```shell
bin/  
include/  
obj/  
src/  
Makefile  
```

Le détails des options disponibles pour GCC est décrit ici : [GCC][anchor-doc-gcc]

# 2. Templates pour une application

## 2.1. Template 1 : simple
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
TARGET   = appName

SRCDIR   = src
INCDIR	 = include
OBJDIR   = obj
BINDIR   = bin

# Build configuration
ifeq ($(ARCH), arm)
	CCPREFIX = arm-linux-gnueabihf-
	DEFINE_MACRO = -D'MY_MACRO'
else
	CCPREFIX =
	DEFINE_MACRO = 
endif

# Compilation configuration
CC       = $(CCPREFIX)gcc
CFLAGS   = -std=c11 -Wall -I$(INCDIR) $(DEFINE_MACRO)

# linking flags here
LDFLAGS	 = -lm
LFLAGS   = -Wall -I$(INCDIR) $(LDFLAGS)

# Get all files
SOURCES  := $(wildcard $(SRCDIR)/*.c)
OBJECTS  := $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
rm       = rm -f

# Commands
$(BINDIR)/$(TARGET): $(OBJECTS)
	@$(CC) $(OBJECTS) $(LFLAGS) -o $@
	@echo "Linking complete!"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.c
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully! ($(CC))"

.PHONY: clean
clean:
	@$(rm) $(OBJECTS)
	@echo "Cleanup complete!"

.PHONY: mrproper
mrproper: clean
	@$(rm) $(BINDIR)/$(TARGET)
	@echo "Executable removed!"
```

## 2.2. Template 2 : Gestion des différences d'architectures

```make
# ------------------------------------------------
# Generic Makefile
# Date : 29/10/2021
#
# Memo debug Makefile :
# From https://www.gnu.org/software/make/manual/make.html#Make-Control-Functions
# $(error   VAR is $(VAR))
# $(warning VAR is $(VAR))
# $(info    VAR is $(VAR))
# ------------------------------------------------
#
# Description of available arguments of this Makefile :
#
# - Argument BOARD
# Set to "default" by default.
# If set to "ciele" : SDK for board Ciele will be used (cross-compiler + sysroot).
# If set to "armadeus" : SDK for board Armadeus will be used (cross-compiler + sysroot)
# Others : GCC host compiler will be used, with default GCC sysroot value
#
# - Argument DEBUG (optionnal)
# When set to 1, application is compile with flag : -g -DDEBUG -D$(DEBUG_LEVEL).
# By default, DEBUG_LEVEL is set to "CI_DEBUG_LEVEL=CI_DEBUG_LEVEL_INFO", see ci_debug.h for more details
# This parameter is set to 0 by default.

# Optional arguments
DEBUG ?= 0

# Board target
BOARD ?= default
ifeq ($(BOARD),armadeus)
	SDK_ROOT := ../../../../05-bsp/02-armadeus-imx8-bsp/01-sdk/aarch64-buildroot_borea-linux-gnu_sdk-buildroot/
	SDK_CC_PATH := $(SDK_ROOT)/bin/
	SDK_SYSROOT := $(SDK_ROOT)/aarch64-buildroot_borea-linux-gnu/sysroot/

	LAYER_SUBAPP_INSTALL_DIR := ./bin
	BOARD_FLAG := -DBOARD_ARMADEUS

	CCPREFIX := $(SDK_CC_PATH)/aarch64-buildroot_borea-linux-gnu-

	BOARD_LDFLAGS :=
	BOARD_LDLIBS :=

else ifeq ($(BOARD),ciele)
	SDK_ROOT := ../../../../05-bsp/01-ciele-imx6-bsp/01-sdk/arm-buildroot_borea-linux-gnueabihf_sdk-buildroot/
	SDK_CC_PATH := $(SDK_ROOT)/bin/
	SDK_SYSROOT := $(SDK_ROOT)/arm-buildroot_borea-linux-gnueabihf/sysroot/

	LAYER_SUBAPP_INSTALL_DIR := ./bin
	BOARD_FLAG := -DBOARD_CIELE

	CCPREFIX := $(SDK_CC_PATH)/arm-buildroot_borea-linux-gnueabihf-

	BOARD_LDFLAGS :=
	BOARD_LDLIBS :=

else 
	SDK_ROOT :=
	SDK_CC_PATH :=
	SDK_SYSROOT :=

	LAYER_LIB_INSTALL_DIR :=
	BOARD_FLAG :=

	CCPREFIX :=

	BOARD_LDFLAGS :=
	BOARD_LDLIBS :=
endif

# Compiler
CC = gcc

# Application library folder
LIBRARY_DIR_BIN ?= ../bin/
LIBRARY_DIR_INC ?= ../include/

# Compilation flags
ifeq ($(SDK_ROOT),)
	SYSROOT_CFLAGS	:=
else
	SYSROOT_CFLAGS	:=	--sysroot=$(SDK_SYSROOT)
endif


EXTRA_CFLAGS	:=	-Wall -Wextra -Werror=format -Werror=return-type -Werror=implicit-function-declaration \
					-Wstrict-prototypes -Wshadow \
					-Wno-ignored-qualifiers  \
					\
					-fdiagnostics-color=auto # -Werror -W -ansi -pedantic

CFLAGS			:=	$(SYSROOT_CFLAGS) \
					$(EXTRA_CFLAGS) \
					-I./include \
					-I$(LIBRARY_DIR_INC) \
					-I../../../02-common/include \
					-I../../../02-common/include/ci_std \
					\
					-I../../ci_times/include \
					-I../../custom_error/include \
					-I../../helper_tools/include \

LDFLAGS			:=	-L. \
					-L$(LIBRARY_DIR_BIN) \
					$(BOARD_LDFLAGS) \
					-L../../ci_times/bin/ \
					-L../../custom_error/bin \
					-L../../helper_tools/bin/

LDLIBS			:=	$(BOARD_LDLIBS) \
					-lcustomerror \
					-lhelpertools \
					-lnetworkmanager \
					-lci_times                

# Borea flags
CFLAGS += $(BOARD_FLAG)

# Debug information
DEBUG_LEVEL ?= CI_DEBUG_LEVEL=CI_DEBUG_LEVEL_INFO
ifeq ($(DEBUG), 1)
    CFLAGS += -g -DDEBUG -D$(DEBUG_LEVEL)
else
    CFLAGS += -Os
endif

# Install directory
INSTALL_DIR ?= $(LAYER_SUBAPP_INSTALL_DIR)

# Project directories
SRC_DIR = src
HDR_DIR = include
OBJ_DIR = obj
BIN_DIR = bin

# Project files
SRC = $(wildcard $(SRC_DIR)/*.c)
HDR = $(wildcard $(HDR_DIR)/*.h)
OBJ = $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# Application information
APP_NAME    := app_network_manager
APP_VERSION := $(shell grep -i "\version" $(HDR_DIR)/app_network_manager.h | head -n 1 | cut -d" " -f8)

# Other information
NAME    = $(APP_NAME)
VERSION = $(APP_VERSION)
EXEC    = $(APP_NAME)


#
# Makefile rules
#

all: $(EXEC)

$(EXEC): $(OBJ)
	@echo "Generate binary application"
	$(CCPREFIX)$(CC) -o $(BIN_DIR)/$@ $^ $(LDFLAGS) $(LDLIBS)

$(OBJ_DIR)/%.o:  $(SRC_DIR)/%.c $(HDR)
	@echo "Generate objects"
	$(CCPREFIX)$(CC) -o $@ -c $< $(CFLAGS)

install:
	install -p -m 755 $(BIN_DIR)/$(EXEC) $(INSTALL_DIR)

.PHONY: clean realclean mrproper

clean:
	rm -rf *.o *~ *~
	rm -rf $(SRC_DIR)/*.o $(SRC_DIR)/*~ $(SRC_DIR)/#*
	rm -rf $(OBJ_DIR)/* $(OBJ_DIR)/#*
	rm -rf $(BIN_DIR)/*~ $(BIN_DIR)/#*
	rm -rf $(HDR_DIR)/*~ $(HDR_DIR)/#*

realclean: clean
	rm -rf $(EXEC)
	rm -rf $(BIN_DIR)/*

mrproper: realclean

version:
	@echo $(NAME) v$(VERSION)
```

# 3. Template pour une librairie

## 3.1. Template 1 : Gestion des différences d'architectures

```make
# ------------------------------------------------
# Generic Makefile
# Date : 29/10/2021
#
# Memo debug Makefile :
# From https://www.gnu.org/software/make/manual/make.html#Make-Control-Functions
# $(error   VAR is $(VAR))
# $(warning VAR is $(VAR))
# $(info    VAR is $(VAR))
# ------------------------------------------------
#
# Description of available arguments of this Makefile :
#
# - Argument BOARD
# Set to "default" by default.
# If set to "ciele" : SDK for board Ciele will be used (cross-compiler + sysroot).
# If set to "armadeus" : SDK for board Armadeus will be used (cross-compiler + sysroot)
# Others : GCC host compiler will be used, with default GCC sysroot value
#
# - Argument DEBUG (optionnal)
# When set to 1, application is compile with flag : -g -DDEBUG -D$(DEBUG_LEVEL).
# By default, DEBUG_LEVEL is set to "CI_DEBUG_LEVEL=CI_DEBUG_LEVEL_INFO", see ci_debug.h for more details
# This parameter is set to 0 by default.
#
# - Argument RELEASE (optionnal) :
# Version application use semantic versionning : MAJOR.MINOR.FIX
# When make argument RELEASE==0, a build version is added to the version.
# This way, we have clean number version in production and detailed version in dev/test phases.
# This parameter is set to 0 by default.

# Optional arguments
DEBUG ?= 0
RELEASE ?= 0

# Library information
LIB_NAME := libnetworkmanager
LIB_VERSION_SEMANTIC := 1.0.0
LIB_VERSION_BUILD := $(shell date +%s)

# Board target
BOARD ?= default
ifeq ($(BOARD),armadeus)
	SDK_ROOT := ../../../05-bsp/02-armadeus-imx8-bsp/01-sdk/aarch64-buildroot_borea-linux-gnu_sdk-buildroot/
	SDK_CC_PATH := $(SDK_ROOT)/bin/
	SDK_SYSROOT := $(SDK_ROOT)/aarch64-buildroot_borea-linux-gnu/sysroot/

	LAYER_LIB_INSTALL_DIR := ../lib/board_armadeus/
	BOARD_FLAG := -DBOARD_ARMADEUS

	CCPREFIX := $(SDK_CC_PATH)/aarch64-buildroot_borea-linux-gnu-

else ifeq ($(BOARD),ciele)
	SDK_ROOT := ../../../05-bsp/01-ciele-imx6-bsp/01-sdk/arm-buildroot_borea-linux-gnueabihf_sdk-buildroot/
	SDK_CC_PATH := $(SDK_ROOT)/bin/
	SDK_SYSROOT := $(SDK_ROOT)/arm-buildroot_borea-linux-gnueabihf/sysroot/

	LAYER_LIB_INSTALL_DIR := ../lib/board_ciele/
	BOARD_FLAG := -DBOARD_CIELE

	CCPREFIX := $(SDK_CC_PATH)/arm-buildroot_borea-linux-gnueabihf-

else 
	SDK_ROOT :=
	SDK_CC_PATH :=
	SDK_SYSROOT :=

	LAYER_LIB_INSTALL_DIR :=
	BOARD_FLAG :=

	CCPREFIX :=
endif

# Compiler
CC = gcc

# Compilation flags
ifeq ($(SDK_ROOT),)
	SYSROOT_CFLAGS	:=
else
	SYSROOT_CFLAGS	:=	--sysroot=$(SDK_SYSROOT)
endif


EXTRA_CFLAGS	:=	-Wall -Wextra -Werror=format -Werror=return-type -Werror=implicit-function-declaration \
					-Wstrict-prototypes -Wshadow \
					-Wno-ignored-qualifiers  \
					\
					-fdiagnostics-color=auto # -Werror -W -ansi -pedantic

CFLAGS			:=	$(SYSROOT_CFLAGS) \
					$(EXTRA_CFLAGS) \
					-I./include \
					-I../../02-common/include \
					-I../../02-common/include/ci_std \
					\
					-I../ci_times/include \
					-I../custom_error/include \
					-I../helper_tools/include

LDFLAGS			:= 
LDLIBS			:= 

# Instal directory
INSTALL_DIR ?= $(LAYER_LIB_INSTALL_DIR)

# Project directories
SRC_DIR = src
HDR_DIR = include
OBJ_DIR = obj
BIN_DIR = bin
DOC_DIR = documentation

# Project files
SRC = $(wildcard $(SRC_DIR)/*.c)
HDR = $(wildcard $(HDR_DIR)/*.h)
OBJ = $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# Debug information
DEBUG_LEVEL ?= CI_DEBUG_LEVEL=CI_DEBUG_LEVEL_INFO
ifeq ($(DEBUG), 1)
    CFLAGS += -g -DDEBUG -D$(DEBUG_LEVEL)
else
    CFLAGS += -Os
endif

#
# Release information :
# - Library version parsing
#
LIB_VERSION_IN_FILE := version.in
LIB_VERSION_IN_PATH := $(BIN_DIR)/$(LIB_VERSION_IN_FILE)
LIB_VERSION_IN_DATA := $(file <$(LIB_VERSION_IN_PATH)) # $(shell cat ${LIB_VERSION_IN_PATH}) | This is alternative for make version < 4.2
ifeq ($(RELEASE), 0)
	LIB_VERSION := $(LIB_VERSION_SEMANTIC)-$(LIB_VERSION_BUILD)
else
	LIB_VERSION := $(LIB_VERSION_SEMANTIC)
endif

# Borea flags
CFLAGS += $(BOARD_FLAG)
CFLAGS += -DLIB_VERSION=\"$(LIB_VERSION)\"


#
# Makefile rules
#

all: shared #static

static: $(HDR)
	@echo "Generate static library $(LIB_NAME).a"
	$(CCPREFIX)$(CC) -c $(SRC) $(CFLAGS) $(LDFLAGS) $(LDLIBS)
	mv *.o $(OBJ_DIR)/
	$(CCPREFIX)ar rvs $(BIN_DIR)/$(LIB_NAME).a $(OBJ)
	$(CCPREFIX)ranlib $(BIN_DIR)/$(LIB_NAME).a
	du -sh $(BIN_DIR)/$(LIB_NAME).a

shared: $(HDR)
	@echo "Generate dynamic library $(BIN_DIR)/$(LIB_NAME).so.$(LIB_VERSION)"
	$(CCPREFIX)$(CC) -c $(SRC) $(CFLAGS) -fpic $(LDFLAGS) $(LDLIBS)
	mv *.o $(OBJ_DIR)/
	$(CCPREFIX)$(CC) -shared -o $(BIN_DIR)/$(LIB_NAME).so.$(LIB_VERSION) $(OBJ)
	ln -sf $(LIB_NAME).so.$(LIB_VERSION) $(BIN_DIR)/$(LIB_NAME).so
	du -sh $(BIN_DIR)/$(LIB_NAME).so.$(LIB_VERSION)
	@echo "Generate version file at : $(LIB_VERSION_IN_PATH)"
	$(file >$(LIB_VERSION_IN_PATH),$(LIB_VERSION))

install_static:
	install -p -m 755 $(BIN_DIR)/$(LIB_NAME).a $(INSTALL_DIR)

install_shared:
	install -p -m 755 $(BIN_DIR)/$(LIB_NAME).so.$(LIB_VERSION_IN_DATA) $(INSTALL_DIR)
	@echo "Don't forget to run 'ln -sf $(LIB_NAME).so.$(LIB_VERSION_IN_DATA) \
	$(LIB_NAME).so' on '/usr/lib' from target after manual deployment \
	to allow the application to find dynamic library at execution !"
	ln -sf $(LIB_NAME).so.$(LIB_VERSION_IN_DATA) $(INSTALL_DIR)/$(LIB_NAME).so

install: install_shared

.PHONY: clean realclean mrproper

clean:
	rm -rf *.o *~ *~
	rm -rf $(SRC_DIR)/*.o $(SRC_DIR)/*~ $(SRC_DIR)/#*
	rm -rf $(OBJ_DIR)/* $(OBJ_DIR)/#*
	rm -rf $(BIN_DIR)/*~ $(BIN_DIR)/#*
	rm -rf $(HDR_DIR)/*~ $(HDR_DIR)/#*

realclean: clean
	rm -rf *.a *.so*
	rm -rf $(BIN_DIR)/*
	rm -rf $(EXEC)

mrproper: realclean

version:
	@echo $(LIB_NAME) v$(LIB_VERSION_IN_DATA)
```

> Notes : `make` possède une commande interne afin d'écrire et de lire depuis un fichier ([documentation][make-file-fct]).  
> L'écriture a été introduite avec `make >= 4.0`  
> La lecture a été introduite avec `make >= 4.2`


<!-- Links for other files -->
[anchor-doc-gcc]: ../Compilers/GCC/

<!-- Links for external ressources -->
[make-file-fct]: https://www.gnu.org/software/make/manual/html_node/File-Function.html
