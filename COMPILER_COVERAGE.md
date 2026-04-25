# uXBasic Kanonik Compiler Coverage Matrisi

Tarih: 2026-04-25

Bu dosya, belgelerdeki daginik "var/yok/kismi" ifadelerini tek kanonik matrise toplamak icin baslatildi.

Bu belge artik su dosyalarla birlikte yonetilir:

- [planyap/incelemeplani.md](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/planyap/incelemeplani.md)
- [COMPILER_FILE_MANIFEST.md](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/COMPILER_FILE_MANIFEST.md)
- [PCK5.md](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/PCK5.md)

Yonetim kurali:

- Coverage matrisi kanonik "katman durumu" kaynagidir.
- Plan dosyasi sprint sirasini ve riskleri tutar.
- Manifest dosyasi buyuk dosya bolme sinirlarini tutar.
- Bir ozellikte kod veya test durumu degisirse once bu dosya guncellenir.

Durum etiketleri:

- `OK`: ilgili katmanda uygulama ve smoke/test kaniti var.
- `PARTIAL`: syntax veya runtime var, ama katmanlardan biri eksik/kirgan.
- `MISSING`: kodda dogrudan destek yok.
- `PLANNED`: yeni tasarim olarak kabul edildi, henuz uygulanmadi.
- `LEGACY-DISABLED`: eski syntax bilerek kapali.
- `DOC-DRIFT`: belgede durum kodla uyumsuz.

## 1. Katman Kolonlari

| Kolon | Anlam |
|---|---|
| Lexer/Parser | Keyword/token/AST uretimi |
| Semantic | type/layout/name/contract kontrolu |
| AST Runtime | `--execmem --interpreter-backend AST` |
| MIR Runtime | `--execmem --interpreter-backend MIR` |
| x64 Codegen | `--emit-x64-nasm` ve `--build-x64` |
| Tests | Otomatik veya manual test kaniti |
| Docs | PCK5/README/mimari belgeleriyle uyum |

## 2. Oncelikli Coverage Matrisi

