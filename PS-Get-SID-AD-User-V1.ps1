

 
<#     

.NOTES 
#=============================================
# Script      : PS-Get-SID-AD-User_V1.ps1 
# Created     : ISE 3.0  
# Author(s)   : casey.dedeal  
# Date        : 03/28/2018 10:33:45  
# Org         : ETC Solutions 
# File Name   : PS-Get-SID-AD-User.ps1 
# Comments    :
# Assumptions : 
#==============================================

SYNOPSIS           : PS-Get-SID-AD-User_v1.ps1 
DESCRIPTION        : Get Ad user SID
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\PS-Get-SID-AD-User_V1.ps1 

  Description
  -----------
  Run the script to get user SID from Active Directory

  (1)_.Import AD Module if Does not Exist
  (2)_.Capture user name
  (3)_.Check if AD User exist
  (4)_.Get the SID
  (5)_.Add Custom Object to array
  (6)_.Provide output
  (7)_.Open results in grid view 

#> 


 Clear-Host
#(1)_.Import AD Module if Does not Exist
if (!(Get-Module ActiveDirectory))
{
 write-Host "()_.Importing AD Module" -ForegroundColor Yellow
 Import-Module ActiveDirectory
 write-Host "()_.Completed" -ForegroundColor Cyan
}

#(2)_.Capture user name
$user =read-host "User Instance" 

#(3)_.Check if AD User exist
 try { 
 get-aduser  $User | Out-Null 
 Write-Host $null
 write-host "()_.Located" -ForegroundColor White -NoNewline; Write-Host ":[$user]" -ForegroundColor Green
 } 
 catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{ 
 Write-Host $null
 write-host "()_.$user" -ForegroundColor Cyan -NoNewline; Write-Host " [Does NOT Exists]" -ForegroundColor yellow
 write-host "()_.Try again" -ForegroundColor Cyan 
 break;
 } 

#(4)_.Get the SID
$sid = (Get-ADUser -Identity $user).sid

#(5)_.Add Custom Object to array
$report = @()
$report += New-Object psobject -Property @{User=$user;SID=$sid}

#(6)_.Provide output
write-host $null
Write-host "-------SID REPORT------" -ForegroundColor Yellow
$report | fl 

#(7)_.Open results in grid view 
$report | Out-GridView
