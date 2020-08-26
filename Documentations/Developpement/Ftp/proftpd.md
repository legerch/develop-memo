# Proftpd

Proftpd permet de gérer un serveur FTP.

## Configuration

1- Editer le fichier `/etc/proftpd.conf` de façon à n'autoriser que les groupes spécifiés, l'authentification anonyme est ainsi désactivée :
```apacheconf
# This is a basic ProFTPD configuration file (rename it to 
# 'proftpd.conf' for actual use.  It establishes a single server
# and a single anonymous login.  It assumes that you have a user/group
# "nobody" and "ftp" for normal operation and anon.

ServerName			"Borea ProFTPD"
ServerType			standalone
DefaultServer		on

# Port 21 is the standard FTP port.
Port				21

# Permit root user logins. Default : off
RootLogin off

# TimeoutLogin default is 300. Sets the login timeout
TimeoutLogin 60
 
# Don't use IPv6 support by default.
UseIPv6				off

# Umask 022 is a good standard umask to prevent new dirs and files
# from being group and world writable.
Umask				022

# To prevent DoS attacks, set the maximum number of child processes
# to 30.  If you need to allow more than 30 concurrent connections
# at once, simply increase this value.  Note that this ONLY works
# in standalone mode, in inetd mode you should use an inetd server
# that allows you to limit maximum number of processes per service
# (such as xinetd).
MaxInstances			30

# Set the user and group under which the server will run.
User				nobody
Group				nogroup

# To cause every FTP user to be "jailed" (chrooted) into their home
# directory, uncomment this line.
DefaultRoot ~

# Normally, we want files to be overwriteable.
AllowOverwrite		on

# Bar use of SITE CHMOD by default
<Limit SITE_CHMOD>
  DenyAll
</Limit>

# Limit login access to members of specified group
<Limit LOGIN>
    AllowGroup ftpborea
    DenyAll
</Limit>

# Legacy FTP servers generally check a special authorization file (typically /etc/ftpusers) when a client attempts to authenticate.
# If the user's name is found in this file, FTP access is denied. For compatibility sake, proftpd defaults to checking this file during authentication. 
# This behavior can be suppressed using the UseFtpUsers configuration directive.
<Global>
  UseFtpUsers on
</Global>
```

2- Redémarrer le serveur FTP :
```shell
# Basic Linux OS
/etc/init.d/S50proftpd restart

# Modern Linux OS
systemctl reload proftpd
```

4- Limiter l'accès du/des groupes autorisé(s) définis dans le fichier `/etc/proftpd.conf`  
Le fichier `/etc/shells` référence les Shell du système, on va créer un faux Shell (car il pointe vers un binaire qui n'existe pas) en indiquant `/bin/false` pour l'attribuer ensuite à notre utilisateur FTP. L'intérêt de cette manipulation, c'est que l'utilisateur ne pourra pas se connecter en shell sur le serveur, il peut donc seulement utiliser l'accès FTP. Ainsi :
```shell
echo "/bin/false" >> /etc/shells
```

5- Créer le(s) groupe(s) autorisé(s)
```shell
addgroup ftpborea
```

6- Créer le(s) utilisateur(s)
```shell
adduser userborea --shell /bin/false --home /home/user_data --ingroup ftpborea
```
> `--shell` : Permet de préciser quel console l'utilisateur utilise. Ici, on ne souhaite que l'user n'est un accès seulement par FTP (non en SSH par exemple), ainsi, le shell précisé est `bin/false`  
> --home : Utiliser le dossier spécifié comme dossier HOME de l'utilisateur. Si le dossier n'existe pas, il sera créé  
> --ingroup : Spécifie le groupe auquel l'utilisateur appartient  
  
La configuration est désormais complète !  

## Utilisation

Pour accéder au serveur FTP, ouvrir un client FTP (_Filezilla_ par exemple) et renseigner les identifiants nécessaires.

## Cas particulier : configuration dans le cadre de buildroot pour les prochains build _rootfs_

Il n'est pas possible d'utiliser la commande `addgroup` ou `adduser` dans les post-scripts buildroot car cela appelerai ceux de la machine hôte et non le système de fichiers cible.

Ainsi, plusieurs fichiers sont à placer dans le _buildroot's rootfs skeleton_ ou les _overlays_ une fois la configuration "classique" effectuée sur une carte :
- `/etc/group` : https://www.cyberciti.biz/faq/understanding-etcgroup-file/
- `/etc/passwd` : https://www.cyberciti.biz/faq/understanding-etcpasswd-file-format/
- `/etc/shadow` : https://www.cyberciti.biz/faq/understanding-etcshadow-file/
- `/etc/shells` : https://bash.cyberciti.biz/guide//etc/shells

Ensuite, il est également nécessaire d'ajouter le `$HOME_DIRECTORY` associé à l'utilisateur

## Ressources utilisées

- http://www.proftpd.org/docs/directives/linked
- https://www.techrepublic.com/article/lock-it-down-set-up-a-secure-ftp-server-with-proftpd/
- https://facemweb.com/creation-site-internet/proftpd-serveur-ftp
- https://www.it-connect.fr/debian-9-configurer-un-serveur-ftp-avec-proftpd/
- http://manpages.ubuntu.com/manpages/focal/en/man8/adduser.8.html
- http://www.armadeus.org/wiki/index.php?title=Adding_users
