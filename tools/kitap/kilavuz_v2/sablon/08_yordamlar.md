# 8. Yordamlar ve işlevler

Bir işi adlandırıp tekrar tekrar kullanmak için **altprogram** yazarız. uXBasic'te iki türü vardır:

| | `SUB` (yordam) | `FUNCTION` (işlev) |
|---|---|---|
| Değer döndürür mü? | Hayır | **Evet** (`AS tip` ile tipi bildirilir) |
| İfade içinde kullanılır mı? | Hayır (`PRINT S()` hatadır) | Evet (`PRINT Kare(3)`) |
| Sonuç nasıl verilir? | — | `RETURN değer` (ya da işlev adına atama: `Kare = x * x`) |
| Erken çıkış | `RETURN` | `RETURN değer` |

## 8.1 Yazım

```basic
SUB Selam(ad AS STRING)
    PRINT "Merhaba "; ad
END SUB

FUNCTION Kare(x AS I32) AS I32
    RETURN x * x
END FUNCTION
```

* Çağrı: `Selam("Ayse")`, `PRINT Kare(5)`. **Her çağrıyı parantezle yazın.**
* `CALL Selam("Ayse")` yazımı da vardır; `CALL` ile parantez **zorunludur** (`CALL Selam` ayrıştırma hatasıdır).

> **Karar (Mete, 2026-10-12): parantezsiz çağrı bir dil özelliği değildir; çalışmamalı ve derleyici parantez istemelidir.**
>
> **G-YORDAM-6, derleyici sürümüne göre iki durumdur.** *20261007 ikilisinde* (bu kılavuzdaki örneklerin ölçüldüğü sürüm) karara aykırı **sessiz bir kusurdu (✖ SESSİZ)**: `Selam "Ayse"`, `Selam` ya da `Artir n` yazarsanız derleyici hata **vermez**, çağrı da **yapılmaz** (dört motorda çıktı yoktur, `BYREF` değişkeni değişmez, çıkış kodu 0); çok argümanlı `Topla 3, 4` ayrıştırma hatasıdır; `o.Selam` AST'de hata verir, MIR ve JS'te hiçbir şey yapmaz, x64'te derlenmez.
> *20261013 ve sonrası derlemelerde* (S-440, Codex) karar uygulanmıştır: parantezsiz çağrı yordam, işlev ve metot için dört motorda **ayrıştırmada reddedilir**: `UXB_CALL_PAREN_REQUIRED: CALL: missing ( after selam; use selam(...)` (çıkış 1). Bu kılavuzdaki her örnekte çağrılar zaten parantezlidir.
* Sonucu kullanılmayan işlev çağrısı deyim olarak yazılabilir: `Kare(5)`.
* `SUB`/`FUNCTION` tanımı çağrıdan **önce** yazılırsa `DECLARE` gerekmez. Tanım çağrıdan **sonra** gelecekse (ileri kullanım, karşılıklı özyineleme) çağrıdan önce `DECLARE` ile bildirilmelidir: **sıkı kural** (Mete, 2026-10-15; ayrıntı 8.5). Derleyici bu kuralı bugün denetlemez (G-YORDAM-9); yeni kodda kurala uyun.

{{ORNEK:06_rutin/sub_function|baslik=SUB ve FUNCTION}}

{{ORNEK:06_rutin/call|baslik=CALL}}

## 8.2 Parametreler