| Grup | Dil Yuzeyi | Lexer/Parser | Semantic | AST Runtime | MIR Runtime | x64 Codegen | Tests | Docs | Not |
|---|---|---|---|---|---|---|---|---|---|
| Akis | `IF/ELSE/END IF` | OK | OK | OK | OK | PARTIAL | OK | OK | Native parity derinlestirilecek |
| Akis | `SELECT CASE` | OK | OK | OK | PARTIAL | PARTIAL | OK | OK | `21_matrix_flow_if_select_exitif.bas` AST/MIR/native smoke ile dogrulandi; MIR tarafinda `EXIT IF` komsulugu halen derin parity istiyor |
| Akis | `FOR/NEXT` | OK | OK | OK | OK | PARTIAL | OK | OK | STEP/parity genisletilecek |
| Akis | `DO/LOOP` | OK | OK | OK | OK | PARTIAL | OK | OK | `6.bas` AST/MIR/native smoke gecti; native loop parity daha fazla kombinasyonla derinlestirilecek |
| Akis | `FOR EACH`, `DO EACH` | OK | OK | OK | PARTIAL | PARTIAL | OK | OK | `23_matrix_each_loops.bas` AST/MIR/native smoke gecti; coverage artik kanitli |
| Akis | `GOTO/GOSUB/RETURN` | OK | OK | OK | PARTIAL | PARTIAL | OK | OK | `run_jump_exec_ast.exe` PASS, native `LABEL/GOTO/GOSUB` emit `13_uxb_commands_operators_types.bas` asm/build ile dogrulandi |
| Tanim | `CONST/DIM/REDIM` | OK | OK | OK | OK | PARTIAL | OK | OK | AST runtime + MIR runtime indexed assignment/load ve `REDIM PRESERVE` probe'u gecti; native x64 hala daha genis array/type parity kapsamasina ihtiyac duyuyor |
| Tanim | `TYPE` | OK | OK | OK | PARTIAL | PARTIAL | OK | OK | `type_class_field_probe.bas` AST/MIR/native olarak `10 / 15 / 33`, `type_class_field_mutation_probe.bas` AST/MIR/native olarak `12 / 40`; aggregate/nested field parity halen acik |
| Tanim | `CLASS/INTERFACE/NEW/DELETE` | OK | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | `NEW` parser akisi duzeltildi, `native_class_field_single_probe.bas` native x64 ile `33`; temel field read/write parity AST/MIR/native smoke ile var, ileri OOP/aggregate parity halen acik |
| Tanim | `DEFINT/DEFLNG/...` | OK | PARTIAL | OK | OK | metadata-only | OK | DOC-DRIFT | `run_deftype_setstringsize_exec.exe` PASS; belgelerde eski eksik yazilmis olabilir |
| Tanim | `SETSTRINGSIZE` | OK | PARTIAL | OK | OK | metadata-only | OK | DOC-DRIFT | `run_deftype_setstringsize_exec.exe` PASS; native string ABI baglantisi sonraki faz |
| G/C | `PRINT` | OK | OK | OK | OK | PARTIAL | OK | OK | `run_print_exec_ast.exe` PASS, `10.bas` native smoke gecti; x64 print zinciri artik test kanitli |
| G/C | `INPUT` | OK | OK | OK | MISSING/PARTIAL | MISSING | PARTIAL | OK | Native console input yok |
| G/C | `OPEN/CLOSE/GET/PUT/SEEK` | OK | OK | OK | PARTIAL | OK | OK | OK | Native x64 CRT helper lane dogrulandi; `native_file_io_probe2.bas` yaz/oku ve `native_lof_eof_probe.bas` LOF/EOF smoke gecti |
| Ekran | `CLS/COLOR/LOCATE` | OK | OK | OK | OK | PARTIAL | OK | DOC-DRIFT | `run_console_state_exec_ast.exe` PASS; native helper gercekligi yine de daha fazla smoke ister |
| Bellek | `POKE*/PEEK*` | OK | OK | OK | PARTIAL | MISSING/PARTIAL | OK | OK | Native memory model netlesmeli |
| Bellek | `MEMCOPY*/MEMFILL*` | OK | OK | OK | PARTIAL | MISSING/PARTIAL | OK | DOC-DRIFT | Belgelerde bazi yanlis negatifler var |
| Yardimci | `INC/DEC` | OK | OK | OK | OK | PARTIAL | OK | DOC-DRIFT | Native scalar smoke gecti; AST/MIR indexed target runtime hazir, parser yuzeyi ayri fazda genisletilecek |
| Rastgele | `RANDOMIZE/RND` | OK | OK | OK | OK | PARTIAL | OK | DOC-DRIFT | Native smoke gecti; tam parity icin determinism ve varyantlar derinlestirilecek |
| Zaman | `TIMER` | OK | OK | OK | OK | PARTIAL | OK | DOC-DRIFT | Native `TIMER()` smoke gecti; `unit` ve `start,end,unit` varyantlari derinlestirilecek |
| Tus | `INKEY/GETKEY` | OK | OK | OK | OK | PARTIAL | PARTIAL | DOC-DRIFT | `INKEY(flags[,state])` ve `GETKEY()` ayrimi aktif; native builtin map artik ayri sembole iniyor, davranis parity genisletilecek |
| Metin | `LEN/MID/UCASE/LCASE/LTRIM/RTRIM/SPACE/STRING` | OK | OK | OK | OK | PARTIAL | OK | DOC-DRIFT | Native `LTRIM/RTRIM` smoke eklendi; core string builtin zinciri genisledi, tam parity icin array/type kombinasyonlari kaldi |
| Sayi | `ABS/INT/FIX/SGN/SQR/SIN/COS/TAN/ATN/EXP/LOG` | OK | OK | OK | OK | PARTIAL | OK | OK | `operator_stage2_probe.bas` AST/native ile `ABS`, `13_uxb_commands_operators_types.bas` native build ile sayi lane'i test kanitina kavustu |
| Operator | Aritmetik `+ - * / MOD` | OK | OK | OK | OK | PARTIAL | OK | OK | `6.bas` AST/MIR/native ve `13_uxb_commands_operators_types.bas` native build ile arithmetic lane test kanitli |
| Operator | Mantiksal/bitwise `AND/OR/XOR/NOT/SHL/SHR/ROL/ROR` | OK | OK | OK | OK | PARTIAL | OK | OK | `AND/OR` keyword lane'i logical short-circuit olarak ayrildi, `&/|` bitwise lane'i korunuyor; `operator_keyword_logic_probe.bas` AST/MIR/native gecti, `operator_stage2_probe.bas` ciktilari backendler arasi hizali |
| Operator | Bilesik atama `+= -= *= /= \=` | OK | OK | OK | PARTIAL | PARTIAL | OK | PARTIAL | `runtime_mir_indexed_array_probe.bas` ile indexed `+=` AST/MIR/native gecti; tam scalar parity icin MIR/x64 izleri temizlenecek |
| Interop | `IMPORT(C/CPP/ASM, file)` | OK | OK | N/A | N/A | OK | OK | OK | Build lane olgun |
| Interop | `INLINE(...) ... END INLINE` | OK | PARTIAL | N/A | N/A | PARTIAL | PARTIAL | OK | Ana emit path'e dokulu degil |
| FFI | `CALL(DLL, ...)` | OK | OK | OK | OK | OK | OK | PARTIAL | Windows smoke gercek calisiyor |
| FFI | mixed arg list `"PTR,STRPTR,..."` | OK | PARTIAL | OK | PARTIAL | OK | OK | PARTIAL | F64/callback/struct eksik |
| API | `CALL(API, ...)` | PARTIAL | PARTIAL | PARTIAL | MISSING | MISSING | PARTIAL | MISSING | Yeni ayri sistem tasarlanacak |
| Event | `EVENT ... END EVENT` | OK | MISSING | PARTIAL | MISSING | MISSING | PARTIAL | PLANNED | AST runtime deterministik slot trigger MVP var |
| Thread | `THREAD ... END THREAD` | OK | MISSING | PARTIAL | MISSING | MISSING | PARTIAL | PLANNED | `THREAT` aliasi kaldirildi; canonical `THREAD` kaldi |
| Parallel | `PARALEL ... END PARALEL` | OK | MISSING | PARTIAL | MISSING | MISSING | PARTIAL | PLANNED | `PARALLEL` aliasi kaldirildi; canonical `PARALEL` kaldi |
| Pipe | `PIPE ... END PIPE` | OK | MISSING | PARTIAL | MISSING | MISSING | PARTIAL | PLANNED | AST runtime `INPUT`/`OUTPUT` MVP var |
| Pipe Operator | `expr | fn` | OK | MISSING | PARTIAL | MISSING | MISSING | PARTIAL | PLANNED | AST runtime pipe trigger MVP var |
| Slot | `SLOT`, `<i8/u8 slotsayisi>` | OK | MISSING | PARTIAL | MISSING | MISSING | PARTIAL | PLANNED | `<U8 ...>` / `<I8 ...>` yuzeyi aktif; `BYTE` yuzeyden kaldiriliyor |
| Slot Control | `ON/OFF/TRIGGER` | OK | MISSING | PARTIAL | MISSING | MISSING | PARTIAL | PLANNED | AST runtime slot manager MVP var |

