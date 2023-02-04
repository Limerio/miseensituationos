Import-Module ActiveDirectory
  
$ADGroup = Import-Csv .\groups.csv -Delimiter ";"

foreach ($Group in $ADGroup) {
   $Name = $Group.name
   if(Get-ADGroup -Filter { Name -eq $Name }) {
      Write-Warning "A group with name $Name already exists in Active Directory."
   } else {
      New-ADGroup -Name $Name -SamAccountName $Name -GroupScope Global -GroupCategory Security -Path "OU=Groups,DC=marvelle,DC=local"
      Write-Host "Group $Name is created"
   }
}
