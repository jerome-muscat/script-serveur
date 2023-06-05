#!/bin/bash

#ces comandes permettent de mettre à jour tous le système, d'installer tous les paquets proftpd.
#Elles permettent aussi d'installer les protocoles de sécurité openssl et openssh.
sudo apt update && sudo apt upgrade -y && sudo apt install proftpd* -y
sudo apt install openssl -y && sudo apt install openssh-server -y

#ces commandes permettent d'assigner une variable à un chemin d'accès à un fichier.
conf=/etc/proftpd/proftpd.conf

#chmod permet de modifier les droits, ici ce dernier donne tous les droits d'accès grâce à la valeur 777.
sudo chmod 777 $conf

#mkdir permet de créer un dossier
sudo mkdir /etc/proftpd/ssl

#openssl req permet ici de créer une clé utilisant le protocol RSA et de le certifié en l'autosignant.
sudo openssl req -x509 -days 30 -subj "/C=''/ST=''/L=''/CN=''/emailAddress=''" -nodes -newkey rsa:4096 -keyout /etc/proftpd/ssl/proftpd.key -out /etc/proftpd/ssl/proftpd.cert
 
#chmod ici permet de donner les droits d'écriture et de lecture à tous les utilisateurs pour les fichiers générés par la commande précédente
sudo chmod 666 /etc/proftpd/ssl/proftpd.key
sudo chmod 666 /etc/proftpd/ssl/proftpd.cert

#echo permet ici dafficher écrire un paragraphe, grâce aux deux chevrons de le redériger sans écraser le fichier cité.
echo -e "<Anonymous ~ftp>\n\
 User ftp\n\
 Group nogroup\n\
 UserAlias anonymous ftp\n\
 DirFakeUser on ftp\n\
 DirFakeGroup on ftp\n\
 RequireValidShell off\n\
 MaxClients 10\n\
  <Directory *>\n\
   <Limit WRITE>\n\
    DenyAll\n\
   </Limit>\n\
  </Directory>\n\
</Anonymous>\n\
\n\
LoadModule mod_tls.c\n\
\n\
TLSEngine on\n\
TLSRSACertificateFile /etc/proftpd/ssl/proftpd.cert\n\
TLSRSACertificateKeyFile /etc/proftpd/ssl/proftpd.key\n\
TLSOptions AllowClientRenegotiations\n\
TLSRequired off" >> $conf

#chmod permet ici de donnée le droit de lecture à tous les utilisateurs. Mais aussi, pour le propriétaire des documents, le droit d'écriture.
sudo chmod 644 $conf

#cette commande permet de faire redémarrer le service proftpd
sudo systemctl restart proftpd.service