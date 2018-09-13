 Function Get-OutlookCalendar
{
 Add-type -assembly "Microsoft.Office.Interop.Outlook" | out-null 
 $olFolders = "Microsoft.Office.Interop.Outlook.OlDefaultFolders" -as [type]  
 $outlook = new-object -comobject outlook.application 
 $namespace = $outlook.GetNameSpace("MAPI") 
 $folder = $namespace.getDefaultFolder($olFolders::olFolderCalendar) 
 $folder.items |Select-Object -Property Subject, Start, Duration, Location
}

$Start = (Get-Date).AddDays(-10).DateTime
$End = (Get-Date).AddDays(+1).DateTime

Get-OutlookCalendar | where-object { $_.start -gt [datetime]$Start -AND $_.start -le [datetime]$End }