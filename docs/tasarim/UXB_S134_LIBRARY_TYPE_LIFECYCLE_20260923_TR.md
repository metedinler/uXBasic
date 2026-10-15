# S-134: Kutuphane Tipi Yasam Dongusu, Halka B1

Tarih: 2026-09-23. Uygulama sahibi: Codex.
Ust plan: `UXB_20260923_SISTEM_TASARIM_KARARLARI_MEVCUT_DURUM_VE_IS_PLANI_TR.md`, Halka B.

## Uygulanan Sozlesme

`uxb.library_type.contract.v1` manifesti artik asagidaki dort alani tasir.
Alan degerleri buyuk/kucuk harften bagimsiz dogrulanir; yazici mevcut yazimi korur.

| Alan | Kabul edilen degerler | Anlam |
|---|---|---|
| `storage_model` | `value`, `reference` | Bagimsiz deger veya paylasilabilen referans semantigi |
| `copy_model` | `bitcopy`, `clone`, `retain`, `forbidden` | Atama, BYVAL parametre ve deger aktarimi politikasi |
| `clone_model` | `bitcopy`, `provider`, `unsupported` | Acik kopyalama isleminin sozlesmesi |
| `drop_model` | `none`, `provider` | Degerin omru bittiginde gereken temizlik |

Bu adlar ilk uygulanmis alt kume olup ust belgede tartisilan MOVE_ONLY/COW
politikalarinin tamamlandigi anlamina gelmez. `forbidden` ortuk kopyayi kapatir;
kendi basina MOVE sozdizimi veya tasinmis-deger denetimi saglamaz. Handle fiziksel
temsildir; tek basina sahiplik politikasi sayilmaz. `layout` ve ABI alanlariyla,
`value/reference` ise gozlemlenebilir davranisla ilgilidir.

RATIONAL referans manifesti:

```json
{
  "storage_model": "value",
  "copy_model": "bitcopy",
  "clone_model": "bitcopy",
  "drop_model": "none"
}
```

RATIONAL'in mantiksal verisi iki I64'tur. Buradaki BITCOPY, iki degerin birbirini
degistirmeden ayni sayiyi tasimasidir. Yorumlayicinin `UXBInterpValue` icindeki
yonetilen String payload'i ham `memcpy` ile kopyalanmaz; FreeBASIC'in normal deger
atamasi kullanilir. Native kayit ve JS/WASM temsili kendi hedeflerinin ayni
gozlemlenebilir sonucunu saglamak zorundadir.

## Dogrulama Kurallari

- `copy_model=bitcopy` yalniz `value` ve `drop_model=none` ile gecerlidir.
- `clone_model=bitcopy` de kaynak temizligi gerektirmeyen degerle sinirlidir.
- `copy_model=clone`, `clone_model=provider` gerektirir.
- Provider clone icin `lifecycle` veya `magic` listesinde `CLONE` bulunmalidir.
- `retain`, `reference` + provider drop + `RETAIN` lifecycle uyesi gerektirir.
- Provider drop icin `lifecycle` listesinde `DROP` bulunmalidir.
- Bilinmeyen, eksik, yanlis tipte veya birbiriyle celisen alanlar reddedilir.
- Gecersiz kayit mevcut registry girdisinin uzerine yazilmaz.

Genel tip dogrulayicisi artik her tipe ADD ve TOSTRING zorunlulugu yuklemez.
Ornegin kaynak sahibi bir veri tutamaci aritmetik operator olmadan tanimlanabilir.
Bir islemin kullanilabilirligi kendi operator/magic/lifecycle bildirimiyle
cozulur. Bu degisiklik sayisal olmayan birinci sinif tipler icin gereklidir.

`UXBLibraryTypeResolveCallName`, bildirilen lifecycle uyelerini de cozer:
`CONSTRUCT/NORMALIZE/COPY/MOVE/CLONE/RETAIN` tipin kendisini, `DROP` ise `VOID`
sonucunu tasir. Bu, metadata cozumudur; provider govdesi, kaynak cagrisi veya
otomatik scope-exit cagrisi uygulanmis sayilmaz.

## Eski Manifestler

Dort alanin hic bulunmadigi eski v1 manifestler metadata olarak okunabilir.
Model alanlari `unspecified` kalir; okuyucu sahiplik tahmini yapmaz. Bu manifestler
`LIBTYPE` ile programda kullanilmak istendiginde lifecycle tanisi alir. Calisan
RATIONAL paket/test manifestleri dort acik alanla guncellendi. Eski
`rational_external_manifest.json` dosyasi geriye donuk okuma testi olarak korundu.

## Gercek Calisma Siniri

Bu halkada otomatik aktarim uygulanmis profil VALUE/BITCOPY/NONE'dir. Genel
CLONE/RETAIN/DROP lowering henuz yoktur. Dogru bildirilmis bir dinamik payload
manifesti registry'ye metadata olarak alinabilir; program tarafindaki LIBTYPE
kapisi `library type lifecycle lowering unavailable` tanisiyla durur. Bu gecici
kisit ortak semantik kapidadir; ileride lowering destegi geldikce ayni yetenek
kapisi genisletilmelidir.

