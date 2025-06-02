# ------------------------------------------------
# Credential Makefile use to store private credentials
# Date : 26/03/2024
# ------------------------------------------------
# Memo debug Makefile :
# From https://www.gnu.org/software/make/manual/make.html#Make-Control-Functions
# $(error   VAR is $(VAR))
# $(warning VAR is $(VAR))
# $(info    VAR is $(VAR))
# ------------------------------------------------
# Available command-line arguments:
#  - No commands-line args (besides those from included makefile)
# ------------------------------------------------
# Arguments to set when calling this Makefile from another (besides those from included makefile):
# - Mandatories:
#	- No mandatory argument for this specific template available
#
# - Optionals:
#	- No optional argument for this specific template available
# ------------------------------------------------
# Developer notes:
# - No notes
# ------------------------------------------------

# Set credentials
TARGET_USER		:= 	myuser
TARGET_IP		:= 	168.8.8.8
TARGET_DGB_PORT	:=	2000

# Create useful variables
TARGET_IDS	:= $(TARGET_USER)@$(TARGET_IP)