# Working Agreement (Copilot Side)

## Canonical References

- reports/HAMLE8_KOD_GERCEKLIGI_MATRIS_2026-05-02.md
- COMPILER_COVERAGE.md
- COMPILER_TODO.md

## Mandatory Rules

1. One scoped patch at a time.
2. Create lock file in .codex/locks before source edits.
3. Run tests for touched lanes.
4. Update COMPILER_COVERAGE.md when status changes.
5. Never mark OK without command + output evidence.

## Coordination

- Announce claimed files in .copilot/TASK_INBOX.md
- Release lock after merge-ready patch
