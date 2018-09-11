while(Test-Path "$env:SystemDrive"){
$exportpath = "$env:SystemDrive"+"\report\"+$env:USERNAME+"\browsing-"+$env:USERNAME+"-"+(get-date).ToString("dd-MMM-yy")+".csv"
Function GetCurrentIEURL
{
    $IEObjs = @()
    $ShellWindows = (New-Object -ComObject Shell.Application).Windows()

    Foreach($IE in $ShellWindows)
    {
        $FullName = $IE.FullName
        If($FullName -ne $NULL)
        {
            $FileName = Split-Path -Path $FullName -Leaf

            If($FileName.ToLower() -eq "iexplore.exe")
            {
                $Title = $IE.LocationName
                $URL = $IE.LocationURL
                $IEObj = New-Object -TypeName PSObject -Property @{Browser = "IE"; URL = $URL;Title = $Title; Time= (Get-Date)}
                $IEObjs += $IEObj
            }
        }
    }

    $IEObjs
}
if(!(Test-Path $exportpath))
{
New-item $exportpath -itemtype File -Force|Out-Null
$a = Get-Process | ?{$_.MainWindowHandle -ne 0}|?{($_.Name -eq "chrome") -or ($_.Name -eq "firefox")}
if($a.Length -gt 0)
{
$a|select -first 2 |select @{n="Browser";e={$_.name}},URL,@{n="Title";e={$_.MainWindowTitle}},@{n="Time";e={Get-Date}}|Export-csv $exportpath -NoTypeInformation -append
}else
{
""|select @{n="Browser";e={"Chrome or Firefox"}},URL,@{n="Title";e={"not open"}},@{n="Time";e={Get-Date}}|Export-csv $exportpath -NoTypeInformation -append
}
GetCurrentIEURL|Export-csv $exportpath -NoTypeInformation -append
}
$b= (Get-ItemProperty -Path $exportpath).LastWriteTime
if([int](New-TimeSpan -end (get-date) -start $b).TotalMinutes -gt 2)
{
$a = Get-Process | ?{$_.MainWindowHandle -ne 0}|?{($_.Name -eq "chrome") -or ($_.Name -eq "firefox")}
if($a.Length -gt 0)
{
$a|select -first 2 |select @{n="Browser";e={$_.name}},URL,@{n="Title";e={$_.MainWindowTitle}},@{n="Time";e={Get-Date}}|Export-csv $exportpath -NoTypeInformation -append
}else
{
""|select @{n="Browser";e={"Chrome or Firefox"}},URL,@{n="Title";e={"not open"}},@{n="Time";e={Get-Date}}|Export-csv $exportpath -NoTypeInformation -append
}
GetCurrentIEURL|Export-csv $exportpath -NoTypeInformation -append
}
Sleep -Seconds 195
}