
 
<#     

.NOTES 
#=============================================
# Script      : Free_Disk_Space_Report_V1.ps1 
# Created     : ISE 3.0  
# Author(s)   : casey.dedeal  
# Date        : 02/23/2018 08:03:25  
# Org         : ETC Solutions 
# File Name   : Free_Disk_Space_Report_V1.ps1 
# Comments    : LUN Space for Each Server
# Assumptions : Exchange 2016 Servers   
#==============================================

SYNOPSIS           : Free_Disk_Space_Report_V1.ps1 
DESCRIPTION        : Get LUN Space
Acknowledgements   : Simple LUN Free Space Script
Limitations        : Exchange Management Shell 
Known issues       : None

.EXAMPLE
  .\Free_Disk_Space_Report_V1.ps1 

  Description
  -----------
  Runs the script to gather LUN free Space

  (1)_.Prepare variables 
  (2)_.Writing Activity Output
  (3)_.Collecting MBX Exchange 2016 Servers Information
  (4)_.Adjusting Variables
  (5)_.Creating Function mountpoint ( LUNS )
  (6)_.Looping and running the function for Each Exchange 2016 Servers 
  (7)_.Results In GridView 
  (8)_.Exporting into CSV 
  (9)_.Open output file directory


#> 


#(1)_.Preapare variables 
$user = $env:username
$path = "C:\Users\$user\Desktop\REPORTS_\Disk_\"
$name = "_DiskSpaceReport"
$csv  = ".csv"
$file = $path + "_" + $name + "_" + $time + $csv
$time = (Get-Date -format "dd-MMM-yyyy-HH-mm")

#(2)_.Writing Activity Output
clear-host
write-host $null
Write-progress -Activity 'Please Wait'

#(3)_.Collecting MBX Exchange 2016 Servers Information
$Servers  = (Get-MailboxServer | ? {$_.AdminDisplayVersion -Match "^Version 15" }).name

#(4)_.Adjusting Variables
$CapacityGB = @{Name="LUN_Capacity(GB)";expression={[math]::round(($_.Capacity/ 1073741824),2)}}
$FreeSpaceGB  = @{Name="LUN_FreeSpace(GB)";expression={[math]::round(($_.FreeSpace / 1073741824),2)}}
$FreePercentage = @{Name="LUN_Free(%)";expression={[math]::round(((($_.FreeSpace / 1073741824)/($_.Capacity / 1073741824)) * 100),0)}}

#(5)_.Creating Function mountpoint ( LUNS )
function get-mountpoints {
$volumes = Get-WmiObject -computer $server win32_volume | Where-object {$_.DriveLetter -eq $null}
$volumes | Select SystemName,Label,$CapacityGB,$FreeSpaceGB,$FreePercentage | Sort-Object -Property SystemName
}

#(6)_.Looping and running the function for Each Exchange 2016 Servers 
$foreloop = foreach ($server in $servers){
 write-host "Scanning" -f Yellow -NoNewline; write-host "-->[$server]" -f Green
 get-mountpoints
 write-host "Done." -f Cyan

}

#(7)_.Results In GridView 
 write-host $null
 $foreloop | Out-GridView

#(8)_.Exporting into CSV 
$foreloop | Export-Csv -Path $file -NoTypeInformation 
Write-host "-----------------------------------------------" -f Yellow
Write-host "()_Report has been saved to following Directory"
$file

#(9)Open output file directory 
start $path 

