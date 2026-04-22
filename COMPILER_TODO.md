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

- MIR lowering:
  `DEFTYPE_STMT`, `SETSTRINGSIZE_STMT`, `CLS_STMT`, `LOCATE_STMT`, `COLOR_STMT`, `RANDOMIZE_STMT`, `INCDEC_STMT`
- MIR CALL/interpreter:
  `STR`, `CHR`, `UCASE`, `LCASE`, `LTRIM`, `RTRIM`, `SPACE`, `STRING`, `MID`, `GETKEY`, tam `TIMER(...)` varyantlari, `CLS`, `LOCATE`, `COLOR`, `RANDOMIZE`
- x64 emit:
  `CLS`, `LOCATE`, `COLOR`, `RANDOMIZE`, metadata-only `DEF*` / `SETSTRINGSIZE`
- x64 builtin baglama:
  `GETKEY`, `TIMER`, `LTRIM`, `RTRIM`, `SPACE`, `STRING`, `MID`, `UCASE`, `LCASE`, `STR`, `CHR`, `LEN`, `FIX`

## Kalan Isler

- x64 tarafinda yeni eklenen helper sembollerin gercek runtime ABI uygulamalarini eklemek:
  `__uxb_runtime_cls`
  `__uxb_runtime_locate`
  `__uxb_runtime_color`
  `__uxb_runtime_randomize_auto`
  `__uxb_runtime_randomize_seed`
  `__uxb_builtin_*`
- x64 backend icin dosya G/C ve keyboard helperlari da gerekiyorsa ayni ABI modeliyle tamamlanmali.
- Kaynaktan derleme araci (FreeBASIC/fbc) ile taze build alip AST interpreter + MIR backend + x64 emit regresyon ornekleri otomatiklestirilmeli.

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
