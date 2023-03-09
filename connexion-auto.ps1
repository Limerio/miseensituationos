$Error.Clear()
netsh interface ipv4 set address "ethernet" dhcp
netsh interface ipv4 set dnsserver "ethernet" dhcp
Rename-Computer -NewName "CPCO1"
if(!$Error){
Add-Computer -DomainName "marvelle.local"
}
Restart-Computer
