---
name: feedback-powershell-erase-alias-blocked
description: "PowerShell tool rejects (and runs NOTHING of) any command whose text contains the word \"erase\" because it is an alias of Remove-Item."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 760ce433-ff72-46c7-8b20-30eed40f7a8c
  modified: 2026-09-19T22:24:22.644Z
---

In this environment the PowerShell tool refuses a whole command with "Remove-Item on system path '*' is blocked" when the command text contains the word `erase` anywhere — including inside a here-string that holds FreeBASIC source (the FreeBASIC `Erase array` statement) or inside prose written to a memory/doc file. PowerShell defines `erase` as an alias of `Remove-Item`, and the safety filter parses it as a command. Nothing in the command runs, so a "half applied" state is not the risk; the risk is losing time.

**Why:** hit twice on 2026-09-20 while editing array allocation code (S-056) and while appending notes; the error text does not mention the real cause.

**How to apply:** for any edit whose text contains that word (FreeBASIC `Erase`, docs, notes) use the Edit or Write tool instead of PowerShell here-strings/Add-Content; if the error appears with no Remove-Item in the command, suspect this. Related environment rule: [[project-no-bash-tool-use-powershell]].
