$csvpath = "C:\Users\brajesh.d\Desktop\scripts monitoring\06-Apr-17-brajesh.d.csv"
if (Test-Path $csvpath)
{
$a=(Import-Csv $csvpath).CurrentApplication
$array=@()
$handles=@()
$unique1=$a|Sort-Object -Unique
foreach ($b in $unique1)
{
$Matches = Select-String -InputObject $a -Pattern $b -AllMatches

$temp=$Matches.Matches.Count

$h=[int]($temp/3600)


$h1=[int]($temp%3600)
$m=[int]($h1/60)
$s1=[int]($h1%60)

if([int]($h/10) -eq 0)
{
$hh="0$h"
}
else{
$hh="$h"
}
if([int]($m/10) -eq 0)
{
$mm="0$m"
}
else{
$mm="$m"
}

if([int]($s1/10) -eq 0)
{
$ss="0$s1"
}
else{
$ss="$s1"
}
$time = $hh+":"+$mm+":"+$ss
$handles+=([int]$time.Split(":")[0]+(([int]$time.Split(":")[1])/60)+([int]$time.Split(":")[2])/3600)
$array+= $b + "`n" + [math]::Round([int]$time.Split(":")[0]+(([int]$time.Split(":")[1])/60)+([int]$time.Split(":")[2])/3600,3) +" "+"hrs"

#$time|Select @{name="process";e={$b}},@{name="Activetime";e={$time}} | Export-Csv "D:\mani temp\Bladelogic\n\active.csv" -Append -NoTypeInformation 
}
$array
}