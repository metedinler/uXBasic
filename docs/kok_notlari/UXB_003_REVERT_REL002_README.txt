UXB_003_REVERT_REL002
Amaç: UXB_002_REL_X64_FIX sonrası release pipeline 0/20 regresyonu ve ABI10 smoke exit=1 göründüğü için,
002 yamasının değiştirdiği üç dosyayı src(17).zip baz durumuna geri almak.

Geri alınan dosyalar:
- src/semantic/ast_mir_coverage_gate_adim25.fbs
- src/semantic/ast_mir_route_table_adim25.fbs
- src/codegen/x64/helpers/x64_codegen_runtime_emit_helpers.fbs

Not: Bu yama ABI10 PASS durumundaki baz kaynağı hedefler. Uyguladıktan sonra build_64.bat ve ABI10 smoke tekrar çalıştırılmalıdır.
