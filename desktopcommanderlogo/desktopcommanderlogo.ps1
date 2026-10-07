# desktopcommanderlogo - show the Desktop Commander logo
# Version: 0.1.1

# Build the logo from Unicode code points so Windows PowerShell 5.1
# does not misread non-ASCII source text under a legacy code page.
$B  = [char]0x2588
$UL = [char]0x2554
$UR = [char]0x2557
$LL = [char]0x255A
$LR = [char]0x255D
$V  = [char]0x2551
$H  = [char]0x2550
$DR = $UR

$logo = @"
$B$B$B$B$B$B$DR $B$B$B$B$B$B$B$DR$B$B$B$B$B$B$B$DR$B$B$DR  $B$B$DR$B$B$B$B$B$B$B$B$DR $B$B$B$B$B$B$DR $B$B$B$B$B$B$DR     $B$B$B$B$B$B$DR $B$B$B$B$B$B$DR $B$B$B$DR   $B$B$B$DR$B$B$B$DR   $B$B$B$DR $B$B$B$B$B$DR $B$B$B$DR   $B$B$DR$B$B$B$B$B$B$DR $B$B$B$B$B$B$B$DR$B$B$B$B$B$B$DR
$B$B$UL$H$H$B$B$DR$B$B$UL$H$H$H$H$LR$B$B$UL$H$H$H$H$LR$B$B$V $B$B$UL$LR$LL$H$H$B$B$UL$H$H$LR$B$B$UL$H$H$H$B$B$DR$B$B$UL$H$H$B$B$DR   $B$B$UL$H$H$H$H$LR$B$B$UL$H$H$H$B$B$DR$B$B$B$B$DR $B$B$B$B$V$B$B$B$B$DR $B$B$B$B$V$B$B$UL$H$H$B$B$DR$B$B$B$B$DR  $B$B$V$B$B$UL$H$H$B$B$DR$B$B$UL$H$H$H$H$LR$B$B$UL$H$H$B$B$DR
$B$B$V  $B$B$V$B$B$B$B$B$DR  $B$B$B$B$B$B$B$DR$B$B$B$B$B$UL$LR    $B$B$V   $B$B$V   $B$B$V$B$B$B$B$B$B$UL$LR   $B$B$V     $B$B$V   $B$B$V$B$B$UL$B$B$B$B$UL$B$B$V$B$B$UL$B$B$B$B$UL$B$B$V$B$B$B$B$B$B$B$V$B$B$UL$B$B$DR $B$B$V$B$B$V  $B$B$V$B$B$B$B$B$DR  $B$B$B$B$B$B$UL$LR
$B$B$V  $B$B$V$B$B$UL$H$H$LR  $LL$H$H$H$H$B$B$V$B$B$UL$H$B$B$DR    $B$B$V   $B$B$V   $B$B$V$B$B$UL$H$H$H$LR    $B$B$V     $B$B$V   $B$B$V$B$B$V$LL$B$B$UL$LR$B$B$V$B$B$V$LL$B$B$UL$LR$B$B$V$B$B$UL$H$H$B$B$V$B$B$V$LL$B$B$DR$B$B$V$B$B$V  $B$B$V$B$B$UL$H$H$LR  $B$B$UL$H$H$B$B$DR
$B$B$B$B$B$B$UL$LR$B$B$B$B$B$B$B$DR$B$B$B$B$B$B$B$V$B$B$V  $B$B$DR   $B$B$V   $LL$B$B$B$B$B$B$UL$LR$B$B$V        $LL$B$B$B$B$B$B$DR$LL$B$B$B$B$B$B$UL$LR$B$B$V $LL$H$LR $B$B$V$B$B$V $LL$H$LR $B$B$V$B$B$V  $B$B$V$B$B$V $LL$B$B$B$B$V$B$B$B$B$B$B$UL$LR$B$B$B$B$B$B$B$DR$B$B$V  $B$B$V
$LL$H$H$H$H$H$LR $LL$H$H$H$H$H$H$LR$LL$H$H$H$H$H$H$LR$LL$H$LR  $LL$H$LR   $LL$H$LR    $LL$H$H$H$H$H$LR $LL$H$LR         $LL$H$H$H$H$H$LR $LL$H$H$H$H$H$LR $LL$H$LR     $LL$H$LR$LL$H$LR     $LL$H$LR$LL$H$LR  $LL$H$LR$LL$H$LR  $LL$H$H$H$LR$LL$H$H$H$H$H$LR $LL$H$H$H$H$H$H$LR$LL$H$LR  $LL$H$LR
"@

Write-Host $logo -ForegroundColor Blue -ForegroundColor Blue
