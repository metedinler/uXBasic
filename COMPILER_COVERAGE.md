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
| Akis | `SELECT CASE` | OK | OK | OK | OK | OK | OK | OK | `21_matrix_flow_if_select_exitif.bas` AST/MIR/native ciktilari hizalandi; MIR `EXIT IF` lowering artik IF sonuna `JMP` uretiyor ve `if-unreach` yolu kapanmis durumda |
| Akis | `FOR/NEXT` | OK | OK | OK | OK | PARTIAL | OK | OK | STEP/parity genisletilecek |
| Akis | `DO/LOOP` | OK | OK | OK | OK | PARTIAL | OK | OK | `6.bas` AST/MIR/native smoke gecti; native loop parity daha fazla kombinasyonla derinlestirilecek |
| Akis | `FOR EACH`, `DO EACH` | OK | OK | OK | OK | OK | OK | OK | `23_matrix_each_loops.bas` AST/MIR/native smoke gecti; `each=63` ve `doeach=15` degerleri backendler arasi tutarli (native satir kirilimi `PRINT` parity satirinda izleniyor) |
| Akis | `GOTO/GOSUB/RETURN` | OK | OK | OK | OK | OK | OK | OK | `run_jump_exec_ast.exe` PASS + `13_uxb_commands_operators_types.bas` AST/MIR/native build-run zincirinde `GOSUB -> RETURN -> GOTO` akisi dogrulandi |
| Tanim | `CONST/DIM/REDIM` | OK | OK | OK | OK | PARTIAL | OK | OK | AST runtime + MIR runtime indexed assignment/load ve `REDIM PRESERVE` probe'u gecti; native x64 hala daha genis array/type parity kapsamasina ihtiyac duyuyor |
| Tanim | `TYPE` | OK | OK | OK | OK | OK | OK | OK | `type_class_field_probe.bas`, `type_class_field_mutation_probe.bas`, `type_class_nested_field_probe.bas` ve `type_class_array_field_probe.bas` AST/MIR/native olarak tekrar dogrulandi; temel field/nested/array parity artik kanitli |
| Tanim | `CLASS/INTERFACE/NEW/DELETE` | OK | OK | OK | OK | OK | OK | OK | MIR user routine/method call zinciri, `NEW -> *_CTOR` ve `DELETE -> *_DTOR` runtime yolu kapatildi. MIR dogrulama: `28_matrix_class_interface.bas`=`42`, `class_constructor_method_runtime.bas`=`25`, `native_class_ctor_probe.bas`=`7`, `native_class_delete_probe.bas`=`9`, `mir_delete_object.bas`=`0` |
| Tanim | `DEFINT/DEFLNG/...` | OK | PARTIAL | OK | OK | metadata-only | OK | DOC-DRIFT | `run_deftype_setstringsize_exec.exe` PASS; belgelerde eski eksik yazilmis olabilir |
| Tanim | `SETSTRINGSIZE` | OK | PARTIAL | OK | OK | metadata-only | OK | DOC-DRIFT | `run_deftype_setstringsize_exec.exe` PASS; native string ABI baglantisi sonraki faz |
| G/C | `PRINT` | OK | OK | OK | OK | PARTIAL | OK | OK | `run_print_exec_ast.exe` PASS, `run_print_zone_exec_mir_64.exe` PASS, `10.bas` native smoke gecti; MIR print separator/zone lane'i kapandi |
| G/C | `INPUT` | OK | OK | OK | OK | OK | OK | OK | `run_input_exec_ast.exe` + `run_input_exec_mir_64.exe` PASS; promptlu `INPUT` ve `INPUT#` MIR runtime parity lane'i kapandi |
| G/C | `OPEN/CLOSE/GET/PUT/SEEK` | OK | OK | OK | OK | OK | OK | OK | `run_file_io_exec_ast.exe` + `run_file_io_exec_mir_64.exe` PASS; native x64 `native_file_io_probe2.bas` ve `native_lof_eof_probe.bas` smoke kaniti mevcut |
| Ekran | `CLS/COLOR/LOCATE` | OK | OK | OK | OK | PARTIAL | OK | DOC-DRIFT | `run_console_state_exec_ast.exe` PASS; native helper gercekligi yine de daha fazla smoke ister |
| Bellek | `POKE*/PEEK*` | OK | OK | OK | OK | OK | OK | OK | MIR runtime lane'i pointer-mirror ile kapandi; x64 codegen lane'i `run_x64_codegen_memory_emit_64.exe` ile dogrulandi |
| Bellek | `MEMCOPY*/MEMFILL*` | OK | OK | OK | OK | OK | OK | OK | MIR runtime lane'i + x64 codegen lane'i `run_x64_codegen_memory_emit_64.exe` ile kapandi (`POKES`/`SETNEWOFFSET` dahil) |
| Yardimci | `INC/DEC` | OK | OK | OK | OK | PARTIAL | OK | DOC-DRIFT | Native scalar smoke gecti; AST/MIR indexed target runtime hazir, parser yuzeyi ayri fazda genisletilecek |
| Rastgele | `RANDOMIZE/RND` | OK | OK | OK | OK | PARTIAL | OK | DOC-DRIFT | Native smoke gecti; tam parity icin determinism ve varyantlar derinlestirilecek |
| Zaman | `TIMER` | OK | OK | OK | OK | PARTIAL | OK | DOC-DRIFT | Native `TIMER()` smoke gecti; `unit` ve `start,end,unit` varyantlari derinlestirilecek |
| Tus | `INKEY/GETKEY` | OK | OK | OK | OK | PARTIAL | PARTIAL | DOC-DRIFT | `INKEY(flags[,state])` ve `GETKEY()` ayrimi aktif; native builtin map artik ayri sembole iniyor, davranis parity genisletilecek |
| Metin | `LEN/MID/UCASE/LCASE/LTRIM/RTRIM/SPACE/STRING` | OK | OK | OK | OK | PARTIAL | OK | DOC-DRIFT | Native `LTRIM/RTRIM` smoke eklendi; core string builtin zinciri genisledi, tam parity icin array/type kombinasyonlari kaldi |
| Sayi | `ABS/INT/FIX/SGN/SQR/SIN/COS/TAN/ATN/EXP/LOG` | OK | OK | OK | OK | PARTIAL | OK | OK | `operator_stage2_probe.bas` AST/native ile `ABS`, `13_uxb_commands_operators_types.bas` native build ile sayi lane'i test kanitina kavustu |
| Operator | Aritmetik `+ - * / MOD` | OK | OK | OK | OK | PARTIAL | OK | OK | `6.bas` AST/MIR/native ve `13_uxb_commands_operators_types.bas` native build ile arithmetic lane test kanitli |
| Operator | Mantiksal/bitwise `AND/OR/XOR/NOT/SHL/SHR/ROL/ROR` | OK | OK | OK | OK | PARTIAL | OK | OK | `AND/OR` keyword lane'i logical short-circuit olarak ayrildi, `&/|` bitwise lane'i korunuyor; `operator_keyword_logic_probe.bas` AST/MIR/native gecti, `operator_stage2_probe.bas` ciktilari backendler arasi hizali |
| Operator | Bilesik atama `+= -= *= /= \=` | OK | OK | OK | OK | OK | OK | PARTIAL | `operator_assign_scalar_only_probe.bas` ve `operator_assign_div_probe.bas` ile scalar `+= -= *= /= \=` AST/MIR/native gecti; `runtime_mir_indexed_array_probe.bas` ile indexed `+=` de dogrulandi |
| Interop | `IMPORT(C/CPP/ASM, file)` | OK | OK | N/A | N/A | OK | OK | OK | Build lane olgun |
| Interop | `INLINE(...) ... END INLINE` | OK | PARTIAL | N/A | N/A | PARTIAL | PARTIAL | OK | Ana emit path'e dokulu degil |
| FFI | `CALL(DLL, ...)` | OK | OK | OK | OK | OK | OK | PARTIAL | Windows smoke gercek calisiyor |
| FFI | mixed arg list `"PTR,STRPTR,..."` | OK | PARTIAL | OK | PARTIAL | OK | OK | PARTIAL | F64/callback/struct eksik |
| API | `CALL(API, ...)` | PARTIAL | PARTIAL | PARTIAL | MISSING | MISSING | PARTIAL | MISSING | Yeni ayri sistem tasarlanacak |
| Event | `EVENT ... END EVENT` | OK | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | Semantic guard + MIR/x64 no-op lane eklendi; AST runtime deterministik slot trigger MVP var |
| Thread | `THREAD ... END THREAD` | OK | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | `THREAT` aliasi kaldirildi; canonical `THREAD` kaldi; semantic guard + MIR/x64 no-op lane eklendi |
| Parallel | `PARALEL ... END PARALEL` | OK | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | `PARALLEL` aliasi kaldirildi; canonical `PARALEL` kaldi; semantic guard + MIR/x64 no-op lane eklendi |
| Pipe | `PIPE ... END PIPE` | OK | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | AST runtime `INPUT`/`OUTPUT` MVP var; semantic guard + MIR/x64 no-op lane eklendi |
| Pipe Operator | `expr | fn` | OK | MISSING | PARTIAL | MISSING | MISSING | PARTIAL | PLANNED | AST runtime pipe trigger MVP var |
| Slot | `SLOT`, `<i8/u8 slotsayisi>` | OK | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | `<U8 ...>` / `<I8 ...>` yuzeyi aktif; semantic guard + MIR/x64 no-op lane eklendi |
| Slot Control | `ON/OFF/TRIGGER` | OK | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | PARTIAL | AST runtime slot manager MVP var; semantic guard + MIR/x64 no-op lane eklendi |

## 2.1 2026-04-24 Izleme Notu

- `layout` tek kaynakli hale getirildi.
- runtime global-state tasimasi `ExecRuntimeContext` altina alindi.
- `memory_exec` icindeki FFI policy/resolver/invoke bloğu [exec_ffi_runtime.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/runtime/exec/exec_ffi_runtime.fbs) dosyasina ayrildi.
- `mir.fbs` icinde model/opcode/declaration bloğu [mir_model.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_model.fbs) dosyasina ayrildi.
- `mir.fbs` icinde pipeline exporter bloğu [mir_exporter_json.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_exporter_json.fbs) dosyasina ayrildi.
- x64 native `CLASS/NEW/DELETE` lane'i yukseltiildi:
  `28_matrix_class_interface.bas` native exe olarak `42`
  `native_class_ctor_probe.bas` native exe olarak `7`
  `native_class_delete_probe.bas` native exe olarak `9`
  routine icinden global store yolu ve destructor/free emit zinciri duzeltildi
- MIR runtime `CLASS/NEW/DELETE` lane'i kapatildi:
  `tests/basicCodeTests/28_matrix_class_interface.bas` MIR olarak `42`
  `tests/oop/class_constructor_method_runtime.bas` MIR olarak `25`
  `tests/probes/native_class_ctor_probe.bas` MIR olarak `7`
  `tests/probes/native_class_delete_probe.bas` MIR olarak `9`
  `tests/oop/mir_delete_object.bas` MIR olarak `0`
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
- `tests/probes/type_class_nested_field_probe.bas` AST/MIR/native olarak `7`, `12`, `10`, `20`, `22`, `24` ciktilariyla nested aggregate (`t.P.X`) ve class-icinde-nested (`c.W.P.X`) parity smoke'i verdi.
- `tests/probes/type_class_array_bridge_probe.bas` AST/MIR/native olarak `10`, `15`, `20`, `20` ciktilariyla scalar array + `TYPE/CLASS` bridge parity smoke'i verdi.
- `tests/probes/type_class_array_field_probe.bas` AST/MIR/native olarak `3`, `12`, `8` ciktilariyla aggregate array + field-chain (`a(0).P.X`) parity smoke'i verdi.
- `tests/probes/operator_assign_scalar_only_probe.bas` AST/MIR/native olarak `13` cikti verdi; scalar `+= -= *= \=` zinciri tekrar dogrulandi.
- `tests/probes/operator_assign_div_probe.bas` AST/MIR/native olarak `5` cikti verdi; scalar `/=` lane'i de tam smoke kanitina kavustu.
- `tests/basicCodeTests/28_matrix_class_interface.bas` AST olarak `42`, native x64 build+run olarak `42` verdi; dotted class/interface method dispatch artik native lane'de de calisiyor.
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
- arrays ve `CLASS/INTERFACE/NEW/DELETE` icin kalan native lane bosluklarini kapatmak
- native print/string parity ve `13.bas` tam davranis dogrulamasi
- operator tablosunun kalan buyuk kisimlari: aggregate `TYPE/CLASS` icin daha genis varyantlar (array/collection ile birlikte), ternary/pipe/incdec icin daha genis semantics ve x64 parity
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
- Event/pipe/thread/paralel grammar parser MVP olarak eklendi; AST runtime slot manager MVP var, semantic guard + MIR/x64 no-op lane artik mevcut (tam runtime parity henuz yok).
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
- 2026-04-25 gozlemi: `type_class_array_field_probe.bas` AST/MIR/native lane'lerde `3`, `12`, `8` vererek daha once dokumanda kalan fail notunu kapatti.
- 2026-04-25 gozlemi: `operator_assign_scalar_only_probe.bas` AST/MIR/native lane'lerde `13` verdi.
- 2026-04-25 gozlemi: `operator_assign_div_probe.bas` AST/MIR/native lane'lerde `5` verdi.
- 2026-04-25 gozlemi: `28_matrix_class_interface.bas` AST lane'de `42`, native x64 build+run lane'inde de `42` verdi; native dotted method dispatch icin `d.Speak()` -> `dog_speak(self)` emit yolu acildi.
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

## 4.1 7 Hamlede Tam Kapanis Plani

Hedef: matriste `PARTIAL`/`MISSING` kalan hucreleri 7 uygulama dalgasinda `OK` seviyesine cekmek.

Hamle 1 - Akis parity (MIR + x64):
- `SELECT CASE`, `FOR EACH/DO EACH`, `GOTO/GOSUB/RETURN` satirlarinda `MIR Runtime` ve `x64 Codegen` kalan `PARTIAL` hucreleri.
- Kriter: `tests/basicCodeTests/21_matrix_flow_if_select_exitif.bas`, `23_matrix_each_loops.bas`, `13_uxb_commands_operators_types.bas` AST/MIR/native ayni davranis.
- Durum: DONE (2026-04-29). `EXIT IF` MIR lowering fix + `SHL/SHR/ROL/ROR` MIR opcode lane ile Hamle 1 smoke zinciri yesile cekildi.

Hamle 2 - I/O parity (MIR + x64):
- `INPUT`, `OPEN/CLOSE/GET/PUT/SEEK`, `PRINT` satirlarinda `MIR Runtime`, `x64 Codegen`, `Tests` kalan `PARTIAL`.
- Kriter: promptlu `INPUT`, file channel varyantlari, print separator davranisi (`;`, `,`, zone) ayni cikti.
- Durum: DONE (2026-04-29). MIR lowering/evaluator tarafinda `INPUT#`, `OPEN/CLOSE/GET/PUT/SEEK`, print separator/zone lane'i kapatildi; `run_input_exec_mir_64.exe`, `run_file_io_exec_mir_64.exe`, `run_print_zone_exec_mir_64.exe` PASS (yeniden kosu ile dogrulandi).

Hamle 3 - Bellek parity (MIR + x64):
- `POKE*/PEEK*`, `MEMCOPY*/MEMFILL*` satirlarinda `MIR Runtime` ve `x64 Codegen`.
- Kriter: width-semantics (`B/W/D`), low/high address overlay, pointer-mirror, bounds/failfast testleri.
- Durum: DONE (2026-04-29). MIR tarafinda `POKES`, `MEMCOPYB/W/D`, `MEMFILLB/W/D`, `SETNEWOFFSET` lane'i + `run_memory_exec_mir_64.exe` PASS; x64 tarafinda ayni lane `run_x64_codegen_memory_emit_64.exe` PASS ile kapatildi.

