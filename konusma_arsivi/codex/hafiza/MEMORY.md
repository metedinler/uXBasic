# Task Group: UXBc compiler/backend parity

scope: BYREF alias and compound-assignment parity remediation in the UXBc checkout; use to route a continuation from the reported baseline and to avoid declaring parity complete without backend measurements.
applies_to: cwd=C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc; reuse_rule=checkout-specific starting state from 2026-09-16; re-inspect the current checkout and rerun measurements before relying on the counts.

## Task 1: BYREF parity and MIR metadata gaps, uncertain

### rollout_summary_files

- rollout_summaries/2026-09-16T09-48-01-sAu9-byref_parity_ve_mir_metadata_aciklari.md (cwd=C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc, rollout_path=C:\Users\mete\.codex\sessions\2026\09\16\rollout-2026-09-16T12-48-01-01a0a99d-b964-7aa0-9e5b-bd5ff703487d.jsonl, updated_at=2026-09-16T09:48:03+00:00, thread_id=01a0a99d-b964-7aa0-9e5b-bd5ff703487d, reported starting state only; no code or test evidence)

### keywords

- BYREF, alias, compound-assignment, parity, AST=11, MIR=11, JS=2, MIR-x64=2, AST-x64=10, WASM virtual probe, base-constructor metadata

## User preferences

- When asking to fix UXBc parity, the user said "kodu incele ve gerekenleri yap, eksikleri gider" -> perform the code changes as well as the diagnosis; do not stop at an analysis. [Task 1]
- The user said parity is not complete until its measurements are complete -> do not mark the task done without parity/measurement evidence across the relevant backends. [Task 1]

## Reusable knowledge

- Reported BYREF baseline: `AST=11, MIR=11, JS=2, MIR-x64=2, AST-x64=10`. Treat these as initial routing measurements, not a validated current result. [Task 1]
- The named open boundaries are the MIR interpreter's multi-level base-constructor metadata chain and a separate WASM virtual probe. [Task 1]

## Failures and how to do differently

- Symptom: a parity fix is described as complete from this rollout -> cause: no tool calls, source inspection, patch, or test occurred -> fix: first locate AST/MIR/JS/MIR-x64/AST-x64 divergence, handle the metadata chain and WASM probe separately, then rerun the measurements. [Task 1]

# Task Group: Windows AI tooling, VS Code agents, and MCP inventory

scope: Read-only inventory of installed/configured AI developer tools on this Windows profile; use when the user asks what is present, especially "VSCode dahil".
applies_to: cwd=C:\Users\mete\Downloads\BasicOyunSource\uXBasic_repo; reuse_rule=the product versions and active state are a 2026-09-11 snapshot; reuse the inventory method, but recheck current installations, processes, authentication, and MCP connectivity.

## Task 1: Inventory installed AI tools and developer assistants, success

### rollout_summary_files

- rollout_summaries/2026-09-11T10-14-22-t0xO-windows_ai_tools_mcp_vscode_inventory.md (cwd=C:\Users\mete\Downloads\BasicOyunSource\uXBasic_repo, rollout_path=C:\Users\mete\.codex\sessions\2026\09\11\rollout-2026-09-11T13-14-22-01a08ff6-0ce0-7a70-af3e-882b23a440c8.jsonl, updated_at=2026-09-11T10:20:44+00:00, thread_id=01a08ff6-0ce0-7a70-af3e-882b23a440c8, successful read-only snapshot)

### keywords

- Windows, PowerShell, Grok CLI, OpenClaw, Ollama, ChatGPT Desktop, Codex CLI, Claude Code, GitHub Copilot CLI, Pi Coding Agent, Antigravity, Kimi, Qwen, ZChat, Cursor

## Task 2: Inventory VS Code extensions and agent definitions, success

### rollout_summary_files

- rollout_summaries/2026-09-11T10-14-22-t0xO-windows_ai_tools_mcp_vscode_inventory.md (cwd=C:\Users\mete\Downloads\BasicOyunSource\uXBasic_repo, rollout_path=C:\Users\mete\.codex\sessions\2026\09\11\rollout-2026-09-11T13-14-22-01a08ff6-0ce0-7a70-af3e-882b23a440c8.jsonl, updated_at=2026-09-11T10:20:44+00:00, thread_id=01a08ff6-0ce0-7a70-af3e-882b23a440c8, extension and prompt-template inventory)

### keywords

- code.cmd --list-extensions --show-versions, extensions.json, openai.chatgpt, Continue.continue, denizhandaklr.kimi-lm-provider, glm-chat-provider, minimax-vscode, .agent.md, agency-agents, claude-game-studios, C:\Users\mete\AppData\Roaming\Code\User\prompts

## Task 3: Inventory Ollama models, Codex MCP, and plugin configuration, success

### rollout_summary_files

- rollout_summaries/2026-09-11T10-14-22-t0xO-windows_ai_tools_mcp_vscode_inventory.md (cwd=C:\Users\mete\Downloads\BasicOyunSource\uXBasic_repo, rollout_path=C:\Users\mete\.codex\sessions\2026\09\11\rollout-2026-09-11T13-14-22-01a08ff6-0ce0-7a70-af3e-882b23a440c8.jsonl, updated_at=2026-09-11T10:20:44+00:00, thread_id=01a08ff6-0ce0-7a70-af3e-882b23a440c8, configuration snapshot, not a health test)

### keywords

- ollama list, ollama ps, qwen3.5:latest, qwen2.5-coder:3b, deepseek-r1:1.5b, C:\Users\mete\.codex\config.toml, mcp_servers.gitnexus, mcp_servers.linear, mcp_servers.openviking, mcp_servers.playwright, mcp_servers.node_repl, GitNexus, OpenViking, Node REPL

