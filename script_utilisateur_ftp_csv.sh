#!/bin/bash

# chemin du fichier csv contenant les utilisateurs
fichier_utilisateur_csv=

cat $fichier_utilisateur_csv | while read Prenom Nom Mdp Role	
	do
	sudo useradd -m $Prenom-$Nom
    echo "$Prenom-$Nom:$Mdp" | sudo chpasswd
        if [ $Role = "Admin" ]
            then
            sudo usermod -aG sudo "$Prenom-$Nom"
        fi
    echo -e "<Directory /home /$Prenom-$Nom>\n\
        Umask 022\n\
        AllowOverwrite off\n\
        <Limit LOGIN>\n\
            AllowUser $Prenom-$Nom\n\
            DenyAll\n\
        </Limit>\n\
        <Limit ALL>\n\
            AllowUser $$Prenom-$Nom\n\
            DenyAll\n\
        </Limit>\n\
    </Directory>" >> /etc/proftpd/proftpd.conf
    done