# shps

A small **sh -> Windows PowerShell compatibility bridge**.

shps lets you run common POSIX shell snippets from PowerShell without installing Bash, WSL, MSYS2, or Cygwin.

## Examples

    shps -c "echo hello; pwd"
    shps -c "ls -la"
    shps -c "mkdir -p test"
    shps -File script.sh

It translates a useful subset of commands such as echo, pwd, ls, cat, mkdir -p, rm -rf, cp, mv, and touch, plus basic $VAR environment-variable syntax.

This is intentionally a compatibility bridge, not a full POSIX shell implementation. Complex Bash/sh features should still be handled by a real POSIX shell.

## Files

- shps.ps1 - PowerShell implementation
- shps.cmd - Windows launcher

## Installation

Put the directory on PATH, or copy both files into a directory already on PATH. No administrator access is required.