Hamle 4 - Operator ve sayisal parity:
- `INC/DEC`, aritmetik, mantiksal/bitwise, sayi builtin satirlarinda `x64 Codegen` ve `Tests`.
- Kriter: AST/MIR/native cikti birebir; ternary/pipe/incdec genis probe seti yesil.
- Durum: IN-PROGRESS (2026-04-29). Kickoff olarak `run_x64_codegen_operator_numeric_emit_64.exe` PASS ile operator/sayisal emit regression hattı acildi.
  - Gate entegrasyonu: `run_x64_codegen_operator_numeric_emit` ve `run_x64_codegen_memory_emit` build/run adimlari `tools/run_faz_a_gate.ps1` içine eklendi, gate tarafindan otomatik kosulacak.

Hamle 5 - Metin/ekran/zaman/tus parity:
- `LEN/MID/UCASE/LCASE/LTRIM/RTRIM/SPACE/STRING`, `CLS/COLOR/LOCATE`, `TIMER`, `INKEY/GETKEY` satirlari.
- Kriter: native x64 string/console parity; deterministik smoke + regresyon matrix.

Hamle 6 - Interop/API ve slot-lane gercek runtime:
- `INLINE`, `FFI mixed arg`, `CALL(API,...)`, `EVENT/THREAD/PARALEL/PIPE/SLOT`, `Pipe Operator`.
- Kriter: semantic no-op degil gercek MIR/x64 lane; `expr | fn` ve slot control zinciri AST/MIR/native parity.

Hamle 7 - Docs/Release kilitleme:
- `DOC-DRIFT` kalan tum hucreler, matrix runner policy, release gate.
- Kriter: `PARTIAL/MISSING` hucre kalmayan final matrix + otomatik rapor + release checklist.

## 4.2 Hamle Takip Matrisi

| Hamle | Odak Gruplar | Baslangic Durumu | Hedef Durum | Durum |
|---|---|---|---|---|
| 1 | Akis (`SELECT/FOREACH/GOTO`) | PARTIAL | OK | DONE (2026-04-29) |
| 2 | G/C (`INPUT/PRINT/FILE IO`) | PARTIAL | OK | DONE (2026-04-29) |
| 3 | Bellek (`POKE/PEEK/MEM*`) | PARTIAL/MISSING | OK | DONE (2026-04-29) |
| 4 | Operator + Sayi + INCDEC | PARTIAL | OK | IN-PROGRESS (2026-04-29) |
| 5 | Metin + Ekran + Zaman + Tus | PARTIAL | OK | TODO |
| 6 | Interop/API + Event/Thread/Pipe/Slot | PARTIAL/MISSING | OK | TODO |
| 7 | Docs/Tests/Release Gate | DOC-DRIFT/PARTIAL | OK | TODO |

Not: Her hamle tamamlandiginda yukaridaki satir `TODO -> DONE` guncellenecek ve ana coverage matrisindeki ilgili hucreler ayni committe `OK` olarak isaretlenecek.

## 4.3 yeni hamleler ve plan
hayir anlamadin. tekrar belgeleri ve plani incele.
Mete abi, kod gerçekliğine göre **floating point desteği var ama tam compiler seviyesi değil.**

## Net durum

**AST interpreter tarafı:** iyiye yakın.
`NUMBER` içinde nokta veya `E` varsa `FLOAT` yapıyor. `+ - * /` işlemlerinde taraflardan biri float ise sonucu float üretiyor. `SQR, SIN, COS, TAN, ATN, EXP, LOG, CDBL, CSNG, FIX, VAL, RND, TIMER` runtime’da var.

**MIR evaluator tarafı:** var.
`MIRValue.floatValue As Double` bulunuyor. `FLOAT` tipi taşınıyor. Matematik fonksiyonları MIR’de de desteklenmiş.

**Type system tarafı:** yüzeyde var.
`F32`, `F64`, `F80` builtin type olarak tanınıyor. `type_binding.fbs` içinde size/align/isFloat bilgileri var.

Ama kritik sorun şu:

## x64 native codegen tarafı gerçek float değil

`src/codegen/x64/code_generator.fbs` içinde expression emit hâlâ ağırlıklı olarak **RAX integer register** üzerinden çalışıyor.

Örneğin sayı emit ederken:

```text
mov rax, integer_value
```

Float literal bile `Val(rawNumber)` sonrası `CLng(...)` ile integer’a kırpılıyor.

Yani native tarafta:

```basic
a = 1.5
PRINT a
```

büyük ihtimalle gerçek `1.5` olarak yaşamıyor; integer yola düşüyor.

Matematik helper’larında da durum şu:

```asm
cvtsi2sd xmm0, rcx
call sin/cos/exp/log
cvttsd2si rax, xmm0
```

Yani helper içeride `double` hesaplıyor ama sonucu tekrar **integer’a çevirip RAX ile döndürüyor**.

Bu yüzden native x64 tarafında şu destek **gerçek floating point değil, integerlaştırılmış math helper desteği**:

```text
SQR
SIN
COS
TAN
ATN
EXP
LOG
RND
VAL
FIX
INT
```

## En büyük eksikler

```text
1. Native değişkenlerde F32/F64 storage yok.
2. XMM register tabanlı expression pipeline yok.
3. Float literal doğrudan .data içine double olarak emit edilmiyor.
4. Assignment float slot’a movsd yapmıyor.
5. PRINT float formatlama yok.
6. Function return F64 ABI yok.
7. Parametrelerde F64 Win64 ABI tam yok.
8. Array/TYPE/CLASS field içinde F64 gerçek okuma-yazma eksik.
9. Native VAL atoi kullanıyor; atof/strtod değil.
10. Native RND rand integer döndürüyor; 0–1 arası BASIC tarzı float değil.
```

## FFI tarafı

FFI tarafında `F64` izi var. Hatta `ExecFnArg*CdeclF64` tipleri tanımlanmış. Ama karma/mixed F64 için açıkça şu hata var:

```text
CALL(DLL) mixed F64 native invoke is not supported yet
```

Ayrıca dönüş değeri `Double` olsa bile sonunda `ExecClampI32(rvF64)` ile integer’a kırpılıyor. Yani FFI F64 da **tam double döndüren sistem değil**.

## Sonuç

Floating point desteği şu seviyede:

| Katman                         | Durum                              |
| ------------------------------ | ---------------------------------- |
| Lexer                          | Var                                |
| Parser                         | Var                                |
| Type binding                   | F32/F64/F80 tanıyor                |
| AST runtime                    | Kısmen iyi                         |
| MIR evaluator                  | Kısmen iyi                         |
| x64 codegen                    | Zayıf / integerlaştırılmış         |
| Native FFI F64                 | Kısmi / dönüş integer’a kırpılıyor |
| Gerçek compiler seviyesi float | Henüz yok                          |

## Yapılması gereken

Önce native float mimarisi kurulmalı:

```text
1. Type system: SINGLE/F32, DOUBLE/F64 eşlemesi netleşsin.
2. AST node numeric literal: INTEGER_LITERAL / FLOAT_LITERAL ayrımı yapılsın.
3. x64 expression emitter iki moda ayrılsın:
   - EmitExprToRax integer
   - EmitExprToXmm0 float
4. F64 local/global storage 8 byte double olarak ayrılsın.
5. Float assignment movsd ile yapılsın.
6. Float arithmetic addsd/subsd/mulsd/divsd ile yapılsın.
7. Float compare ucomisd + setcc ile yapılsın.
8. PRINT float için printf("%g") veya benzeri helper eklensin.
9. VAL native atoi değil strtod/atof kullansın.
10. RND 0.0–1.0 arası double döndürsün.
11. F64 function return XMM0 ABI’ye bağlansın.
12. F64 FFI dönüş değeri integer’a kırpılmasın.
```

Kısa hüküm: **Interpreter tarafında float var; native compiler tarafında gerçek float henüz yok.**
Mete abi, kod gerçekliğine göre cevap net:

**7 hamlede bitmez.**
Hamle 4’te floating point düzeltilse bile, hemen `TYPE/CLASS` tarafına geçmek sistemi “varmış gibi gösterir”; ama compiler tam bitmiş olmaz. Çünkü şu anda sorun tek özellik eksikliği değil, **katmanlar arası eşitlik eksikliği**:

```text
Parser başka seviyede,
AST runtime başka seviyede,
MIR başka seviyede,
x64 codegen başka seviyede,
test/coverage belgeleri başka seviyede.
```

## Hamle 4 sonrası durum

Floating point yapılınca şu kapanır:

```text
F32/F64 literal
DOUBLE/SINGLE değişken
XMM register yolu
float arithmetic
float PRINT
float compare
F64 function return
F64 FFI temeli
```

Ama bu yalnızca **sayısal omurgayı** düzeltir. Sonra `TYPE/CLASS` geçilebilir; fakat class’a geçmeden önce şu şart lazım:

```text
integer + float + string + pointer storage aynı type/layout sisteminden okunmalı.
```

Yani Hamle 4’ten sonra doğrudan class’a geçilir ama class hamlesi **tek hamlede bitmez**.

## Kodda görünen büyük eksikler

### 1. `TYPE/CLASS` layout var ama tam yaşam döngüsü yok

Kodda `F32/F64`, `TYPE`, `CLASS` size/align bilgileri var. `NEW_EXPR` için native `calloc` çağrısı da yazılmış. Constructor çağırma denemesi de var.

Ama tam sistem için eksik kalanlar:

```text
TYPE field read/write
CLASS field read/write
nested field access
array field access
class içinde string/float field
method receiver doğruluğu
THIS / ME standardizasyonu
base class field layout
destructor garantisi
DELETE sonrası güvenli sıfırlama
copy/assignment davranışı
```

### 2. x64 codegen hâlâ kırılgan

`code_generator.fbs` içinde hâlâ:

```text
TODO: unsupported binary op
TODO: expression kind
metadata-only for x64 emit
unsupported statement
```

var. Yani parser’ın tanıdığı her şey native exe’ye dönüşmüyor.

Hatta test çıktısında `13_uxb_commands_operators_types.bas` için durum şu:

```text
JSON OK
Semantic OK
AST OK
MIR FAIL
x64 Build FAIL
x64 Run SKIP
```

Bu çok önemli. Demek ki temel komut/operator/type testinde bile MIR ve x64 tamamen kapanmamış.

### 3. Class/interpreter tarafı x64’ten ileride

Runtime tarafında class constructor/destructor kayıtları var:

```text
CLASS_METHOD_DECL
CLASS_CONSTRUCTOR_DECL
CLASS_DESTRUCTOR_DECL
```

Semantic tarafında da override/interface kontrolleri var:

```text
OVERRIDE requires base class
signature mismatch
implements unknown interface
```

Ama bu kontrollerin olması, native compiler’ın tam class ürettiği anlamına gelmiyor. Şu anda class sistemi **AST/MIR/runtime tarafında daha ileri, x64 tarafında daha sınırlı**.

## 7 hamle neden yetmez?

Çünkü mevcut 7 hamle muhtemelen “özellik başlıklarına” göre yapılmış. Ama compiler bitirmek için başlık yetmez; her özellik şu 7 katmanda geçmeli:

```text
1. Lexer/parser
2. Semantic
3. AST runtime
4. MIR lowering
5. MIR evaluator
6. x64 build
7. x64 run output parity
```

Bir özellik `parser OK` ise bitmiş sayılmaz.
Bir özellik `AST OK` ise de bitmiş sayılmaz.
**Native x64 aynı sonucu vermeden compiler bitmiş sayılmaz.**

## Revize hamle planı

Ben Hamle 4 sonrasını şöyle değiştirirdim.

### Hamle 4 — Floating point omurgası

Bu hamle doğru. Ama kapsamı net olmalı:

```text
F32/F64 type canonicalization
float literal ayrımı
EmitExprToXmm0
int-float conversion
addsd/subsd/mulsd/divsd
ucomisd compare
float local/global storage
PRINT float
VAL/STR/CDbl/CSng
F64 function return
F64 FFI temel ABI
```

Bu tamamlanmadan class’a geçilirse class içindeki float field’lar bozuk kalır.

---

### Hamle 5 — TYPE sistemi

Class’tan önce `TYPE` kapatılmalı.

```text
TYPE field layout
field offset
nested field
array field
TYPE variable storage
TYPE assignment
TYPE field read/write
TYPE içinde I32/I64/F64/STRING/PTR
x64 field load/store
```

Neden önce TYPE? Çünkü class field layout da TYPE mantığının üstüne kurulacak.

---

### Hamle 6 — CLASS minimum gerçek nesne sistemi

Burada hedef OOP gösterisi değil, gerçek object memory olmalı:

```text
CLASS field layout
NEW allocation
constructor call
method call
THIS/ME receiver
field read/write
DELETE
destructor call
DELETE sonrası pointer sıfırlama
class variable assignment
class pointer/null kontrolü
```

Bu hamlede inheritance/interface değil, **tek sınıf + field + method + ctor/dtor** sağlamlaştırılmalı.

---

### Hamle 7 — CLASS genişletme

Mevcut 7 hamle planın burada bitiyorsa yetmez; çünkü bu ayrı hamle ister:

```text
inheritance
base class layout
override
virtual dispatch veya statik override kararı
interface implements doğrulama
method signature parity
base method call
operator overload varsa sınırlama veya erteleme
```

Burada özellikle dikkat: virtual dispatch gerçek vtable istiyorsa büyük iştir. İlk sürümde “compile-time resolved override” yapılabilir, vtable sonraya bırakılabilir.

---

### Hamle 8 — x64 codegen tamamlama / parçalama

Bu zorunlu ek hamle.

`code_generator.fbs` çok büyümüş. Bölünmeli:

```text
x64_expr_int.fbs
x64_expr_float.fbs
x64_stmt_flow.fbs
x64_stmt_io.fbs
x64_stmt_memory.fbs
x64_type_field.fbs
x64_class_object.fbs
x64_call_emit.fbs
x64_ffi_emit.fbs
x64_runtime_helpers.fbs
```

Ama önce testler sabitlenmeli. Yoksa bölme sırasında çalışan yerler de bozulur.

---

### Hamle 9 — AST/MIR/x64 parity test sistemi

Bu hamle olmadan compiler “bitti” denmez.

Her test için şu tablo zorunlu olmalı:

```text
Source | Parse | Semantic | AST | MIR | x64 Build | x64 Run | AST=MIR | MIR=x64
```

Şu an bazı matrislerde x64 run `SKIP`, `MISSING`, `RAN_EXIT_10`, `RAN_EXIT_5` gibi sonuçlar var. Bunlar tek başına başarı değil. Çıktı karşılaştırması yapılmalı.

---

### Hamle 10 — çekirdek BASIC kapanış paketi

Şunlar native tarafta tam kapanmalı:

```text
PRINT / INPUT
IF / ELSEIF / SELECT
FOR / DO / WHILE
EXIT FOR / EXIT DO / EXIT IF
DIM / REDIM / CONST
arrays
SUB / FUNCTION
GOSUB / RETURN
DATA / READ / RESTORE varsa
file IO
string functions
math functions
error diagnostics
```

Bu, gerçek “v1 compiler” eşiği olur.

---

### Hamle 11 — FFI / DLL / INLINE / API ayrımı

Şu an FFI var ama sınırlı. Bunu ayrı hamle yapmak gerekir:

```text
CALL(DLL)
I32/U64/PTR/F64
BYREF
STRPTR
Win64 ABI shadow space
stack alignment
external import plan
INLINE ASM ana emit yoluna bağlama
CALL(API) ayrı tasarım
```

---

### Hamle 12 — ileri özellikleri dondur / sonra aç

Şunları şimdilik “v2” yapardım:

```text
EVENT
THREAD
PARALEL
PIPE
SLOT
advanced collections LIST/DICT/SET
Python/Lua/SWIPL embedding
MPFR/ARB/FLINT entegrasyonu
```

