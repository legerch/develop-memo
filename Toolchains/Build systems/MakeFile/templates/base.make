# ------------------------------------------------
# Generic Makefile use to prepare build
# for libraries or apps
# Date : 17/05/2023
# ------------------------------------------------
# Memo debug Makefile :
# From https://www.gnu.org/software/make/manual/make.html#Make-Control-Functions
# $(error   VAR is $(VAR))
# $(warning VAR is $(VAR))
# $(info    VAR is $(VAR))
# ------------------------------------------------
# Available command-line arguments:
# - BOARD
# Set to "default" by default.
# If set to "arduino" : SDK for Arduino board will be used (cross-compiler + sysroot).
# If set to "raspberry" : SDK for Raspberry board will be used (cross-compiler + sysroot)
# Others : GCC host compiler will be used, with default GCC sysroot value
#
# - DEBUG
# When set to 1, application is compile with flag : -g -DDEBUG.
# By default, this parameter is set to 0.
#
# - RELEASE
# Version application use semantic versionning : MAJOR.MINOR.FIX
# When make argument RELEASE==0, a build version is added to the version.
# This way, we have clean number version in production and detailed version in dev/test phases.
# By default, this parameter is set to 0.
#
# - ANALYZE
# Option used to trigger analyze options:
# When set to 1: This will enable static analyzer tool (see https://gcc.gnu.org/onlinedocs/gcc/Static-Analyzer-Options.html)
# When set to 2: Thi will enable stack memory usage for each compiled file (see https://gcc.gnu.org/onlinedocs/gnat_ugn/Static-Stack-Usage-Analysis.html)
# By default, this value is empty.
#
# - CCOPT
# Compiler option to pass, only used with command `compiler-option`.
# This can be useful to retrieve compiler version, specs or available options.
# By default, this parameter is set to `--help`
# ------------------------------------------------
# Arguments to set when calling this Makefile from another:
#
# - Mandatories:
# 	- .DEFAULT_GOAL
# 	Default target rule to execute when only "make" is called.
#	See https://www.gnu.org/software/make/manual/html_node/Special-Variables.html
#	- TARGET_NAME
# 	Name of target to build
#	- TARGET_VERSION_SEMANTIC
#	Semantic version (https://semver.org/) of the target to build
#
# - Optionals:
#	- BOARD_<name-board>_CFLAGS: C flags specified to a supported board to used
#	- CFLAGS_TARGET: C flags of target to used, common to all board
#	
#	- BOARD_<name-board>_LIB_PATHS_LIST: List of libraries paths to search, specific to a supported board
#	- PATHS_LIBS_LIST_SPECIFIC: List of libraries paths to search, common to all board
#
#	- BOARD_<name-board>_LDLIBS: Linker flags to use for a supported board
#	- LDLIBS_SPECIFIC: Linker flags to use, common to all board
#
#	- HEADERS_SPECIFIC_LIST: List of externals/custom headers paths needed for target to compile (headers dependency with others libraries/apps)
#	- HEADERS_LAYER_LIST: List of externals/custom headers, available in the layer, needed for target to compile
#	- HEADERS_SDK_LIST: List of SDK headers paths needed for target to compile (example: /usr/include/glib-2.0)
# ------------------------------------------------
# Developer notes:
# - Paths used in this file will be relative path from the calling Makefile (not path relative to this file)
# - To use path from THIS file, use custom variable $(PWD_TEMPLATE_BASE)
# ------------------------------------------------

# Optional arguments
DEBUG ?= 0
RELEASE ?= 0
CCOPT ?= --help

# Verify used make version
# - GNU make is required since we used custom features
# - 4.2 is set as minimum since:
# 	- "$(file <path_file>)" command is required
ifneq (4.2,$(firstword $(sort $(MAKE_VERSION) 4.2)))
    $(error GNU make 4.2 or superior must be used)
endif

# Prevent recipe from this makefile to be run when no target is specified
# (since base rules are mainly "clean" rules, we don't want to run this by default)
# For more details, see:
# https://www.gnu.org/software/make/manual/html_node/Special-Variables.html
ifeq ($(.DEFAULT_GOAL),)
    $(error No default goal is set for "base" recipe)
endif

# Target information
ifeq ($(TARGET_NAME),)
    $(error Target name is not set, cannot pursuit)
endif

ifeq ($(TARGET_VERSION_SEMANTIC),)
    $(error Target semantic version is not set, cannot pursuit)
endif

