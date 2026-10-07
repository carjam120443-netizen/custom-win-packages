# terminalwinver - show Windows version information in the terminal
# Version: 0.1.0

$os = Get-CimInstance -ClassName Win32_OperatingSystem

Write-Host "Windows Version Information"
Write-Host "--------------------------"
Write-Host "Name       : $($os.Caption)"
Write-Host "Version    : $($os.Version)"
Write-Host "Build      : $($os.BuildNumber)"
Write-Host "Architecture: $($os.OSArchitecture)"
Write-Host "Computer   : $env:COMPUTERNAME"
