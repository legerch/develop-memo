# Problèmes rencontrés - Windows

Dans ce fichier se trouve tous les problèmes rencontrés liés à l'OS **Windows**

## Réseau

1 - L'application sur certains PCs ne reçoit pas les notifications envoyées par le _Cobra_ : _start_stream_, _stop_stream_, etc...

Après vérification avec l'outil _Wireshark_, le PC reçoit bien les trames UDP envoyées par l'appareil. Le soucis se trouve au niveau du **Pare-feu**. Lorsque l'on se connecte pour la première fois à un nouveau réseau Wifi via Windows, celui-ci pose la question suivante "_Voulez-vous autoriser les autres pc connectés à ce réseau vous détecter_", si l'on réponds OUI, le réseau est considéré comme sécurisé, il est reconnu comme un réseau **PRIVE** par Windows, sinon il est considéré comme un réseau **PUBLIC**

A partir de là, les autorisations de l'application liées au pare-feu dépendent directement de ces paramètres.