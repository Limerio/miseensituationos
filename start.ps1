$ip = Get-NetIpAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4
New-NetIPAddress -InterfaceIndex $ip.InterfaceIndex -IPAddress 192.168.0.1 -PrefixLength 24
Add-WindowsFeature AD-Domain-Services -IncludeManagementTools

Import-Module ADDSDeployment

Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "marvelle.local" `
-DomainNetbiosName "MARVELLE" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true