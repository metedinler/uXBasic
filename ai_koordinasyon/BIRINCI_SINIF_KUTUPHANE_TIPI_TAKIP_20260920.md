# Birinci Sinif Kutuphane Tipi Takip Notu

Tarih: 2026-09-20
Sahiplik: Mete karar sahibi; Codex/Claude uygulama ve kanit sorumlulari is bazinda ayrilir.

## Ana Karar

uXBasic yeni matematiksel, bilimsel, sistem ve AI tiplerini varsayilan olarak
cekirdek tiplerine eklemeyecek. Once su soru sorulacak:

```text
Birinci sinif kutuphane tipi sistemi bu tipi cekirdegi degistirmeden ifade edebiliyor mu?
```

Hayir cevabi gelirse, o tipe ozel cekirdek eklentisi yapmadan once eksik genel
yeteneğin ne oldugu bulunacak.

## Sozlesme Bilesenleri

Bir kutuphane tipi asagidaki bilgileri bildirir:

- veri yerlesimi: size, align, stride, field/dynamic payload,
- operator yuzeyi: ADD/SUB/MUL/DIV/EQ/CMP ve hedefe ozgu genislemeler,
- MAGIC davranis: TOSTRING, CLONE, HASH, ITER, INDEX, CALL,
- donusumler: cast ve implicit/explicit uyumluluk,
- yasam dongusu: constructor/destructor/copy/clone/ownership,
- ABI: by value, by ref, pointer, array-view, JS handle, WASM linear memory,
- MIR davranisi: canonical TYPE_OP veya dogrudan CALL lowering,
- native hizlandirma: opsiyonel x64/C ABI/JS/WASM provider.

## Iliskili Belgeler

- `docs/tasarim/UXB_BIRINCI_SINIF_KUTUPHANE_TIPI_TASARIM_PAKETI_20260920_TR.md`
- `docs/tasarim/UXB_TASARIM_KUTUPHANE_TIPI_CEKIRDEK_TIPI_AYRIMI_20260920_TR.md`
- `docs/tasarim/UXB_TASARIM_JS_WASM_KUTUPHANE_TIPI_BACKENDLER_20260920_TR.md`
- `docs/tasarim/UXB_TASARIM_UBASIC_UXBASIC_TIP_SISTEMI_KARSILASTIRMA_20260920_TR.md`
- `docs/tasarim/UXB_TASARIM_TYPED_POINTER_VE_RAW_PTR_20260920_TR.md`
- `docs/tasarim/UXB_TASARIM_6502_ADRESLEME_VE_PTR_ARITMETIGI_20260920_TR.md`

## Acik Izleme Maddeleri

- S-096: Dizi parametresi dort motor kapandi; kalan WAT/WASM/TYPE-dizi sinirlari S-100, S-102 ve S-103 altinda izleniyor.
- S-112: Birinci sinif kutuphane tipi manifest/registry ilk kod halkasi eklendi; `RATIONAL + RATIONAL` type-binding ve canonical MIR lowering halkasi `CALL RATIONAL.ADD` olarak kanitlandi. 2026-09-21'de MIR provider/runtime aritmetigi ve karsilastirma ailesi de kanitlandi: `ADD/SUB/MUL/DIV/EQ/GT` ornekleri canonical-MIR yorumlayicida calisiyor. JS/WASM/native yurutme henuz acik.
- S-113: Raw `PTR` ile `PTR TO T` typed pointer ayrimi henuz dil yuzeyi degil.
- S-114: JS/WASM hedef bagimsiz kutuphane tipi ABI/manifest sozlesmesi yok.
- S-115: UBASIC'ten gelen RATIONAL/COMPLEX/POLYNOMIAL icin cekirdeksiz ilk kutuphane tipi paketi yok.

## Uygulama Sirasi Onerisi

