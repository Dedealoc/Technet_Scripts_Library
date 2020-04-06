

<#    

.NOTES

#=============================================
# Script      : Add-Second-Site-Collection-Admin-V1.ps1
# Created     : ISE 3.0 
# Author(s)   : Casey.Dedeal 
# Date        : 04/05/2020 16:47:17 
# Org         : ETC Solutions
# File Name   : Add-Second-Site-Collection-Admin-V1.ps1
# Comments    :
# Assumptions :
#==============================================

 
SYNOPSIS           : Add-Second-Site-Collection-Admin-V1.ps1
DESCRIPTION        : Adding second site administrator to site collection
Acknowledgements   : Open license
Limitations        : None
Known issues       : None
Credits            : Please visit: 
                          https://simplepowershell.blogspot.com
                          https://msazure365.blogspot.com

.EXAMPLE

  .\Add-Second-Site-Collection-Admin-V1.ps1


  MAP:

  -----------
  #(1)_.Connect to SharePoint Admin Center using the SPO module
  #(2)_.In this example these are CSV headers
  #(3)_.More Vars users
  #(4)_.Check if File Exist, import or stop
  #(5)_.Add 2nd Site Collection admin
  #(6)_.Get PersonalUrl of a OneDrive site
  #(7)_.Connect PnP use web login
  #(8)_.Get Personal URL
  #(9)_.Get information about a OneDrive site incl. SiteCollectionAdmins 
  #(10)_.Site Collection admin
  #(11)_.Remove a user from site owner access
 

#>

 

#(1)_.Connect to SharePoint Admin Center using the SPO module

 Try{

#(-)_.Connect SP Online Module
$orgName = 'CloudSec365'
$url = "https://$orgName-admin.sharepoint.com"
Connect-SPOService -Url $url -Verbose
}catch{
    Write-Warning 'Error has occoured'
    Write-host "Problem FOUND: $($PSItem.ToString())" -f red -b White
  } 

#(2)_.In this example these are CSV headers
<# 

# CSV HEADERS SAMPLE
UserName    : Oz.DeDeal
HomeDir     : \\OZ-SURFACE-BOOK\Network_DATA\DeDeal
ONEDRIVEURL : https://cloudsec365-my.sharepoint.com/personal/oz_dedeal_cloudsec
              365_onmicrosoft_com/
#>



#(3)_.More Vars users
$csvname  = 'OneDrive-Migration-List.csv'
$csvpath  = 'A:\Migration\'
$Csvfile  = $csvpath+$csvname
$SecAdmin = 'admin@CloudSec365.onmicrosoft.com'



#(4)_.Check if File Exist, import or stop
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


#(5)_.Add 2nd Site Collection admin
foreach ($url in $URLs){

write-host "Processing : $($url.UserName)" 
write-host "Connecting : $($url.ONEDRIVEURL)" 
write-host "Second site collection admi will be added :$SecAdmin"

Set-SPOUser -Site $url.ONEdriveURL `
            -LoginName $SecAdmin `
            -IsSiteCollectionAdmin $true
}


#(6)_.Get PersonalUrl of a OneDrive site
$upnName = 'Oz.DeDeal@CloudSec365.onmicrosoft.com'
$orgName = 'CloudSec365'
$urlName = "https://$orgName-admin.sharepoint.com"

#(7)_.Connect PnP use web login
Connect-PnPOnline -Url $urlName -UseWebLogin;

#(8)_.Get Personal URL
$Persurl = (Get-PnPUserProfileProperty -Account $upnName).PersonalUrl
$Persurl = $Persurl.TrimEnd('/')


#(9)_.Get information about a OneDrive site incl. SiteCollectionAdmins 
Get-SPOSite -Identity $Persurl -Detailed | Format-List


#(10)_.Site Collection admin 
$SiteInfo = Get-SPOUser -Site $Persurl -Limit all | `
              Select DisplayName,LoginName,IsSiteAdmin | `
              Sort-Object IsSiteAdmin,DisplayName | `
              ft -GroupBy IsSiteAdmin -AutoSize

$SiteInfo

#(11)_.Remove a user from site owner access
$admin = 'Admin@UPN' 
Set-SPOUser -Site $Persurl -LoginName $admin -IsSiteCollectionAdmin $false