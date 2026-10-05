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
$edition=(Get-ItemProperty "HKLM:SOFTWAREMicrosoftWindows NTCurrentVersion" -ErrorAction SilentlyContinue).ProductName
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
$logo=@(
"        ████████████████  ████████████████",
"        ████████████████  ████████████████",
"        ████████████████",
"        ████████████████",
"        ████████████████  ████████████████",
"        ████████████████  ████████████████",
"                                ████████████████",
"                                ████████████████",
"        ████████████████████████████████████",
"        ████████████████████████████████████"
)
$maxLabel=($lines.Label|Measure-Object Length -Maximum).Maximum
$width=$maxLabel+2
for($i=0;$i -lt [math]::Max($logo.Count,$lines.Count);$i++){
  $left=if($i -lt $logo.Count){$logo[$i]}else{""}
  $right=if($i -lt $lines.Count){$lines[$i].Label.PadRight($width)+$lines[$i].Value}else{""}
  if($NoColor){Write-Host ("{0,-48} {1}" -f $left,$right)}
  else {
    Write-Host ("{0,-48}" -f $left) -NoNewline -ForegroundColor Blue
    if($right){Write-Host $right -ForegroundColor Gray}else{Write-Host ""}
  }
}
if($NoColor){
  Write-Host ""
  Write-Host "  newfetch • native PowerShell Windows port"
}else{
  Write-Host ""
  Write-Host "  newfetch • native PowerShell Windows port" -ForegroundColor DarkCyan
}