| Biçim | Anlamı | Not |
|---|---|---|
| `x AS I32` ya da `BYVAL x AS I32` | **Değerle**: yordam kopya alır, çağıranın değişkeni değişmez | Varsayılan |
| `BYREF x AS I32` | **Başvuruyla**: yordam çağıranın değişkenini değiştirir | Birden çok sonuç döndürmenin yolu |
| `a AS I32[]` | Dizi parametresi | Dizi her zaman başvuruyla geçer; `LBOUND`/`UBOUND` ile sınırlar okunur |
| `a AS Nokta[]` (kayıt dizisi parametresi) | Kayıt dizisini işleve vermek | ✖ SINIR (G-VERI-12): AST ve MIR'de çalışır (yazma çağırana görünür); x64 "array parameter ARR has unsupported element type" ile **derlemeyi reddeder**; JS derler ama yürütme anında `ARRAY_FIELD_STORE` ile durur. Alanları ayrı skaler dizilerde tutun |
| `y AS I32 = 7` | Varsayılan değerli parametre | ✖ Yoktur (`missing ) in signature`) |
| `p AS Nokta` / `BYREF p AS Nokta` (kayıt parametresi) | Kaydı işleve vermek | ✖ SINIR (G-VERI-6, G-VERI-2): değerle geçirilen kaydın alanları AST/MIR'de `0`, JS'te `nan` okunur, x64 derlemez; `BYREF` kayıt yalnız AST'de çalışır. **Alanları ayrı parametre** olarak verin (Bölüm 10) |

{{ORNEK:06_rutin/byref_byval|baslik=BYVAL ve BYREF}}

{{ORNEK:46_kv_yordam/byref_cikti|baslik=Orta düzey: BYREF ile bölüm ve kalanı birlikte döndürmek}}

{{ORNEK:46_kv_yordam/dizi_ortalama|baslik=Dizi parametresi: her alt sınırda çalışan ortalama}}

### Argüman sayısı ve tip denetimi

* **Eksik ya da fazla argüman** derleme hatasıdır: `no matching overload for P with 1 argument(s)`.
* Dar tipten geniş tipe geçiş (örn. `P(3)` ile `F64` parametre) serbesttir.
* **✖ SINIR (G-YORDAM-3, G-YORDAM-4):** Parametre tipine uymayan argümanlar bugün **sessizce kabul edilir**:
  `I32` parametreye metin vermek AST/MIR'de `0`, x64'te çöp değer üretir; `I32` parametreye `2.5` vermek AST/MIR'de `2`, x64'te `0` üretir.
  Atamada açık dönüşüm şart olduğu halde çağrıda aranmaması, "her şey açık" ilkesiyle çelişir; hedef bunların derleme hatası olmasıdır.
  Şimdilik `I32(x)` gibi dönüşümü **siz** yazın.

## 8.3 Dönüş değeri

* `RETURN değer` işlevi bitirir ve değeri verir. Değerin tipi, bildirilen dönüş tipine uymalıdır: `RETURN 2.5` yazıp işlevi `AS I32` bildirirseniz
  derleme hatası alırsınız (`assignment requires explicit cast TYPE_F64 to TYPE_I32`).
* `SUB`'dan erken çıkmak için değersiz `RETURN` yazılır (`EXIT SUB` ve `EXIT FUNCTION` **yoktur**).
* **✖ SINIR (G-YORDAM-2, G-YORDAM-12):** `RETURN` hiç çalışmadan biten bir `FUNCTION` ya da değer döndüren `METHOD` AST ve MIR'de `0`, x64'te rastgele bir değer, JS'te `undefined` döndürür; WASM'da derlenmez, eski AST-x64'te son hesaplanan değeri verir. Eski AST-x64'te `F = değer` yazıp sonra başka deyim çalıştıran işlev de atanan değeri vermez. **Kaynakta düzeltildi** (2026-10-17, testler `function_result_zero`, `float_function_result`): işlevin sonuç değişkeni (işlev adı) türün sıfırıyla başlar; gövde `RETURN` olmadan biterse altı yolda bu değişken döner. Ölçüm ikilisinde her yolun `RETURN` ile bittiğinden emin olun.

## 8.4 Özyineleme

Bir işlev kendini çağırabilir. Her özyinelemeli işlevde **durma koşulu** olmalıdır; yoksa çağrı yığını taşar.

{{ORNEK:06_rutin/ozyineleme|baslik=Faktöriyel}}

{{ORNEK:46_kv_yordam/ebob_ekok|baslik=Orta düzey: Öklid algoritması}}

{{ORNEK:46_kv_yordam/hanoi|baslik=Orta düzey: Hanoi kuleleri (SUB ve FUNCTION birlikte)}}

{{ORNEK:46_kv_yordam/fibonacci_bellekli|baslik=Orta düzey: bellekli özyineleme}}

