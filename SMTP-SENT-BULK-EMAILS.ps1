 
<#     

.NOTES 
#=============================================
# Script      : SMTP-SENT-BULK-EMAILS.ps1 
# Created     : ISE 3.0  
# Author(s)   : Casey.Dedeal  
# Date        : 10/11/2019 14:46:37  
# Org         : ETC Solutions 
# File Name   : SMTP-SENT-BULK-EMAILS.ps1 
# Comments    : Relay Test Bulk Emails
# Assumptions : 
#==============================================

SYNOPSIS           : SMTP-SENT-BULK-EMAILS.ps1 
DESCRIPTION        : Sent Bulk SMTP Mails 
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\SMTP-SENT-BULK-EMAILS.ps1 

  MAP:
  -----------

  #(1)_.Mail Gateways 
  #(2)_.Adjust Subject & BODY & From addess Vars
  #(3)_.Define Folder Location
  #(4}_.Define Att Names
  #(5)_.Create folder
  #(6)_.Verify Attachment List 
  #(7)_.Constract SMTP ARRAY List
  #(8)_.Add Counter
  #(9)_.Provide Info

  #(10)_.Starting loop 
  #(11)_.Loop for Seding email
  #(12)_.Sending Message

#> 





#(1)_.Define SMTP Relay Host 
$smtpserver1    = "MailRelay1.Your_relay.com" 
$smtpserver2    = "MailRelay2.Your_relay.com"

#(2)_.Adjust Subject & BODY & From addess Vars
$Subject      = "Bulk Mail Relay test" 
$body         = "Sending BULK EMAILS to Multiple recepients" 
$fromaddress  = "SpamKing@SpamKingdom.com"

#(3)_.Define Attachment List
$attname1 = "This_File_is_ALLOWED.zip"
$attname2 = "This_File_is_FORBIDEN.zip"


#(4)_.Define Folder Location
$user = $env:USERNAME
$AttPath  = "C:\Users\$user\Desktop\Reports_\Relay_Test\"

#(5)_.Define Attc Names
$att1  = $AttPath + $attname1
$att2  = $AttPath + $attname2



#(6)_.Create folder
If (!(Test-Path $AttPath)) {New-Item -ItemType Directory -Force $AttPath | Out-Null}

#(7)_.Verify Attachment List 

If (!(Test-Path $att1) ){
  Write-host "Attachment NOT found" -f Red
  Write-Warning "[$att1] FAILED"
  Write-Warning "Script wll stop"
  Start-Sleep -Seconds 5
  break;
}

If (!(Test-Path $att2) ){
  Write-host "Attachment NOT found" -f Red
  Write-Warning "[$att2] FAILED"
  Write-Warning "Script wll stop"
  Start-Sleep -Seconds 5
  break;
}


#(8)_.Constract SMTP ARRAY List
 $array=@(
  
 # On Prem 
 "User1@YourSMTPdomain.com"
 "User2@YourSMTPdomain.com"

 "User3@YourSMTPdomain.com"
 "User4@YourSMTPdomain.com"

         )

#(9)_.Add Counter
$i = 1


#(10)_.Provide Info
Clear-Host
$HowMany =  Read-host "(-)_.Provide <Number> for bulk emails"
Write-host "[$HowMany] Emails will be sent out" -f Cyan
Write-warning "Recepients List" 
Write-host "---------------------------------------" - -f Yellow -b black
$array 
Write-host "---------------------------------------" -f Yellow -b black
Read-Host "press <ENTER> to continue"


#(11)_.Starting loop foreach($RelayTest in 1..$HowMany){

Write-Progress -activity "Processing " -status "$i"

#(12)_.Loop for Seding email
foreach ($toaddress in $array)
{
    

Write-Progress -activity "Processing " -status "$i"
Write-host "Sending mail to ($toaddress)" -f Cyan

#(13)_.Sending Message
$message = new-object System.Net.Mail.MailMessage 
$message.From = $fromaddress 
$message.To.Add($toaddress)
$message.IsBodyHtml = $True 
$message.Subject = $Subject 
$attach = new-object Net.Mail.Attachment($att3) 
$message.Attachments.Add($attach) 
$message.body = $body 
$smtp = new-object Net.Mail.SmtpClient($smtpserver2) 
$smtp.Send($message)
Write-host "Done" -f yellow
$i++

}

}







