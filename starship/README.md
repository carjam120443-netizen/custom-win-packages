# Starship — Linux-like theme

This directory contains an original Starship configuration for Windows PowerShell.

## Install

Copy `linux-like.toml` to:

```text
%USERPROFILE%\.config\starship-linux-like.toml
```

For a one-session test in PowerShell:

```powershell
$env:STARSHIP_CONFIG = "$HOME\.config\starship-linux-like.toml"
starship prompt
```

To use it as your PowerShell prompt, initialize Starship from your PowerShell profile:

```powershell
Invoke-Expression (&starship init powershell)
```

Starship reads `STARSHIP_CONFIG` when you want to keep this theme separate from another Starship configuration.

## Credit

This theme is an original configuration created for **custom-win-packages** and uses Starship's configuration system.

**Starship:** https://github.com/starship/starship  
**Starship license:** ISC License (see the upstream repository's LICENSE file).

No Starship source code is copied into this theme; only Starship's documented configuration format is used.
