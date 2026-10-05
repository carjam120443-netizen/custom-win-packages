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

### Installation

Clone or download the repository, then place the `newfetch` directory somewhere on your PATH.

For example:

```text
newfetch/
├── newfetch.cmd
└── newfetch.ps1
```

The included `newfetch.cmd` launcher runs the PowerShell implementation directly.

No Scoop package is required.

## Why?

The original Neofetch is a Bash-based project. This repository is for Windows-native alternatives that fit better into a normal PowerShell / Windows Terminal environment.

## License

Individual files may have their own licensing information. Check the file and repository history before redistributing a component.
