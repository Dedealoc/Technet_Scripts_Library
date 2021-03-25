



<#    

.NOTES
#------------------------------------------------------
# Script      : Set-ADUSER-ACL-READ-ONLY-ACCESS_V1.ps1
# Created     : ISE 3.0 
# Author(s)   : (Casey.Dedeal) 
# Date        : 03/24/2021 21:25:18 
# Org         : CloudSec365
# File Name   : Set-ADUSER-ACL-READ-ONLY-ACCESS_V1.ps1
# Comments    : None
# Assumptions : None
#------------------------------------------------------

 
.SYNOPSIS     : Set-ADUSER-ACL-READ-ONLY-ACCESS_V1.ps1
.DESCRIPTION  : Following script,
.License      : Open license
.Limitations  : None
.Known issues : None
.Credits      : (Casey.Dedeal)
.Blog         : https://simplepowershell.blogspot.com
.Blog         : https://msazure365.blogspot.com
.Blog         : https://cloudsec365.blogspot.com
.Twitter      : https://twitter.com/Message_Talk
                          

.EXAMPLE

  .\Set-ADUSER-ACL-READ-ONLY-ACCESS_V1.ps1


.MAP:
-----------

 #(1)_.Adding log Vars
 #(2)_.Adding Functions
 #(3)_.Create Report Folder
 #(4)-.Get User Name
 #(5)_.Check AD user
 #(6)_.Run ACL Change

-----------

   #>

 

