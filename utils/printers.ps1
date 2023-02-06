Install-WindowsFeature Print-Services -IncludeManagementTools
Install-WindowsFeature Print-Internet -IncludeManagementTools

$ADPrinters = Import-Csv %USERPROFILE%/Desktop/data/printers.csv -Delimiter ";"

foreach ($Printer in $ADPrinters) {
  $name = $Printer.name
  if (Get-ADPrinter -F { Name -eq $name }) {
    Write-Warning "A printer with name $name already exists in Active Directory."
  } else {
    $driver = $Printer.driver
    Add-Printer -Name $name -DriverName $driver
  }
}