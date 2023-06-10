# Exemple de script

Dans ce dossier sont réunis plusieurs exemples de scripts : 
- [Redirection des messages **stdout** et **stderr** vers un fichier de log](redirectStdToLog/ "Exemple de redirection") 

# Tips

Lire un fichier depuis un shell script :
```shell
printf "%s\n" "$(<${fileSrc})"

# Redirect to another file in same time
 printf "%s\n" "$(<${fileSrc})" >> "${fileDest}"
```

# Ressources

- https://unix.stackexchange.com/questions/86321/how-can-i-display-the-contents-of-a-text-file-on-the-command-line
- https://stackoverflow.com/questions/6212219/passing-parameters-to-a-bash-function
- https://unix.stackexchange.com/questions/432816/grab-id-of-os-from-etc-os-release
- https://unix.stackexchange.com/questions/13466/can-grep-output-only-specified-groupings-that-match/