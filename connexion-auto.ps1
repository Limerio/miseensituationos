netsh interface ipv4 set address "connexion au réseau local" dhcp
netsh interface ipv4 set dnsserver "connexion au réseau local" dhcp
Add-Computer -DomainName "marvelle.local"
Restart-Computer