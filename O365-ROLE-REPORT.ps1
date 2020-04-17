

<#    

.NOTES

#=============================================
# Script      : O365-ROLE-REPORT.ps1
# Created     : ISE 3.0 
# Author(s)   : Casey.Dedeal 
# Date        : 01/15/2020 22:39:51 
# Org         : ETC Solutions
# File Name   : O365-ROLE-REPORT.ps1
# Comments    : Reporting Roles and its members
# Assumptions : O365
#==============================================

 
SYNOPSIS           : O365-ROLE-REPORT.ps1
DESCRIPTION        : Report Roles/Members
Acknowledgements   : Open license
Limitations        : None
Known issues       : None
Credits            : Please visit: 
                          https://simplepowershell.blogspot.com
                          https://msazure365.blogspot.com

.EXAMPLE

  .\O365-ROLE-REPORT.ps1


  MAP:

  -----------
  #(1)_.Add VARS
  #(2)_.Check Folder
  #(3)_.Run Azure PowerShell Connect Function
  #(4)_.Function-Get-TimeStamp
  #(5)_.Function Role Report
  #(5.1)_.Get All Roles
  #(5.2)_.Loop through the Azure AD roles
  #(5.3)_.Get the list of members for the role
  #(5.4)_.Loop through the list of members
  #(5.5)_.Start exporting results to CSV
  #(6)_.Open Reports

#>

 
#(1)_.Add VARS
$name    = 'O365-ROLE-REPORT'
$now     = (get-date -f 'dd-MMM-yyyy-HH-mm-ss')
$user    = ($env:USERNAME)
$desFol  = ("C:\Temp\Reports_\Report-$name\")
$fname   = ("$name-$now.CSV")
$Outfile = ($desFol + $fname)

#(2)_.Check Folder
If (!(Test-Path $desFol)) {
New-Item -ItemType Directory -Force $desFol | Out-Null}

#(3)_.Run Azure PowerShell Connect Function
function Connect-Azure-PoWerShell
{
	# Connect Azure PowerShell with MsolService if ! Connected
	Try
	{
		
		#(1)_.Check to see if any return for Valid cmdlet
		$session = Get-MsolDomain -EA SilentlyContinue
		if ($session)
		{
			#(1.1)_.Connected to O365 Azure PowerShell Module
			Write-Host 'ALREADY Connected: Azure PowerShell' -f Gray -b DarkGreen
			
		}
		else
		{
			
			#(1.2)_.Add Vars Modify $company Var
			$company = '@CloudSec365.onmicrosoft.com'
			$adminUser = "$env:USERNAME"
			$UPN = $adminUser + $company
			Write-Host 'Connecting: Azure PowerShell' -f Gray -b DarkCyan
			$cred = Get-Credential -Credential $UPN -ErrorAction Stop
			Connect-MsolService -Credential $cred -ErrorAction Stop | Out-Null
		}
	}
	Catch
	{
		
		#(2)_.Catch Errors
		Write-Host "ERROR FOUND:$($PSItem.ToString())"
        Write-host 'Scrtip will stop' -f DarkGray
        Start-Sleep -Seconds 5
        break;
		
	}
}Connect-Azure-PoWerShell

#(4)_.Function-Get-TimeStamp 
function Function-Get-TimeStamp { 
     
  return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date) 
     
}

#(5)_.Function Role Report
function Function-Roles-Report {

    [CmdletBinding()]
    param( $String )

#(5.1)_.Get All Roles
$Roles = Get-MsolRole
$i = 1 
$TotalRoles = $Roles.Count

#(5.2)_.Loop through the Azure AD roles
foreach ($Role in $Roles) {
    
    $rolename =  $($Role.Name)   
    Write-Progress -activity "Processing ($rolename)" -status "$i out of ($totalRoles) completed"
    Write-host "($i)_.Working on : $role" -f DarkYellow
    Write-host "`t Processing $rolename" -f DarkCyan

    #(5.3)_.Get the list of members for the role
    $RoleMembers = @(Get-MsolRoleMember -RoleObjectId $Role.ObjectId)

    #(5.4)_.Loop through the list of members
    foreach ($RoleMember in $RoleMembers) {
        $ObjectProperties         = [Ordered]@{
            "Role"                = $Role.Name
            "Display Name"        = $RoleMember.DisplayName
            "Email Address"       = $RoleMember.EmailAddress
            "License"             = $RoleMember.IsLicensed
            "Object ID"           = $RoleMember.ObjectId
            "Description"         = $Role.Description
        }

  #(5.5)_.Start exporting results to CSV
  $OutReport  = New-Object -TypeName PSObject -Property $ObjectProperties
  $OutReport | Export-Csv $Outfile -notypeinformation -Append 
  $OutReport 
    }
    $i++
} 

#(6)_.Open Reports
Write-host 'Completed' -f DarkCyan
Write-host 'Report Time:' -f DarkCyan -NoNewline; Function-Get-TimeStamp
Read-Host 'Press <ENTER> to open report folder'
start $desFol


}Function-Roles-Report




