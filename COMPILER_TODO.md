# Compiler Command Coverage TODO

Bu not, `src` taramasi sonrasinda compiler katmanlarinin mevcut durumunu ve bu turde yapilan kapatma islerini ozetler.

## Pipeline Ozeti

1. `src/parser/lexer/*`
   Keyword tanima ve tokenizasyon.
2. `src/parser/parser/*`
   Statement/expression parse, AST uretimi, parser-semantik dogrulamalari.
3. `src/semantic/semantic_pass.fbs`
   AST uzerinden temel anlamsal dogrulamalar.
4. `src/semantic/mir.fbs`
   AST -> MIR lowering, MIR optimizer/interpreter.
5. `src/runtime/exec/*`
   AST tabanli interpreter/runtime uygulamasi.
6. `src/codegen/x64/code_generator.fbs`
   AST -> x64 NASM emit.
7. `src/build/interop_manifest.fbs`
   IMPORT/FFI baglanti ciktilari ve link plani.

## Bu Turde Kapatilan Bosluklar

- ALIAS parser yuzeyi:
  `ALIAS yeni = eski`
  `ALIAS yeni AS eski`
  `ALIAS yeni eski`
  tumu ayni `ALIAS_STMT`/`ALIAS_TARGET` modeline iniyor
- Dil yuzeyi sikilastirmasi:
  `SQRT` parser seviyesinde reddediliyor, `SQR` kullaniliyor
  `THREAT` kaldirildi, `THREAD` kaldi
  `PARALLEL` kaldirildi, `PARALEL` kaldi
  `SLOT <BYTE ...>` yerine `SLOT <I8 ...>` / `SLOT <U8 ...>`
  `DEFBYT` runtime/MIR icte `I8` normalize yoluna cekildi

- MIR lowering:
  `DEFTYPE_STMT`, `SETSTRINGSIZE_STMT`, `CLS_STMT`, `LOCATE_STMT`, `COLOR_STMT`, `RANDOMIZE_STMT`, `INCDEC_STMT`
- MIR CALL/interpreter:
  `STR`, `CHR`, `UCASE`, `LCASE`, `LTRIM`, `RTRIM`, `SPACE`, `STRING`, `MID`, `GETKEY`, tam `TIMER(...)` varyantlari, `CLS`, `LOCATE`, `COLOR`, `RANDOMIZE`
- x64 emit:
  `CLS`, `LOCATE`, `COLOR`, `RANDOMIZE`, metadata-only `DEF*` / `SETSTRINGSIZE`
  native file I/O emit/helper lane:
  `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK`, `INPUT#`, `LOF`, `EOF`
  x64 asm helperleri CRT tabanli kanal tablosuna indiriliyor
  `native_file_io_probe2.bas` native exe olarak `287454020` yaziyor
  `native_lof_eof_probe.bas` native exe olarak `4` ve `0` yaziyor
  file I/O runtime parity kapandi
  native string builtin zinciri:
  `STR`, `UCASE`, `LCASE`, `SPACE`, `STRING`, `MID`
  `native_string_builtin_probe.bas` smoke gecti
  `tests/basicCodeTests/10.bas` native string smoke gecti
  native `LTRIM` / `RTRIM` smoke:
  `native_ltrim_rtrim_probe.bas` native exe olarak `abc`, `abc`, `1`, `1`
  native `RANDOMIZE` / `RND` smoke:
  `native_timer_randomize_probe.bas` native exe olarak sayisal `RND(1)` cikisi verdi
  native `TIMER()` smoke:
  `native_timer_randomize_probe.bas` native exe olarak sayisal `TIMER()` cikisi verdi
  native scalar `INC` / `DEC` smoke:
  `native_incdec_probe.bas` native exe olarak `10`
  parser + x64 indexed assignment zinciri:
  `arr(i) = ...` parserda `ASSIGN_STMT` + `CALL_EXPR` lhs olarak iniyor
  native global indexed array smoke:
  `native_global_array_probe.bas` native x64 exe olarak `22`, `27`, `33`
  AST + MIR indexed array parity:
  `runtime_mir_indexed_array_probe.bas` AST interpreter, MIR interpreter ve native x64 exe olarak `22`, `27`, `27`, `33`, `44`
  `LOAD_INDEXED` / `STORE_INDEXED` opcode'lari eklendi
  `REDIM PRESERVE` runtime storage parity'si gercek array storage ile baglandi
