param(
  [Parameter(Position=0, ValueFromRemainingArguments=$true)]
  [string[]]$Name
)

if (-not $Name -or $Name.Count -eq 0) {
  Write-Error "usage: which <command> [command ...]"
  exit 1
}

$exitCode = 0

foreach ($n in $Name) {
  if ([string]::IsNullOrWhiteSpace($n)) { continue }

  $matches = @(Get-Command -Name $n -All -ErrorAction SilentlyContinue)

  if ($matches.Count -eq 0) {
    Write-Host "$n not found"
    $exitCode = 1
    continue
  }

  foreach ($m in $matches) {
    if ($m.CommandType -eq 'Application' -and $m.Path) {
      Write-Output $m.Path
    } elseif ($m.Definition) {
      Write-Output $m.Definition
    } else {
      Write-Output $m.Name
    }
  }
}

exit $exitCode
