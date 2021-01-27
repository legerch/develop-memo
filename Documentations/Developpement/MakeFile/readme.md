**Sommaire :**

- [Introduction](#introduction)
- [Templates pour une application](#templates-pour-une-application)
- [Template pour une librairie](#template-pour-une-librairie)

# Introduction

Le projet devra être structuré de la façon suivante :
```shell
bin/  
include/  
obj/  
src/  
Makefile  
```

# Templates pour une application

- Template 1 : Plus simple
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

- Template 2 : Exemple avec deux boards possédant une architecture différente
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

- Template 3 : Complet (peut-être trop...) (source : [Makefile-Templates](https://github.com/TheNetAdmin/Makefile-Templates "Makefile-Templates"))
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

# Template pour une librairie

- Template 1 : Deux boards d'architecture différente possédant une seule paire header/source :
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

- Template 2 : Deux boards d'architecture différente possédant plusieurs paires header/source :
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
