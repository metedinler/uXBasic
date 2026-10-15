# uXBasic Birinci Sinif Kutuphane Tipi Uygulama Plani

Tarih: 2026-09-25
Karar sahibi: Mete
Teknik koordinasyon: Codex
Paydaslar: Claude, Antigravity, Gemini

## Amac

Yeni matematiksel, bilimsel, grafiksel veya yapay zeka tiplerini derleyici
cekirdeğine ozel `IF type = ...` dallari eklemeden ifade edebilmek.

Birinci sinif kutuphane tipi su sozlesmeyi tek descriptor/manifest altinda
tasir:

`layout + operators + MAGIC + conversions + lifecycle + ABI + canonical MIR + optional native provider`

## Mevcut Baseline

- Manifest/registry/provider metadata: uygulandi.
- RATIONAL manifest, operator baglama ve canonical MIR provider: uygulandi.
- S-148 DIM initializer tipi: uygulandi.
- `TASK OF T` ve canonical MIR TASK senkron referans halkasi: uygulandi.
- Library contract paketi: **30/30 PASS**.
- TASK modeli: **108/108 PASS**.
- Taze binary: `bin/uxb.exe`, SHA256
  `FF4ECFAB6633308E83CE882EFF3A06232B732D1532A2DF625ADC1A6A32208852`.

## Siradaki Uygulama Halkalari

### B3 - Genel lifecycle lowering

Kapsam:

- `COPY`, `CLONE`, `RETAIN`, `DROP` icin canonical MIR cagri sozlesmesi.
- Atama, BYVAL parametre, FUNCTION/SUB argumani ve RETURN.
- Dizi elemani, field store/load ve gecici degerler.
- Scope cikisi, erken RETURN, THROW/hata ve cift DROP engeli.
- Allocation/clone/drop/live sayaclariyla fail-closed kabul vektorleri.

Kural: Manifestte hook ilan edilmis olsa bile provider yoksa temiz semantic veya
MIR runtime reddi verilir; sessiz bit-copy veya sahte provider kabul edilmez.

### B4 - Provider ABI ve registry

- Manifest provider adi ile gercek provider kaydinin birebir eslesmesi.
- Provider surumu, paket adi ve bagimliliklar.
- MIR, native, JS ve WASM provider yetenek matrisinin ayni descriptor'dan
  uretilmesi.
- `RATIONAL` referans yolu geriye donuk kabul olarak korunur.

### B5 - Hedef parity

Ayni kaynak ve ayni lifecycle oracle'i:

1. canonical MIR
2. native x64
3. JS/node
4. WAT/WASM/node

Desteklenmeyen hedefte emit basarisi yeterli sayilmaz; gercek calisma yoksa
acik ve hedef-adli red gerekir.

### B6 - Alan ve omur kabul vektoru

Ilk sahte ama gercek providerli managed tip `TEXT_VALUE` benzeri bir tip ile:

- field clone/drop
- BYREF yasagi veya acik aktarim kurali
- fonksiyon parametre/donus
- scope cikisi
- hata ortasinda cleanup
- alias ve cift drop

test edilir. Parser tarafinda manifest tip adinin erken gorunurlugu artik
uygulanmistir; `DYNAMIC_PAYLOAD` semantic lifecycle kapisina kadar gelir ve
provider/lifecycle lowering yoksa kontrollu reddedilir. Pozitif provider testi
B3/B4 kapsaminda tasinir.

### B7 - Paketleme ve yeni tipler

Genel sozlesme kanitlandiktan sonra sira:

- `COMPLEX`
- `POLYNOMIAL`
- `MATRIX`
- `VECTOR`
- `TENSOR`
- `UNIT`

Bu tipler cekirdege primitive olarak eklenmez; manifest/provider paketleri
olarak gelir.

## Gorev Dagilimi

| Ajan | Sorumluluk | Baslangic kosulu |
|---|---|---|
| Codex | B3 lifecycle lowering, MIR kabulleri, S-134 defteri | B2 30/30 baseline |
| Claude | TASK/S-030 Faz 2 taslagi, native async ve S-146 karar bagimliliklari | S-146 kararlarinin netlesmesi |
| Antigravity | JS/WASM provider, Worker/host, gercek runner parity | B4 descriptor matrisi |
| Gemini | Bagimsiz inceleme, OOP/collection/lifetime regresyonu | Claim acilmadan koordinasyon kaydi |

## Kapanis Olcutu

Bir halka ancak kaynak yolu, taze binary hash'i, tam komut, cikis kodu,
beklenen/gercek cikti ve bilinen dislamalar ayni kayitta bulunursa kapanir.
Manifestte alan bulunmasi provider'in calistigini kanitlamaz. Emit-only veya
temiz red, gercek hedef calismasi olarak sayilmaz.

## Claude Icin Acik Sorular

1. S-146 D1-D6 kararlarindan hangileri Mete tarafindan kilitlendi?
2. Native Faz 2 TASK ABI'si S-134 lifecycle transferiyle hangi ortak payload
   kurallarini kullanacak?
3. TASK sonucu `TASK OF T` icin JS/WASM hedeflerinde provider yoksa hedef-adli
    temiz red mi, yoksa once referans senkron adaptor mu uygulanacak?

## 2026-09-27 Guncel Uygulama Addendum

Bu ek, onceki tarihsel baseline'i guncel ortak derleyici kanitiyla
uzlastirir; eski sayilar silinmez.

- Taze ortak ikili: `bin/uxb.exe`
- SHA256: `FAE3FEA1A6753BE88CBA2BE50DBAD6902B6CC23483FB53A00268AE32B6977096`
- B6 parser/layout: manifestteki kutuphane tipi adlari parser ve TYPE layout
  tablosuna erken kaydediliyor; TYPE alanlari artik semantik tur cikariminda
  yerlesim tablosundan da cozuluyor.
