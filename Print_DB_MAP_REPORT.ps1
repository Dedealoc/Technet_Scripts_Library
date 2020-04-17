
<#     

.NOTES 
#=============================================
# Script      : Print_DB_MAP_REPORT.ps1
# Created     : ISE 3.0  
# Author(s)   : Casey.Dedeal  
# Date        : 02/10/2019 11:19:52  
# Org         : ETC Solutions 
# File Name   : 
# Comments    :
# Assumptions : 
#==============================================

SYNOPSIS           :
DESCRIPTION        :
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\Print-DB_MAP_REPORT.ps1
  .\Print-DB_MAP_REPORT.ps1 -Server <MAIL-SERVER-NAME>

  MAP:
  -----------
  (1)_.Function -- Invoke-Choice
  (2)_.Function -- Check-DB-Health-MAP ~ requied paramater $Server
  (3)_.PRINT REPORT
  (4)_.INVOKE-Choice

#> 



 #()_. DB Health Report Get Single Server
        Clear-host 

 #(1)_.Function -- Invoke-Choice
  function Invoke-Choice {
 [CmdletBinding()]
 param ([string] $Message = ‘(Print DB-Health Report)’, `
        [string] $Title = ‘Continue or Cancel’)
Add-Type -AssemblyName ‘System.Windows.Forms’
$MsgBox = [Windows.Forms.MessageBox]
 $Decision = $MsgBox::Show($Message, $Title, ‘OkCancel’, ‘Information’)
If ($Decision -eq ‘Cancel’) {break;}
 }

 #(2)_.Function -- Check-DB-Health-MAP ~Requied paramater $Server
  function Check-DB-Health-MAP {            
             
param (            

         
[parameter(Mandatory = $true)]             
[string]$Server         
             
)            
                         
$HealthMap = Get-MailboxDatabaseCopyStatus -Server $server | Sort-Object Status  |`
            select  Name,Status,ContentIndexState,ReplayQueueLength, `
                    CopyQueueLength,MailBoxServer,ActiveDatabaseCopy

#(3)_.PRINT REPORT

Write-Warning "++++++++++++++++++++++"  
Write-Host "`nDatabase Health MAP ($Server)" -f Yellow 
$HealthMap | ft -AutoSize

#(4)_.INVOKE-Choice
Invoke-Choice
$HealthMap | Out-GridView            
        
             
}