## 2.1 2026-04-24 Izleme Notu

- `layout` tek kaynakli hale getirildi.
- runtime global-state tasimasi `ExecRuntimeContext` altina alindi.
- `memory_exec` icindeki FFI policy/resolver/invoke bloğu [exec_ffi_runtime.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/runtime/exec/exec_ffi_runtime.fbs) dosyasina ayrildi.
- `mir.fbs` icinde model/opcode/declaration bloğu [mir_model.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_model.fbs) dosyasina ayrildi.
- `mir.fbs` icinde pipeline exporter bloğu [mir_exporter_json.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_exporter_json.fbs) dosyasina ayrildi.
- x64 FFI arg-count yolu [code_generator.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/codegen/x64/code_generator.fbs) icinde sertlestirildi.
- `src/main.bas` icinde `--emit-x64-nasm` yolu dogrudan `GenerateX64Code` hattina baglandi.
- `ALIAS` parseri uc yuzeyi ayni AST'ye indiriyor:
  - `ALIAS Yeni = Eski`
  - `ALIAS Yeni AS Eski`
  - `ALIAS Yeni Eski`
- Bu genisleme `CALL(DLL, ...)` alias hedefleri icin de aktif; `run_call_dll_alias_exec_ast_64.exe` yeniden geciyor.
- Dil yuzeyi sikilastirmalari:
  - `SQRT` kaldirildi, hata mesaji `use SQR`
  - `THREAT` kaldirildi, canonical `THREAD`
  - `PARALLEL` kaldirildi, canonical `PARALEL`
  - `SLOT <BYTE ...>` yerine `SLOT <I8 ...>` / `SLOT <U8 ...>`
  - `DEFBYT` runtime/MIR icte `I8` olarak normalize edilmeye baslandi
