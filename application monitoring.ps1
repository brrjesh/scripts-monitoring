[CmdletBinding()]            
Param(            
)
clear
do
{
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class UserWindows {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@            
try 
{            
    $ActiveHandle = [UserWindows]::GetForegroundWindow()          
    $Process = Get-Process | ? {$_.MainWindowHandle -eq $activeHandle} 

    if(!($Process.Name -eq "CcmExec" -or $Process.Name -eq "audiodg"))
    {
	$date=(Get-Date).ToString("dd-MMM-yy")
	$appoutput="$env:SystemDrive"+"\report\"+$env:username+"\"+$date+"-"+"appusage-"+$env:username+".csv"
    if(!(Test-Path $appoutput))
    {
    New-Item $appoutput -ItemType file -Force|out-null
    }
        $Process | Select @{name="CurrentApplication";e={$_.processname}},@{name="Date";e={get-date}}| Export-Csv $appoutput -Append -NoTypeInformation 
        if(!($Process.Name))
        {
        ""| Select @{name="CurrentApplication";e={"System Idle"}},@{name="Date";e={get-date}}| Export-Csv $appoutput -Append -NoTypeInformation|out-null
        }
    }
    
    Start-Sleep -Milliseconds 1000            
                        
} 
catch 
{            
    Write-Error "Failed to get active Window details. More Info: $_"            
}
}
while($true)
