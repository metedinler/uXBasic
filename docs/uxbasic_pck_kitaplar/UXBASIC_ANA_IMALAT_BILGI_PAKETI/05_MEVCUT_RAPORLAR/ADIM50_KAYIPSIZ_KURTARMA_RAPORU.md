# ADIM50 Kayipsiz Kurtarma Raporu

Bu rapor son kaynak adayını `src(31.05_3).zip` kabul ederek, onceki ZIPlerde olup son pakette davranis/API olarak eksilen noktalarin kurtarilmasi icin hazirlandi.

## Kronolojik ZIP sirasi

| Sira | ZIP | Dosya | Acilmis boyut | Ilk ic tarih | Son ic tarih |
|---:|---|---:|---:|---|---|
| 1 | `src(30.05_1).zip` | 469 | 3.353.764 | 2026-05-25 01:08:02 | 2026-05-30 00:50:36 |
| 2 | `src(30.05_2).zip` | 476 | 3.389.213 | 2026-05-25 01:08:02 | 2026-05-30 01:20:08 |
| 3 | `src(30.05_3).zip` | 476 | 3.401.549 | 2026-05-25 01:08:02 | 2026-05-30 04:40:20 |
| 4 | `src(30.05_4).zip` | 478 | 3.473.174 | 2026-05-25 01:08:02 | 2026-05-30 21:31:14 |
| 5 | `src(30.05_5).zip` | 482 | 3.541.903 | 2026-05-25 01:08:02 | 2026-05-30 21:31:14 |
| 6 | `src(31.05_0).zip` | 485 | 3.714.197 | 2026-05-25 01:08:02 | 2026-05-31 03:22:58 |
| 7 | `src(31.05_1).zip` | 485 | 3.714.197 | 2026-05-25 01:08:02 | 2026-05-31 03:22:58 |
| 8 | `src(31.05_2).zip` | 485 | 3.714.197 | 2026-05-25 01:08:02 | 2026-05-31 03:22:58 |
| 9 | `src(31.05_3).zip` | 485 | 3.695.309 | 2026-05-25 01:08:02 | 2026-05-31 07:43:46 |

## Uygulanan kurtarma kararlari

| Ozellik | Son zipte durum | En guvenli kaynak | Uygulanan dosya/yontem |
|---|---|---|---|
| Backend target X86/WAT | Yok/kırık: son zipte sabitler yok ama referans var | `src(31.05_2).zip` | `src/backend/common/backend_target.fbs` — 31.05_2 tam dosya alındı |
| FFI contract registry | Yok: son zipte sadece runtime/ffi köprüsü var; parser eski API çağırıyor | `src(31.05_2).zip` | `src/runtime/ffi_registry.fbs` — Eski registry + yeni runtime_ffi include birleştirildi |
| File parent directory | Yok: output/append/binary/random açarken klasör açma kaldırılmış | `src(31.05_2).zip` | `src/runtime/file_io.fbs` — 31.05_2 tam dosya alındı |
| INPUT# line reading | Yok: son zip INPUT# için integer/binary okumaya dönmüş | `src(31.05_2).zip` | `src/runtime/file_io.fbs + exec_stmt_io_file.fbs` — 31.05_2 davranışı geri alındı |
| PRINT # | Kısmen: parser yeni PRINT_STMT op=FILE üretiyor, runtime yazmıyor | `src(31.05_2).zip` | `src/runtime/exec/exec_stmt_io_file.fbs` — Eski runtime fonksiyonu geri alındı ve yeni AST op=FILE desteklendi |
| Standalone WHILE/WEND | Yok: son zipte WHILE parse/runtime kaldırılmış | `src(31.05_2).zip` | `parser/parser.fbs; parser_stmt_flow.fbs; parser_stmt_registry.fbs; exec_stmt_flow.fbs` — 31.05_2 dosyaları geri alındı |
| Single-line IF THEN | Yok: son zipte tek satır IF desteği kaldırılmış | `src(31.05_2).zip` | `src/parser/parser/parser_stmt_flow.fbs` — 31.05_2 dosyası geri alındı |
| Text builtins interpreter | Kısmen: helper var ama builtin call dispatch listesi eksilmiş | `src(31.05_2).zip` | `runtime/exec/exec_eval_builtin_categories.fbs; runtime/memory_exec.fbs` — 31.05_2 dispatch geri alındı |
| Bare RND/TIMER | Yok: son zipte çıplak RND/TIMER kaldırılmış | `src(31.05_2).zip` | `src/runtime/memory_exec.fbs` — 31.05_2 dosyası geri alındı |
| AST compatibility | Kısmen: son zip ASTK_PARALLEL_STMT adıyla değer PARALEL_STMT tutuyor; eski ad yok | `src(31.05_2).zip + latest` | `parser/ast_node_kinds.fbs; ast_contract_registry.fbs; ast_contract_layer_bindings.fbs` — Alias ve sözleşme kayıtları eklendi |
| MIR PARALEL alias | Kısmen: son zipte PARALLEL adlı sabit var | `src(31.05_2).zip + latest` | `src/mir/mir_opcode.fbs` — PARALEL alias eklendi |
| Slot range error | Yok | `src(31.05_2).zip` | `src/semantic/semantic_error_codes.fbs` — Sabit geri eklendi |

## Degistirilen dosyalar

- `src/backend/common/backend_target.fbs`
- `src/mir/mir_opcode.fbs`
- `src/parser/ast_contract_layer_bindings.fbs`
- `src/parser/ast_contract_registry.fbs`
- `src/parser/ast_node_kinds.fbs`
- `src/parser/parser.fbs`
- `src/parser/parser/parser_stmt_flow.fbs`
- `src/parser/parser/parser_stmt_registry.fbs`
- `src/runtime/exec/exec_eval_builtin_categories.fbs`
- `src/runtime/exec/exec_stmt_flow.fbs`
- `src/runtime/exec/exec_stmt_io_file.fbs`
- `src/runtime/ffi_registry.fbs`
- `src/runtime/file_io.fbs`
- `src/runtime/memory_exec.fbs`
- `src/semantic/semantic_error_codes.fbs`

## Kullanim

1. Paket icindeki `apply_adim50_recovery_patch.bat` dosyasini `UXBc\uxb` kokune veya proje kokune calistir. Betik once `_adim50_recovery_backup_YYYYMMDD_HHMMSS` yedegi alir.

2. Alternatif olarak `src_31_05_3_ADIM50_RECOVERED.zip` dogrudan kurtarilmis `src/` paketi olarak kullanilabilir.

3. Uygulama sonrasi statik kontrol icin: `python verify_adim50_recovery.py <uxb_koku>`


## Not

Tam klasor ezme yerine secili dosya yamasi hazirlandi. Bunun sebebi son ZIPteki yeni ADIM50 dosyalarini korumak ve sadece geriye dusen/eksilen sozlesmeleri geri almaktir.