# Makefile path management
PWD_TEMPLATE_BASE	:= $(dir $(lastword $(MAKEFILE_LIST)))
PWD_BSP 			:= $(PWD_TEMPLATE_BASE)/../../05-bsp/
PWD_LAYER			:= $(PWD_TEMPLATE_BASE)/../
PWD_LAYER_COMMON	:= $(PWD_LAYER)/02-common/
PWD_LAYER_LIBS		:= $(PWD_LAYER)/03-libs/
PWD_LAYER_APPS		:= $(PWD_LAYER)/04-apps/

# Board target
BOARD ?= default
ifeq ($(BOARD),raspberry)
	SDK_ROOT := $(PWD_BSP)/02-raspberry-bsp/01-sdk/aarch64-buildroot-linux-gnu_sdk-buildroot/
	SDK_CC_PATH := $(SDK_ROOT)/bin/
	SDK_SYSROOT := $(SDK_ROOT)/aarch64-buildroot-linux-gnu/sysroot/

	LAYER_DIR_INSTALL_LIB := $(PWD_LAYER_LIBS)/libs/board_raspberry/
	LAYER_DIR_INSTALL_APP := $(PWD_LAYER_APPS)/apps/board_raspberry/

	CFLAGS_BOARD := -DBOARD_RASPBERRY -DRUN=4 $(BOARD_RASPBERRY_CFLAGS)
	STACK_LIMIT_BOARD := 512

	CCPREFIX := $(SDK_CC_PATH)/aarch64-buildroot-linux-gnu-

	PATHS_LIBS_LIST_BOARD := $(BOARD_RASPBERRY_LIB_PATHS_LIST)
	LDLIBS_BOARD := $(BOARD_RASPBERRY_LDLIBS)

else ifeq ($(BOARD),arduino)
	SDK_ROOT := $(PWD_BSP)/01-arduino-bsp/01-sdk/arm-buildroot-linux-gnueabihf_sdk-buildroot/
	SDK_CC_PATH := $(SDK_ROOT)/bin/
	SDK_SYSROOT := $(SDK_ROOT)/arm-buildroot-linux-gnueabihf/sysroot/

	LAYER_DIR_INSTALL_LIB := $(PWD_LAYER_LIBS)/libs/board_arduino/
	LAYER_DIR_INSTALL_APP := $(PWD_LAYER_APPS)/apps/board_arduino/

	CFLAGS_BOARD := -DBOARD_ARDUINO $(BOARD_ARDUINO_CFLAGS)
	STACK_LIMIT_BOARD := 512

	CCPREFIX := $(SDK_CC_PATH)/arm-buildroot-linux-gnueabihf-

	PATHS_LIBS_LIST_BOARD := $(BOARD_ARDUINO_LIB_PATHS_LIST)
	LDLIBS_BOARD := $(BOARD_ARDUINO_LDLIBS)

else 
	SDK_ROOT :=
	SDK_CC_PATH :=
	SDK_SYSROOT :=

	LAYER_DIR_INSTALL_LIB :=
	LAYER_DIR_INSTALL_APP :=

	CFLAGS_BOARD := $(BOARD_OTHERS_CFLAGS)

	CCPREFIX :=

	PATHS_LIBS_LIST_BOARD := $(BOARD_OTHERS_LIB_PATHS_LIST)
	LDLIBS_BOARD := $(BOARD_OTHERS_LDLIBS)
endif

# Compiler
CC := gcc

# Sysroot flags
ifeq ($(SDK_ROOT),)
	CFLAGS_SYSROOT	    :=
else
	CFLAGS_SYSROOT	    :=	--sysroot=$(SDK_SYSROOT)
endif

# Compiler flags

CFLAGS_STANDARDS		:=	-D_GNU_SOURCE	# See https://www.gnu.org/software/libc/manual/html_node/Feature-Test-Macros.html
                            # -D_POSIX_C_SOURCE is also needed, but already set by -std=gnu<number_std>
                            # -std=gnu<number_std> needed but let at default value to get latest standard (currently set to -std=gnu17, see https://gcc.gnu.org/onlinedocs/gcc/Standards.html)

CFLAGS_WARNING			:=	-Wall -Wextra -Werror=format -Werror=return-type -Werror=implicit-function-declaration \
							-Wformat=2 -Wstrict-prototypes -Wshadow \
							-Wlogical-op -Wduplicated-cond -Wduplicated-branches \
							-Wno-ignored-qualifiers  \
							\
							-fdiagnostics-color=auto # -Werror -W -ansi -pedantic

