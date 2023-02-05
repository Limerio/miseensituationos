Import-Module ActiveDirectory
  
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
