# Scripts d'initialisation :

Les scripts doivent être nommés selon : _S[num][nom]_  
Les scripts sont lancés dans l'ordre numérique grâce au script _rcS_  

## Locations
```shell
cd /etc/init.d
```

## Squelette script

Exemple d'un script d'initialisation

```shell
#!/bin/sh
#
# BOREA        Starts BOREA - Exemple
#              - Exemple RP2
#


umask 077

start() {
    echo "Start BOREA - Exemple RP2" 

    # Via script shell - Load config file for camera
    ./home/ciele/tools/cmd_camera_v2.sh -l=/home/ciele/tools/config_camera.ini

    # Create process for application - RP2_core
    start-stop-daemon -b -S -q -m -p /var/run/rp2_core.pid --exec usr/bin/rp2_core

}

stop() {
    # Stop process
    start-stop-daemon -K -q -p /var/run/rp2_core.pid

	echo -n "Stop BOREA - Exemple"
}

restart() {
	stop
	start
}

case "$1" in
  start)
	start
	;;
  stop)
	stop
	;;
  restart|reload)
	restart
	;;
  *)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
esac

exit $?
```

- Détails :  
**start-stop-daemon** (Documentation disponible [ici](http://manpages.ubuntu.com/manpages/xenial/fr/man8/start-stop-daemon.8.html))  
    -S : start  
    -K : stop  
    -b : run app in background  
    -q : mode **quiet**, n'affiche pas les messages d'informations, seulement les messages d'erreurs  
    -m : Permet de créer un pid associé  
    -p : Permet de vérifier que le processus a bien été associé à un pid  