#(1)_.Adding log Vars
$repname   = 'ACL-NTFS-RED-ONLY-REPORT'
    if(!($repname)){

    $repname    = 'DEFAULT-ACL-REPORT'}
    $ACLRep    = $RepServer+'-ACL-REPORT'
    $RepServer = $env:COMPUTERNAME
    $logname   = $Repname+'-Log.TXT'
    $csvname1  = $Repname+'-Log.CSV'
    $csvname2  = $Repname+'-PROG.CSV'
    $csvname3  = $ACLRep+'-NTFS-Log.CSV'
    $traname   = $Repname+'-Transcript.LOG'
    $pname     = $rname+'-PROCESS-LogFile.CSV'
    $now       = (get-Date -format 'dd-MMM-yyyy-HH-mm-ss-tt-')
    $user      = $env:USERNAME
    $desFol    = ("C:\temp\Reports_\$repname\")
    $logfile   = $desFol+$now+$logname
    $csvfile1  = $desFol+$now+$csvname1
    $csvfile2  = $desFol+$now+$csvname2 
    $csvfile3  = $desFol+$now+$csvname3
    $scrfile   = $desFol+$now+$traname

#(2)_.Adding Functions
  function Function-create-ReportFolder{

  [CmdletBinding()]

  param(

    [parameter(

     Mandatory = $true,
     ValueFromPipeline = $true)]
     [string]$ReportPath)
Try{

if (!(Test-Path -Path $ReportPath))

{

  New-Item -Type Directory -Path $ReportPath -ErrorAction Stop | Out-Null

    }

}catch{

 
    $errormessage = $($PSItem.ToString())
    Write-Warning 'Error has occoured'
    Write-host 'Problem FOUND:' $errormessage -ForegroundColor Red -BackgroundColor Black

    }

}
  function Write-Log2 {

     [CmdletBinding()]

     param(

         [Parameter()]

         [ValidateNotNullOrEmpty()]

         [string]$Count,

         [string]$User,

         [string]$Message,

         [String]$Progress,

         [String]$FailedUSER,

 

         [Parameter()]

         [ValidateNotNullOrEmpty()]

         [ValidateSet('Information','Warning','Error','Progress','Completed','Failed','FailedUSER','DoesNotExist','Progress')]

         [string]$Severity = 'Information'

     )

    

       [pscustomobject]@{

         Time     = (Get-Date -f g)

         Progress = $Progress

         Count  = $Count

         User = $User

         Message  = $Message

         Severity = $Severity

         FailedUSER = $FailedUSER

      

     } | Export-Csv -Path $csvfile3 -Append -NoTypeInformation

}
  function Set-ADUSER-ACL-READ-ONLY-ACCESS {

param (

[parameter(Mandatory=$true)]
[ValidateNotNullOrEmpty()]$UserName

)

try {

#(2)_.Add Access control vars
$Rights   = 'Read,ReadAndExecute,ListDirectory'           
$InhSets  = 'Containerinherit,ObjectInherit'
$ProtSets = 'None'
$RuleType = 'Allow'

#(13.1)_.Start constructing/combining access control vars

$domain   = "$env:USERDNSDOMAIN\"
$AddUser  = $domain+$userName
$path     = $user.homeDirectory


#(13.2)_.Start constructing system messages

$message1 = "(-)_.SCANNING:($userName)"
$message2 = "(a)_.Applying ACL-NTFS FULL Rights"
$message3 = "(b)_.Permissions modified:($Rights)"
$message4 = "(c)_.File Share:($UserDIRECTORY)"
$message5 = "(e)_.VERIFYING ACL changes"
$message6 = "(f)_.ACL has been updated succesfully"
$message7 = "(f)_.ACL updates has failed"
$gmessage = '(d)_.Completed'

 

#(13.3)_.Start getting ADUser data here
$userInfo = Get-ADUser -Identity $UserName -Properties * -ErrorAction Stop | `
            Select  SamAccountName,mail,HomeDirectory,HomeDrive

    

#(13.4)_.Construct User HomeDirectory into new var
    $UserDIRECTORY = ($userInfo).HomeDirectory
    $mess1 = "$userName Home Directory is NOT Configured"
    if ( $UserDIRECTORY -like $null ){
     write-host $mess1
     Write-Log2 -Message $mess1 -Severity Warning

     }

#(13.5)_.Capture existing NTFS rights

$acl  = Get-Acl $UserDIRECTORY -ErrorAction Stop
$perm = $AddUser,$Rights,$InhSets,$ProtSets,$RuleType
$rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm
$acl.SetAccessRule($rule)


#(13.6)_.Construct system messages
write-host '----------------------------------------------------------------' -ForegroundColor white
write-host 'Start Time:' -NoNewline;Function-Get-TimeStamp
write-Host "($i)_.Processing:$UserName"  -ForegroundColor DarkYellow
Write-Host 'ACL Permissions Summary:User home directory will be SET READ ONLY ACCESS' -ForegroundColor White
Write-host "`t(1)_.User Name      :$addUser"
Write-host "`t(2)_.Permissions    :$Rights"
Write-host "`t(3)_.HomeDirectory  :$UserDIRECTORY"


#(13.8)_.Perform ACL change and write to logs
Write-Host  $message1  -ForegroundColor Cyan
Write-Host "`t$message2" -ForegroundColor White
Write-Host "`t$message3" -ForegroundColor White
Write-Host "`t$message4" -ForegroundColor White

Write-Log2 -Message $message1 -Severity Information
Write-Log2 -Message $message2 -Severity Information
Write-Log2 -Message $message3 -Severity Information
Write-Log2 -Message $message4 -Severity Information


#(13.9)_.Setting ACL now
$acl | Set-Acl -Path $UserDIRECTORY -verbose -ErrorAction Stop
Write-Host  "`t$gmessage"  -ForegroundColor White
Write-Log2 -Message $gmessage -Severity Information
Write-Log2 -Message $UserName -Severity Completed


#(13.10)_.Start collecting changed ACL, perform verification

Write-Host  "`t$message5"  -ForegroundColor White
Write-Log2 -Message $message5 -Severity Information

$acl   = Get-Acl $UserDIRECTORY -ErrorAction Stop
$rules = $acl.Access |  ? IsInherited -eq $false           
$check = ($rules.IdentityReference).Value


#(13.11)_.VERIFY the ACL changes now; errors will be captured PSitem object if they accour , write results to log

if($check -contains $AddUser){

  #(13.12)_.Provide Verify work status/Success
  write-host "`t$message6" -ForegroundColor White
  Write-host 'END Time:' -NoNewline; Function-Get-TimeStamp
  Write-Log2 -Message $message6 -Severity Information

}else{


#(13.13)_.Failed to complete ACl update,write results/log
Write-host "`t$message7" -ForegroundColor DarkYellow
Write-host 'END Time:' -NoNewline; Function-Get-TimeStamp
Write-Log2 -Message $message7 -Severity Error
      }

   }

catch {  

  $Error1 = $($PSItem.ToString())
  $Error2 = $($PSItem.Exception.Message)
  Write-Warning 'ERROR has occoured'
  Write-host 'PROBLEM FOUND'  $Error1 -ForegroundColor red -BackgroundColor Black
  Write-Log2 -Message $Error1 -Severity Error
  Write-Log2 -Message $Error2 -Severity Error

      }
}
  function Function-Check-AD-User {

    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)]
        [String]$UserName
    )

   $User = $(try {Get-ADUser $UserName} catch {$null})
If ($User -ne $Null){

 write-host "Located USER:$UserName" -ForegroundColor Green

} Else {

Write-host "NOT FOUND USER:$UserName" -ForegroundColor Cyan
Write-host 'Script will STOP'
break;

    }

}

#(3)_.Create Report Folder
function-create-ReportFolder -ReportPath $desFol

#(4)-.Get User Name
$userName = Read-host 'Provide User Name'

#(5)_.Check AD user
Function-Check-AD-User -UserName $userName

#(6)_.Run ACL Change
Set-ADUSER-ACL-READ-ONLY-ACCESS -UserName $userName 