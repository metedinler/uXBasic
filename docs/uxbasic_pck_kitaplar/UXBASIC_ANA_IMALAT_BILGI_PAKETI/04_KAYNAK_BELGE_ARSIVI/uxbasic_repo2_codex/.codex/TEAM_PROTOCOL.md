# Team Protocol (Codex + Copilot)

## Conflict Prevention

1. One owner per file cluster at a time.
2. Before edit, create lock file under .codex/locks.
3. If unexpected edits appear in owned files, stop and sync via TASK_BOARD.
4. No broad refactor while another agent is touching the same area.

## Lock Format

Filename: <agent>__<scope>.lock
Content:
- owner
- scope
- files
- started_at_utc
- expected_release

## Required Workflow

1. Claim task in .codex/TASK_BOARD.md
2. Create lock file
3. Implement minimal patch
4. Run targeted tests
5. Update COMPILER_COVERAGE.md
6. Release lock and update TASK_BOARD

## Scope Split for Current Sprint

- Agent-A: MIR dispatch and semantic/mir runtime lanes
- Agent-B: x64 builtin gaps and input parity
- Shared only by agreement: COMPILER_COVERAGE.md