1. Var olan `TYPE`/`CLASS`/`MAGIC`/operator metadata yuzeyini envanterle.
2. `LIBTYPE` veya mevcut `CLASS` uzerinden manifest bicimini kararlastir.
3. `RATIONAL` icin pure BASIC/MIR referans paketini yaz.
4. `a + b` -> `TYPE_OP ADD` veya `CALL RATIONAL.ADD` canonical lowering kuralini olc. (2026-09-20: `CALL RATIONAL.ADD` yolu kanitlandi.)
5. JS/WAT/WASM icin ayni referans tipin provider/handle/linear-memory davranisini kanitla.
6. Native x64 hizlandirma yalniz bu referans yol yesil olduktan sonra eklenir.

## 2026-09-20 Kod Halkasi

`src/semantic/library_type_contract.fbs` eklendi. Bu dosya `UXBLibraryTypeContract`
sozlesmesini, registry fonksiyonlarini ve referans `RATIONAL` manifestini tasir.
`src/semantic/type_binding.fbs`, `src/parser/parser/parser_shared.fbs` ve
`src/semantic/semantic_gate_orchestrator.fbs` icinden ana semantic zincire baglandi.

Kanıt:

- `tests/library_type_contract/test_library_type_contract.bas` FreeBASIC ile derlendi ve `PASS library_type_contract RATIONAL manifest` verdi.
- Zorlanmis ana derleyici build'i FreeBASIC derleme/link asamasini gecti ve `bin/uxb.exe` guncellendi.
- `bin/uxb.exe sem tests/library_type_contract/rational_decl_semantic.uxb` exit `0`.
- `bin/uxb.exe run tests/library_type_contract/rational_decl_semantic.uxb` -> `RATIONAL_DECL_OK`.

Operator/type-binding halkasi: `tests/library_type_contract/rational_add_contract.uxb`
icindeki `c = a + b` artik semantic geciyor ve canonical MIR full JSON'da
`opcode:"CALL"`, `type:"RATIONAL"`, `operands:["RATIONAL.ADD","a","b"]` olarak
gorunuyor. `bin/uxb.exe run tests/library_type_contract/rational_add_contract.uxb`
-> `RATIONAL_ADD_OK`. Taze `bin/uxb.exe` SHA256:
`376E164DF5953B979282AC4F018BADE514AEB13BB59A21214E971CDCE3B1E162`.

Kalan S-112 halkasi: `RATIONAL.ADD` icin gercek provider/pure-MIR aritmetigi,
JS/WAT/WASM ve native hedeflerde yurutme kaniti, hata kapisi ve dogruluk testleri.

## 2026-09-21 MIR Provider Halkasi

Ilk gercek provider/runtime kaniti eklendi. Yeni test:
`tests/library_type_contract/rational_mir_add_value.uxb`.

Kaynak davranis:

```basic
DIM a AS RATIONAL
DIM b AS RATIONAL
DIM c AS RATIONAL
a = 1
b = 2
c = a + b
PRINT c
```

Kanıt:

- `bin/uxb.exe sem tests/library_type_contract/rational_mir_add_value.uxb` exit `0`.
- `bin/uxb.exe mir tests/library_type_contract/rational_mir_add_value.uxb --mir-full-json-out tmp/rational_mir_add_value_full_final.json` exit `0`.
- Full JSON: global tipler `RATIONAL`; `CALL RATIONAL.ADD` sonucu `type:"RATIONAL"`; `instruction_to_type_missing:0`.
- `bin/uxb.exe run tests/library_type_contract/rational_mir_add_value.uxb --interpreter-backend MIR --mir-exec-result-json-out tmp/rational_mir_add_value_exec_final.json` -> stdout `3/1`, status `PASS`.
- FreeBASIC unit: `tests/library_type_contract/test_library_type_contract.bas` -> `PASS library_type_contract RATIONAL manifest`.
- Taze `bin/uxb.exe` SHA256: `E8622B2397A62214F1A3D2ABC35928BAF895A96533A78CCC4928A3366186BC16`.

Kod notu:

