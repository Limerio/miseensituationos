Import-Module ActiveDirectory
  
$ADOrganizationUnit = Import-Csv ./ou.csv -Delimiter ";"

foreach ($OU in $ADOrganizationUnit) {
   $Name = $OU.name
   if(Get-ADOrganizationalUnit -Filter { Name -eq $Name }) {
      Write-Warning "A OU with name $Name already exists in Active Directory."
   } else {
      New-ADOrganizationalUnit -Name $Name -Path "DC=marvelle,DC=local"
   }
}