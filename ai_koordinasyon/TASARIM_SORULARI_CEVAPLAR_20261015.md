# Mete'nin 2026-10-15 tasarım soruları: cevaplar ve kayıtlar

Hazırlayan: Claude · Ölçüm referansı: `bin\uxb_kilavuz_20261014_0253.exe`, altı yol (AST, MIR, MIR-x64, eski AST-x64, JS, WAT/WASM) · Yöntem: önce tasarım belgeleri ve kitap, sonra her özellik için **kitapta doğrulanmış bir kontrol programı + özelliği deneyen program** (`tools\kitap\kilavuz_v2\yoklama\vaka_kos.py`, 117 vaka, sekiz parti: 69 + 14 + 6 + 1 + 9 + 8 + 2 + 8; vaka dosyaları `tools\kitap\kilavuz_v2\yoklama\iddia_sorular_20261015\`, ham sonuçlar `docs\kitaplar\_ortak\soru_partisi_20261015\`; her partinin koşusu altı motorda ayrı ayrı yapıldı). Hiçbir derleyici kaynağı değiştirilmedi.

Her bulgu kuralınca ayrı bir `SORUN_TAKIP.md` kaydı oldu (**S-544 … S-564**, 21 yeni kayıt; 7 eski kayda güncelleme notu). Kitap yeniden üretildi (Kılavuz V2: 16 320 satır, 197/197 örnek).

## Bir bakışta

| # | Konu | Tasarım belgesi var mı? | Kitapta var mı? | Kodda ne durumda? | Kayıtlar |
|---|---|---|---|---|---|
| 1 | Bellek tasarımı | ✔ (24.09 belgesi, 20.09 kararları, `spec/NESTED_MEMORY_LAYOUT_SPEC.md`) | ✔ Bölüm 14 (+ yuvalanmış yerleşim bu turda eklendi) | Temel ✔; `PTR TO T`, `ADDR`, kayıt dizisi adresi eksik | S-546 (yeni), S-377, S-391 |
| 2 | 6502 adresleme modları | ✔ (20.09 düşünce deneyi) | ✔ 14.5 (bu turda 13 modun tamamı) | 10 bellek değeri altı yolda birebir ✔; `ADDR` ✖ | S-391, S-545, S-562, S-563 |
| 3 | EVENT/THREAD/PARALEL/PIPE/SLOT ve `DECLARE` | ✔ (24.09 görev tasarımı) | ✔ Bölüm 15, 8.5 | Bloklar ✔ (AST, MIR, x64); `DECLARE` kuralı **denetlenmiyor** | S-544, S-545, S-395 |
| 4 | Dosya kanalı: değişken / `TYPE` ile tutamaç | kısmen (`FILE_HANDLE` kanonik tip) | ✔ 13.2 (bu turda genişledi) | Değişken, `TYPE` alanı, ifade ✔; tipli tutamaç ve `FREEFILE` ✖ | S-548, S-549 |
| 5 | Python tarzı veri sabitleri, `DATA`/`READ`/`RESTORE` | ✖ tasarım yok | ✔ 10.5 (bu turda "bugün yok" tablosu) | ✖ hiçbiri yok | S-550, S-551, S-552 |
| 6 | `any`, `variant`, `object`, `none`, `nan`, `node` | ✔ `ANY`/`VARIANT` (35 kanonik tip); ✖ `NONE`/`NODE`/`NAN` | ✔ 4.4 (bu turda tablo) | `OBJECT` ✔; ötekiler yüzeyden reddedilir | S-386, S-553, S-554, S-564 |
| 7 | OOP: çoklu kalıtım, karışım, eksikler | ✔ 15 Eylül planı (**çoklu durum kalıtımı bilerek yok**) | ✔ 11.10, **11.12 (yeni)** | Tek tabanlı kalıtım ✔; çoklu kalıtım ve 8 yetenek ✖ | S-555 … S-561, S-547 |
| 8 | `ALIAS` (önişlemci ve meta) | ✔ | ✔ 16.1, 17.4, 18.1 (tablo bu turda) | **Hepsi çalışıyor**; yalnız `REM %%ALIAS` yorumdur | G-META-1 (S-286) |
| 9 | (boş bıraktığın madde) | — | — | — | — |

---

## 1. uXBasic bellek tasarımı

**Tasarım belgeleri:** `docs/tasarim/uxbasic bellek tasarimi  ve coklu is modeli yeni gelistirmeler 24.09.26.md` (306 KB, 15 616 satır; bir **tarihçe**: bağlayıcı olanlar karar defterindeki K1–K8 görev kararlarıdır), `UXB_TASARIM_F80_MEMORYREF_AUTO_KARARLARI_20260920_TR.md`, `UXB_TASARIM_PTR_BYTE_ARITMETIGI_VE_ARRAY_STRIDE_20260920_TR.md`, `UXB_TASARIM_TYPED_POINTER_VE_RAW_PTR_20260920_TR.md`, `spec/NESTED_MEMORY_LAYOUT_SPEC.md` (10 Nisan, "Proposed"; **kitapta adı hiç geçmiyordu, bu turda Bölüm 14.5'e ve Ek I'ye işlendi**).

**Tasarımın özü (kitap Bölüm 14):** iki bellek: `VIRTUAL` (sınırları denetlenen sanal bellek, varsayılan 1 MiB, `--virtual` ya da `VIRTUAL boyut` ile ayarlanır) ve `NATIVE` (sürecin gerçek adres alanı); `AUTO` kuralı (`PTR` kaynaklı adres → `NATIVE`, düz sayı → `VIRTUAL`); `PEEK*`/`POKE*` (`B`, `W`, `D`, `Q`, `S`), `MEMCOPY*`/`MEMFILL*`; ham `PTR` bayt aritmetiği; `MemoryRef` başvurusu; WASM'da doğrusal bellek.

**Bu turda ölçüldü (`20261014_0253`):**

| Konu | Sonuç |
|---|---|
| `SIZEOF(Entity)` (iç içe `TYPE`) | `12` — altı yolda aynı |
| `OFFSETOF(Entity, "pos.y")` (yuvalanmış yol) | `4` — altı yolda aynı (WASM dahil) |
| Hizalama dolgusu (`U8` + `I64`) | `16` ve ofset `8` — aynı |
| Kendini içeren `TYPE` | açık hata (`recursive by-value type`) — altı yolda aynı |
| `STRING` alanı (8 baytlık başvuru) | `SIZEOF` `16` — altı yolda aynı |
| Kayıt **dizisinin** adresinden alana yazma | ✖ **FARK** (S-546, G-VERI-17): x64 ✔; AST `NATIVE POKED out of range`; MIR `VARPTR requires a native-scalar-type`; eski AST-x64 sessizce `0` |

**Sonuç:** Bellek tasarımı belgelenmiş ve temel parçalar çalışıyor. Açık kalanlar: tipli işaretçi `PTR TO T` (S-113 tasarımı; bugün **sessiz** ham `PTR` gibi davranır, S-377), `ADDR(...)` (S-391), kayıt dizisi adresi (S-546), JS'te `VIRTUAL` bağlama (S-341), WASM'da 8 baytlık erişim (S-428).

---

## 2. uXBasic 6502 adresleme modları tasarımı

**Tasarım belgesi:** `docs/tasarim/UXB_TASARIM_6502_ADRESLEME_VE_PTR_ARITMETIGI_20260920_TR.md` — bir **düşünce deneyi**. Kararı: "6502'nin adresleme modlarını **işleç olarak eklemeyelim**; bayt tabanlı `PTR` aritmetiği ve `PEEK`/`POKE` yeter. Bir adım ileri: `ADDR(taban, indeks, ölçek, kayıklık)` düşünülebilir; `INDIRECT(p)` önerilmez (yeni sözcük dili şişirir); sıfır sayfasını dile zorunlu kılmayalım (`CONST ZP = 0` yazılır)."

**Kitap Bölüm 14.5 bu turda genişletildi:** 6502'nin **tüm modları** tek tabloda (örtük/biriktirici, hemen, sıfır sayfası, sıfır sayfası,X/Y, mutlak, mutlak,X/Y, dolaylı, indeksli dolaylı, dolaylı indeksli, göreli) ve uXBasic karşılıkları. **On bellek değerinin hepsi** AST, MIR, MIR-x64, eski AST-x64, JS ve WASM'da beklenen sayılarla **birebir aynı** çıktı (`11 22 33 44 55 66 17408 77 66 88`). Sıfır sayfası **sarması** (`($20,X)` için `x = 240`: adres `(32 + 240) AND 255 = 16`'ya sarar) dil dayatması olmadan `AND 255` ile yazılıyor ve doğru çıkıyor.

**Eksik / sınır:** `ADDR(...)` yok (S-391); tanımsız işlev olduğu için AST `unsupported call ADDR`, **WASM sessizce `0`** (S-545). Onaltılık adres yazımı: `&H4400` ifade içinde ✔, **tek başına** JS'te `undefined`, WASM'da derlenmez (S-242, S-563); `0x4400` **sessizce yanlış** (S-562). Bu yüzden tabloda adresler onluk yazıldı.

**Karar gerekmiyor**; yalnız `ADDR` istenirse uygulama sırası: önce S-113 (`PTR TO T`), sonra `ADDR`.

---

## 3. `EVENT`, `THREAD`, `PARALEL`, `PIPE`, `SLOT` ve "SUB/FUNCTION `DECLARE` ile önden tanımlanmalı"

**Bloklar çalışıyor.** `EVENT … END EVENT`, `PIPE … END PIPE`, `THREAD … END THREAD`, `PARALEL … END PARALEL`, `SLOT … END SLOT`: AST, MIR ve x64'te doğru; JS'te görev konak bağlamaları yok (`TASK_SPAWN`, `SLOT_DEF`); WASM görev yapılarını reddeder; eski AST-x64 `SPAWN/TASK/TASKGROUP`'u açıkça reddeder. Bunlar Bölüm 15'te anlatılı.

**`DECLARE` kuralı.** 24.09 tasarımı: "tanım daha önce geldiyse `DECLARE` gerekmez; tanım dosyanın ilerleyen bölümündeyse ya da başka modüldeyse `DECLARE` kullanılır; imza bire bir uyuşmak zorunda." Sen: "`SUB … END SUB` ve `FUNCTION … END FUNCTION` `DECLARE` ile önden tanımlanmalı." Ölçülen:

| Durum | Sonuç (altı yolda) |
|---|---|
| `SUB`/`FUNCTION` tanımdan **önce** `DECLARE`'siz çağrı | ✖ **hatasız çalışır** (S-544): kural denetlenmiyor |
| `DECLARE` imzası tanımla uyuşmuyor | ✔ derleme hatası `declaration signature mismatch` |
| `DECLARE THREAD/EVENT/PIPE/PARALEL/SLOT` | ✖ ayrıştırma hatası (S-395, ◇ HEDEF) |
| Görevi tanımdan önce `SPAWN`/`TRIGGER` | AST, MIR, x64: `DECLARE`'siz çalışır (derleyici görev adlarını önceden toplar) |
| `DECLARE` var ama tanım **yok**, çağrı var | ✖ FARK: AST/MIR çalışma anında, x64 derlemede, JS yürütmede, eski AST-x64 bağlamada durur; **WASM `0` yazar (sessiz yanlış, S-545)** |

**Karar bekleniyor (S-544):** ileri kullanım derleme hatası mı olsun (sıkı), uyarı mı, yoksa isteğe bağlı mı kalsın? **Önerim: sıkı kural.** Bedeli küçük: rutin tanımlayan 66 kılavuz örneğinden **2'si**, 133 test dosyasından **2'si**, 80 kütüphane kaynağından **1'i** etkilenir (yaklaşık 5 dosya). Sıkı kural görev yapıları için de aynı olurdu (S-395).

---

## 4. Dosya kanalı: değişken ve `TYPE` ile tutamaç

| İstek | Sonuç |
|---|---|
| `OPEN … AS #f` (`f` bir `I32` değişken) | ✔ AST, MIR, x64, eski AST-x64 |
| `OPEN … AS #k.no` (`TYPE` alanı) | ✔ aynı |
| `OPEN … AS #(1 + 1)` (ifade) | ✔ aynı |
| `DIM f AS I32 = FREEFILE` | ✖ `FREEFILE` yok (S-548; G-DOSYA-4 ile aynı aileden) |
| `DIM f AS FILE` / `FILE_HANDLE` ve `OPEN "x" FOR OUTPUT AS f` | ✖ tipli tutamaç yok (S-549); `FILE_HANDLE` tasarımın 35 kanonik tipinden biri |
| JS / WASM | dosya işlemleri zaten çalışmaz (JS `host binding missing: OPEN`) |

**Tasarım önerisi (onayına sunuyorum):** (1) `FREEFILE` eklensin (en ucuz parça). (2) `DIM f AS FILE_HANDLE` gerçek bir tip olsun; `OPEN "x" FOR OUTPUT AS f`, `PRINT #f`, `CLOSE f` hem sayıyla (`#3`) hem tutamaçla çalışsın; tutamaç bir `TYPE` alanı da olabilsin. (3) Tutamaç, kanal numarasını içeren değer tipi olur; böylece mevcut `#n` yazımı bozulmaz.

---

## 5. Python tarzı veri sabitleri ve `DATA` / `READ` / `RESTORE`

**Ölçüm:** hiçbiri çalışmıyor.

| İstek | Bugün |
|---|---|
| `DIM a(2) AS I32 = {1, 2, 3}`, `DICT`/`SET` için `{ … }` | sözcük çözümleyici hatası (çıkış 2) — S-551 |
| `DIM l AS LIST = [1, 2, 3]` | ayrıştırma hatası — S-551 |
| `DIM t AS TUPLE = (1, 2, 3)`, `DIM df AS DATAFRAME` | tipler yok — S-552 |
| `DATA 10, 20, 30` / `READ a` / `RESTORE` | yok; `DATA` değişken adı bile olabilir — S-550 |

**"Eskiden lexer'daydı" bilgisi doğrulanamadı.** Bugünkü yüzey kaydında ve 239 anahtar sözcüğün listesinde yok; eski yama arşivindeki bir uyumluluk notu yalnızca "DATA / READ / RESTORE varsa" diyor. Eski uygulamayı hatırlıyorsan ya da bir arşiv zip'inde varsa söyle; kaynağı bulursak geri getirmek yeniden yazmaktan ucuz olur.

**Bir tasarım çatışması (önemli):** tasarım belgeleri `{ … }` biçimini zaten **ham büyük sayı sabiti** için ayırmış (`X = {3.1415926535897932384626433832795028841971}`, S-495) ve önişlemci yönergeleri `{eski}`/`{yeni}` yer tutucusu olarak kullanıyor (`%%ALIAS {a} AS {b}`). Dict/set sabitleri aynı süslü parantezi kullanacaksa **bağlama göre ayrım** gerekir: tek sayı → ham sayı; `anahtar: değer` → `DICT`; virgüllü liste → `SET`/dizi başlangıcı. Önerim: sabitler **hedef tipe göre** yorumlansın (`DIM d AS DICT = { … }` ise sözlük).

---

## 6. `any`, `variant`, `object`, `none`, `nan`, `node`

| Ad | İç tip kümesinde | Yüzeyde (kaynak yazımı) | Tasarımın 35 tipinde |
|---|---|---|---|
| `ANY`, `VARIANT` | ✔ (`TYPE_ANY`, `TYPE_VARIANT`; değer türü `VAL_ANY`, `VAL_VARIANT`) | ✖ `unknown type` | ✔ (G-TIP-8, S-386) |
| `VOID` | ✔ | ✖ `unknown type` | ✔ |
| `OBJECT` | ✔ | ✔ kabul edilir (koleksiyon işlevlerinin dönüş tipi) | ✔ |
| `FILE_HANDLE`, `FUNCTION_PTR`, `DLL_HANDLE`, `JS_OBJECT`, `WASM_EXTERNREF` | ✔ | ✖ reddedilir | ✔ |
| `NONE`, `NODE` | ✖ (iç karşılığı da yok; `NONE` yalnız seçenek adı) | ✖ `unknown type` | ✖ |
| `NAN` | ✖ tip değil | ✖ sabit yok; `ISNAN()` yok | ✖ |
| `NULL`, `NOTHING`, `NIL` | MIR indirgeyicisinde kod var | ✖ `unknown symbol` — boş değer yazılamıyor (S-564) | — |

"İç kullanımda var" varsayımın `any`, `variant`, `object` için **doğru**; `none`, `nan`, `node` için **yanlış** (hiçbir yerde tip olarak tanımlı değil). Belgelerde: `ANY`/`VARIANT`/`VOID`/`FILE_HANDLE` … tasarımın 35 tipinde ve kitapta (4.4, G-TIP-8); `NONE`/`NODE`/`NAN` hiçbir tasarım belgesinde tip olarak geçmiyor.

**Karar bekleniyor (S-554):** `NONE` (Python `None` benzeri yokluk) ve `NODE` neyi karşılasın? Önerim: şimdilik **eklenmesin**; yokluk için **`NULL`/`NOTHING` çalıştırılsın** (S-564; kod MIR'de var, anlam kapısı tanımıyor), düğüm `CLASS`/`TYPE` ile ya da `uxgraph`/`uxcollections` kütüphane tipi olarak gelsin. `NAN`/`INF`/`ISNAN()` (S-553) ayrı ve ucuz bir iyileştirmedir.

---

## 7. OOP: çoklu kalıtım, karışım ve neler eksik

**Mevcut tasarım (15 Eylül, kitap 11.10) tersini söylüyor:** "bir sınıfın tek uygulama tabanı ve çok arayüzü vardır; **çoklu durum kalıtımı yoktur**." Senin kararın bunu değiştiriyor (S-555, kitap 23.6'ya yazıldı). Bugün: `CLASS C EXTENDS A, B` altı yolda ayrıştırma hatası; `MIXIN` tanınır ama ayrıştırılmaz (S-360).

**Çoklu kalıtım için seçenekler (S-555):**

| Seçenek | Ne olur? | Artısı | Eksisi |
|---|---|---|---|
| **A. Durumsuz karışım** | Tek durum tabanı + çok `MIXIN`/trait + çok arayüz | Elmas sorunu yok; taşıması kolay | Alan paylaşan karışım yok |
| **B. Gerçek çoklu durum kalıtımı** | `EXTENDS A, B`; alanlar sırayla; kurucular soldan sağa; elmas için C3 ya da "aynı tabanı iki yoldan almak hata" | En güçlü | Alan yerleşimi, `SUPER` çözümü, JS/WASM pahalı |
| **C. Aşamalı (önerim)** | Önce durum taşıyabilen `MIXIN`, sonra B | Her aşama sınanır | İki aşama |

**Ön koşullar (hangisi seçilirse seçilsin):** taban kurucu zinciri (S-485 ve S-487: AST ve MIR taban kurucusunu çalıştırmaz, `SUPER(...)` yok), `ABSTRACT`/`FINAL`/`SEALED` (S-360), `THIS`/`ME` ayrımı (S-484).

**Bu turda ölçülen başka eksikler** (kitap Bölüm 11.12'de tam tablo):

| Eksik | Kayıt |
|---|---|
| Arayüz mirası `INTERFACE IB EXTENDS IA` | S-556 |
| İç içe sınıf | S-557 |
| Sınıf sabiti (`CONST`) | S-558 |
| Arayüzde gövdeli (varsayılan) metot | S-559 |
| Kurucu aşırı yükleme (birden çok `CONSTRUCTOR`) | S-560 |
| `INSTANCEOF` yalnız AST'de | S-547 |
| Varsayılan parametre değeri (`b AS I32 = 10`) | S-561 |
| Boş nesne / `NULL` / `NOTHING` | S-564 |
| (zaten kayıtlı) jenerik, `USES`, `DECORATOR`, zayıf başvuru, `PROPERTY` bloğu, `STATIC`, alan erişim denetimi, metot aşırı yükleme | G-HEDEF-4, G-HEDEF-25, G-HEDEF-3, G-NESNE-1, G-NESNE-2, G-YORDAM-1 |

---

## 8. `ALIAS`: önişlemci ve meta

**Sezgin doğru.** Altı yolda ölçüldü:

| Yazım | Sonuç |
|---|---|
| `ALIAS KA = Cok_Uzun_Bir_Ad_Alani` / `ALIAS Sayi = I32` / `ALIAS Plus = Topla` | ✔ ad alanı, tip ve işlev için çalışır |
| `%%ALIAS YAZ AS PRINT` | ✔ anahtar sözcüğe ve `SUB` adına ikinci ad verir |
| `%%ALIAS A AS B` + `%%ALIAS B AS A` | ✔ döngü açık hatayla reddedilir (`PREPROCESSOR_ALIAS_CYCLE`) |
| `REM %%ALIAS KISA AS UZUN` | yorumdur: hatasız kabul edilir, hiçbir şey yapmaz (G-META-1, S-286) |

Meta sisteminin **ilk katmanı** zaten önişlemci komutlarıdır (Bölüm 18.1); `%%ALIAS` o katmanın komutu olarak vardır. `REM %%ATTR` ve `REM %%MIR` katmanları henüz yok; yok oldukları için `ALIAS` da yok. Yeni kayıt gerekmedi.

---

## 9. (boş madde)

9. maddeyi yazmamışsın; ekleyeceksen söyle.

---

## Bu turda yan olarak bulunanlar (sorularında olmayan ama kayda geçenler)

| Bulgu | Kayıt |
|---|---|
| WASM'da tanımsız işlev/SUB çağrısı derleme hatası vermez, sessizce `0` yazar | S-545 (SESSİZ) |
| `0x1F` biçimi sessizce yanlış sayı üretir (`0`, çöp sayı ya da `undefined`) | S-562 (SESSİZ) |
| Tek başına duran `&H…`/`&B…`/`&O…` sabiti WASM'da ham `wat2wasm` hatasıyla derlenmez | S-563 |
| `DECLARE` var, tanım yok, çağrı var: altı yolda altı farklı davranış | S-329 (genişletildi) |
| Test koşucuları `reports\` klasörünü 40 GB'a şişirdi: her `bld` çıktı klasörüne ≈ 6,5 MB DLL kopyalıyor | S-117 (güncellendi), kitapta G-ARAC-7 |

## Senden bekleyen kararlar (özet)

1. **S-544** — `DECLARE` kuralı sıkı mı olsun? (önerim: evet)
2. **S-555** — Çoklu kalıtım: A / B / C? (önerim: C)
3. **S-554** — `NONE`/`NODE` eklensin mi? (önerim: hayır; `NULL`/`NOTHING` çalıştırılsın, S-564)
4. **S-549, S-551** — tipli dosya tutamacı ve veri sabitleri için yukarıdaki tasarım önerilerini onaylıyor musun?
5. **Eski `DATA`/`READ`/`RESTORE`** kaynağı elinde var mı? (S-550)
