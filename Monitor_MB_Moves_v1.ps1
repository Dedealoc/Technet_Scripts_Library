


 
<#     

.NOTES 
#=============================================
# Script      : Monitor_MB_Moves_v1.ps1 
# Created     : ISE 3.0  
# Author(s)   : casey.dedeal  
# Date        : 11/14/2017 17:29:07  
# Org         : ETC Solutions 
# File Name   : Monitor_MB_Moves_v1.ps1 
# Comments    : Monitor MB  moves InProgress
# Assumptions : EMC Shell    
#==============================================

SYNOPSIS           : Monitor_MB_Moves_v1.ps1 
DESCRIPTION        : 
Acknowledgements   :
Limitations        : none
Known issues       : none

.EXAMPLE
  .\Monitor_MB_Moves_v1.ps1 

  Description
  -----------
  Run the script to see the Ongoing MB moves
  Run it from EMC or connect to Remote Exchange PS

   (1)_. Monitor MB Moves while Move request "InProgress"
   (2)_. Count MB Moves inProgress
   (3)_. Start Sleep before looping back

#> 



#(1)_. Monitor MB Moves while Move request "InProgress"
write-host $null
while ($(Get-MoveRequest |? {$_.Status -eq  "InProgress"}  | `
Group-Object Status | Select-Object Count,Name)) {cls; Get-MoveRequest |? {$_.Status -eq "InProgress"} |`
Get-MoveRequestStatistics |`
ft  DisplayName,Status,BytesTransferred,TotalMailboxSize,PercentComplete;
#(2)_. Count MB Moves inProgress
$Count = (Get-MoveRequest |? {$_.Status -eq  "InProgress"}).count 
Write-host "---------------------------------------" -ForegroundColor Yellow 
Write-host "Number of moves "InProgress" [ $count ]" -ForegroundColor Yellow 
Write-host "Please wait..." -ForegroundColor Cyan
Write-host "---------------------------------------" -ForegroundColor Yellow 
#(3)_. Start Sleep before looping back
Start-Sleep -seconds 10 }




