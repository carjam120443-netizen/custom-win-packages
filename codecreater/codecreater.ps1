# codecreater - create HTML websites from supplied code
# Version: 0.2.0

param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Code
)

function Format-HtmlCode {
    param([string]$Html)

    $nl = [Environment]::NewLine
    $result = $Html.Trim()
    $result = $result -replace '(?s)>\s+<', '><'
    $result = $result -replace '(?i)<(html|head|body|title|meta|style|script|main|header|footer|section|article|nav|div|h[1-6]|p|ul|ol|li|button|form|table|tr|td|th|link)(\s[^>]*)?>', ($nl + '$0')
    $result = $result -replace '(?i)</(html|head|body|title|style|script|main|header|footer|section|article|nav|div|h[1-6]|p|ul|ol|li|button|form|table|tr|td|th)>', ('$0' + $nl)
    $result = $result -replace '\r?\n+', $nl

    $lines = New-Object System.Collections.Generic.List[string]
    $indent = 0

    foreach ($line in ($result -split [regex]::Escape($nl))) {
        $line = $line.Trim()
        if (-not $line) { continue }

        if ($line -match '^</') {
            $indent = [Math]::Max(0, $indent - 1)
        }

        $lines.Add(('    ' * $indent) + $line)

        $opens = [regex]::Matches($line, '(?i)<([a-z][a-z0-9-]*)(\s[^>]*)?>')
        $closes = [regex]::Matches($line, '(?i)</([a-z][a-z0-9-]*)>')
        $selfClosing = [regex]::IsMatch($line, '(?i)<(meta|link|img|input|br|hr)(\s[^>]*)?/?>')

        if (-not $selfClosing -and $opens.Count -gt $closes.Count -and $line -notmatch '(?i)</[^>]+>\s*$') {
            $indent++
        }
    }

    return ($lines -join $nl).Trim() + $nl
}

if (-not $Code -or $Code.Count -eq 0) {
    $Code = @()
    Write-Host "codecreater interactive mode" -ForegroundColor Cyan
    Write-Host "Paste HTML code. Finish by entering a line containing only END." -ForegroundColor DarkGray
    while ($true) {
        $line = Read-Host
        if ($line -eq 'END') { break }
        $Code += $line
    }
}

$sourceCode = ($Code -join ' ').Trim()

if ([string]::IsNullOrWhiteSpace($sourceCode)) {
    Write-Host "No HTML code provided. Cancelled." -ForegroundColor Yellow
    exit 1
}

$formattedCode = Format-HtmlCode $sourceCode

Write-Host ""
Write-Host "HTML detected and line-wrapped/indented." -ForegroundColor Green
Write-Host ""

$Path = Read-Host "Save website as (example: C:\Users\carja\Desktop\mysite\index.html)"
if ([string]::IsNullOrWhiteSpace($Path)) {
    Write-Host "No path provided. Cancelled." -ForegroundColor Yellow
    exit 1
}

if (-not [System.IO.Path]::GetExtension($Path)) {
    $Path = Join-Path $Path "index.html"
}

$fullPath = [System.IO.Path]::GetFullPath($Path)
$directory = Split-Path -Parent $fullPath

if (-not (Test-Path $directory)) {
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
}

$title = Read-Host "Website title (optional)"
if ([string]::IsNullOrWhiteSpace($title)) { $title = "My Website" }

if ($formattedCode -notmatch '(?i)<title(\s[^>]*)?>') {
    $safeTitle = [System.Net.WebUtility]::HtmlEncode($title)
    if ($formattedCode -match '(?i)</head>') {
        $formattedCode = $formattedCode -replace '(?i)</head>', ("    <title>$safeTitle</title>" + $nl + "</head>")
    } else {
        $formattedCode = "<!DOCTYPE html>$nl<html>$nl<head>$nl    <title>$safeTitle</title>$nl</head>$nl<body>$nl$formattedCode</body>$nl</html>$nl"
    }
}

Set-Content -LiteralPath $fullPath -Value $formattedCode -Encoding UTF8

Write-Host ""
Write-Host "Website created:" -ForegroundColor Green
Write-Host $fullPath -ForegroundColor Cyan
Write-Host ""
Write-Host "The supplied HTML was automatically split into lines and indented." -ForegroundColor DarkGray
