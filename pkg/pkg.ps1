param(
  [Parameter(Position=0, ValueFromRemainingArguments=$true)]
  [string[]]$Arguments
)

& winget.exe @Arguments
exit $LASTEXITCODE
