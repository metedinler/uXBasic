# Codex -> Claude/Antigravity Devir: B3/B4 Lifecycle Halkasi

Tarih: 2026-09-29

## Uygulanan kaynak degisiklikleri

- `src/semantic/mir_lower_expr.fbs`: fonksiyon parametre ABI'sinden BYVAL
  managed parametre tespiti, `TYPE.COPY` temporary lowering ve managed RETURN
  transferi eklendi. `CONSTRUCT/COPY/CLONE/RETAIN` sonuclari ikinci kez
  kopyalanmiyor; `NORMALIZE` alias yolu kopyalaniyor.
- `src/semantic/mir_lower_stmt.fbs` ve
  `src/semantic/mir_lower_stmt_core_split.fbs`: expression/statement call ve
  RETURN yollarina lifecycle lowering baglandi.
- `src/interpreter/mir/mir_interp.fbs`: eski implicit BYVAL/RETURN kopyalari
  kaldirildi; canonical MIR lifecycle kararinin tek kaynagi.
- `src/semantic/library_type_contract.fbs`: target-aware
  `UXBLibraryTypeProviderIsRegistered` registry kapisi.
- `src/interpreter/mir/mir_interp_library_type.fbs`: bilinmeyen MIR provider
  icin acik ABI reddi.

## Yeni test

`tests/library_type_contract/library_byval_return.uxb` cagiran degerinin
korundugunu ve managed RETURN sonucunun bagimsiz geldigini kanitlar. Cikti:
`hello`, `HELLO`.

## Taze kabul kaniti

- `tests/library_type_contract/run_library_type_tests.ps1`: **32/32 PASS**
- `tests/exceptions_cross/run_exceptions_cross_tests.ps1`: **20/20 PASS**
- `tests/task_model/run_task_model_tests.ps1`: **192/192 PASS**
- `build_64.ps1`: exit 0
- Binary: `bin/uxb.exe`
- SHA256: `7C5E20BE5EAFFD3F3D3DFA84A446976F6E0D126EA20446BB29D8FF2E81F18008`

## Baglayici sinirlar

- Whole-value array, nested managed field ve genel BYREF/escape matrisi henuz
  kapanmadi.
- Manifest provider version/package/dependency/capability descriptor'i sonraki
  B4 halkasidir.
- Gercek JS/node, WAT/WASM/node ve native x64 lifecycle providerlari yoktur.
  Hedeflerdeki temiz red parity kaniti, calisan provider parity'si degildir.

Claude icin soru: native async/TASK ABI lifecycle transferi explicit MIR
`TYPE.COPY` sozlesmesini nasil tukecek? Antigravity icin soru: JS/WASM provider
descriptor'i capability ve cleanup oracle'ini hangi host/worker ABI ile
ortaklastiracak?

## 2026-09-29 Guncelleme: whole-value array ve scope/THROW kaniti

`src/semantic/mir_lower_stmt.fbs` icindeki ikinci indexed-assignment lowering
yolu da B3/B6 kuralina baglandi. Managed whole-value array store artik
canonical MIR'de `TYPE.COPY` sonrasi `STORE_INDEXED` uretiyor; bu yol onceki
`mir_lower_stmt_core_split.fbs` duzeltmesiyle ayni davranisa sahip.

Yeni probe:
`tests/library_type_contract/library_scope_throw_cleanup.uxb`

Probe, managed yerel degerin erken `RETURN` ve `THROW/CATCH` unwind yollarinda
scope heap tarafindan tam bir kez birakildigini kanitliyor.

Taze kanit:

- `tests/library_type_contract`: **34/34 PASS**
- `tests/exceptions_cross`: **20/20 PASS**
- `tests/task_model`: **192/192 PASS**
- `build_64.ps1`: exit 0
- `bin/uxb.exe` SHA256:
  `591CCB69D5A69647670EB5CBD8159FA6D576B50207033E9DB6912965703FF9FC`

Acik kararlar degismedi: genel manifest provider version/package/dependency/
capability descriptor'i, gercek JS/WASM/native provider implementasyonlari ve
nested managed/BYREF/escape matrisi sonraki halkalardir. Mevcut hedef davranisi
fail-closed'dur; temiz red, provider parity kaniti sayilmaz.

## 2026-09-29 Son ABI guncellemesi

Provider registry artik `target + provider + type` bagini da denetliyor.
`OWNED_TEXT_REFERENCE` yalniz `TEXT_VALUE` ve `TEXT_REF`,
`RATIONAL_REFERENCE` yalniz `RATIONAL` icin kabul ediliyor. Yanlis tip-provider
eslesmesi runtime'a gecmeden `library type provider type mismatch` ile
reddediliyor.

Son build ve kanit:

- `build_64.ps1`: exit 0
- `tests/library_type_contract`: **34/34 PASS**
- `tests/exceptions_cross`: **20/20 PASS**
- `tests/task_model`: **192/192 PASS**
- `bin/uxb.exe` SHA256:
  `0E505C88F68AC95D30A5168E1E5645807097DA6C4D7AB17D11BD4E7B254D4993`
