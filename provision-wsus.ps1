$ip = Get-NetIpAddress -InterfaceAlias "Ethernet" -AddressFamily IPv4
New-NetIPAddress -InterfaceIndex $ip.InterfaceIndex -IPAddress 192.168.0.2 -PrefixLength 24
Install-WindowsFeature UpdateServices -IncludeManagementTools
New-Item 'C:\WSUS' -ItemType Directory & 'C:\Program Files\Update Services\Tools\WsusUtil.exe' postinall CONTENT_DIR=C:\WSUS
$wsus = Get-WSUSServer
$wsusConfig = $wsus.GetConfiguration()
Set-WsusServerSynchronization -SyncFromMU
$wsusConfig.AllUpdateLanguagesEnabled = $false
$wsusConfig.setEnabledUpdateLanguages('en')
$wsusConfig.setEnabledUpdateLanguages('fr')
$wsusConfig.TargetingMode = 'Client'
$wsusConfig.Save()