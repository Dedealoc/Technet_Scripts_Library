
<#    

.NOTES

#=============================================
# Script      : Revoke-Bulk-AzureADUserAllRefreshToken.ps1
# Created     : ISE 3.0 
# Author(s)   : Casey.Dedeal 
# Date        : 03/0/2020 02:00:56 
# Org         : ETC Solutions
# File Name   : Revoke-AzureADUserAllRefreshToken-V2.ps1
# Comments    : Remove all user AzureAD Tokens O365
# Assumptions : O365 Tenant 
#==============================================

 
SYNOPSIS           : Revoke-BULK--AzureADUserAllRefreshToken-V2.ps1
DESCRIPTION        : Remove all user tokens dues to security concerns
Acknowledgements   : Open license
Limitations        : None
Known issues       : None
Credits            : Please visit: 
                          https://simplepowershell.blogspot.com
                          https://msazure365.blogspot.com
.EXAMPLE

  .\Revoke-Bulk-AzureADUserAllRefreshToken.ps1

  MAP:
  -----------
 #(1)_.Create a Log folder
 #(2)_.Check Folder existance
 #(3)_.Function write logs
 #(4)_.Function Time
 #(5)_.Timestamp function
 #(6)_.Function Connect Azure AD
 #(7)_.Attempt to connect AzureAD PowerShell
 #(8)_.Import CSV GUI Function
 #(9)_.IMPORT CSV DATA now
 #(10)_.Provide Information now.
 #(11)_.Start Looping after CSV data is imported
 #(12)_.Try catch errors within the Loop 
 #(13)_.Provide user validation, write results to log file
 #(14)_.Revoke AzureAD All Fresh Tokens now
 #(15)_.Start Constractiong Custom PS object to capture results
 #(16)_.Store PS Object again,User data has changed, Export CSV
 #(17)_.Capture errors write to error log
 #(18)_.Capture errors write to error log
 #(19)_.Present Results
 #(20)_.Give option to open CSV folder to see results

#>

#(1)_.Create a Log folder
$name      = 'AzureAD-UserToken-Report'
$now       = Get-Date -format 'dd-MMM-yyyy-HH-mm-ss'
$user      = $env:USERNAME
$desFol    = "C:\temp\Reports_\Report-$name\"
$filename  = "$name-$now.CSV"
$CSVfile   = $desFol + $filename

#(2)_.Check Folder existance
If (!(Test-Path $desFol)) {New-Item -ItemType Directory -Force $desFol | Out-Null}#(3)_.Function write logsfunction Write-Log {
     [CmdletBinding()]
     param(
         [Parameter()]
         [ValidateNotNullOrEmpty()]
         [string]$Message,
         [Parameter()]
         [ValidateNotNullOrEmpty()]
         [ValidateSet('Information','Warning','Error')]
         [string]$Severity = 'Information'
     )
 
     $name     = 'UserToken-Report-LOG'
     $user     = $env:USERNAME
     $now      = get-Date -format 'dd-MMM-yyyy'
     $Log_name = "$now-$name.CSV"
     $filepath = "C:\temp\Reports_\Report-$name\" 
     $CSVPath  = $filepath + $Log_name

     # Folder Check 
     If (!(Test-Path $filepath)) {     New-Item -ItemType Directory -Force $filepath| Out-Null}

     # PS Object
     [pscustomobject]@{
         Time     = (Get-Date -f g)
         Message  = $Message
         Severity = $Severity
     } | Export-CSV -Path $CSVPath -Append -NoTypeInformation -Force
   }#(4)_.Function Timefunction Write-Time {
    
return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
    
}

