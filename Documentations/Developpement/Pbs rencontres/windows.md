**Sommaire :**

- [1. Introduction](#1-introduction)
- [2. Réseau](#2-réseau)
  - [2.1. L'application sur certains PCs ne reçoit pas les notifications envoyées par le _Cobra_ : _start_stream_, _stop_stream_, etc...](#21-lapplication-sur-certains-pcs-ne-reçoit-pas-les-notifications-envoyées-par-le-cobra--start_stream-stop_stream-etc)
  - [2.2. Impossible de télécharger les fichiers présents sur un serveur FTP](#22-impossible-de-télécharger-les-fichiers-présents-sur-un-serveur-ftp)

# 1. Introduction

Dans ce fichier se trouve tous les problèmes rencontrés liés à l'OS **Windows**.

# 2. Réseau

## 2.1. L'application sur certains PCs ne reçoit pas les notifications envoyées par le _Cobra_ : _start_stream_, _stop_stream_, etc...

Après vérification avec l'outil _Wireshark_, le PC reçoit bien les trames UDP envoyées par l'appareil. Le soucis se trouve au niveau du **Pare-feu**. Lorsque l'on se connecte pour la première fois à un nouveau réseau Wifi via Windows, celui-ci pose la question suivante "_Voulez-vous autoriser les autres pc connectés à ce réseau vous détecter_", si l'on réponds OUI, le réseau est considéré comme sécurisé, il est reconnu comme un réseau **PRIVE** par Windows, sinon il est considéré comme un réseau **PUBLIC**

A partir de là, les autorisations de l'application liées au pare-feu dépendent directement de ces paramètres.

## 2.2. Impossible de télécharger les fichiers présents sur un serveur FTP

Lorsque l'on souhaite télécharger depuis un serveur FTP, on obtient l'erreur suivante : _Accès au réseau désactivé_.
Conditions dans lequel apparait le bug :
- L'application doit être compilée avec un kit Qt inférieur ou égal à `5.15.0`
- Le client ne doit pas avoir d'accès internet

Cause du bug :
- [QTBUG-85913](https://bugreports.qt.io/browse/QTBUG-85913) : lorsque l'on cherche à télécharger depuis un serveur qui ne dispose pas d'accès internet et que le client ne possède pas d'autres interfaces wifi connectée avec un accès internet, le bug se produit.

Solutions :
- Solution 1 (**recommandée**) : Recompiler l'application avec kit Qt supérieur ou égal à `5.15.1`
- Solution 2 (**workaround temporaire**) : S'assurer que la personne utilisant l'application dispose d'une seconde interface pouvant se connecter à un accès internet.