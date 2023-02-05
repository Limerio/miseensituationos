$Error.Clear()
try{Add-DhcpServerv4Scope -Name "projet" -StartRange 192.168.0.1 -EndRange 192.168.0.150 -SubnetMask 255.255.255.0}
catch{Write-Warning "there is already a reseau with this range"}
if(!$Error){

Add-DhcpServerv4ExclusionRange -ScopeId 192.168.0.0 -StartRange 192.168.0.1 -EndRange 192.168.0.10
Set-DhcpServerv4OptionValue -ScopeId 192.168.0.0 -DnsServer 192.168.0.1 -DnsDomain "marvelle.local" -Router 192.168.0.254 
Set-DhcpServerv4Scope -ScopeId 192.168.0.0 -Name "projet" -State Active
Write-Host "the reseau etendu a ete cree" -ForegroundColor Green
}

 
