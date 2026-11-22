# custom-win-packages PowerShell 7 profile
# Dot-source this file from your PowerShell 7 profile, or copy its contents there.
# The repository is detected relative to this file; set CUSTOM_WIN_PACKAGES_ROOT
# if you keep the profile somewhere else.

$profileRepoRoot = $env:CUSTOM_WIN_PACKAGES_ROOT
if ([string]::IsNullOrWhiteSpace($profileRepoRoot)) {
    $profileRepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
}

if (Test-Path $profileRepoRoot) {
    $env:CUSTOM_WIN_PACKAGES_ROOT = $profileRepoRoot

    # Add package directories so their .cmd launchers are available as commands.
    $packageDirectories = @(
        'newfetch', 'betterfetch', 'which', 'pkg', 'commenter',
        'shps', 'starinit', 'and', 'expanded-git', 'terminalwinver'
    )
    foreach ($directory in $packageDirectories) {
        $candidate = Join-Path $profileRepoRoot $directory
        if ((Test-Path $candidate -PathType Container) -and
            (($env:PATH -split ';') -notcontains $candidate)) {
            $env:PATH = "$candidate;$env:PATH"
        }
    }
}

# PowerShell-friendly aliases for the repository's WinGet wrapper.
function pkg {
    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
        Write-Error 'WinGet (winget.exe) was not found in PATH.'
        return
    }
    & winget.exe @args
}
function apt { pkg @args }

# Invoke the repository's commenter utility without requiring a separate install.
function commenter {
    $script = Join-Path $env:CUSTOM_WIN_PACKAGES_ROOT 'commenter\commenter.ps1'
    if (-not (Test-Path $script)) {
        Write-Error "commenter.ps1 was not found. Set CUSTOM_WIN_PACKAGES_ROOT to the repository directory."
        return
    }
    & $script @args
}

# Oh My Posh helpers. These are optional and do not prevent profile loading
# when Oh My Posh is not installed.
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    if (Get-Command omp -ErrorAction SilentlyContinue) {
        # Keep an existing omp command/alias.
    } else {
        Set-Alias -Name omp -Value oh-my-posh -Scope Global
    }

    function theme-switch {
        param([Parameter(Position = 0)][string]$Name)

        $themeDirectory = $env:POSH_THEMES_PATH
        if ([string]::IsNullOrWhiteSpace($themeDirectory)) {
            $themeDirectory = Join-Path $HOME '.poshthemes'
        }

        if (-not (Test-Path $themeDirectory -PathType Container)) {
            Write-Host "Oh My Posh themes directory not found: $themeDirectory" -ForegroundColor Yellow
            return
        }

        $themes = @(Get-ChildItem -Path $themeDirectory -Filter '*.omp.json' -File |
            Sort-Object BaseName)

        if ([string]::IsNullOrWhiteSpace($Name)) {
            $themes | Select-Object -ExpandProperty BaseName
            return
        }

        $selected = $themes | Where-Object {
            $_.BaseName -eq $Name -or $_.Name -eq $Name
        } | Select-Object -First 1

        if (-not $selected) {
            Write-Host "Theme not found: $Name" -ForegroundColor Yellow
            Write-Host 'Available themes:'
            $themes | Select-Object -ExpandProperty BaseName
            return
        }

        oh-my-posh init pwsh --config $selected.FullName | Invoke-Expression
        $selected.BaseName | Set-Content -Path (Join-Path $HOME '.git-powershell-theme') -Encoding utf8
        Write-Host "Loaded Oh My Posh theme: $($selected.BaseName)" -ForegroundColor Green
    }
}

# Optional Starship initializer; call starinit theme select <name> to choose a theme.
# The package launcher is placed on PATH above when the repository is available.


# Native PowerShell 7 entry points for repository scripts.
# These functions invoke the .ps1 implementations directly, avoiding the
# Windows PowerShell 5.1 .cmd launchers when running inside pwsh.
function Invoke-CwpScript {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position=0)][string]$Package,
        [Parameter(Position=1)][string[]]$Arguments
    )
    if ([string]::IsNullOrWhiteSpace($env:CUSTOM_WIN_PACKAGES_ROOT)) {
        throw 'Set CUSTOM_WIN_PACKAGES_ROOT to the custom-win-packages checkout directory.'
    }
    $scriptPath = Join-Path $env:CUSTOM_WIN_PACKAGES_ROOT "$Package\$Package.ps1"
    if (-not (Test-Path -LiteralPath $scriptPath -PathType Leaf)) {
        throw "custom-win-packages script not found: $scriptPath"
    }
    & $scriptPath @Arguments
}

function newfetch {
    [CmdletBinding()]
    param([switch]$Short,[switch]$NoColor,[switch]$Help)
    $a=@(); if($Short){$a+='-Short'}; if($NoColor){$a+='-NoColor'}; if($Help){$a+='-Help'}
    Invoke-CwpScript 'newfetch' $a
}
function betterfetch {
    [CmdletBinding()]
    param([switch]$Short,[switch]$NoColor,[switch]$NoApps,[switch]$Help)
    $a=@(); if($Short){$a+='-Short'}; if($NoColor){$a+='-NoColor'}; if($NoApps){$a+='-NoApps'}; if($Help){$a+='-Help'}
    Invoke-CwpScript 'betterfetch' $a
}
function which {
    [CmdletBinding()]
    param([Parameter(Position=0,ValueFromRemainingArguments=$true)][string[]]$Name)
    Invoke-CwpScript 'which' $Name
}
function shps {
    [CmdletBinding()]
    param([Parameter(Position=0,ValueFromRemainingArguments=$true)][string[]]$Arguments)
    Invoke-CwpScript 'shps' $Arguments
}
function and {
    [CmdletBinding()]
    param([Parameter(Position=0,ValueFromRemainingArguments=$true)][string[]]$Commands)
    Invoke-CwpScript 'and' $Commands
}
function starinit {
    [CmdletBinding()]
    param([Parameter(Position=0)][string]$Command='theme',
          [Parameter(Position=1)][string]$Subcommand,
          [Parameter(Position=2)][string]$Theme)
    $scriptPath=Join-Path $env:CUSTOM_WIN_PACKAGES_ROOT 'starinit\starinit.ps1'
    if(-not(Test-Path -LiteralPath $scriptPath -PathType Leaf)){throw "starinit script not found: $scriptPath"}
    & $scriptPath $Command $Subcommand $Theme
}

