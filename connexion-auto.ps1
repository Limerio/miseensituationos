& netsh interface ipv4 set address "connexion au r�seau local" dhcp
& netsh interface ipv4 set dnsserver "connexion au r�seau local" dhcp
Rename-Computer -NewName "CPCO" 
Add-Computer -DomainName "marvelle.local" -Credential "Administrateur"
Restart-Computer