Kanonik MIR yorumlayicisinda:

- `b=a`, bagimsiz deger kopyasidir; sonraki `a` atamasi `b`yi degistirmez.
- Varsayilan BYVAL parametresinin yeniden atanmasi cagiranin degerini degistirmez.
- `RETURN` yerel RATIONAL'in payload'ini cagirana tasir.
- Diziye yazilan RATIONAL kaynaginin yeniden atanmasi elemani degistirmez.
- Dizi elemanina integer atama, elemanin bildirilmis tipine donusturulur.
- Bos eleman `0/1` verir. REDIM PRESERVE eski elemanlari korur; yeni elemanlar
  yine `0/1` olur. REDIM, preserve olmadan bu varsayilana doner.

Son uc madde `interp_heap.fbs` icindeki kayitli kutuphane tipi sorgusuna
baglidir. Heap koduna RATIONAL adina ozel yeni bir dal eklenmedi; mevcut
tip varsayilani/donusum yolu kullanildi.

## Kabul Testleri

`tests/library_type_contract/run_library_type_tests.ps1` birim testlerini
derler, MIR programlarini calistirir, negatif tanilari kontrol eder ve
`reports/library_type_contract/results.json` raporunu uretir. `-Compiler`
veya `-Uxb` ile izole derleyici secilebilir. Paket ortak
`tests/run_all_model_tests.ps1` listesine `library_type_contract` adiyla eklendi.

`test_library_type_lifecycle.bas`: 41 sozlesme kontrolu; referans ve kaynak
sahibi deger modeli, eksik hook, gecersiz kombinasyon, JSON gidis-donus,
eski manifest, registry atomikligi ve destek kapisi.

`rational_value_transfer.uxb`: `3/1, 3/1, 4/1, 3/1, 4/1, 9/1`.

`rational_fraction_transfer.uxb`: `3/2, 3/2, 0/1, 5/1, 3/2, 0/1, 0/1`.

`neg_dynamic_payload_lifecycle.uxb`: gecerli REFERENCE/RETAIN/PROVIDER
metadata'si, derlemede lifecycle lowering tanisiyla reddedilmeli.

## Sonraki Halka

Taze derleyiciyle kabul sonucu: paket **14/14**, lifecycle unit **41 kontrol**,
`array_params` regresyonu **63/63**. Raporlar
`reports/library_type_contract/results.json`, `lifecycle_suite_summary.md`
ve `model_suite_summary.md` altindadir. Sonuncusu ilk turdaki uc test beklentisi
sorununu da saklar; duzeltilen beklentilerle yeni paket tekrar 14/14 gecmistir.
Ana `bin/uxb.exe` ve izole `bin/uxb_s134.exe` SHA256:
`EB94D0D16CDBD4BBAF3E88D8ECDDB7F7CE91B2B9BE5ED0E27C25256C2E02989D`.

Yeni S-112 bagimliligi: LIBTYPE bildirimi sonrasinda
`DIM payload AS DYNAMIC_PAYLOAD` parser'da `unknown type: DYNAMIC_PAYLOAD`
ile durur. Manifest su an semantic asamada yuklendigi icin, parser'in yeni tip
adini onceden bilmesi gereken yol eksiktir. RATIONAL'in referans kaydi bu
eksigi gostermiyordu. B2'den once genel manifest tip-adi gorunurlugu cozulmeli;
bu turdaki negatif test yalniz manifestin yuklenme kapisini sinar.

S-134 kapanmadi. B2'de CLONE/RETAIN/DROP hook cagri imzalari, atama sirasinda
eski hedefin temizligi, gecici degerler, fonksiyon donusu ve erken cikis/hata
yollarindaki sahiplik aktarimi canonical MIR'e baglanacak. Kaynak tahsis/serbest
birakma sayacli gercek dinamik payload provider'iyle cift DROP, sizinti ve
alias testleri eklenecek. Ardindan AST ve en az bir uretilen hedefte ayni
sonuclar olculmeden S-134 kapatilmayacak.

Antigravity icin: bu dort manifest alani JS/WAT/WASM provider sozlesmesinin
parcasidir. JS nesnesini veya WASM adresini kopyalamak tek basina VALUE
semantigini kanitlamaz; yukaridaki kesirli deger aktarimi testleri hedeflerde de
aynen gecmelidir. B1'in MIR kaniti, diger hedeflerin tamamlandigi iddiasi degildir.

## 2026-09-25 Guncel Uygulama Notu

Onceki metindeki ilk kabul sayilari tarihsel kayittir. Taze `bin/uxb.exe` ile
`tests/library_type_contract/run_library_type_tests.ps1` toplam **30/30**
gecmistir. `RATIONAL_REFERENCE` MIR saglayicisi, kendi manifestinde ilan edilen
`VALUE/BITCOPY/NONE` sozlesmesine uygun olarak `CLONE`, `COPY` ve `TOSTRING`
lifecycle cagri vektorlerini destekler; `RETAIN` ve `DROP` RATIONAL manifestinde
ilan edilmedigi icin kaynak yuzeyinde kabul edilmez. Bu genisletme cekirdege
RATIONAL icin yeni tip dali eklemez; manifest/provider sozlesmesinden gelir.

