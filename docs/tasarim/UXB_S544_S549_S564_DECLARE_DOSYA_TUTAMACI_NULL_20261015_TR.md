# Onaylanan kararların uygulama sözleşmesi: sıkı `DECLARE`, tipli dosya tutamacı ve `FREEFILE`, `NULL` ve `NOTHING`

**Tarih:** 2026-10-15 · **Hazırlayan:** Claude (tasarım ve belgeleme) · **Karar sahibi:** Mete · **Durum:** kararlar verildi, **uygulanmadı** · **Uygulama:** Codex (kaynak) · **Doğrulama:** Claude (altı yolda, değer düzeyinde) · **Kayıtlar:** S-544, S-548, S-549, S-554, S-564 (ilgili: S-395, S-545, S-555, S-326)

## 0. Mete'nin kararları (2026-10-15, akşam)

| Konu | Karar | Kayıt |
|---|---|---|
| `DECLARE` kuralı | **Sıkı olmalı**: tanımdan önce `DECLARE`siz kullanım derleme hatası | S-544 |
| Tipli dosya tutamacı ve `FREEFILE` | Tasarım **onaylandı** (önerim aynen) | S-549, S-548 |
| `NULL`, `NOTHING` | **Çalışsın** | S-564 |
| `NONE`, `NODE` | "Önerdiğin gibi": **eklenmesin**; yokluk `NULL`/`NOTHING` ile, düğüm `CLASS`/`TYPE` ile | S-554 |
| Çoklu kalıtım (A/B/C) | "Önerdiğin gibi" dedi ama seçeneklerin içeriğini anlamadığını söyledi; sade anlatım kitabın 11.12 bölümüne eklendi. **Son onay bekleniyor** (varsayılan: C) | S-555 |
| Anahtarlar | Yapay zekâ hizmeti anahtarları **GitHub'a gönderilmez**; yerel belgelerde olduğu gibi kalır (yenileme istenmedi) | — |

Etiketli `DATA`/`READ`/`RESTORE` ve veri sabitleri ayrı belgededir: `UXB_S550_S551_DATA_READ_RESTORE_VE_VERI_SABITLERI_20261015_TR.md`.

## 1. Sıkı `DECLARE` kuralı (S-544)

### 1.1 Kural

> Bir `SUB` ya da `FUNCTION`, **tanımı kaynak metinde kullanımından sonra geliyorsa**, ilk kullanımından önce aynı imzayla bir `DECLARE` ile bildirilmelidir. Tanım kullanımdan **önce** geliyorsa `DECLARE` gerekmez. `DECLARE` imzası tanımla bire bir uyuşmalıdır.

Bu, 24.09 görev tasarımıyla ("tanım daha önce geldiyse `DECLARE` gerekmez; ilerideyse ya da başka modüldeyse `DECLARE` kullanılır") ve Mete'nin 2026-10-15 kuralıyla ("`SUB … END SUB` ve `FUNCTION … END FUNCTION` `DECLARE` ile önden tanımlanmalı") aynıdır; "sıkı" ihlalin sessiz geçmemesi, **derleme hatası** olması demektir.

### 1.2 Ne sayılır, ne sayılmaz

| Durum | Kural |
|---|---|
| "Kullanım" | Çağrı deyimi ya da ifadesi (`Ad(…)`, `CALL Ad(…)`), işlev göstericisi alma (`CODEPTR(Ad)`), görev başlatma (`SPAWN Ad(…)`; görev yapıları için önce S-395) |
| "Metin sırası" | `INCLUDE` açılımından sonraki sıra |
| Karşılıklı özyineleme | Sonra tanımlanan rutin `DECLARE` ile önceden bildirilir |
| Muaf | Sınıf metotları (sınıf gövdesinde bildirilir), `DECLARE … LIB` ile tanıtılan dış kütüphane işlevleri, yerleşik işlevler |
| Rapor | İlk kullanım satırında, rutin başına **bir** hata |

### 1.3 Tanı