- Integer -> `RATIONAL` implicit assignment `FROM_I64` sozlesmesiyle kabul edilir.
- `RATIONAL` runtime payload'i simdilik normalize `n/d` metnidir; bu referans yol, gercek ABI/layout hizlandirmalarindan once dogruluk saglamak icindir.
- Canonical MIR sozlesmesi hedeflerden bagimsizdir: backendler `RATIONAL` primitive'i eklemek yerine `CALL RATIONAL.ADD` / ileride `TYPE_OP ADD,RATIONAL` sozlesmesini tuketmelidir.

Antigravity icin JS/WAT/WASM devralma notu:

- JS/WASM tarafinda cekirdege ozel `RATIONAL` primitive eklenmeyecek.
- Ilk hedef, canonical `CALL RATIONAL.ADD(a,b)` kaydini manifestteki `jsPolicy=pure_mir`, `wasmPolicy=wasm_linear_memory` bilgisiyle calistirmak veya bilincli fail-closed tani uretmektir.
- AST/canonical-MIR referans cikti `3/1` kabul kanitidir.

## 2026-09-21 Operator Ailesi Devami

`RATIONAL` provider `SUB/MUL/DIV/EQ/NE/LT/LE/GT/GE` ailesine genisletildi.
Manifest destek listesi `EQ,NE,LT,LE,GT,GE,CMP` ile guncellendi; boylece
`c > b` gibi ifadeler normal integer `GT` opkoduna dusmek yerine library type
operator sozlesmesine iniyor.

Kanıt:

- `tests/library_type_contract/rational_mir_ops_value.uxb` -> `2/1`, `24/1`, `3/2`.
- `tests/library_type_contract/rational_mir_compare_value.uxb` -> `EQ`, `GT`.
- Full MIR cagri kaniti: `CALL RATIONAL.EQ a b : BOOLEAN` ve `CALL RATIONAL.GT c b : BOOLEAN`.
- FreeBASIC unit: `PASS library_type_contract RATIONAL manifest`.
- Taze `bin/uxb.exe` SHA256: `71245DDF4FFF2B9EB42648C25FDA07CB13208F4A2B62F914BB360EA26F114050`.

Antigravity icin guncel devralma: JS/WAT/WASM hedefleri artik yalniz
`RATIONAL.ADD` degil, ayni canonical `CALL RATIONAL.<OP>` ailesini
(`ADD/SUB/MUL/DIV/EQ/NE/LT/LE/GT/GE`) tuketmeli veya desteklenmeyen operator
icin fail-closed tani uretmelidir.

## 2026-09-21 Registry Dispatch Esigi

MIR provider girisi artik dogrudan `RATIONAL.` prefix kontroluyle baslamiyor.
`UXBLibraryTypeFindCallOwner` ve `UXBLibraryTypeResolveCallName` ile once
canonical call adinin kayitli bir library type'a ait olup olmadigi, sonra da
member'in manifestte operator/magic olarak tanimli olup olmadigi denetleniyor.
Bu, sonraki `COMPLEX` / `POLYNOMIAL` / `MATRIX` provider'lari icin ayni
dispatch girisini kullanma yolunu acar.

Fail-closed kural:

- Kayitli olmayan `FOO.BAR` cagrisina dokunulmaz; normal CALL yollari devam eder.
- Kayitli library type'a ait ama manifestte olmayan `RATIONAL.BOGUS` gibi cagri
  sessiz fallback yapmaz; `library type member not declared` hatasina gider.
- Provider'i olmayan kayitli tip/member icin sonraki hedef `library type provider missing`
  tanisini standartlastirmaktir.

Kanıt:

- FreeBASIC unit: `PASS library_type_contract RATIONAL manifest`.
- `rational_mir_add_value.uxb` -> `3/1`.
- `rational_mir_ops_value.uxb` -> `2/1`, `24/1`, `3/2`.
- `rational_mir_compare_value.uxb` -> `EQ`, `GT`.
- Full MIR cagri kaniti degismedi: `CALL RATIONAL.EQ a b : BOOLEAN`, `CALL RATIONAL.GT c b : BOOLEAN`.
- Taze `bin/uxb.exe` SHA256: `961715481AE5FD31AF4636CADB273502D83CD04046C7EAA692A95DCF568BB3C7`.