Bunlar güzel ama compiler bitmeden sistemi dağıtır.

## Yeni gerçekçi sonuç

Bence doğru plan şu:

```text
Hamle 4: Floating point
Hamle 5: TYPE layout + field access
Hamle 6: CLASS basic object model
Hamle 7: CLASS ctor/dtor/method/THIS/DELETE
Hamle 8: inheritance/interface/override sınırlı sürüm
Hamle 9: x64 codegen refactor
Hamle 10: AST/MIR/x64 parity test sistemi
Hamle 11: çekirdek BASIC kapanış
Hamle 12: FFI/INLINE/API sağlamlaştırma
Hamle 13: advanced özellikleri v2’ye ayırma
```

## Kısa hüküm

**Hamle 4 + class’a geçiş doğru yön.**
Ama **7 hamlede compiler bitmez**. 7 hamlede ancak “güzel görünen prototip compiler” olur.

Gerçek v1 için hedef şu olmalı:

```text
Parser genişliği değil,
AST/MIR/x64 aynı çıktıyı veriyor mu?
```

Bunu sağlarsan uXBasic gerçek compiler olur. Aksi halde parser’ı zengin ama native tarafı kısmi bir sistem olarak kalır.
Mete abi, önceki planın devamı olarak ileri özellikleri böyle sıralardım:

```text
Hamle 14: EVENT sistemi
Hamle 15: THREAD / PARALLEL sistemi
Hamle 16: PIPE / SLOT / SIGNAL sistemi
Hamle 17: LIST / DICT / SET koleksiyonları
Hamle 18: modül, namespace ve paket sistemi
Hamle 19: gelişmiş hata yakalama
Hamle 20: bilimsel matematik çekirdeği
Hamle 21: dış kütüphane köprüleri
Hamle 22: JIT değil, çoklu backend hazırlığı
Hamle 23: IDE / debugger / profiler araçları
Hamle 24: release ve standart kütüphane paketi
```

## Hamle 14 — EVENT sistemi

Bu hamlede `EVENT`, `ON`, `OFF`, `TRIGGER`, event handler ve callback sistemi gerçek hale getirilmeli.

Önce parser’da tanınan event yapıları semantic tabloya bağlanmalı. Her event’in adı, taşıdığı parametreler, handler listesi ve çağrılma sırası netleşmeli. AST runtime, MIR evaluator ve x64 native tarafta aynı davranış oluşmalı.

Minimum hedef:

```text
EVENT Click(x AS INTEGER, y AS INTEGER)
ON Click CALL HandleClick
TRIGGER Click(10, 20)
OFF Click CALL HandleClick
```

Bu hamlede thread yok. Event sistemi önce tek iş parçacıklı ve deterministik çalışmalı.

## Hamle 15 — THREAD / PARALLEL sistemi

Bu hamle event’ten sonra gelmeli. Çünkü paralel çalışma, event/callback olmadan dağılır.

Önce sınırlı thread modeli yapılmalı:

```text
THREAD START Worker()
THREAD JOIN handle
THREAD SLEEP ms
LOCK / UNLOCK
MUTEX
```

`PARALLEL` ise ilk sürümde çok iddialı olmamalı. Şimdilik şu yeterli:

```text
PARALLEL FOR i = 1 TO n
   ...
NEXT
```

Bu hamlede en önemli konu hız değil, güvenliktir:

```text
race condition
shared variable kontrolü
thread-safe print
thread-safe file IO
thread-safe event trigger
```

## Hamle 16 — PIPE / SLOT / SIGNAL sistemi

Bu hamle message-passing altyapısıdır. `THREAD` sonrası gelmesi doğru olur.

Ama ilk sürüm Qt gibi büyük sinyal-slot sistemi olmamalı. Daha sade olmalı:

```text
PIPE p AS INTEGER
SEND p, 123
RECV p, x
```

Sonra slot/signal eklenir:

```text
SIGNAL DataReady(value AS DOUBLE)
SLOT OnDataReady(value AS DOUBLE)
CONNECT DataReady TO OnDataReady
EMIT DataReady(3.14)
```

Bu sistem event’in daha tip güvenli ve modüler hali olur.

## Hamle 17 — LIST / DICT / SET koleksiyonları

Bu hamle standart kütüphane tarafına yakındır ama compiler desteği gerektirir.

Minimum koleksiyonlar:

```text
LIST<T>
DICT<K,V>
SET<T>
QUEUE<T>
STACK<T>
```

İlk sürümde generic sistemi tam açmak yerine sınırlı tipli koleksiyonlar yapılabilir:

```text
LIST OF INTEGER
LIST OF DOUBLE
LIST OF STRING
DICT OF STRING, DOUBLE
```

Burada native memory yönetimi çok önemli:

```text
allocation
resize
copy
delete
destructor çağrısı
string eleman temizliği
class eleman temizliği
```

## Hamle 18 — MODULE / NAMESPACE / paket sistemi

Bu hamle dilin büyümesini düzenler.

Şunlar netleşmeli:

```text
MODULE ... END MODULE
NAMESPACE ... END NAMESPACE
IMPORT
EXPORT
PUBLIC / PRIVATE
ALIAS
INCLUDE
include-once
symbol visibility
```

Bu olmadan büyük projeler karışır. Özellikle FFI, bilimsel kütüphane, GUI ve gömülü hedefler için modül sistemi şart.

## Hamle 19 — gelişmiş hata yakalama

Burada iki seviye var:

Birinci seviye klasik BASIC:

```text
ON ERROR GOTO Handler
RESUME
ERR
ERL
ERROR n
```

İkinci seviye modern yapı:

```text
TRY
   ...
CATCH e
   ...
FINALLY
   ...
END TRY
```

Ben ilk v1.5 için klasik BASIC hata sistemini, v2 için `TRY/CATCH` sistemini öneririm.

## Hamle 20 — bilimsel matematik çekirdeği

Bu senin asıl hedeflerinden biri. Burada standart matematik çok aşılmalı.

Katmanlar:

```text
temel math: sin/cos/log/exp/sqr
istatistik: mean/median/variance/stddev/correlation/regression
lineer cebir: vector/matrix
nümerik çözüm: root finding, integration, interpolation
olasılık dağılımları
FFT
astronomi fonksiyonları
```

Burada compiler içine her şeyi gömmek yanlış olur. Doğru yapı:

```text
uXBasic standard scientific library
+
DLL/so backend
+
native wrapper
```

## Hamle 21 — dış kütüphane köprüleri

Bu hamle uXBasic’i büyütür.

Hedef köprüler:

```text
C ABI
WinAPI
SQLite
BLAS/LAPACK
GSL
MPFR
GMP
OpenBLAS
Python embedding
Lua embedding
SWI-Prolog
```

Ama hepsi aynı anda değil.

Önce:

```text
C ABI + WinAPI + SQLite
```

Sonra:

```text
BLAS/LAPACK + MPFR/GMP
```

En sonra:

```text
Python/Lua/Prolog embedding
```

## Hamle 22 — çoklu backend hazırlığı

Sen JIT istemiyorsun; o yüzden burada JIT yok.

Bu hamlenin amacı şu:

```text
aynı AST/MIR’den farklı hedeflere çıkmak
```

Hedefler:

```text
Windows x64
Linux x64
ARM64
SBC cihazlar
Arduino benzeri mikrodenetleyiciler
WebAssembly
C transpiler
C++ transpiler
```

İlk iş x64 codegen’i backend arayüzüne bağlamak:

```text
backend_emit_program()
backend_emit_function()
backend_emit_expr()
backend_emit_call()
backend_emit_data()
```

## Hamle 23 — IDE / debugger / profiler

Dil büyüdükten sonra araçlar gerekir.

Gerekenler:

```text
syntax highlighter
VS Code extension
basic formatter
linter
step debugger
breakpoint
watch variables
call stack
memory viewer
MIR viewer
AST viewer
native asm viewer
profiler
coverage reporter
```

Bu hamlede compiler çıktısı geliştiriciye okunabilir olmalı.

## Hamle 24 — release ve standart kütüphane paketi

Bu artık ürünleştirme hamlesidir.

Şunlar gerekir:

```text
uxbc.exe
uxbrun.exe
standard library
scientific library
examples
tests
docs
installer
GitHub release
CI pipeline
Windows build artifact
versioning
changelog
```

Burada amaç “benim bilgisayarımda çalışıyor” değil:

```text
indir → kur → örnek çalıştır → exe üret
```

## En doğru genel sıra

Tam liste şöyle olur:

```text
Hamle 4  : Floating point
Hamle 5  : TYPE layout + field access
Hamle 6  : CLASS basic object model
Hamle 7  : CLASS ctor/dtor/method/THIS/DELETE
Hamle 8  : inheritance/interface/override
Hamle 9  : x64 codegen refactor
Hamle 10 : AST/MIR/x64 parity test sistemi
Hamle 11 : çekirdek BASIC kapanış
Hamle 12 : FFI/INLINE/API sağlamlaştırma
Hamle 13 : ileri özellikleri v2’ye ayırma

Hamle 14 : EVENT sistemi
Hamle 15 : THREAD / PARALLEL
Hamle 16 : PIPE / SLOT / SIGNAL
Hamle 17 : LIST / DICT / SET
Hamle 18 : MODULE / NAMESPACE / paket sistemi
Hamle 19 : gelişmiş hata yakalama
Hamle 20 : bilimsel matematik çekirdeği
Hamle 21 : dış kütüphane köprüleri
Hamle 22 : çoklu backend hazırlığı
Hamle 23 : IDE / debugger / profiler
Hamle 24 : release / stdlib / installer
```

Kısa hüküm: **compiler gerçek v1 için Hamle 11–12 civarı kapanır; güçlü dil ve ürün haline gelmesi Hamle 20–24 arasıdır.**
Mete abi, aşağıdaki metni diğer yapay zekâya **aynen görev talimatı** olarak verebilirsin.

---

# uXBasic Hamle 4–23 Uygulama Talimatı

Sen bu projede yeni özellik uydurmayacaksın. Önce mevcut kod gerçekliğini okuyacaksın, sonra eksik katmanları tamamlayacaksın.

Repo yapısı şu ana omurgaya sahip:

```text
src/main.bas
src/parser/
src/semantic/
src/runtime/
src/codegen/x64/
src/build/
tests/basicCodeTests/
```

Özellikle şu dosyalar her hamlede okunacak:

```text
src/parser/ast.fbs
src/parser/token_kinds.fbs
src/parser/lexer/
src/parser/parser/

src/semantic/type_binding.fbs
src/semantic/layout.fbs
src/semantic/layout/
src/semantic/mir.fbs
src/semantic/mir_model.fbs
src/semantic/mir_evaluator.fbs
src/semantic/semantic_pass.fbs

src/runtime/memory_exec.fbs
src/runtime/exec/
src/runtime/file_io.fbs
src/runtime/diagnostics.fbs

src/codegen/x64/cg_context.fbs
src/codegen/x64/code_generator.fbs
src/codegen/x64/ffi_call_backend.fbs
src/codegen/x64/inline_backend.fbs
src/codegen/x64/var_mapping.fbs

src/build/x64_build_pipeline.fbs
src/build/interop_manifest.fbs

tests/basicCodeTests/
tests/basicCodeTests/out_matrix_*/matrix.md
tests/basicCodeTests/out_matrix_*/matrix.csv
```

Ana kural şudur:

```text
Parser OK yetmez.
Semantic OK yetmez.
AST runtime OK yetmez.
MIR OK yetmez.
x64 Build OK yetmez.

Bir özellik ancak şu zincirde aynı sonucu verirse tamamdır:

JSON / Semantic / AST / MIR / x64 Build / x64 Run / output parity
```

---

# Önce doldurulacak belgeler

Her hamleden önce ve sonra şu belgeleri üret veya güncelle:

```text
COMPILER_COVERAGE.md
COMPILER_TODO.md
COMPILER_PARITY_MATRIX.md
NATIVE_X64_STATUS.md
MIR_STATUS.md
TYPE_CLASS_STATUS.md
FFI_STATUS.md
ADVANCED_FEATURES_STATUS.md
```

Eğer dosyalar yoksa oluştur.

Her belge şu formatta olacak:

```text
Özellik
Parser durumu
Semantic durumu
AST runtime durumu
MIR lowering durumu
MIR evaluator durumu
x64 codegen durumu
x64 run durumu
Eksik dosyalar
Tamamlanacak fonksiyonlar
Test dosyası
Beklenen çıktı
Gerçek çıktı
Karar: TODO / PARTIAL / OK
```

`OK` yazmak yasaktır; ancak x64 run ve çıktı karşılaştırması geçmişse `OK` yazılabilir.

---

# Hamle 4 — Floating point omurgası

Amaç: `SINGLE`, `DOUBLE`, `F32`, `F64` gerçek çalışsın.

Şu anda interpreter/MIR tarafında float izleri var ama native x64 hâlâ büyük ölçüde integer `RAX` hattına bağlı. Bunu düzelt.

Bakılacak dosyalar:

```text
src/semantic/type_binding.fbs
src/semantic/mir_model.fbs
src/semantic/mir.fbs
src/semantic/mir_evaluator.fbs
src/runtime/memory_exec.fbs
src/codegen/x64/code_generator.fbs
src/codegen/x64/cg_context.fbs
```

Yapılacaklar:

```text
1. Numeric literal ayrımı yap:
   INTEGER_LITERAL
   FLOAT_LITERAL

2. Type binding içinde şunları tekleştir:
   SINGLE = F32
   DOUBLE = F64
   FLOAT = F64 veya açık karar

3. x64 codegen içine iki ayrı expression yolu aç:
   EmitExprToRax     -> integer/pointer/string handle
   EmitExprToXmm0    -> F32/F64

4. Float arithmetic gerçek SSE2 ile yapılacak:
   addsd
   subsd
   mulsd
   divsd

5. Float compare:
   ucomisd
   setcc

6. Local/global F64 storage:
   dq gerçek double saklayacak

7. Assignment:
   integer için mov
   double için movsd

8. PRINT double:
   printf("%g") veya runtime helper

9. VAL:
   atoi değil atof/strtod

10. RND:
   integer rand değil 0.0–1.0 DOUBLE

11. Function return:
   F64 dönüş XMM0 ile olacak

12. FFI F64:
   dönüş değeri integer’a kırpılmayacak
```

Test yaz:

```text
tests/basicCodeTests/44_matrix_float_native.bas
```

İçerik şunları ölçsün:

```basic
DIM a AS DOUBLE
DIM b AS DOUBLE
a = 1.5
b = 2.25
PRINT a + b
PRINT b - a
PRINT a * b
PRINT b / a
PRINT SIN(1.0)
PRINT SQR(9.0)
```

Hamle 4 bitiş şartı:

```text
AST OK
MIR OK
x64 Build OK
x64 Run OK
çıktı aynı
```

---

# Hamle 5 — TYPE layout ve field access

Class’a geçmeden önce `TYPE` bitirilecek. Çünkü class field sistemi TYPE layout üstüne kurulacak.

Bakılacak dosyalar:

```text
src/semantic/layout.fbs
src/semantic/layout/
src/semantic/type_binding.fbs
src/semantic/mir.fbs
src/runtime/exec/exec_class_layout_helpers.fbs
src/codegen/x64/code_generator.fbs
```

Yapılacaklar:

```text
1. TYPE field offset hesabı tek yerde yapılacak.
2. Field size/align kuralları belgelenecek.
3. INTEGER, LONG, DOUBLE, STRING, PTR field desteklenecek.
4. Nested TYPE desteklenecek.
5. TYPE array desteklenecek.
6. x64 field load/store yazılacak.
7. TYPE assignment davranışı netleşecek:
   shallow copy mi?
   byte copy mi?
   string field varsa özel copy mi?
```

Minimum test:

```basic
TYPE Point
    x AS DOUBLE
    y AS DOUBLE
END TYPE

DIM p AS Point
p.x = 1.5
p.y = 2.5
PRINT p.x + p.y
```

