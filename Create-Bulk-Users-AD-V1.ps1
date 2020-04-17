 
<#     

.NOTES 
#=============================================
# Script      : Create-Bulk-Users-AD-V1.ps1 
# Created     : ISE 3.0  
# Author(s)   : Casey Dedeal  
# Date        : 03/21/2019 21:15:26  
# Org         : ETC Solutions 
# File Name   : Create-Bulk-Users-AD-V1.ps1
# Comments    :
# Assumptions : 
#==============================================

SYNOPSIS           : create Bulk AD Users
DESCRIPTION        : Simple script to create bulk test users
Acknowledgements   : Open License 
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\Create-Bulk-Users-AD-V1.ps1.ps1

  MAP:
  -----------
  (1)_.Collecting Data
  (2)_.Create Users populate with data
  (3)_.Completed.

#> 



#(1)_.Collecting Data
Clear-Host
Write-Host "+++++++++++++++++++++++++++++++"
$accname  = read-host "Enter the User Name"
$password = Read-Host "Enter password" -AsSecureString
$count    = Read-Host "Enter the number Users" 
Write-Host "+++++++++++++++++++++++++++++++"
Write-Host $null
Write-host "++++++++++++++++++++++++++++++"$total = (1..$count).countwrite-host "()_.User name ($accname)" -f YellowWrite-Host "()_.Total Users will be created ($total)" -f YellowWrite-host "++++++++++++++++++++++++++++++"Read-Host  "Press Enter to continue"


#(2)_.Create Users populate with data
1..$count | ForEach {

$id = "001$_"
$oPhone = "1900-88-77-00$_"
$phone = "1-800-99-88-00$_"
$office = "Main-Office$_"
$address = "Test Street walley"
$info = "Office 365 Test Account-$_"
$org = "MAIN OFFICE $_"
$city = "ARLINGTON" 
$Country = "USA"
$smtp = "@SecuredNinja.org"
$email = $accname + $smtp
$company = "IT-RESEARCH-CORP" 
$eid = "$accname-$_"
$state = "VA"
$Division = "Office-OF-$accname"

Write-host "Processing -($_) `t" -NoNewline; Write-Host "($accname$_)" -f Yellow
New-ADUser -SamAccountName $accname$_ `
-AccountPassword $password `
-Name $accname$_ `
-GivenName $accname$_ `
-Surname $accname$_ `
-DisplayName $accname$_ `
-Department $office `
-MobilePhone $phone `
-StreetAddress $address `
-OfficePhone $oPhone `
-Description $info `
-EmployeeID $id `
-Organization $org `
-City $city `
-Country $Country `
-EmailAddress $email `
-Company $company `
-EmployeeNumber $eid `
-Office $office `
-UserPrincipalName $accname$_ `
-State $state `
-Division $Division


}
#(3)_.Completed.
Write-Host "completed" -f Green


 
