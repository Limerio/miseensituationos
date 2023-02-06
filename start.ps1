#
# DÃ©finition de l'adresse ip sur l'interface Ethernet
#

$ip = Get-NetIpAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4
New-NetIPAddress -InterfaceIndex $ip.InterfaceIndex -IPAddress 192.168.0.1 -PrefixLength 24

#
# Fin de la dÃ©finition de l'adresse ip
#

#
# Ajout des services de domaines
#

Add-WindowsFeature AD-Domain-Services -IncludeManagementTools

#
# Fin de l'ajout des services de domaines
#

#
# DÃ©ploiment de la forÃªt
#

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
-NoRebootOnCompletion:$true `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true

#
# Fin du dÃ©ploiement de la forÃªt
#

#
# CrÃ©ation de la tÃ¢che aprÃ¨s redÃ©marrage
#

$action = New-ScheduledTaskAction -Execute "C:\Users\Administrateur.WIN-JVJI6HKCQAN\Desktop\init.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogon
$principal = New-ScheduledTaskPrincipal -UserId "MARVELLE\Administrateur"
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
Register-ScheduledTask -InputObject $task -TaskName "Init server"

#
# Fin de la crÃ©ation de la tÃ¢che
#

#
# RedÃ©marrage de la machine
#

Restart-Computer