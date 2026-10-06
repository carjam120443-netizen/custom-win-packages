# apt

apt is an APT-style compatibility command for Windows PowerShell. It maps familiar Debian/Ubuntu-style package commands onto Microsoft's WinGet package manager.

## Examples

    apt update
    apt search firefox
    apt install 7zip
    apt remove 7zip
    apt upgrade
    apt list
    apt show firefox
    apt config-init
    apt --config

## Configuration

The user config lives at:

    $HOME\.apt\apt.ps1

Run apt config-init to create it. The config is PowerShell syntax and controls the WinGet source and agreement/silent defaults.

## Important limitation

This is NOT Debian APT. It does not understand .deb repositories, Debian package dependencies, apt sources.list, or Linux package metadata. It uses WinGet underneath, so package names/IDs and available software can differ from Linux.

apt install may still require elevation depending on the Windows installer/package.