* Kod (öneri): `UXB_DECLARE_REQUIRED_BEFORE_USE`.
* İleti anlamı: "`Selam` rutini tanımından önce kullanıldı; ilk kullanımdan önce `DECLARE SUB Selam()` yazın".
* Denetim, altı yolun hepsinin geçtiği ortak kapıda (ayrıştırma/anlam çözümleme) yapılır; böylece AST yorumlayıcının doğrudan çalıştırma yolu dahil **altı yolda aynı ret** kendiliğinden gelir.

### 1.4 Etkilenen dosyalar (kaynak metin sezgisiyle bulundu; derleyici kuralı gelince kesin liste çıkar)

| Dosya | Durum |
|---|---|
| `docs/kitaplar/_ortak/ornekler/41_kv_yapi/sub_tanimdan_once.uxb` | **Claude güncelledi** (`DECLARE SUB Selam()` eklendi); AST, MIR, x64, JS yeniden doğrulandı |
| `docs/kitaplar/_ortak/ornekler/67_kv_buyuk_program/ifade_hesaplayici.uxb` | **Claude güncelledi** (`DECLARE FUNCTION Toplam() AS F64` eklendi); AST, MIR, x64 yeniden doğrulandı |
| `tests/task_model/iso_global_recursion.uxb` | Codex güncellemeli |
| `tests/uxbasic_hamle2_runtime_chain_patch/tests/runtime/hamle2_chain_runtime.uxb` | Codex güncellemeli |
| `libsx/uxclazz/uxclazz_support.bas` | Codex güncellemeli (kütüphane kaynağı) |

### 1.5 Kabul ölçütleri (model testi paketi önerisi: `tests/declare_siki/`)

