




<#     

.NOTES 
#=============================================
# Script      : Function-Migration-Status-Loop-V1.ps1
# Created     : ISE 3.0  
# Author(s)   : CA-Casey.Dedeal  
# Date        : 01/14/2020 22:03:58  
# Org         : ETC Solutions 
# File Name   : Function-Migration-Status-Loop-V1.ps1
# Comments    : Function-Migration-Status-Loop-V1.ps1
# Assumptions : 
#==============================================

SYNOPSIS           : Function-Migration-Status-Loop-V1.ps1
DESCRIPTION        : Monitor moves
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\Function-Migration-Status-Loop-V1.ps1

  MAP:
  -----------

  #(1)_.Function-Get-TimeStamp
  #(2)_.Function-EXO-MSOL-Connect-V1
  #(3)_.Run Function to Connect
  #(4)_.Loop Monitoring Function

#> 

#(1)_.Function-Get-TimeStamp
function Get-TimeStamp {
    
  return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    
}

#(2)_.Function-EXO-MSOL-Connect-V1
function Function-CON-EXO-AZURE-AD-V1 
{
   
$URL   = 'https://outlook.office365.com/powershell-liveid/'
$Luser = $env:USERNAME
$Mail  = '@tsa.dhs.gov'
$UPN   = $Luser + $Mail 

$UserCredential = Get-Credential $UPN
Connect-MsolService -Credential $UserCredential -ErrorAction Stop
$Session = New-PSSession -ConfigurationName Microsoft.Exchange `
          -ConnectionUri $URL -Credential $UserCredential `
          -Authentication Basic -AllowRedirection -ErrorAction Stop
Import-PSSession $Session -DisableNameChecking -AllowClobber | Out-Null
   
}

#(3)_.Run Function to Connect
function MyFunction-CON-EXO 
{
 Try {
$CompName = 'Outlook.office365.com'
$ConfName = 'Microsoft.Exchange'
$State    = 'Opened'
$Session  = get-pssession | ?{$_.ComputerName -eq $CompName `
           -and $_.ConfigurationName -eq $ConfName `
           -and $_.State -eq $state}
  
if (!($session)) {
   Clear-host
   
   Write-host '+++++++++++++++++++++++++++++++++++++++++++' -f Yellow
   Write-host '(-)_.Creating New <EXO PowerShell> Session' 
   Write-host '(-)_.Please Wait' 
   Write-host '+++++++++++++++++++++++++++++++++++++++++++' -f Yellow
   Function-CON-EXO-AZURE-AD-V1 

}}
catch
{

 Write-host "Problem FOUND: $($PSItem.ToString())" -f red -b White
 Write-Warning 'Script will stop'
 Write-Warning 'Check your credentials and Try again' 
 Start-Sleep -Seconds 5
 break;

 }}MyFunction-CON-EXO

#(4)_.Loop Monitoring
function Function-Migration-Status-Loop-V1
{
   

# Loop & Report Specific Migration Batch 
do
{

 $ops = @(
'Identity',
'Status',
'TotalCount',
'FinalizedCount'
'SyncedCount',
'FailedCount'
'StoppedCount'
)

 
 Write-host '------------------------------------' -f Yellow
 Write-host '(a)_.Getting Migration Batch Status' -f DarkCyan
 Write-host '(b)_.Please wait.' -f DarkCyan
 Write-host '(c)_.Looping in 15 seconds' -f DarkCyan
 Write-host '------------------------------------' -f Yellow
 Write-host 'Report Run:'$(Get-TimeStamp) 

 # Change the Vars 
 $var = 'My_Batch*'  # Target Specific Batch name, manupulate $var 
 $sta = 'Completing'
 
 # Target Specific Batch name, manupulate $var 
 # ?{$_.Identity -like $var -and $_.Status -like $sta} 
 
 $status = Get-MigrationBatch | `
           ?{$_.Status -like $sta} 
           
 if (!($status)){
 Write-host 'Migrations seems to be completed' -f DarkGray
 Write-host 'Script will stop' -f DarkCyan
 Write-host 'Completed:'$(Get-TimeStamp) 
 start-sleep -Seconds 5
 break;

 }
 
$status | select $ops | ft -AutoSize
 
 Start-Sleep -Seconds 15
 Clear-host

} until ($false)

}Function-Migration-Status-Loop-V1