- B6 scalar field: `leftBox.item = a` ve `rightBox.item = leftBox.item`
  canonical MIR'de `TEXT_VALUE.COPY` cagrilaridir.
- B6 array field: `boxes(0).item = a` canonical MIR'de `TEXT_VALUE.COPY`
  sonrasinda `MIR_ARRAY_FIELD_STORE` ile yazilir.
- Yasam kaniti: alan kopya probe'unda `allocations=3, clones=3, drops=3,
  live=0`; provider sonrasi kaynak yeniden ataninca alan kopyalari bagimsiz
  kalir.
- `tests/library_type_contract`: **31/31 PASS**.
- `tests/task_model`: **192/192 PASS**.

### B6'nin kapanan alt maddeleri

Parser erken gorunurlugu, scalar TYPE field COPY ve array-of-TYPE field COPY
uygulandi ve canonical MIR ile kanitlandi. Bu, genel S-134 kapanisi degildir.

### Hala acik B3/B4/B5 maddeleri

- Genel `CLONE/RETAIN/DROP` lowering: BYVAL/RETURN/scope-exit/erken RETURN/
  THROW ve eski hedef temizligi henuz ortak kurala baglanmadi.
- Dizi elemani whole-value ve nested managed field omru; BYREF/escape yasagi
  veya aktarim kurali henuz genel kabul vektoruyle kapanmadi.
- Provider registry/ABI surumu/packaging ve native/JS/WASM provider parity'si
  tamamlanmadi. `RATIONAL` referans yolu halen MIR kabul yoludur.
- `COMPLEX`, `POLYNOMIAL`, `MATRIX`, `VECTOR`, `TENSOR`, `UNIT` paketleri
  cekirdege eklenmedi; bu bilincli tasarimdir ve B7'ye aittir.

## 2026-09-29 B3/B4 Uygulama Halkasi

BYVAL/RETURN explicit lifecycle lowering ve MIR provider registry uygulandi.
Whole-value indexed array store icin ikinci lowering yolu da explicit
`TYPE.COPY` ile kapatildi; scope `RETURN` ve `THROW/CATCH` cleanup probe'u
eklendi. Kanit: library **34/34**, exception **20/20**, task **192/192**.
JS/WASM/native gercek provider parity'si henuz acik ve fail-closed.

Binary SHA256: `591CCB69D5A69647670EB5CBD8159FA6D576B50207033E9DB6912965703FF9FC`.

### 2026-09-29 B4 ABI sikilastirmasi

Provider kaydi artik hedef, provider ve statik tip birlikte eslesmeden gecmiyor.
`OWNED_TEXT_REFERENCE -> TEXT_VALUE/TEXT_REF` ve
`RATIONAL_REFERENCE -> RATIONAL` baglari kanitlandi; yanlis eslesme fail-closed
runtime tanisi veriyor. Son binary SHA256:
`0E505C88F68AC95D30A5168E1E5645807097DA6C4D7AB17D11BD4E7B254D4993`.
Regresyon: library **34/34**, exception **20/20**, task **192/192**.

### 2026-10-14 B3 kapanis addendum

B3 MIR lifecycle lowering'i kapatildi. Implicit transfer artik manifest
`copy_model` degerinden `CLONE/RETAIN` canonical MIR cagrisi olarak uretiliyor;
explicit `COPY` kaynaktaki provider hook'u olarak ayrik. Function RETURN, END,
uncaught THROW/ASSERT ve exception propagation sentetik RET yollarinda managed
local/BYVAL cleanup `DROP` ile kanitlandi; BYREF alias cleanup disinda.

`tests/library_type_contract` paketi yeni canonical MIR yapisal kontroller ve
propagation fixture'i ile **43/43 PASS** oldu. Yeni tasarim kaydi:
`docs/tasarim/UXB_S134_B3_LIFECYCLE_LOWERING_20261014_TR.md`.

B4 halen aciktir: provider ABI registry'si surum/paket/capability/lifecycle
operation tablosunu target bazinda baglayacak. B3 kapanisi native/JS/WASM
gercek provider parity'si anlamina gelmez.

### 2026-10-14 B4.1 operasyon ABI kapanisi

Provider registry'si artik yalniz provider ve tip degil, gercek operation
uygulamasini da denetliyor. `RATIONAL_REFERENCE` tarafinda uygulanmayan
`RATIONAL.CMP` gibi manifest uyeleri generic MIR fallback'ine dusmeden
`UXB_LIBTYPE_PROVIDER_OPERATION_UNAVAILABLE` ile duruyor. Library paketi
44/44, structured provider tanisi 3/3 PASS.

B4.2 acik: manifest `version/dependencies/capabilities` metadata'sinin target
provider registry ile zorunlu uygunluk solver'i. B5 acik: native/JS/WASM
provider runtime parity'si ve ayni lifecycle oracle'inin hedeflerde gercek
calismasi.

### 2026-10-14 B4.2 capability metadata kapanisi

Explicit `capabilities` bildiren manifestler MIR hedefinde `MIR_PROVIDER`
iddiasini tasimak zorunda. Capability eksigi hedef provider kapisinda ortak
`UXB_LIBTYPE_PROVIDER_UNAVAILABLE` ile reddediliyor; metadata'siz eski
manifestler geriye uyumlu. Library **45/45**, S-499 **8/8**, S-500 **3/3**.

B4.3 acik: package `version/dependencies` alanlarini gercek paket graph'i ve
uygunluk solver'i ile baglamak. B5 acik: native/JS/WASM provider runtime ve
lifecycle/operation parity'si.