1. `Selam()` çağrısı, `SUB Selam` tanımından önce, `DECLARE`siz → `UXB_DECLARE_REQUIRED_BEFORE_USE`, altı yolda aynı ileti ve çıkış durumu.
2. Aynı program, çağrıdan önce `DECLARE SUB Selam()` ile → `merhaba` (altı yol; WASM'da metin kapısı nedeniyle sayısal sürümüyle).
3. Tanım önce, çağrı sonra, `DECLARE`siz → çalışır.
4. Karşılıklı özyineleme: `DECLARE`siz → hata; `DECLARE` ile → çalışır.
5. `DECLARE` imzası tanımla uyuşmuyor → `declaration signature mismatch` (mevcut davranış korunur).
6. Sınıf metotları ve `DECLARE … LIB` etkilenmez.
7. Kitap örnekleri (`declare_ileri`, `karsilikli_ozyineleme`, `sub_tanimdan_once`, `ifade_hesaplayici`) ve bütün model testleri geçer.

### 1.6 Ön koşullar ve sıra

1. **S-395:** `DECLARE THREAD`, `EVENT`, `PIPE`, `PARALEL`, `SLOT` biçimleri eklenmeden kural görev yapılarına uygulanamaz; ilk aşamada kural yalnız `SUB`/`FUNCTION` içindir.
2. **S-545 / S-329 (aynı turda önerilir):** tanımsız rutin çağrısı bugün altı yolda altı farklı davranır (WASM sessizce `0`). Kural "ileri kullanım"ı yakalar, "hiç tanımsız"ı yakalamaz; ikisi birlikte "ya doğru sonuç ya da anlaşılır açık ret" (İlke 2) olur.
3. Etkilenen 3 dosyanın güncellenmesi (1.4).
4. Kitap: Bölüm 8.1, 8.4, 8.5, 8.10 ve 15.3 "◇ HEDEF"ten ✔'ya çevrilir.

### 1.7 Mete'ye sorulacak (kararın kapsamı dışında kalan küçük öneri)

`DECLARE` ile bildirilmiş ama hiçbir yerde tanımlanmamış (ve `LIB` ile dış kütüphaneye bağlı olmayan) rutin için bugün çağrı yoksa hata yoktur. Öneri: bu da derleme hatası olsun (kullanılmayan bildirim). **Onay gelene kadar uygulanmaz.**

## 2. Tipli dosya tutamacı ve `FREEFILE` (S-549, S-548)

### 2.1 Onaylanan tasarım

1. **`FREEFILE`** eklenir (en ucuz parça).
2. **`DIM f AS FILE_HANDLE`** gerçek bir tip olur; `OPEN "x" FOR OUTPUT AS f`, `PRINT #f`, `CLOSE f` hem sayıyla (`#3`) hem tutamaçla çalışır; tutamaç bir `TYPE` alanı da olabilir.
3. Tutamaç, kanal numarasını içeren **değer tipi**dir; böylece bugünkü `#n` yazımı bozulmaz.

### 2.2 Sözleşme

| # | Kural |
|---|---|
| **F1** | `FREEFILE`, boş olan **en küçük** kanal numarasını döndürür (`TIMER` gibi parantezsiz yazılır). Kanal aralığı `OPEN`un bugün kabul ettiği aralıktır (Codex doğrular). Boş kanal yoksa `0` döner ve `OPEN` `0` numarayı reddeder |
| **F2** | `FILE_HANDLE` varsayılan değeri `0`dır ("açık değil"). Değişken, `TYPE` alanı, sınıf alanı ve parametre (`BYVAL` ya da `BYREF`) olabilir |
| **F3** | `OPEN "ad" FOR … AS f` (`f` bir `FILE_HANDLE`, `#` işaretsiz) boş bir kanalı kendisi seçer ve `f`ye verir (`f = FREEFILE` + `OPEN … AS #f` ile eşdeğer). `f` zaten `0`dan farklıysa (açık bir kanalı tutuyorsa) çalışma anı hatasıdır: `UXB_FILE_HANDLE_IN_USE` |
| **F4** | `PRINT #f, …`, `INPUT #f, …`, `EOF(f)`, `LOF(f)`, `CLOSE f` ve `CLOSE #f`: `f` bir `FILE_HANDLE` ya da `I32` olabilir. Mevcut `#n` yazımının davranışı değişmez |
| **F5** | `CLOSE f` (`f` bir `FILE_HANDLE` değişkeni) kanalı kapatır **ve `f`yi `0` yapar** (çift kapatma zararsız, `IF f = 0` sınaması mümkün). Sayıyla `CLOSE #3` eskisi gibidir |
| **F6** | `FILE_HANDLE` ile `I32` arasında örtük dönüşüm vardır (kanal numarası); `PRINT f` numarayı yazar. Böylece `OPEN "x" FOR OUTPUT AS #n` ve `n = FREEFILE` kullanan bugünkü programlar bozulmaz |
| **F7** | `TYPE` alanı: `TYPE Gunluk : dosya AS FILE_HANDLE : END TYPE` ve `OPEN "g.txt" FOR APPEND AS g.dosya`; `#g.dosya` da kabul edilir (bugün `AS #k.no` çalışır) |
| **F8** | JS ve WASM: dosya işlemleri bugün zaten çalışmaz (`UXB host binding missing: OPEN`). Tip adı iki yolda da tanınır, dosya deyimleri **mevcut açık retle** durmaya devam eder; sessiz başarı yoktur |

### 2.3 Örnek (◇ HEDEF; bugün derlenmez)

```basic
DIM f AS FILE_HANDLE
DIM g AS FILE_HANDLE
DIM satir AS STRING

OPEN "a.txt" FOR OUTPUT AS f       ' f = boş kanal (1)
OPEN "b.txt" FOR OUTPUT AS g       ' g = boş kanal (2)
PRINT #f, "birinci"
PRINT #g, "ikinci"
CLOSE f                            ' f = 0
CLOSE g

OPEN "a.txt" FOR INPUT AS f
INPUT #f, satir
PRINT satir                        ' birinci
CLOSE f
```

### 2.4 Kabul ölçütleri (model testi paketi önerisi: `tests/dosya_tutamaci/`; AST, MIR, MIR-x64, eski AST-x64)

1. 2.3'teki örnek; `FREEFILE` ardışık numaralar verir (1, 2), kapatınca en küçük boş numarayı yeniden verir.
2. Tutamaç ile `#3` karışık kullanımı; `I32` değişkenle eski yazım bozulmaz.
3. `TYPE` alanı olarak tutamaç.
4. Açık tutamaca ikinci `OPEN` → `UXB_FILE_HANDLE_IN_USE`.
5. `CLOSE f` sonrası `f = 0`.
6. Tip adı JS ve WASM'da tanınır, `OPEN` mevcut açık retle durur.

## 3. `NULL` ve `NOTHING` (S-564)

### 3.1 Bugün

`PRINT NULL`, `DIM p AS PTR` ardından `p = NOTHING` ve `IF k = NOTHING THEN …` (sınıf değişkeni) altı yolun hepsinde `semantic-step3: type: unknown symbol` ile reddedilir. MIR indirgeyicisinde `NULL` ve `NOTHING` için kod hazırdır (`src/semantic/mir_lower_expr.fbs`: değer `0`, tür `PTR`), yalnız anlam kapısı sembolü tanımaz. Boş bırakılmış nesne değişkenine alan erişimi çalışma anı hatasıdır (`field access on a null object reference`; JS'te hata vermeyip `undefined` yazdırır, G-HATA-6).

### 3.2 Sözleşme

| # | Kural |
|---|---|
| **N1** | `NULL` ve `NOTHING`, **aynı boş değerin iki yazılışıdır** (iç değer `0`). `NIL` istenmedi, eklenmez |
| **N2** | Atanabilir: `PTR`, tipli işaretçi (`PTR TO T`, gelince), nesne başvurusu (sınıf tipli değişken), işlev göstericisi (`FUNCTION_PTR`, gelince) |
| **N3** | Sınanabilir: `=` ve `<>` ile (`p = NULL`, `IF k <> NOTHING THEN …`); iki yazılış birbirine eşittir |
| **N4** | Sayı, metin ya da `BOOLEAN` değişkene atanması derleme hatasıdır: `UXB_NULL_TYPE` ("`NULL` yalnız işaretçi ve nesne tipleriyle kullanılır") |
| **N5** | `PRINT NULL` `0` yazar |
| **N6** | `CALL(DLL, …)` ve `DECLARE … LIB` çağrılarında boş işaretçi bağımsız değişkeni olarak yazılabilir (`BYVAL NULL`); bu, ana gerekçelerden biridir |
| **N7** | `NOTHING` bir nesneden alan okumak ya da metot çağırmak, **altı yolda aynı** çalışma anı hatasıdır (`field access on a null object reference`); JS'te `undefined` yazdırma kusuru (G-HATA-6) bununla birlikte kapanmalıdır |

### 3.3 Örnek (◇ HEDEF; bugün derlenmez)

```basic
DIM k AS Kutu = NEW Kutu(3)
DELETE k
k = NOTHING
IF k = NOTHING THEN PRINT "bos"
```

### 3.4 Mete'ye sorulacak (kararın kapsamı dışında kalan öneri)

`DELETE k` nesneyi yıkarken **`k`yi de `NOTHING` yapsın mı?** Bugün `DELETE`ten sonra değişkeni okumak motora göre değişen sessiz sonuç verir (G-NESNE-20: MIR eski değeri okur, JS `undefined`; G-NESNE-22: başka adla erişim de çalışır). `NOTHING` geldikten sonra bu otomatik atama sarkan başvuruyu kapatan en ucuz önlemdir. **Onay gelene kadar uygulanmaz.**

### 3.5 Kabul ölçütleri (model testi paketi önerisi: `tests/null_nothing/`)

1. `PTR` ile `NULL`, `NOTHING`; `=`/`<>` sınaması; altı yolda aynı.
2. Nesne değişkeni `NOTHING` iken alan erişimi aynı çalışma anı hatası.
3. `k = NOTHING` sonrası `IF k = NOTHING`.
4. `I32` değişkene `NULL` atamak `UXB_NULL_TYPE`.
5. `PRINT NULL` → `0`.
6. FFI örneğinde `NULL` işaretçi bağımsız değişkeni (x64).

## 4. `NONE` ve `NODE` (S-554): eklenmeyecek

Karar: çekirdeğe ya da kütüphane tipi olarak **eklenmez**. Yokluk `NULL`/`NOTHING` ile (Bölüm 3), düğüm yapıları (bağlı liste, ağaç, çizge) `CLASS` ya da `TYPE` ile ifade edilir. `uxgraph` ve `uxcollections` kütüphaneleri ileride kendi düğüm tiplerini birinci sınıf kütüphane tipi olarak sunabilir (Bölüm 19); bu ayrı bir kayıt gerektirir. `NAN`, `INF`, `ISNAN()` (S-553) ayrı ve ucuz bir iyileştirme olarak açık kalır.

## 5. Çoklu kalıtım (S-555): karar verildi, B (bkz. Bölüm 7)

Seçenekler (A durumsuz karışım, B gerçek çoklu kalıtım, C aşamalı) ve sade anlatım kitabın 11.12 bölümündedir. Mete "önerdiğin gibi" dedi (C) ama içeriği tam anlamadığını belirtti; bu yüzden kayıt `KARAR-BEKLIYOR` kalır. Ön koşullar seçimden bağımsızdır: taban kurucu zinciri (S-485, S-487), `ABSTRACT`/`FINAL` (S-360), `THIS`/`ME` ayrımı (G-NESNE-24).

## 6. Uygulama sırası önerisi (Codex karar verir)

| Sıra | İş | Neden |
|---|---|---|
| 1 | `NULL`/`NOTHING` anlam kapısı (S-564) | Kod MIR'de hazır; en ucuz; FFI'ya ve nesne güvenliğine hemen yarar |
| 2 | Tanımsız rutin çağrısı açık ret (S-545/S-329) + `DECLARE THREAD/…` biçimleri (S-395) | Sıkı kuralın ön koşulları |
| 3 | Sıkı `DECLARE` (S-544) ve 3 dosyanın güncellenmesi | Karar verildi |
| 4 | `FREEFILE` ve `FILE_HANDLE` (S-548, S-549) | Ucuz; yeni tip adı |
| 5 | Veri sabitleri ve etiketli `DATA`/`READ`/`RESTORE` | Ayrı belge; sözcük çözümleyici değişikliği ister |

## 7. 2026-10-16 eki: iki öneri kabul edildi, çoklu kalıtım kararı verildi

Mete (2026-10-16): «b ile devam, belgeleri de github a gönder … sorularının cevapları ise varsayılanları uygulamandır.» Buna göre:

* **Tanımı olmayan `DECLARE` derleme hatasıdır** (öneri kabul edildi; yapıştırılan analiz de «evet» diyor). Tanı kodu `UXB_DECLARE_MISSING_DEFINITION`: `DECLARE SUB Selam()` bildirilip programın hiçbir yerinde `SUB Selam() … END SUB` yazılmamışsa, `Selam` çağrılsın çağrılmasın, derleme durur (ileti: bildirimin satırı ve «tanım bulunamadı»). Gerekçe: sıkı `DECLARE` kuralıyla (Bölüm 2) birlikte bildirim bir **söz** olur; sözü tutulmayan bildirim, yalnız çağrıldığında WASM'da sessiz `0` ya da başka motorlarda geç hata verir (S-545, S-329). Kabul: `tests/oop_parity` benzeri yeni `declare_missing` testi altı yolda aynı tanıyı verir.
* **`DELETE k` sonrası `k = NOTHING` olur** (öneri kabul edildi; Mete'nin OOP tasarım belgesi de böyle yazar). `NOTHING` gelince (Bölüm 3, S-564) `DELETE` değişkeni `NOTHING` yapar; bugün lowering değişkene `0` yazar (MIR'de boş başvuru). Boş ya da ölü hedefe `DELETE` hiçbir şey yapmaz. Yaşam döngüsünün bütünü: S-574.
* **Çoklu kalıtım (Bölüm 5) kararı verildi: B.** Ayrıntı: `UXB_S555_COKLU_KALITIM_B_VE_CAKISMA_DENETIMI_20261016_TR.md`.