Set-NetIPAddress -InterfaceIndex 3 -IPAddress 192.168.0.1
Install-WindowsFeature DNS
Install-WindowsFeature DHCP
Add-WindowsFeature AD-Domain-Services