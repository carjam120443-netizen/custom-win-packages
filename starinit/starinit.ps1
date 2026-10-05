param(
    [Parameter(Position=0)][string]$Command = "theme",
    [Parameter(Position=1)][string]$Subcommand,
    [Parameter(Position=2)][string]$Theme
)

$themeFiles = [ordered]@{
    "linux-like" = "$HOME\.config\starship-linux-like.toml"
    "dracula" = "$PSScriptRoot\themes\dracula.toml"
    "catppuccin-macchiato" = "$PSScriptRoot\themes\catppuccin-macchiato.toml"
    "catppuccin-mocha" = "$PSScriptRoot\themes\catppuccin-mocha.toml"
}

function Show-Themes {
    Write-Host "Available Starship themes:" -ForegroundColor Cyan
    foreach ($name in $themeFiles.Keys) {
        Write-Host "  $name"
    }
}

function Select-Theme([string]$Name) {
    if (-not $Name) {
        Write-Host "Usage: starinit theme select <theme>" -ForegroundColor Yellow
        Show-Themes
        return 1
    }
    if (-not $themeFiles.Contains($Name)) {
        Write-Host "Starship theme not found: $Name" -ForegroundColor Red
        Show-Themes
        return 1
    }
    $themePath = $themeFiles[$Name]
    if (-not (Test-Path $themePath)) {
        Write-Host "Starship theme not found: $themePath" -ForegroundColor Red
        return 1
    }
    $env:STARSHIP_CONFIG = $themePath
    Invoke-Expression (&starship init powershell)
    return 0
}

function Search-Themes([string]$Query) {
    if (-not $Query) {
        Show-Themes
        return 0
    }
    $matches = @($themeFiles.Keys | Where-Object { $_ -like "*$Query*" })
    if ($matches.Count -eq 0) {
        Write-Host "No Starship themes matched: $Query" -ForegroundColor Yellow
        return 1
    }
    Write-Host "Themes matching '$Query':" -ForegroundColor Cyan
    $matches | ForEach-Object { Write-Host "  $_" }
    return 0
}

# Backward compatibility: starinit [theme] still selects a theme.
if ($Command -ne "theme") {
    $legacyTheme = $Command
    if ($themeFiles.Contains($legacyTheme)) {
        exit (Select-Theme $legacyTheme)
    }
    Write-Host "Usage:" -ForegroundColor Cyan
    Write-Host "  starinit theme"
    Write-Host "  starinit theme select <theme>"
    Write-Host "  starinit theme search <query>"
    Write-Host "  starinit <theme>  (legacy shortcut)"
    Write-Host ""
    Show-Themes
    exit 1
}

switch ($Subcommand) {
    "select" { exit (Select-Theme $Theme) }
    "search" { exit (Search-Themes $Theme) }
    "" { Show-Themes; exit 0 }
    default {
        Write-Host "Unknown theme command: $Subcommand" -ForegroundColor Red
        Write-Host "Usage: starinit theme [select <theme> | search <query>]"
        exit 1
    }
}
