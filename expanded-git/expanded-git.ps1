# expanded-git 0.1.0
[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$ErrorActionPreference = "Stop"

function Show-Help {
    @"
expanded-git 0.1.0
Git + useful helper/plugin-style commands

Usage:
  expanded-git <git-command> [args...]
  expanded-git <plugin-command> [args...]

Git passthrough:
  Anything not listed below is passed directly to git.

Plugin commands:
  overview              Show branch, status, upstream, and recent commits
  graph                 Show a compact decorated commit graph
  recent [n]             Show the latest n commits (default 10)
  branches              Show local and remote branches
  sync                  Fetch all remotes and show ahead/behind status
  quickcommit <message>  Stage all changes and create a commit
  undo-last              Create a revert commit for HEAD (safe undo)
  aliases                Show expanded-git helper commands
  doctor                Check Git installation and repository state
  help                  Show this help

Examples:
  expanded-git status
  expanded-git clone https://github.com/user/repo.git
  expanded-git overview
  expanded-git graph
  expanded-git quickcommit "update README"
  expanded-git sync
"@
}

function Invoke-Git([string[]]$GitArgs) {
    & git @GitArgs
    exit $LASTEXITCODE
}

function Require-Repo {
    & git rev-parse --is-inside-work-tree *> $null
    if ($LASTEXITCODE -ne 0) {
        throw "Not inside a Git working tree."
    }
}

if (-not $Args -or $Args.Count -eq 0) {
    Show-Help
    exit 0
}

$cmd = $Args[0].ToLowerInvariant()
$rest = if ($Args.Count -gt 1) { $Args[1..($Args.Count-1)] } else { @() }

switch ($cmd) {
    "help" { Show-Help; exit 0 }
    "aliases" {
        Write-Host "expanded-git plugins:"
        Write-Host "  overview      repo overview"
        Write-Host "  graph         compact commit graph"
        Write-Host "  recent [n]    recent commits"
        Write-Host "  branches      local + remote branches"
        Write-Host "  sync          fetch remotes + show tracking status"
        Write-Host "  quickcommit   stage all + commit"
        Write-Host "  undo-last     revert HEAD safely"
        Write-Host "  doctor        Git/repository diagnostics"
        exit 0
    }
    "overview" {
        Require-Repo
        Write-Host "=== expanded-git overview ==="
        Write-Host ""
        git branch --show-current
        Write-Host ""
        git status --short --branch
        Write-Host ""
        git log -5 --oneline --decorate
        exit $LASTEXITCODE
    }
    "graph" {
        Require-Repo
        git log --graph --oneline --decorate --all --max-count=40
        exit $LASTEXITCODE
    }
    "recent" {
        Require-Repo
        $n = 10
        if ($rest.Count -gt 0 -and $rest[0] -match '^[0-9]+$') { $n = [int]$rest[0] }
        git log --oneline --decorate --max-count=$n
        exit $LASTEXITCODE
    }
    "branches" {
        Require-Repo
        git branch -a -vv
        exit $LASTEXITCODE
    }
    "sync" {
        Require-Repo
        Write-Host "Fetching all remotes..."
        git fetch --all --prune
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        Write-Host ""
        git status --short --branch
        Write-Host ""
        git branch -vv
        exit $LASTEXITCODE
    }
    "quickcommit" {
        Require-Repo
        if ($rest.Count -eq 0) {
            Write-Error "Usage: expanded-git quickcommit <message>"
            exit 2
        }
        $message = $rest -join " "
        git add -A
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        git commit -m $message
        exit $LASTEXITCODE
    }
    "undo-last" {
        Require-Repo
        Write-Host "Creating a revert commit for HEAD..."
        git revert HEAD
        exit $LASTEXITCODE
    }
    "doctor" {
        Write-Host "=== expanded-git doctor ==="
        git --version
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        & git rev-parse --show-toplevel 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Repository: OK"
            git status --short --branch
        } else {
            Write-Host "Repository: not currently inside a Git worktree"
        }
        exit 0
    }
    default {
        Invoke-Git $Args
    }
}