- `uxbasic_next.exe` ile `31_uxb_windows_kernel_sleep_tick.bas` ve `32_uxb_windows_user32_metrics.bas` icin `--emit-x64-nasm` ve matrix `--build-x64` smoke tekrar temiz gecti.
- Parser tarafinda indexed assignment yuzeyi acildi; `arr(i) = ...` satirlari artik `ASSIGN_STMT` + `CALL_EXPR` lhs olarak AST'ye iniyor.
- [src/codegen/x64/code_generator.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/codegen/x64/code_generator.fbs) icinde native `SELECT CASE`, `CASE IS`, `CASE ELSE`, `DO/LOOP` ve `EXIT IF/FOR/DO` emit yolu eklendi.
- Ayni dosyada native `FOR EACH` / `DO EACH` emit yolu da eklendi; `23_matrix_each_loops.bas` native build/run ciktilari `each= 63` ve `doeach= 15` olarak dogrulandi.
- Ayni dosyada native math/operator coverage genisledi:
  - builtin wrapper emit: `ABS`, `INT`, `FIX`, `SGN`, `VAL`, `ASC`, `RND`, `SQR`, `SIN`, `COS`, `TAN`, `ATN`, `EXP`, `LOG`
  - binary/unary emit: `MOD`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`, `ROL`, `ROR`
  - sembolik operator yuzeyi: `==`, `!=`, `^`, unary `!`, unary `~`
- `tests/probes/operator_symbol_probe.bas` ile `==`, `!=`, `^`, `!`, `~` parser + semantic + MIR opcode JSON + AST runtime + x64 build smoke gecti.
- `tests/probes/operator_stage2_probe.bas` ile parser/AST/native tarafinda `|>`, `?:`, prefix/postfix `++/--`, sembolik `|` ve `&&/||` genislemesi dogrulandi.
- `tests/probes/operator_stage2_probe.bas` artik MIR `--execmem --interpreter-backend MIR` modunda da tam cikti veriyor: `-1`, `-1`, `7`, `22`, `11`, `7`, `5`, `6`, `7`, `7`.
- `tests/probes/operator_logic_bridge_probe.bas` AST/MIR/native olarak `&`, `&&`, `||` mantik koprusu icin tekrar gecti.
- Parser expression zinciri assignment precedence katmani ile genislendi; field compound assignment (`p.x += 2`) parse lane'i acildi.
- `AND/OR` keyword'leri logical short-circuit lane'ine, `&/|` sembolleri bitwise lane'ine ayrildi (parser/semantic/runtime/MIR/x64).
- `tests/probes/operator_keyword_logic_probe.bas` AST/MIR/native olarak `0`, `0`, `-1`, `0`, `2`, `5`, `-1`, `-1` ciktilariyla gecti.
- Parser tarafinda `FIELD_EXPR = ...` yuzeyi `ASSIGN_STMT` olarak normalize edilmeye baslandi; `p.x = 10` ve `b.x = 33` satirlari artik expression-no-op yerine gercek assignment lane'ine iniyor.
- `tests/probes/type_class_field_probe.bas` AST runtime olarak `10`, `15`, `33` cikti verdi.
- MIR lowering tarafinda `FIELD_EXPR` path (load/store/incdec) lane'i eklendi; field lhs artik MIR'de `assign lhs must be ident...` hatasina dusmuyor.
- `tests/probes/type_class_field_mutation_probe.bas` AST/MIR/native olarak `12`, `40` ciktilariyla field `+=` parity smoke'i verdi.
- `tests/probes/native_type_field_single_probe.bas` native x64 exe olarak `10` verdi.
- `tests/probes/native_class_field_single_probe.bas` native x64 exe olarak `33` verdi.
- AST runtime tarafinda `FIELD_EXPR` read/write ve field-target `ASSIGN_STMT` / `INCDEC` destegi eklendi.
- x64 codegen tarafinda temel `FIELD_EXPR` load/store emit yolu eklendi; `TYPE` icin by-address, `CLASS` icin pointer-deref lane'i temel smoke ile dogrulandi.
- `tests/run_console_state_exec_ast.exe`, `tests/run_jump_exec_ast.exe`, `tests/run_print_exec_ast.exe` yeniden gecti; console/jump/print satirlari icin test kaniti tazelendi.
- Native `LABEL_STMT`, `GOTO_STMT`, `GOSUB_STMT` emit yolu da eklendi; `13_uxb_commands_operators_types.bas` asm'inde artik `call __uxb_label_*` ve `jmp __uxb_label_*` cikiyor.
- `src/main_64.exe` ile native build smoke:
  - `tests/basicCodeTests/6.bas` -> `out_do_native/program.exe`
  - `tests/basicCodeTests/21_matrix_flow_if_select_exitif.bas` -> `out_select_native/program.exe`
  - gercek ciktilar: `15 25 35 0` ve `if-enter` / `case-gt10`
- Yarim kalan ana isler:
- native file I/O lane runtime parity: relative path, gorunur cikti ve hata/return davranisini derinlestirmek
- arrays ve `TYPE/CLASS` icin native lane'i buyutmek
- native print/string parity ve `13.bas` tam davranis dogrulamasi
- operator tablosunun kalan buyuk kisimlari: aggregate `TYPE/CLASS` field parity, ternary/pipe/incdec icin daha genis semantics ve x64 parity
  - `mir_exporter_json` altina opcode exporter yuzeyini de toplamak
- Hemen sonraki dogal adim:
  1. file I/O/array coverage'ini genisletmek
  2. native print/string parity'sini sertlestirmek
  3. ardindan `TYPE/CLASS` native parity'sine gecmek
- coverage ve plan bundan sonra rapordaki dogal siraya gore izlenecek:
  1. `memory_exec` split
  2. `mir.fbs` split
  3. `code_generator.fbs` split
  4. native x64 coverage sprint

## 3. Katman Bazli Kirmizilar

### Parser

- Member access expression siniri: `member access expression unsupported; expected call`.
- Event/pipe/thread/paralel grammar parser MVP olarak eklendi; AST runtime slot manager MVP var, semantic/MIR/codegen henuz yok.
- Pipe operator `|` parser ve AST runtime MVP olarak eklendi, MIR/codegen henuz yok.

### Semantic / MIR

- `mir: unsupported binary op`.
- `mir: unsupported expr kind`.
- `mir: unsupported assign op`.
- `src/semantic/mir.fbs` halen tek parca ve yaklasik `3083` satir.
- model/opcode/declaration bloğu [mir_model.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_model.fbs) dosyasina ayrilarak ilk split baslatildi.
- evaluator/value-engine bloğu [mir_evaluator.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_evaluator.fbs) dosyasina ayrildi.
- pipeline exporter bloğu [mir_exporter_json.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_exporter_json.fbs) dosyasina ayrildi.
- Yarim kalan MIR split:
  - `mir_lowering_expr`
  - `mir_lowering_stmt`
  - opcode exporter yuzeyini `mir_exporter_json` altina toplamak
- Interface method implementation hatalari mevcut ama native/OOP coverage ile baglanmali.
- MIR tek canonical backend degil.

### Runtime

- `memory_exec.fbs` icinde eski MIR placeholder izleri var.
- `src/runtime/memory_exec.fbs` halen yaklasik `1777` satir; split suruyor.
- `DEF FN` user function destegi eksik.
- Bilerek no-op olan scope metadata ile gercek eksik no-op ayrilmali.
- FFI policy report-only davranisi dokumante edilmeli.

### x64 Codegen

- `TODO: unsupported binary op`.
- `TODO: expression kind`.
- `TODO: emit node kind`.
- `unsupported statement in GenerateStatement`.
- `unsupported assignment operator`.
- `src/codegen/x64/code_generator.fbs` halen yaklasik `2674` satir.
- context/global/declaration yüzeyi [cg_context.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/codegen/x64/cg_context.fbs) dosyasina ayrilarak codegen split baslatildi.
- Native akis coverage genisledi:
  - `SELECT CASE` + `CASE IS` + `CASE ELSE`
  - `DO WHILE`, `DO`, `LOOP WHILE`, `LOOP UNTIL`
  - `FOR EACH`, `DO EACH`
  - `LABEL`, `GOTO`, `GOSUB`
  - `EXIT IF`, `EXIT FOR`, `EXIT DO`
- Native math/operator coverage genisledi:
  - `ABS`, `INT`, `FIX`, `SGN`, `VAL`, `ASC`, `RND`
  - `SQR`, `SIN`, `COS`, `TAN`, `ATN`, `EXP`, `LOG`
  - `MOD`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`, `ROL`, `ROR`