## 2026-09-21 Provider Adi Manifest Alani

Sozlesmeye hedefe ozel provider adlari eklendi:

- `mir_provider`
- `js_provider`
- `wasm_provider`
- `native_provider`

RATIONAL referansi su provider adlarini tasiyor:

- MIR/JS: `RATIONAL_REFERENCE`
- WASM: `RATIONAL_LINEAR_MEMORY_REFERENCE`
- native: `RATIONAL_X64_REFERENCE`

MIR dispatch artik `typeName = RATIONAL` kararina degil, manifestteki
`mirProvider` alanina bakiyor. Bu, bir sonraki tiplerin ayni registry girisini
kullanip kendi provider adina ayrilabilmesi icin ilk somut adimdir.

Kanıt:

- FreeBASIC unit provider alanlarini ve JSON'daki `mir_provider` bilgisini dogruluyor.
- ADD/ops/compare canonical-MIR yorumlayici testleri yeniden gecti.
- Full MIR cagri kaniti degismedi: `CALL RATIONAL.EQ a b : BOOLEAN`, `CALL RATIONAL.GT c b : BOOLEAN`.
- Taze `bin/uxb.exe` SHA256: `24C65A0E64654DD3F635D1FEA6DA1E8895B55A7BFE2234B11084D5C83784D884`.

## 2026-09-22 Harici Manifest Dosyasi Halkasi

Ilk dosya tabanli manifest yukleme halkasi eklendi. Sozlesme artik
`uxb.library_type.contract.v1` JSON metnini okuyup `UXBLibraryTypeContract`
kaydina cevirebiliyor ve registry'ye kaydedebiliyor.

Yeni API:

- `UXBLibraryTypeContractFromJson`
- `UXBLibraryTypeRegistryRegisterJsonText`
- `UXBLibraryTypeRegistryLoadManifestFile`

Test manifesti:

- `tests/library_type_contract/rational_external_manifest.json`

Notlar:

- `UXBLibraryTypeContractToJson` cikti semasina `conversions` ve `lifecycle`
  alanlari eklendi; dis manifestten yuklenen tip implicit donusum bilgisini
  kaybetmiyor.
- Bu halka henuz otomatik paket kesfi veya CLI yuzeyi degildir; cekirdek
  manifest okuma/validate/register kanitidir.
- Sonraki halka: manifest dosyalarini moduller/paket klasorleri uzerinden
  derleme akisine baglamak.

Kanıt:

- FreeBASIC unit: `PASS library_type_contract RATIONAL manifest`.
- Dosyadan yuklenen manifest `FROM_I64`, `RATIONAL.GT -> BOOLEAN`, provider
  adlari ve status/package alanlariyla dogrulandi.
- ADD/ops/compare canonical-MIR yorumlayici testleri yeniden gecti.
- Full MIR cagri kaniti degismedi: `CALL RATIONAL.EQ a b : BOOLEAN`,
  `CALL RATIONAL.GT c b : BOOLEAN`.
- `git diff --check` temiz.
- Taze `bin/uxb.exe` SHA256: `9BC0CBD826A21CE9D69169556A1FAC49238F05680D96C52FD62FF6EB1CC168B5`.

## 2026-09-22 Kaynak Yuzeyi / LIBTYPE Halkasi

Manifest dosyalarini normal `INCLUDE` ile baglamanin yanlis model oldugu
dogrulandi: preprocessor JSON dosyasini kaynak metne actigi icin lexer `{` ve
`}` uzerinde duruyor. Library type manifesti kaynak genisletmesi degil, derleme
sozlesmesi oldugundan yeni dar deyim eklendi:

```basic
LIBTYPE "tests/library_type_contract/rational_external.library_type.json"
```

Eklenen yuzey:

