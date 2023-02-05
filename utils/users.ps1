Import-Module ActiveDirectory
  
$ADUsers = Import-Csv ./users.csv -Delimiter ";"
$UPN = "marvelle.local"

foreach ($User in $ADUsers) {
    $username = $User.Prenom+'.'+$User.nom
    $firstname = $User.Prenom
    $lastname = $User.Nom
    $email = $User.email
    if (Get-ADUser -F { SamAccountName -eq $username }) {
        Write-Warning "A user account with username $username already exists in Active Directory."
    } else {
        New-ADUser `
            -SamAccountName $username `
            -UserPrincipalName "$username@$UPN" `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -Path 'OU=please,DC=marvelle,DC=local' `
            -AccountPassword (ConvertTo-secureString  test@1234562  -AsPlainText -Force) -ChangePasswordAtLogon $True

        Write-Host "The user account $username is created." -ForegroundColor Cyan
    }
}