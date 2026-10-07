# expanded-git

**expanded-git** is a small Windows-friendly wrapper around Git. Normal Git commands are passed directly to `git`, while extra plugin-style commands provide common repository workflows.

## Requirements

- Git installed and available on PATH
- PowerShell

## Usage

```text
expanded-git <git-command> [args...]
expanded-git <plugin-command> [args...]
```

### Git passthrough

Anything that is not an expanded-git plugin is sent directly to Git:

```text
expanded-git status
expanded-git add .
expanded-git commit -m "message"
expanded-git clone <repository>
expanded-git pull
expanded-git push
```

### Plugin commands

- `overview` — branch, status, and recent commits
- `graph` — compact decorated commit graph
- `recent [n]` — latest commits
- `branches` — local and remote branches
- `sync` — fetch all remotes with pruning, then show tracking status
- `quickcommit <message>` — stage all changes and commit
- `undo-last` — create a normal Git revert commit for HEAD
- `aliases` — list helper commands
- `doctor` — check Git and repository state

The helper commands use normal Git features such as logs, branches, fetch, staging, commits, and revert. Git's official documentation also supports custom aliases and custom `git-*` subcommands for extending Git. citeturn0search1

## Examples

```text
expanded-git overview
expanded-git graph
expanded-git recent 20
expanded-git branches
expanded-git sync
expanded-git quickcommit "update project"
expanded-git undo-last
```