#(5)_.Timestamp function
function Function-Get-TimeStamp {
    
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

#(6)_.Function Connect Azure AD
function Function-Connect-AzureAD {

  [CmdletBinding()]
  param()
   
try { 
	$connection = Get-AzureADTenantDetail -ErrorAction Stop
    write-host 'Already connected AzureAD PowerShell' 
    Write-host 'Time:' -NoNewline; Function-Get-TimeStamp 
    Write-host $null
} 
catch [Microsoft.Open.Azure.AD.CommonLibrary.AadNeedAuthenticationException]{ 
	Write-Host 'You are not connected to AzureAD PowerShell'   
    write-host 'Connecting AzureAD now' -f DarkCyan
    Connect-AzureAD -ErrorAction Stop
    }	  
	
}

#(7)_.Attempt to connect AzureAD PowerShell
try {
    Function-Connect-AzureAD -ErrorAction Stop
} 
catch{ 
	Write-host 'ERROR FOUND:'
    write-host "ERROR: $($PSItem.ToString())"
}	  
	
#(8)_.Import CSV GUI Function
Clear-Host
Function Function-Get-CSV ($initialDirectory)
{  
 [System.Reflection.Assembly]::LoadWithPartialName(“System.windows.forms”) |
 Out-Null

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = “All files (*.*)| *.*”
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
 $initialDirectory = "C:\temp\"
} 

#(9)_.IMPORT CSV DATA now
$file    = Function-Get-CSV -initialDirectory $initialDirectory
$CSVdata = Import-Csv -path $file
$i = 1 
$totalusers = ($CSVdata).count 
#(10)_.Provide Information now.
Write-Host '+++++++++++++++++++++++++++++++++++++'
Write-host "Sucessfully Imported($totalusers) records" -ForegroundColor DarkYellow
Write-host 'Script will reset all <AD Azure existing Access Tokens>' -ForegroundColor DarkYellow
Write-Host '+++++++++++++++++++++++++++++++++++++'
Read-Host 'Press <ENTER> to continue'

#(11)_.Start Looping after CSV data is imported
foreach ($user in $CSVdata)
{
 $name = $_
 $userName  = ($user.DisplayName)
 $ObjectID  = ($user.Objectid)
 Write-Progress -activity "Processing $name" -status "$i out of $totalusers completed"
 Write-host "Processing:($userName)" -f DarkYellow
 #(12)_.Try catch errors within the Loop 
 Try{

 $Userexist = Get-AzureADUser -ObjectId $ObjectID -ErrorAction Stop

 #(13)_.Provide user validation, write results to log file
 if ( $Userexist){
 Write-host "Located user:($userName)" -f DarkYellow
 write-host 'Revoking All Tokes.' -ForegroundColor DarkYellow
 Write-Log "Located user:($userName)"
 Write-Log 'Revoking All Tokes.'

#(14)_.Revoke AzureAD All Fresh Tokens now
 Revoke-AzureADUserAllRefreshToken -ObjectId  $ObjectID
 write-host 'Completed succesfully' -ForegroundColor DarkGray
 Write-Log 'Completed succesfully'
 #(15)_.Start Constractiong Custom PS object to capture results
$Userdata = Get-AzureADUser -ObjectId $ObjectID 
$objectProperty = [ordered]@{
    DisplayName         = $Userdata.DisplayName
    UPN                 = $Userdata.UserPrincipalName
    AccStaus            = $Userdata.AccountEnabled
    TokenRefreshTime    = $Userdata.RefreshTokensValidFromDateTime
}

#(16)_.Store PS Object again,User data has changed, Export CSV
$Results = New-Object -TypeName psobject -Property $objectProperty
$Results | export-Csv -Path $CSVfile -NoTypeInformation -Append
$Results | fl

 }else{

 #(17)_.Capture errors write to error log
 Write-host "(-)_.CANNOT Locate user ($userName)" -ForegroundColor DarkYellow
 Write-Log  "(-)_.CANNOT Locate user ($userName)" -Severity Warning
 
    }

}catch 
{
#(18)_.Capture errors write to error log
write-host "ERROR FOUND: $($PSItem.ToString())" -ForegroundColor DarkYellow
Write-Log  "ERROR FOUND: $($PSItem.ToString())" -Severity Error
   }

$i++
}

#(19)_.Present Results
Write-host '+++++++++++++++++++++++++++++++++++++'
write-host 'Default Access Token Lifetime' -f Green
Write-host 'Expiration is upto : <1hr>' -f Green
write-host '<TokenRefreshTime> value indicates when new token was issued' -f Green
Write-host '+++++++++++++++++++++++++++++++++++++'
Read-host 'Press <ENTER> to open report folder'
#(20)_.Give option to open CSV folder to see results
start $desFol
