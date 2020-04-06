


<#    

.NOTES

#=============================================
# Script      : Create-One-Drive-Folder-V1.ps1
# Created     : ISE 3.0 
# Author(s)   : Casey.Dedeal 
# Date        : 04/05/2020 18:17:43 
# Org         : ETC Solutions
# File Name   : Create-One-Drive-Folder-V1.ps1
# Comments    : 
# Assumptions : CSV file exist/formatted properly OrgName is provided
#==============================================

 
SYNOPSIS           : Create-One-Drive-Folder-V1.ps1
DESCRIPTION        : Create O365 SP/OneDrive Migration Folder
Acknowledgements   : Open license
Limitations        : None
Known issues       : None
Credits            : Please visit: 
                          https://simplepowershell.blogspot.com
                          https://msazure365.blogspot.com

.EXAMPLE

  .\Create-One-Drive-Folder-V1.ps1


  MAP:

  -----------
  #(1)_.Add Vars 
  #(2)_.Check CSV file , stop if file is not there
  #(3)_.Load PnP Module already installed
  #(4)_.Connect PnP Function
  #(5)_.Check if File Exist, import or stop
  #(6)_.Add Vars for Folder and Loop it
  #(7)_.Connect PnP Online
  #(8)_.Start Loop to create OneDrive Folder

#>

 

<# 

# CSV HEADERS SAMPLE

UserName    : Oz.DeDeal
HomeDir     : \\OZ-SURFACE-BOOK\Network_DATA\DeDeal
ONEDRIVEURL : https://cloudsec365-my.sharepoint.com/personal/oz_dedeal_cloudsec365_onmicrosoft_com/

#>

#(1)_.Add Vars 
$csvname  = 'OneDrive-Migration-List.csv'
$csvpath  = 'C:\Temp\Migration\'
$Csvfile  = $csvpath+$csvname

#(2)_.Check CSV file , stop if file is not there
if (!(Test-Path $Csvfile)){ 
Write-Warning 'Cannot locate CSV import file'
Write-Warning 'Script will stop'
Start-Sleep -Seconds 5
break:

}

#(3)_.Load PnP Module already installed
 Try{
 $module = 'SharePointPnPPowerShellOnline'
if (!(Get-Module $module))
{
 write-Host "()_.Importing $modue Module" -ForegroundColor DarkYellow
 Import-Module $module -ErrorAction Stop
 write-Host "()_.Completed" -ForegroundColor DarkYellow

 }

}catch{
    Write-Warning 'Error has occoured, script will stop'
    Write-host "Problem FOUND: $($PSItem.ToString())" -f red -b White
    break;

   } 

#(4)_.Connect PnP Function
function Connect-PnP-Online{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,mandatory=$true)]
        [string] $OrgName)
 Try{

$url = "https://$orgName-admin.sharepoint.com"
Connect-PnPOnline -Url $url -ErrorAction Stop -UseWebLogin; 

}catch{
    Write-Warning 'Error has occoured'
    Write-host "Problem FOUND: $($PSItem.ToString())" -f red -b White

   } 
}


#(5)_.Check if File Exist, import or stop
if(!(Test-Path $csvfile ))
{
  Write-Warning 'cannot locate csv file'
  Write-Warning "$Csvfile"
  Write-Warning 'Script will stop'
  Start-Sleep -Seconds 5
  break;
}else
{
$URLs = Import-Csv -Path $Csvfile 
}

#(6)_.Add Vars for Folder and Loop it
$Newfolder = 'Migration_Folder'
$LibFolder = 'Documents'

#(7)_.Connect PnP Online
Connect-PnP-Online

Read-Host 'Press <ENTER> to continue'
#(8)_.Start Loop to create OneDrive Folder
foreach ($url in $URLs){

write-host "Processing : $($url.UserName)" 
write-host "Connecting : $($url.ONEDRIVEURL)"
Connect-PnPOnline -Url $url.ONEDRIVEURL -UseWebLogin;
Add-PnPFolder -Name $Newfolder -Folder $LibFolder
write-host 'Completed' -f DarkGray

}



