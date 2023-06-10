#!/bin/sh

LOGFILE=logfile.txt

# ----------------------------------------------------------- #
# Redirect stdout and stderr
# ----------------------------------------------------------- #

exec 6>&1           # Link file descriptor #6 with stdout.

exec 1<>$LOGFILE	# stdout replaced with logfile.
exec 7<&2			# saves stderr to file descriptor #6
exec 2>&1 			# stderror to stdout

# ----------------------------------------------------------- #
# All output from commands in this block sent to file $LOGFILE.
# ----------------------------------------------------------- #

# On stdout
echo -n "Logfile: "
date
echo "-------------------------------------"
echo

echo "Output of \"ls -al\" command"
echo
ls -al
echo; echo
echo "Output of \"df\" command"
echo
df

# On sterr
echo "\nOutput of error : cat lala.txt"
cat lala.txt
echo

# ----------------------------------------------------------- #
# Restore stdout and stderr
# ----------------------------------------------------------- #

exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.
exec 2>&7 7>&-

# ----------------------------------------------------------- #
# All output from commands in this block display on terminal.
# ----------------------------------------------------------- #

# On stdout
echo "\n== stdout now restored to default == \n"
ls -al
echo

# On stderr
cat lala.txt

# End
exit 0