- Lexer keyword tablosu `LIBTYPE`i taniyor.
- Statement registry/dispatch `LIBTYPE`i parser'a bagliyor.
- Parser yalniz guvenli `.library_type.json` yollarini kabul ediyor.
- Semantik kapida `TypeBindingInit` sonrasinda manifest registry'ye yukleniyor.

Yeni test:

- `tests/library_type_contract/rational_external.library_type.json`
- `tests/library_type_contract/rational_include_manifest_semantic.uxb`

Kanıt:

- FreeBASIC unit: `PASS library_type_contract RATIONAL manifest`.
- `sem rational_include_manifest_semantic.uxb` exit `0`.
- `run rational_include_manifest_semantic.uxb --interpreter-backend MIR` -> `3/1`.
- Full MIR: `global_types` RATIONAL, `CALL RATIONAL.ADD` `type:"RATIONAL"`.
- Önceki ADD/ops/compare testleri degismeden gecti.
- Taze `bin/uxb.exe` SHA256: `5C87D496401CBBDC8F91DABA582DDCA8D75C729CB38C92E394AFAFC757DEEE4D`.

Sonraki halka:

- Manifest yolunu kaynak dosyanin dizinine ve paket arama yoluna gore cozmek.
- Paket klasoru sozlesmesi (`uxmath/manifest.library_type.json` vb.).
- JS/WAT/WASM backendlerinin `js_provider` / `wasm_provider` alanlarini tuketmesi.
- Native provider ve RATIONAL disi ilk referans tip.

## 2026-09-22 Kaynak Dizini / Paket Arama / Fail-Closed Halkalari

`LIBTYPE` manifest cozum sirasi genisletildi:

1. Yazilan yol aynen.
2. `LIBTYPE` deyiminin bulundugu kaynak dosyanin dizini.
3. `manifests\library_types`.
4. `manifests`.
5. `libs`.
6. `include\modules`.

Yeni pozitif testler:

- `tests/library_type_contract/rational_libtype_source_relative.uxb`
  - `LIBTYPE "rational_external.library_type.json"`
  - MIR cikti: `12/1`
- `tests/library_type_contract/rational_libtype_package_search.uxb`
  - `LIBTYPE "uxmath/rational.library_type.json"`
  - Manifest: `manifests/library_types/uxmath/rational.library_type.json`
  - MIR cikti: `13/1`

Negatif/fail-closed testler:

- `rational_libtype_bad_extension.uxb`
  - `.library_type.json` disi manifest parser'da reddediliyor.
- `rational_libtype_missing_manifest.uxb`
  - Semantikte cozulmus yol ile `library type manifest not found` hatasi.
- `rational_libtype_missing_provider_runtime.uxb`
  - Bilinmeyen `mir_provider` icin runtime tanisi:
    `library type provider missing: RATIONAL.ADD via RATIONAL_PROVIDER_NOT_INSTALLED`.

Kanit:

- FreeBASIC unit: `PASS library_type_contract RATIONAL manifest`.
- Explicit manifest test: `3/1`.
- Source-relative manifest test: `12/1`.
- Package-search manifest test: `13/1`.
- Compare regresyonu: `EQ`, `GT`.
- Ops regresyonu: `2/1`, `24/1`, `3/2`.
- `git diff --check` temiz.
- Taze `bin/uxb.exe` SHA256: `CD663C2493D33381A2AEFC75BD085FCC965CBCEFA4F2C4A66D0CBAEFCBCF51FC`.

Sonraki halka:

- `LIBTYPE` yüklenen manifestlerin derleme raporuna JSON olarak yazılması.
- Paket manifest standardinin belgeye alinmasi.
- Antigravity icin JS/WAT/WASM provider tuketim kabul testlerinin eklenmesi.

## 2026-09-23 Ust Tasarim Sentezi ve Yeni Halkalar

Yeni ana belge:

- `docs/tasarim/UXB_20260923_SISTEM_TASARIM_KARARLARI_MEVCUT_DURUM_VE_IS_PLANI_TR.md`

Bu belge, paylasilan `UXBasic Bellek Tasarımı` sohbetindeki karar akisini,
20.09 tasarim belgelerini ve canli kod durumunu tek bir ust kayitta toplar.

