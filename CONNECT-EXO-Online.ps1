


<#    

.NOTES

#=============================================
# Script      : Connect-EXO-ISE.ps1
# Created     : ISE 3.0 
# Author(s)   : Casey.Dedeal 
# Date        : 01/20/2020 22:15:55 
# Org         : ETC Solutions
# File Name   : Connect-EXO-ISE.ps1
# Comments    : Connect O365 Exchange Online Module 
# Assumptions : 
#==============================================

 
SYNOPSIS           : Connect-EXO-ISE.ps1
DESCRIPTION        : Connect O365 Exchange Online Module
Acknowledgements   : Open license
Limitations        : None
Known issues       : None
Credits            : Please visit: 
                          https://simplepowershell.blogspot.com
                          https://msazure365.blogspot.com

.PRE-Requiset

 * Install EXO before you can use this script.
 * Open the Exchange admin center (EAC) for your Exchange Online organization
 * Locate Hybrid  Setup
 * Click EXO to download the Exchange Online Remote PowerShell Module.


.EXAMPLE

  .\Connect-EXO-ISE.ps1

  MAP:

  -----------
  #(1)_.Run Function-Check-EXO-DLL
  #(2)_.Run Function-Check-EXO-Session
  #(3)_,Run Function-CONNECT-EXO

#>

 
#(1)_.Run Function-Check-EXO-DLL
function Function-Check-EXO-DLL
{
   [CmdletBinding()]
    param()

  Try{

  #(-)_.Check if the Exchange Online PowerShell Module is installed
    $pathEXO = $env:LOCALAPPDATA+"\Apps\2.0"
    $moduleDLL = 'Microsoft.Exchange.Management.ExoPowershellModule.dll'
    $EXO = (Get-ChildItem -Path $($pathEXO) `
                          -Filter $moduleDLL `
                          -Recurse `
                          -ErrorAction Stop).name           
if (!($EXO)){
    
 Write-warning 'CANNOT Locate:Installed <EXO> Exchange Online Module'
 Write-warning 'Install EXO Module before running this scripts'
 Write-host 'Script will exit' -f DarkGray
 Start-Sleep -Seconds 5
 break;
   
}
  }catch{

    Write-Warning 'Error has occoured'
    Write-host 'Problem FOUND: $($PSItem.ToString())' -f red -b White
  } 

}

#(2)_.Run Function-Check-EXO-Session
function Function-Check-EXO-Session
{
    [CmdletBinding()]
    param()

 Try{


 #(-)_.Vars 
$CompName = 'outlook.office365.com'
$ConfName = 'Microsoft.Exchange'
$State    = 'Opened'

Function-Check-EXO-DLL
$Session = get-pssession | ?{$_.ComputerName -eq $CompName `
           -and $_.ConfigurationName -eq $ConfName `
           -and $_.State -eq $state}


if ($session){
    
 Write-warning 'Located Existing <EXO> Session' 
 Write-warning 'Will use the session'
 break;
   
}

 }Catch{

   Clear-Host
   write-host '+++++++++++++++++++++++++++++++++++++++++++++++++' 
   Write-host '(-)_.Creating New EXO PowerShell Session' -f darkYellow
   Write-host '(-)_.Please Wait' -f DarkYellow
   write-host '+++++++++++++++++++++++++++++++++++++++++++++++++' 
  
  }
}

#(3)_,Run Function-CONNECT-EXO
function Function-CONNECT-EXO
{
  [CmdletBinding()]
   param()

try{

Function-Check-EXO-Session
$pathEXO = $env:LOCALAPPDATA+"\Apps\2.0"
$moduleDLL = 'Microsoft.Exchange.Management.ExoPowershellModule.dll'

Import-Module $((Get-ChildItem -Path $($pathEXO) `
               -Filter $moduleDLL -Recurse -ErrorAction Stop).FullName | `
                ?{$_ -notmatch "_none_"} | select -First 1)

$EXOSession = New-ExoPSSession
Import-PSSession $EXOSession

}Catch{

    Write-Warning 'Error has occoured'
    Write-host "Problem FOUND: $($PSItem.ToString())" -f Darkred -b White

  }
}Function-CONNECT-EXO




