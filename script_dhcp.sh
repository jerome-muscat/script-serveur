#!/bin/bash

# paramètres de configuration
subnet=
netmask=
range_debut=
range_fin=

##  les paramètres suivant sont a décommenter et à modifier en fonction de si vous avez un DNS ou un routeur:
## Si vous décommenter la ligne "nom_domaine" et "ip_dns", alors il faut décommenter les lignes 48 et 49,
### DNS :
### nom_domaine=
### ip_dns=

## Si vous décommenter la ligne "ip_routeur", alors il faut décommenter les lignes 51,
### routeur :
### ip_routeur=


##  Le paramètres suivant dépendra de la version de l'IP :
### si la version de l'IP est IPv4 alors version= 4
### si la version de l'IP est IPv6 alors version= 6
version=

interface_reseau=

if [ $version = 4 ]
    then
    interface_reseau_nouveau="DHCPDv4_CONF=/etc/dhcp/dhcpd.conf\n\
                            INTERFACESv4=\"${interface_reseau}\""
elif [ $version = 6 ]
    then
    interface_reseau_nouveau="DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf\n\
                            INTERFACESv6=\"${interface_reseau}\""
fi

# installation des paquets
sudo apt update && sudo apt upgrade -y && sudo apt install isc-dhcp-server -y 

dhcp_conf=/etc/dhcp/dhcpd.conf
dhcp_interface=/etc/default/isc-dhcp-server

sudo chmod 777 $dhcp_conf
sudo chmod 777 $dhcp_interface

echo -e ";\n\
subnet $subnet netmask $netmask {\n\
    range $range_debut $range_fin;\n\
    # option domain-name-servers $ip_dns, www.$nom_domaine;\n\
    # option domain-name \"$nom_domaine\";\n\
    # option routers $ip_routeur;\n\
    default-lease-time 86600;\n\
    max-lease-time 72600;\n\
}" | sudo -a tee "$dhcp_conf" > /dev/null 

echo -e $interface_reseau_nouveau >> | sudo -a tee "$dhcp_interface" > /dev/null

sudo chmod 644 $dhcp_conf
sudo chmod 644 $dhcp_interface

sudo systemctl restart isc-dhcp-server
