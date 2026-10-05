param([Parameter(Position=0)][string]$Theme = "linux-like")

$themePath = "$HOME\.config\starship-$Theme.toml"
if (-not (Test-Path $themePath)) {
    Write-Host "Starship theme not found: $themePath" -ForegroundColor Red
    Write-Host "Available themes: linux-like"
    exit 1
}

$env:STARSHIP_CONFIG = $themePath
Invoke-Expression (&starship init powershell)
