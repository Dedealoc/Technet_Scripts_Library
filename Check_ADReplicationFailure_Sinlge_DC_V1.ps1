


<#     

.NOTES 
#=============================================
# Script      : Check_ADReplicationFailure_Sinlge_DC_V1.ps1 
# Created     : ISE 3.0  
# Author(s)   : Casey.Cedeal  
# Date        : 09/19/2018 10:35:34  
# Org         : ETC Solutions 
# File Name   : Check_ADReplicationFailure_Sinlge_DC_V1.ps1 
# Comments    : Repadmin AD Replication status
# Assumptions : 
#==============================================

SYNOPSIS           :
DESCRIPTION        : 
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\Check_ADReplicationFailure_Sinlge_DC_V1.ps1 

  MAP:
  -----------
  (1)_.Import AD Module if Does not Exist
  (2)_.Capturing Server Name
  (3)_.Check If Server is onnline,quit if not
  (4)_.Run repadmin to remote DC with csv and OW options

#> 

Clear-host 
Write-host $null
Write-Host  "..............................................." -f Yellow
Write-Host  "Validating Domain Controller replication status" -f White
Write-Host  "..............................................." -f Yellow
Write-host $null

#(1)_.Import AD Module if Does not Exist
if (!(get-Module ActiveDirectory))
{
Write-Host "`t()_.Importing AD Module"
Import-Module ActiveDirectory
Write-Host "`t()_.Completed"
}
else{
Write-Host "`t()_.AD Module exist" -f Green
Write-Host "`t()_.Will continue" -f Green
Start-Sleep -Seconds 3
}

#(2)_.Capturing Server Name
Write-Host          "+++++++++++++++++++++++++++++++++++++"
$Server = Read-Host "Please Provide Domain Controller Name"
Write-Host          "+++++++++++++++++++++++++++++++++++++"

if ([string]::IsNullOrWhiteSpace($Server))
{
Write-host "`t(-)_.Server name cannot be blank or contains space" -f Cyan -b Black
write-host "`t(-)_.Will exit in 5 seconds" -f Cyan -b Black
break;
}

#(3)_.Check If Server Online, quit if !
Write-Host $null
If (Test-Connection -ComputerName $Server -count 1 -quiet){
  write-host "`t()_.$Server is alive" -f Green
  }
Else {
  write-host  "`t(-)_.$Server is offline" -f Red -b White
  write-host  "`t(-)_.Will exit in 5 seconds" -f Red -b White
  Start-Sleep -Seconds 5
  break;
  }  
  
#(4)_.Run repadmin to remote DC with csv and OW options
$dchealth = repadmin /showrepl $Server  /csv | ConvertFrom-Csv | ?{$_.'Number Of Failures'} 
$dchealth | Out-GridView 