Bitiş şartı:

```text
TYPE içindeki INTEGER/F64/STRING field AST, MIR ve x64’te aynı çalışacak.
```
---
Mete abi, tamam. Bundan sonra **GPTmini’ye verilecek iş emri içinde başka model/LLM adı geçmeyecek.** Aşağıdaki metin doğrudan VSCode GPTmini’ye verilecek şekilde yazıldı.

Yüklenen Hamle 5 taslağı fikir olarak doğru ama **sıfırdan `CalculateTypeLayout()` yazdırması yanlış**, çünkü repo içinde zaten `BuildTypeLayoutTable`, `ResolveTypeLayout`, `TypeLayoutSizeOf`, `TypeLayoutResolvePath`, `TypeLayoutOffsetOf` altyapısı var. Ayrıca taslakta `F80 align=16` denmiş; kod gerçekliğinde `F80 size=10 align=8`. 

---

# VSCode GPTmini İş Emri

# uXBasic Hamle 5 — TYPE Layout ve Field Access

Bu görevde sadece **Hamle 5** yapılacak. Yeni özellik icat edilmeyecek. `TYPE` sisteminin mevcut compiler katmanlarında gerçek çalışması sağlanacak.

Amaç:

```text
TYPE değişkenleri doğru size/align ile saklansın.
TYPE field read/write AST, MIR ve x64 native tarafında çalışsın.
Nested TYPE ve array field yolu çözülsün.
F32/F64 field load/store XMM ile yapılsın.
F80 sessizce F64’e düşürülmesin.
String field ayrı ve kontrollü ele alınsın.
```

---

## 0. Kesin kurallar

```text
1. Sıfırdan yeni layout sistemi yazma.
2. CalculateTypeLayout() diye paralel sistem kurma.
3. Mevcut layout altyapısını kullan.
4. FIELD_EXPR node yapısını değiştirme.
5. Parser’a yeni syntax ekleme.
6. F80 align değerini 16 yapma; mevcut kod gerçekliği size=10 align=8.
7. F80’i sessizce F64’e düşürme.
8. Field store’da aynı register’ı hem adres hem değer için kullanma.
9. STRING field’i ilk minimum teste koyma.
10. TYPE tamamlanmadan CLASS’a geçme.
```

---

## 1. Önce okunacak dosyalar

Önce şu dosyaları oku ve mevcut fonksiyonları bozmadan ilerle:

```text
src/semantic/layout.fbs
src/semantic/layout/layout_shared_core.fbs
src/semantic/layout/layout_type_table.fbs
src/semantic/layout/layout_path_common.fbs
src/semantic/layout/layout_path_resolution.fbs
src/semantic/layout/layout_path_and_intrinsic.fbs

src/semantic/type_binding.fbs
src/semantic/mir_model.fbs
src/semantic/mir.fbs
src/semantic/mir_evaluator.fbs
src/semantic/semantic_pass.fbs

src/runtime/memory_exec.fbs
src/runtime/exec/exec_class_layout_helpers.fbs
src/runtime/exec/exec_stmt_memory_core.fbs
src/runtime/exec/exec_state_value_utils.fbs

src/codegen/x64/cg_context.fbs
src/codegen/x64/code_generator.fbs
src/codegen/x64/var_mapping.fbs
```

Özellikle `code_generator.fbs` içinde şunları incele:

```text
X64BuildFieldPath
X64EmitLoadFieldExpr
X64EmitStoreFieldExpr
X64FindDeclaredTypeName
X64ComputeDimSlotCount
X64EmitDimStmt
X64EmitAddrOfVar
X64EmitLoadVar
X64EmitStoreVar
X64EmitAssignStmt
X64EmitIncDecStmt
```

---

## 2. Mevcut layout sistemi korunacak

Repo içinde zaten şu yapı var:

```text
TypeLayoutDim
TypeLayoutField
TypeLayoutRecord

BuildTypeLayoutTable(ps)
ResolveTypeLayout(ps, typeName, sizeOut, alignOut, errOut)
TypeLayoutSizeOf(ps, typeName, sizeOut, errOut)
TypeLayoutOffsetOf(ps, typeName, pathText, offsetOut, errOut)
TypeLayoutResolvePath(ps, typeName, pathText, offsetOut, targetTypeOut, targetSizeOut, errOut)
```

Bu yüzden Hamle 5’te yapılacak iş:

```text
Layout sistemi yeniden yazılmayacak.
Mevcut layout sistemi doğrulanacak.
x64 field access tarafı tamamlanacak.
AST/MIR/native parity testleri eklenecek.
```

---

## 3. Hamle 5 alt hedefleri

Hamle 5 şu alt aşamalara bölünecek:

```text
5A — Layout doğrulama
5B — TYPE değişken storage doğrulama
5C — Field address helper
5D — Integer field load/store
5E — F32/F64 field load/store
5F — Nested TYPE path
5G — TYPE içi array field
5H — Runtime / MIR parity
5I — String field kontrollü ikinci aşama
5J — Coverage ve matrix güncelleme
```

Bu 10 madde Hamle 5’in ana iş planıdır.

---

# 5A — Layout doğrulama

Mevcut layout fonksiyonlarıyla şu kontroller yapılacak:

```text
I8/U8/BOOLEAN  -> size 1 align 1
I16/U16        -> size 2 align 2
I32/U32/F32    -> size 4 align 4
I64/U64/F64    -> size 8 align 8
F80            -> size 10 align 8
STRING/PTR     -> size 8 align 8
Nested TYPE    -> kendi size/align değerinden gelecek
Array field    -> elemStride * elemCount
```

Yeni kod yazmadan önce test amaçlı küçük debug/diagnostic eklenebilir ama kalıcı şekilde gürültü üretmeyecek.

Beklenen layout örneği:

```basic
TYPE Point
    x AS F64
    y AS F64
    z AS F32
    i AS I32
END TYPE
```

Beklenen yaklaşık:

```text
x offset 0  size 8
y offset 8  size 8
z offset 16 size 4
i offset 20 size 4
total size 24
align 8
```

---

# 5B — TYPE değişken storage

`X64ComputeDimSlotCount(ps, declNode)` kontrol edilecek.

Hedef:

```basic
DIM p AS Point
```

için `p` değişkenine yalnızca 8 byte pointer slot değil, `Point` size kadar alan ayrılmalı.

Doğru mantık:

```freebasic
Private Function X64ComputeTypeSlotCount( _
    ByRef ps As ParseState, _
    ByRef typeName As String _
) As Integer

    Dim typeSize As Integer
    Dim layoutErr As String

    If TypeLayoutSizeOf(ps, typeName, typeSize, layoutErr) = 0 Then
        Return 1
    End If

    If typeSize <= 0 Then Return 1

    Return (typeSize + 7) \ 8
End Function
```

`X64ComputeDimSlotCount` içinde `TYPE_REF` bulunduğunda:

```freebasic
If typeNode <> -1 Then
    Dim typeName As String
    typeName = X64Upper(Trim(ps.ast.nodes(typeNode).value))

    Dim typeSize As Integer
    Dim layoutErr As String

    If TypeLayoutSizeOf(ps, typeName, typeSize, layoutErr) <> 0 Then
        elemSlots = (typeSize + 7) \ 8
        If elemSlots < 1 Then elemSlots = 1
    Else
        elemSlots = 1
    End If
End If
```

Array DIM varsa:

```text
slotCount = elemSlots * arrayElementCount
```

Bu mevcut mantıkla uyumlu olmalı.

---

# 5C — Field info ve address helper

Field load/store içinde aynı kod tekrar etmesin. Önce ortak resolver yaz.

## Yeni helper: `X64ResolveFieldInfo`

```freebasic
Private Function X64ResolveFieldInfo( _
    ByRef ps As ParseState, _
    ByVal fieldNode As Integer, _
    ByRef rootNameOut As String, _
    ByRef pathTextOut As String, _
    ByRef rootNodeOut As Integer, _
    ByRef rootTypeOut As String, _
    ByRef fieldOffsetOut As Integer, _
    ByRef fieldTypeOut As String, _
    ByRef fieldSizeOut As Integer, _
    ByRef errText As String _
) As Integer

    rootNameOut = ""
    pathTextOut = ""
    rootNodeOut = -1
    rootTypeOut = ""
    fieldOffsetOut = 0
    fieldTypeOut = ""
    fieldSizeOut = 0

    If X64BuildFieldPath(ps, fieldNode, rootNameOut, pathTextOut, rootNodeOut) = 0 Then
        errText = "x64-codegen: invalid field expression"
        Return 0
    End If

    If X64FindDeclaredTypeName(ps, rootNameOut, rootTypeOut) = 0 Then
        errText = "x64-codegen: field root type missing for " & rootNameOut
        Return 0
    End If

    Dim layoutErr As String
    If TypeLayoutResolvePath(ps, rootTypeOut, pathTextOut, fieldOffsetOut, fieldTypeOut, fieldSizeOut, layoutErr) = 0 Then
        errText = "x64-codegen: field resolve failed: " & layoutErr
        Return 0
    End If

    fieldTypeOut = X64Upper(Trim(fieldTypeOut))
    Return 1
End Function
```

---

## Yeni helper: `X64EmitAddrOfFieldExpr`

Bu fonksiyonun görevi:

```text
RAX = field adresi
fieldTypeOut = field tipi
fieldSizeOut = field size
```

İskelet:

```freebasic
Private Function X64EmitAddrOfFieldExpr( _
    ByRef ps As ParseState, _
    ByVal fieldNode As Integer, _
    ByRef cg As X64CodegenContext, _
    ByRef fieldTypeOut As String, _
    ByRef fieldSizeOut As Integer, _
    ByRef errText As String _
) As Integer

    Dim rootName As String
    Dim pathText As String
    Dim rootNode As Integer
    Dim rootType As String
    Dim fieldOffset As Integer

    If X64ResolveFieldInfo(ps, fieldNode, rootName, pathText, rootNode, rootType, fieldOffset, fieldTypeOut, fieldSizeOut, errText) = 0 Then
        Return 0
    End If

    Dim indexedRootName As String
    Dim indexedRootExpr As Integer
    Dim isIndexedRoot As Integer
    isIndexedRoot = X64TryExtractIndexedTarget(ps, rootNode, indexedRootName, indexedRootExpr)

    If isIndexedRoot <> 0 Then
        Dim elemSize As Integer
        Dim elemSlots As Integer
        Dim strideBytes As Integer
        Dim elemLayoutErr As String

        If TypeLayoutSizeOf(ps, rootType, elemSize, elemLayoutErr) = 0 Then
            errText = "x64-codegen: indexed field element layout missing: " & elemLayoutErr
            Return 0
        End If

        elemSlots = (elemSize + 7) \ 8
        If elemSlots < 1 Then elemSlots = 1
        strideBytes = elemSlots * 8

        If cg.currentRoutineLabel <> "" Then
            If X64EmitAddrOfIndexedLocal(ps, cg, indexedRootName, indexedRootExpr, strideBytes, errText) <> 0 Then
                ' RAX ok
            ElseIf X64EmitAddrOfIndexedGlobal(ps, cg, indexedRootName, indexedRootExpr, strideBytes, errText) = 0 Then
                errText = "x64-codegen: indexed field root currently supports DIM arrays"
                Return 0
            End If
        Else
            If X64EmitAddrOfIndexedGlobal(ps, cg, indexedRootName, indexedRootExpr, strideBytes, errText) = 0 Then
                errText = "x64-codegen: indexed field root currently supports DIM arrays"
                Return 0
            End If
        End If

    Else
        If rootType = "OBJECT" Or X64FindClassDeclNode(ps, rootType) <> -1 Then
            X64EmitLoadVar cg, rootName
        Else
            If X64EmitAddrOfVar(cg, rootName, errText) = 0 Then Return 0
        End If
    End If

    If fieldOffset <> 0 Then
        X64EmitText cg, "    add rax, " & X64ToStr(fieldOffset)
    End If

    Return 1
End Function
```

Not: Bu helper mevcut `X64EmitLoadFieldExpr` ve `X64EmitStoreFieldExpr` içindeki tekrarları azaltır.

---

# 5D — Integer field load/store

`X64EmitLoadFieldExpr` sadeleşmeli.

```freebasic
Private Function X64EmitLoadFieldExpr( _
    ByRef ps As ParseState, _
    ByVal nodeIdx As Integer, _
    ByRef cg As X64CodegenContext, _
    ByRef errText As String _
) As Integer

    Dim fieldType As String
    Dim fieldSize As Integer

    If X64EmitAddrOfFieldExpr(ps, nodeIdx, cg, fieldType, fieldSize, errText) = 0 Then
        Return 0
    End If

    Dim fk As Integer
    fk = X64TypeToFloatKind(fieldType)

    If fk = UX_FLOAT_F32 Then
        X64EmitText cg, "    movss xmm0, [rax]"
        Return 1
    ElseIf fk = UX_FLOAT_F64 Then
        X64EmitText cg, "    movsd xmm0, [rax]"
        Return 1
    ElseIf fk = UX_FLOAT_F80 Then
        errText = "x64-codegen: F80 field load is not implemented in x64 backend yet"
        Return 0
    End If

    If fieldSize = 1 Then
        X64EmitText cg, "    movsx rax, byte [rax]"
    ElseIf fieldSize = 2 Then
        X64EmitText cg, "    movsx rax, word [rax]"
    ElseIf fieldSize = 4 Then
        X64EmitText cg, "    movsxd rax, dword [rax]"
    ElseIf fieldSize = 8 Then
        X64EmitText cg, "    mov rax, [rax]"
    Else
        errText = "x64-codegen: unsupported field load size " & X64ToStr(fieldSize)
        Return 0
    End If

    Return 1
End Function
```

---

## Integer store’da register kuralı

Yanlış:

```asm
mov [rax], rax
```

Doğru:

```asm
; değer rdx'te
; adres rax'te
mov [rax], rdx
```

`X64EmitStoreFieldExpr` integer için değer `rdx`’e alınmalı, sonra adres hesaplanmalı.

```freebasic
Private Function X64EmitStoreIntegerFieldExpr( _
    ByRef ps As ParseState, _
    ByVal fieldNode As Integer, _
    ByRef cg As X64CodegenContext, _
    ByVal fieldSize As Integer, _
    ByRef errText As String _
) As Integer

    ' Buraya gelmeden önce RDX değer olarak hazırlanmış varsayılır.
    ' RAX ise X64EmitAddrOfFieldExpr tarafından field address olacak.

    If fieldSize = 1 Then
        X64EmitText cg, "    mov byte [rax], dl"
    ElseIf fieldSize = 2 Then
        X64EmitText cg, "    mov word [rax], dx"
    ElseIf fieldSize = 4 Then
        X64EmitText cg, "    mov dword [rax], edx"
    ElseIf fieldSize = 8 Then
        X64EmitText cg, "    mov [rax], rdx"
    Else
        errText = "x64-codegen: unsupported field store size " & X64ToStr(fieldSize)
        Return 0
    End If

    X64EmitText cg, "    mov rax, rdx"
    Return 1
End Function
```

---

# 5E — F32/F64 field store

Field assignment özel ele alınmalı. Çünkü float değer `xmm0` içinde olur; integer değer `rax/rdx` içinde olur.

`X64EmitAssignStmt` içinde şu sırayı uygula:

```text
lhs FIELD_EXPR ise:
  field type çöz.
  Eğer F32/F64 ise:
      rhs -> XMM0
      field address -> RAX
      movss/movsd [rax], xmm0
      return
  Eğer F80 ise:
      diagnostic
  Değilse:
      rhs -> RAX
      mov rdx, rax
      field address -> RAX
      integer store
```

İskelet:

