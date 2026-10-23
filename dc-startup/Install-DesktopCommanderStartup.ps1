# DeskHide Commander — per-user startup task installer
# Starts the requested command in a persistent PowerShell console, then hides (does not close) it.
[CmdletBinding()]
param([string]$TaskName = 'DeskHide Commander')
$ErrorActionPreference = 'Stop'

$npx = Get-Command 'npx.cmd' -ErrorAction SilentlyContinue
if (-not $npx) { $npx = Get-Command 'npx' -ErrorAction SilentlyContinue }
if (-not $npx) {
    throw "npx was not found on PATH. Install Node.js/npm or add its directory to this user's PATH, then run this installer again."
}

$installDir = Join-Path $env:LOCALAPPDATA 'DeskHideCommander'
New-Item -ItemType Directory -Path $installDir -Force | Out-Null
$runtimePath = Join-Path $installDir 'Start-DesktopCommanderRemote.ps1'
$npxPath = $npx.Source.Replace("'", "''")

$runtime = @'
# Runtime launcher: start a persistent PowerShell console, then hide its window.
$ErrorActionPreference = 'Stop'
$npxPath = '__NPX_PATH__'
$command = "& '$npxPath' '@wonderwhy-er/desktop-commander@latest' remote"
$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($command))
$ps = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$child = Start-Process -FilePath $ps -ArgumentList @('-NoLogo','-NoProfile','-NoExit','-EncodedCommand',$encoded) -PassThru

Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class DeskHideWindow {
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@
# Wait up to 10 seconds for the console window, then hide it (SW_HIDE = 0).
for ($i = 0; $i -lt 40; $i++) {
    Start-Sleep -Milliseconds 250
    $child.Refresh()
    if ($child.MainWindowHandle -ne [IntPtr]::Zero) {
        [DeskHideWindow]::ShowWindow($child.MainWindowHandle, 0) | Out-Null
        break
    }
}
'@
$runtime = $runtime.Replace('__NPX_PATH__', $npxPath)
Set-Content -LiteralPath $runtimePath -Value $runtime -Encoding UTF8

$powerShellExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$arguments = '-NoLogo -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' + $runtimePath + '"'
$action = New-ScheduledTaskAction -Execute $powerShellExe -Argument $arguments
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $currentUser
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -UserId $currentUser -LogonType Interactive -RunLevel Limited

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description 'Starts Desktop Commander Remote at sign-in and hides its persistent PowerShell terminal.' -Force | Out-Null
Write-Host "Installed scheduled task: $TaskName" -ForegroundColor Green
Write-Host 'Starting it now...'
Start-ScheduledTask -TaskName $TaskName
Write-Host "Runtime launcher: $runtimePath"
Write-Host ("Check status: Get-ScheduledTask -TaskName '" + $TaskName + "' | Get-ScheduledTaskInfo")
