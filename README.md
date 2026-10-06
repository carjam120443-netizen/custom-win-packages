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
