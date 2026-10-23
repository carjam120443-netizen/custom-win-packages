# custom-win-packages

Custom, Windows-friendly ports and utilities that I build for my Windows setup. 🪟

<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/8/87/Windows_logo_-_2021.svg" alt="Windows logo" width="110">
  <img src="https://upload.wikimedia.org/wikipedia/commons/3/35/Tux.svg" alt="Linux Tux mascot" width="110">
</div>

<div align="center">
  <strong>Windows + Linux tooling, because why pick one? 🪟🐧</strong>
</div>

## Platform SVGs

The README uses SVG artwork for both platforms:

- **Windows:** Windows 11-era logo, sourced from Wikimedia Commons.
- **Linux:** Tux, the Linux mascot, sourced from Wikimedia Commons.

Windows SVG: https://commons.wikimedia.org/wiki/File:Windows_logo_-_2021.svg  
Linux SVG: https://commons.wikimedia.org/wiki/File:Tux.svg

The Windows logo is listed by Wikimedia Commons as public domain, with trademark restrictions still potentially applying. Tux is used with the attribution requirements listed on its source page; attribution is retained here for reference. citeturn8view0turn5view0

## Packages

### newfetch

A native PowerShell Windows reimplementation inspired by **Neofetch**.

`newfetch` is designed to feel like a Windows-native fetch tool instead of requiring Bash, WSL, MSYS2, Cygwin, or Scoop.

**Shows:**
- OS and build
- Host / motherboard model
- Windows kernel version
- Uptime
- PowerShell version
- Terminal
- Display resolution
- CPU
- GPU
- Memory usage
- C: drive space

**Commands:**
```powershell
newfetch
newfetch -Short
newfetch -NoColor
newfetch -Help
```

### which

A native PowerShell Windows port of the familiar Unix `which` command.

`which` uses PowerShell's command resolution to find executables, scripts, cmdlets, functions, aliases, and other commands available in your environment.

**Commands:**
```powershell
which powershell.exe
which newfetch
which git
which not-a-command
```

If a command cannot be found, `which` reports that it was not found.

### pkg

A Unix-style alias for **WinGet**.

`pkg` is a lightweight wrapper around the Windows Package Manager, keeping WinGet's normal arguments and behavior while giving it a shorter, Unix-like command name.

**Examples:**
```powershell
pkg search firefox
pkg install Mozilla.Firefox
pkg upgrade
pkg list
pkg uninstall Mozilla.Firefox
pkg --version
```

Under the hood, `pkg` simply passes its arguments to `winget.exe`, so no separate package manager is installed.

### commenter

A tiny comment helper for PowerShell.

Run `commenter "text"` to print a comment in the custom syntax:

```powershell
commenter "comment-example"
# Output:
# /*"comment-example"*/
```

The PowerShell profile also adds an interactive PSReadLine shortcut for standalone comment lines. When you type a line matching:

```text
/*"comment-example"*/
```

and press Enter, the line is treated as a non-command comment and is not executed. The same pattern works with whatever text you put between the quotes.

This interactive syntax is handled before PowerShell parses the line, so it does not require changing PowerShell itself.

### Installation

Clone or download the repository, then place the package directory somewhere on your PATH.

For example:

```text
newfetch/
├── newfetch.cmd
└── newfetch.ps1

which/
├── which.cmd
└── which.ps1

pkg/
├── pkg.cmd
└── pkg.ps1

commenter/
├── commenter.cmd
└── commenter.ps1
```

The included `.cmd` launchers run the PowerShell implementations or native Windows commands directly.

No Scoop package is required.

## Why?

The original Neofetch is a Bash-based project. This repository is for Windows-native alternatives that fit better into a normal PowerShell / Windows Terminal environment.

## License

Individual files may have their own licensing information. Check the file and repository history before redistributing a component.


### Starship

A Windows-native install of **Starship** plus an original Linux-like theme for PowerShell.

Starship itself is the upstream cross-shell prompt project; this repository does **not** repackage or modify its source code. The Windows x64 executable is installed separately from the official Starship v1.26.0 release.

**Installed executable:**
```text
C:\Users\carja\.cargo\bin\starship.exe
```

**Upstream:** https://github.com/starship/starship  
**Upstream release:** v1.26.0  
**Upstream license:** ISC License

**Theme:**
```text
starship/
├── linux-like.toml
└── README.md
```

The theme is an original configuration designed to make PowerShell look more like a traditional Linux shell:

```text
┌──carja@carsonswin10─~/project   main
└─❯
```

To test it without replacing the current prompt configuration:

