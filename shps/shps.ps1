# shps - a small POSIX sh -> PowerShell compatibility bridge
param([Parameter(Position=0)][string]$Command,[Parameter(Position=1,ValueFromRemainingArguments=$true)][string[]]$Arguments)
$ErrorActionPreference='Stop'
$script:Version='0.1.0'
function Show-Help {
' shps - run common POSIX sh syntax through Windows PowerShell'
''
'Usage:'
'  shps -c "echo hello; pwd"'
'  shps -c "ls -la"'
'  shps -File script.sh'
'  shps script.sh'
'  shps --help'
'  shps --version'
''
'Compatibility: echo, pwd, ls, cat, mkdir -p, rm -rf, cp, mv, touch, $VAR'
'This is a compatibility bridge, not a full POSIX shell.'
}
if($Command -in @('--help','-h')){Show-Help;exit 0}
if($Command -eq '--version'){"shps $script:Version";exit 0}
function Convert-ShToPowerShell([string]$Line){
 $s=$Line.Trim();if([string]::IsNullOrWhiteSpace($s)-or $s.StartsWith('#')){return $null}
 $s=[regex]::Replace($s,'\$\{([A-Za-z_][A-Za-z0-9_]*)\}','$env:$1')
 $s=[regex]::Replace($s,'\$([A-Za-z_][A-Za-z0-9_]*)','$env:$1')
 $s=[regex]::Replace($s,'^echo\b','Write-Output');$s=[regex]::Replace($s,'^pwd\s*$','Get-Location')
 if($s -match '^ls\s+-la(?:\s|$)'){ $s=$s -replace '^ls\s+-la','Get-ChildItem -Force' } elseif($s -match '^ls\s+-l(?:\s|$)'){ $s=$s -replace '^ls\s+-l','Get-ChildItem' } elseif($s -match '^ls(?:\s|$)'){ $s=$s -replace '^ls','Get-ChildItem' }
 $s=[regex]::Replace($s,'^cat\b','Get-Content');$s=[regex]::Replace($s,'^mkdir\s+-p\b','New-Item -ItemType Directory -Force');$s=[regex]::Replace($s,'^mkdir\b','New-Item -ItemType Directory')
 $s=[regex]::Replace($s,'^rm\s+-rf\b','Remove-Item -Recurse -Force');$s=[regex]::Replace($s,'^rm\s+-f\b','Remove-Item -Force');$s=[regex]::Replace($s,'^rm\b','Remove-Item')
 $s=[regex]::Replace($s,'^cp\s+-r\b','Copy-Item -Recurse');$s=[regex]::Replace($s,'^cp\b','Copy-Item');$s=[regex]::Replace($s,'^mv\b','Move-Item')
 if($s -match '^touch\s+(.+)$'){$target=$Matches[1];$s="if(-not(Test-Path -LiteralPath $target)){New-Item -ItemType File -Path $target|Out-Null}else{(Get-Item -LiteralPath $target).LastWriteTime=Get-Date}"}
 $s
}
function Invoke-ShLine([string]$Line){$t=Convert-ShToPowerShell $Line;if($t){Invoke-Expression $t}}
if($Command -in @('-c','--command')){if(-not $Arguments){Write-Error 'shps: -c requires a command string';exit 2};foreach($line in ($Arguments[0]-split "`r?`n")){Invoke-ShLine $line};exit 0}
if($Command -in @('-f','--file','-File')){if(-not $Arguments){Write-Error 'shps: -File requires a script path';exit 2};$Command=$Arguments[0]}
if($Command -and(Test-Path -LiteralPath $Command -PathType Leaf)){foreach($line in [IO.File]::ReadAllLines((Resolve-Path -LiteralPath $Command))){Invoke-ShLine $line};exit 0}
if($Command){Invoke-ShLine (($Command+' '+($Arguments-join ' ')).Trim());exit $LASTEXITCODE}
Show-Help
