# 1. uXBasic'in amacı, ilkeleri ve derleme hattı

## 1.1 Amaç

uXBasic, **öğrenmek için de yazılmış** bir derleyicidir. Komut satırı yalnızca programı çalıştırmakla kalmaz; genç bir programcı
seçeneklerle kendi programının iç organlarını (sözcükleri, sözdizimi ağacını, ara kodu, üretilen assembly'yi) görebilir.
Derleyici yazmayı öğrenmenin kısa yolu budur.

Dilin beş hedefi vardır:

| Hedef | Ne demek? |
|---|---|
| **Basit söz dizimi** | BASIC'in okunaklılığı: `IF ... THEN`, `FOR ... NEXT`, `PRINT` |
| **Sistem programlama** | İşaretçi, ham bellek, DLL çağrısı, bit işlemleri; gerektiğinde makineye inebilmek |
| **Tek kaynak, çok hedef** | Aynı program yerel EXE (x64), JavaScript ve WebAssembly olarak çalışabilmek |
| **Derleme zamanı üretimi** | Önişlemci ve meta komutlarla kod üretmek, programı kendi kendini tanımlayan hâle getirmek |
| **Genişletilebilir tipler** | `RATIONAL`, `COMPLEX` gibi tipleri derleyici çekirdeğini şişirmeden kütüphane olarak eklemek |

## 1.2 Altı temel ilke

Bu kılavuzdaki her tasarım kararı aşağıdaki ilkelerden birine dayanır. Bir kural size tuhaf geldiğinde hangi ilkeden
çıktığına bakın.

### İlke 1: Tek anlam, çok hedef (eşlik)

Aynı kaynak kod AST, MIR, x64, JS ve WASM'da **aynı gözlenebilir sonucu** vermelidir. Hedefler arasındaki fark bir özellik
değil, **hatadır**. Yazdığınız program bir hedefte çalışıp ötekinde başka bir şey yapıyorsa kusur derleyicidedir.

Eşliğin tek istisnası *olmayan şeyin reddedilmesidir* (İlke 2): bir hedef bir özelliği hiç desteklemiyorsa, programı
**yanlış çalıştırmak yerine** derleme sırasında reddeder.

### İlke 2: Sessiz hata yok, sahte iş yok (kapalı başarısızlık)

Derleyici bir şeyi yapamıyorsa **durur ve nedenini söyler**. Aşağıdakilerin hiçbiri kabul edilemez:

| Yasak davranış | Yerine yapılması gereken |
|---|---|
| Yapamadığı işi yapmış gibi boş bir sonuç üretmek | `refusing fake null handle` gibi açık bir ret |
| Taşan sayıyı sessizce kırpmak | Aralık dışı sabitte **derleme hatası** |
| İki görevi aynı SLOT numarasına bağlayıp sonuncusunu seçmek | Aynı kimlik = **derleme hatası** |
| Okunmayan görev hatasını yutmak | Hata çıkışına yazılır, program çıkış kodu **başarısız** olur |
| Tanınan ama uygulanmamış bir meta politikasını yok saymak | `META_MIR_POLICY_NOT_IMPLEMENTED` tanısı |
| Hedefte olmayan bir sağlayıcıyı taklit etmek | `library type provider type mismatch` gibi reddetme |
| "Kapsandı" raporuna yalnızca `host fallback` yazıp geçmek | `DIRECT`, `PORTABLE_RUNTIME`, `HOST_REQUIRED` ayrı sayılır; `HOST_REQUIRED` tam destek **sayılmaz** |

Bugünkü derleyicinin bu ilkeye **tam uymadığı** yerler vardır (örneğin eksik bir ifadeyi sessizce kabul etmek, bazı
hedeflerde yanlış çıktı üretmek). Bunlar saklanmaz: **Ek G**'de numarasıyla listelenir ve ilgili bölümlerde **✖ SINIR**
etiketiyle gösterilir. Hedef, listenin sıfıra inmesidir.

### İlke 3: Her şey açık (tipler, dönüşümler, kapsam)

* Her değişkenin tipi bellidir; `I32`, `U8`, `F64` gibi **boyutu adında yazan** tipler kullanılır.
* Dönüşüm örtük değil açıktır: ondalıklı bir sayıyı tamsayıya atamak için `I32(x)` yazılır, aksi hâlde derleme hatası olur.
* Değişken önce `DIM` ile tanımlanır; tanımsız ad kullanmak hatadır.
* Eski `LONG`, `INTEGER`, `DOUBLE` adları ve `$ # % ! &` tip sonekleri **kullanılmaz** (Bölüm 4.1).

Bugünkü derleyici bu ilkeyi **atamada** ve (`20261014_0253` derlemesinden beri) **metin + sayı karışımında** uygular: `5 + "a"`, `n = "5"`, `"a" < 5` gibi karışık işlemler `UXB_MIXED_STRING_NUMERIC` ("string and numeric operands cannot be mixed; use STR or VAL") ile altı yolda reddedilir; `20261007` ikilisinde bunlar sessizce `5a` yazardı ve x64 çökerdi (G-DIL-8, G-DIL-13, G-DIL-14: kapandı).
Henüz uygulamadığı yerler: **çağrı argümanlarında** parametre tipine uymayan argüman hata vermeden kabul edilir (✖ SINIR: G-YORDAM-3, G-YORDAM-4); `STRING` değişkene sayıyı `+=` ile eklemek (`s += 7`) reddedilmez, hatta x64'te **çöker** (✖ G-DIL-16); eski tip adları da `I32` gibi kabul edilir (G-TIP-6). Bu durumlarda dönüşümü **siz** açıkça yazın (`STR(n)`, `VAL(s)`).

### İlke 4: İç içe kullanılabilirlik (bileşilebilirlik)

uXBasic'in yapıları birbirinin **içine** girebilir ve birbirinin **çıktısını** girdi olarak alabilir; kullanıcıdan "bunlar birlikte
olmaz" diye bir özel durum listesi ezberlemesi beklenmez:

* Bir işlevin sonucu, başka bir işlevin parametresi olabilir; bir görev başka görevi başlatabilir, kendini bile.
* Önişlemci bir `FUNCTION` üretir, o `FUNCTION` bir görevden çağrılır, görev bir kütüphane tipi döndürür.
* Meta komutlar derleyicinin iç aşamalarına (AST, MIR, çıktı üreticisi) bağlanacak biçimde tasarlanmıştır: bir `REM %%ATTR` satırı
  yalnızca bir yorum değil, derleyici kaydına giren bir tanım olacaktır (**◇ HEDEF**; bugün bu satırlar yok sayılır: Bölüm 18, G-META-1).
  Bugün derleyicinin iç bilgisine JSON raporları ve onları okuyan araçlar üzerinden ulaşılır.

Bu ilkenin kanıtı Bölüm 22'dedir. Bir birleşim henüz çalışmıyorsa **◇ HEDEF** veya **✖ SINIR** yazılır, "olmaz" denmez.

### İlke 5: Küçük çekirdek, güçlü genişletme

Derleyici çekirdeği yalnızca makinenin gerçekten bildiği tipleri (tamsayılar, kayan noktalılar, işaretçi, metin) bilir.
`RATIONAL`, `COMPLEX`, `POLYNOMIAL` gibi tipler **kütüphane tipi** olarak, bir **manifest** (sözleşme) ile gelir; operatörleri
(`+`, `*`), yaşam döngüsü kuralları ve her hedefteki karşılıkları bu sözleşmede yazılıdır. Yarın biri `MATRIX` ya da `QUATERNION`
eklemek istediğinde derleyici kaynağına dokunması gerekmez (Bölüm 19).

### İlke 6: Kanıt önce

"Çalışıyor" demek için **çalıştırılmış bir kanıt** gerekir. Reddetme testinin geçmesi, özelliğin çalıştığını kanıtlamaz. Bu belgedeki
her örnek bu yüzden gerçek derleyiciyle koşturulmuştur ve sonucu altında yazılıdır.

### Bir yedinci kural: eski biçimler kırılmaz, ama uyarı alır

Eski kaynak kodlar bir süre çalışmaya devam eder (örneğin `%%PP A` / `%%PP B`, kısa `SLOT ad ON` biçimi, `LONG` takma adı).
Bunlar **⌛ ESKİ** olarak işaretlenir; yeni kodda kullanılmaz ve ileride tanı uyarısı verebilir.

## 1.3 Motorlar ve ne zaman hangisi?

| Motor | Güçlü yanı | Zayıf yanı | Ne zaman seçilir? |
|---|---|---|---|
| **AST** | Hızlı anlam sınaması; hata iletileri en açık; kayıtlı farkların bir bölümünde (ör. G-VERI-11 `UNION`, G-NESNE-3 yalnız-`GET` özellik, G-NESNE-19 `RESTRICTED`) doğru sonucu veren tek motordur | En yavaş; **her zaman doğru değildir**: taban kurucusunu çalıştırmaz (G-NESNE-25), sanal çağrıda ve değerlendirme sırasında öbür motorlardan ayrışır (G-NESNE-24, G-DIL-15), nesne sonuçlarını paylaşır (G-NESNE-9) | Programın sonucunu öğrenmek, hata ayıklamak; ama sonucu bir ikinci motorla da karşılaştırın |
| **MIR** | Ara kodu doğrudan sınar; AST ile aynı sonucu vermelidir | Yavaş | Derleyici geliştirirken AST ↔ MIR eşliğini denetlemek |
| **x64** | Gerçek hız; DLL/API çağrısı; gerçek eşzamanlılık; EXE üretir | Yalnız Windows x64 | Bitmiş programı dağıtmak, hız, sistem programlama |
| **JS** | Tarayıcıda/Node'da çalışır | Görevler, dosya G/Ç, DLL, 64 bit tamsayı vb. eksik; bazı yanlışlar var | Web arayüzü, tarayıcı programları |
| **WASM** | Güvenli, taşınabilir; tarayıcı ve Node | Yalnız tamsayı alt kümesi; metin, kayan nokta, koleksiyon yok | Küçük hesaplama çekirdekleri |
| *Eski AST-x64* | Eski kod üreticisi; korunur (2026-10-11) ve **dondurulmaz**: öteki motorlar gibi aynı sonucu verecek şekilde düzeltilecektir (Mete, 2026-10-14) | Bugün yeni özellikleri reddeder; bilinen sessiz yanlış ve çökme kusurları vardır (aşağıdaki alt bölüm) | Karşılaştırma; düzeltmeler bitene dek yeni program için MIR-x64 |

> **Bağlayıcı karar (Mete, 2026-10-11; G-HEDEF-19):** 2026-10-10 motor sadeleştirme önerisi (iki MIR temsilini birleştirmek, MIR yorumlayıcısını varsayılan yapmak, AST yorumlayıcısını referans rolüne çekmek, eski AST-x64'ü emekliye ayırmak) **kabul edilmedi**.
> AST, MIR, MIR-x64, AST-x64, JS ve WAT/WASM üretim yolları **korunur**; aşağıdaki tablo bu yüzden bir geçiş tablosu değil, kalıcı yol haritasıdır.
> Kararın ikinci yarısı bir **kuraldır**: bir komutun tasarım dışı bir hedefte çalışmaması, hedefe göre sessizce farklı davranmak yerine **ortak bir tanı koduyla** bildirilir (Bölüm 12.4; ilk uygulama kütüphane tipi sağlayıcı hataları). Rapor her zaman gerçekte kullanılan motoru bildirir; AST komutu gizlice MIR'e yönlendirilmez.

Bu motorların bugünkü **gerçek** eşlik durumu, bu belgedeki doğrulanmış örnekler üzerinden şöyledir (hücre = geçen/denenen örnek):

{{ESLIK_OZETI}}

Bu tablo, belgenin geri kalanında kullanılan sınama kümesinin özetidir. `AST`, `MIR` ve `x64` sütunlarının dolu olması hedefin ilk
yarısıdır; `JS` ve `WASM` sütunları, ilkenin ikinci yarısının (tek kaynak, çok hedef) hâlâ yapılmakta olduğunu gösterir.
Eksik olan her şeyin nedeni örnek altında **açık ret** (◌) ya da **sınır** (✖) olarak yazılıdır.

### Eski AST-x64 yolunun ölçülen durumu

Eski AST-x64 yolu (`uxb bld k.uxb --build-x64 --x64-mode AST`) 2026-10-11 kararıyla korunur; **Mete'nin 2026-10-14 kararıyla dondurulmaz, öteki motorlar gibi aynı sonucu verecek şekilde düzeltilecektir** ("dondur ve STRING kullanan programları açık redle karşıla" seçeneği reddedildi). Aşağıdaki kusurlar bu yüzden kabul edilmiş bir sınır değil, düzeltme kuyruğundaki kayıtlardır. Yol, aşağıdaki "Motor sorumlulukları" tablosunda şu sözleşmeyle durur: **MIR-x64 ile aynı sonuç; destek yoksa derleme zamanı yetenek hatası.** Bu sözleşmenin bugünkü durumu `20261014_0253` ile ölçüldü: örnek klasörünün 282 programı (bu belgede 197'si anlatılır), 303 iddia vakası ve yeni `iddia_eski_astx64` dosyasının 15 vakası (ham sonuçlar `docs/kitaplar/_ortak/ornek_sonuclari_astx64_20261014_0253.json`). Aşağıdaki kusurların hepsi `20261007`'de de aynıdır; hiçbiri yeni bir gerileme değildir. İyileşen tek yan: 303 iddia vakasının 8'i `20261007`'den bu yana değişti ve hepsi düzeldi (`MAGIC AND/OR/XOR` artık `4`, `12`, `8`; `5 + "a"` ve bilinmeyen FFI tipi açık ret; `swap`, `sleep`, `with` parantezsiz çağrısı `UXB_CALL_PAREN_REQUIRED`).

| Sonuç | Örnek |
|---|---|
| Beklenen çıktıyı verdi | 176 |
| Beklenen çıktı tanımlı değil (çalıştı, çıktı denetlenmedi) | 27 |
| Derleme aşamasında reddedildi | 58 |
| Çalıştı ama çıktı yanlış ya da program kendi denetimiyle durdu | 18 |
| Erişim ihlaliyle çöktü | 2 |
| Örnek yalnız AST ve MIR için yazılmış (DLL bulunamadı) | 1 |

Reddedilen 58 örneğin nedenleri: `SPAWN`/`TASK`/`TASKGROUP` (10), rutinden atılan istisnanın çağıranda yakalanması (5), `DIM ATOMIC` (5), `LOCK` (3), `MUTEX` (1), `BYREF` (2), LIST/STRING/DICT üzerinde `FOR EACH` (5), çok boyutlu dizi (6: eleman ataması ve `LBOUND`/`UBOUND`), `END` deyimi (1; her konumda reddedilir), kütüphane tipi `RATIONAL` (1, `UXB_LIBTYPE_PROVIDER_UNAVAILABLE`) ve **derleme betiği hatası** (13: `DICT`, `SET`, `TRIM`, `ATN`, `CDBL`, F80 yazdırma, `SLOT` geri çağrısı, modül işlevi çağrısı, FFI; kullanıcı yalnız `build_all.bat failed with exit code 1` görür, gerçek neden `build_all.stderr.txt` içindedir, ✖ G-HATA-14). Kalan altısı iç hata iletileriyle reddedilir (arayüz yuvası, `CALL_EXPR` dönüş tipi, boş ileti, `unsupported AST node kind=NUMBER` ve iki yoklama programı).

Reddetmek sözleşmeye uyar. Sözleşmeyi **çiğneyenler** çalışıp yanlış sonuç veren ya da çöken yapılardır; her biri ayrı bir kayıttır:

| Kayıt | Belirti (eski AST-x64'te) | Ne yapmalı? |
|---|---|---|
| ✖ G-ISLEC-11 | `F64`/`F32` değişkende tekli eksi bozuk: `x = -x` (`x = -2.5`) → `4.61e+18` | `0 - x` yazın |
| ✖ G-ISLEC-12 | `PRINT a / b` (iki `I32`) tamsayı bölümü verir: `3`, diğer yollar `3.5`; `CDBL` yok | Sonucu `F64` değişkene atayın |
| ✖ G-ISLEC-13 | İçinde `PRINT` olan işlev, tamsayı işlemin sağ işleneniyse program iletisiz çöker (`6 + Yn(3)`) | Sonucu önce değişkene alın |
| ✖ G-TIP-28 | Rutin içindeki yerel tamsayı ondalık işlemde bit düzeniyle okunur (`v * k` → `4.7e-320`) | Değeri parametreye ya da genel değişkene alın |
| ✖ G-YORDAM-7 | Yerel değişken sıfırlanmaz, önceki çağrının yığın değerini taşır | `DIM n AS I32 = 0` yazın |
| ✖ G-METIN-6 | `a = STR(5000)` sonra `b = STR(4)` yazınca `a` da `4` olur; birleştirmeyle (`+`, `LEFT`) atanan metin değişkeni 32 metin işleminden sonra başka metne dönüşür (eski S-157-L) | `a = "" + STR(5000)` yazın; uzun metin döngülerinden sonra kullanılacak yolları kullanımdan hemen önce yeniden kurun |
| ✖ G-DOSYA-7 | `PRINT #1, 10` (tamsayı) çöker | `PRINT #1, STR(10)` yazın |
| ✖ G-DOSYA-8 | Satır sonu `LF`: `LOF` `4`, diğer yollar `5` | Boyuta dayanmayın |
| ✖ G-VERI-13 | `REDIM` ile büyütülen dizi büyümez, komşu belleği bozar; yerel dizide çıkışta çöker | `REDIM` kullanmayın |
| ✖ G-AKIS-3 | `F64` `FOR` sayacı tamsayı gibi artar (`FOR x = -2 TO 2` → `-nan -nan 0 …`) | Tamsayı sayaç kullanın |
| ✖ G-MODUL-5 | `MODULE` içindeki değişken okunamaz (adres benzeri sayı gelir) | Genel değişken kullanın |

Çalışıp yanlış sonuç veren ya da çöken 20 örneğin hepsinin nedeni bilinir. On biri G-METIN-6'dan (ve bazısı ayrıca G-ISLEC-11'den) bozulur ve kopya (`"" + STR(…)`), yolu kullanımdan hemen önce yeniden atama ya da `0 - x` yamasıyla eski AST-x64'te beklenen çıktıyı verir: `istatistik_regresyon`, `matris_denklem`, `tensor_not_analizi`, `maliyet_ve_buyume`, `sinir_agi_xor`, `gsl_geri_cagri_integral`, `tampon_goruntu`, `ayar_gunluk_surec`, `ilk_adim`, `csv_model_egitimi`, `dosya_butunluk_sikistirma` (yama kanıtı). Dokuzu başka bir kusura bağlıdır: `ai_siniflandirici_cikisi` (G-AKIS-3 ve G-ISLEC-11), `gsl_hesap_defteri` (G-TIP-28), `stok_moduller` (G-MODUL-5), `bit_sayma` (G-YORDAM-7), `const_dim_redim` (G-VERI-13), `lof` (G-DOSYA-8), `secim_kisa_devre` (G-ISLEC-13), `dosya_toplam` (G-DOSYA-7) ve `buyuk_sayi_bigint` (G-TIP-1). Sonuç: bu yol çalışan basit programlarda doğrudur, ama **bu kılavuzdaki hiçbir örneğin "eski AST-x64'te de çalışır" diye varsayılmasına izin vermez**; yeni bir program için varsayılan MIR-x64 yolunu (`uxb bld … --build-x64`) kullanın. Kusurlar kapatıldığında `iddia_eski_astx64` vakaları yeşile döner.

### Motor sorumlulukları ve tekil otorite (tasarım sözleşmesi)

`docs/MOTOR_SORUMLULUK_VE_PARITE_SOZLESMESI_20260916_CODEX1.md` her motora bir görev ve bir başarı ölçütü verir ve bir düzeltmenin **yalnız tek motorda çalışmasını tamamlanma saymaz**:

| Motor | Görevi | Kanonik girdisi | Başarı ölçütü |
|---|---|---|---|
| AST yorumlayıcı | Kaynak AST'yi doğrudan çalıştırır; hızlı anlam ve çalışma zamanı yoklaması | AST + ortak çalışma zamanı sözleşmesi | Dil sonucu ve hata kodu |
| Kanonik MIR yorumlayıcı | AST anlam çıktısını opcode sözleşmesiyle çalıştırır | Kanonik MIR | AST ile aynı değer ve hata |
| MIR-x64 | Kanonik MIR'i yerel x64 ABI'sine üretir | Doğrulanmış MIR | MIR sonucu ve çıkış davranışı |
| AST-x64 | Eski, doğrudan AST yerel arka ucu; **uyumluluk** yolu (dondurulmaz, Mete 2026-10-14) | AST | MIR-x64 ile aynı sonuç; destek yoksa derleme zamanı yetenek hatası (bu bir ara durumdur, hedef tam eşliktir) |
| JS / Node | Kanonik çağrıları JS çalışma zamanına taşır | Kanonik MIR / JS üretici | Konak sonucu ve hata sözleşmesi |
| WASM / WAT | Kanonik çağrıları WAT/WASM içe aktarma ve çalışma zamanına taşır | Kanonik MIR / WAT üretici | `wat2wasm` doğrulaması ve çalışma sonucu |

**Tekil otorite:** (1) ayrıştırıcının AST biçimi sözdiziminin tek sahibidir; (2) anlam çözümleme / tip bağlama tür, dönüşüm, kalıtım ve aşırı yüklemenin tek sahibidir; (3) kanonik MIR opcode ve işlenen biçimi, arka uçların **tek** yürütme sözleşmesidir; (4) ortak çalışma zamanı sözleşmesi hata kodlarını, bellek sınırlarını, koleksiyon tutamaçlarını ve nesne ömrünü tanımlar; (5) arka uç yetenek / hazırlık kapısı, desteklenmeyen yapıyı assembler ya da WAT aşamasına bırakmadan bildirir.

**Her yeni komut için zorunlu kayıt:** ayrıştırıcı AST düğümü ve işlenen biçimi; anlam çözümlemedeki tip ve dönüşüm kuralı; kanonik MIR opcode'u ve doğrulayıcı kuralı; AST, MIR, JS/WASM, MIR-x64 ve AST-x64 yolları; başarı çıktısı, hata kodu ve sınır sınaması; tek bir eşlik yoklaması ve sonuç JSON'u; ikincil/eski yol varsa açıkça `uyumluluk` olarak işaretlenmesi. Bu kılavuzdaki ölçümler bu zorunlu kaydın dışarıdan sınanmış hâlidir: her kusur, kendisini gösteren en küçük program ve motor sonuçlarıyla Ek G'ye ve `SORUN_TAKIP.md`'ye girer.

## 1.4 Derleme hattı

Bir uXBasic programı, çalışmadan önce aşağıdaki aşamalardan geçer. Her aşamanın çıktısı bir sonrakinin girdisidir:

```
 ham .uxb kaynağı
      │
      ▼
 ┌────────────────────────┐
 │ ÖNİŞLEMCİ  (%% komutları)│  %%DEFINE, %%IF, %%FOREACH, %%MACRO, %%TEMPLATE ...
 └────────────┬───────────┘      → genişletilmiş kaynak (expandedSource)
              ▼
 ┌────────────────────────┐
 │ META TARAMA (REM %%)    │  REM %%ATTR, REM %%MIR → MetaRegistry
 └────────────┬───────────┘
              ▼
 ┌────────────────────────┐
 │ SÖZCÜK ÇÖZÜMLEME (lex)  │  → belirteç (token) listesi
 └────────────┬───────────┘
              ▼
 ┌────────────────────────┐
 │ ÇÖZÜMLEYİCİ (parser)    │  → AST (soyut sözdizimi ağacı)
 └────────────┬───────────┘
              ▼
 ┌────────────────────────┐
 │ ANLAM ÇÖZÜMLEME (sem)   │  tip bağlama, kapsam, yerleşim (layout), kütüphane tipleri
 └────────────┬───────────┘
              ▼
 ┌────────────────────────┐
 │ MIR                     │  anlamsal MIR → kanonik MIR (doğrulanır)
 └───┬─────────┬──────┬────┘
     ▼         ▼      ▼
  MIR yorum.  x64    JS / WAT→WASM
  (run)      (NASM)  (jsw / wat)

  AST yorumlayıcı (run / int) ve eski AST-x64 doğrudan AST'den beslenir.
```

| Aşama | Ne yapar | Bu aşamada durmak için | Ürettiği dosyalar (`--out-root` altında) |
|---|---|---|---|
| Önişlemci | `%%` komutlarını çalıştırıp kaynağı üretir | `uxb lex dosya.uxb --preprocessed-out out.txt` | `json/frontend/preprocess/preprocessed.uxb` |
| Sözcük çözümleme | Kaynağı belirteçlere böler | `uxb lex` | `json/frontend/lexer/tokens.json` |
| Çözümleme | Sözdizimi ağacını kurar | `uxb par` / `uxb ast` | `json/frontend/parser/ast.json` |
| Anlam çözümleme | Tipleri ve adları bağlar, hataları yakalar | `uxb sem` | `json/semantic/symbols.json`, `types.json`, `layouts.json` |
| MIR | Tüm hedeflerin ortak ara kodu | `uxb mir dosya.uxb --semantic` | `json/mir/canonical_mir.json` |
| x64 | Assembly (NASM) ve EXE | `uxb x64` / `uxb bld` | `asm/.../output.asm`, `.exe` |
| JS | JavaScript | `uxb jsw` | `.js` |
| WAT/WASM | WebAssembly metni ve ikili | `uxb wat` | `.wat`, `.wasm` |

> **Önemli:** Anlam çözümlemeden sonra her hedef **aynı MIR'i** kullanır. Bu yüzden bir özellik MIR'e doğru indirgenmişse JS, WASM ve
> x64'e aktarılması "yalnızca" o hedefin yazıcısını tamamlamaya kalır. Hedeflerin ayrı ayrı yeniden yorumlanmaması, eşlik ilkesinin
> mühendislik karşılığıdır.

`--stop-after <aşama>` seçeneği tanıtılmıştır ama bugün **etkisizdir** (her değeri kabul eder, aşamayı fiil belirler): **✖ SINIR (Ek G, G-CLI-5)**.

## 1.5 Çıktı klasörü

Her `uxb` çağrısı, `--out-root` verilmezse çalışma dizininde `build/<gg_aa_yyyy_ss_dd_ss>/` adında yeni bir klasör açar.
Alt klasörler: `json/` (raporlar), `logs/` (günlükler), `asm/`, `obj/`, `web/`. Hata günlükleri `logs/` içindedir: `uxbasic.hata.log` **merkezi hata günlüğüdür** (derleyicinin hata merkezi `UxbError`, `DiagHata`, `UxbWarn` ve yapılandırılmış tanı kayıtlarını buraya yansıtır; var olan log/JSON/CSV raporlarının yerine geçmez, ek bir hattır), `<program>.hata.log` programa özgü hata günlüğüdür. Sık deneme yaparken `--out-root` ile
tek bir geçici klasör verilir ve işiniz bitince silinir; böylece proje klasörü şişmez.

Çıktı kökü politikası (`docs/hata_merkezi_ve_raporlama_politikasi_20260606.md`): derleyicinin resmî çıktıları kaynak ağacına değil `build/<çalıştırma>/<dosya_tipi>/` yapısına yazılır (`json/`, `asm/`, `obj/`, `exe/`, `dll/`, `web/`, `logs/`); `dist/` yalnız dağıtım içindir; araçlar ve yapay zekâ kullanıcı adına kaynak dosya **silmez**, gereksiz görülenleri raporlar ya da onayla emekli arşivine koyar.

## 1.6 Çıkış kodları

| Kod | Anlamı |
|---|---|
| `0` | Başarılı |
| `1` | Anlam çözümleme / çözümleyici hatası (derleme reddedildi) |
| `2` | Sözcük çözümleme hatası ya da desteklenmeyen dosya uzantısı |
| `5` | AST yorumlayıcı çalışma anı hatası (sıfıra bölme, sınır dışı indeks, adım sınırı, geçersiz `--virtual` boyutu…) |
| `6` | MIR-x64 NASM üretimi başarısız (örneğin `--x64gen-out` ile klasör verilmesi, G-CLI-30) |
| `11` | MIR üretimi başarısız |
| `13` | MIR yorumlayıcı çalışma anı hatası |
| `14` | x64 kod üretimi başarısız |
| `20` | Bilinmeyen CLI seçeneği |
| `22` | Çıktı isteği yerine getirilemedi: programı çalıştırmayan fiille `--stdout-out`, `--stderr-out` ya da `--runtime-trace-json-out` istendi (`runtime/stdout/stderr ciktisi istendi ama interpreter/runtime calistirilmadi`) ya da bir rapor dosyası yazılamadı (`… yazilamadi: report write open failed`; örneğin iki karakterli göreli `--out-root`, G-CLI-29) |
| `23` | Web arka uç hattı başarısız (`uxb wat` / web üretimi; örneğin WASM'ın reddettiği ondalık değer, metin ya da `BYREF`) |
| `27` | Kapanış kapısı başarısız: AST→MIR kapsam denetimi (`ADIM25/26/27 close gate failed`; örneğin değişkenle tekli `+x`, `!x` ya da hiç başvurulmayan rutinde `DELETE`) |

Üretilen **x64 EXE'nin kendi** çıkış kodu da vardır: `0` başarı; çalışma anı hatasında `1` (iletili) ya da `2` (iletisiz, G-HATA-9). JS'te sınır dışı erişim hata vermez ve çıkış kodu `0` kalır (G-HATA-6); yakalanmayan `THROW` ise `20261007`'de `0` verirdi, `20261013_1514`'ten beri `1` verir (G-JS-14). Çıkış kodları motorlar arasında ortak değildir (G-HATA-7).

Başka bir hata kodu görürseniz `build/.../json/diagnostics/all_diagnostics.json` dosyasındaki tanıya bakın. **Bu dosya yalnız derleme zamanı tanılarını taşır** (ayrıştırma, anlam çözümleme ve hedef doğrulama reddi). AST ve MIR yorumlayıcılarının çalışma anı hataları (`5` ve `13` çıkışları) bu dosyaya ve `vscode_diagnostics.json`'a hiç yazılmaz: dosya oluşur ama `count` 0 kalır (✖ G-HATA-11). Çalışma anı hatasında çıkış kodunu ve metin satırını ya da `--diag-format json` terminal çıktısını okuyun.

## 1.7 İlkelerden çıkan programlama kararları

* **Programınızı önce AST'de çalıştırın**, sonra MIR ve x64'te aynı çıktıyı doğrulayın. Çıktılar ayrışıyorsa bu sizin programınızın değil derleyicinin kusurudur (İlke 1); ama yeni bir kusur bildirmeden önce Ek G'de kaydının olup olmadığına bakın.
* **Hedefi baştan seçin** (1.3): hız, EXE, DLL çağrısı ve görev → x64; tarayıcı → JS; küçük tamsayı hesap çekirdeği → WASM. Seçtiğiniz hedefin desteklemediği özelliği kullanmayın; Bölüm 21'deki tabloya bakın.
* **Tipleri açıkça yazın**: boyutu adında yazan tipler (`I32`, `U8`, `F64`) ve açık dönüşümler (`I32(x)`, `STR(n)`) kullanın. Eski ad (`LONG`, `DOUBLE`) ve soneklerden (`$ # % ! &`) kaçının (İlke 3).
* **Derleyicinin sessiz kabul ettiği yerleri kendiniz denetleyin** (12.5): çağrı argümanı tipleri, `RETURN` ile bitmeyen yollar, `STRING` değişkene sayı `+=` ile eklemek, çift `DIM`. İlke 2'ye göre bunlar düzeltilecek kusurlardır, ama bugün sizi korumazlar.
* **Bir yapı ötekiyle çalışmıyorsa "olmaz" demeyin**, ◇ HEDEF ya da ✖ SINIR etiketini arayın (İlke 4): kayıt numarası varsa derleyici düzeltilecek, yoksa bildirin.
* **Yeni bir veri tipi gerekiyorsa** derleyiciye dokunmadan `LIBTYPE` manifestiyle kütüphane tipi olarak ekleyin (İlke 5, Bölüm 19).
* **"Çalışıyor" demeden önce çalıştırın** (İlke 6): reddetme testinin geçmesi özelliğin çalıştığını kanıtlamaz. Beklenen çıktıyı yazın, programı gerçekten koşturun, çıktıyı karşılaştırın.
* Eski biçimleri (⌛ ESKİ) yeni kodda yazmayın; çalışmaya devam ederler ama ileride uyarı alabilirler.
* Deneme çıktılarını `--out-root` ile tek bir geçici klasöre yönlendirin (1.5); betiklerde **çıkış kodunu denetleyin** (1.6): `0` başarı, `1` anlam çözümleme, `5` AST çalışma anı, `13` MIR çalışma anı, `14` x64 üretimi hatası.
* Derleme hattının bir aşamasında durmak için `--stop-after` kullanmayın (etkisizdir, G-CLI-5): ilgili fiili seçin (`lex`, `par`, `sem`, `mir --semantic`, `x64`).
