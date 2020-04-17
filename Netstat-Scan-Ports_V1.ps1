
<#     

.NOTES 
#=============================================
# Script      : Netstat-Scan-Ports_V1.ps1 
# Created     : ISE 3.0  
# Author(s)   : c-casey.dedeal  
# Date        : 04/02/2018 09:42:30  
# Org         : ETC Solutions 
# File Name   : Scan Network Port
# Comments    : Scan multiple ports
# Assumptions : 
#==============================================

SYNOPSIS           : Netstat-Scan-Ports_V1.ps1 
DESCRIPTION        : Scan multiple ports
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\Netstat-Scan-Ports_V1.ps1

  Description
  -----------
  Run the script o scan multiple TCP/IP Ports
  (1)_.Function to define log directory and vars
  (2)_.Create Log folder If ! exist 
  (3)_.Function open log directories
  (4)_.If no port defined use default ports
  (5)_.Scan the ports

  Note: Script will dump the results into log file
        to open the log file location , execute the function
        typing | OpenLog | after terminating the script.


#> 

  
#(1)_.define vars
$now = Get-Date -format "dd-MMM-yyyy-HH-mm"
$lname = "Trace.log"
$path = "c:\temp\Logs\"
$log = $path + $now + $lname
$server = $env:computername


#(2)_.Create Log folder If ! exist If (!(Test-Path $log)) {New-Item -ItemType file -Force $log}

#(3)_.Function open log directories
function OpenLog
{
   $path = "c:\temp\Logs\"
   $log = $path + $now + $lname
   write-host "()_.Opening Logs directory" -ForegroundColor Yellow 
   start $path  
}

Clear-Host
write-host "-----------------------------------------------------" -F Yellow
$port1 = Read-Host -Prompt 'Provide first  port number to scan [Port-Number]'
$port2 = Read-Host -Prompt 'Provide second port number to scan [Port-Number]'
$port3 = Read-Host -Prompt 'Provide third  port number to scan [Port-Number]'
write-host "-----------------------------------------------------" -F Yellow

#(4)_.If no port defined use default ports
if ([string]::IsNullOrWhiteSpace($port1))
{ $port1= '6000' }
if ([string]::IsNullOrWhiteSpace($port2))
{ $port2= '444' }
if ([string]::IsNullOrWhiteSpace($port3))
{ $port3= '2000' }

#(5)_.Scan the ports
write-host $null
do{
write-host $null
clear-host
write-host "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -f yellow
 write-host "(a)_.Netstat Port scanning started" 
 write-host "(b)_.Scanning Server:"---> -f white -NoNewline;Write-host " [$server]" -f Cyan
 Write-Host "(c)_.TCP/IP Ports:"---> -f white -NoNewline;Write-Host " [$port1] [$port2] [$port3]" -f Green 
 write-host "(d)_.Logging enabled" 
 write-host "(e)_.Logs location [$log]" 
 write-host "(e)_.Type [OpenLog] when terminating the loop" 
 write-host "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" -f yellow
write-host $null
netstat -ano | findstr "$port1 $port2 $port3" | tee -a $log;sleep 5

}
while ($true)


