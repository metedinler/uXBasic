# ADIM25-26-27 — AST/MIR/WEB/CLI Kapatma Planı

Bu paket ADIM24 PASS sonrasında uygulanır. Amaç yeni büyük mimari icat etmek değil, konuşulan üç hedefi kapatmaktır:

1. **AST -> MIR eksiksiz olacak.**
2. **MIR -> JS/WAT/WASM/BROWSER eksiksiz olacak.**
3. **CLI 3 harfli köprü ana zincirde doğrulanacak.**

## ADIM25 — AST -> MIR Coverage Gate

Dosyalar:

```text
src/semantic/ast_mir_route_table_adim25.fbs
src/semantic/ast_mir_coverage_gate_adim25.fbs
```

Görev:

- AST node kind listesini tarar.
- Her node için route belirler: MIR_REQUIRED, EXPR_ONLY, DECL_ONLY, COMPILE_TIME_ONLY, NATIVE_ONLY, CONTAINER.
- MIR required node için beklenen MIR opcode ailesinin modülde bulunup bulunmadığını denetler.
- AST backend'e doğrudan veri vermez; coverage/source-map/diagnostic rolündedir.

Beklenen raporlar:

```text
reports/control/current/adim25_ast_mir_coverage.csv
reports/control/current/adim25_ast_mir_coverage.json
```

## ADIM26 — MIR -> JS/WAT/WASM/BROWSER Coverage Gate

Dosyalar:

```text
src/codegen/js/js_mir_opcode_coverage_adim26.fbs
src/codegen/wasm/wasm_mir_opcode_coverage_adim26.fbs
src/backend/backend_web_coverage_gate_adim26.fbs
```

Görev:

- MIR opcode setini tarar.
- JS için DIRECT_JS / RUNTIME_JS / HOST_FALLBACK_JS / NATIVE_ONLY_DIAGNOSTIC kararını verir.
- WAT/WASM için DIRECT_WAT / HOST_IMPORT_WAT / NATIVE_ONLY_DIAGNOSTIC kararını verir.
- Native-only opcode web hedeflerinde fail-close olur.
- Bilinmeyen ama host-safe opcode sessizce yok sayılmaz; host fallback route'a yazılır.

Beklenen raporlar:

```text
reports/control/current/adim26_js_opcode_coverage.csv
reports/control/current/adim26_wasm_opcode_coverage.csv
```

## ADIM27 — CLI 3 Harfli Komut Zinciri Kapanışı

Dosyalar:

```text
src/cli/cli_backend_route_close_adim27.fbs
src/main_backend_close_gate_adim27.fbs
```

Görev:

- lex/par/ast/sem/hir/mir/int/x64/x86/jsw/wat/bld/run/chk/fmt/map/doc/rel/hlp/ver komutlarını denetler.
- Her verb'ün eski CLI flag sisteminde karşılığı olduğunu kanıtlar.
- CLI köprüsü sadece help metni değil, eski HasArg/GetArgValue uyumluluk katmanını da doğrular.

Beklenen rapor:

```text
reports/control/current/adim27_cli_route_close.csv
```

## Uygulama

Yeni dosyaları aynı repo yollarına kopyala. Ana dosyaları komple ezme.

### src/main.bas içine include ekle

`patch_files/snippets/main_bas_include_snippet_adim25_26_27.fbs` içeriğini mevcut include bloklarından sonra ekle.

### src/main_program_entry.fbs içine call ekle

`patch_files/snippets/main_program_entry_after_mir_ready_snippet_adim25_26_27.fbs` içeriğini MIR hazırlandıktan ve mandatory MIR gate geçtikten sonra, web backend çağrısından önce ekle.

### İsteğe bağlı daha sıkı backend içine gate ekleme

`patch_files/snippets/js_codegen_adim26_snippet.fbs` dosyasındaki include/call parçaları `src/codegen/js/js_codegen.fbs` içine eklenebilir.

`patch_files/snippets/wasm_codegen_adim26_snippet.fbs` dosyasındaki include/call parçaları `src/codegen/wasm/wasm_codegen.fbs` içine eklenebilir.

## Copilot kısa emir

```text
ADIM25-26-27 patch paketini uygula.
Ana dosyaları komple ezme.
Yeni .fbs dosyalarını aynı repo yollarına kopyala.
src/main.bas içine ADIM25/26/27 include snippetini ekle.
src/main_program_entry.fbs içine ADIM25/26/27 close gate call snippetini MIR hazır olduktan sonra ekle.
Placeholder artifact üretme.
Test runner'a çıktı uydurma kodu ekleme.
Derleme hatasında geniş tamirata girme; ilk 30 hatayı raporla.
compiler/scripts/run_adim25_26_27_close_gates.ps1 -NoRepair çalıştır.
```