- String/PRINT stabilitesi.
- Native file I/O runtime parity kapandi; OOP, collection, advanced control-flow ve print/string parity eksikleri devam ediyor.
- 2026-04-24 gozlemi: `uxbasic_next.exe` ile `3[12]` smoke matrix tekrar temiz gecti.
- 2026-04-25 gozlemi: `operator_stage2_probe.bas` artik MIR runtime'da da tam gecti; onceki ternary block-akisi kopugu kapandi.
- 2026-04-25 gozlemi: `type_class_field_probe.bas` AST exec olarak `10`, `15`, `33` verdi.
- 2026-04-25 gozlemi: `type_class_field_probe.bas` artik MIR ve native x64 lane'de de `10`, `15`, `33` veriyor.
- 2026-04-25 gozlemi: `type_class_field_mutation_probe.bas` AST/MIR/native lane'lerde `12`, `40` verdi.
- 2026-04-25 gozlemi: `operator_keyword_logic_probe.bas` AST/MIR/native lane'lerde `0`, `0`, `-1`, `0`, `2`, `5`, `-1`, `-1` vererek `AND/OR` short-circuit + `&/|` bitwise ayrimini dogruladi.
- 2026-04-25 gozlemi: `native_type_field_single_probe.bas` native exe olarak `10`, `native_class_field_single_probe.bas` native exe olarak `33` verdi.
- 2026-04-25 gozlemi: `native_file_io_probe2.bas` native exe olarak `287454020` yazdi; `native_lof_eof_probe.bas` native exe olarak `4` ve `0` yazdi.
- 2026-04-25 gozlemi: `native_string_builtin_probe.bas` native exe olarak `TXT`, `123`, `AB`, `ab`, `BB`, `min#` yazdi; `tests/basicCodeTests/10.bas` native olarak temel string yuzeyini dogruladi.
- 2026-04-25 gozlemi: `native_ltrim_rtrim_probe.bas` native exe olarak `abc`, `abc`, `1`, `1` yazdi.
- 2026-04-25 gozlemi: `native_timer_randomize_probe.bas` native exe olarak sayisal `RND(1)` ve `TIMER()` ciktilari verdi.
- 2026-04-25 gozlemi: `native_incdec_probe.bas` native exe olarak `10` yazdi.
- 2026-04-25 gozlemi: `native_global_array_probe.bas` AST JSON'da indexed assignment olarak dogrulandi; native x64 exe ciktilari `22`, `27`, `33` oldu.
- 2026-04-25 gozlemi: `runtime_mir_indexed_array_probe.bas` AST `--execmem`, MIR `--execmem --interpreter-backend MIR` ve native x64 exe olarak ayni `22`, `27`, `27`, `33`, `44` ciktilarini verdi.
- AST runtime tarafinda `CALL_EXPR` array access yolu artik gercek element storage'a iniyor; `ASSIGN_STMT` ve `REDIM PRESERVE` ayni storage modelini kullaniyor.
- MIR tarafinda yeni `LOAD_INDEXED` / `STORE_INDEXED` opcode'lari eklendi; `DIM/REDIM` alt/ust bound operand'lari ve preserve flag'i evaluator tarafinda gercek array storage'a baglandi.
- `--emit-x64-nasm` lane tekrar calisiyor; siradaki odak print/string parity, array/type parity ve kalan operator bosluklari.
- Yarim kalan codegen split:
  - driver/final assembly assembly-out yuzeyini ayirmak
  - daha sonra expr/stmt fallback diagnostiklerini ayri modullere tasimak