## User preferences

- When asking which assistants are present, the user included "VSCode dahil" -> make one read-only pass across desktop installs, PATH commands, running processes, VS Code extensions, and configuration traces rather than limiting the answer to terminal CLIs. [Task 1][Task 2][Task 3]

## Reusable knowledge

- The 2026-09-11 snapshot confirmed Grok CLI, OpenClaw, Ollama, ChatGPT Desktop, Codex Desktop/CLI, Claude Desktop/Claude Code, GitHub Copilot CLI, Pi Coding Agent, Antigravity, and VS Code. Kimi was a VS Code extension; Qwen was represented by Ollama models; ZChat was not found in the checked records. Cursor had only a stale shortcut/configuration trace because `C:\Users\mete\AppData\Local\Programs\cursor\Cursor.exe` was absent. [Task 1]
- `code.cmd --list-extensions --show-versions` and `C:\Users\mete\.vscode\extensions\extensions.json` confirmed 62 extensions. `C:\Users\mete\AppData\Roaming\Code\User\prompts` held 230 `.agent.md` definitions (179 Agency Agents, 48 Claude Game Studios, 3 standalone); prompt definitions are templates/instructions, not proof of concurrent execution. [Task 2]
- Snapshot: eight Ollama models were listed and `ollama ps` had no loaded model. `C:\Users\mete\.codex\config.toml` registered GitNexus, Linear, OpenViking, Playwright, and Node REPL; GitNexus/OpenViking launchers existed. Registration/launcher presence does not prove connectivity. [Task 3]

## Failures and how to do differently

- Symptom: `CreateProcess ... Dizin adı geçersiz. (os error 267)` -> malformed Windows execution context/workdir -> rerun with an explicit valid workdir such as `C:\Users\mete` and `login:false`. [Task 1]
- Symptom: an inventory overstates what is usable -> cause: treating directories, shortcuts, config traces, or generic JSON `null` keys as active tools/servers -> fix: parse product-specific schemas and report installed, configured, running, authenticated, and connectivity-verified as distinct statuses. [Task 1][Task 3]

# Task Group: uXBasic / Claude coordination and safe cleanup

scope: Coordinate Codex work in the UXBc checkout with Claude; use for shared-status handling and evidence-based cleanup decisions.
applies_to: cwd=C:/Users/mete/Downloads/BasicOyunSource/UXBc_Clean/UXBc; reuse_rule=checkout-specific coordination policy from an ad-hoc note, not validated rollout evidence; recheck the shared files at the start of each applicable task.

## Task 1: Maintain uXBasic / Claude coordination boundaries

### rollout_summary_files

- No rollout summary exists; source is extensions/ad_hoc/notes/20260906-uxbasic-claude-koordinasyon.md (cwd=C:/Users/mete/Downloads/BasicOyunSource/UXBc_Clean/UXBc, rollout_path=not applicable, updated_at=2026-09-06, ad-hoc authoritative coordination note)

### keywords

- UXBc, uXBasic, uxb, uxm, ai_koordinasyon, DURUM.md, SORULAR_CEVAPLAR.md, Claude, CLAIM, Devam ediyor, KEEP-RAG, Ollama, ZIP hash

## User preferences

- In applicable UXBc work, the coordination note requires reading `uxb/ai_koordinasyon/DURUM.md` and `SORULAR_CEVAPLAR.md` at the start, updating workspace/status at the end, and not editing files Claude marked `CLAIM`/`Devam ediyor` or taking over Claude-planned work. [Task 1] [ad-hoc note]
- The coordination note says "Dosya silme yapılmayacak" without separate user approval -> limit work to read-only inspection and safe additions/edits; tell the user if unknown coordination files or important work records are found. [Task 1] [ad-hoc note]

## Reusable knowledge

- At the beginning of applicable work, read `uxb/ai_koordinasyon/DURUM.md` and `uxb/ai_koordinasyon/SORULAR_CEVAPLAR.md`; at the end, update workspace/status there. [Task 1]
- Do not edit files Claude marked `CLAIM`/`Devam ediyor`, and do not take over work Claude planned. Put Claude/Codex questions in the same daily log; place necessary new questions at the top. [Task 1]
- Tell the user if previously unknown coordination files or important work records are found, then update this guidance. [Task 1]
- Do not delete files. Without separate user approval, limit work to read-only inspection and safe additions/edits. [Task 1]
- `uxm` is a separate language; `uxb/uXBasic` is a separate scope. For Downloads cleanup, a name or extension alone is not evidence. [Task 1]
- Cleanup candidate order: metadata and size -> hash/diff -> content/references -> patch-application status -> build/test/runtime contribution -> RAG need -> explicit user approval. [Task 1]
- Preserve original RAG/Ollama documents and mark them `KEEP-RAG`; do not remove sources before indexing completes or while the model is not running. [Task 1]
- A folder and ZIP match only if every path, size, and hash matches. Retain a folder with even one extra file. ZIPs may have been copied/extracted under another name: match by file count, total size, extension/path signature, and final content hashes, not name/location. [Task 1]

## Failures and how to do differently

- Symptom: a cleanup candidate looks duplicated by name, extension, or adjacent ZIP/folder placement -> cause: `uxm`/`uxb` scope confusion or renamed extraction -> fix: follow the evidence order and require full path/size/hash equivalence before considering deletion; stop for explicit user approval. [Task 1]
- Symptom: parallel work collides with Claude's changes -> cause: shared status was not checked or a `CLAIM`/`Devam ediyor` marker was ignored -> fix: read both shared logs first and avoid claimed/planned files. [Task 1]
