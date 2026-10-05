param(
    [Parameter(Position=0, ValueFromRemainingArguments=$true)]
    [string[]]$Commands
)

if (-not $Commands -or $Commands.Count -eq 0) {
    Write-Host 'Usage: and "command 1" "command 2" ...' -ForegroundColor Yellow
    exit 1
}

foreach ($command in $Commands) {
    if ([string]::IsNullOrWhiteSpace($command)) { continue }
    Write-Host ">> $command" -ForegroundColor Cyan
    & powershell.exe -NoProfile -Command $command
    $code = $LASTEXITCODE
    if ($code -ne 0) {
        Write-Host "Command failed with exit code $code. Stopping." -ForegroundColor Red
        exit $code
    }
}
exit 0
