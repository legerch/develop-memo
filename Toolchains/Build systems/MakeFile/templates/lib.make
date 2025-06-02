# ------------------------------------------------
# Generic Makefile to build libraries
# using a common base
# Date : 17/05/2023
# ------------------------------------------------#
# Please refer to included makefile for arguments details:
# - base.make
#
# Available command-line arguments:
# - DIR_INSTALL
#	Directory to used when using "install" rule.
#	By default, this directory is set to library layer directory
#
# Arguments to set when calling this Makefile from another:
# - No mandatory/optional arguments (besides those from included makefile)
# ------------------------------------------------

# Set default library goal
.DEFAULT_GOAL := all

# Include common makefile recipe
PWD_TEMPLATE_LIB := $(dir $(lastword $(MAKEFILE_LIST)))
include $(PWD_TEMPLATE_LIB)base.make

# Library install directory
DIR_INSTALL ?= $(LAYER_DIR_INSTALL_LIB)

# Library custom flags
CFLAGS += -DLIB_VERSION=\"$(TARGET_VERSION)\"

#
# Makefile rules
#

all: shared #static

$(DIR_OBJ)/%.o: $(DIR_SRC)/%.c | $(DIR_OBJ)
	$(CCPREFIX)$(CC) -c $< -o $@ $(CFLAGS) $(PICFLAG)

static: $(OBJ) | $(DIR_BIN)
	@echo "Generate static library $(TARGET_NAME).a"
	$(CCPREFIX)ar rvs $(DIR_BIN)/$(TARGET_NAME).a $(OBJ)
	$(CCPREFIX)ranlib $(DIR_BIN)/$(TARGET_NAME).a
	du -sh $(DIR_BIN)/$(TARGET_NAME).a

shared: $(OBJ) | $(DIR_BIN)
	@echo "Generate dynamic library $(DIR_BIN)/$(TARGET_NAME).so.$(TARGET_VERSION)"
	$(CCPREFIX)$(CC) -shared -o $(DIR_BIN)/$(TARGET_NAME).so.$(TARGET_VERSION) $(OBJ) $(LDFLAGS) $(LDLIBS)
	ln -sf $(TARGET_NAME).so.$(TARGET_VERSION) $(DIR_BIN)/$(TARGET_NAME).so
	du -sh $(DIR_BIN)/$(TARGET_NAME).so.$(TARGET_VERSION)
	@echo "Generate version file at : $(TARGET_VERSION_IN_PATH)"
	$(file >$(TARGET_VERSION_IN_PATH),$(TARGET_VERSION))

install_static:
	install -p -m 755 $(DIR_BIN)/$(TARGET_NAME).a $(DIR_INSTALL)

install_shared:
	install -p -m 755 $(DIR_BIN)/$(TARGET_NAME).so.$(TARGET_VERSION_IN_DATA) $(DIR_INSTALL)
	ln -sf $(TARGET_NAME).so.$(TARGET_VERSION_IN_DATA) $(DIR_INSTALL)/$(TARGET_NAME).so
	@echo "Don't forget to run 'ln -sf $(TARGET_NAME).so.$(TARGET_VERSION_IN_DATA) \
	$(TARGET_NAME).so' on '/usr/lib' from target after manual deployment \
	to allow the application to find dynamic library at execution !"

install: install_shared

send-lib:
	scp $(DIR_BIN)/$(TARGET_NAME).so.$(TARGET_VERSION_IN_DATA) $(TARGET_IDS):

debug-lib: debug-base
	@echo "Install directory: $(DIR_INSTALL)"
