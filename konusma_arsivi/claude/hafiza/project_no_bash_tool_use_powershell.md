---
name: project-no-bash-tool-use-powershell
description: "Git for Windows (and its Git Bash) was uninstalled by the user on 2026-09-07 because Claude's heavy Bash-tool usage on this huge repo was consuming too much RAM and slowing the machine — use the PowerShell tool for all shell work on this project from now on, never Bash."
metadata: 
  node_type: memory
  type: project
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-06T21:28:12.282Z
---

During the uXBasic clean-build repair effort (2026-09-06/07, see [[uxb-clean-build-effort]]), Claude's Bash tool calls were backed by Git Bash, part of a Git for Windows installation. Repeated heavy usage — large recursive `grep`/`find` scans over this very large repo (hundreds of thousands of files across `_retired/`, `Snapshoots/`, patch-bundle folders, etc.) — consumed enough RAM to noticeably slow the user's machine. The Bash tool itself also became unresponsive mid-session (every command, even `echo hello`, started returning exit code 1 with no output) after one long compiler run.

**The user's resolution (2026-09-07): uninstalled Git for Windows entirely.** Verbatim: "Git Bash'i Git for Windows'u sen çalıştırıyormuşsun Claude, bu her seferinde o kadar yoğun oluyor ki RAM yetersiz kalıyor. Git for Windows kaldırıldı." (It turns out you were running Git Bash/Git for Windows, Claude — this gets so heavy every time that RAM runs out. Git for Windows has been removed.)

**How to apply, going forward, in this project:**
1. **Do not use the Bash tool in this repo at all** — its underlying `bash.exe`/`git.exe` may no longer exist post-uninstall, and even if some shell remains, the user has signaled a clear preference to stop this resource pattern.
2. **Use the PowerShell tool for every shell task instead**: file listing, running the FreeBASIC build script (`compiler/scripts/build_uxb_main_64.ps1`), running the compiled `bin/uxb.exe` for manual tests, etc. — PowerShell was confirmed working (`Write-Output "hello"` succeeded) even while Bash was unresponsive.
3. **Avoid broad recursive searches** over this repo's full tree regardless of tool — prefer the Grep/Glob tools scoped to specific subdirectories (e.g. `src/semantic`, not repo root) since the repo is huge (many old zip snapshots, `_retired/`, patch-bundle folders) and unscoped searches are slow/heavy on any shell.
4. If git itself (not just Git Bash) is needed later (the user has separately discussed wanting to set up git properly — see [[project-git-infrastructure-broken]]), check whether `git` is even still on PATH before assuming it works, since the whole Git for Windows package was removed, not just the bash shell component.
