# uXBasic Dosya Manifestosu ve Modulerlesme Kurallari

Tarih: 2026-04-23

Bu manifesto iki amac tasir:

1. Kod kaybi olmadan refactor yapmak.
2. Her modulun yalnizca kendi gorevini icermesini saglamak.

## 1. Refactor Guvenlik Kurallari

- Kod silinmez; once tasinir, sonra testlerle dogrulanir, ancak islevsiz/duplicate oldugu kanitlanan parca ayri bir temizlik turunda kaldirilir.
- Her tasima isinde once eski fonksiyon adi, yeni dosya yolu ve test kaniti not edilir.
- Bir modul, kendi gorevi disindaki kodu icermemelidir.
- Hedef dosya boyutu 900 satirdir.
- 901-1000 satir tolerans bandidir; yeni kod eklenmemeli, ilk firsatta bolunmelidir.
- 1000+ satir zorunlu refactor adayidir.
- Asiri dosya sayisi da bakimi zorlastirir; bu nedenle bolme islemi "tek fonksiyon tek dosya" seklinde degil, sorumluluk gruplarina gore yapilir.
- Her yeni dosya `main_*_include_bundle.fbs` veya ilgili katman bundle'i uzerinden dahil edilmelidir.
- Refactor sonrasi minimum dogrulama: compiler build + ilgili AST/MIR/native smoke.

## 2. Katman Sahipligi

| Katman | Sahip Oldugu Kod | Sahip Olmamasi Gereken Kod |
|---|---|---|
| `parser/lexer` | token, keyword, preprocess token akisi | runtime davranisi, codegen kararlari |
| `parser/parser` | syntax -> AST | semantic type kararinin kalici sonucu, native ABI |
| `semantic` | type, layout, HIR/MIR, semantic hata | console I/O, DLL invoke, NASM text |
| `runtime` | AST interpreter, runtime value, file/memory/FFI invoke | parser token kurallari, native asm emit |
| `codegen/x64` | AST/MIR -> x64 asm, native ABI | AST interpreter state, CLI |
| `build` | artifact, rsp, bat, toolchain, link | dil semantic kurallari |
| `main.bas` | CLI orchestration | parser/runtime/codegen implementasyonu |

## 3. Boyut Durumu

### Zorunlu Bolunme Adaylari

| Dosya | Satir | Sorun | Onerilen Bolme |
|---|---:|---|---|
| `src/semantic/mir.fbs` | 2667 | MIR model, evaluator, lowering, optimizer, JSON ayni dosyada | `mir_types.fbs`, `mir_eval.fbs`, `mir_lowering.fbs`, `mir_opt.fbs`, `mir_json.fbs` |
| `src/codegen/x64/code_generator.fbs` | 2291 | context, emit expr, emit stmt, runtime helpers, FFI, program emit ayni dosyada | `context.fbs`, `emit_expr.fbs`, `emit_stmt.fbs`, `emit_runtime.fbs`, `emit_ffi.fbs`, `emit_program.fbs` |
| `src/runtime/exec/exec_eval_support_helpers.fbs` | 1676 | FFI policy, resolver, marshal, type helpers, audit ayni dosyada | `exec_ffi_policy.fbs`, `exec_ffi_resolver.fbs`, `exec_ffi_marshal.fbs`, `exec_value_type_helpers.fbs` |
| `src/runtime/memory_exec.fbs` | 1594 | runtime state, expression eval, statement dispatch, legacy MIR placeholder izleri | `exec_state.fbs`, `exec_eval_core.fbs`, `exec_stmt_dispatch.fbs`, `exec_program_runner.fbs` |
| `src/semantic/semantic_pass.fbs` | 1061 | import, declaration, routine, interface, class semantic karisik | `semantic_imports.fbs`, `semantic_routines.fbs`, `semantic_classes.fbs`, `semantic_interfaces.fbs` |

### Tolerans Bandinda

| Dosya | Satir | Not |
|---|---:|---|
| `src/runtime/exec/exec_eval_builtin_categories.fbs` | 906 | Yeni builtin eklenmemeli; kategori dosyalarina ayrilmali |

### Stabil Kalabilecek Dosyalar

Bu dosyalar 900 satir altinda ve su an tek sorumluluk sinirina daha yakin:

