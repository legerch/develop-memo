**Sommaire**

- [1. Configuration d'une IP statique](#1-configuration-dune-ip-statique)
  - [1.1. Windows](#11-windows)
  - [1.2. Linux](#12-linux)
  - [1.3. Android](#13-android)
- [2. Contrôle des paramètres WIFI via les API systèmes](#2-contrôle-des-paramètres-wifi-via-les-api-systèmes)
  - [2.1. API système](#21-api-système)
  - [2.2. Solution existante](#22-solution-existante)

# 1. Configuration d'une IP statique

## 1.1. Windows

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

## 1.2. Linux

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

## 1.3. Android

Une adresse statique est affectée pour un réseau (comme sous linux), cela n'affectera pas les autres connexions.

1. Ouverture paramètre wifi pour lequel on souhaite se connecter
2. Configurer les paramètres wifi :
   1. Proxy : **Aucun**
   2. Paramètres IP : `statique`
   3. Adresse IP : `192.168.0.157`
   4. Longueur du préfixe réseau : `24` (c'est le _mask_ réseau : `/24` étant équivalent à `255.255.255.0`)
   5. Passerelle : `192.168.0.5` (ici, on utilise l'adresse hôte car c'est un champs obligatoire mais on ne s'en sert pas)
   6. DNS 1 : `8.8.8.8` (de même, champs obligatoire donc utilisation du _DNS Google_)
3. Valider la configuration

# 2. Contrôle des paramètres WIFI via les API systèmes

## 2.1. API système

- Windows : 
  - [WlanAPI][wlanapi] : Permet le contrôle des réseaux wifi (scan, connexion, déconnexion, création profil, etc...) 
  - [IpHelperAPI][iphelperapi] : Permet d'obtenir le contrôle des cartes réseaux (ou interfaces) installées (adresse MAC, compatible IpV4/IpV6, etc...) 
- Mac OSX : 
  - [CoreWlan][corewlan] : Permet d'obtenir le contôle des cartes réseaux installées et de gérer les réseaux wifi
- Linux : 
  - DBus
  
## 2.2. Solution existante

Une API a été créée dans le but de gérer les actions relatives au WIFI (obtenir les propriétés des interfaces réseaux, scanner les réseaux, se connecter à un réseau connu/inconnu, etc...). Cette API a pour but d'utiliser les API systèmes sans se soucier du système sur lequel l'on tourne, l'API est compatible :
- Windows
- Mac OSX (prévu, non développée pour le moment)
- Linux (prévu, non dévéloppée pour le moment)

L'API est disponible sous le nom [wlan-manager][repo-wlan-manager].   
Elle possède des dépendances au framework Qt (notammement pour son système de signal/slot).

<!-- Borea links -->
[repo-wlan-manager]: https://github.com/BOREA-DENTAL/WlanManager-library

<!-- External links -->
[wlanapi]: https://docs.microsoft.com/fr-fr/windows/win32/nativewifi/native-wifi-functions?redirectedfrom=MSDN
[iphelperapi]: https://docs.microsoft.com/fr-fr/windows-hardware/drivers/network/ip-helper
[corewlan]: https://developer.apple.com/documentation/corewlan?language=objc