Manifest tip adinin parser'da erken gorunurlugu de guncel ikilide uygulanmistir;
`DYNAMIC_PAYLOAD` artik parser unknown-type hatasi yerine semantic lifecycle
kapisinda kontrollu reddedilir. Bu kabul sonucu genel S-134'u kapatmaz.
`REFERENCE/RETAIN/PROVIDER`, alan/BYREF/
escape omru, genel CLONE/RETAIN/DROP lowering'i ve gercek JS/WASM/native
provider parity'si ayri uygulama ve regresyon kaniti ister.

## 2026-09-27 B6 Alan Kopyasi Kaniti

Parser/layout duzeltmesiyle `LIBTYPE` manifestindeki tip adlari, parser'in TYPE
alanlarini kurdugu asamada da gorunur hale getirildi. `MIRTryInferExprTypeName`
sinif uye aramasini basarisiz biraktiginda `TypeLayoutResolvePath` fallback'ine
basvuruyor; boylece `TYPE BOX : ITEM AS TEXT_VALUE` gibi kayit alanlari da
manifest/provider sozlesmesine baglaniyor.

`tests/library_type_contract/library_type_field_copy.uxb` su uc yolu birlikte
olcer:

1. scalar TYPE field: `leftBox.item = a`
2. field-to-field: `rightBox.item = leftBox.item`
3. array-of-TYPE field: `boxes(0).item = a`

Ilk iki yol canonical MIR'de `TEXT_VALUE.COPY`, ucuncu yol ise `TEXT_VALUE.COPY`
sonrasi `MIR_ARRAY_FIELD_STORE` uretir. Taze ortak ikiliyle provider sayaci
`allocations=3, clones=3, drops=3, live=0`; cikti `hello / hello / hello` ve
`library_type_contract` **31/31 PASS** oldu.

Bu kanit B6 alan kopyasi halkasini kapatir; genel S-134 hala kapanmis degildir.
Whole-value array assignment, nested managed fields, BYREF/escape omru,
FUNCTION/SUB parametre-donus transferi, scope/throw cleanup, genel
`RETAIN/DROP`, provider ABI ve JS/WASM/native provider parity'si sonraki B3-B5
halkalaridir.

## 2026-09-29 B3/B4 Uygulama Kaniti

Managed default BYVAL parametre ve RETURN ifadeleri canonical MIR'de explicit
`TYPE.COPY` transferine indirgenir. `CONSTRUCT`, `COPY`, `CLONE`, `RETAIN`
transferleri ikinci kez kopyalanmaz; `NORMALIZE` alias yolu kopyalanir. MIR
interpreter'daki implicit BYVAL/RETURN kopyalari kaldirildi.

Scope cikisinda refcount drop, THROW/CATCH gecisinde mevcut exception pass
kullanilir; sentetik ikinci DROP yoktur. Provider registry su an yalniz MIR
providerlarini kaydeder. Kanit: library 32/32, exception 20/20, task 192/192.
JS/WASM/native provider parity'si acik ve fail-closed'tur.

## 2026-09-29 B3/B4/B6 Guncel Kanit

Whole-value managed array atamasinin iki MIR lowering yolu da ayni sozlesmeye
baglandi: hedef dizi elemani yazilmadan once `TYPE.COPY`, ardindan
`STORE_INDEXED`. Erken `RETURN` ve `THROW/CATCH` icin managed yerel deger
cleanup probe'u eklendi; scope heap her payload'i bir kez birakti.

Taze ortak binary ile `library_type_contract` **34/34**, `exceptions_cross`
**20/20**, `task_model` **192/192** ve `build_64.ps1` exit 0 verdi.
`bin/uxb.exe` SHA256:
`591CCB69D5A69647670EB5CBD8159FA6D576B50207033E9DB6912965703FF9FC`.

Bu kanit genel provider parity'si degildir. Manifest provider version,
package/dependency/capability alanlari; gercek JS/WASM/native providerlari;
nested managed field ve BYREF/escape omru halen aciktir. JS/WASM/native
hedefleri su anda provider yoklugunu kontrollu reddeder.

## 2026-09-29 Provider ABI tipi kaniti

MIR provider registry yalniz provider adini degil, provider'in destekledigi
statik tip bagini da denetler. `OWNED_TEXT_REFERENCE` icin `TEXT_VALUE` ve
`TEXT_REF`, `RATIONAL_REFERENCE` icin `RATIONAL` kabul edilir; uyumsuz bag
`library type provider type mismatch` ile fail-closed reddedilir.

Son ortak binary `0E505C88F68AC95D30A5168E1E5645807097DA6C4D7AB17D11BD4E7B254D4993`;
library **34/34**, exception **20/20**, task **192/192**, build exit 0.