- x64 akıs emit:
  `SELECT CASE`, `CASE IS`, `CASE ELSE`, `DO/LOOP`, `FOR EACH`, `DO EACH`, `EXIT IF/FOR/DO`
  native build smoke:
  `tests/basicCodeTests/6.bas`
  `tests/basicCodeTests/21_matrix_flow_if_select_exitif.bas`
  `tests/basicCodeTests/23_matrix_each_loops.bas`
- x64 label/control-flow emit:
  `LABEL_STMT`, `GOTO_STMT`, `GOSUB_STMT`
  `13_uxb_commands_operators_types.bas` asm'inde artik `call __uxb_label_*` ve `jmp __uxb_label_*` uretiliyor
- x64 math/operator emit:
  `ABS`, `INT`, `FIX`, `SGN`, `VAL`, `ASC`, `RND`
  `SQR`, `SIN`, `COS`, `TAN`, `ATN`, `EXP`, `LOG`
  `MOD`, `AND`, `OR`, `XOR`, `NOT`, `SHL`, `SHR`, `ROL`, `ROR`
  `tests/basicCodeTests/13_uxb_commands_operators_types.bas` artik native emit/build asamalarini geciyor
- sembolik operator uyumu:
  `==`, `!=`, `^`, unary `!`, unary `~`
  parser + semantic const-eval + AST runtime + MIR lowering + x64 emit zincirine baglandi
  `tests/probes/operator_symbol_probe.bas` parser + semantic + MIR opcode JSON + AST runtime + x64 build smoke gecti
- operator sprint stage-2:
  `&&`, `||`, sembolik `|`, `|>`, prefix/postfix `++/--`, `?:`
  parser + AST runtime + x64 emit tarafina baglandi
  `tests/probes/operator_stage2_probe.bas` AST runtime ve native x64 olarak gecti
  `tests/probes/operator_logic_bridge_probe.bas` AST/MIR/native olarak tekrar gecti
  `tests/probes/operator_stage2_probe.bas` artik MIR runtime'da da tam geciyor
- operator keyword lane hizalama:
  parser precedence zincirine assignment katmani eklendi (right-associative)
  `AND/OR` logical short-circuit, `&/|` bitwise lane olarak ayrildi
  semantic const-fold, AST runtime, MIR lowering/evaluator ve x64 emit ayni operatore hizalandi
  `tests/probes/operator_keyword_logic_probe.bas` AST/MIR/native olarak `0`, `0`, `-1`, `0`, `2`, `5`, `-1`, `-1`
- parser field assignment normalize:
  `FIELD_EXPR = ...` artik `ASSIGN_STMT` olarak iniyor
- AST/runtime field parity:
  `FIELD_EXPR` read/write
  field target `ASSIGN_STMT`
  field target `INCDEC`
  `tests/probes/type_class_field_probe.bas` AST exec olarak `10`, `15`, `33`
- MIR field parity:
  `FIELD_EXPR` path lowering (read/write/assign/incdec) eklendi
  `tests/probes/type_class_field_probe.bas` AST/MIR/native olarak `10`, `15`, `33`
  `tests/probes/type_class_field_mutation_probe.bas` AST/MIR/native olarak `12`, `40`
- `NEW` parser akisi:
  `NEW BOX()` artik `NEW_EXPR("BOX")` olarak iniyor
- x64 basic field parity:
  `tests/probes/native_type_field_single_probe.bas` native exe olarak `10`
  `tests/probes/native_class_field_single_probe.bas` native exe olarak `33`