### Karşılıklı özyineleme

İki işlev birbirini çağırabilir. Sonra tanımlanacak işlevi, ilk çağrıdan önce `DECLARE` ile **bildirmeniz gerekir** (sıkı kural, 8.5; derleyici bugün yazmasanız da kabul eder);
bu örnek beş hedefte de çalışan nadir programlardandır:

{{ORNEK:46_kv_yordam/karsilikli_ozyineleme|baslik=DECLARE ile karşılıklı özyineleme}}

### Özyineleme derinliği sınırları

| Motor | Güvenli derinlik | Sınırı aşınca |
|---|---|---|
| AST | 100'den az | Açık hata: `call stack limit exceeded` |
| MIR | 50'den az | `20261013_2333` ve öncesinde `Aborting : stack overflow` (FreeBASIC çalışma zamanı iletisi, çıkış kodu `4`); **`20261014_0253`'te iletisiz erişim ihlali** (çıkış kodu `-1073741819`, ✖ G-YORDAM-8, gerileme) |
| x64 | Yaklaşık 8000 | **İletisiz çökme** (çıkış kodu `-1073741571`) |

Çok derin özyineleme gereken işleri (ağaç gezme, büyük sayı toplama) **döngüyle** yazın. Bu sınırlar **✖ SINIR (G-YORDAM-5)** olarak izlenir; hedef,
yığın taşmasının her motorda aynı açık hatayı vermesidir.

## 8.5 `DECLARE`

`DECLARE FUNCTION Ad(parametreler) AS tip`, işlevin imzasını önceden bildirir:

```basic
DECLARE FUNCTION Iki(x AS I32) AS I32
```

Bu derleyicide kullanımı: karşılıklı özyinelemeyi belirginleştirmek ve **dış kütüphane işlevlerini** tanıtmak (`DECLARE ... LIB "x.dll" ALIAS "ad"`, Bölüm 16).
**◇ HEDEF:** Görev tipleri için de ileri bildirim (`DECLARE THREAD`, `DECLARE EVENT`, `DECLARE PIPE`, `DECLARE PARALEL`) tasarlanmıştır; bugün
`DECLARE: expected SUB or FUNCTION` hatasıyla reddedilir (Bölüm 15).

{{ORNEK:06_rutin/declare_ileri|baslik=DECLARE ile ileri bildirim}}

### `DECLARE` zorunlu mu? (Mete'nin 2026-10-15 kuralı)

**Kural (Mete, 2026-10-15):** `SUB … END SUB` ve `FUNCTION … END FUNCTION`, kullanılmadan önce `DECLARE` ile **önden bildirilmelidir**. Bu, 24.09 görev tasarımıyla uyumludur: "tanım daha önce geldiyse `DECLARE` gerekmez; tanım dosyanın ilerleyen bölümündeyse ya da başka modüldeyse `DECLARE` kullanılır". **Bugün derleyici bu kuralı denetlemez.** Altı yolda ölçülen davranış (`20261014_0253`):

| Durum | Sonuç |
|---|---|
| `Selam(3)` çağrısı, `SUB Selam` tanımından **önce**; `DECLARE` yok | ✖ **SESSİZ** (G-YORDAM-9): altı yolda hatasız çalışır (`3`) |
| `PRINT Iki(4)` çağrısı, `FUNCTION Iki` tanımından önce; `DECLARE` yok | ✖ **SESSİZ** (G-YORDAM-9): altı yolda hatasız çalışır (`8`) |
| `DECLARE` var, tanım ona uyuyor | ✔ altı yolda `8` |
| `DECLARE` var ama imza tanımla uyuşmuyor (`I32` ile `F64`) | ✔ altı yolda derleme hatası: `declaration signature mismatch` |
| `DECLARE` var, tanım yok, çağrı da yok | hata yok (kullanılmayan bildirim) |
| `DECLARE` var, tanım **yok**, çağrı var | ✖ **FARK**: AST ve MIR çalışma anında, x64 derlemede, JS yürütmede, eski AST-x64 bağlamada durur; **WASM hata vermez, `0` yazar** (G-DIL-7, G-WASM-23) |

