Function Net-Usage
{
    #Start testing the connection and continue until the connection is good.
    Function NetworkUp
    {
    $wait = 300
    While (((Get-WmiObject -class "Win32_NetworkAdapterConfiguration" | Where {$_.IPEnabled -Match "True"}).DHCPEnabled -eq "true")) {

        $colItems = Get-WmiObject -class "Win32_NetworkAdapterConfiguration" | Where {$_.IPEnabled -Match "True" -and $_.dhcpenabled -Match "True"}
foreach ($objItem in $colItems) {
    
    $a= $objItem.IPAddress|Out-String
    $b=$a.contains("192.")
    $c=$a.contains("10.")
   }
if (!$b -and !$c )
{
$date =(Get-Date).ToString("dd-MMM-yy")
$path = "$env:SystemDrive"+"\report\"+"$env:username"+"\"+$date+"-"+"net-"+"$env:username"+".csv"
$fileExistenceCheck= Test-Path $path
if(!($fileExistenceCheck -eq "true"))
{
New-Item $path -ItemType file -Force
""|select Date,User,HostName,Private,OfficeNetwork,NoNetwork|export-csv $path -NoTypeInformation
$csv = import-csv $path
[int]$csv.Private+=5
$csv.Date= (get-date).tostring("dd-MMM-yy")
$csv.User= $env:username
$csv.HostName= $env:computername
$csv|Export-Csv $path -NoTypeInformation -Force
}
$csv = import-csv $path
[int]$csv.Private+=5
$csv.Date= (get-date).tostring("dd-MMM-yy")
$csv.User= $env:username
$csv.HostName= $env:computername
$lwt = [datetime](Get-ItemProperty -Path $path -Name LastWriteTime).lastwritetime
$timespan=[int](New-TimeSpan -start $lwt -End (Get-Date)).TotalMinutes
if($timespan -ge 4)
{
$csv|Export-Csv $path -NoTypeInformation -Force
}
}elseif($c)
{
$date =(Get-Date).ToString("dd-MMM-yy")
$path = "$env:SystemDrive"+"\report\"+"$env:username"+"\"+$date+"-"+"net-"+"$env:username"+".csv"
$fileExistenceCheck= Test-Path $path
if(!($fileExistenceCheck -eq "true"))
{
New-Item $path -ItemType file -Force
""|select Date,User,HostName,Private,OfficeNetwork,NoNetwork|export-csv $path -NoTypeInformation
$csv = import-csv $path
[int]$csv.OfficeNetwork+=5
$csv.Date= (get-date).tostring("dd-MMM-yy")
$csv.User= $env:username
$csv.HostName= $env:computername
$csv|Export-Csv $path -NoTypeInformation -Force
}
$csv = import-csv $path
[int]$csv.OfficeNetwork+=5
$csv.Date= (get-date).tostring("dd-MMM-yy")
$csv.User= $env:username
$csv.HostName= $env:computername
$lwt = [datetime](Get-ItemProperty -Path $path -Name LastWriteTime).lastwritetime
$timespan=[int](New-TimeSpan -start $lwt -End (Get-Date)).TotalMinutes
if($timespan -gt 5)
{
$csv|Export-Csv $path -NoTypeInformation -Force
}
}elseif ($b)
{
$date =(Get-Date).ToString("dd-MMM-yy")
$path = "$env:SystemDrive"+"\report\"+"$env:username"+"\"+$date+"-"+"net-"+"$env:username"+".csv"
$fileExistenceCheck= Test-Path $path
if(!($fileExistenceCheck -eq "true"))
{
New-Item $path -ItemType file -Force
""|select Date,User,HostName,Private,OfficeNetwork,NoNetwork|export-csv $path -NoTypeInformation
$csv = import-csv $path
[int]$csv.Private+=5
$csv.Date= (get-date).tostring("dd-MMM-yy")
$csv.User= $env:username
$csv.HostName= $env:computername
$csv|Export-Csv $path -NoTypeInformation -Force
}
$csv = import-csv $path
[int]$csv.Private+=5
$csv.Date= (get-date).tostring("dd-MMM-yy")
$csv.User= $env:username
$csv.HostName= $env:computername
$lwt = [datetime](Get-ItemProperty -Path $path -Name LastWriteTime).lastwritetime
$timespan=[int](New-TimeSpan -start $lwt -End (Get-Date)).TotalMinutes
if($timespan -gt 5)
{
$csv|Export-Csv $path -NoTypeInformation -Force
}
}
        Start-Sleep -Seconds $wait
        }
    #Connection is good
    #Write-Host -ForegroundColor Green "$(Get-Date): Connection up!"
    NetworkDown
    }

    Function NetworkDown
    {
    While (!((Get-WmiObject -class "Win32_NetworkAdapterConfiguration" | Where {$_.IPEnabled -Match "True" -and $_.dhcpenabled -Match "True"}).DHCPEnabled -eq "true")) {
        $date =(Get-Date).ToString("dd-MMM-yy")
$path = "$env:SystemDrive"+"\report\"+"$env:username"+"\"+$date+"-"+"net-"+"$env:username"+".csv"
$fileExistenceCheck= Test-Path $path
if(!($fileExistenceCheck -eq "true"))
{
New-Item $path -ItemType file -Force
""|select Date,User,HostName,Private,OfficeNetwork,NoNetwork|export-csv $path -NoTypeInformation
$csv = import-csv $path
[int]$csv.NoNetwork+=1
$csv.Date= (get-date).tostring("dd-MMM-yy")
$csv.User= $env:username
$csv.HostName= $env:computername
$csv|Export-Csv $path -NoTypeInformation -Force
}
        $csv = import-csv $path
[int]$csv.NoNetwork+=1
$csv.Date= (get-date).tostring("dd-MMM-yy")
$csv.User= $env:username
$csv.HostName= $env:computername
$lwt = [datetime](Get-ItemProperty -Path $path -Name LastWriteTime).lastwritetime
$timespan=[int](New-TimeSpan -start $lwt -End (Get-Date)).TotalMinutes
if($timespan -ge 1)
{
$csv|Export-Csv $path -NoTypeInformation -Force
        
        }
        Start-Sleep -Seconds 60
        }
    #Connection is good
    #Write-Host -ForegroundColor Green "$(Get-Date): Connection up!"
    NetworkUp
    }
   NetworkUp
   NetworkDown
   }
Net-Usage