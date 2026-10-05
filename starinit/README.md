# starinit

Quickly initialize Starship in PowerShell with the included themes.

## Usage

List available themes:

    starinit theme

Select a theme:

    starinit theme select linux-like
    starinit theme select dracula
    starinit theme select catppuccin-macchiato
    starinit theme select catppuccin-mocha

Search the included themes by name:

    starinit theme search catppuccin
    starinit theme search dracula

The original short form still works for compatibility:

    starinit linux-like
    starinit dracula

The linux-like theme loads from:

    %USERPROFILE%\.config\starship-linux-like.toml

starinit is a small launcher for Starship; it does not include or modify Starship itself.

## Included community themes

starinit also ships several community-authored Starship configurations in starinit/themes/, with source and attribution comments:

- **Dracula** — derived from dracula/starship, MIT License, Copyright (c) 2022 Dracula Theme.
- **Catppuccin Macchiato** — derived from catppuccin/starship, MIT License, Copyright (c) 2021 Catppuccin.
- **Catppuccin Mocha** — derived from catppuccin/starship, MIT License, Copyright (c) 2021 Catppuccin.

The original theme projects remain credited in each theme file, and their MIT license notices are preserved.
