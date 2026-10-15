# Raw Memories

Merged stage-1 raw memories (stable ascending thread-id order):

## Thread `01a08ff6-0ce0-7a70-af3e-882b23a440c8`
updated_at: 2026-09-11T10:20:44+00:00
cwd: C:\Users\mete\Downloads\BasicOyunSource\uXBasic_repo
rollout_path: \\?\C:\Users\mete\.codex\sessions\2026\09\11\rollout-2026-09-11T13-14-22-01a08ff6-0ce0-7a70-af3e-882b23a440c8.jsonl
rollout_summary_file: 2026-09-11T10-14-22-t0xO-windows_ai_tools_mcp_vscode_inventory.md

---
description: Read-only Windows inventory found multiple AI assistants, 62 VS Code extensions, 230 agent prompt definitions, eight Ollama models, and five Codex MCP registrations; distinguish installed/configured from connected/active.
task: inventory-installed-ai-tools-vscode-agents-mcp
 task_group: windows-ai-tooling-inventory
task_outcome: success
cwd: C:\Users\mete\Downloads\BasicOyunSource\uXBasic_repo
keywords: Windows, PowerShell, VS Code, Ollama, OpenClaw, Codex, Claude Code, Grok CLI, Kimi, Qwen, MCP, GitNexus, OpenViking, Playwright, Node REPL
---

### Task 1: Inventory AI tools and developer assistants

task: identify-installed-ai-assistants-and-cli-tools
task_group: windows-ai-tooling-inventory
task_outcome: success

Preference signals:
- The user asked broadly which named assistants are present, including “VSCode dahil” -> similar requests should proactively inspect desktop installs, PATH commands, running processes, VS Code extensions, and config traces in one read-only pass.

Reusable knowledge:
- Verified installations: Grok CLI `@webdevtoday/grok-cli` 0.2.1; OpenClaw 2026.2.21-2; Ollama 0.33.2; OpenAI Codex CLI package 0.133.0 plus desktop/AppX presence; Claude Desktop plus Claude Code 2.1.132; GitHub Copilot package 1.0.43; Pi Coding Agent 0.70.6; Antigravity 2.2.1; VS Code 1.136.1.
- Kimi was verified as VS Code extension `denizhandaklr.kimi-lm-provider` 0.3.0. Qwen was verified through Ollama models, not a separate CLI. ZChat was not found in checked locations. Cursor had a stale shortcut/config trace but its target executable was absent.

Failures and how to do differently:
- Initial execution failed with `CreateProcess ... Dizin adı geçersiz. (os error 267)`; use an explicit valid Windows workdir such as `C:\Users\mete` and `login:false`.
- Do not equate a directory, shortcut, or config trace with an installed/runnable application; report evidence categories separately.

References:
- `C:\Users\mete\AppData\Roaming\npm\node_modules\@webdevtoday\grok-cli`
- `C:\Users\mete\AppData\Roaming\npm\node_modules\@openai\codex`
- `C:\Users\mete\AppData\Roaming\npm\node_modules\@anthropic-ai\claude-code`
- `C:\Users\mete\tools\node-global\node_modules\openclaw`
- Cursor shortcut target checked: `C:\Users\mete\AppData\Local\Programs\cursor\Cursor.exe` (exists=false)

### Task 2: Inventory VS Code extensions and agents

task: inspect-vscode-extensions-and-agent-prompts
task_group: vscode-ai-agents
task_outcome: success

Reusable knowledge:
- `code.cmd --list-extensions --show-versions` and `extensions.json` confirmed 62 VS Code extensions.
- AI-related extensions: `openai.chatgpt`, `Continue.continue`, `SilasNevstad.gpthelper`, `DenizhanDaklr.glm-chat-provider`, `DenizhanDaklr.kimi-lm-provider`, and `denizhandaklr.minimax-vscode`.
- `C:\Users\mete\AppData\Roaming\Code\User\prompts` contained 230 agent definitions: 179 `agency-agents`, 48 `claude-game-studios`, and 3 standalone agents (`git-nexus.agent.md`, `gsd-open-viking.agent.md`, `open-claw.agent.md`). Agent files are templates/instructions, not proof of simultaneous execution.

References:
- `C:\Users\mete\AppData\Roaming\Code\User\prompts`
- `C:\Users\mete\.vscode\extensions\extensions.json`
- Command: `code.cmd --list-extensions --show-versions`

### Task 3: Inventory Ollama, MCP, and plugin configuration

task: inspect-ollama-models-codex-mcp-and-plugin-config
 task_group: local-ai-mcp-configuration
task_outcome: success

