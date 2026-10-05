param(
  [Parameter(Position=0, ValueFromRemainingArguments=$true)]
  [string[]]$Text
)

if (-not $Text -or $Text.Count -eq 0) {
  Write-Host 'Usage: commenter "your comment"'
  exit 1
}

$comment = ($Text -join ' ')
Write-Host ('/*"{0}"*/' -f $comment)