```freebasic
Private Function X64EmitStoreFieldFromRhs( _
    ByRef ps As ParseState, _
    ByVal fieldNode As Integer, _
    ByVal rhsNode As Integer, _
    ByRef cg As X64CodegenContext, _
    ByRef errText As String _
) As Integer

    Dim rootName As String
    Dim pathText As String
    Dim rootNode As Integer
    Dim rootType As String
    Dim fieldOffset As Integer
    Dim fieldType As String
    Dim fieldSize As Integer

    If X64ResolveFieldInfo(ps, fieldNode, rootName, pathText, rootNode, rootType, fieldOffset, fieldType, fieldSize, errText) = 0 Then
        Return 0
    End If

    Dim fk As Integer
    fk = X64TypeToFloatKind(fieldType)

    If fk = UX_FLOAT_F32 OrElse fk = UX_FLOAT_F64 Then
        If X64EmitExprToXmm0(ps, rhsNode, cg, fk, errText) = 0 Then Return 0

        Dim addrFieldType As String
        Dim addrFieldSize As Integer
        If X64EmitAddrOfFieldExpr(ps, fieldNode, cg, addrFieldType, addrFieldSize, errText) = 0 Then Return 0

        If fk = UX_FLOAT_F32 Then
            X64EmitText cg, "    movss [rax], xmm0"
        Else
            X64EmitText cg, "    movsd [rax], xmm0"
        End If

        Return 1

    ElseIf fk = UX_FLOAT_F80 Then
        errText = "x64-codegen: F80 field store is not implemented in x64 backend yet"
        Return 0
    End If

    If X64EmitExprToRax(ps, rhsNode, cg, errText) = 0 Then Return 0
    X64EmitText cg, "    mov rdx, rax"

    Dim addrType As String
    Dim addrSize As Integer
    If X64EmitAddrOfFieldExpr(ps, fieldNode, cg, addrType, addrSize, errText) = 0 Then Return 0

    Return X64EmitStoreIntegerFieldExpr(ps, fieldNode, cg, fieldSize, errText)
End Function
```

Sonra `X64EmitAssignStmt` içinde ilk `=` assignment kısmı şöyle değişsin:

```freebasic
If opText = "=" Or opText = "" Then
    If lhsKind = "FIELD_EXPR" Then
        Return X64EmitStoreFieldFromRhs(ps, lhs, rhs, cg, errText)
    End If

    ' Eski indexed ve identifier yolu aynen devam
End If
```

---

# 5F — Nested TYPE path

Nested path için yeni layout yazma. Mevcut `TypeLayoutResolvePath` bunu çözmeli.

Test:

```basic
TYPE Point
    x AS F64
    y AS F64
END TYPE

TYPE Box
    p AS Point
    id AS I32
END TYPE

DIM b AS Box
b.p.x = 1.25
b.p.y = 2.75
b.id = 9

PRINT b.p.x + b.p.y
PRINT b.id
END
```

Beklenen:

```text
4
9
```

Bu test geçmeden CLASS field’a geçme.

---

# 5G — TYPE içi array field

Mevcut layout path parser indeksli field path destekliyor. Şu test hazırlanacak:

```basic
TYPE Row
    a(0 TO 2) AS I32
END TYPE

DIM r AS Row
r.a(0) = 3
r.a(1) = 4
r.a(2) = 5

PRINT r.a(0) + r.a(1) + r.a(2)
END
```

Beklenen:

```text
12
```

Burada önemli olan:

```text
TypeLayoutResolvePath("Row", "a(0)")
TypeLayoutResolvePath("Row", "a(1)")
TypeLayoutResolvePath("Row", "a(2)")
```

doğru offset dönmeli.

---

# 5H — Runtime ve MIR parity

Sadece x64 düzeltmek yetmez. Aşağıdaki katmanlar kontrol edilecek:

```text
AST runtime:
TYPE field assignment ve field read doğru mu?

MIR lowering:
FIELD_LOAD / FIELD_STORE benzeri temsil var mı?
Yoksa mevcut MIR’de field access nasıl taşınıyor?

MIR evaluator:
TYPE field değerlerini doğru okuyup yazıyor mu?

x64:
Aynı output’u veriyor mu?
```

Eğer MIR’de özel `FIELD_LOAD/FIELD_STORE` yoksa hemen büyük opcode reformu yapma. Önce mevcut MIR temsilini incele. Gerekirse `MIR_STATUS.md` içine şu notu yaz:

```text
TYPE field access currently represented through existing expression path.
Dedicated FIELD_LOAD/FIELD_STORE opcode planned if lowering becomes ambiguous.
```

Ama native x64 output parity sağlanmadan `OK` yazma.

---

# 5I — String field ikinci aşama

İlk minimum testte `STRING` kullanma.

String field için önce şu sorular cevaplanacak:

```text
STRING field by-value mı?
STRING field pointer/handle mı?
STRING * N fixed buffer destekleniyor mu?
Assignment string copy mi yapıyor, pointer mı saklıyor?
Destructor/cleanup gerekiyor mu?
```

İkinci aşama test:

```basic
TYPE LabelledPoint
    name AS STRING
    x AS F64
END TYPE

DIM p AS LabelledPoint
p.name = "Origin"
p.x = 1.5

PRINT p.name
PRINT p.x
END
```

Bu test ancak string runtime modeli netse `OK` yapılacak. Değilse `PARTIAL` yaz.

---

# 5J — Coverage ve matrix güncelleme

Hamle 5 sonunda şu belgeler güncellenecek veya yoksa oluşturulacak:

```text
TYPE_FIELD_STATUS.md
COMPILER_COVERAGE.md
COMPILER_TODO.md
COMPILER_PARITY_MATRIX.md
NATIVE_X64_STATUS.md
MIR_STATUS.md
yapilanlar.md
```

`TYPE_FIELD_STATUS.md` formatı:

```text
TYPE Layout:
- BuildTypeLayoutTable:
- ResolveTypeLayout:
- TypeLayoutSizeOf:
- TypeLayoutResolvePath:
- F80 size/align:

TYPE Storage:
- DIM scalar TYPE:
- DIM array of TYPE:
- local storage:
- global storage:

Field Load:
- I32:
- I64:
- F32:
- F64:
- F80:
- nested:
- array field:
- string:

Field Store:
- I32:
- I64:
- F32:
- F64:
- F80:
- nested:
- array field:
- string:

Parity:
- AST:
- MIR:
- x64 build:
- x64 run:
- output equality:

Remaining:
```

---

# Test dosyaları

## Test 50 — Minimum numeric TYPE

```text
tests/basicCodeTests/50_type_field_numeric.bas
```

```basic
TYPE Point
    x AS F64
    y AS F64
    z AS F32
    i AS I32
END TYPE

DIM p AS Point

p.x = 1.5
p.y = 2.75
p.z = 3.25
p.i = 7

PRINT p.x + p.y
PRINT p.z
PRINT p.i
END
```

Beklenen:

```text
4.25
3.25
7
```

---

## Test 51 — Nested TYPE

```text
tests/basicCodeTests/51_type_nested_field.bas
```

```basic
TYPE Point
    x AS F64
    y AS F64
END TYPE

TYPE Box
    p AS Point
    id AS I32
END TYPE

DIM b AS Box

b.p.x = 1.25
b.p.y = 2.75
b.id = 9

PRINT b.p.x + b.p.y
PRINT b.id
END
```

Beklenen:

```text
4
9
```

---

## Test 52 — Array field

```text
tests/basicCodeTests/52_type_array_field.bas
```

```basic
TYPE Row
    a(0 TO 2) AS I32
END TYPE

DIM r AS Row

r.a(0) = 3
r.a(1) = 4
r.a(2) = 5

PRINT r.a(0) + r.a(1) + r.a(2)
END
```

Beklenen:

```text
12
```

---

## Test 53 — F80 diagnostic

```text
tests/basicCodeTests/53_type_f80_field_diagnostic.bas
```

```basic
TYPE Precise
    x AS F80
END TYPE

DIM p AS Precise
p.x = 1.25
PRINT p.x
END
```

Beklenen:

```text
Parser OK
Semantic/Layout OK
x64 native açık diagnostic
F80 sessiz F64’e düşmeyecek
```

---

## Test 54 — String field ikinci aşama

```text
tests/basicCodeTests/54_type_string_field_partial.bas
```

```basic
TYPE LabelledPoint
    name AS STRING
    x AS F64
END TYPE

DIM p AS LabelledPoint

p.name = "Origin"
p.x = 1.5

PRINT p.name
PRINT p.x
END
```

Beklenen:

```text
String field modeli netse çalışacak.
Değilse PARTIAL olarak belgelenecek.
```

---

# Hamle 5 başarı şartı

Hamle 5 ancak şu durumda tamam sayılır:

```text
1. Yeni layout sistemi yazılmadı.
2. Mevcut TypeLayoutResolvePath kullanıldı.
3. DIM p AS Type doğru byte/slot storage ayırıyor.
4. Integer field load/store native x64 çalışıyor.
5. F32/F64 field load/store XMM ile çalışıyor.
6. Nested TYPE field çalışıyor.
7. TYPE içi array field çalışıyor.
8. F80 açık diagnostic veriyor.
9. String field durumu dürüstçe OK/PARTIAL olarak yazıldı.
10. AST/MIR/x64 parity matrix güncellendi.
```

---

# Kısa son emir

```text
Önce mevcut layout sistemini oku.
Sonra X64ResolveFieldInfo ve X64EmitAddrOfFieldExpr helper’larını yaz.
Sonra X64EmitLoadFieldExpr’i sadeleştir.
Sonra X64EmitStoreFieldFromRhs ile field assignment’ı düzelt.
Önce I32/F64/F32 testini geçir.
Sonra nested TYPE.
Sonra array field.
En son F80 diagnostic ve string field durumunu belgele.
CLASS’a geçme.
```

Bu metin Hamle 5 için kullanılacak ana iş emridir.

---

# Hamle 6 — CLASS basic object model

Bu hamlede inheritance yok. Sadece tek sınıf gerçek nesne olarak çalışacak.

Bakılacak dosyalar:

```text
src/parser/parser/parser_stmt_decl_class_method.fbs
src/semantic/semantic_pass.fbs
src/runtime/memory_exec.fbs
src/runtime/exec/exec_class_layout_helpers.fbs
src/codegen/x64/code_generator.fbs
```

Yapılacaklar:

```text
1. CLASS field layout TYPE layout ile aynı sisteme bağlanacak.
2. NEW gerçek allocation yapacak.
3. Object pointer değişkende tutulacak.
4. Method call receiver alacak.
5. THIS veya ME tek standarda bağlanacak.
6. Field access:
   obj.x
   THIS.x
   ME.x
7. x64 tarafında object base pointer + field offset load/store yapılacak.
```

Minimum test:

```basic
CLASS Counter
    value AS INTEGER

    SUB Inc()
        THIS.value = THIS.value + 1
    END SUB
END CLASS

DIM c AS Counter
c = NEW Counter
c.Inc()
c.Inc()
PRINT c.value
```

Bitiş şartı:

```text
2 yazacak.
AST/MIR/x64 aynı olacak.
```

---

# Hamle 7 — Constructor, destructor, DELETE

Bu hamle class yaşam döngüsüdür.

Yapılacaklar:

```text
1. Constructor otomatik çağrılacak.
2. Constructor parametresiz sürüm önce yapılacak.
3. Parametreli constructor sonra eklenecek.
4. Destructor DELETE sırasında çağrılacak.
5. DELETE sonrası pointer güvenli şekilde 0 yapılacak.
6. Double DELETE davranışı tanımlanacak:
   hata mı?
   sessiz geçiş mi?
7. String/class field temizliği destructor ile uyumlu olacak.
```

Bakılacak dosyalar:

```text
src/runtime/exec/exec_class_layout_helpers.fbs
src/runtime/memory_exec.fbs
src/semantic/mir.fbs
src/codegen/x64/code_generator.fbs
```

Minimum test:

```basic
CLASS Box
    value AS INTEGER

    CONSTRUCTOR()
        THIS.value = 10
    END CONSTRUCTOR

    DESTRUCTOR()
        PRINT 99
    END DESTRUCTOR
END CLASS

DIM b AS Box
b = NEW Box
PRINT b.value
DELETE b
```

Beklenen:

```text
10
99
```

---

# Hamle 8 — inheritance, interface, override

Bu hamlede vtable’a hemen atlama. Önce statik çözüm yap.

Yapılacaklar:

```text
1. Base class field layout çocuk class başına yerleşecek.
2. Child field offset base sonrası başlayacak.
3. OVERRIDE kontrolü semantic tarafında kesinleşecek.
4. Method signature mismatch hata verecek.
5. Interface implements kontrolü sadece semantic ile başlayacak.
6. Native dispatch ilk sürümde statik olabilir.
7. Gerçek virtual dispatch v2’ye bırakılabilir.
```

Minimum test:

```basic
CLASS Animal
    SUB Speak()
        PRINT 1
    END SUB
END CLASS

CLASS Dog EXTENDS Animal
    OVERRIDE SUB Speak()
        PRINT 2
    END SUB
END CLASS

DIM d AS Dog
d = NEW Dog
d.Speak()
```

Beklenen:

```text
2
```

---

# Hamle 9 — x64 codegen refactor

Bu hamle zorunlu. `src/codegen/x64/code_generator.fbs` çok büyümüş. Yeni özellik eklemeden modülerleştir.

Yeni dosya önerisi:

```text
src/codegen/x64/x64_expr_int.fbs
src/codegen/x64/x64_expr_float.fbs
src/codegen/x64/x64_stmt_flow.fbs
src/codegen/x64/x64_stmt_io.fbs
src/codegen/x64/x64_stmt_memory.fbs
src/codegen/x64/x64_type_field.fbs
src/codegen/x64/x64_class_object.fbs
src/codegen/x64/x64_call_emit.fbs
src/codegen/x64/x64_ffi_emit.fbs
src/codegen/x64/x64_runtime_helpers.fbs
```

Kurallar:

```text
1. Önce testleri çalıştır.
2. Sonra küçük küçük fonksiyon taşı.
3. Her taşıma sonrası matrix test çalıştır.
4. Davranış değiştirme.
5. Refactor sırasında yeni özellik ekleme.
```

---

# Hamle 10 — AST/MIR/x64 parity sistemi

Bu hamle olmadan compiler bitmiş sayılmaz.

Yapılacaklar:

```text
1. tests/basicCodeTests için otomatik matrix runner geliştir.
2. Her testte şu kolonlar olsun:
   JSON
   Semantic
   AST
   MIR
   x64 Build
   x64 Run
   Output AST
   Output MIR
   Output x64
   output x86
   Parity

3. SKIP, MISSING, RAN_EXIT_5, RAN_EXIT_10 başarı sayılmayacak.
4. Başarı sadece beklenen çıktı eşleşirse verilecek.
```

Belge:

```text
COMPILER_PARITY_MATRIX.md
```

---

# Hamle 11 — çekirdek BASIC kapanışı

Bu hamlede advanced özellik yok. Temel BASIC tamamlanacak.

Tamamlanacak başlıklar:

```text
PRINT
INPUT
DIM
CONST
REDIM
IF / ELSEIF / ELSE
SELECT CASE
FOR / NEXT
DO / LOOP
WHILE / WEND
EXIT FOR
EXIT DO
EXIT IF
SUB
FUNCTION
CALL
GOTO
GOSUB
RETURN
DATA / READ / RESTORE
arrays
string functions
math functions
file IO
```

Her biri için şu yapılacak:

```text
Parser var mı?
Semantic var mı?
AST çalışıyor mu?
MIR çalışıyor mu?
x64 çalışıyor mu?
Çıktı aynı mı?
```

---

# Hamle 12 — FFI / INLINE / API sağlamlaştırma

Bakılacak dosyalar:

```text
src/runtime/exec/exec_ffi_runtime.fbs
src/runtime/exec/exec_ffi_x64_invoke_helpers.fbs
src/codegen/x64/ffi_call_backend.fbs
src/codegen/x64/inline_backend.fbs
src/build/interop_manifest.fbs
```

