# Desktop Commander Remote — per-user startup task installer
# Installs a logon task for the current Windows user; no admin rights required.
[CmdletBinding()]
param(
    [string]$TaskName = 'Desktop Commander Remote'
)
$ErrorActionPreference = 'Stop'

$npx = Get-Command 'npx.cmd' -ErrorAction SilentlyContinue
if (-not $npx) { $npx = Get-Command 'npx' -ErrorAction SilentlyContinue }
if (-not $npx) {
    throw "npx was not found on PATH. Install Node.js/npm or add its directory to this user's PATH, then run this installer again."
}

$PowerShellExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$npxPath = $npx.Source
# The task launches a hidden PowerShell process that runs the remote agent.
$command = "& '$($npxPath.Replace("'", "''"))' '@wonderwhy-er/desktop-commander@latest' 'remote'"
$encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($command))
$arguments = "-NoLogo -NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -EncodedCommand $encoded"
$action = New-ScheduledTaskAction -Execute $PowerShellExe -Argument $arguments
$trigger = New-ScheduledTaskTrigger -AtLogOn -User ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) -LogonType Interactive -RunLevel Limited

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description 'Starts the Desktop Commander Remote agent when this user signs in.' -Force | Out-Null
Write-Host "Installed scheduled task: $TaskName" -ForegroundColor Green
Write-Host 'Starting it now...'
Start-ScheduledTask -TaskName $TaskName
Write-Host 'Task created and start requested. Check its status with:'
Write-Host "Get-ScheduledTask -TaskName '$TaskName' | Get-ScheduledTaskInfo"
