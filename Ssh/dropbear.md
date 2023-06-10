# Utilisation de dropbear

## Configuration

1- Créer les clés privées/publiques  
Il est nécessaire de créer des clés d'authentification pour l'host, il existe deux méthodes de chiffrement pour le SSH : RSA et DSS.  
> Both kind of keys seem to be equally secure, but RSA seems to be faster for signature verification that is the most common operation when using the keys.

```shell
# Go to dropbear directory
cd /etc/dropbear

# Generate the RSA private and public keys.
$ dropbearkey -t rsa -f dropbear_rsa_host_key

# Generate the DSS private and public keys.
$ dropbearkey -t dss -f dropbear_dss_host_key
```

2- Démarrer le serveur dropbear
```shell
dropbear
```
> Note : Il est possible qu'un script d'initialisation soit existant si le système embarqué est construit via buildroot, on le trouve à l'emplacement : `/etc/init.d/S50dropbear`

## Utilisation

Utilisation des commandes ssh/scp classiques
```shell
# Connect from host (client) to target (server) using SSH.
# It will prompt for root's passwd.
$ ssh root@192.168.0.135

# Copy the file 'hola' from the host (client) to the directory /etc in the target (server).
# It will prompt for root's passwd.
$ scp hola root@192.168.0.135:/etc/hola
```

## Ressources utilisées

- Dropbear : https://paguilar.org/?p=30
- SSH: http://en.wikipedia.org/wiki/Secure_Shell
- Public-key cryptography: http://en.wikipedia.org/wiki/Public-key_cryptography