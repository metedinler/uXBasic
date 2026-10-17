# S-555: Çoklu kalıtım (B seçeneği) ve çakışma denetimi anahtar sözcükleri

**Tarih:** 2026-10-16 · **Yazan:** Claude · **Durum:** `ACIK-TASARIM-KARARI-KAYITLI` (Mete: "B ile devam")
**İlgili kayıtlar:** S-555 (çoklu kalıtım), S-556 … S-560 (arayüz mirası, iç içe sınıf, sınıf sabiti, arayüzde gövde, kurucu aşırı yükü), S-484 (`THIS`/`ME`), S-487 (`SUPER(...)`), S-360 (`ABSTRACT/FINAL/SEALED/MIXIN`), S-382 (aynı sınıfta aynı adlı iki metot)
**Dayanak belgeler:** `docs/tasarim/UXB OPP SISTEMI TASARIM VE TARTISMALARI.md` (Mete'nin tasarım konuşması, bölüm 1–4), `docs/tasarim/uXBasic_OOP_Tam_Sistem_Denetimi_2026-10-16.md` (K-03, K-04, K-07), `docs/OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md` (`THIS` doğrudan, `ME` sanal, `SUPER` sözcüksel).

---

## 1. Karar ve Mete'nin fikri

**Karar (2026-10-16):** Çoklu kalıtımın **B** seçeneği seçildi: bir sınıf birden çok sınıftan **hem davranışı hem durumu (alanları)** devralabilir. A (yalnız durumsuz karışım) ve C (aşamalı) seçilmedi; ama aşağıdaki uygulama planı B'yi **aşama aşama** teslim eder (bölüm 7), yani C'nin güvenli yanı B'nin içinde kalır.

**Mete'nin fikri (aynı mesaj):** "Bir ana sınıftan ve bir baba sınıftan miras alan yeni sınıfta aynı isimde iki metot varsa çakışma olabilir. Yeni sınıf bazı anahtar kelimelerle metotların birleştirilmesini durduramaz mı?"

**Cevap: evet, durdurabilir; ve bunu böyle tasarlıyorum.** İlke tek cümle: **derleyici iki aynı adlı metodu asla sessizce birleştirmez.** Çakışma varsa program derlenmez; yeni (miras alan) sınıf, hangi metodun kazanacağını **anahtar sözcüklerle açıkça** yazar. Böylece "birleştirmeyi durdurmak", çakışmayı sessiz bir tahmine bırakmak yerine yazılı bir karara bağlamak olur.

## 2. Sade anlatım (okuyan için)

* **Kalıtım**, bir sınıfın başka bir sınıfın alan ve metotlarını hazır almasıdır. `CLASS Köpek EXTENDS Hayvan`: Köpek, Hayvan'ın her şeyine sahip olur.
* **Çoklu kalıtım**, bir sınıfın iki ayrı sınıftan birden hazır almasıdır: `CLASS Amfibi EXTENDS KaraAraci, SuAraci`. Amfibi araç hem karada giden hem suda giden aracın özelliklerini taşır.
* **Çakışma**, iki tabanın **aynı adlı** üye vermesidir. İkisinde de `Sür()` varsa `amfibi.Sür()` hangisi olmalı? Karadaki mi, sudaki mi, ikisi birden mi? Bilgisayar tahmin etmemelidir; çünkü yanlış tahmin, program çalışırken fark edilen sessiz bir hata olur.
* **Çözüm:** miras alan sınıf bir **karar cümlesi** yazar. Dört karar cümlesi vardır (bölüm 3.2). Karar yazılmadıysa derleyici durur ve hangi cümlenin yazılabileceğini söyler.
* **Elmas sorunu**: `KaraAraci` ve `SuAraci` ikisi de ortak bir `Arac` sınıfından türüyorsa `Amfibi`'de `Arac`'ın alanları (örneğin `hiz`) bir mi olur iki mi? Hedef: **bir** (bölüm 3.5).

## 3. Kurallar

### 3.1 Varsayılan: sessiz birleştirme yoktur

`CLASS C EXTENDS A, B` yazıldığında C'nin üye tablosu A ve B'nin üyelerinin birleşimidir. İki **farklı** tabandan **aynı ad ve aynı imzada** üye gelirse (ve bölüm 3.3'teki üstünlük kuralı çakışmayı çözmüyorsa) derleme **durur**:

```
UXB_AMBIGUOUS_MEMBER: 'Sur' is inherited from both KaraAraci and SuAraci in Amfibi;
resolve it with OVERRIDE METHOD Sur, PREFER KaraAraci.Sur, RENAME SuAraci.Sur AS <ad> or EXCLUDE SuAraci.Sur
```

Aynı ad **farklı imzada** ise çakışma değildir; fakat bugün sınıfta aşırı yükleme yoktur (S-382, G-NESNE-16), o zamana kadar bu da `UXB_AMBIGUOUS_MEMBER` sayılır (güvenli taraf).

### 3.2 Dört karar cümlesi

| Cümle | Ne yapar | Örnek |
|---|---|---|
| `OVERRIDE METHOD Sur() … END METHOD` | Miras alan sınıf **kendi** metodunu yazar; iki tabanın da `Sur`'ü gizlenir, ikisine de `SUPER[Taban].Sur()` ile ulaşılır | zaten vardır (bölüm 3.6 yalnız `SUPER[Taban]` ekler) |
| `PREFER KaraAraci.Sur` | `Sur` adı **KaraAraci'nın** metodudur; aynı adlı öbür taban üyeleri (`SuAraci.Sur`) **bu sınıfın yüzeyinde** görünmez, ama `SUPER[SuAraci].Sur()` ile ve `SuAraci` görünümüyle ulaşılır | tek satır, gövde yok |
| `RENAME SuAraci.Sur AS SuSur` | Sudaki metot **yeni adıyla** (`SuSur`) kalır; `Sur` adı yalnız öbür tabandan gelenin olarak kalır, yani çakışma tek başına biter. İki metot da kullanılabilir | tek satır |
| `EXCLUDE SuAraci.Sur` | Tabanın o üyesi **bu sınıfın yüzeyine alınmaz** (yine `SUPER[SuAraci].Sur()` ile çağrılabilir). İkiden çok tabanda yalnız o üyeyi eler; `PREFER` ise adı verilen dışındaki hepsini eler | tek satır |

* Bu dört cümle **gövde dokuması yapmaz**: iki metodu "arka arkaya çalıştıran" üçüncü bir metot kendiliğinden oluşmaz. Bunu isteyen `OVERRIDE METHOD Sur()` yazar ve içinde ikisini de açıkça çağırır: `SUPER[KaraAraci].Sur()` ve `SUPER[SuAraci].Sur()`. (Gizli birleştirme tam olarak durdurulmak istenen şeydir.)
* `PREFER`, `RENAME`, `EXCLUDE` **bağlamsal sözcüklerdir**: yalnız sınıf gövdesinde bir satırın başında ve ardından `Sınıf.Üye` geldiğinde anlam taşırlar. Bu yüzden **yeni ayrılmış sözcük oluşturmazlar**; bugün `prefer`, `rename`, `exclude` adlı bir değişken kullanan programlar bozulmaz (`EXTENDS` ve `IMPLEMENTS` ayrıştırıcıda aynı yolla tanınır).
* Bir üye için karar cümlesi ya da `OVERRIDE` yazılmışsa çakışma çözülmüştür; **gereksiz** karar cümlesi (çakışma yokken) bir **uyarıdır**, hata değil.
* Karar cümleleri **taban görünümünü değiştirmez** (bölüm 3.7): `DIM s AS SuAraci = a` ile tutulan nesnede `s.Sur()` hâlâ SuAraci'nın (ya da `OVERRIDE` varsa Amfibi'nin) metodunu çağırır.

### 3.3 Üstünlük (dominance) kuralı: çakışma olmayan durum

A ve B'nin ortak bir tabanı `T` varsa ve `T.Sur` yalnız **bir** kolda geçersiz kılınmışsa (A `OVERRIDE` etmiş, B etmemişse) o kol **kazanır**; çakışma sayılmaz. İki kol da farklı geçersiz kılma yapmışsa çakışmadır (bölüm 3.1). Bu kural olmasa elmasın en sık durumu gereksiz yere hata verirdi.

### 3.4 Alan çakışması

* İki farklı tabandan aynı adlı **alan** gelirse yine `UXB_AMBIGUOUS_MEMBER` (gizleme varsayılan hatadır; bugün tek kalıtımda da böyledir: `CLASS field hides inherited member`).
* Çözüm: `RENAME SuAraci.sayac AS suSayac` (iki alan da kalır) ya da `EXCLUDE SuAraci.sayac` (o alan bu sınıfın yüzeyinden çıkar; taban kendi içinde kullanmayı sürdürür).
* **Elmasta** (`Arac.hiz`, hem KaraAraci hem SuAraci üzerinden gelir) alan çakışması değildir: aynı tanım, aynı depolama (bölüm 3.5).

### 3.5 Elmas: ortak taban tek depolama

Aynı sınıf bir türetilmiş sınıfa birden çok yoldan ulaşıyorsa (elmas) onun alanları nesnede **bir kez** bulunur ve kurucusu **bir kez** çalışır (en derin ortak taban önce). Bu "sanal taban / tek depolama"dır ve ayrı bir anahtar sözcük **istemez**: iki ayrı kopya isteyen bir kullanım uXBasic için gerekçesiz bir hata kaynağıdır.

### 3.6 Kurucu, yıkıcı, `SUPER[...]`

* Kurucular **soldan sağa** (bildirim sırası), yıkıcılar **tersine** çalışır. Taban kurucusu parametre istiyorsa türetilmiş kurucu bunu açıkça verir: `SUPER[KaraAraci](t)`, `SUPER[SuAraci](p)`. Parametresiz taban kurucusu verilmediyse kendiliğinden çalışır (bugünkü davranış, S-485). **Parametreli bir taban kurucusu yazılmadıysa derleme hatasıdır** (`UXB_BASE_CTOR_REQUIRED`): bugünkü "beş motor beş ayrı davranış" durumu (bölüm 6) buradan kapanır.
* `SUPER[Taban].Metot(...)`: o tabanın uygulamasını **doğrudan** çağırır (sanal değil). Tek kalıtımda yalnız `SUPER.Metot()` yeterlidir; **çoklu kalıtımda niteliksiz `SUPER` belirsizdir** ve yalnız tek doğrudan taban o üyeyi veriyorsa kabul edilir, aksi halde `UXB_AMBIGUOUS_SUPER`.
* `THIS.Metot()` **doğrudan** (yazıldığı sınıfın uygulaması), `ME.Metot()` **sanal** (gerçek nesne türüne göre); kurucu ve yıkıcıda `ME` ile sanal çağrı yasaktır (11.10; bugünkü ayrıntı: S-484 ve S-576).

### 3.7 Taban görünümleri ve çok biçimlilik

Türetilmiş nesne, devraldığı **her** tabanın değişkenine atanabilir (`DIM k AS KaraAraci = a`, `DIM s AS SuAraci = a`); sanal çağrılar nesnenin gerçek türüne göre seçilir. Aşağı atama (daraltma) yalnız denetimli dönüştürmeyle yapılır (`AS`, S-587). `INSTANCEOF` bugün yalnız AST'de çalışır (G-NESNE-36); çoklu kalıtım gelmeden **altı yolda** çalışması gerekir (aşama M0).

### 3.8 Tanı kodları (yeni)

| Kod | Ne zaman |
|---|---|
| `UXB_AMBIGUOUS_MEMBER` | İki tabandan aynı üye, çözüm yok (bölüm 3.1, 3.4) |
| `UXB_AMBIGUOUS_SUPER` | Çoklu kalıtımda niteliksiz `SUPER` belirsiz |
| `UXB_BASE_CTOR_REQUIRED` | Parametreli taban kurucusu için `SUPER[...]` çağrısı yok |
| `UXB_RESOLUTION_TARGET_UNKNOWN` | `PREFER/RENAME/EXCLUDE X.y` içinde `X` doğrudan taban değil ya da `y` üyesi yok |
| `UXB_RESOLUTION_CONFLICT` | Aynı üyeye çelişen karar cümleleri (`PREFER A.y` ve `PREFER B.y`; `RENAME` hedef adı başka üyeyle çakışıyor) |
| `UXB_DIAMOND_NOT_YET` | **Yalnız M1 sürümünde:** ortak tabanlı çoklu yol (elmas) henüz desteklenmiyor; sessiz ikinci kopya yerine açık ret |
| `UXB_DUPLICATE_BASE` | Aynı sınıf `EXTENDS` listesinde iki kez |
| `UXB_MI_CYCLE` | Kalıtım döngüsü |

## 4. Sözdizimi

```
CLASS Ad [EXTENDS Taban1 [, Taban2 ...]] [IMPLEMENTS Arayuz [, ...]]
    [PUBLIC | PROTECTED | PRIVATE]
    PREFER   Taban.Uye
    RENAME   Taban.Uye AS YeniAd
    EXCLUDE  Taban.Uye
    ... alanlar, metotlar, kurucular ...
END CLASS
```

* Karar cümleleri sınıf gövdesinde, erişim bölümünden **bağımsız**dır (erişim bildirmezler).
* `SUPER[Taban]` yalnız sınıfın **doğrudan** tabanlarından birini adlandırır (dolaylı taban için ara sınıf adı yazılır).
* Başlıkta `MIXIN` (tasarım belgesindeki `CLASS Rapor EXTENDS Belge MIXIN Yazdirilabilir, Kaydedilebilir`) çoklu **karışımı** gösterir; ayrı iş paketidir (bölüm 7, M3). Bugün başlıkta `MIXIN` yazımı ayrıştırılıp gövde biçimiyle aynı sayılır ve `EXTENDS` ile birlikte reddedilir (aşağıda bölüm 6).

## 5. Örnekler

**5.1 Çakışmayı karar cümlesiyle çözmek (geçerli).**

```basic
CLASS KaraAraci
    PUBLIC
    DIM tekerSayisi AS I32
    VIRTUAL METHOD Sur()
        PRINT "Karada gidiyor"
    END METHOD
END CLASS

CLASS SuAraci
    PUBLIC
    DIM pervaneSayisi AS I32
    VIRTUAL METHOD Sur()
        PRINT "Suda gidiyor"
    END METHOD
END CLASS

CLASS Amfibi EXTENDS KaraAraci, SuAraci
    PUBLIC
    RENAME SuAraci.Sur AS SuSur     ' sudaki artık SuSur; Sur yalnız karadakidir
END CLASS

DIM a AS Amfibi = NEW Amfibi()
a.Sur()                             ' Karada gidiyor
a.SuSur()                           ' Suda gidiyor
DIM s AS SuAraci = a
s.Sur()                             ' Suda gidiyor (taban görünümü değişmez)
```

**5.2 Kendi metodunu yazmak, ikisini açıkça çağırmak (geçerli).**

```basic
CLASS Amfibi EXTENDS KaraAraci, SuAraci
    PUBLIC
    OVERRIDE METHOD Sur()
        SUPER[KaraAraci].Sur()
        SUPER[SuAraci].Sur()
        PRINT "Amfibi mod"
    END METHOD
END CLASS
```

**5.3 Karar yazmamak (geçersiz).** 5.1'deki `CLASS Amfibi EXTENDS KaraAraci, SuAraci` yalnız `PUBLIC` ile bitseydi: `UXB_AMBIGUOUS_MEMBER … Sur`.

**5.4 Üstünlük (geçerli, çakışma yok).** `Arac` ortak taban, `KaraAraci` `Sur`'ü geçersiz kılar, `SuAraci` kılmaz: `Amfibi.Sur()` KaraAraci'nınkidir (bölüm 3.3).

**5.5 Taban kurucusu parametreli (geçerli).**

```basic
CLASS Amfibi EXTENDS KaraAraci, SuAraci
    PUBLIC
    CONSTRUCTOR(t AS I32, p AS I32)
        SUPER[KaraAraci](t)
        SUPER[SuAraci](p)
    END CONSTRUCTOR
    PREFER KaraAraci.Sur
END CLASS
```

## 6. Bugünkü durum (ölçüm: `bin\uxb_kilavuz_20261014_0253.exe`, altı yol, 2026-10-16)

| Program | Sonuç (altı yolda aynı, açık ret) |
|---|---|
| `CLASS C EXTENDS A, B` | Ayrıştırma hatası: `CLASS: field identifier expected near OP(',')` |
| `SUPER[A].F()` | Ayrıştırma hatası: `statement parse failed near OP('[')` |
| `MIXIN Y, W` (gövdede, iki karışım) | `semantic: CLASS supports at most one MIXIN in this phase` |
| `CLASS R EXTENDS Belge` + gövdede `MIXIN Yazici` (ya da başlıkta `… MIXIN Yazici`) | `semantic: MIXIN currently supports single-base model` |
| Tek `MIXIN Yazici` (taban yok) | **Çalışır**, altı yolda `7`, `1` |
| Parametreli taban kurucusu, `SUPER` yok | **Beş ayrı davranış:** AST, WASM, eski AST-x64 alanı `0` bırakır; MIR çalışma anı hatası; x64 derleme hatası; JS `undefined`; `NEW D2(7)` ise x64 ve JS'te `7`, ötekilerde `0` verir (S-485, S-487) |
| `SUPER(5)` | AST `object is not callable`, MIR/x64 kurucu hatası, JS `host binding missing: SUPER`, **WASM ve eski AST-x64 sessizce yok sayar** |

Yani çoklu kalıtım için öngörülen güvenli ret **yerindedir**; ama çoklu kalıtımın zemini olan tek kalıtımda taban kurucusu ve `THIS/ME` çağrı seçimi altı yolda henüz aynı değildir. Bu nedenle uygulama sırası (bölüm 7) önce tek kalıtımı sağlamlaştırır.

## 7. Uygulama planı (aşamalar, kabul ölçütleriyle)

| Aşama | İçerik | Kabul |
|---|---|---|
| **M0** (ön koşul) | Tek kalıtımı altı yolda eşitle: ~~`THIS` doğrudan / `ME` sanal / niteliksiz çağrı (S-484, S-576)~~ **yapıldı, 2026-10-17** (altı yolda aynı; testler `this_direct_me_virtual`, `this_me_three_levels`, `ctor_*`), `SUPER(...)` ve parametreli taban kurucusu (S-485, S-487), tabana göre `DELETE`te türetilmiş yıkıcı (S-486), `INSTANCEOF` altı yolda (G-NESNE-36), `ABSTRACT/FINAL/SEALED` (S-572), yaşam döngüsü (S-574) | `tests/oop_parity` + yeni M0 paketi altı yolda yeşil |
| **M1** | `EXTENDS A, B` ayrıştırma + üye tablosu birleştirme + `UXB_AMBIGUOUS_MEMBER` + dört karar cümlesi + `SUPER[Taban]` + soldan sağa kurucu; **ortak tabanı olmayan** (ayrık) hiyerarşiler; elmas `UXB_DIAMOND_NOT_YET` ile reddedilir | Bölüm 8'deki T1–T14 altı yolda |
| **M2** | Elmas: ortak taban tek depolama ve tek kurucu | T15–T17 |
| **M3** | Çoklu `MIXIN`, başlıkta `MIXIN`, durum taşıyan karışım, `MIXIN … END MIXIN` bloğu; karışımda aynı çakışma kuralları | T18–T20 |

**Altı yola indirgeme (öneri, M0 sonunda 2 günlük bir deneme ile doğrulanır):** MIR düzeyinde **köprü nesneleri**. `C EXTENDS A, B` için C'nin nesnesi, her taban için sıradan bir alt nesne (`__A`, `__B`) taşır; devralınan her metot için C'de bir yönlendirici metot üretilir; tabanın sanal metodu C'de geçersiz kılınmışsa alt nesne, tabandan türeyen ve çağrıyı dış nesneye ileten üretilmiş bir ara sınıfın örneğidir. Böylece **motorlar yalnız tek kalıtım ve sıradan nesne alanı bilir** (bugün altı yolda var); WASM'ın alan kaybı (G-WASM-1) ayrı kapanır. Alternatifler: (a) her taban için ayrı `vptr` + `this` kaydırma (x64'te doğal, JS/WASM'da gereksiz karmaşık), (b) düzleştirme (alanlar ada göre; yalnız ad-tabanlı motorlarda kolay, x64 yerleşimiyle uyuşmaz). Köprü yaklaşımının bedeli: üretilen kod büyür ve taban görünümünün kimliği dış nesneyle aynı değildir (kimlik karşılaştırması ve `AS` aşağı atama için dış nesne bağlantısı gerekir). Karar M0 sonunda ölçümle verilir.

## 8. Kabul testleri (her biri altı yolda; beklenen çıktı kayıtlı)

| No | Program | Beklenen |
|---|---|---|
| T1 | `EXTENDS A, B`, çakışma yok, iki taban metodu | iki metot da çağrılır |
| T2 | Aynı adlı metot, karar yok | `UXB_AMBIGUOUS_MEMBER` (derleme) |
| T3 | `OVERRIDE METHOD` ile çözüm | kendi gövdesi |
| T4 | `PREFER A.f` | `a.f()` A'nınki; B'nin `f`'i C yüzeyinde görünmez (`SUPER[B].f()` ile ulaşılır) |
| T5 | yalnız `RENAME B.f AS bf` | `a.f()` A'nınki, `a.bf()` B'nin; ikisi de çağrılır |
| T6 | `EXCLUDE B.f` | `a.f()` A'nınki; `SUPER[B].f()` çalışır |
| T7 | taban görünümü `DIM b AS B = a; b.f()` | B'nin `f`'i (ya da `OVERRIDE`) |
| T8 | aynı adlı alan, karar yok | `UXB_AMBIGUOUS_MEMBER` |
| T9 | aynı adlı alan + `RENAME` | iki alan ayrı değer tutar |
| T10 | `SUPER[A](1)`, `SUPER[B](2)` | kurucu sırası: A, B, C; yıkıcı: C, B, A |
| T11 | parametreli taban kurucusu, `SUPER[...]` yok | `UXB_BASE_CTOR_REQUIRED` |
| T12 | `PREFER Z.f` (Z doğrudan taban değil) | `UXB_RESOLUTION_TARGET_UNKNOWN` |
| T13 | `PREFER A.f` ve `PREFER B.f` | `UXB_RESOLUTION_CONFLICT` |
| T14 | niteliksiz `SUPER.f()` iki tabanda da `f` varken | `UXB_AMBIGUOUS_SUPER` |
| T15 | elmas, `Arac.hiz` bir kez | `a.hiz = 5` her iki görünümden `5` |
| T16 | elmas kurucusu bir kez | `Arac` kurucusu tek satır çıktı |
| T17 | üstünlük kuralı | tek kolda `OVERRIDE` → o kol kazanır |
| T18 | başlıkta `MIXIN A, B` (durumsuz) | iki metot kazanılır |
| T19 | iki karışımda aynı metot | `UXB_AMBIGUOUS_MEMBER` |
| T20 | durum taşıyan karışım | alan nesnede bir kez |

## 9. Varsayılan kararlar (Mete "varsayılanları uygula" dediği için uygulanır; değiştirilebilir)

| No | Konu | Varsayılan |
|---|---|---|
| D1 | Karar cümlelerinin adı | `PREFER`, `RENAME … AS`, `EXCLUDE` (bağlamsal sözcük; yeni ayrılmış sözcük yok) |
| D2 | Çakışmada davranış | Derleme hatası; sessiz birleştirme yok |
| D3 | Elmas | Ortak taban tek depolama; M1'de açık ret, M2'de uygulama |
| D4 | `SUPER` çoklu kalıtımda | Niteliksiz `SUPER` belirsizse hata; `SUPER[Taban]` |
| D5 | Gereksiz karar cümlesi | Uyarı (hata değil) |
| D6 | Başlıkta `MIXIN` | M3'e kadar tek-taban sınırı korunur |
| D7 | Alt yol | Önce M0 (tek kalıtımı altı yolda eşitle), sonra M1 |
| D8 | `THIS`/`ME` | Plan belgelerindeki anlam (`THIS` doğrudan, `ME` sanal) |

## 10. Bu belgenin kitaptaki yeri

Kitap bölüm 11.12 (sade anlatım ve karar), 11.13 (yeni OOP belgelerinin incelenmesi), 23 (kararlar) ve Ek I (tasarım belgeleri). Kayıt: S-555 `ACIK-TASARIM-KARARI-KAYITLI`.
