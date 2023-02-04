Import-Module ActiveDirectory

# 
# Creation des Unités d'organisations
#
  
$ADOrganizationUnit = Import-Csv ./ou.csv -Delimiter ";"

foreach ($OU in $ADOrganizationUnit) {
   $Name = $OU.name
   if(Get-ADOrganizationalUnit -Filter { Name -eq $Name }) {
      Write-Warning "A OU with name $Name already exists in Active Directory."
   } else {
      New-ADOrganizationalUnit -Name $Name -Path "DC=marvelle,DC=local"
   }
}

#
# Fin de création des unités d'organisations
#

#
# Création des ordindateurs
#
  
$ADComputer = Import-Csv .\computers.csv -Delimiter ";"

foreach ($Computer in $ADComputer) {
   $Name = $Computer.name
   if(Get-ADComputer -Filter { Name -eq $Name }) {
      Write-Warning "A group with name $Name already exists in Active Directory."
   } else {
      New-ADComputer -Name $Name -Path "OU=Ordinateurs,DC=marvelle,DC=local"
      Write-Host "Computer $Name is added"
   }
}

#
# Fin de création des ordinateurs
#

#
# Création des groupes
#

$ADGroup = Import-Csv .\groups.csv -Delimiter ";"

foreach ($Group in $ADGroup) {
   $Name = $Group.name
   if(Get-ADGroup -Filter { Name -eq $Name }) {
      Write-Warning "A group with name $Name already exists in Active Directory."
   } else {
      New-ADGroup -Name $Name -SamAccountName $Name -GroupScope Global -GroupCategory Security -Path "OU=Groupes,DC=marvelle,DC=local"
      Write-Host "Group $Name is created"
   }
}

#
# Fin de création des groupes
#

#
# Création des utilisateurs et attribution des groupes
#

  
$ADUsers = Import-Csv ./users.csv -Delimiter ";"
$UPN = "marvelle.local"

foreach ($User in $ADUsers) {
    $username = $User.Prenom+'.'+$User.nom
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        Write-Warning "A user account with username $username already exists in Active Directory."
    } else {
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
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -Path 'OU=Utilisateurs,DC=marvelle,DC=local' `
            -AccountPassword (ConvertTo-secureString  test@1234562  -AsPlainText -Force) -ChangePasswordAtLogon $True

        Add-ADGroupMember -Identity $group -Members $username
        Write-Host "The user account $username is created and add in group $Group." -ForegroundColor Cyan
    }
}


#
# Fin de création des utilisateurs et attribution des groupes
#