**Sommaire :**

- [1. Introduction](#1-introduction)
- [2. Templates pour une application](#2-templates-pour-une-application)
	- [2.1. Template 1 : simple](#21-template-1--simple)
	- [2.2. Template 3 : Deux boards possédant une architecture différente](#22-template-3--deux-boards-possédant-une-architecture-différente)
	- [2.3. Template 3 : Deux boards avec une architecture différente et une gestion de version plus avancée](#23-template-3--deux-boards-avec-une-architecture-différente-et-une-gestion-de-version-plus-avancée)
	- [2.4. Template 4 : générique](#24-template-4--générique)
- [3. Template pour une librairie](#3-template-pour-une-librairie)
	- [3.1. Template 1 : Deux boards d'architecture différente possédant une seule paire header/source](#31-template-1--deux-boards-darchitecture-différente-possédant-une-seule-paire-headersource)
	- [3.2. Template 2 : Deux boards d'architecture différente possédant plusieurs paires header/source](#32-template-2--deux-boards-darchitecture-différente-possédant-plusieurs-paires-headersource)
	- [3.3. Template 3 : Deux boards d'architecture différente possédant plusieurs paires header/source avec gestion de version avancée](#33-template-3--deux-boards-darchitecture-différente-possédant-plusieurs-paires-headersource-avec-gestion-de-version-avancée)

# 1. Introduction

Le projet devra être structuré de la façon suivante :
```shell
bin/  
include/  
obj/  
src/  
Makefile  
```

Le détails des options disponibles pour GCC est décrit ici : [GCC](https://github.com/BOREA-DENTAL/DocumentationsCobra/tree/master/Documentations/Developpement/Compilers/GCC)

# 2. Templates pour une application

## 2.1. Template 1 : simple
```Makefile
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

## 2.2. Template 3 : Deux boards possédant une architecture différente
```Makefile
# ------------------------------------------------
# Generic Makefile
# Date : 27/01/2021
#
# Memo debug Makefile :
# From https://www.gnu.org/software/make/manual/make.html#Make-Control-Functions
# $(error   VAR is $(VAR))
# $(warning VAR is $(VAR))
# $(info    VAR is $(VAR))
# ------------------------------------------------


# Compilation variables
FLAG_BOARD_CIELE = -DBOARD_CIELE
FLAG_BOARD_ARMADEUS = -DBOARD_ARMADEUS

# Target
ARCH ?= arm
ifeq ($(ARCH),arm)
        CCPREFIX = arm-linux-gnueabihf-
        BOARD_FLAG = $(FLAG_BOARD_CIELE)
else 
  ifeq ($(ARCH),aarch64)
        CCPREFIX = aarch64-none-linux-gnu-
        BOARD_FLAG = $(FLAG_BOARD_ARMADEUS)
  else
      ifeq ($(ARCH),nios2)
        CCPREFIX = nios2-linux-gnu-
        BOARD_FLAG =
      else
        CCPREFIX =
        BOARD_FLAG =
      endif
  endif
endif

# Compiler
CC = gcc

# Custom target libraries folder
LIB_DIR ?= ../bin/

# Custom board compilation flags
ifeq ($(BOARD_FLAG), $(FLAG_BOARD_CIELE))
  BOARD_LDFLAGS =
  BOARD_LDLIBS =

else
  ifeq ($(BOARD_FLAG), $(FLAG_BOARD_ARMADEUS))
    BOARD_LDFLAGS =
    BOARD_LDLIBS =
  else
    BOARD_LDFLAGS = 
    BOARD_LDLIBS = 
  endif
endif

# Compilation flags
EXTRA_CFLAGS = -Wall -W #-Wcomment -ansi -pedantic -Werror 

CFLAGS       = $(EXTRA_CFLAGS) \
               -I./include \
               -I../include \
               -I../../../02-common/include \
               -I../../../02-common/include/ci_std \
               -I../../custom_error/include

LDFLAGS      = -L. \
               -L$(LIB_DIR) \
               $(BOARD_LDFLAGS) \
               -L../../custom_error/bin \
               -L../../helper_tools/bin

LDLIBS       =  $(BOARD_LDLIBS) \
                -lcustomerror \
                -lhelpertools \
                -lnetworkmanager \
                
# Borea flags
CFLAGS += $(BOARD_FLAG)

# Debug information
DEBUG_LEVEL ?= CI_DEBUG_LEVEL=CI_DEBUG_LEVEL_INFO
DEBUG ?= 0
ifeq ($(DEBUG), 1)
    CFLAGS += -g -DDEBUG -D$(DEBUG_LEVEL)
endif

# Install
INSTALL_DIR ?= ./bin

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
APP_NAME    = app_network_manager
APP_VERSION = $(shell grep -i "\version" $(SRC_DIR)/app_network_manager.c | head -n 1 | cut -d" " -f8)

# Others informations
NAME    = $(APP_NAME)
VERSION = $(APP_VERSION)
EXEC    = $(APP_NAME)

# Makefile rules
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
	rm -rf *~ src/*.o src/*~ bin/*~ bin/*.so bin/*.a obj/* file.out

realclean: clean
	rm -rf $(EXEC) bin/$(EXEC) bin/file.out

mrproper: realclean

version:
	@echo $(NAME) v$(VERSION)

```

## 2.3. Template 3 : Deux boards avec une architecture différente et une gestion de version plus avancée
```Makefile
# ------------------------------------------------
# Generic Makefile
# Date : 03/05/2021
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
# - Argument ARCH (optionnal)
# Set to "arm" by default.
# If set to "arm" : Elements for board Ciele will be used (cross-compiler + dependant libraries).
# If set to "aarch64" : Elements for board Armadeus will be used (cross-compiler + dependant libraries)
# Others : host compiler GCC will be used, no dependant libraries
#
# - Argument OPT_EXTENTED_FEATURES (optionnal)
# When set to 1, enable extended features : SIGUSR management
#
# - Argument RELEASE (optionnal) :
# Version application use semantic versionning : MAJOR.MINOR.FIX
# When make argument RELEASE==0, a build version is added to the version.
# This way, we have clean number version in production and detailed version in dev/test phases.
# This parameter is set to 0 by default.
#
# - Argument DEBUG (optionnal)
# When set to 1, application is compile with flag : -g -DDEBUG -D$(DEBUG_LEVEL).
# By default, DEBUG_LEVEL is set to "CI_DEBUG_LEVEL=CI_DEBUG_LEVEL_INFO", see ci_debug.h for more details
# This parameter is set to 0 by default.

# Optional arguments
OPT_EXTENTED_FEATURES ?= 0
RELEASE ?= 0
DEBUG ?= 0

# Application information
APP_NAME = rp2_core
APP_VERSION_SEMANTIC = 1.7.0
APP_VERSION_BUILD = $(shell date +%s)
APP_CFG_FILE_VERSION_SEMANTIC = 100

# flags
FLAG_BOARD_CIELE = -DBOARD_CIELE
FLAG_BOARD_ARMADEUS = -DBOARD_ARMADEUS

# target
ARCH ?= arm
ifeq ($(ARCH),arm)
      CCPREFIX = arm-linux-gnueabihf-
      BOARD_FLAG = $(FLAG_BOARD_CIELE)

else 
  ifeq ($(ARCH),aarch64)
      CCPREFIX = aarch64-none-linux-gnu-
      BOARD_FLAG = $(FLAG_BOARD_ARMADEUS)
  else
      ifeq ($(ARCH),nios2)
            CCPREFIX = nios2-linux-gnu-
            BOARD_FLAG = 
      else
            CCPREFIX =
            BOARD_FLAG = 
      endif
  endif
endif

# Custom board variables
ifeq ($(BOARD_FLAG), $(FLAG_BOARD_CIELE))
  BSP_DIR = ../../../05-bsp/01-ciele-imx6-bsp/03-bsp/
  CUSTOM_LIB_BOARD_DEPLOY_DIR = board_ciele
  
  BOARD_LDFLAGS = -L../../pwm_led/bin
  BOARD_LDLIBS =  -lEGL \
                  -lGAL \
				  -lGLESv2 \
  				  -lOpenVG \
				  -lVSC \
				  \
				  -lpwm_led

else
  ifeq ($(BOARD_FLAG), $(FLAG_BOARD_ARMADEUS))
    BSP_DIR = ../../../05-bsp/02-armadeus-imx8-bsp/03-bsp/
    CUSTOM_LIB_BOARD_DEPLOY_DIR = board_armadeus

	BOARD_LDFLAGS = -L../../helper_tlc5949/bin \
					-L../../spi_communication/bin

    BOARD_LDLIBS =  -lhelpertlc5949 \
					-lspicommunication

  else
    BOARD_LDFLAGS = 
    BOARD_LDLIBS = 
  endif
endif


# custom target libraries folder
BSP_LIB_DIR ?= $(BSP_DIR)lib/
BSP_INC_DIR ?= $(BSP_DIR)include/

CUSTOM_LIB_DIR = ../../03-libs/
CUSTOM_LIB_DIR_INSTALL = $(CUSTOM_LIB_DIR)/lib/$(CUSTOM_LIB_BOARD_DEPLOY_DIR)/

BOARD_BIN_DIR = bin/$(CUSTOM_LIB_BOARD_DEPLOY_DIR)
           
# compiler
CC = gcc

# compilation flags
NATIVE_CFLAGS = -DPOSIX -D_POSIX_SOURCE -D_GNU_SOURCE

EXTRA_CFLAGS  = -Wall -Wextra -Werror=format -Werror=return-type -Werror=implicit-function-declaration \
				-Wstrict-prototypes -Wshadow \
				-Wno-ignored-qualifiers #-Werror -W -ansi -pedantic

CFLAGS        = $(NATIVE_CFLAGS) \
                $(EXTRA_CFLAGS)  \
                -I./include \
				-I../../02-common/include \
                -I../../02-common/include/ci_std \
				\
				-I$(CUSTOM_LIB_DIR)ci_times/include \
				-I$(CUSTOM_LIB_DIR)custom_error/include \
				-I$(CUSTOM_LIB_DIR)custom_syslog/include \
				-I$(CUSTOM_LIB_DIR)helper_tools/include \
				-I$(CUSTOM_LIB_DIR)iniparser/include \
				-I$(CUSTOM_LIB_DIR)led_manager/include \
				-I$(CUSTOM_LIB_DIR)network_manager/include \
				-I$(CUSTOM_LIB_DIR)screen/include \
				-I$(CUSTOM_LIB_DIR)sensor_configuration/include \
				-I$(CUSTOM_LIB_DIR)snapshot/include \
				-I$(CUSTOM_LIB_DIR)wifi_manager/include \
				\
				-I$(BSP_INC_DIR) \
				-I$(BSP_INC_DIR)/glib-2.0 \
				-I$(BSP_INC_DIR)/gstreamer-1.0 \

LDFLAGS       = -L. \
                -L$(CUSTOM_LIB_DIR_INSTALL) \
				-L$(BSP_LIB_DIR) \
				$(BOARD_LDFLAGS)

LDLIBS        = $(BOARD_LDLIBS) \
                -lci_times \
				-lcrc \
				-lcustomerror \
				-lcustom_syslog \
				-lhelpertools \
				-liniparser \
				-lledmanager \
				-lmediactl \
				-lnetworkmanager \
                -lscreen \
				-lsensorconfiguration \
				-lsnapshot \
				-lv4l2subdev \
				-lwifimanager \
				\
				-lcairo \
                -lcairo-gobject \
				-lexpat \
				-lffi \
				-lfontconfig \
				-lfreetype \
				-lglib-2.0 \
				-lgmodule-2.0 \
				-lgobject-2.0 \
				-lgpiod \
				-lgstbase-1.0 \
				-lgstreamer-1.0 \
				-lgstvideo-1.0 \
				-lpcre \
				-lpixman-1 \
                -lpng16 \
				-luuid \
				-lz \

#
# Debug information
#
DEBUG_LEVEL ?= CI_DEBUG_LEVEL=CI_DEBUG_LEVEL_INFO
ifeq ($(DEBUG), 1)
    CFLAGS += -g -DDEBUG -D$(DEBUG_LEVEL)
endif

#
# Release information :
# - Library version parsing
#
ifeq ($(RELEASE), 0)
	APP_VERSION = $(APP_VERSION_SEMANTIC)-$(APP_VERSION_BUILD)
else
	APP_VERSION = $(APP_VERSION_SEMANTIC)
endif

#
# Borea flags
#
CFLAGS += $(BOARD_FLAG)
CFLAGS += -DRP2_CORE_APP_VERSION=\"$(APP_VERSION)\" -DRP2_CORE_APP_CFG_VERSION=$(APP_CFG_FILE_VERSION_SEMANTIC)
ifeq ($(OPT_EXTENTED_FEATURES), 1)
	CFLAGS += -DRP2_EXTENDED_FEATURES
endif

#
# install
#
INSTALL_DIR ?= ./$(BOARD_BIN_DIR)


#
# project directories
#
SRC_DIR = src
HDR_DIR = include
OBJ_DIR = obj
BIN_DIR = $(BOARD_BIN_DIR)


#
# project files
#
SRC = $(wildcard $(SRC_DIR)/*.c)
HDR = $(wildcard $(HDR_DIR)/*.h)
OBJ = $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

#
# other information
#
NAME    = $(APP_NAME)
VERSION = $(APP_VERSION)
EXEC    = $(APP_NAME)


#
# Makefile rules
#

all: $(EXEC)

$(EXEC): $(OBJ)
	@echo "Generate binary application"
	$(CCPREFIX)$(CC) -pthread -o $(BIN_DIR)/$@ $^ $(LDFLAGS) $(LDLIBS)

$(OBJ_DIR)/%.o:  $(SRC_DIR)/%.c $(HDR)
	@echo "Generate objects"
	$(CCPREFIX)$(CC) -o $@ -c $< $(CFLAGS)

install:
	install -p -m 755 $(BIN_DIR)/$(EXEC) $(INSTALL_DIR)

runtest:
	./run_test.sh

.PHONY: clean realclean mrproper

clean:
	rm -rf *~ $(SRC_DIR)/*.o $(SRC_DIR)/*~ $(BIN_DIR)/*~ $(BIN_DIR)/*.so $(BIN_DIR)/*.a $(OBJ_DIR)/* file.out

realclean: clean
	rm -rf $(EXEC) $(BIN_DIR)/$(EXEC) $(BIN_DIR)/file.out

mrproper: realclean

version:
	@echo $(NAME) v$(VERSION)


```

## 2.4. Template 4 : générique

Source : [Makefile-Templates](https://github.com/TheNetAdmin/Makefile-Templates "Makefile-Templates"))

```Makefile
########################################################################
####################### Makefile Template ##############################
########################################################################

# Compiler settings - Can be customized.
CC = gcc
CXXFLAGS = -std=c11 -Wall
LDFLAGS = -lm

# Makefile settings - Can be customized.
APPNAME = myapp
EXT = .c
SRCDIR = src
OBJDIR = obj
BINDIR = bin

############## Do not change anything from here downwards! #############
SRC = $(wildcard $(SRCDIR)/*$(EXT))
OBJ = $(SRC:$(SRCDIR)/%$(EXT)=$(OBJDIR)/%.o)
DEP = $(OBJ:$(OBJDIR)/%.o=%.d)
TARGET = $(BINDIR)/$(APPNAME)
# UNIX-based OS variables & settings
RM = rm
DELOBJ = $(OBJ)
# Windows OS variables & settings
DEL = del
EXE = .exe
WDELOBJ = $(SRC:$(SRCDIR)/%$(EXT)=$(OBJDIR)\\%.o)

########################################################################
####################### Targets beginning here #########################
########################################################################

all: $(TARGET)

# Builds the app
$(TARGET): $(OBJ)
	$(CC) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)

# Creates the dependecy rules
%.d: $(SRCDIR)/%$(EXT)
	@$(CPP) $(CFLAGS) $< -MM -MT $(@:%.d=$(OBJDIR)/%.o) >$@

# Includes all .h files
-include $(DEP)

# Building rule for .o files and its .c/.cpp in combination with all .h
$(OBJDIR)/%.o: $(SRCDIR)/%$(EXT)
	$(CC) $(CXXFLAGS) -o $@ -c $<

################### Cleaning rules for Unix-based OS ###################
# Cleans complete project
.PHONY: clean
clean:
	$(RM) $(DELOBJ) $(DEP) $(APPNAME)

# Cleans only all files with the extension .d
.PHONY: cleandep
cleandep:
	$(RM) $(DEP)

#################### Cleaning rules for Windows OS #####################
# Cleans complete project
.PHONY: cleanw
cleanw:
	$(DEL) $(WDELOBJ) $(DEP) $(APPNAME)$(EXE)

# Cleans only all files with the extension .d
.PHONY: cleandepw
cleandepw:
	$(DEL) $(DEP)
```

# 3. Template pour une librairie

## 3.1. Template 1 : Deux boards d'architecture différente possédant une seule paire header/source
```Makefile
# Target
ARCH ?= arm
ifeq ($(ARCH),arm)
        CCPREFIX = arm-linux-gnueabihf-
		BOARD_FLAG = -DBOARD_CIELE
		BSP_DIR = ../../../05-bsp/01-ciele-imx6-bsp/03-bsp/
		CUSTOM_INSTALL_DIR = ../lib/board_ciele
else 
  ifeq ($(ARCH),aarch64)
		CCPREFIX = aarch64-none-linux-gnu-
		BOARD_FLAG = -DBOARD_ARMADEUS
		BSP_DIR = ../../../05-bsp/02-armadeus-imx8-bsp/03-bsp/
		CUSTOM_INSTALL_DIR = ../lib/board_armadeus
  else
	ifeq ($(ARCH),nios2)
			CCPREFIX = nios2-linux-gnu-
			BOARD_FLAG =
			BSP_DIR =
			CUSTOM_INSTALL_DIR = ../lib
	else
			CCPREFIX =
			BOARD_FLAG =
			BSP_DIR =
			CUSTOM_INSTALL_DIR = ../lib
	endif
  endif
endif

# Compiler
CC = gcc

# Custom target libraries folder
BSP_LIB_DIR ?= $(BSP_DIR)lib/
BSP_INC_DIR ?= $(BSP_DIR)include/

# Compilation flags
EXTRA_CFLAGS = -Wall -Werror #-ansi -W -Wcomment -pedantic

CFLAGS       = $(EXTRA_CFLAGS) \
               -I./include \
	           -I../../02-common/include \
	           -I../../02-common/include/ci_std \
			   -I../helper_tlc5949/include \
			   -I../pwm_led/include

LDFLAGS      = 
LDLIBS       = 

# Borea flags
CFLAGS += $(BOARD_FLAG)

# Debug information
DEBUG_LEVEL ?= CI_DEBUG_LEVEL=CI_DEBUG_LEVEL_INFO
DEBUG ?= 0
ifeq ($(DEBUG), 1)
    CFLAGS += -g -DDEBUG -D$(DEBUG_LEVEL)
endif

# Coverage information
COVERAGE ?= 0
ifeq ($(COVERAGE), 1)
    COVERAGE_CFLAGS = -fprofile-arcs -ftest-coverage
    CFLAGS += -g $(COVERAGE_CFLAGS)
    LDLIBS += -lgcov
endif

# Install
INSTALL_DIR ?= $(CUSTOM_INSTALL_DIR)

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

# Library information
LIB_NAME    = libledmanager
LIB_VERSION = $(shell grep -i "\version" $(HDR_DIR)/led_manager.h | head -n 1 | cut -d" " -f8)

# Other information
NAME    = $(LIB_NAME)
VERSION = $(LIB_VERSION)

# Makefile rules

all: shared #static

$(OBJ_DIR)/%.o: $(HDR)
	@echo "Generate objects"
	$(CCPREFIX)$(CC) -c $(CFLAGS) -fpic $(SRC) $(LDFLAGS) $(LDLIBS) -o $@

static: $(OBJ) $(HDR)
	@echo "Generate static library $(LIB_NAME).a"
	$(CCPREFIX)ar rvs $(BIN_DIR)/$(LIB_NAME).a $(OBJ)
	$(CCPREFIX)ranlib $(BIN_DIR)/$(LIB_NAME).a
	du -sh $(BIN_DIR)/$(LIB_NAME).a

shared: $(OBJ) $(HDR)
	@echo "Generate dynamic library $(BIN_DIR)/$(LIB_NAME).so.$(LIB_VERSION)"
	$(CCPREFIX)$(CC) -shared -o $(BIN_DIR)/$(LIB_NAME).so.$(LIB_VERSION) $(OBJ)
	ln -sf $(LIB_NAME).so.$(LIB_VERSION) $(BIN_DIR)/$(LIB_NAME).so
	du -sh $(BIN_DIR)/$(LIB_NAME).so.$(LIB_VERSION)

install_static:
	install -p -m 755 $(BIN_DIR)/$(LIB_NAME).a $(INSTALL_DIR)

install_shared:
	install -p -m 755 $(BIN_DIR)/$(LIB_NAME).so.$(LIB_VERSION) $(INSTALL_DIR)
	@echo "Don't forget to run 'ln -sf $(LIB_NAME).so.$(LIB_VERSION) \
	$(LIB_NAME).so' on '/usr/lib' from target after manual deployment \
	to allow the application to find dynamic library at execution !"
	ln -sf $(LIB_NAME).so.$(LIB_VERSION) $(INSTALL_DIR)/$(LIB_NAME).so

install: install_shared

coverage:
	@echo "Generate coverage reports using 'gcov' and 'lcov'"
	rm -rf $(DOC_DIR)/coverage 2>&1 >/dev/null
	mkdir -p $(DOC_DIR)/coverage/html
	lcov --base-directory ./ --directory ./obj --capture --output-file ./$(DOC_DIR)/coverage/$(LIB_NAME)-coverage.info
	genhtml -o ./$(DOC_DIR)/coverage/html ./$(DOC_DIR)/coverage/$(LIB_NAME)-coverage.info

.PHONY: coverageclean clean gendocclean realclean mrproper

gendoc:
	rm -rf ./$(DOC_DIR)/doxygen-outputs 2>&1 >/dev/null
	mkdir -p $(DOC_DIR)/doxygen-outputs
	/usr/bin/doxygen ./$(DOC_DIR)/doxygen-build/Doxyfile

gendocclean:
	rm -rf ./$(DOC_DIR)/doxygen-outputs

coverageclean:
	rm -rf obj/*.gcno obj/*.gcda $(DOC_DIR)/coverage

clean:
	rm -rf *.o *~ *~
	rm -rf $(SRC_DIR)/*.o $(SRC_DIR)/*~ $(SRC_DIR)/#*
	rm -rf $(OBJ_DIR)/* $(OBJ_DIR)/#*
	rm -rf $(BIN_DIR)/*~ $(BIN_DIR)/#*
	rm -rf $(HDR_DIR)/*~ $(HDR_DIR)/#*

realclean: coverageclean clean gendocclean
	rm -rf *.a *.so*
	rm -rf $(BIN_DIR)/*
	rm -rf $(EXEC)

mrproper: realclean

version:
	@echo $(NAME) v$(VERSION)
```

## 3.2. Template 2 : Deux boards d'architecture différente possédant plusieurs paires header/source

La différence par rapport au Template 1 se situe seulement lors des directives `static` et `shared` avec la génération 
des objets dans le répertoire courant puis ensuite l'utilisation de la commande `mv` pour les placer dans le répertoire _obj_ :

```Makefile
# Target
ARCH ?= arm
ifeq ($(ARCH),arm)
        CCPREFIX = arm-linux-gnueabihf-
		BOARD_FLAG = -DBOARD_CIELE
		BSP_DIR = ../../../05-bsp/01-ciele-imx6-bsp/03-bsp/
		CUSTOM_INSTALL_DIR = ../lib/board_ciele
else 
  ifeq ($(ARCH),aarch64)
		CCPREFIX = aarch64-none-linux-gnu-
		BOARD_FLAG = -DBOARD_ARMADEUS
		BSP_DIR = ../../../05-bsp/02-armadeus-imx8-bsp/03-bsp/
		CUSTOM_INSTALL_DIR = ../lib/board_armadeus
  else
	ifeq ($(ARCH),nios2)
			CCPREFIX = nios2-linux-gnu-
			BOARD_FLAG =
			BSP_DIR =
			CUSTOM_INSTALL_DIR = ../lib
	else
			CCPREFIX =
			BOARD_FLAG =
			BSP_DIR =
			CUSTOM_INSTALL_DIR = ../lib
	endif
  endif
endif

# Compiler
CC = gcc

# Custom target libraries folder
BSP_LIB_DIR ?= $(BSP_DIR)lib/
BSP_INC_DIR ?= $(BSP_DIR)include/

# Compilation flags
EXTRA_CFLAGS = -Wall -Werror #-ansi -W -Wcomment -pedantic
CFLAGS       = $(EXTRA_CFLAGS) \
               -I./include \
               -I../../02-common/include \
               -I../../02-common/include/ci_std \
			   -I../custom_error/include \
			   -I../helper_tools/include

LDFLAGS      = 
LDLIBS       = 

# Borea flags
CFLAGS += $(BOARD_FLAG)

# Debug information
DEBUG_LEVEL ?= CI_DEBUG_LEVEL=CI_DEBUG_LEVEL_INFO
DEBUG ?= 0
ifeq ($(DEBUG), 1)
    CFLAGS += -g -DDEBUG -D$(DEBUG_LEVEL)
endif

# Coverage information
COVERAGE ?= 0
ifeq ($(COVERAGE), 1)
    COVERAGE_CFLAGS = -fprofile-arcs -ftest-coverage
    CFLAGS += -g $(COVERAGE_CFLAGS)
    LDLIBS += -lgcov
endif

# Install
INSTALL_DIR ?= $(CUSTOM_INSTALL_DIR)

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

# Library information
LIB_NAME    = libnetworkmanager
LIB_VERSION = $(shell grep -i "\version" $(HDR_DIR)/network_manager.h | head -n 1 | cut -d" " -f8)

# Others informations
NAME    = $(LIB_NAME)
VERSION = $(LIB_VERSION)

# Makefile rules

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

install_static:
	install -p -m 755 $(BIN_DIR)/$(LIB_NAME).a $(INSTALL_DIR)

install_shared:
	install -p -m 755 $(BIN_DIR)/$(LIB_NAME).so.$(LIB_VERSION) $(INSTALL_DIR)
	@echo "Don't forget to run 'ln -sf $(LIB_NAME).so.$(LIB_VERSION) \
	$(LIB_NAME).so' on '/usr/lib' from target after manual deployment \
	to allow the application to find dynamic library at execution !"
	ln -sf $(LIB_NAME).so.$(LIB_VERSION) $(INSTALL_DIR)/$(LIB_NAME).so

install: install_shared

coverage:
	@echo "Generate coverage reports using 'gcov' and 'lcov'"
	rm -rf $(DOC_DIR)/coverage 2>&1 >/dev/null
	mkdir -p $(DOC_DIR)/coverage/html
	lcov --base-directory ./ --directory ./obj --capture --output-file ./$(DOC_DIR)/coverage/$(LIB_NAME)-coverage.info
	genhtml -o ./$(DOC_DIR)/coverage/html ./$(DOC_DIR)/coverage/$(LIB_NAME)-coverage.info

.PHONY: coverageclean clean gendocclean realclean mrproper

gendoc:
	rm -rf ./$(DOC_DIR)/doxygen-outputs 2>&1 >/dev/null
	mkdir -p $(DOC_DIR)/doxygen-outputs
	/usr/bin/doxygen ./$(DOC_DIR)/doxygen-build/Doxyfile

gendocclean:
	rm -rf ./$(DOC_DIR)/doxygen-outputs

coverageclean:
	rm -rf obj/*.gcno obj/*.gcda $(DOC_DIR)/coverage

clean:
	rm -rf *.o *~ *~
	rm -rf $(SRC_DIR)/*.o $(SRC_DIR)/*~ $(SRC_DIR)/#*
	rm -rf $(OBJ_DIR)/* $(OBJ_DIR)/#*
	rm -rf $(BIN_DIR)/*~ $(BIN_DIR)/#*
	rm -rf $(HDR_DIR)/*~ $(HDR_DIR)/#*

realclean: coverageclean clean gendocclean
	rm -rf *.a *.so*
	rm -rf $(BIN_DIR)/*
	rm -rf $(EXEC)

mrproper: realclean

version:
	@echo $(NAME) v$(VERSION)

```

## 3.3. Template 3 : Deux boards d'architecture différente possédant plusieurs paires header/source avec gestion de version avancée

Les précédants template ne permettaient d'obtenir le numéro de version dans la librairie, c'était seulement défini pour la documentation, une macro a donc été ajoutée.  
De plus, lorsque la librairie est compilée sans le flag `RELEASE=1`, un numéro de build est ajouté à la version :
- `RELEASE=0` : `MAJOR.Minor.fix`
- `RELEASE=1` : `MAJOR.MINOR.fix-build`  
Cela permet de traquer les versions exactes d'une librarie, même en cycle de développement ou de tests.

```Makefile
# ------------------------------------------------
# Generic Makefile
# Date : 03/05/2021
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
# - Argument ARCH (optionnal)
# Set to "arm" by default.
# If set to "arm" : Elements for board Ciele will be used (cross-compiler + dependant libraries).
# If set to "aarch64" : Elements for board Armadeus will be used (cross-compiler + dependant libraries)
# Others : host compiler GCC will be used, no dependant libraries
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
LIB_NAME = libnetworkmanager
LIB_VERSION_SEMANTIC = 0.0.1
LIB_VERSION_BUILD = $(shell date +%s)

# target
ARCH ?= arm
ifeq ($(ARCH),arm)
        CCPREFIX = arm-linux-gnueabihf-
		BOARD_FLAG = -DBOARD_CIELE
		BSP_DIR = ../../../05-bsp/01-ciele-imx6-bsp/03-bsp/
		CUSTOM_INSTALL_DIR = ../lib/board_ciele
else 
  ifeq ($(ARCH),aarch64)
		CCPREFIX = aarch64-none-linux-gnu-
		BOARD_FLAG = -DBOARD_ARMADEUS
		BSP_DIR = ../../../05-bsp/02-armadeus-imx8-bsp/03-bsp/
		CUSTOM_INSTALL_DIR = ../lib/board_armadeus
  else
	ifeq ($(ARCH),nios2)
			CCPREFIX = nios2-linux-gnu-
			BOARD_FLAG =
			BSP_DIR =
			CUSTOM_INSTALL_DIR = ../lib
	else
			CCPREFIX =
			BOARD_FLAG =
			BSP_DIR =
			CUSTOM_INSTALL_DIR = ../lib
	endif
  endif
endif

# compiler
CC = gcc

# custom target libraries folder
BSP_LIB_DIR ?= $(BSP_DIR)lib/
BSP_INC_DIR ?= $(BSP_DIR)include/

# compilation flags
EXTRA_CFLAGS  = -Wall -Wextra -Werror=format -Werror=return-type -Werror=implicit-function-declaration \
				-Wstrict-prototypes -Wshadow \
				-Wno-ignored-qualifiers #-Werror -W -ansi -pedantic
				
CFLAGS       = $(EXTRA_CFLAGS) \
               -I./include \
               -I../../02-common/include \
               -I../../02-common/include/ci_std \
			   -I../ci_times/include \
			   -I../custom_error/include \
			   -I../helper_tools/include

LDFLAGS      = 
LDLIBS       = 

#
# Debug information
#
DEBUG_LEVEL ?= CI_DEBUG_LEVEL=CI_DEBUG_LEVEL_INFO
ifeq ($(DEBUG), 1)
    CFLAGS += -g -DDEBUG -D$(DEBUG_LEVEL)
endif

#
# Release information :
# - Library version parsing
#
ifeq ($(RELEASE), 0)
	LIB_VERSION = $(LIB_VERSION_SEMANTIC)-$(LIB_VERSION_BUILD)
else
	LIB_VERSION = $(LIB_VERSION_SEMANTIC)
endif

#
# Borea flags
#
CFLAGS += $(BOARD_FLAG)
CFLAGS += -DLIB_VERSION=\"$(LIB_VERSION)\"

#
# Coverage information
#
COVERAGE ?= 0
ifeq ($(COVERAGE), 1)
    COVERAGE_CFLAGS = -fprofile-arcs -ftest-coverage
    CFLAGS += -g $(COVERAGE_CFLAGS)
    LDLIBS += -lgcov
endif


#
#
# install
#
INSTALL_DIR ?= $(CUSTOM_INSTALL_DIR)


#
# project directories
#
SRC_DIR = src
HDR_DIR = include
OBJ_DIR = obj
BIN_DIR = bin
DOC_DIR = documentation


#
# project files
#
SRC = $(wildcard $(SRC_DIR)/*.c)
HDR = $(wildcard $(HDR_DIR)/*.h)
OBJ = $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)


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

install_static:
	install -p -m 755 $(BIN_DIR)/$(LIB_NAME).a $(INSTALL_DIR)

install_shared:
	install -p -m 755 $(BIN_DIR)/$(LIB_NAME).so.$(LIB_VERSION) $(INSTALL_DIR)
	@echo "Don't forget to run 'ln -sf $(LIB_NAME).so.$(LIB_VERSION) \
	$(LIB_NAME).so' on '/usr/lib' from target after manual deployment \
	to allow the application to find dynamic library at execution !"
	ln -sf $(LIB_NAME).so.$(LIB_VERSION) $(INSTALL_DIR)/$(LIB_NAME).so

install: install_shared

coverage:
	@echo "Generate coverage reports using 'gcov' and 'lcov'"
	rm -rf $(DOC_DIR)/coverage 2>&1 >/dev/null
	mkdir -p $(DOC_DIR)/coverage/html
	lcov --base-directory ./ --directory ./obj --capture --output-file ./$(DOC_DIR)/coverage/$(LIB_NAME)-coverage.info
	genhtml -o ./$(DOC_DIR)/coverage/html ./$(DOC_DIR)/coverage/$(LIB_NAME)-coverage.info

.PHONY: coverageclean clean gendocclean realclean mrproper

gendoc:
	rm -rf ./$(DOC_DIR)/doxygen-outputs 2>&1 >/dev/null
	mkdir -p $(DOC_DIR)/doxygen-outputs
	/usr/bin/doxygen ./$(DOC_DIR)/doxygen-build/Doxyfile

gendocclean:
	rm -rf ./$(DOC_DIR)/doxygen-outputs

coverageclean:
	rm -rf obj/*.gcno obj/*.gcda $(DOC_DIR)/coverage

clean:
	rm -rf *.o *~ *~
	rm -rf $(SRC_DIR)/*.o $(SRC_DIR)/*~ $(SRC_DIR)/#*
	rm -rf $(OBJ_DIR)/* $(OBJ_DIR)/#*
	rm -rf $(BIN_DIR)/*~ $(BIN_DIR)/#*
	rm -rf $(HDR_DIR)/*~ $(HDR_DIR)/#*

realclean: coverageclean clean gendocclean
	rm -rf *.a *.so*
	rm -rf $(BIN_DIR)/*
	rm -rf $(EXEC)

mrproper: realclean

version:
	@echo $(LIB_NAME) v$(LIB_VERSION)

```