- `src/build/interop_manifest.fbs`
- `src/parser/parser/parser_stmt_dispatch.fbs`
- `src/runtime/exec/exec_stmt_flow.fbs`
- `src/parser/lexer/lexer_preprocess.fbs`
- `src/parser/parser/parser_stmt_decl_core.fbs`
- `src/codegen/x64/ffi_call_backend.fbs`
- `src/codegen/x64/inline_backend.fbs`
- `src/codegen/x64/var_mapping.fbs`

## 4. Onerilen Yeni Dosya Manifestosu

### MIR

| Yeni Dosya | Icerik |
|---|---|
| `src/semantic/mir_types.fbs` | MIR instruction, block, function, module, value type tanimlari |
| `src/semantic/mir_eval_core.fbs` | evaluator state, load/store, arithmetic, control flow |
| `src/semantic/mir_eval_builtins.fbs` | MIR builtin call evaluator |
| `src/semantic/mir_eval_ffi.fbs` | MIR `CALL(DLL/API)` invoke |
| `src/semantic/mir_lower_expr.fbs` | AST expression -> MIR |
| `src/semantic/mir_lower_stmt.fbs` | AST statement -> MIR |
| `src/semantic/mir_opt.fbs` | optimizer pass |
| `src/semantic/mir_json.fbs` | opcode/pipeline JSON export |

### x64 Codegen

| Yeni Dosya | Icerik |
|---|---|
| `src/codegen/x64/context.fbs` | `X64CodegenContext`, global arrays, label helpers |
| `src/codegen/x64/emit_expr.fbs` | expression emit |
| `src/codegen/x64/emit_stmt.fbs` | statement dispatch and emit |
| `src/codegen/x64/emit_runtime.fbs` | `__uxb_runtime_*`, `__uxb_builtin_*` helper emit |
| `src/codegen/x64/emit_ffi.fbs` | in-program FFI stub/arg emit |
| `src/codegen/x64/emit_program.fbs` | program header, externs, main, final assembly |
| `src/codegen/x64/code_generator.fbs` | sadece public facade: `GenerateX64Code` |

### Runtime

| Yeni Dosya | Icerik |
|---|---|
| `src/runtime/exec/exec_state.fbs` | `ExecState`, `ExecVar`, state init |
| `src/runtime/exec/exec_eval_core.fbs` | number/string/ident/binary/unary/call expression eval |
| `src/runtime/exec/exec_stmt_dispatch.fbs` | top-level runtime statement dispatch |
| `src/runtime/exec/exec_ffi_policy.fbs` | allowlist, policy, audit |
| `src/runtime/exec/exec_ffi_resolver.fbs` | x86/x64 resolver state |
| `src/runtime/exec/exec_ffi_marshal.fbs` | argument type parsing and marshalling |
| `src/runtime/exec/exec_builtin_*.fbs` | scalar/text/file/memory/collection/ffi kategori dosyalari |

## 5. Yeni Dil Ozellikleri Icin Dosya Sahipligi

| Ozellik | Parser | Semantic/MIR | Runtime | x64 Codegen | Build |
|---|---|---|---|---|---|
| `CALL(API, ...)` | `parser_stmt_dispatch.fbs` | `mir_eval_ffi.fbs` | `exec_builtin_ffi` | `emit_ffi.fbs` + backend | resolver metadata |
| `EVENT ... END EVENT` | yeni `parser_stmt_event_pipe.fbs` | slot table + MIR block | `exec_slot_manager.fbs` | sonraki faz | yok |
| `THREAD/THREAT ... END THREAD` | yeni `parser_stmt_event_pipe.fbs` | slot table | `exec_slot_manager.fbs` | sonraki faz | runtime helper |
| `PARALEL ... END PARALEL` | yeni `parser_stmt_event_pipe.fbs` | slot table | `exec_slot_manager.fbs` | sonraki faz | runtime helper |
| `PIPE ... END PIPE` | yeni `parser_stmt_event_pipe.fbs` | pipe IR | `exec_pipe_runtime.fbs` | sonraki faz | yok |
| pipe operator `|` | `parser_expr.fbs` | pipe operator lowering | runtime pipe eval | sonraki faz | yok |
| `SLOT`, `ON`, `OFF`, `TRIGGER` | yeni parser stmt | slot state semantic | slot manager | sonraki faz | yok |

Not: Kullanici metnindeki `threat` yazimi korunur; teknik ic modelde canonical ad `THREAD` olacak, `THREAT` alias olarak degerlendirilecektir.