Yapılacaklar:

```text
1. CALL(DLL) signature parser netleşecek.
2. I32, U32, I64, U64, PTR, F64 desteklenecek.
3. BYREF desteklenecek.
4. STRPTR / WSTRPTR ayrımı yapılacak.
5. Win64 ABI:
   RCX, RDX, R8, R9
   XMM0-XMM3
   shadow space 32 byte
   16-byte stack alignment
6. Return:
   integer -> RAX
   double -> XMM0
7. INLINE ASM ana emit akışına bağlanacak.
8. CALL(API) ayrı tasarlanacak, CALL(DLL) ile karıştırılmayacak.
```

---

# Hamle 13 — ileri özellikleri dondurma/etiketleme

Bu hamlede kod yazmaktan çok sınır çizilecek.

Şu özellikler `v2 feature` olarak işaretlenecek:

```text
EVENT
THREAD
PARALLEL
PIPE
SLOT
LIST
DICT
SET
Python embed
Lua embed
SWI-Prolog
MPFR
ARB
FLINT
libcurl
WinHTTP
```

Belge:

```text
ADVANCED_FEATURES_STATUS.md
```

Her biri şu şekilde etiketlenecek:

```text
Parser only
Runtime partial
Native unsupported
Planned
```

---

# Hamle 14 — EVENT sistemi

Önce tek thread içinde deterministic event sistemi kur.

Bakılacak dosyalar:

```text
src/parser/parser/parser_stmt_event_pipe.fbs
src/runtime/exec/exec_slot_manager.fbs
src/runtime/memory_exec.fbs
src/semantic/mir.fbs
```

Yapılacaklar:

```text
1. EVENT declaration semantic tabloya yazılacak.
2. Event parametre listesi tutulacak.
3. ON event handler bağlayacak.
4. OFF handler kaldıracak.
5. TRIGGER handler çağıracak.
6. Handler çağrı sırası deterministic olacak.
7. x64 native için ilk sürümde sınırlı destek veya açık hata verilecek.
```

Minimum test:

```basic
EVENT Alarm(x AS INTEGER)

SUB Handler(x AS INTEGER)
    PRINT x
END SUB

ON Alarm CALL Handler
TRIGGER Alarm(7)
```

Beklenen:

```text
7
```

---

# Hamle 15 — THREAD / PARALLEL

Bunu event’ten önce yapma.

Yapılacaklar:

```text
1. THREAD START
2. THREAD JOIN
3. THREAD SLEEP
4. LOCK / UNLOCK
5. MUTEX
6. Shared variable kuralları
7. Thread-safe PRINT
8. Thread-safe event trigger
```

İlk sürüm:

```text
AST runtime destekli olsun.
x64 native için ya gerçek destek ya da net unsupported diagnostic.
Sessiz no-op yasak.
```

---

# Hamle 16 — PIPE / SLOT / SIGNAL

Bu hamle message passing içindir.

Yapılacaklar:

```text
1. PIPE declaration
2. SEND
3. RECV
4. SIGNAL
5. SLOT
6. CONNECT
7. EMIT
```

İlk sürümde basit queue yeterlidir.

Minimum model:

```basic
PIPE p AS INTEGER
SEND p, 123
RECV p, x
PRINT x
```

---

# Hamle 17 — LIST / DICT / SET

Bakılacak dosyalar:

```text
src/runtime/exec/exec_collections.fbs
src/semantic/type_binding.fbs
src/semantic/layout.fbs
```

Yapılacaklar:

```text
1. LIST OF INTEGER
2. LIST OF DOUBLE
3. LIST OF STRING
4. DICT OF STRING, INTEGER
5. SET OF STRING
6. Add/Get/Remove/Count
7. Destructor/copy kuralları
```

Generic sistemi yoksa sahte generic yazma. İlk sürümde tipli koleksiyonları açık açık uygula.

---

# Hamle 18 — MODULE / NAMESPACE / paket sistemi

Bakılacak dosyalar:

```text
src/parser/parser/parser_stmt_using_alias_semantics.fbs
src/parser/parser/parser_stmt_decl_scope.fbs
src/semantic/semantic_pass.fbs
```

Yapılacaklar:

```text
1. MODULE ... END MODULE
2. NAMESPACE ... END NAMESPACE
3. IMPORT
4. EXPORT
5. PUBLIC / PRIVATE
6. ALIAS
7. INCLUDE
8. include-once
9. symbol visibility
10. name mangling
```

Bu hamle büyük projeler için şarttır. Kesinlikle uxbasic in sonradan gelistirme planlarinda gerekli olan hamledir. ileride bir cok gelistirme .bas wrapper, alias, namespace ve module sistei ile call (dll,..) ve call(api,...) ile yazilip import veya include ile kullanilabilir hale getirilecektir. ayrica meta komutlar ve inline(asm|c|cpp,...) , end inline gibi interop ozellikleri ile gelistirmeler yapilacaktir. bu hamle olmadan bu gelistirmeler cok karisik ve daginik olur. bu hamle ile birlikte gelistirme planlarinda onemli bir adim atilmis olur.

---

# Hamle 19 — gelişmiş hata sistemi

Önce klasik BASIC:
Not : ON komutu bir event olusturma acma komutudur.ERROR UXBASIC HATA SINIFI DIR, BU HATA SINIFININ BIR HATA olustugunda kaldirilan bayragi vardir. bayrak kalktiginda hata var demektir ozaman hatagoto komutu calisir, programci isterse on error gosub da yazabilir, yada on error call ve ya baska bir komut da yazabilir.

yani or error goto lexer ve parserde tum olarak aranmasina gerek yok, on komutunun bir ozelligi olarak anlasilmali.

ayni zamanda off komutuda event kapatir. demekki off error goto | gosub | call veya continiue | exit de yazilabilir


```text
ON ERROR GOTO
RESUME
ERR
ERL
ERROR n
```

Sonra modern yapı:

```text
TRY
CATCH
FINALLY
END TRY
```

Ama kesinlikle gerekli yapilabilirse yazilmali. Önce `ON ERROR` gerçek çalışsın. ardirdan `TRY/CATCH` eklenmeli. (once kontrol et tabi var mi yokmu?)

Bakılacak dosyalar:

```text
src/runtime/diagnostics.fbs
src/runtime/error_format.fbs
src/runtime/error_localization.fbs
src/runtime/memory_exec.fbs
src/semantic/mir_evaluator.fbs
```

---

# Hamle 20 — bilimsel matematik çekirdeği

Bunu compiler içine gömme. Standart kütüphane + DLL köprüsü şeklinde yap.

Katmanlar:

```text
1. temel math
2. istatistik
3. lineer cebir
4. nümerik analiz
5. olasılık dağılımları
6. FFT
7. astronomi
```

Önce native compiler tarafında `DOUBLE` sağlam olmalı. Floating point bitmeden bu hamleye geçme.

---

# Hamle 21 — dış kütüphane köprüleri

Sıra:

```text
1. C ABI
2. WinAPI
3. SQLite
4. BLAS/LAPACK
5. GSL
6. GMP/MPFR
7. ARB/FLINT
8. Python embed
9. Lua embed
10. SWI-Prolog
```

Önce `CALL(DLL)` sağlamlaşacak. Sonra wrapper library yazılacak.

---

# Hamle 22 — çoklu backend hazırlığı

JIT yok. Çoklu backend hazırlığı var.

Yapılacaklar:

```text
1. Backend interface çıkar.
2. x64 backend bu interface’e taşınsın.
3. MIR backend-neutral hale getirilsin.
4. Windows x64 birinci hedef kalsın.
5. Sonra Linux x64, ARM64, C transpiler, C++ transpiler düşünülsün.
```

Fonksiyon arayüzü örneği:

```text
backend_emit_program
backend_emit_function
backend_emit_stmt
backend_emit_expr_int
backend_emit_expr_float
backend_emit_call
backend_emit_data
backend_emit_runtime_helpers
```

---

# Hamle 23 — IDE / debugger / profiler

Compiler stabil olmadan bu hamleye geçme.

Yapılacaklar:

```text
1. VS Code syntax highlighter
2. formatter
3. linter
4. AST viewer
5. MIR viewer
6. native ASM viewer
7. breakpoint
8. step execution
9. watch variables
10. call stack
11. profiler
12. coverage reporter
```

İlk ürün için en gerekli üç araç:

```text
formatter
linter
MIR/ASM viewer
```

---

# Yapay zekâya kesin uyarılar

Şunları yapma:

```text
1. Parser’a yeni keyword ekleyip “tamamlandı” deme.
2. Runtime’da no-op koyup başarı sayma.
3. x64 unsupported iken OK yazma.
4. SKIP testini başarı sayma.
5. MISSING output’u başarı sayma.
6. RAN_EXIT_5 / RAN_EXIT_10 sonucunu başarı sayma.
7. Yeni özellik eklerken eski matrix’i bozma.
8. code_generator.fbs içine sonsuz ekleme yapma; parçala.
9. F64 değeri integer’a kırpma.
10. Class DELETE yapıp destructor çağırmadan geçme.
```

Şunları yap:

```text
1. Her hamlede önce ilgili dosyaları oku.
2. Eksik fonksiyonları listele.
3. Küçük patch yap.
4. Test yaz.
5. AST/MIR/x64 karşılaştır.
6. Belge güncelle.
7. Sonra bir sonraki hamleye geç.
```

---

# En gerçekçi nihai sıra

```text
Hamle 4  : Floating point
Hamle 5  : TYPE layout + field access
Hamle 6  : CLASS basic object model
Hamle 7  : Constructor / destructor / DELETE
Hamle 8  : Inheritance / interface / override
Hamle 9  : x64 codegen refactor
Hamle 10 : AST/MIR/x64 parity matrix
Hamle 11 : çekirdek BASIC kapanışı
Hamle 12 : FFI / INLINE / API
Hamle 13 : ileri özelliklerin dondurulması ve etiketlenmesi
Hamle 14 : EVENT
Hamle 15 : THREAD / PARALLEL
Hamle 16 : PIPE / SLOT / SIGNAL
Hamle 17 : LIST / DICT / SET
Hamle 18 : MODULE / NAMESPACE / paket
Hamle 19 : hata sistemi
Hamle 20 : bilimsel matematik
Hamle 21 : dış kütüphane köprüleri
Hamle 22 : çoklu backend hazırlığı
Hamle 23 : IDE / debugger / profiler
```

Kısa karar:  **“Kod yazmadan önce coverage belgesini değil, kodun çalıştırma zincirini esas al. Bir özellik x64 native çıktı verene kadar bitmiş değildir.”**

Mete abi, haklısın; **F80’i ayrıca yazmak gerekir.** Önce Hamle 24’ü plana ekliyorum, sonra Hamle 4 floating point talimatını **F32/F64/F80 dahil** düzeltiyorum. Aşağıdaki metin diğer AI’ye verilecek net görev metnidir. Önceki belgede de type system tarafında `F32/F64/F80` tanındığı ama x64 native hattının gerçek float olmadığı açıkça belirtilmişti. 

---

# Hamle 24 — Release, Standard Library ve Ürünleştirme

Hamle 24, compiler’ın “benim bilgisayarımda çalışıyor” seviyesinden çıkarılıp indirilebilir, kurulabilir ve test edilebilir ürün haline getirilmesidir.

Bu hamlede hedef şudur:

```text
indir → kur → örnek çalıştır → native exe üret → test et → belge oku
```

## Hamle 24 yapılacaklar

```text
1. uxbc.exe ana compiler olarak paketlenecek.
2. uxbrun.exe varsa runtime/interpreter aracı olarak ayrılacak.
3. standard library klasörü oluşturulacak.
4. scientific library klasörü oluşturulacak.
5. examples/ klasörü düzenlenecek.
6. tests/ klasörü release öncesi gate sistemine bağlanacak.
7. COMPILER_COVERAGE.md son kez güncellenecek.
8. COMPILER_PARITY_MATRIX.md release belgesi olacak.
9. CHANGELOG.md oluşturulacak.
10. VERSION dosyası veya version sabiti eklenecek.
11. Windows için zip release paketi hazırlanacak.
12. GitHub Actions / CI kurulacak.
13. README.md sadeleştirilecek.
14. Kurulum ve ilk program belgesi yazılacak.
15. “known limitations” açık yazılacak.
```

## Hamle 24 klasör önerisi

```text
release/
  uxbc.exe
  uxbrun.exe
  stdlib/
  scilib/
  examples/
  docs/
  tests/
  CHANGELOG.md
  VERSION
  README_FIRST.md
```

## Hamle 24 başarı şartı

```text
Temiz sistemde:
1. release zip indirilecek.
2. hello.bas derlenecek.
3. float_test.bas derlenecek.
4. class_test.bas derlenecek.
5. file_io_test.bas derlenecek.
6. Native exe çalışacak.
7. Beklenen çıktı ile gerçek çıktı aynı olacak.
```

---

# Hamle 4 — Floating Point Omurgası: F32 / F64 / F80

Bu hamlede amaç sadece “DOUBLE çalışıyor gibi olsun” değildir. uXBasic’in sayısal sistemi üç ayrı floating point düzeyini tanımalıdır:

```text
F32  = SINGLE / 32-bit float
F64  = DOUBLE / 64-bit double
F80  = EXTENDED / 80-bit extended precision
```

Mevcut durumda type system tarafında `F32/F64/F80` izleri var; fakat native x64 codegen hâlâ büyük ölçüde integer `RAX` hattına bağlı. Float literal’ların integer’a kırpılması, math helper’ların double hesaplayıp sonucu integer’a çevirmesi ve FFI F64 dönüşlerinin integer’a düşmesi düzeltilmelidir. 

## Temel karar

```text
F32 ve F64 v1 native hedefidir.
F80 v1’de type/layout/storage olarak tanınacak,
ama gerçek aritmetik desteği iki aşamalı yapılacak.
```

Yani:

```text
F32: tam destek
F64: tam destek
F80: önce parser/type/layout/storage + açık diagnostic
     sonra x87 veya runtime helper ile gerçek destek
```

F80’i yok saymak yasak. Ama ilk hamlede F80’i sahte şekilde F64’e düşürmek de yasak. Eğer F80 arithmetic henüz yapılmadıysa compiler açıkça şunu demeli:

```text
F80 arithmetic native x64 backend does not support this operation yet.
```

---

# Eklenecek / düzenlenecek modüller

## 1. `src/semantic/type_binding.fbs`

Burada floating point canonical type sistemi netleştirilecek.

Eklenecek mantık:

```text
SINGLE  -> F32
CSNG    -> F32 conversion
DOUBLE  -> F64
CDBL    -> F64 conversion
EXTENDED -> F80
F32     -> F32
F64     -> F64
F80     -> F80
```

Type özellikleri:

```text
F32:
  size = 4
  align = 4
  isFloat = true

F64:
  size = 8
  align = 8
  isFloat = true

F80:
  size = 16 storage slot önerilir
  align = 16 önerilir
  logical precision = 80-bit
  isFloat = true
```

F80 için neden 16 byte slot? Çünkü x86 extended 80-bit değer pratikte çoğu ABI/layout sisteminde 10 byte yerine 16 byte hizalı saklanır. Bu ileride array/type/class field hesaplarında daha güvenli olur.

---

## 2. `src/parser/ast.fbs`

Numeric literal ayrımı net olmalı.

Eklenecek/ayrılacak node türleri:

```text
INTEGER_LITERAL
F32_LITERAL
F64_LITERAL
F80_LITERAL
```

Literal suffix önerisi:

```text
1.5!   -> F32 / SINGLE
1.5#   -> F64 / DOUBLE
1.5@   -> F80 / EXTENDED önerisi
1.5    -> default F64
```

Eğer `@` başka yerde kullanılıyorsa F80 suffix daha sonra seçilsin; ama AST içinde `F80_LITERAL` yeri şimdiden ayrılsın.

---

## 3. `src/semantic/mir_model.fbs`