```powershell
$env:STARSHIP_CONFIG = "$HOME\.config\starship-linux-like.toml"
starship prompt
```

To initialize Starship for the current PowerShell session:

```powershell
Invoke-Expression (&starship init powershell)
```

The existing Oh My Posh setup is left untouched, so Starship can be tested without removing the current themes.

**Credit:** Starship and its contributors created the prompt engine. This repo only supplies the Windows setup and the original `linux-like.toml` configuration.


### shps

A small **sh -> Windows PowerShell compatibility bridge**.

`shps` runs common POSIX shell commands from PowerShell without requiring Bash, WSL, MSYS2, or Cygwin.

**Examples:**
```powershell
shps -c "echo hello; pwd"
shps -c "ls -la"
shps -c "mkdir -p test"
shps -File script.sh
```

It currently translates common commands including `echo`, `pwd`, `ls`, `cat`, `mkdir -p`, `rm -rf`, `cp`, `mv`, `touch`, and basic `$VAR` environment-variable syntax. It is a compatibility bridge rather than a full POSIX shell.


### DeskHide Commander

A per-user Windows sign-in task for **Desktop Commander Remote**. It runs the requested command in a persistent PowerShell terminal, then hides that terminal window instead of closing it. No administrator privileges are requested.

**Install:** In PowerShell, from a clone of this repository, run:

```powershell
.\dc-startup\Install-DesktopCommanderStartup.ps1
```

The installer creates a scheduled task named **DeskHide Commander**, writes its runtime launcher under `%LOCALAPPDATA%\DeskHideCommander\`, and starts the task immediately. At sign-in, it starts a separate PowerShell window running:

```powershell
npx @wonderwhy-er/desktop-commander@latest remote
```

After the terminal starts, the launcher hides its window while leaving the PowerShell process and remote command running. Node.js/npm must be installed and `npx` available in the signed-in user's PATH. The first launch needs internet access to fetch or resolve the package.

**Manage the task:**

```powershell
Get-ScheduledTask -TaskName 'DeskHide Commander'
Start-ScheduledTask -TaskName 'DeskHide Commander'
Stop-ScheduledTask -TaskName 'DeskHide Commander'
Unregister-ScheduledTask -TaskName 'DeskHide Commander' -Confirm:$false
```

The task runs at sign-in for the current user, not before sign-in. Use only on a PC you control and review the upstream package before running it.


### Cygwin Portable

A **non-admin, D-drive-friendly Cygwin setup** for using a Unix-like command-line environment directly on Windows. The local setup was installed under `D:\\CygwinPortable`, with package downloads cached under `D:\\CygwinCache`. This repository contains the reproducible installer and launcher scripts, not a bundled copy of Cygwin or its binaries.

**Included tools in the configured package set:** Bash, coreutils, grep, sed, awk, find, tar/gzip/bzip2/xz, zip/unzip, curl, wget, Git, nano, Vim, make, Python 3, OpenSSH, rsync, procps, and `which`. Available commands depend on the packages selected and successfully installed.

**Install to D:** from a PowerShell session, run:

```powershell
.\cygwin\Install-CygwinPortable.ps1
```

The installer downloads the official Cygwin setup program, validates its Authenticode signature, installs without requesting administrator privileges, and places the Cygwin root and package cache on D:. It uses the upstream Cygwin mirror and standard package manager; it is not a self-contained single-file app, and Cygwin should be updated through its setup program.

**Launchers:**
- `cygwin\cygwin.cmd` opens the Cygwin Mintty terminal.
- `cygwin\cygwin-bash.cmd` runs an interactive login Bash session in the current console.

For the installed personal setup, these launchers were also placed in `D:\\Scripts` (already on the user's PATH), and a **Cygwin Portable** desktop shortcut was created. The install script defaults to `D:\\CygwinPortable` and `D:\\CygwinCache`; you can pass alternate paths if needed.

**Credits and upstreams:**
- **Cygwin Project** — the POSIX compatibility layer, runtime, shell environment, and package ecosystem: https://www.cygwin.com/
- **Cygwin setup program and source** — https://github.com/cygwin/cygwin
- **Cygwin package mirrors** — https://mirrors.kernel.org/sourceware/cygwin/
- **Mintty** — the terminal emulator included with Cygwin: https://github.com/mintty/mintty

Cygwin and its individual packages remain the work of their respective authors and are distributed under their respective licenses. This repository only provides convenience scripts and setup documentation; it does not claim ownership of Cygwin, Mintty, or bundled upstream software. Consult the upstream package metadata and license files for component-specific license terms.
