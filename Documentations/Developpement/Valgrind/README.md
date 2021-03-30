# Readme under construction - To complete

https://stackoverflow.com/questions/2375726/how-do-you-tell-valgrind-to-completely-suppress-a-particular-so-file/4226706#4226706
https://wiki.wxwidgets.org/Valgrind_Suppression_File_Howto
https://wiki.wxwidgets.org/Parse_valgrind_suppressions.sh

https://stackoverflow.com/questions/56218885/how-to-get-rid-of-the-memory-leaks-in-third-party-frameworkgstreamer
-> GLib : /usr/share/glib-2.0/valgrind/glib.supp

```shell
valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes -s --suppressions=rp2_core-vg.suppr --suppressions=glib.supp ./rp2_core
```

```shell
cat fileToFilter.log | ./vg-parse-suppressions.sh
```