CFLAGS_HEADERS_COMMON	:=	-I./include \
							-I$(PWD_LAYER_COMMON)/include

CFLAGS_HEADERS_SPECIFIC :=	$(addprefix -I, $(HEADERS_SPECIFIC_LIST))
CFLAGS_HEADERS_LAYER	:=	$(addprefix -I$(PWD_LAYER_LIBS), $(HEADERS_LAYER_LIST))
CFLAGS_HEADERS_SDK		:=	$(addprefix -I$(SDK_SYSROOT), $(HEADERS_SDK_LIST))

CFLAGS					:=	$(CFLAGS_SYSROOT) \
							$(CFLAGS_STANDARDS) \
							$(CFLAGS_WARNING) \
							\
							$(CFLAGS_HEADERS_COMMON) \
							$(CFLAGS_HEADERS_SPECIFIC) \
							$(CFLAGS_HEADERS_LAYER) \
							$(CFLAGS_HEADERS_SDK)

# Linker flags

LDFLAGS_LIBS_BOARD		:=	$(addprefix -L, $(PATHS_LIBS_LIST_BOARD))
LDFLAGS_LIBS_SPECIFIC	:=	$(addprefix -L, $(PATHS_LIBS_LIST_SPECIFIC))

LDFLAGS					:= 	-L. \
							$(LDFLAGS_LIBS_BOARD) \
							$(LDFLAGS_LIBS_SPECIFIC)

LDLIBS					:= 	$(LDLIBS_BOARD) \
							$(LDLIBS_SPECIFIC)

# Project directories
DIR_SRC := src
DIR_HDR := include
DIR_OBJ := obj
DIR_BIN := bin
DIR_DOC := documentation

# Project files
SRC := $(wildcard $(DIR_SRC)/*.c)
HDR := $(wildcard $(DIR_HDR)/*.h)
OBJ := $(SRC:$(DIR_SRC)/%.c=$(DIR_OBJ)/%.o)

# Debug information
ifeq ($(DEBUG), 1)
    CFLAGS += -g -DDEBUG
else
    CFLAGS += -Os
endif

# Analyze behaviour
ifeq ($(ANALYZE), 1)		# Use static analyzer
	CFLAGS += -fanalyzer
else ifeq ($(ANALYZE), 2) 	# Verify stack usage
	CFLAGS += -fstack-usage
	ifneq ($(STACK_LIMIT_BOARD),)
		CFLAGS += -Wstack-usage=$(STACK_LIMIT_BOARD)
	endif
endif

# Release information
BUILD_DATE := $(shell date +%s)
ifeq ($(RELEASE), 0)
	TARGET_VERSION := $(TARGET_VERSION_SEMANTIC)-$(BUILD_DATE)
else
	TARGET_VERSION := $(TARGET_VERSION_SEMANTIC)
endif

# Custom flags
CFLAGS_CUSTOM	:=	$(CFLAGS_BOARD) $(CFLAGS_TARGET)
CFLAGS 			+= 	$(CFLAGS_CUSTOM)

OPT_ADD_FLAGS_DETAILS ?= 0
ifeq ($(OPT_ADD_FLAGS_DETAILS), 1)
	CFLAGS		+=	-DAPP_FLAGS_DETAILS="\"$(CFLAGS_CUSTOM)\""
endif

# Version data build file
TARGET_VERSION_IN_FILE := version.in
TARGET_VERSION_IN_PATH := $(DIR_BIN)/$(TARGET_VERSION_IN_FILE)
TARGET_VERSION_IN_DATA := $(file <$(TARGET_VERSION_IN_PATH))

#
# Makefile "base" rules
#

.PHONY: clean realclean mrproper

clean:
	rm -f *.o
	rm -f *.su
	rm -f $(DIR_OBJ)/*.o
	rm -f $(DIR_OBJ)/*.su

realclean: clean
	rm -f $(DIR_BIN)/*

mrproper: realclean

version:
	@echo $(TARGET_NAME) v$(TARGET_VERSION_IN_DATA)

debug-base:
	@echo "Build target $(TARGET_NAME) ($(TARGET_VERSION_SEMANTIC))"
	@echo "List of C flags:"
	@echo $(CFLAGS)
	@echo "List of linker flags: $(LDFLAGS)"
	@echo "List of library linker flags: $(LDLIBS)"

compiler-option:
	$(CCPREFIX)$(CC) $(CCOPT)
