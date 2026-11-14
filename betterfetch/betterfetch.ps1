param(
    [switch]$Short,
    [switch]$NoColor,
    [switch]$NoApps,
    [switch]$Help
)

$ErrorActionPreference = 'SilentlyContinue'
if ($Help) {
    Write-Host 'BetterFetch - enhanced Windows system and PATH fetch'
    Write-Host 'Usage: betterfetch [-Short] [-NoColor] [-NoApps] [-Help]'
    exit 0
}

function Get-RegValue([string]$Path, [string]$Name, [string]$Fallback = 'Unknown') {
    $v = (Get-ItemProperty -LiteralPath $Path -Name $Name -ErrorAction SilentlyContinue).$Name
    if ($null -eq $v -or [string]::IsNullOrWhiteSpace([string]$v)) { return $Fallback }
    return [string]$v
}
function Write-Accent([string]$Text, [ConsoleColor]$Color = [ConsoleColor]::Cyan) {
    if ($NoColor) { Write-Host $Text } else { Write-Host $Text -ForegroundColor $Color }
}

$os = Get-CimInstance Win32_OperatingSystem
$cs = Get-CimInstance Win32_ComputerSystem
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
$bios = Get-CimInstance Win32_BIOS
$board = Get-CimInstance Win32_BaseBoard | Select-Object -First 1
$gpus = @(Get-CimInstance Win32_VideoController | Where-Object { $_.Name -and $_.Name -notmatch 'Microsoft Basic Display' })
$reg = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'

$product = Get-RegValue $reg 'ProductName' $os.Caption
$version = Get-RegValue $reg 'DisplayVersion' (Get-RegValue $reg 'ReleaseId')
$build = Get-RegValue $reg 'CurrentBuild' $os.BuildNumber
$ubr = Get-RegValue $reg 'UBR' '0'
$edition = Get-RegValue $reg 'EditionID'
$installType = Get-RegValue $reg 'InstallationType'
$kernel = [Environment]::OSVersion.Version
$uptime = (Get-Date) - $os.LastBootUpTime

$totalRam = [math]::Round($cs.TotalPhysicalMemory / 1GB, 1)
$usedRam = [math]::Round(($cs.TotalPhysicalMemory - ($os.FreePhysicalMemory * 1KB)) / 1GB, 1)
$ramPct = if ($totalRam -gt 0) { [math]::Round($usedRam / $totalRam * 100) } else { 0 }
$gpuText = if ($gpus.Count) { ($gpus | ForEach-Object { $_.Name.Trim() }) -join ', ' } else { 'Unknown' }
$res = @(Get-CimInstance Win32_VideoController | Where-Object { $_.CurrentHorizontalResolution -and $_.CurrentVerticalResolution } | ForEach-Object { "$($_.CurrentHorizontalResolution)x$($_.CurrentVerticalResolution)" } | Select-Object -Unique)
$resText = if ($res.Count) { $res -join ', ' } else { 'Unknown' }
$terminal = if ($env:WT_SESSION) { 'Windows Terminal' } elseif ($env:TERM_PROGRAM) { $env:TERM_PROGRAM } elseif ($env:ConEmuANSI) { 'ConEmu' } else { 'Console Host' }
$cpuText = if ($cpu) { $cpu.Name.Trim() } else { 'Unknown' }
$hostText = "$($cs.Manufacturer) $($cs.Model)"
$boardText = if ($board -and $board.Product) { "$($board.Manufacturer) $($board.Product)" } else { 'Unknown' }
$drive = $env:SystemDrive
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$drive'"
$diskText = if ($disk -and $disk.Size) { '{0} GiB free / {1} GiB' -f [math]::Round($disk.FreeSpace / 1GB, 1), [math]::Round($disk.Size / 1GB, 1) } else { 'Unknown' }

$pathCommands = @()
if (-not $NoApps) {
    $pathCommands = @(Get-Command -CommandType Application,ExternalScript -ErrorAction SilentlyContinue | Sort-Object Name -Unique)
}
$pathCount = $pathCommands.Count
$appSample = @($pathCommands | Select-Object -First 14 | ForEach-Object { [IO.Path]::GetFileNameWithoutExtension($_.Name) } | Select-Object -Unique)