### Build / Test

- Build report halen hardcoded `partial`.
- Native exe exit code kontrati net degil.
- Test runner katman bazli standart rapor uretmiyor.

## 4. Sprint Sirasi

1. Coverage runner: her `.bas` icin parse/semantic/json/AST/MIR/x64 build/exe run.
2. `memory_exec` split: expr/stmt/call/debug bolumleri.
3. `mir.fbs` split:
   - `mir_model`
   - `mir_evaluator`
   - `mir_exporter_json`
   - siradaki: `mir_lowering_expr`, `mir_lowering_stmt`
4. `code_generator.fbs` split:
   - `cg_context`
   - siradaki: driver/final assembly assembly-out yuzeyi
5. native coverage sprint:
   - `GOTO` / `GOSUB`
   - math/operator parity
   - file I/O
   - arrays
   - `TYPE/CLASS`
6. x64 string/print stabilitesi.
7. x64 assignment + binary operator coverage.
8. CLASS/INTERFACE native baseline.
9. FFI v2: external DLL skip/probe + wrapper library.
10. Event/pipe/thread/paralel slot sistemi semantic/MIR/x64 parity.
11. MIR merkezlilestirme.

## 5. Test Matrix Runner

Ilk otomatik coverage runner eklendi:

```powershell
tests\basicCodeTests\run_basiccodetest_matrix.ps1
```

