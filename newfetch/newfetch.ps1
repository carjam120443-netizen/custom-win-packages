param([switch]$NoColor,[switch]$Short,[switch]$Help)

if ($Help) {
  Write-Host "newfetch - native Windows system information"
  Write-Host "Usage: newfetch [-Short] [-NoColor]"
  exit
}

$os=Get-CimInstance Win32_OperatingSystem
$cs=Get-CimInstance Win32_ComputerSystem
$cpu=Get-CimInstance Win32_Processor | Select-Object -First 1
$gpus=@(Get-CimInstance Win32_VideoController | Where-Object {$_.Name -and $_.Name -notmatch 'Microsoft Basic Display'})
$disk=Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
$uptime=(Get-Date)-$os.LastBootUpTime
$ramTotal=[math]::Round($cs.TotalPhysicalMemory/1GB,1)
$ramUsed=[math]::Round(($cs.TotalPhysicalMemory-$os.FreePhysicalMemory*1KB)/1GB,1)
$ramPct=if($ramTotal){[math]::Round(($ramUsed/$ramTotal)*100)}else{0}
$gpuNames=($gpus|ForEach-Object{$_.Name}) -join ", "
if(-not $gpuNames){$gpuNames="Unknown"}
$res=@(Get-CimInstance Win32_VideoController|Where-Object{$_.CurrentHorizontalResolution -and $_.CurrentVerticalResolution}|ForEach-Object{"$($_.CurrentHorizontalResolution)x$($_.CurrentVerticalResolution)"})|Select-Object -Unique
$resText=if($res){$res -join " + "}else{"Unknown"}
$shell="PowerShell $($PSVersionTable.PSVersion)"
$terminal=if($env:WT_SESSION){"Windows Terminal"}elseif($env:TERM_PROGRAM){$env:TERM_PROGRAM}else{"Console Host"}
$edition=(Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -ErrorAction SilentlyContinue).ProductName
if(-not $edition){$edition=$os.Caption}

$lines=@(
  @{Label="OS";Value="$edition (Build $($os.BuildNumber))"},
  @{Label="Host";Value="$($cs.Manufacturer) $($cs.Model)"},
  @{Label="Kernel";Value="Windows NT $([Environment]::OSVersion.Version)"},
  @{Label="Uptime";Value=("{0}d {1}h {2}m" -f [int]$uptime.TotalDays,$uptime.Hours,$uptime.Minutes)},
  @{Label="Shell";Value=$shell},
  @{Label="Terminal";Value=$terminal},
  @{Label="Resolution";Value=$resText},
  @{Label="CPU";Value=$cpu.Name.Trim()},
  @{Label="GPU";Value=$gpuNames},
  @{Label="Memory";Value="$ramUsed GiB / $ramTotal GiB ($ramPct%)"},
  @{Label="Disk";Value=("{0} GiB free / {1} GiB" -f [math]::Round($disk.FreeSpace/1GB,1),[math]::Round($disk.Size/1GB,1))}
)

if($Short){Write-Host "newfetch | $edition | $($cpu.Name.Trim()) | RAM $ramUsed/$ramTotal GiB | GPU $gpuNames";exit}

# Four-pane ASCII Windows logo; rendered blue in normal mode.
$logo=@(
"   +--------+  +--------+",
"   |        |  |        |",
"   |        |  |        |",
"   |        |  |        |",
"   +--------+  +--------+",
"   +--------+  +--------+",
"   |        |  |        |",
"   |        |  |        |",
"   |        |  |        |",
"   +--------+  +--------+"
)

$labelWidth=(($lines.Label | Measure-Object Length -Maximum).Maximum)+2
$logoWidth=($logo | ForEach-Object {$_.Length} | Measure-Object -Maximum).Maximum
$gap=4
$rightStart=$logoWidth+$gap

$consoleWidth=try {[Console]::WindowWidth} catch {120}
if($consoleWidth -lt 60){$consoleWidth=60}
$maxValueWidth=[math]::Max(20,$consoleWidth-$rightStart-$labelWidth-2)

for($i=0;$i -lt [math]::Max($logo.Count,$lines.Count);$i++){
  $left=if($i -lt $logo.Count){$logo[$i]}else{""}
  if($i -lt $lines.Count){
    $value=[string]$lines[$i].Value
    if($value.Length -gt $maxValueWidth){
      $value=$value.Substring(0,$maxValueWidth-3)+"..."
    }
    $right=$lines[$i].Label.PadRight($labelWidth)+$value
  }else{$right=""}

  if($NoColor){
    Write-Host ($left.PadRight($rightStart)+$right)
  }else{
    Write-Host $left.PadRight($rightStart) -NoNewline -ForegroundColor Blue
    if($right){Write-Host $right -ForegroundColor Gray}else{Write-Host ""}
  }
}

Write-Host ""
if($NoColor){
  Write-Host "  newfetch - native PowerShell Windows port"
}else{
  Write-Host "  newfetch - native PowerShell Windows port" -ForegroundColor DarkCyan
}
