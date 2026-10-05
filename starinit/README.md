# starinit

Quickly initialize Starship in PowerShell with the included themes.

## Usage

    starinit

This loads the linux-like theme from:

    %USERPROFILE%\.config\starship-linux-like.toml

Optional theme argument:

    starinit linux-like

Starinit is a small launcher for Starship; it does not include or modify Starship itself.


## Included community themes

`starinit` also ships several community-authored Starship configurations in `starinit/themes/`, with source and attribution comments:

- **Dracula** — derived from dracula/starship, MIT License, Copyright (c) 2022 Dracula Theme.
- **Catppuccin Macchiato** — derived from catppuccin/starship, MIT License, Copyright (c) 2021 Catppuccin.
- **Catppuccin Mocha** — derived from catppuccin/starship, MIT License, Copyright (c) 2021 Catppuccin.

Use them directly:

    starinit dracula
    starinit catppuccin-macchiato
    starinit catppuccin-mocha

The original theme projects remain credited in each theme file, and their MIT license notices are preserved.
