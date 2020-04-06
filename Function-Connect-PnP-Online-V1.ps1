

<#    

.NOTES

#=============================================
# Script      : Function-Connect-PnP-Online-V1.ps1
# Created     : ISE 3.0 
# Author(s)   : Casey.Dedeal 
# Date        : 04/05/2020 20:33:21 
# Org         : ETC Solutions
# File Name   : Function-Connect-PnP-Online-V1.ps1
# Comments    : OrgName is required
# Assumptions :
#==============================================

 
SYNOPSIS           : Function-Connect-PnP-Online-V1.ps1
DESCRIPTION        : Connect O365 SP Online
Acknowledgements   : Open license
Limitations        : None
Known issues       : None
Credits            : Please visit: 
                          https://simplepowershell.blogspot.com
                          https://msazure365.blogspot.com

.EXAMPLE

  .\ Function-Connect-PnP-Online-V1.ps1


  MAP:

  -----------
  #(1)_.Connect PnP Function

 Example :

 Function-Connect-PnP-Online -Orgname CloudSec365

#>

 


#(1)_.Connect PnP Function
function Function-Connect-PnP-Online{
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