**Karar (Mete, 2026-10-15): sıkı kural.** Tanımdan önce `DECLARE`siz kullanım **derleme hatası** olacaktır (◇ HEDEF, S-544; altı yolda aynı ortak tanı). Kural: **tanım çağrıdan önce gelmişse `DECLARE` gerekmez; tanım çağrıdan sonra geliyorsa (ya da başka modüldeyse) çağrıdan önce `DECLARE` yazılır; `DECLARE` imzası tanımla bire bir uyuşur** (bu son denetim bugün çalışır). Bedeli küçüktür: kaynak metin sezgisiyle sayıldığında, rutin tanımlayan 66 örnek dosyasının 2'sinde, 133 test dosyasının 2'sinde ve 80 kütüphane kaynağının 1'inde tanımdan önce `DECLARE`siz çağrı vardır (toplam 5 dosya); bu kılavuzdaki iki örnek (`sub_tanimdan_once`, `ifade_hesaplayici`) yeni kurala göre güncellendi ve yeniden doğrulandı. Görev yapılarına (`DECLARE THREAD …`) aynı kural, bu biçimler eklenince (S-395) uygulanır. Sözleşme ve kabul ölçütleri: `docs/tasarim/UXB_S544_S549_S564_DECLARE_DOSYA_TUTAMACI_NULL_20261015_TR.md`. **Yeni kod yazarken kuralı şimdiden uygulayın:** ileri kullanacağınız her rutin için tanımdan önce `DECLARE` yazın.

## 8.6 `STATIC` yerel değişken

`STATIC` ile bildirilen yerel değişken ve diziler, yordam bitse de **değerini korur**:

{{ORNEK:06_rutin/static_yerel|baslik=Çağrılar arasında korunan sayaç}}

## 8.7 Aşırı yükleme (aynı adlı işlevler)

Derleyici aynı adlı işlevleri **parametre sayısına** göre ayırt etmek üzere tasarlanmıştır (`no matching overload for F with 2 argument(s)` tanısı bunu gösterir)
ve aynı sayıda parametreli ikinci tanımı `duplicate overload signature` ile reddeder. Ancak **çalışma tarafı tamamlanmamıştır**
(**✖ SINIR G-YORDAM-1**): AST `duplicate routine` hatası verir, MIR ve JS yanlış sonuç üretir, x64 derlemez. Şimdilik her işleve ayrı ad verin:

```basic
FUNCTION Topla2(a AS I32, b AS I32) AS I32
FUNCTION Topla3(a AS I32, b AS I32, c AS I32) AS I32
```

**Varsayılan (isteğe bağlı) parametre değeri de yoktur** (✖ G-YORDAM-10): `FUNCTION Topla(a AS I32, b AS I32 = 10) AS I32` altı yolda ayrıştırma hatasıyla reddedilir. İsteğe bağlı değer gerekiyorsa yukarıdaki gibi iki ayrı işlev yazın.

## 8.8 Çağrıların iç içe kullanımı

Bir işlevin sonucu başka bir işlevin argümanı olabilir; `T(K(3), K(K(2)))` gibi. Boru işleci (`|>`) aynı zinciri soldan sağa yazar (Bölüm 6.6).

## 8.9 Benzerlerinden farkı

| İkili | Fark |
|---|---|
| `SUB` ve `FUNCTION` | Değer döndürmez / döndürür |
| `RETURN` ve `END` | `RETURN` yordamdan çıkar; `END` **programı** bitirir |
| `BYVAL` ve `BYREF` | Kopya / çağıranın değişkeni |
| `DIM` yerel ve `STATIC` yerel | Her çağrıda sıfırlanır / değeri korunur |
| `DECLARE FUNCTION` ve `FUNCTION` tanımı | Yalnız imza / imza + gövde |
| `CALL S(x)` ve `S(x)` | Aynı iş; `CALL` yazılsa da yazılmasa da **parantez şarttır**. `S x` (parantezsiz) 20261007'de çağrı **yapmaz** ve uyarmaz; 20261013 ve sonrasında `UXB_CALL_PAREN_REQUIRED` ile reddedilir (G-YORDAM-6) |
| Özyineleme ve döngü | Özyineleme bölüp çözmek için doğal; döngü derin tekrarda daha güvenli |
| Adlı işlev ve anonim işlev (lambda) | Yalnız adlı `FUNCTION` / `SUB` vardır. `FN(x) => x * 2` biçimi ayrıştırılamaz ("expression expected"); kapanış (closure) ve sözcüksel yakalama sözleşmesi tasarım izidir: ◇ HEDEF (G-HEDEF-26). İşlev değeri olarak yalnız `CODEPTR(F)` vardır ve gerçek adresi yalnız x64 verir (AST ve MIR "requires native x64", JS "pointer values are not available") |

