# apt.ps1 - APT-style command shim for Windows using WinGet
param(
    [Parameter(Position=0)][string]$Command,
    [Parameter(Position=1,ValueFromRemainingArguments=$true)][string[]]$Arguments
)
$ErrorActionPreference = 'Stop'
$script:Version = '0.1.0'
$configPath = Join-Path $HOME '.apt\apt.ps1'
$defaults = @{
    Source = 'winget'
    Exact = $false
    AcceptSourceAgreements = $false
    AcceptPackageAgreements = $false
    Silent = $false
}
if (Test-Path -LiteralPath $configPath) { . $configPath }
function Get-WingetArgs {
    $a = @()
    if ($defaults.Source) { $a += '--source'; $a += $defaults.Source }
    if ($defaults.Exact) { $a += '--exact' }
    if ($defaults.AcceptSourceAgreements) { $a += '--accept-source-agreements' }
    if ($defaults.AcceptPackageAgreements) { $a += '--accept-package-agreements' }
    if ($defaults.Silent) { $a += '--silent' }
    return $a
}
function Show-Help {
@'
apt - APT-style package commands for Windows (backed by WinGet)

Usage:
  apt update
  apt search <name>
  apt install <package>
  apt remove <package>
  apt purge <package>
  apt upgrade
  apt list
  apt show <package>
  apt autoremove
  apt --version
  apt --config
  apt config-init

Config:
  ~/.apt/apt.ps1

This is an APT-style compatibility layer, not Debian APT.
Packages come from WinGet and package names/IDs may differ from Linux.
'@
}
if ($Command -in @('--help','-h','help')) { Show-Help; exit 0 }
if ($Command -eq '--version') { "apt $script:Version (Windows/WinGet compatibility shim)"; exit 0 }
if ($Command -eq '--config') {
    if (Test-Path -LiteralPath $configPath) { Get-Content -LiteralPath $configPath }
    else { "No config file yet. Run: apt config-init" }
    exit 0
}
if ($Command -eq 'config-init') {
    $dir = Split-Path -Parent $configPath
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    @'
# sh/apt-style configuration for the Windows apt shim.
# This file is PowerShell syntax.
$defaults = @{
    Source = 'winget'
    Exact = $false
    AcceptSourceAgreements = $false
    AcceptPackageAgreements = $false
    Silent = $false
}
'@ | Set-Content -LiteralPath $configPath -Encoding UTF8
    Write-Output "Created $configPath"
    exit 0
}
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error 'apt: winget is required but was not found.'
    exit 127
}
switch ($Command) {
    'update' {
        & winget source update
        exit $LASTEXITCODE
    }
    'search' {
        if (-not $Arguments) { Write-Error 'apt search: package name required'; exit 2 }
        & winget search ($Arguments -join ' ')
        exit $LASTEXITCODE
    }
    'install' {
        if (-not $Arguments) { Write-Error 'apt install: package name or ID required'; exit 2 }
        & winget install ($Arguments + (Get-WingetArgs))
        exit $LASTEXITCODE
    }
    'remove' {
        if (-not $Arguments) { Write-Error 'apt remove: package name or ID required'; exit 2 }
        & winget uninstall ($Arguments + (Get-WingetArgs))
        exit $LASTEXITCODE
    }
    'purge' {
        if (-not $Arguments) { Write-Error 'apt purge: package name or ID required'; exit 2 }
        & winget uninstall ($Arguments + (Get-WingetArgs))
        exit $LASTEXITCODE
    }
    'upgrade' {
        if ($Arguments) { & winget upgrade ($Arguments + (Get-WingetArgs)) }
        else { & winget upgrade --all (Get-WingetArgs) }
        exit $LASTEXITCODE
    }
    'list' {
        & winget list @Arguments
        exit $LASTEXITCODE
    }
    'show' {
        if (-not $Arguments) { Write-Error 'apt show: package name or ID required'; exit 2 }
        & winget show ($Arguments + (Get-WingetArgs))
        exit $LASTEXITCODE
    }
    'autoremove' {
        Write-Output 'apt: Windows does not have a direct APT autoremove equivalent.'
        Write-Output 'Use "winget list" to review installed packages.'
        exit 0
    }
    default {
        if ($Command) {
            Write-Error "apt: unknown command '$Command'. Run 'apt --help'."
            exit 2
        }
        Show-Help
    }
}