Guncel kararlar:

- `FOR EACH x IN 10, 20, 30` deger listesi kalir.
- `FOR EACH x IN a, b` ifadesinde `a`/`b` dizi veya koleksiyon gibi iterable
  kaynak adlariysa derleme hatasi dogrudur; cok kaynakli iterasyon ileride
  `CHAIN(a,b,c)` ve `ZIP(a,b)` gibi acik kutuphane iteratorleriyle gelir.
- Genel iterator hedefi `ITER_CREATE/NEXT/CLOSE` MIR sozlesmesidir.
- Library type manifestinde lifecycle/ownership/copy/move/drop kararlari henuz
  yeterince somut degildir; bu yeni acik halka S-134 olarak takip edilir.
- Meta/generator registry, `%%DERIVE`, `%%GEN_BLOCK`, REST/host wrapper/test
  skeleton uretimi gibi yuzeyleri normal uXBasic source uretimi olarak
  birlestirmelidir; bu S-136 olarak takip edilir.

Yeni takip maddeleri:

- S-134: Library type lifecycle / ownership / copy-model sozlesmesi eksik.
- S-135: Genel iterator sozlesmesi, `MAGIC ITER`, `CHAIN` ve `ZIP` yok.
- S-136: Meta/generator registry ve normal-source uretim akisi resmilestirilmedi.

## 2026-09-23 08:02 — Halka B1 Uygulamasi

S-134 ilk dilimi kodlandi: acik storage/copy/clone/drop modelleri, JSON
gidis-donus ve dogrulama, dinamik kaynak sahibi profiller icin semantic destek
kapisi. RATIONAL VALUE/BITCOPY/NONE. Genel tiplerde ADD/TOSTRING mecburiyeti yok.
MIR deger aktarimi (atama, BYVAL, RETURN, kesirli dizi elemani) kanitlandi;
bos eleman/REDIM varsayilani ve integer eleman atamasi duzeltildi.

Kanit: yeni `library_type_contract` paketi 14/14, lifecycle unit 41 kontrol;
`array_params` 63/63. Paket `tests/run_all_model_tests.ps1` listesinde.
Ayrinti: `docs/tasarim/UXB_S134_LIBRARY_TYPE_LIFECYCLE_20260923_TR.md`.
Bu halka MIR referansidir; S-134 tum-motor kapanisi degildir.

Bu paragraf tarihsel ara sirayi kaydeder. Guncel ikilide S-112 erken manifest
tip adi gorunurlugu uygulanmistir; `DYNAMIC_PAYLOAD` parser'dan gecip semantic
lifecycle kapisinda kontrollu reddedilir. Guncel sira: (1) S-134 B3 genel
CLONE/RETAIN/DROP lowering, scope/erken cikis ve gercek sahiplik testleri;
(2) Antigravity'nin JS/WAT/WASM provider parity'si; (3) registry raporu ve
paket standardi.

## 2026-09-25 — Codex/Claude Paylasim ve Yeni Uygulama Plani

Guncel devir kaydi: `ai_koordinasyon/CODEX_CLAUDE_PAYLASIM_20260925_TR.md`.
Yeni uygulama sirasi ve ajan gorevleri:
`ai_koordinasyon/PLAN_BIRINCI_SINIF_KUTUPHANE_TIPI_20260925_TR.md`.

Son ortak baseline: library contract **30/30**, TASK modeli **108/108**.
RATIONAL `VALUE/BITCOPY/NONE` lifecycle cagri vektorleri `COPY/CLONE/TOSTRING`
ile MIR'de kanitlandi. Genel `REFERENCE/RETAIN/PROVIDER`, field/BYREF/escape
omru ve JS/WASM/native provider parity'si acik kaldi. Claude TASK alanini,
Antigravity hedef provider alanini korur; Codex B3 lifecycle lowering halkasini
ustlenir. Aktif CLAIM dosyalari bu kayitla degistirilmez.
