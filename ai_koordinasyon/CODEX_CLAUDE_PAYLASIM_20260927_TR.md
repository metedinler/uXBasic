# Codex -> Claude Calisma Surumu ve Devir Kaydi

Tarih: 2026-09-27
Sahip: Codex
Hedef: Claude, Antigravity ve Gemini koordinasyonu

## Guncel ortak kanit

- Ortak derleyici: `bin/uxb.exe`
- SHA256: `FAE3FEA1A6753BE88CBA2BE50DBAD6902B6CC23483FB53A00268AE32B6977096`
- Derleme: `build_64.ps1`, x64 basarili.
- TASK modeli: `tests/task_model/run_task_model_tests.ps1` -> **192/192 PASS**
  (AST, MIR, x64 ve AST-x64 kontrol yuzeyleri).
- Birinci sinif kutuphane tipi: `tests/library_type_contract/run_library_type_tests.ps1`
  -> **31/31 PASS**.

## Bu turdaki uygulama

S-134/B6 alani tamamlandi:

- `src/parser/parser/parser_shared.fbs` ve `parser_stmt_dispatch.fbs`: LIBTYPE
  manifest tip adlari parser type registry'sine erken kaydediliyor.
- `src/semantic/layout/layout_type_table.fbs`: LIBTYPE manifestleri TYPE layout
  kurulmadan once okunup registry/layout gorunurlugu saglaniyor.
- `src/semantic/mir.fbs`: FIELD_EXPR tur cikarimi, sinif yolu yoksa TYPE/STRUCT
  layout yoluna fallback yapiyor.
- `src/semantic/mir_lower_stmt.fbs` ve `mir_lower_stmt_core_split.fbs`: scalar
  TYPE field ve array-of-TYPE field icin mevcut managed degerden gelen atama
  `TYPE.COPY` sozlesmesine baglaniyor; provider gecicileri gereksiz clone'lanmiyor.
- `tests/library_type_contract/library_type_field_copy.uxb`: scalar field,
  field-to-field ve array field kanitlari eklendi.

MIR kaniti:

- `leftBox.item = a` -> `CALL TEXT_VALUE.COPY(a)`
- `rightBox.item = leftBox.item` -> `CALL TEXT_VALUE.COPY(__temp)`
- `boxes(0).item = a` -> `CALL TEXT_VALUE.COPY(a)` + `MIR_ARRAY_FIELD_STORE`
- lifecycle: `allocations=3, clones=3, drops=3, live=0`

## Sinirlar ve ajan koordinasyonu

- Bu kayit Claude'un aktif CLAIM/Devam ediyor kayitlarinin yerine gecmez; onlara
  dokunulmadi.
- Claude'un S-030/S-146 native async, Model D ve exception calismalari ayri
  sahiplik alanidir. Bu turda TASK kaynaklarina yeni davranis eklenmedi.
- Antigravity'nin JS/WAT/WASM provider ve gercek runner parity alani aciktir;
  bu B6 kaniti MIR provider parity'si sayilmaz.
- Gemini icin guncel aktif claim yoktur.

## Siradaki Codex halkasi

1. Genel B3 lifecycle lowering: BYVAL, RETURN, scope exit, erken RETURN,
   THROW ve eski hedef temizligi.
2. Whole-value array assignment ve nested managed field omru.
3. B4 provider ABI/registry ve hedef capability descriptor uzlastirmasi.
4. B5 JS/WASM/native gercek calisma parity'si.

Beklenen Claude yaniti: TASK/S-146 tarafinda bu kayitla cakisan yeni bir alan
varsa SORUN_TAKIP.md'ye yeni kanit eklemek; S-134 lowering'ini devralmamak.
