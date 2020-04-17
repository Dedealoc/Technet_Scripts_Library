



<#	
.NOTES
#============================================= 
# Script            : Create_Bulk_AD_Users.ps1 
# Created With      : ISE 3.0 
# Author (s)        : Casey Dedeal
# Date              : 04/15/2018 18:01:41 
# Organization      : ETC Solution
# File Name         : Create_Bulk_AD_Users.ps1
# Comments          : Create Bulk AD Users
# Assumptions       : None
#=============================================
.DESCRIPTION
		Basic ISE Profile Setup

SYNOPSIS           : Create_Bulk_AD_Users.ps1 
DESCRIPTION        : Create Bulk AD Users
Acknowledgements   : Working ADDS Environment required 
Limitations        : None 
Known issues       : None this time


Script map:

#(1)_.COllecting Information 
#(2)_.Providing Information
#(3)_.Looping Net User into Forech
#(4)_.Done creating users
#(5)_.Opening ADUC

#>


#(1)_.COllecting Information 
Clear-Host
write-host $null
Write-Host "--------------------------" -ForegroundColor Yellow
$accname  = read-host "Enter user Instance Name"
$password = Read-Host "Enter password" -AsSecureString
$number   = Read-Host "Enter the number Users" 
Write-Host "--------------------------" -ForegroundColor Yellow
write-host $null

#(2)_.Providing Information
Write-Host `tBulk AD Users Create Script.`n -f Cyan;start-Sleep -Seconds 1 
Write-Host `tStarting .`n -f Cyan;start-Sleep -Seconds 1 
# we will start creating users now as we have enough data

#(3)_.Looping Net User into Forech
1..$number | ForEach {
write-host "()_.processing" -f Yellow
Net User "$accname$_"MyPassword=$password /ADD /Y /Domain

}
#(4)_.Done creating users
Write-Host "()_.Completed." -Fore Yellow;start-Sleep -Seconds 3
Write-Host "().Opening ADUC."-Fore Yellow;start-Sleep -Seconds 3
#(5)_.Opening ADUC
start dsa.msc

