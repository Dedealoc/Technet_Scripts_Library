

<#     

.NOTES 
#=============================================
# Script      : Function-Check-O365-User-License-V1.ps1 
# Created     : ISE 3.0  
# Author(s)   : Casey.Dedeal  
# Date        : 12/18/2019 18:13:57  
# Org         : ETC Solutions 
# File Name   : Function-Check-O365-User-License-V1
# Comments    : Checking O365 Single User License and MB Size
# Assumptions : Script will run by O365 administrator
#==============================================

SYNOPSIS           : Function-Check-O365-User-License-V1.ps1 
DESCRIPTION        : Gather Single O365 User License
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : https://simplepowershell.blogspot.com/  

.EXAMPLE
   You will have to pass UPN
  .\Function-Check-O365-User-License-V1.ps1 .ps1 -UPN Casey.Dedeal@SecCloud365.OnMicrosfot.com

  MAP:
  -----------
  #(1)_.Function-EXO-MSOL-Connect-V1
  #(2)_.Run Function to Connect Azure AD and Exchange Online
  #(3)_.Function-Get-TimeStamp
  #(4)_.Run Function to get User License Status
  #(5)_.Run Function 

#> 

#(1)_.Function-EXO-MSOL-Connect-V1
function Function-CON-EXO-AZURE-ADD-V1 
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
Import-PSSession $Session -DisableNameChecking -AllowClobber -ErrorAction Stop | Out-Null
   
}

#(2)_.Run Function to Connect Azure AD and Exchange Online
function Function-CON-EXO-V1 
{
 Try {
$CompName = 'outlook.office365.com'
$ConfName = 'Microsoft.Exchange'
$State    = 'Opened'
$Session  = get-pssession | ?{$_.ComputerName -eq $CompName `
           -and $_.ConfigurationName -eq $ConfName `
           -and $_.State -eq $state} -ErrorAction stop
  
if (!($session)) {
   Clear-host
   Write-host '(-)_.Creating New <EXO PowerShell> Session' -f cyan
   Write-host '(-)_.Please Wait' -f cyan
   Function-CON-EXO-AZURE-ADD-V1

}}
catch
{

    Write-host 'Problem FOUND:' -f Cyan
    Write-host "Error Occoured: $($PSItem.ToString())" -f red -b White
    
 }}


#(3)_.Function-Get-TimeStamp
function Get-TimeStamp {
    
  return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    
}

#(4)_.Run Function to get User License Status
function Function-Check-O365-User-License-V1
{

param(
    [parameter(Mandatory=$true)][String] $UPN
)

Try{

$licenseInfo = Get-MsolUser -UserPrincipalName $UPN -ErrorAction stop
$licstatus   = ($licenseInfo ).IsLicensed
$Ulicense    = ((Get-MsolUser -UserPrincipalName $UPN).Licenses).AccountSkuId
$mailboxStat =  Get-MailboxStatistics -Identity $UPN -ErrorAction stop


#-CREATE PS Custom Object 
$OzobjectProperty = [ordered]@{

'DisplayName'    = $licenseInfo.DisplayName
'UserName'       = $licenseInfo.UserPrincipalName 
'LastDirSycTime' = $licenseInfo.LastDirSyncTime  
'ISLicenced'     = $licenseInfo.IsLicensed
'Licences'       = ($licenseInfo.Licenses.AccountSkuId -join ',')
'Mailbox Size'   = $mailboxStat.TotalItemsize
'Archive Enabled'= $mailboxStat.IsArchiveMailbox
'ProxyAddress'   = ($licenseInfo.ProxyAddresses -join ',')
}

Write-host '-----------------------------------' -f Cyan
Write-host 'License Report'
Write-host 'Report run time:' $(Get-TimeStamp)
Write-host '-----------------------------------' -f Cyan
$ozObject = New-Object -TypeName psobject -Property $OzobjectProperty
$ozObject | fl 

Write-host '------------------------------------------' -f Yellow
Read-host 'Press <ENTER> to open results in Grid-View'

$ozObject | Out-GridView

}
catch{
    Write-host 'Problem FOUND:' -f Cyan
    Write-host "Error Occoured: $($PSItem.ToString())" -f red -b White
}
}

#(5)_.Run Function
Function-CON-EXO-V1  
Function-Check-O365-User-License-V1
