# Canonical Sources and Update Order

## Sources

1. reports/HAMLE8_KOD_GERCEKLIGI_MATRIS_2026-05-02.md
2. COMPILER_COVERAGE.md
3. COMPILER_TODO.md
4. reports/HAMLE8A3_PATCH_REPORT_2026-05-02.md

## Update Order (single truth flow)

1. Code change and tests.
2. COMPILER_COVERAGE.md row/status update.
3. If architectural behavior changed, append note to reports/HAMLE8A3_PATCH_REPORT_2026-05-02.md or a new dated report.

## Coverage Update Contract

- Never mark OK without a concrete test command and output value.
- Keep Not column explicit about remaining risk.
- Keep MIR/AST/x64 differences visible, do not hide partial parity.
