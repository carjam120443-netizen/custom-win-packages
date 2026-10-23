# Cygwin Portable setup for Windows

This folder contains convenience scripts for installing and launching Cygwin on Windows without requesting administrator elevation. The default root and package cache are on D:.

## Install

From PowerShell:

    .\cygwin\Install-CygwinPortable.ps1

Optional custom paths:

    .\cygwin\Install-CygwinPortable.ps1 -Root 'E:\Tools\Cygwin' -Cache 'E:\Tools\CygwinCache' -ScriptsDirectory 'E:\Tools\Scripts'

The script downloads setup-x86_64.exe from the official Cygwin site, checks its Authenticode signature, then invokes setup in quiet, non-admin mode. It installs Bash, core Unix utilities, Git, Python 3, curl/wget, editors, make, OpenSSH, rsync, and archive utilities. Cygwin remains a directory-based runtime with DLLs and package metadata; this is not a single-executable portable distribution.

The installer places cygwin.cmd, cygwin-bash.cmd, and a desktop shortcut for the current Windows user. Put the scripts directory on your user PATH if you want to launch them by name.

## Launch

- cygwin.cmd opens Mintty.
- cygwin-bash.cmd starts interactive login Bash in the current console.

The default launchers target D:\CygwinPortable. If you choose a custom root, edit the launcher's CYGWIN_ROOT value accordingly.

## Credits and licenses

- Cygwin Project — Cygwin POSIX compatibility layer, runtime, and package ecosystem: https://www.cygwin.com/
- Cygwin setup program and source: https://github.com/cygwin/cygwin
- Cygwin package mirror: https://mirrors.kernel.org/sourceware/cygwin/
- Mintty terminal emulator: https://github.com/mintty/mintty

All Cygwin components and packages remain the property of their respective authors and are distributed under their own licenses. This repository provides setup/launcher scripts and documentation only; it does not bundle or claim ownership of Cygwin, Mintty, or third-party packages. Consult each upstream package's license metadata before redistribution.
