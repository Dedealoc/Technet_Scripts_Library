
<#     

.NOTES 
#=============================================
# Script      : SMTP_Relay_Test_V1.ps1 
# Created     : ISE 3.0  
# Author(s)   : casey.dedeal  
# Date        : 03/15/2018 20:47:44  
# Org         : ETC Solutions 
# File Name   : SMTP_Relay_Test_V1
# Comments    : Application Relay test
# Assumptions : Relay is allowed
#==============================================

SYNOPSIS           :
DESCRIPTION        :
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : ETC Solutions http://www.etcsol.com/

.EXAMPLE
  .\SMTP_Relay_Test_V1.ps1 

  Description
  -----------
  Run the script to perfrom SMTP Relay test. 
  This script will assume relay is allowed
  From source to destination 
  TCP/IP Port 25 is allowed
  
 (1)_.Adding Env Variables
 (2)_.Change these Vars 
 (3)_.Message Vars
 (4)_.Providing Information
 (5)_Sending Relay Message now


 #(2)_.Change these Vars 
$smtpServer1 = "10.10.10.10"                   # SMTP Server IP Address , for RELAY                     
$smtpFrom    = "Test_Relay_Bulkl@ETCsol.com"   # FRPM Address
$smtpTo      = "Aki.Armstrong@ETCsol.com"      # TO Address 



#> 


clear-host
Write-Host $null
write-host  "-------------------------------------------" -ForegroundColor Yellow
write-host  "How many E-mails you would like to sent out" -ForegroundColor Cyan
write-host  "Provide Numbers from 1 to ANY in digits" -ForegroundColor Cyan
$MailCount  = (Read-Host "How many e-mail you wish to generate?");
write-host  "-------------------------------------------" -ForegroundColor Yellow



1..$MailCount | % {

#(1)_.Adding Env Variables
$var1        = "Test conducted from Server --->[$Computer]"  
$subject     = "Testing SMTP Relay ( $var1 ) "
$body1       = "Smtp relay TEST."
$body2       = "If this E-mail is received.TCP/IP Port [25] is open from [Source] to [Destination]."
$body3       = "SMTP Relay is working as expected."

#(2)_.Change these Vars 
$smtpServer1 = "10.10.10.10"                       
$smtpFrom    = "Test_Relay_Bulkl@ETCsol.com"
$smtpTo      = "Aki.Armstrong@ETCsol.com"

#(3)_.Message Vars
$Computer = $env:computername
$now      = Get-Date -format "(dd-MMM-yyyy)-(HH-mm-ss)"
$message  = "Note: Relay test conducted FROM: "

#(3)_.Subject body Vars
$var3 = "---->"
$var4 = "-"
$messageSubject = $subject + $var4 + $var3 + $now
$messageBody = $body1 + $body2 + $body3 + $message +$Computer + $var3 + $now 


#(4)_.Providing Information
write-host $null
Write-host "--------------------------" -ForegroundColor Yellow
Write-host "()_.Sending SMTP relay Test $now" -ForegroundColor Green
Write-host "()_.SMTP gateway" -f Green -NoNewline; write-host " [ $smtpServer1 ] " -f Blue
Write-host "()_.Recepients  " -f Green -NoNewline; write-host " [ $smtpTo ] " -f Blue
Write-host "--------------------------" -ForegroundColor Yellow

#(5)_Sending Relay Message now
$smtp = New-Object Net.Mail.SmtpClient($smtpServer1)
$smtp.Send($smtpFrom,$smtpTo,$messagesubject,$messagebody)
Write-Host "_Message Sent" -ForegroundColor Green
Write-Host "_Completed" -ForegroundColor Yellow


}


