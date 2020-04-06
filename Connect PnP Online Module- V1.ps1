

<#    

.NOTES

#=============================================
# Script      : Connect PnP Online Module- V1.ps1
# Created     : ISE 3.0 
# Author(s)   : Casey.Dedeal 
# Date        : 04/05/2020 20:20:25 
# Org         : ETC Solutions
# File Name   : Connect PnP Online Module- V1.ps1
# Comments    :
# Assumptions :
#==============================================

 
SYNOPSIS           : Connect PnP Online Module- V1.ps1
DESCRIPTION        : Connect PnP Online
Acknowledgements   : Open license
Limitations        : None
Known issues       : None
Credits            : Please visit: 
                          https://simplepowershell.blogspot.com
                          https://msazure365.blogspot.com

.EXAMPLE

  .\Connect PnP Online Module- V1.ps1


  MAP:

  -----------
  #(1)_.Load SP Module already installed
  #(2)_.Connect PnP Online Module



#>

 

#(1)_.Load SP Module already installed
$module = 'SharePointPnPPowerShellOnline'
if (!(Get-Module $module))
{
 write-Host "()_.Importing $modue Module" -ForegroundColor DarkYellow
 Import-Module $module
 write-Host "()_.Completed" -ForegroundColor DarkYellow

}else{

write-Host "Cannot locate ($module)"
write-host 'Script will stop, download and install SP Online module first'
Start-Sleep -Seconds 5
break;

}


#(2)_.Connect PnP Online Module
 Try{

#(-)_.Connect PnP Online Module
$orgName = 'CloudSec365'
$url = "https://$orgName-admin.sharepoint.com"
Connect-PnPOnline -Url $url -UseWebLogin;


}catch{

 Write-Warning 'Error has occoured'
 Write-host "Problem FOUND: $($PSItem.ToString())" -f red -b White

  } 



