# Gestion de Makefile

Le projet devra être structuré de la façon suivante :
```shell
bin/  
include/  
obj/  
src/  
Makefile  
```

## Template pour un projet classique
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

- Template 2 : Complet (peut-être trop...) (source : [Makefile-Templates](https://github.com/TheNetAdmin/Makefile-Templates "Makefile-Templates"))
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
