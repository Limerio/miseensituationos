$ip = Get-NetIpAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4
New-NetIPAddress -InterfaceIndex $ip.InterfaceIndex -IPAddress 192.168.0.2 -PrefixLength 24
Install-WindowsFeature UpdateServices -IncludeManagementTools
New-Item 'C:\WSUS' -ItemType Directory 
wsusutil postinstall CONTENT_DIR=C:\WSUS
$wsus = Get-WSUSServer
$wsusConfig = $wsus.GetConfiguration()
Set-WsusServerSynchronization -SyncFromMU
$wsusConfig.AllUpdateLanguagesEnabled = $false
$wsusConfig.setEnabledUpdateLanguages('fr')
$wsusConfig.Save()
$wsusConfig.TargetingMode = 'Client'
$wsusConfig.Save()
$subscription = $wsus.GetSubscription()
$subscription.StartSynchronizationForCategoryOnly()
$wsusConfig.OobeInitialized = $true
$wsusConfig.Save()
Get-WsusProduct | Where-Object {$_.Product.Title -ne "Windows Server 2016 R2"} | Set-WsusProduct -Disable
Get-WsusProduct | Where-Object {$_.Product.Title -eq "Windows Server 2016 R2"} | Set-WsusProduct
Get-WsusClassification | Where-Object {$_.Classification.Title -notin 'Update Rollups', 'Security Updates', 'Critical Updates', 'Updates', 'Services Packs'} | Set-WsusClassification -Disable
Get-WsusClassification | Where-Object {$_.Classification.Title -notin 'Security Updates', 'Critical Updates', 'Updates'} | Set-WsusClassification
$subscription.StartSynchronization()
$subscription.GetSynchronizationProgress()
$subscription.GetSynchronizationStatus()
$wsus.CreateComputerTargetGroup('Servers')
$group = $wsus.GetComputerTargetGroups() | ? {$_.Name -eq "Servers"}
$wsus.CreateComputerTargetGroup("General", $group)

Import-Module WebAdministration
Set-ItemProperty IIS:\AppPools\WsusPool -Name recycling.periodicrestart.privateMemory -Value 21000
$time = New-TimeSpan -Hours 4
Set-ItemProperty IIS:\AppPools\WsusPool -Name recycling.periodicrestart.time -Value $time
Restart-WebAppPool -Name WsusPool