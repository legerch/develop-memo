# ------------------------------------------------
# Generic Makefile used to execute Makefiles
# of multiple subdirectories
# Date : 17/05/2023
# ------------------------------------------------
# Note than this makefile will make "available", arguments from
# included subdirectories makefiles.
#
# Available command-line arguments of this template:
# - SILENT
# Set to "1" to disable any output on stdout/stderr.
# By default, this value is set to "0"
# - BOARD
# Set to "default" by default.
# If set to "arduino" : SDK for board Arduino will be used (cross-compiler + sysroot).
# If set to "raspberry" : SDK for board Raspberry will be used (cross-compiler + sysroot)
# Others : GCC host compiler will be used, with default GCC sysroot value
# ------------------------------------------------
# Arguments to set when calling this Makefile from another:
#
# - Mandatories:
# 	- TARGETS_LIST
#	List of rule target that can be used (example: "all", "clean", "install", etc...).
#	This value must not contains any '/' characters (otherwise, no action will be performed)
#
# - Optionals:
#	- BOARD_<name-board>_LIST_SUBDIRS: List of subdirectories to use, specific to a supported board
#	- LIST_SUBDIRS_COMMON: List of subdirectories to use, will be available for any board
# ------------------------------------------------

# Optional argument
SILENT	?= 0

# Board target
BOARD ?= default
ifeq ($(BOARD),raspberry)
	LIST_SUBDIRS_BOARD	:=	$(BOARD_RASPBERRY_LIST_SUBDIRS)

else ifeq ($(BOARD),arduino)
	LIST_SUBDIRS_BOARD	:=	$(BOARD_ARDUINO_LIST_SUBDIRS)

else
	LIST_SUBDIRS_BOARD	:=	$(BOARD_OTHERS_LIST_SUBDIRS)

endif

# Set subdirectories to make
LIST_SUBDIRS :=	$(LIST_SUBDIRS_BOARD) \
				$(LIST_SUBDIRS_COMMON)

# Verify than list of targets has been set
ifeq ($(TARGETS_LIST),)
    $(error "List of targets is empty, cannot pursuit")
endif

# Verify than list of targets is valid
ifneq ($(findstring /,$(TARGETS_LIST)),)
    $(error "List of targets contains '/' character, cannot pursuit")
endif

# Build all subdirectories targets
# Example:
# For subdirs list: "foo" and "bar"
# For targets list: "all", "clean"
# This will generate targets:
# 	"foo/.all" "foo/.clean" "bar/.all" "bar/.clean"
TARGETS_SUBDIRS := 	$(foreach TARGET,$(TARGETS_LIST), 			\
						$(addsuffix $(TARGET),$(LIST_SUBDIRS))	\
					)

#
# Makefile "subdirectories" rules
#

.PHONY: $(TARGETS_LIST) $(TARGETS_SUBDIRS)

# Static pattern rule, expands into:
# all clean: %: foo/.% bar/.%
$(TARGETS_LIST): %: $(addsuffix %,$(LIST_SUBDIRS))
ifneq ($(SILENT),1)
	@echo 'Done "$*" target'
endif

# Here, for foo/.all:
#   $(@D) is "foo"
#   $(@F) is ".all", with leading period
#   $(@F:.%=%) is just "all"
$(TARGETS_SUBDIRS) :
	$(MAKE) -C $(@D) $(@F:.%=%)