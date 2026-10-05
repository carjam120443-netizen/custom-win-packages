# custom-win-packages

Custom, Windows-friendly ports and utilities that I build for my Windows setup. 🪟

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
```

The included `.cmd` launchers run the PowerShell implementations or native Windows commands directly.

No Scoop package is required.

## Why?

The original Neofetch is a Bash-based project. This repository is for Windows-native alternatives that fit better into a normal PowerShell / Windows Terminal environment.

## License

Individual files may have their own licensing information. Check the file and repository history before redistributing a component.
