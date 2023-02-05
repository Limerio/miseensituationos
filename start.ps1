New-NetIPAddress -InterfaceIndex 3 -IPAddress 192.168.0.1 -PrefixLength 24
Install-WindowsFeature DNS
Install-WindowsFeature DHCP
Add-WindowsFeature AD-Domain-Services

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

