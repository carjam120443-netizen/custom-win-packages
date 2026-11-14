# BetterFetch

An enhanced, Windows-native PowerShell fetch utility and feature-rich companion to NewFetch. No Bash, WSL, MSYS2, Cygwin, or external PowerShell modules are required.

## Features

- Windows product name, reported release version (such as 25H2 or 26H2), build number, and update revision (UBR)
- Windows edition, installation type, kernel version, and architecture
- Computer manufacturer/model, motherboard, BIOS, CPU, and GPU
- Uptime, PowerShell version, terminal, display resolution, RAM use, and system-drive capacity
- PATH command discovery using the current PowerShell session's effective PATH, including user-level PATH entries
- Colored output and perspective-style ASCII artwork

The artwork is a terminal-friendly text effect, not hardware-accelerated 3D rendering. PATH discovery lists available executable/script commands; it does not claim to enumerate every installed graphical application.

## Usage

```powershell
betterfetch
betterfetch -Short
betterfetch -NoColor
betterfetch -NoApps
betterfetch -Help
```

- `-Short`: compact one-line summary
- `-NoColor`: disable colored output
- `-NoApps`: skip PATH command discovery
- `-Help`: show usage

## Install

Place this directory somewhere on PATH. The included `betterfetch.cmd` launcher runs `betterfetch.ps1`.

```text
betterfetch/
├── betterfetch.cmd
├── betterfetch.ps1
└── README.md
```
