[CmdletBinding()]
param(
    [string]$Root = 'D:\CygwinPortable',
    [string]$Cache = 'D:\CygwinCache',
    [string]$ScriptsDirectory = 'D:\Scripts',
    [switch]$SkipLaunchers
)

$ErrorActionPreference = 'Stop'
$setupUrl = 'https://www.cygwin.com/setup-x86_64.exe'
$setupPath = Join-Path $env:TEMP 'cygwin-setup-x86_64.exe'
$site = 'https://mirrors.kernel.org/sourceware/cygwin/'
$packages = @(
    'bash', 'coreutils', 'grep', 'sed', 'gawk', 'findutils',
    'tar', 'gzip', 'bzip2', 'xz', 'zip', 'unzip', 'curl', 'wget',
    'git', 'nano', 'vim', 'make', 'python3', 'openssh', 'rsync',
    'procps-ng', 'which'
) -join ','

Write-Host 'Downloading the official Cygwin setup program...' -ForegroundColor Cyan
Invoke-WebRequest -Uri $setupUrl -OutFile $setupPath

$signature = Get-AuthenticodeSignature -FilePath $setupPath
if ($signature.Status -ne [System.Management.Automation.SignatureStatus]::Valid) {
    throw "Cygwin setup signature is not valid (status: $($signature.Status)). Installer will not run."
}
Write-Host "Verified signature: $($signature.SignerCertificate.Subject)" -ForegroundColor Green

New-Item -ItemType Directory -Path $Root, $Cache -Force | Out-Null
$setupArgs = @(
    '--root', $Root,
    '--local-package-dir', $Cache,
    '--site', $site,
    '--no-admin',
    '--quiet-mode',
    '--packages', $packages
)

Write-Host "Installing Cygwin under $Root without administrator elevation..." -ForegroundColor Cyan
& $setupPath @setupArgs
if ($LASTEXITCODE -ne 0) {
    throw "Cygwin setup failed with exit code $LASTEXITCODE. You can rerun this script to retry."
}

$bash = Join-Path $Root 'bin\bash.exe'
if (-not (Test-Path -LiteralPath $bash)) {
    throw "Setup returned success, but Bash was not found at $bash."
}

if (-not $SkipLaunchers) {
    New-Item -ItemType Directory -Path $ScriptsDirectory -Force | Out-Null
    $cygwinCmd = @'
@echo off
set "CYGWIN_ROOT=__CYGWIN_ROOT__"
if not exist "%CYGWIN_ROOT%\bin\mintty.exe" (
  echo Cygwin was not found at "%CYGWIN_ROOT%".
  exit /b 2
)
start "Cygwin Terminal" "%CYGWIN_ROOT%\bin\mintty.exe" -i /Cygwin-Terminal.ico -
'@.Replace('__CYGWIN_ROOT__', $Root)
    $bashCmd = @'
@echo off
set "CYGWIN_ROOT=__CYGWIN_ROOT__"
if not exist "%CYGWIN_ROOT%\bin\bash.exe" (
  echo Cygwin was not found at "%CYGWIN_ROOT%".
  exit /b 2
)
"%CYGWIN_ROOT%\bin\bash.exe" --login -i %*
'@.Replace('__CYGWIN_ROOT__', $Root)

    Set-Content -LiteralPath (Join-Path $ScriptsDirectory 'cygwin.cmd') -Value $cygwinCmd -Encoding Ascii
    Set-Content -LiteralPath (Join-Path $ScriptsDirectory 'cygwin-bash.cmd') -Value $bashCmd -Encoding Ascii

    $desktop = [Environment]::GetFolderPath('Desktop')
    if ($desktop) {
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut((Join-Path $desktop 'Cygwin Portable.lnk'))
        $shortcut.TargetPath = Join-Path $Root 'bin\mintty.exe'
        $shortcut.Arguments = '-i /Cygwin-Terminal.ico -'
        $shortcut.WorkingDirectory = $Root
        $shortcut.Description = 'Cygwin terminal installed under the selected root directory.'
        $shortcut.Save()
    }

    Write-Host "Launchers created in $ScriptsDirectory. Ensure that directory is on your user PATH." -ForegroundColor Green
}

Write-Host "Cygwin installed successfully at $Root" -ForegroundColor Green
Write-Host "Package cache: $Cache"
Write-Host 'Try: cygwin  (Mintty terminal) or cygwin-bash  (current console)'
