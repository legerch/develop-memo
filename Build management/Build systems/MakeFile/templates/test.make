# ------------------------------------------------
# Generic Makefile to build test applications
# using a common base
# This will set dependency to test library/framework
# Date : 17/05/2023
# ------------------------------------------------
# Please refer to included makefile for arguments details:
# - app.make
#
# Available command-line arguments:
# - No commands-line args (besides those from included makefile)
#
# Arguments to set when calling this Makefile from another:
# - No mandatory/optional arguments (besides those from included makefile)
# ------------------------------------------------

# Set default target informations
TARGET_VERSION_SEMANTIC		?=	0.0.1

# Set test application needed headers
HEADERS_SPECIFIC_LIST 		+=	../../utest/include

# Set test application linking libraries paths
PATHS_LIBS_LIST_SPECIFIC	+=	../../utest/bin/

# Set test application needed libraries
LDLIBS_SPECIFIC				+=	-lutest

# Call generic application makefile
PWD_TEMPLATE_TEST := $(dir $(lastword $(MAKEFILE_LIST)))
include $(PWD_TEMPLATE_TEST)app.make