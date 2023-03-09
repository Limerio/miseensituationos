#
# Installation du réseau entendu
#

$Error.Clear()
try {
	Add-DhcpServerv4Scope -Name "Marvelle" -StartRange 192.168.0.1 -EndRange 192.168.0.150 -SubnetMask 255.255.255.0
}
catch {
	Write-Warning "Il y a déjà une étendu"
}

if (!$Error) {
	Add-DhcpServerv4ExclusionRange -ScopeId 192.168.0.0 -StartRange 192.168.0.1 -EndRange 192.168.0.10
	Set-DhcpServerv4OptionValue -ScopeId 192.168.0.0 -DnsServer 192.168.0.1 -DnsDomain "marvelle.local" -Router 192.168.0.254 
	Set-DhcpServerv4Scope -ScopeId 192.168.0.0 -Name "marvelle-scope" -State Active
	Add-DnsServerPrimaryZone -NetworkId "192.168.0.0/24" -ZoneFile "168.192.marvelle.local" -DynamicUpdate NonsecureAndSecure
	Write-Host "Le réseau étendu a été créer" -ForegroundColor Green
}

#
# Fin de l'ajout du réseau entendu
#

Import-Module ActiveDirectory

# 
# Creation des UnitÃ©s d'organisations
#

$ADOrganizationUnit = Import-Csv $env:USERPROFILE/Desktop/data/ou.csv -Delimiter ";"

foreach ($OU in $ADOrganizationUnit) {
	$Name = $OU.name
	if (Get-ADOrganizationalUnit -Filter { Name -eq $Name }) {
		Write-Warning "A OU with name $Name already exists in Active Directory."
	}
 else {
		New-ADOrganizationalUnit -Name $Name -Path "DC=marvelle,DC=local"
	}
}

#
# Fin de crÃ©ation des unitÃ©s d'organisations
#

#
# CrÃ©ation des ordindateurs
#

$ADComputer = Import-Csv $env:USERPROFILE/Desktop/data/computers.csv -Delimiter ";"

foreach ($Computer in $ADComputer) {
	$Name = $Computer.name
	if (Get-ADComputer -Filter { Name -eq $Name }) {
		Write-Warning "A group with name $Name already exists in Active Directory."
	}
 else {
		New-ADComputer -Name $Name -Path "OU=Ordinateurs,DC=marvelle,DC=local"
		Write-Host "Computer $Name is added"
	}
}

#
# Fin de crÃ©ation des ordinateurs
#

#
# CrÃ©ation des groupes
#

$ADGroup = Import-Csv $env:USERPROFILE/Desktop/data/groups.csv -Delimiter ";"

foreach ($Group in $ADGroup) {
	$Name = $Group.name
	if (Get-ADGroup -Filter { Name -eq $Name }) {
		Write-Warning "A group with name $Name already exists in Active Directory."
	}
 else {
		New-ADGroup -Name $Name -SamAccountName $Name -GroupScope Global -GroupCategory Security -Path "OU=Groupes,DC=marvelle,DC=local"
		Write-Host "Group $Name is created"
	}
}

#
# Fin de crÃ©ation des groupes
#

#
# CrÃ©ation des utilisateurs et attribution des groupes
#


$ADUsers = Import-Csv $env:USERPROFILE/Desktop/data/users.csv -Delimiter ";"
$UPN = "marvelle.local"

foreach ($User in $ADUsers) {
	$username = $User.Prenom + '.' + $User.nom
	if (Get-ADUser -F { SamAccountName -eq $username }) {
		Write-Warning "A user account with username $username already exists in Active Directory."
	}
 else {
		$firstname = $User.Prenom    
		$lastname = $User.Nom
		$email = $User.email
		$group = $User.groupe
		New-ADUser `
			-SamAccountName $username `
			-UserPrincipalName "$username@$UPN" `
			-Name "$firstname $lastname" `
			-GivenName $firstname `
			-Surname $lastname `
			-EmailAddress $email `
			-Enabled $True `
			-DisplayName "$lastname, $firstname" `
			-Path 'OU=Utilisateurs,DC=marvelle,DC=local' `
			-AccountPassword (ConvertTo-secureString  test@1234562  -AsPlainText -Force) -ChangePasswordAtLogon $True

		Add-ADGroupMember -Identity $group -Members $username
		Write-Host "The user account $username is created and add in group $Group." -ForegroundColor Cyan
	}
}


#
# Fin de crÃ©ation des utilisateurs et attribution des groupes
#

#
# Installation web server
#

Install-WindowsFeature Web-Server -IncludeManagementTools

#
# Fin de l'installation du web server
#

#
# Inistallation Print Services
#

Install-WindowsFeature Print-Services -IncludeManagementTools
Install-WindowsFeature Print-Internet -IncludeManagementTools

#
# fin de l'installation du Print Server
#



#
# Suppresion de la tâche
#

Unregister-ScheduledTask -TaskName "Init server"