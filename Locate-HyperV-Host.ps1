
<#     

.NOTES 
#=============================================
# Script      : Locate-HyperV-Host.ps1 
# Created     : ISE 3.0  
# Author(s)   : Casey Dedeal  
# Date        : 06/11/2018 09:11:06  
# Org         : ETC Solutions 
# File Name   : Locate-HyperV-Host.ps1 
# Comments    :
# Assumptions : 
#==============================================

SYNOPSIS           : Locate HyperV Host FQDN
DESCRIPTION        : 
Acknowledgements   : Open license 
Limitations        : None
Known issues       : None 
Credits            : None 

.EXAMPLE
  .\Locate-HyperV-Host.ps1

  MAP:
  -----------
  (1)_.Capture User input
  (2)_.Perform connectivity test , stops if host is not responding ICMP
  (3)_.Invoke command remote PC to collect HyperV host FQDN

#> 

Clear-host 
#(1)_.Capture User input
write-host $null
write-host "------------------------------" -f Yellow 
$vmclient = Read-Host -Prompt 'Provide HyperV- Client FQDN'

if ([string]::IsNullOrWhiteSpace($vmclient)){

Write-Warning "Name cannot be blank or contains space" 
break;

}

#(2)_.Perform connectivity test , stops if host is not responding ICMP
if (Test-Connection -computername $vmclient -Quiet -Count 1) {
   write-host "`tSuccesfully connected to [$vmclient]" -f Green -b Black
} else {
   write-host "`tFailed to connect to [$vmclient]" -f Red -b Black
   write-host "`tTeminating script" 
   Start-Sleep -Seconds 3
   break;
}
#(3)_.Invoke command remote PC to collect HyperV host FQDN
Write-host "(-)_Processing..." -f Yellow 
Invoke-Command -ComputerName $vmclient {
$rhost   = (get-item "HKLM:\SOFTWARE\Microsoft\Virtual Machine\Guest\Parameters").GetValue("HostName")
$client = $env:COMPUTERNAME
$domain = $env:USERDNSDOMAIN 
$cfqdn  = $client + $domain
Write-host $null
Write-host "++++++++++++++++++++++++++++++++++" -f Green
Write-host "Hyper-V Host   : [$rhost]  "
Write-host "Hyper-V Client : [$cfqdn] " 
Write-host "++++++++++++++++++++++++++++++++++" -f Green

}