Reusable knowledge:
- Ollama models: `qwen3.5:latest`, `qwen3:0.6b`, `qwen2.5:3b`, `qwen2.5-coder:3b`, `deepseek-r1:1.5b`, `smollm:360m`, `nomic-embed-text:latest`, `all-minilm:latest`. `ollama ps` showed no loaded model during inspection.
- Codex `C:\Users\mete\.codex\config.toml` registered `[mcp_servers.gitnexus]`, `[mcp_servers.linear]`, `[mcp_servers.openviking]`, `[mcp_servers.playwright]`, and `[mcp_servers.node_repl]`. GitNexus and OpenViking launcher files existed; registration is not a connectivity test.
- Codex enabled built-in plugin entries included Documents, Presentations, Spreadsheets, PDF, GitHub, Visualize, Template Creator, Browser, Chrome, Codex App Tools, Computer Use, Unified Computer Use, and Sites.
- Gemini/Antigravity plugin directories included Android CLI, Chrome DevTools, Data Agent Kit, Firebase, Flutter, Google Maps Platform, Antigravity SDK, Modern Web Guidance, and Science.
- Pi settings reported provider `ollama`, model `qwen3.5`; OpenClaw default model was `github-copilot/gpt-4o`.

Failures and how to do differently:
- Configuration schemas differed across Claude, Cursor, Gemini, Continue, and OpenClaw; null property names from generic JSON enumeration are not reliable evidence of empty configs. Parse product-specific keys and state uncertainty.
- Keep “installed,” “configured,” “running,” “authenticated,” and “connectivity verified” as separate statuses. No account login or MCP health test was performed in this rollout.

References:
- `C:\Users\mete\.codex\config.toml`
- `C:\Users\mete\.local\bin\gitnexus.cmd`
- `C:\Users\mete\.local\bin\openviking-mcp.cmd`
- Command: `C:\Users\mete\AppData\Local\Programs\Ollama\ollama.exe list`
- Command: `C:\Users\mete\AppData\Local\Programs\Ollama\ollama.exe ps`

## Thread `01a0a99d-b964-7aa0-9e5b-bd5ff703487d`
updated_at: 2026-09-16T09:48:03+00:00
cwd: \\?\C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc
rollout_path: C:\Users\mete\.codex\sessions\2026\09\16\rollout-2026-09-16T12-48-01-01a0a99d-b964-7aa0-9e5b-bd5ff703487d.jsonl
rollout_summary_file: 2026-09-16T09-48-01-sAu9-byref_parity_ve_mir_metadata_aciklari.md

---
description: BYREF alias ve compound-assignment parity eksikleri için çalışma başlangıç durumu; kod inceleme ve düzeltme talebi geldi ancak bu rolloutta uygulama/doğrulama yapılmadı
task: BYREF alias ve compound-assignment parity eksiklerini giderme
task_group: UXBc compiler/backend parity
task_outcome: uncertain
cwd: C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc
keywords: BYREF, alias, compound-assignment, parity, AST, MIR, JS, MIR-x64, AST-x64, WASM virtual probe, base-constructor metadata
---

### Task 1: BYREF parity ve MIR metadata açıkları

task: BYREF alias ve compound-assignment parity ölçümlerindeki eksikleri inceleyip düzeltme
task_group: UXBc compiler/backend parity
task_outcome: uncertain

Preference signals:
- Kullanıcı "kodu incele ve gerekenleri yap, eksikleri gider" dedi -> benzer görevlerde yalnızca teşhis değil, kod değişikliği ve ölçümle doğrulama bekleniyor.
- Kullanıcı parity tamamlanmadan işin tamamlandı işaretlenmediğini belirtti -> gelecekte sonuçları backend ölçümleriyle doğrulamadan tamamlandı kabul etme.

Reusable knowledge:
- Başlangıç BYREF ölçümleri: AST=11, MIR=11, JS=2, MIR-x64=2, AST-x64=10.
- Açık sınırlar: MIR yorumlayıcısında çok seviyeli base-constructor metadata zinciri ve ayrı WASM virtual probe.

Failures and how to do differently:
- Bu rolloutta araç çağrısı, dosya incelemesi, patch veya test sonucu yok; hiçbir düzeltme doğrulanmış değil.
- Takipte AST/MIR/JS/MIR-x64/AST-x64 ayrışmaları bulunmalı; metadata zinciri ve WASM probe ayrı doğrulanmalı, sonra parity ölçümleri yeniden alınmalı.

References:
- `C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc`
- `AST=11, MIR=11, JS=2, MIR-x64=2, AST-x64=10`
- `BYREF alias ve compound assignment parity’si hâlâ açık sahiplikte.`

