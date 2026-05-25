# Copilot Adım 3 Görevi — Runtime-backed MIR x64

Copilot, bu görevde yeni mimari icat etmeyeceksin. Mevcut UXBc mimarisine eklenecek modülleri bağlayacaksın.

## Önce zorunlu oku

1. `uxb/docs/COPILOT_WORKSPACE_CLEAN_POLICY.md`
2. `uxb/docs/UXB_MIMARI_NOTU_BACKENDS_CLI_JSON_I18N.md`
3. `uxb/dist/surface/copilot_step2_targets.md` varsa oku.
4. `uxb/src/codegen/x64/mir_x64_codegen.fbs`
5. `uxb/src/codegen/x64/mir_x64_capability.fbs`
6. `uxb/src/codegen/x64/mir_x64_emit_helpers.fbs`
7. `uxb/src/runtime/console_output.fbs`
8. `uxb/src/runtime/file_io.fbs`
9. `uxb/src/runtime/memory_exec.fbs`

## Kesin kurallar

- AST x64 codegen bozulmayacak.
- MIR x64 experimental/complete modülleri korunacak.
- Unsupported olan opcode sessiz geçilmeyecek.
- Runtime isteyen işlem native sahte emit ile geçiştirilmeyecek.
- Interpreter çıktıları doğruluk referansı olarak kullanılacak.
- Derleme/test/artifact çıktıları `uxb/src` içine yazılmayacak.
- Çıktılar `uxb/_work/projects/<project>/runs/<timestamp>/` altında sınıflandırılacak.
- `.bas`, `.uxm`, `.uxmh` include tasarımı korunacak.
- `.uxmh` header dosyası executable program değildir; sabit, tip, declare, include, namespace, alias gibi başlık görevi görür.

## Bu patch ile gelen yeni dosyalar

```text
uxb/src/runtime/project_output_policy.fbs
uxb/src/codegen/x64/mir_x64_runtime_call_contract.fbs
uxb/src/codegen/x64/mir_x64_runtime_emit_helpers.fbs
uxb/tools/uxb_project_output_manager.py
uxb/tools/uxb_differential_project_runner.py
uxb/compiler/scripts/run_step3_project_runner.bat
uxb/include/core.uxmh
uxb/include/io.uxmh
uxb/include/string.uxmh
uxb/include/extfp.uxmh
```

## Include zinciri

### 1. `main.bas` veya uygun include bundle içinde ekle

Eğer `uxb/src/runtime` include bölümü varsa:

```freebasic
#include once "runtime/project_output_policy.fbs"
```

Eğer x64 codegen include bölümü varsa:

```freebasic
#include once "codegen/x64/mir_x64_runtime_call_contract.fbs"
#include once "codegen/x64/mir_x64_runtime_emit_helpers.fbs"
```

Mevcut include sırasını bozma.

### 2. `mir_x64_capability.fbs`

Şu opcode/call aileleri desteklenebilir veya runtime-backed olarak raporlanabilir:

```text
PRINT
PRINTLN
INPUT
LINE_INPUT
CLS
LOCATE
COLOR
LEN
ASC
CHR
VAL
STR
LEFT
RIGHT
MID
INSTR
OPEN
CLOSE
EOF
LOF
SEEK
GET
PUT
PRINT_FILE
INPUT_FILE
LINE_INPUT_FILE
MEMCOPY
MEMFILL
PEEK
POKE
```

Runtime helper hazırsa `supported=1`.
Runtime helper yoksa `diagnostic_only=1`, ama sessiz skip yok.

### 3. `mir_x64_codegen.fbs`

Runtime-backed opcode geldiğinde şunu yap:

```text
MIRX64RuntimeEmitCall(...)
```

veya daha özel helper:

```text
MIRX64EmitRuntimePrint
MIRX64EmitRuntimeInput
MIRX64EmitRuntimeFileOpen
MIRX64EmitRuntimeStringLen
MIRX64EmitRuntimeMemoryCopy
```

Eğer mevcut MIR operand yapısı gerekli bilgiyi vermiyorsa:

```text
MIR_X64_RUNTIME_LOWERING_PENDING: opcode X lacks operand metadata
```

diagnostic ver.

## Runtime symbol sözleşmesi

MIR x64 runtime çağrıları şu sembollere indirecek:

```text
__uxb_rt_print_i64
__uxb_rt_print_cstr
__uxb_rt_print_newline
__uxb_rt_input_i64
__uxb_rt_cls
__uxb_rt_locate
__uxb_rt_color

__uxb_rt_strlen
__uxb_rt_left
__uxb_rt_right
__uxb_rt_mid
__uxb_rt_instr
__uxb_rt_val_i64
__uxb_rt_str_i64

__uxb_rt_file_open
__uxb_rt_file_close
__uxb_rt_file_eof
__uxb_rt_file_lof
__uxb_rt_file_seek
__uxb_rt_file_get
__uxb_rt_file_put
__uxb_rt_file_print_cstr
__uxb_rt_file_input_line

__uxb_rt_memcopy
__uxb_rt_memfill
__uxb_rt_peek_i64
__uxb_rt_poke_i64
```

Bu semboller gerçek runtime implementasyonu yoksa linker aşamasında hata verir. Bu nedenle ilk aşamada ASM emit sırasında `extern` listesi ve diagnostic JSON üret.

## Test komutları

Önce workspace temizliği:

```bat
uxb\compiler\scripts\run_workspace_clean_guard.bat
```

Sonra proje runner:

```bat
uxb\compiler\scripts\run_step3_project_runner.bat uxb\tests\basicCodeTests\42_uxb_native_console_codegen_smoke.bas
```

Sonra matrix:

```bat
uxb\compiler\scripts\run_language_surface_full_matrix.bat
```

Sonra MIR x64 smoke:

```bat
uxb\compiler\scripts\run_mir_x64_completion_smoke.bat
```

## Kabul şartları

1. Build varsa bozulmayacak.
2. Toolchain yoksa `TOOLCHAIN_OR_FILE_MISSING` olarak raporlanacak.
3. AST interpreter ve MIR interpreter çıktıları ayrı klasörlerde oluşacak.
4. x64 AST ASM ve MIR x64 ASM çıktıları ayrı klasörlerde oluşacak.
5. JSON dosyaları `json/` altında oluşacak.
6. Loglar `logs/` altında oluşacak.
7. `uxb/src` içine hiçbir çıktı yazılmayacak.
8. Runtime-backed opcodes sahte native emit üretmeyecek.