Urettigi artefactlar:

- `matrix.csv`
- `matrix.json`
- `matrix.md`
- her ornek icin `ast.json`, `inventory.json`, `pipeline.json`
- her ornek icin `semantic.log`, `exec_ast.log`, `exec_mir.log`, `build_x64.log`, opsiyonel `run_x64.log`

Ornek kullanim:

```powershell
.\tests\basicCodeTests\run_basiccodetest_matrix.ps1 -CompilerPath .\build\uxbasic_ffi_gui.exe -SourceGlob '3[12]_*.bas' -OutRoot tests\basicCodeTests\out_matrix_smoke -RunNativeExe
```

Smoke dogrulama:

| SourceGlob | JSON | Semantic | AST | MIR | x64 Build | x64 Run |
|---|---|---|---|---|---|---|
| `3[12]_*.bas` | OK | OK | OK | OK | OK | `RAN_EXIT_10/5` |
| `4[23]_*.bas` | OK | OK | OK | OK | OK | `RAN_EXIT_10/2` |
| `3[12]_*.bas` with `uxbasic_ffiharden.exe` | OK | OK | OK | OK | OK | `RAN_EXIT_10/5` |
| `3[12]_*.bas` with `uxbasic_next.exe` | OK | OK | OK | OK | OK | `RAN_EXIT_10/5` |

Parser-only yeni slot/event probe:

```powershell
.\build\uxbasic_ffi_gui.exe .\tests\probes\slot_event_pipe_parse.bas --ast-json-out build\slot_event_pipe_ast.json --inventory-json-out build\slot_event_pipe_inventory.json --pipeline-json-out build\slot_event_pipe_pipeline.json
```

Dogru AST dugumleri:

- `EVENT_STMT`
- `THREAD_STMT`
- `PARALEL_STMT`
- `PIPE_STMT`
- `SLOT_STMT`
- `SLOT_CONTROL_STMT`
- `TRIGGER_STMT`
- `BINARY` op `|`

AST runtime MVP smoke:

```powershell
.\build\uxbasic_ffi_gui.exe .\tests\probes\slot_event_pipe_parse.bas --execmem
```

Beklenen cikti:

```text
tick
11
```

Not: Native exe'lerde non-zero exit code su an otomatik fail sayilmiyor; generated program son `rax` degerini process exit code olarak birakabiliyor. Bu nedenle runner `RAN_EXIT_N` olarak ayri raporlar.
Runner kendi cikis kodunu artik rapora gore belirler: `FAIL` veya `MISSING` yoksa `0`, aksi halde `1`. Bu, native exe'nin `RAN_EXIT_N` cikis kodunun PowerShell tarafinda yanlis fail gibi gorunmesini engeller.
Build pipeline artik ayni workspace icinde tek global native build slot uzerinden siralanir. Boylece birden fazla `uxbasic --build-x64` sureci ortak `dist`/toolchain artefactlarina ayni anda yazmaz. Paralel testlerde yine farkli output klasorleri onerilir, ama yalanci `FAIL` ureten temel cakisma kapanmistir.

Paralel smoke dogrulama:

- `31_uxb_windows_kernel_sleep_tick.bas` ve `32_uxb_windows_user32_metrics.bas` iki ayri `--build-x64-out` klasoru ile eszamanli baslatildi.
- Her iki build de `program.exe` uretti.
- Uretilen exe'ler sirayla calistirilinca beklenen DLL ciktilarini verdi.