$osText = "$product $version (Build $build.$ubr)"
if ($Short) {
    Write-Host ("BetterFetch | {0} | {1} | RAM {2}/{3} GiB | {4} PATH commands" -f $osText, $cpuText, $usedRam, $totalRam, $pathCount)
    exit 0
}

$rows = @(
    @{ Label='OS'; Value=$osText },
    @{ Label='Edition'; Value=$edition },
    @{ Label='Install'; Value=$installType },
    @{ Label='Host'; Value=$hostText },
    @{ Label='Motherboard'; Value=$boardText },
    @{ Label='BIOS'; Value=$bios.SMBIOSBIOSVersion },
    @{ Label='Kernel'; Value="Windows NT $kernel ($($os.OSArchitecture))" },
    @{ Label='Uptime'; Value=('{0}d {1}h {2}m' -f [int]$uptime.TotalDays, $uptime.Hours, $uptime.Minutes) },
    @{ Label='Shell'; Value="PowerShell $($PSVersionTable.PSVersion)" },
    @{ Label='Terminal'; Value=$terminal },
    @{ Label='Resolution'; Value=$resText },
    @{ Label='CPU'; Value=$cpuText },
    @{ Label='GPU'; Value=$gpuText },
    @{ Label='Memory'; Value="$usedRam / $totalRam GiB ($ramPct%)" },
    @{ Label="Disk ($drive)"; Value=$diskText }
)

$art = @(
'          __________________________',
'         /  _________  / _________ /|',
'        /  /        /|/ /        /| |',
'       /__/________/ |/__/_______/ | |',
'       |  |        | | |  |      | | |',
'       |  |  ░░░   | | |  | ▒▒▒  | | |',
'       |  |  ░░░   | / |  | ▒▒▒  | / /',
'       |  |________|/  |  |______|/ /',
'       |  /___________/| /_________/ ',
'       | /___________/ |            ',
'       |/______________|'
)
$labelWidth = (($rows | ForEach-Object { $_.Label.Length } | Measure-Object -Maximum).Maximum) + 2
$leftWidth = (($art | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum) + 4
$consoleWidth = 120
try { if ([Console]::WindowWidth -gt 0) { $consoleWidth = [Console]::WindowWidth } } catch {}
$maxValueWidth = [math]::Max(24, $consoleWidth - $leftWidth - $labelWidth - 2)

for ($i=0; $i -lt [math]::Max($art.Count,$rows.Count); $i++) {
    $left = if ($i -lt $art.Count) { $art[$i] } else { '' }
    $right = ''
    if ($i -lt $rows.Count) {
        $value = [string]$rows[$i].Value
        if ([string]::IsNullOrWhiteSpace($value)) { $value = 'Unknown' }
        if ($value.Length -gt $maxValueWidth) { $value = $value.Substring(0,[math]::Max(1,$maxValueWidth-3)) + '...' }
        $right = $rows[$i].Label.PadRight($labelWidth) + $value
    }
    if ($NoColor) { Write-Host ($left.PadRight($leftWidth) + $right) }
    else {
        Write-Host $left.PadRight($leftWidth) -NoNewline -ForegroundColor DarkCyan
        if ($i -lt $rows.Count) {
            Write-Host $rows[$i].Label.PadRight($labelWidth) -NoNewline -ForegroundColor Cyan
            Write-Host $right.Substring($labelWidth) -ForegroundColor Gray
        } else { Write-Host '' }
    }
}
Write-Host ''
if ($NoApps) { Write-Accent 'PATH application scan: skipped' DarkYellow }
else {
    Write-Accent "PATH applications/commands: $pathCount detected" Green
    if ($appSample.Count) { Write-Host ('  ' + ($appSample -join '  |  ')) -ForegroundColor Gray }
}
Write-Host ''
Write-Accent 'BetterFetch - more than just system info.' DarkCyan
