#!/bin/bash

# paramètres de configuration
nom_machine=
adresse_ip_dns=
nom_domaine=

##  les paramètres suivant dépendront du masque réseau, par exemple :
### si le masque est 255.255.255.0 et l'IP est 192.168.1.1
### alors ip_machine = 1 et ip_inverse = 1.168.192
ip_machine=
ip_inverse=

# installation des paquets
sudo apt update && sudo apt upgrade -y && sudo apt install -y bind9 bind9utils dnsutils

dns_conf=/etc/bind

echo -e ";\n\
; BIND data file for local loopback interface\n\
;\n\
\$TTL    604800\n\
@       IN      SOA     $nom_domaine. $nom_machine.$nom_domaine. (\n\
                              2         ; Serial\n\
                         604800         ; Refresh\n\
                          86400         ; Retry\n\
                        2419200         ; Expire\n\
                         604800 )       ; Negative Cache TTL\n\
;\n\
@             IN      NS     $nom_machine.$nom_domaine.\n\
$nom_machine       IN      A      $adresse_ip_dns\n\
www           IN      CNAME  $nom_machine.$nom_domaine." | sudo tee "$dns_conf/db.$nom_domaine" > /dev/null

echo -e ";\n\
; BIND data file for local loopback interface\n\
;\n\
\$TTL    604800\n\
@       IN      SOA     $nom_domaine. $nom_machine.$nom_domaine. (\n\
                              2         ; Serial\n\
                         604800         ; Refresh\n\
                          86400         ; Retry\n\
                        2419200         ; Expire\n\
                         604800 )       ; Negative Cache TTL\n\
;\n\
@             IN      NS     $nom_machine.$nom_domaine..\n\
$nom_machine       IN      A      $adresse_ip_dns\n\
$ip_machine       IN      PTR  $nom_machine.$nom_domaine." | sudo tee "$dns_conf/inverse" > /dev/null

echo -e "zone \"$nom_domaine\" IN {\n\
       type master;\n\
       file \"$dns_conf/db.$nom_domaine\";\n\
};\n\
zone \"$ip_inverse.in-addr.arpa\" IN {\n\
       type master;\n\
       file \"$dns_conf/inverse\";\n\
};" | sudo tee "$dns_conf/named.conf.local" > /dev/null

echo -e "search $nom_domaine\n\
nameserver $adresse_ip_dns" | sudo tee "/etc/resolv.conf" > /dev/null

sudo systemctl restart bind9