- coverage test kaniti tazelendi:
  `tests/run_console_state_exec_ast.exe` -> `PASS console state AST exec`
  `tests/run_jump_exec_ast.exe` -> `PASS jump AST exec`
  `tests/run_print_exec_ast.exe` -> `PASS print exec AST`
  `tests/basicCodeTests/21_matrix_flow_if_select_exitif.bas` AST/MIR/native smoke yeniden kosuldu
  `tests/basicCodeTests/23_matrix_each_loops.bas` AST/MIR/native smoke yeniden kosuldu
  `tests/basicCodeTests/6.bas` AST/MIR/native smoke yeniden kosuldu
  `tests/basicCodeTests/10.bas` native smoke yeniden kosuldu
  `tests/run_deftype_setstringsize_exec.exe` -> `PASS deftype/setstringsize exec`
- x64 builtin baglama:
  `GETKEY`, `TIMER`, `LTRIM`, `RTRIM`, `SPACE`, `STRING`, `MID`, `UCASE`, `LCASE`, `STR`, `CHR`, `LEN`, `FIX`
- x64 FFI emit sertlestirme:
  `X64ResetFfiArgCounts`
  `X64FfiArgCountAt`
  bu sertlestirme sonrasi `31` ve `32` Windows DLL smoke ornekleri `--build-x64` + exe run yolunda tekrar gecti
- x64 emit-only yol:
  `src/main.bas` icinde `--emit-x64-nasm` artik dogrudan `GenerateX64Code` hattini kullaniyor
  `31_uxb_windows_kernel_sleep_tick.bas` icin emit-only smoke tekrar gecti
- MIR exporter split:
  `MIRWritePipelineFlowJson` -> `src/semantic/mir_exporter_json.fbs`

## Kalan Isler

- x64 tarafinda siradaki davranis bosluklari:
  array/type access
  `TYPE/CLASS` field access icin daha genis native smoke ve print parity
- operator tablosunda kalan buyuk bosluklar:
  aggregate/nested `TYPE/CLASS` field parity (ozellikle daha genis native smoke)
  ternary/pipe/incdec lane'i icin daha genis semantic+MIR+x64 coverage
- PTR/POINTER anlamsal not:
  `POINTER` su an tip sistemi/semantic katmaninda veri tipi kategorisi
  `PTR` ise FFI imza tokeni ve pointer-benzeri cagrı sozlesmesi yuzeyi
  bu iki temsil ileride daha acik ortak pointer modeli altinda birlestirilmeli
- x64 backend icin dosya G/C, keyboard helperlari, array/type access ve operator parity tamamlanmali.
- string tarafinda kalan odak:
  string variable/array/type parity'yi daha genis test matrisiyle sabitlemek
- array tarafinda kalan odak:
  local/global array store/load davranisini daha genis test matrisiyle sabitlemek
  `TYPE` alanlari ve object/class field access ile array parity'nin birlikte genisletilmesi
- keyboard tarafinda kalan odak:
  native `INKEY(flags[,state])` davranisini `GETKEY()`den daha anlamli ayri bir helper/model ile genisletmek
- Kaynaktan derleme araci (FreeBASIC/fbc) ile taze build alip AST interpreter + MIR backend + x64 emit regresyon ornekleri otomatiklestirilmeli.
- `mir_exporter_json` altinda opcode exporter yuzeyi de toplanmali.
- Dosya bolme ikinci planda; once coverage matrisindeki partial/missing davranislar kodla kapatilacak.
- Bir sonraki oncelik:
  `TYPE/CLASS` aggregate/nested field parity probe'larini genisletmek
  ardindan daha genis native aggregate/type smoke

## Hedef Ornek Regresyonlar

- `DEFINT A-Z`
- `SETSTRINGSIZE 32`
- `CLS : COLOR 15,1 : LOCATE 10,20`
- `INC x : DEC x : RANDOMIZE 1234`
- `PRINT LTRIM("  a")`
- `PRINT RTRIM("a  ")`
- `PRINT SPACE(4) + STRING(3, 65)`
- `PRINT FIX(3.9)`
- `PRINT GETKEY()`
- `PRINT TIMER()`
- `PRINT TIMER("ms")`
- `PRINT TIMER(10, 13, "ms")`
