# terminalwinver

A small PowerShell command that prints useful Windows version information directly in the terminal.

## Usage

```powershell
terminalwinver
```

It reports the Windows edition/name, version, build number, architecture, and computer name.

## Requirements

- Windows PowerShell 5.1 or PowerShell 7+
- Windows

## Files

- `terminalwinver.ps1` - PowerShell implementation
- `terminalwinver.cmd` - CMD/PATH wrapper

The implementation uses Windows system information exposed through PowerShell/CIM.
