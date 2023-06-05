#!/bin/bash

# liste d'utilisateurs :
## Forme par exemple : ("user1" "user2" "user3")
utilisateurs=()
mdp=

# si les utilisateurs sont dans un fichier csv :
#cat /home/jerome/GitHub/FTP/fichier.csv | while read Id Prenom Nom Mdp Role	
	do
	sudo useradd -m $Prenom-$Nom
        echo "$Prenom-$Nom:$Mdp" | sudo chpasswd
        sudo usermod -u $Id "$Prenom-$Nom"
                if [ $Role = "Admin" ]
                then
                sudo usermod -aG sudo "$Prenom-$Nom"
                fi
        done

for utilisateur in ${utilisateurs[*]};
do
    sudo useradd -m $utilisateur
    echo $utilisateur:$mdp | sudo chpasswd
    echo -e "<Directory /home /$utilisateur>\n\
        Umask 022\n\
        AllowOverwrite off\n\
        <Limit LOGIN>\n\
            AllowUser $utilisateur\n\
            DenyAll\n\
        </Limit>\n\
        <Limit ALL>\n\
            AllowUser $utilisateur\n\
            DenyAll\n\
        </Limit>\n\
    </Directory>" >> /etc/proftpd/proftpd.conf
done

