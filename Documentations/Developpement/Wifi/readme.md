**Sommaire**

- [Configuration d'une IP statique](#configuration-dune-ip-statique)
  - [Windows](#windows)
  - [Linux](#linux)
- [Contrôle des paramètres WIFI via les API systèmes](#contrôle-des-paramètres-wifi-via-les-api-systèmes)
  - [API système](#api-système)
  - [Solution existante](#solution-existante)

# Configuration d'une IP statique

## Windows

1. Aller dans `Panneau de configuration` -> `Réseau et internet` -> `Centre réseau et partage` -> `Modifier les paramètres de la carte`
2. Clic droit sur la carte réseau souhaitée -> `Propriétés`
3. Sélectionner la ligne `Protocole TCP/IPV4` (**ne pas la décocher !**) -> cliquer sur `Propriétés`
4. Sélectionner _"Utiliser l'adresse IP suivante"_ puis renseigner les informations :
   1. IP : `192.168.0.157`
   2. Masque : `255.255.255.0`
   3. Passerelle : Peut être vide
5. Valider la configuration

L'addrese statique est désormais configurée pour toute l'interface, sous windows, il est possible que si une nouvelle interface est ajoutée, ces options de configurations soient effacées.  
Il faudra donc réitérer la procédure.  

De plus, la configuration sera appliquée pour tous les réseaux auxquels l'interface se connectera.

> Pour obtenir la configuration IP actuelle, on peut utiliser la commande
> ```shell
> ipconfig
> ```

## Linux

Sous linux, une configuration est associée à une interface et à un réseau, c'est à dire qu'il est possible pour une même interface de se connecter à un réseau A via DHCP et à un réseau B via une adresse IP statique, ce qui n'est pas le cas sous windows.

1. Se connecter une première fois au réseau souhaité (la configuration ne peut pas se faire si le mot de passe n'a pas été entré, c'est pourquoi on se connecte une 1ere fois automatiquement)
2. Cliquer sur l'icône `Paramètre` représenté par une _roulette_
3. Aller dans l'onglet `IPV4`
4. Sélectionner pour la **méthode IPv4** l'option `Manuel`
5. Configurer l'adresse a utiliser :
   1. IP : `192.168.0.157`
   2. Masque : `255.255.255.0`
   3. Passerelle : Peut être vide
6. Valider la configuration

> Pour obtenir la configuration IP actuelle, on peut utiliser la commande
> ```shell
> ifconfig
> ```

# Contrôle des paramètres WIFI via les API systèmes

## API système

- Windows : [WlanAPI](https://docs.microsoft.com/fr-fr/windows/win32/nativewifi/native-wifi-functions?redirectedfrom=MSDN)
- Mac OSX : [CoreWlan](https://developer.apple.com/documentation/corewlan?language=objc)
- Linux : DBus
  
## Solution existante

Une API a été créée dans le but de gérer les actions relatives au WIFI (scanner les réseaux, se connecter à un réseau connu/inconnu, etc...). Cette API a pour but d'utiliser les API systèmes sans se soucier du système sur lequel l'on tourne, l'API est compatible :
- Windows
- Mac OSX (prévu, non développée pour le moment)
- Linux (prévu, non dévéloppée pour le moment)

L'API est disponible à l'adresse suivante : https://github.com/BOREA-DENTAL/API-Wifi  
Elle possède des dépendances au framework Qt (notammement pour son système de signal/slot).