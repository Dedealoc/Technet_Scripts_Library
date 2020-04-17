



 
<#     

.NOTES 
#=============================================
# Script      : Function-CON-EXO-AZURE-AD-V1 .ps1 
# Created     : ISE 3.0  
# Author(s)   : Casey.Dedeal  
# Date        : 11/21/2019 15:04:40  
# Org         : ETC Solutions 
# File Name   : Function-CON-EXO-AZURE-AD-V1 
# Comments    :
# Assumptions : 
#==============================================

SYNOPSIS           : Function-EXO-MSOL-Connect-V1
DESCRIPTION        :
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\ Function-CON-EXO-AZURE-AD-V1.ps1

  MAP:
  -----------
  (1)_.Function-CON-EXO-AZURE-AD-V1 
  (2)_.Try Both Functions catch errors


#> 


#(1)_.Function-EXO-MSOL-Connect-V1
function Function-CON-EXO-AZURE-AD-V1 
{
   
$URL   = 'https://outlook.office365.com/powershell-liveid/'
$Luser = $env:USERNAME
$Mail  = '@'
$UPN   = $Luser + $Mail 

$UserCredential = Get-Credential $UPN
Connect-MsolService -Credential $UserCredential -ErrorAction Stop
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
          -ConnectionUri $URL -Credential $UserCredential `
          -Authentication Basic -AllowRedirection -ErrorAction Stop
Import-PSSession $Session -DisableNameChecking -AllowClobber | Out-Null
   
}

#(2)_.Try Catch Errors
Try {
 
 
#(2.a)__.VARS
$CompName = 'outlook.office365.com'
$ConfName = 'Microsoft.Exchange'
$State    = 'Opened'

$Session = get-pssession | ?{$_.ComputerName -eq $CompName `
           -and $_.ConfigurationName -eq $ConfName `
           -and $_.State -eq $state}

   
if ($session) {
   
   Clear-host
   Write-Host '(-)_.Located Existing EXO Session.' -f Yellow
   Write-Host '(-)_.Using Existing Session' -f Cyan

}
else {
   Clear-Host
   Write-host '(-)_.Creating New EXO PowerShell Session' -f Yellow
   Write-host '(-)_.Please Wait' -f Cyan
   Function-CON-EXO-AZURE-AD-V1 
}


}

catch
{
    Write-Warning 'Error has occoured'
    Write-host 'Problem FOUND: $($PSItem.ToString())' -f red -b White
    Write-Host $_.Exception.Message -ForegroundColor red
  

  }
