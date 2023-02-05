#
# Définition de l'adresse ip sur l'interface Ethernet
#

$ip = Get-NetIpAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4
New-NetIPAddress -InterfaceIndex $ip.InterfaceIndex -IPAddress 192.168.0.1 -PrefixLength 24

#
# Fin de la définition de l'adresse ip
#

#
# Ajout des services de domaines
#

Add-WindowsFeature AD-Domain-Services -IncludeManagementTools

#
# Fin de l'ajout des services de domaines
#

#
# Déploiment de la forêt
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
# Fin du déploiement de la forêt
#

#
# Création de la tâche après redémarrage
#

$action = New-ScheduledTaskAction -Execute "./init.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogon
$principal = "MARVELLE\Administrator"
$settings = New-ScheduledTaskSettingsSet
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings
Register-ScheduledTask T1 -InputObject $task -TaskName "Init server"

#
# Fin de la création de la tâche
#

#
# Redémarrage de la machine
#

Restart-Computer