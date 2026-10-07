# terminalwinver - clean Windows version display
# Version: 0.1.2

$os = Get-CimInstance -ClassName Win32_OperatingSystem

$logo = @'
  +---+ +---+
  |   | |   |
  +---+ +---+
  |   | |   |
  +---+ +---+
'@

Write-Host $logo
Write-Host " terminalwinver"
Write-Host ""
Write-Host " OS           : $($os.Caption)"
Write-Host " Version      : $($os.Version)"
Write-Host " Build        : $($os.BuildNumber)"
Write-Host " Architecture : $($os.OSArchitecture)"
Write-Host " Computer     : $env:COMPUTERNAME"