## 8.10 Yordamlarla ilgili programlama kararları

* **Her çağrıyı parantezle yazın** (`Selam("Ayse")`, `Say()`, `o.Metot()`): parantezsiz çağrı 20261007'de sessizce hiçbir şey yapardı, 20261013 ve sonrasında derleme hatasıdır (G-YORDAM-6).
* Bir **değer üretiyorsanız `FUNCTION`**, yalnız bir iş yapıyorsanız `SUB` yazın. Birden çok sonuç gerekiyorsa **`BYREF` çıkış parametreleri** kullanın (`Bol(a, b, BYREF bolum, BYREF kalan)`).
* **Her işlevin her yolu `RETURN` ile bitsin** (G-YORDAM-2, G-YORDAM-12): `RETURN` çalışmadan biten işlev ölçüm ikilisinde AST/MIR'de `0`, x64'te rastgele değer verir (kaynakta düzeltildi). Erken çıkış için `RETURN` yazın; `EXIT SUB`/`EXIT FUNCTION` yoktur.
* **Gövdesi boş rutin (`SUB Taslak() : END SUB`) ölçüm ikilisinde bozuktu** (✖ ÇÖKME, G-YORDAM-11): AST çöker, MIR, x64 ve JS çağrıyı bulamaz, eski AST-x64 boş sınıf rutinini derleyemez (WASM doğru). **Kaynakta düzeltildi** (2026-10-17, test `tests/oop_parity/empty_routine_bodies`); ölçüm ikilisinde taslak rutine bir deyim koyun (`DIM bos AS I32`).
* Argüman tipini **kendiniz dönüştürün** (`I32(x)`, `STR(n)`): tip uyuşmazlığı bugün çağrıda sessizce kabul edilir ve yanlış değer üretir (G-YORDAM-3, G-YORDAM-4).
* Parametreye varsayılan değer yazmayın (yoktur); aynı adlı işlevi **parametre sayısıyla ayırmaya** çalışmayın, her işleve ayrı ad verin (G-YORDAM-1).
* **Kaydı (`TYPE`) parametre olarak vermeyin**, kayıt döndürmeyin: alanları ayrı parametre ve `BYREF` çıkış olarak geçirin (G-VERI-6, G-VERI-3). Dizi parametresi her zaman başvuruyladır.
* Özyinelemeli işleve **durma koşulunu ilk satıra** yazın. Derinliği küçük tutun (AST 100'den az, MIR 50'den az, x64 yaklaşık 8000); derin işleri döngüyle yazın (G-YORDAM-5).
* İleri kullanacağınız ve karşılıklı özyinelemeli her rutini çağrıdan önce `DECLARE` ile bildirin (sıkı kural, 8.5); tanımı çağrıdan önce yazarsanız `DECLARE` gerekmez.
* Çağrılar arasında durum saklamak için **`STATIC` yerel**; yalnız gerçekten paylaşılan durum için genel değişken kullanın.
* Yerleşik işlev adıyla aynı adlı işlev yazmayın (G-DIL-9); kütüphane işlev adlarıyla aynı adlı değişken tanımlamayın (G-KUT-5).
* Çağrıları iç içe yazabilirsiniz (`T(K(3), K(K(2)))`); okunaklılık için uzun zincirleri `|>` ile soldan sağa ya da ara değişkenlerle yazın.
