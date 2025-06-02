# ------------------------------------------------
# Generic Makefile to build applications
# using a common base
# Date : 17/05/2023
# ------------------------------------------------
# Please refer to included makefile for arguments details:
# - base.make
#
# Available command-line arguments:
# - DIR_INSTALL
#	Directory to used when using "install" rule.
#	By default, this directory is set to application layer directory
#
# Arguments to set when calling this Makefile from another (besides those from included makefile):
# - Mandatories:
#	- No mandatory argument for this specific template available
#
# - Optionals
# 	- OPT_LDFLAGS_USE_LAYER_DIR_LIB
#	Set to "1" to search libraries binaries from the layer.
#	By default, this value is set to "0"
# ------------------------------------------------

# Set default application goal
.DEFAULT_GOAL := all

# Include common makefile recipe
PWD_TEMPLATE_APP := $(dir $(lastword $(MAKEFILE_LIST)))
include $(PWD_TEMPLATE_APP)base.make

# Application install directory
DIR_INSTALL ?= $(LAYER_DIR_INSTALL_APP)

# Dependant libraries paths
OPT_LDFLAGS_USE_LAYER_DIR_LIB ?= 0
ifeq ($(OPT_LDFLAGS_USE_LAYER_DIR_LIB), 1)
	LDFLAGS +=	$(addprefix -L, $(LAYER_DIR_INSTALL_LIB))
endif

# Application custom flags
CFLAGS += -DAPP_VERSION=\"$(TARGET_VERSION)\"

#
# Makefile rules
#

all: $(TARGET_NAME)

$(TARGET_NAME): $(OBJ) | $(DIR_BIN)
	@echo "Generate binary application"
	$(CCPREFIX)$(CC) -o $(DIR_BIN)/$@ $^ $(LDFLAGS) $(LDLIBS)
	@echo "Generate version file at : $(TARGET_VERSION_IN_PATH)"
	$(file >$(TARGET_VERSION_IN_PATH),$(TARGET_VERSION))

$(DIR_OBJ)/%.o: $(DIR_SRC)/%.c | $(DIR_OBJ)
	@echo "Generate objects"
	$(CCPREFIX)$(CC) -o $@ -c $< $(CFLAGS)

install:
	install -p -m 755 $(DIR_BIN)/$(TARGET_NAME) $(DIR_INSTALL)

send-app:
	scp $(DIR_BIN)/$(TARGET_NAME) $(TARGET_IDS):

debug-app: debug-base
	@echo "Install directory: $(DIR_INSTALL)"

debug-run:
	$(CCPREFIX)$(CCDB) -ex "target remote $(TARGET_IP):$(TARGET_DGB_PORT)" $(DIR_BIN)/$(TARGET_NAME)
