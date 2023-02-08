netsh interface ipv4 set address "ethernet" dhcp
netsh interface ipv4 set dnsserver "ethernet" dhcp
Add-Computer -DomainName "marvelle.local"
Restart-Computer