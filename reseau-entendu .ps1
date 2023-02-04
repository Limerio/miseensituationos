$Error.Clear()
try{Add-DhcpServerv4Scope -Name "projet" -StartRange 192.168.0.1 -EndRange 192.168.0.150 -SubnetMask 255.255.255.0}
catch{Write-Warning "there is already a reseau with this range"}
if(!$Error){

Add-DhcpServerv4ExclusionRange -ScopeId 192.168.0.0 -StartRange 192.168.0.1 -EndRange 192.168.0.10
Set-DhcpServerv4OptionDefinition -OptionId 3 -DefaultValue 192.168.0.254
#the dns server is optionId 6
Set-DhcpServerv4OptionDefinition -OptionId 6 -DefaultValue 192.168.0.253
Set-DhcpServerv4Scope -ScopeId 192.168.0.0 -Name "projet" -State Active
Write-Host "the reseau etendu a ete cree" -ForegroundColor Green
}

 
