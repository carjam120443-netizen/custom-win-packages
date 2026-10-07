# codecreater - create a simple HTML website
# Version: 0.1.0

param(
    [string]$Path
)

if (-not $Path) {
    $Path = Read-Host "Save website as (example: C:\Users\carja\Desktop\mysite\index.html)"
}

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

$title = Read-Host "Website title"
if ([string]::IsNullOrWhiteSpace($title)) { $title = "My Website" }

$heading = Read-Host "Main heading"
if ([string]::IsNullOrWhiteSpace($heading)) { $heading = $title }

$text = Read-Host "Main text"
if ([string]::IsNullOrWhiteSpace($text)) { $text = "Welcome to my website!" }

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$title</title>
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            font-family: Arial, sans-serif;
            background: #111827;
            color: white;
        }
        main {
            max-width: 700px;
            padding: 40px;
            text-align: center;
        }
        h1 { font-size: 3rem; margin-bottom: 16px; }
        p { font-size: 1.2rem; line-height: 1.6; color: #d1d5db; }
    </style>
</head>
<body>
    <main>
        <h1>$heading</h1>
        <p>$text</p>
    </main>
</body>
</html>
"@

Set-Content -LiteralPath $fullPath -Value $html -Encoding UTF8
Write-Host ""
Write-Host "Website created:" -ForegroundColor Green
Write-Host $fullPath -ForegroundColor Cyan
Write-Host ""
Write-Host "Tip: open it with your browser, or edit the HTML in your favorite editor." -ForegroundColor DarkGray