MIR value modeli genişletilecek.

Şu an muhtemelen şuna benzer yapı var:

```text
floatValue As Double
```

Bu yeterli değil.

Önerilen model:

```text
MIRFloatKind:
  MIR_FLOAT_F32
  MIR_FLOAT_F64
  MIR_FLOAT_F80

MIRValue:
  f32Value As Single
  f64Value As Double
  f80TextValue As String   ' geçici güvenli temsil
  floatKind As Integer
```

F80 için FreeBASIC tarafında gerçek 80-bit tip güvenilir değilse ilk aşamada `String` veya raw byte temsil kullanılabilir. Ama F80’i sessizce Double’a düşürme.

---

## 4. `src/semantic/mir.fbs`

MIR instruction seviyesinde float op ayrılacak.

Eklenecek op mantığı:

```text
MIR_FADD_F32
MIR_FSUB_F32
MIR_FMUL_F32
MIR_FDIV_F32

MIR_FADD_F64
MIR_FSUB_F64
MIR_FMUL_F64
MIR_FDIV_F64

MIR_FADD_F80
MIR_FSUB_F80
MIR_FMUL_F80
MIR_FDIV_F80
```

F80 ilk aşamada lowering yapılabilir ama native emit unsupported diagnostic verebilir.

---

## 5. `src/semantic/mir_evaluator.fbs`

AST/MIR interpreter tarafında F32/F64 ayrımı korunmalı.

```text
F32 işlemler Single hassasiyetinde normalize edilecek.
F64 işlemler Double olarak kalacak.
F80 için geçici olarak:
  ya runtime diagnostic
  ya da high precision decimal/string helper
```

F80’i doğrudan Double ile hesaplayıp “F80 desteklendi” deme.

---

## 6. `src/codegen/x64/code_generator.fbs`

Bu dosyada en kritik iş yapılacak.

Mevcut integer merkezli yapı ayrılacak:

```text
EmitExprToRax    -> integer / pointer / string handle
EmitExprToXmm0   -> F32 / F64
EmitExprToFpu0   -> F80, ileride x87 yolu
```

F32 için SSE:

```asm
addss
subss
mulss
divss
ucomiss
movss
cvtss2sd
cvtsi2ss
cvttss2si
```

F64 için SSE2:

```asm
addsd
subsd
mulsd
divsd
ucomisd
movsd
cvtsi2sd
cvttsd2si
```

F80 için ilk aşama:

```text
EmitExprToFpu0 taslak fonksiyon aç.
Eğer backend F80 op görürse:
  diagnostic üret
  native build başarısız olsun
veya
  runtime helper çağıracak altyapı hazırla.
```

F80 ileride x87 ile yapılacaksa:

```asm
fld tword [mem]
fstp tword [mem]
fadd
fsub
fmul
fdiv
```

Ama Windows x64 ABI’de F80 return/param konusu sorunlu olduğu için F80’i doğrudan ABI’ye sokmadan önce runtime helper yaklaşımı daha güvenli olabilir.

---

# Yeni dosya önerisi

Hamle 4 sırasında `code_generator.fbs` daha da şişmesin. Şunlar açılabilir:

```text
src/codegen/x64/x64_expr_float.fbs
src/codegen/x64/x64_float_literals.fbs
src/codegen/x64/x64_float_storage.fbs
src/codegen/x64/x64_float_builtins.fbs
src/codegen/x64/x64_float_compare.fbs
```

Ana `code_generator.fbs` sadece yönlendirsin.

---

# Silinecek / kaldırılacak yanlış davranışlar

Şunlar kaldırılmalı:

```text
1. Float literal → CLng(Val(...)) kırpması.
2. Math helper sonucu → cvttsd2si rax ile integer’a çevirme.
3. DOUBLE return değerini RAX ile döndürme.
4. F64 FFI return değerini ExecClampI32 ile integer’a kırpma.
5. RND’nin sadece integer rand gibi davranması.
6. VAL’in atoi benzeri integer parse etmesi.
7. PRINT’in float değerleri integer gibi basması.
8. F80’i sessizce F64’e düşürme.
```

---

# F32 / F64 / F80 testleri

## Test 1 — F32

```basic
DIM a AS SINGLE
DIM b AS SINGLE

a = 1.5!
b = 2.25!

PRINT a + b
PRINT b - a
PRINT a * b
PRINT b / a
```

Beklenen:

```text
3.75
0.75
3.375
1.5
```

## Test 2 — F64

```basic
DIM a AS DOUBLE
DIM b AS DOUBLE

a = 1.5#
b = 2.25#

PRINT a + b
PRINT b - a
PRINT a * b
PRINT b / a
PRINT SQR(9.0#)
PRINT SIN(1.0#)
```

## Test 3 — int-float conversion

```basic
DIM i AS INTEGER
DIM d AS DOUBLE

i = 3
d = i + 0.5#

PRINT d
PRINT CINT(d)
PRINT CDBL(i)
```

## Test 4 — F80 storage

```basic
DIM x AS F80
x = 1.234567890123456789@

PRINT x
```

İlk aşamada kabul edilebilir sonuç:

```text
Native diagnostic:
F80 native arithmetic/print is not implemented yet
```

Ama type/layout tarafında parser ve semantic çökmeden bu tipi tanımalı.

---

# Hamle 4 bitiş şartı

```text
F32:
  AST OK
  MIR OK
  x64 build OK
  x64 run OK
  output parity OK

F64:
  AST OK
  MIR OK
  x64 build OK
  x64 run OK
  output parity OK

F80:
  Parser OK
  Semantic OK
  Layout OK
  Storage model OK
  Native unsupported ise açık diagnostic OK
  Sessiz F64’e düşürme YASAK
```

Kısa emir:

```text
Önce F32/F64 gerçek native olsun.
F80 unutulmasın; type/layout/storage seviyesi eklensin.
F80 arithmetic ya x87/runtime helper ile yapılacak ya da açık unsupported diagnostic verecek.
Sessiz kırpma, integer’a dönüş, F64’e düşürme yapılmayacak.
```
Haklısın Mete abi. **Suffix yok.** Ben orada belge/kod gerçekliği yerine genel BASIC alışkanlığıyla `! # @` önermişim; bu uXBasic planına göre yanlış.

Kod gerçekliği şu:

```text
Lexer:
NUMBER tek token üretiyor.

Parser:
NUMBER node’u üretiyor.

Builtin type listesi:
F32
F64
F80
var.

type_binding:
F32 size 4 align 4
F64 size 8 align 8
F80 size 10 align 8
olarak tanımlı.
```

Yani doğru plan şu olmalı:

```text
Suffix eklenmeyecek.
Yeni literal suffix icat edilmeyecek.
F32/F64/F80 ayrımı literal üstünden değil, hedef type / cast / semantic binding üstünden yapılacak.
```

Düzeltilmiş talimat:

```text
Hamle 4 Floating Point için:

1. NUMBER node aynen kalacak.
2. Literal metni korunacak: "1.5", "1E-3", "2.0" gibi.
3. Semantic aşamada hedef tipe göre yorumlanacak:
   DIM x AS F32 : x = 1.5  -> F32
   DIM x AS F64 : x = 1.5  -> F64
   DIM x AS F80 : x = 1.5  -> F80 storage/diagnostic
4. Eğer hedef type yoksa default floating literal F64 sayılacak.
5. CDBL / CSNG / varsa CF80 benzeri cast fonksiyonları type conversion olarak ele alınacak.
6. F80 için suffix önerilmeyecek.
```

F80 için de düzeltme:

```text
F80:
  sizeBytes = 10
  alignBytes = 8
  type_binding mevcut davranışına uyulacak.
  Benim önceki 16 byte storage önerim mevcut kodla uyuşmuyor.
  Şimdilik değiştirilmesin; layout zinciri bozulmasın.
```

Diğer AI’ye verilecek kısa emir şöyle olsun:

```text
Suffix ekleme.
Lexer/parser NUMBER sistemini bozma.
F32/F64/F80 ayrımını semantic type binding ve assignment/cast üzerinden yap.
F32 için movss/addss/subss/mulss/divss.
F64 için movsd/addsd/subsd/mulsd/divsd.
F80 için mevcut type_binding: size 10 align 8 korunacak; native arithmetic yoksa açık diagnostic verilecek.
Float literal integer’a kırpılmayacak.
F80 sessizce F64’e düşürülmeyecek.
```

Evet Mete abi, bu konuda sen haklısın.
Mete abi, **bu iskelet yön olarak doğru ama doğrudan uygulanacak kadar doğru değil.** Özellikle “kopyala-yapıştır hazır” denmesi tehlikeli. Çünkü bazı parçalar mevcut src gerçekliğiyle uyuşmuyor. 

## Doğru tarafları

Şunlar doğru:

```text
x64 codegen RAX/integer hattından ayrılmalı.
EmitExprToXmm0 benzeri float yolu açılmalı.
F32/F64 için SSE/SSE2 kullanılmalı.
Float literal integer’a kırpılmamalı.
F80 unutulmamalı ama ilk aşamada native arithmetic açık diagnostic verebilir.
VAL/PRINT/RND/math helper integer davranıştan çıkarılmalı.
```

## Hatalı / eksik tarafları

En büyük hatalar şunlar:

```text
1. X64CreateFloatConstant fonksiyonunda cg parametresi yok ama içeride cg kullanıyor.
2. Her float literal için sadece dq kullanıyor; F32 için dd, F64 için dq, F80 için tword/10 byte ayrımı lazım.
3. “FLOAT_LITERAL node’u güçlendir” demiş ama sende suffix yok; NUMBER korunmalı, hedef tipe göre F32/F64/F80 seçilmeli.
4. X64EmitFloatBinary işlem sırası hatalı olabilir:
   sol xmm1’e alınıyor, sağ xmm0’da kalıyor.
   a - b için subsd xmm0, xmm1 yazarsa b - a üretir.
   Doğrusu sol sonuç korunup sağ operand ayrı register’a alınmalı.
5. PRINT helper yanlış:
   xmm0 zaten değer taşıyorsa neden __uxb_float_temp’ten okuyor?
   Win64 printf için varargs + stack alignment konusu ayrıca dikkat ister.
6. VarMapping yerine “offset_varName” placeholder yazılmış; gerçek kodda böyle çalışmaz.
7. F80 için sadece size=10 demek yetmez; assignment, storage, diagnostic ve layout testleri şart.
8. cg_context’e rastgele alan eklemek riskli; önce mevcut context yapısıyla uyum kontrol edilmeli.
```

## Düzeltilmiş temel yön

Diğer AI’ye şunu söyle:

```text
Bu iskeleti doğrudan uygulama.
Önce mevcut X64CodegenContext, VarMapping, data section emit fonksiyonları ve GenerateExpression imzasını oku.
Sonra gerçek fonksiyon isimlerine göre patch üret.
Placeholder offset_, sahte cg kullanımı, suffix veya yeni literal node ekleme yapma.
```

## Hamle 4 için doğru mini iskelet

```text
1. NUMBER literal text korunacak.
2. Semantic hedef tipe göre:
   F32 / F64 / F80 seçilecek.
3. F32:
   dd constant
   movss
   addss/subss/mulss/divss
4. F64:
   dq constant
   movsd
   addsd/subsd/mulsd/divsd
5. F80:
   type/layout/storage tanınacak.
   native arithmetic yoksa açık diagnostic.
6. Float binary işlemde operand sırası korunacak:
   sol -> xmm0
   push/spill veya xmm1’e kaydet
   sağ -> xmm1
   işlem -> xmm0 = sol op sağ
7. PRINT float gerçek helper ile yapılacak.
8. F64 return XMM0 olacak; RAX’a kırpılmayacak.
```

Kısa hüküm: **İskelet fikir olarak iyi, ama kod olarak yarı placeholder. Uygulatmadan önce gerçek src fonksiyon adlarına ve mevcut VarMapping/data emit sistemine göre düzelttirmek gerekir.**

Mete abi, aşağıdaki metni **GPT’ye aynen ver**. Bu, Grok’un iskeletindeki doğru fikirleri korur ama hatalı placeholder/kopyala-yapıştır kısımlarını düzeltir. Özellikle **suffix yok**, `F80` unutulmuyor, `F32/F64/F80` ayrımı **semantic hedef tip / cast / assignment** üzerinden yapılıyor. Önceki belgelerde de mevcut durumun “type system tanıyor ama x64 native gerçek float değil” olduğu açıkça yazıyordu.  Grok’un verdiği iskelette ise `EmitExprToXmm0`, SSE2, `code_generator.fbs` odaklı yaklaşım doğru ama bazı kod parçaları placeholder ve doğrudan uygulanamaz durumdaydı. 

---

# GPT’ye Talimat: uXBasic Hamle 4 — Gerçekçi Floating Point Tamamlama Planı

Sen bu görevde yeni syntax icat etmeyeceksin. Özellikle **literal suffix eklemeyeceksin**. uXBasic belgelerinde ve mevcut kod gerçekliğinde sayı literal’ları `NUMBER` olarak geliyor. `F32`, `F64`, `F80` ayrımı literal son ekinden değil, **hedef type, semantic binding, assignment ve cast** üzerinden yapılacak.

## Ana hedef

Hamle 4 sonunda:

```text
F32 / SINGLE  gerçek native x64 destek alsın.
F64 / DOUBLE  gerçek native x64 destek alsın.
F80           parser/type/layout/storage seviyesinde tanınsın.
F80 arithmetic/native print henüz yoksa sessizce F64’e düşürülmesin; açık diagnostic verilsin.
```

Başarı ölçütü:

```text
Parser OK yetmez.
Semantic OK yetmez.
AST OK yetmez.
MIR OK yetmez.
x64 build OK yetmez.

F32/F64 için:
AST output = MIR output = x64 native output olacak.

F80 için:
Parser + semantic + layout OK olacak.
Native arithmetic unsupported ise açık hata verecek.
Sessiz F64’e düşürme yasak.
```

---

# 1. Önce okunacak dosyalar

Kod yazmadan önce şu dosyalar okunacak:

```text
src/parser/ast.fbs
src/parser/token_kinds.fbs
src/parser/lexer/
src/parser/parser/

src/semantic/type_binding.fbs
src/semantic/layout.fbs
src/semantic/mir_model.fbs
src/semantic/mir.fbs
src/semantic/mir_evaluator.fbs
src/semantic/semantic_pass.fbs

src/runtime/memory_exec.fbs
src/runtime/exec/exec_eval_builtin_categories.fbs
src/runtime/exec/exec_eval_text_helpers.fbs

src/codegen/x64/cg_context.fbs
src/codegen/x64/code_generator.fbs
src/codegen/x64/var_mapping.fbs
src/codegen/x64/ffi_call_backend.fbs

src/build/interop_manifest.fbs
tests/basicCodeTests/
tests/basicCodeTests/out_matrix_*/matrix.md
tests/basicCodeTests/out_matrix_*/matrix.csv
```

Kod yazmadan önce şu soruların cevabı çıkarılacak:

```text
1. NUMBER node şu anda nasıl saklanıyor?
2. Type binding F32/F64/F80 için size/align ne veriyor?
3. x64 local/global variable offset sistemi nerede tutuluyor?
4. Data section nasıl emit ediliyor?
5. PRINT helper’ları nerede tanımlı?
6. Builtin math helper’ları nerede emit ediliyor?
7. GenerateExpression / X64EmitExprToRax imzaları gerçek olarak nedir?
8. VarMapping gerçek offset’i nasıl veriyor?
```

Placeholder kod yazma. `offset_varName`, sahte `cg`, sahte fonksiyon ismi kullanma.

---

# 2. Yapılmayacaklar

Şunlar kesin yasak:

```text
1. ! # @ gibi suffix ekleme.
2. FLOAT_LITERAL, F32_LITERAL, F64_LITERAL, F80_LITERAL diye parser syntax’ını kafana göre değiştirme.
3. NUMBER token sistemini bozma.
4. Float literal’ı CLng(Val(...)) ile integer’a kırpma.
5. Math helper sonucunu cvttsd2si rax ile integer’a çevirme.
6. F64 dönüş değerini RAX’a koyma.
7. F80’i sessizce F64’e düşürme.
8. PRINT float’ı integer gibi basma.
9. RND’yi sadece integer rand gibi bırakma.
10. VarMapping yerine placeholder offset yazma.
11. `code_generator.fbs` içine plansız dev kod yığma.
```

---

# 3. Type sistemi düzeltmesi

`src/semantic/type_binding.fbs` içinde şu eşleşmeler net olmalı:

```text
SINGLE -> F32
F32    -> F32

DOUBLE -> F64
F64    -> F64

F80    -> F80
```

Eğer `EXTENDED` veya benzeri bir alias belgelerde yoksa ekleme. Varsa belgeye göre bağla.

Mevcut gerçeklikte F80 için:

```text
F80 size = 10
F80 align = 8
```

korunacak. Benzer şekilde layout zinciri bozulmayacak.

Beklenen yardımcı karar fonksiyonları:

```freebasic
Function TypeIsFloat(ByRef t As String) As Integer
Function TypeIsF32(ByRef t As String) As Integer
Function TypeIsF64(ByRef t As String) As Integer
Function TypeIsF80(ByRef t As String) As Integer
Function TypeFloatKind(ByRef t As String) As Integer
```

Ama bunları mevcut projedeki naming standardına göre yaz.

---

# 4. Literal stratejisi

Lexer/parser tarafı korunacak:

```text
1.5
1E-3
2.0
```

bunlar yine `NUMBER` olarak kalacak.

Semantic/lowering sırasında:

```basic
DIM a AS F32
a = 1.5
```

ise literal F32 kabul edilecek.

```basic
DIM a AS F64
a = 1.5
```

ise literal F64 kabul edilecek.

```basic
DIM a AS F80
a = 1.5
```

ise literal F80 storage/type olarak kabul edilecek; native arithmetic/print desteklenmiyorsa açık diagnostic verilecek.

Hedef tip yoksa:

```text
floating numeric literal default = F64
integer numeric literal default = mevcut integer kuralı
```

---

# 5. MIR tarafı

`src/semantic/mir_model.fbs`, `src/semantic/mir.fbs`, `src/semantic/mir_evaluator.fbs` içinde float tür bilgisi korunacak.

Minimum mantık:

```text
MIR float kind:
F32
F64
F80
```

F32 işlemler:

```text
Single hassasiyetine normalize edilecek.
```

F64 işlemler:

```text
Double olarak kalacak.
```

F80 işlemler:

```text
Eğer gerçek F80 evaluator yoksa:
- semantic/type/layout geçsin
- arithmetic/print aşamasında açık diagnostic verilsin
- F64’e sessiz düşürülmesin
```

---

# 6. x64 codegen ana ayrımı

`src/codegen/x64/code_generator.fbs` içinde integer ve float expression yolları ayrılacak.

Gerekli emit yolları:

```text
X64EmitExprToRax   -> integer / pointer / string handle
X64EmitExprToXmm0  -> F32 / F64
X64EmitExprToF80   -> şimdilik diagnostic veya ileride x87/runtime helper
```

Fonksiyon isimleri mevcut projeye göre değişebilir; ama mantık bu olacak.

## F32 için kullanılacak komutlar

```asm
movss
addss
subss
mulss
divss
ucomiss
cvtsi2ss
cvttss2si
cvtss2sd
```

## F64 için kullanılacak komutlar

```asm
movsd
addsd
subsd
mulsd
divsd
ucomisd
cvtsi2sd
cvttsd2si
cvtsd2ss
```

## F80 için

İlk aşamada:

```text
type/layout/storage OK
native arithmetic unsupported diagnostic OK
```

İleride destek için iki yol açık bırakılacak:

```text
1. x87 yolu:
   fld tword
   fstp tword
   fadd/fsub/fmul/fdiv

2. DLL/runtime helper yolu:
   MPFR/GMP/ARB/FLINT wrapper
```

Bu projede uzun vadede yüksek hassasiyet DLL + .bas wrapper ile yapılacağı için F80’i compiler içinde sahte destekleme.

---

# 7. Operand sırası hatası düzeltilmeli

Grok iskeletindeki şu mantık tehlikeli:

```text
left -> xmm0
movsd xmm1, xmm0
right -> xmm0
subsd xmm0, xmm1
```

Bu `a - b` yerine `b - a` üretir.

Doğru mantık:

```text
left  -> xmm0
xmm0 değerini spill et veya xmm1’e al
right -> xmm1
xmm0 = left op right
```

Örnek F64 mantığı:

```asm
; left sonucu xmm0
movsd xmm2, xmm0

; right sonucu xmm0
; sonra right'ı xmm1'e al
movsd xmm1, xmm0

; sonucu tekrar xmm0 = left
movsd xmm0, xmm2

; işlem
addsd xmm0, xmm1
subsd xmm0, xmm1
mulsd xmm0, xmm1
divsd xmm0, xmm1
```

Register çakışması varsa stack spill kullan:

```asm
sub rsp, 8
movsd [rsp], xmm0
; right emit
movsd xmm1, xmm0
movsd xmm0, [rsp]
add rsp, 8
; xmm0 = left, xmm1 = right
```

Stack alignment’a dikkat et.

---

# 8. Float constant emit

Sahte `X64CreateFloatConstant(valueText)` yazma. Gerçek fonksiyon `cg` context ve data emitter almalı.

Mantık:

```text
F32 constant -> dd
F64 constant -> dq
F80 constant -> 10 byte/tword storage veya diagnostic placeholder
```

Örnek iskelet:

```freebasic
Private Function X64CreateFloatConstant( _
    ByRef cg As X64CodegenContext, _
    ByRef valueText As String, _
    ByVal floatKind As Integer, _
    ByRef errText As String _
) As String

    ' Mevcut data section emit fonksiyonunu kullan.
    ' Static counter yerine mümkünse context counter kullan.
    ' F32 -> dd valueText
    ' F64 -> dq valueText
    ' F80 -> mevcut assembler destekliyorsa tword,
    '        yoksa raw bytes/runtime helper planı veya diagnostic.
End Function
```

---

# 9. Assignment

Şu ayrım yapılacak:

```basic
DIM a AS F32
a = 1.5
```

x64:

```asm
; expr -> xmm0
movss [target], xmm0
```

```basic
DIM a AS F64
a = 1.5
```

x64:

```asm
; expr -> xmm0
movsd [target], xmm0
```

```basic
DIM a AS F80
a = 1.5
```

İlk aşamada:

```text
storage tanınıyorsa raw store planı
arithmetic/print yoksa diagnostic
```

---

# 10. PRINT float

PRINT için üç davranış:

```text
PRINT F32 -> helper F32 veya F32 önce F64’e genişletilip print double
PRINT F64 -> print double helper
PRINT F80 -> unsupported diagnostic veya ileride runtime helper
```

`printf("%g")` kullanılacaksa Win64 varargs kurallarına dikkat:

```text
RCX -> format string
XMM0 -> double value
RDX veya uygun shadow/register kopyası gerekebilir
stack 16-byte aligned olmalı
shadow space 32 byte ayrılmalı
```

Daha güvenli çözüm:

```text
Kendi runtime helper’ını yaz:
__uxb_print_f64
__uxb_print_f32
```

Compiler sadece helper çağırır.

---

# 11. Builtin math functions

Şunlar float döndürmeli:

```text
SQR
SIN
COS
TAN
ATN
EXP
LOG
CDBL
CSNG
VAL
RND
TIMER
```

Düzeltilecek yanlış:

```text
double hesapla -> integer’a kırp -> RAX dön
```

Doğru:

```text
F64 sonucu XMM0’da dön.
F32 gerekiyorsa cvtsd2ss ile F32’ye düşür.
```

`VAL`:

```text
atoi değil strtod/atof mantığı.
```

`RND`:

```text
0.0 <= RND < 1.0 double üretmeli.
```

`TIMER`:

```text
double saniye değeri döndürmeli.
```

---

# 12. Function return ve CALL

F32/F64 return:

```text
F32/F64 function return XMM0
```

Integer return:

```text
RAX
```

FFI tarafı Hamle 12’de derinleşecek; ama Hamle 4’te şu yasak düzeltilmeli:

```text
F64 FFI return değerini ExecClampI32 ile integer’a kırpma.
```

Hamle 4’te tam FFI şart değil; ama kırpma davranışı kaldırılmalı veya açık PARTIAL/diagnostic yazılmalı.

---

# 13. Testler

Şu dosya oluşturulacak:

```text
tests/basicCodeTests/44_matrix_float_native.bas
```

İçerik:

```basic
PRINT "F32"
DIM a AS F32
DIM b AS F32
a = 1.5
b = 2.25
PRINT a + b
PRINT b - a
PRINT a * b
PRINT b / a

PRINT "F64"
DIM x AS F64
DIM y AS F64
x = 1.5
y = 2.25
PRINT x + y
PRINT y - x
PRINT x * y
PRINT y / x
PRINT SQR(9.0)
PRINT SIN(1.0)

PRINT "CONVERT"
DIM i AS INTEGER
DIM d AS F64
i = 3
d = i + 0.5
PRINT d
PRINT CDBL(i)
```

Ayrı F80 testi:

```text
tests/basicCodeTests/45_matrix_float_f80_storage.bas
```

İçerik:

```basic
DIM z AS F80
z = 1.25
```

Beklenen:

```text
Parser OK
Semantic OK
Layout OK
Native arithmetic/print yoksa açık diagnostic
```

F80 testinde `PRINT z` varsa, destek yoksa açık hata beklenmeli.

---

# 14. Güncellenecek belgeler

Hamle sonunda şu belgeler güncellenecek:

```text
COMPILER_COVERAGE.md
COMPILER_TODO.md
COMPILER_PARITY_MATRIX.md
NATIVE_X64_STATUS.md
MIR_STATUS.md
FLOATING_POINT_STATUS.md
yapilanlar.md
```

`FLOATING_POINT_STATUS.md` yoksa oluştur.

İçeriği şu formatta olacak:

```text
F32:
Parser:
Semantic:
AST:
MIR:
x64 build:
x64 run:
Output parity:
Eksikler:

F64:
Parser:
Semantic:
AST:
MIR:
x64 build:
x64 run:
Output parity:
Eksikler:

F80:
Parser:
Semantic:
Layout:
Storage:
x64 arithmetic:
x64 print:
Diagnostic:
Eksikler:
```

---

# 15. Hamle 4 bitiş şartı

Hamle 4 tamam sayılabilmesi için:

```text
1. NUMBER sistemi bozulmayacak.
2. Suffix eklenmeyecek.
3. F32/F64 semantic hedef tipe göre ayrılacak.
4. F32 native arithmetic çalışacak.
5. F64 native arithmetic çalışacak.
6. F32/F64 PRINT doğru olacak.
7. Builtin math sonuçları integer’a kırpılmayacak.
8. Float compare çalışacak.
9. F80 type/layout/storage tanınacak.
10. F80 desteklenmeyen işlemde açık diagnostic verecek.
11. AST/MIR/x64 output parity sağlanacak.
12. Coverage belgeleri gerçek test sonucuna göre güncellenecek.
```

---

# 16. Kısa kod iskeleti — sadece yön gösterici

Bu kod **doğrudan kopyala-yapıştır kodu değildir**. Mevcut fonksiyon isimlerine göre uyarlanacak.

```freebasic
Enum UXFloatKind
    UX_FLOAT_NONE = 0
    UX_FLOAT_F32  = 1
    UX_FLOAT_F64  = 2
    UX_FLOAT_F80  = 3
End Enum

Private Function X64FloatKindFromType(ByRef typeName As String) As Integer
    Dim t As String = UCase(Trim(typeName))

    If t = "SINGLE" OrElse t = "F32" Then Return UX_FLOAT_F32
    If t = "DOUBLE" OrElse t = "F64" Then Return UX_FLOAT_F64
    If t = "F80" Then Return UX_FLOAT_F80

    Return UX_FLOAT_NONE
End Function
```

```freebasic
Private Function X64EmitExprToXmm0( _
    ByRef ps As ParseState, _
    ByVal nodeIdx As Integer, _
    ByRef cg As X64CodegenContext, _
    ByVal targetFloatKind As Integer, _
    ByRef errText As String _
) As Integer

    If targetFloatKind = UX_FLOAT_F80 Then
        errText = "F80 native arithmetic is not implemented in x64 backend yet"
        Return 0
    End If

    ' NUMBER:
    '   constant emit -> F32 dd / F64 dq
    '
    ' IDENT/VAR_REF:
    '   VarMapping ile gerçek adres çöz
    '   F32 -> movss xmm0, [addr]
    '   F64 -> movsd xmm0, [addr]
    '
    ' BINARY_OP:
    '   X64EmitFloatBinary(...)
    '
    ' INTEGER expr:
    '   X64EmitExprToRax(...)
    '   F32 -> cvtsi2ss xmm0, rax
    '   F64 -> cvtsi2sd xmm0, rax

    Return 1
End Function
```

```freebasic
Private Function X64EmitFloatBinary( _
    ByRef ps As ParseState, _
    ByVal nodeIdx As Integer, _
    ByRef cg As X64CodegenContext, _
    ByVal floatKind As Integer, _
    ByRef errText As String _
) As Integer

    ' 1. left -> xmm0
    ' 2. spill left
    ' 3. right -> xmm0
    ' 4. move right -> xmm1
    ' 5. reload left -> xmm0
    ' 6. xmm0 = left op right

    Select Case floatKind
    Case UX_FLOAT_F32
        ' addss/subss/mulss/divss
    Case UX_FLOAT_F64
        ' addsd/subsd/mulsd/divsd
    Case UX_FLOAT_F80
        errText = "F80 native binary arithmetic is not implemented yet"
        Return 0
    End Select

    Return 1
End Function
```

---

# Son emir

Önce `src` gerçek fonksiyon isimlerini çıkar.
Sonra bu plana göre küçük patch üret.
Önce F64 çalıştır, sonra F32, sonra F80 diagnostic.
TYPE/CLASS’a geçme.
EVENT/THREAD konuşma.
Hamle 4 bitmeden Hamle 5’e geçme.








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

## Hamle 5 Durum Guncellemesi (2026-04-30)

Hamle 5 icin TYPE layout + field access lane'i bu turda tekrar dogrulandi.

Tamamlanan kanitlar:

- `tests/run_x64_type_field_codegen_h5.bas` -> `PASS H5 x64 type field codegen`
- `tests/run_x64_type_field_f80_diag.bas` -> `PASS H5 F80 diagnostic`
- `tests/run_x64_codegen_emit.bas` -> `PASS x64 codegen emit`
- `tests/basicCodeTests/46_matrix_float_array_stride.bas` -> PASS
- `tests/basicCodeTests/47_matrix_float_function_return.bas` -> PASS

50-54 matrisi:

- `50_type_field_numeric.bas`: AST OK, MIR OK, x64 build OK
- `51_type_nested_field.bas`: AST OK, MIR OK, x64 build OK
- `52_type_array_field.bas`: AST FAIL (exit=5), MIR FAIL (exit=13), x64 build FAIL (exit=14)
- `53_type_f80_field_diagnostic.bas`: AST OK, MIR OK, x64 build FAIL (exit=14, bilincli diagnostic lane)
- `54_type_string_field_partial.bas`: AST OK, MIR OK, x64 build OK

x64 log kaniti (`dist/loglar/uxbasic.log`):

- `x64-codegen: field resolve failed OFFSETOF invalid index syntax`
- `x64-codegen: F80 field store is not implemented in x64 backend yet`

Sonuc: Hamle 5 durumu bu snapshotta `PARTIAL`.
Kapanis icin array-field index cozumleme lane'i ve F80 field-store lane'i tamamlanmali.
