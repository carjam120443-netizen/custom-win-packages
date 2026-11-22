[CmdletBinding()]
param(
    [string]$RepositoryPath = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'
if ($PSVersionTable.PSVersion.Major -lt 7) {
    throw 'Run this installer from PowerShell 7 (pwsh), not Windows PowerShell 5.1.'
}

$repo = (Resolve-Path -LiteralPath $RepositoryPath).Path
$profileSource = Join-Path $repo 'profiles/PowerShell7/Microsoft.PowerShell_profile.ps1'
if (-not (Test-Path -LiteralPath $profileSource -PathType Leaf)) {
    throw "PowerShell 7 profile not found: $profileSource"
}

$profilePath = $PROFILE.CurrentUserCurrentHost
$profileDirectory = Split-Path -Parent $profilePath
if (-not (Test-Path -LiteralPath $profileDirectory)) {
    New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
}
if (-not (Test-Path -LiteralPath $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

$marker = '# >>> custom-win-packages PowerShell 7 profile >>>'
$existing = Get-Content -LiteralPath $profilePath -Raw
if ($existing.Contains($marker)) {
    Write-Host 'Profile hook already exists; no changes made.' -ForegroundColor Yellow
    return
}

$backup = "$profilePath.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
Copy-Item -LiteralPath $profilePath -Destination $backup
$quotedSource = $profileSource.Replace("'", "''")
$block = @"

$marker
. '$quotedSource'
# <<< custom-win-packages PowerShell 7 profile <<<
"@
Add-Content -LiteralPath $profilePath -Value $block -Encoding utf8
Write-Host 'Installed custom-win-packages PowerShell 7 profile hook.' -ForegroundColor Green
Write-Host "Profile: $profilePath"
Write-Host "Backup:  $backup"
Write-Host 'Reload with: . $PROFILE'
