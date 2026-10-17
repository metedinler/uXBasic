# 11. Nesne yönelimli programlama

**Nesne yönelimli programlama**, veriyi (alanlar) ve o veriyle çalışan kodu (metotlar) **sınıf** adı altında birleştirir. Sınıftan üretilen somut örneğe **nesne** denir.

## 11.1 Hızlı bakış

| Kavram | Anahtar sözcük | Ne işe yarar? | Durum |
|---|---|---|---|
| Sınıf | `CLASS` ... `END CLASS` | Alan + metot topluluğu | ✔ |
| Nesne oluşturma / silme | `NEW`, `DELETE` | Belleğe nesne ayırır / yıkıcıyı çalıştırır | ✔ |
| Kurucu / yıkıcı | `CONSTRUCTOR`, `DESTRUCTOR` | Başlangıç ve temizlik kodu | ◐ Tek sınıfta ✔ (yıkıcı `DELETE` ile çalışır; sayısı motora göre değişir: ✖ G-NESNE-23). Kalıtımda **parametresiz** taban kurucusu altı yolda çalışır (türetilmiş sınıfın kendi kurucusu yoksa MIR çalıştırmıyordu: **kaynakta düzeltildi**, G-NESNE-25); **parametreli** taban kurucusunda altı yol beş ayrı davranır (✖ FARK, G-NESNE-25) |
| Metot | `METHOD` ... `END METHOD` | Sınıfın işlevi | ✔ |
| Kendine başvuru | `THIS`, `ME` | Geçerli nesne | ✔ `THIS.m()` **doğrudan**, `ME.m()` ve niteliksiz `m()` **sanal** çağırır; altı yolda aynı (**kaynakta düzeltildi**, G-NESNE-24, G-NESNE-46; ölçüm ikilisinde AST üçünü de doğrudan, öbür motorlar üçünü de sanal çağırır) |
| Erişim belirteci | `PUBLIC`, `PRIVATE`, `PROTECTED` | Üyenin kimler tarafından kullanılacağı | ◐ (metotta denetlenir, alanda **denetlenmez**) |
| Kalıtım | `EXTENDS` | Başka sınıfın üyelerini devralma | ✔ |
| Sanal metot | `VIRTUAL`, `OVERRIDE` | Çalışma anında gerçek sınıfın metodunu seçme | ✔ |
| Üst sınıf çağrısı | `SUPER.Metot()` | Devralınan metodu çağırma | ✔ (`BASE` yoktur; tabana kurucu çağrısı `SUPER(...)` da yoktur: ✖ G-NESNE-27) |
| Arayüz | `INTERFACE`, `IMPLEMENTS` | Uyulması gereken metot sözleşmesi | ✔ |
| Özellik | `PROPERTY ad AS tip GET SET` | Alan gibi görünen okuma/yazma | ◐ (yalnız kısa biçim) |
| Sihirli metot | `MAGIC ... END MAGIC` | Özel davranışlar: işleç, `TOSTRING` | ✔ |
| Soyut / son / mühürlü | `ABSTRACT`, `FINAL`, `SEALED` | Sınıf nitelikleri | ✖ Ölçüm ikilisinde (`20261014_0253`) ayrıştırılamaz (G-NESNE-6, kök neden G-NESNE-38); **kaynakta düzeltildi**, yeni ikilide ✔ |
| Değişmezlik niteleyicileri | `READONLY`, `IMMUTABLE` (alana yazma zorlanır: AST'de çalışma anı, MIR ve x64'te derleme hatası), `MUTABLE` | Alanın değişip değişmeyeceği | ✔ |
| Erişim bölümleri | `RESTRICTED`, `FRIEND liste` | `RESTRICTED` bölümü kabul edilir ama yalnız AST'de metot çağrısında zorlanır; `FRIEND` bir arkadaş listesi ister ve `PUBLIC` bölümünde yazılamaz | ◐ FARK (G-NESNE-19) |
| Statik üye | `STATIC` | Nesnesiz üye | ✖ Motorlar farklı (G-NESNE-1) |
| Karışım | `MIXIN` | Kod paylaşımı | ◐ Sınıf gövdesinde **tek** `MIXIN Sinif` altı yolda ✔; iki karışım, `EXTENDS` ile birlikte karışım ve `MIXIN … END MIXIN` bloğu ✖ (G-NESNE-6, G-HEDEF-39) |
| Çoklu kalıtım | `EXTENDS A, B` | Birden çok tabandan devralma | ✖ Yok (altı yolda ayrıştırma hatası); 15 Eylül tasarımı bilerek dışarıda bırakmıştı, **Mete'nin 2026-10-15 kararıyla istenir, 2026-10-16'da B (gerçek çoklu kalıtım) seçildi** ve çakışmayı anahtar sözcüklerle çözen tasarım yazıldı (11.12, 11.13; G-NESNE-30, G-HEDEF-40) |
| Arayüz mirası, iç içe sınıf, sınıf sabiti, arayüzde gövdeli metot, kurucu aşırı yükleme | `INTERFACE IB EXTENDS IA`, sınıf içinde `CLASS` ve `CONST` … | Zengin OOP yetenekleri | ✖ Yok (G-NESNE-31 … G-NESNE-35; 11.12) |
| Genel tipler, `USES`, `DECORATOR`, geçişli immutable, weak/döngü referansı | `Polynomial<F64>` gibi | İleri OOP | ✖ ◇ HEDEF (G-HEDEF-4, G-HEDEF-25; ayrıntı 11.10) |
| `PROPERTY` blok biçimi | `PROPERTY Ad AS T GET … END GET SET(v) … END SET` | Okuma/yazma mantığı olan özellik | ✖ ◇ HEDEF (G-HEDEF-3, 11.6) |
| Üst katman | `CLAZZ DATA … DERIVE …` | Sınıf kodu üreten üst yüzey | ✖ ◇ HEDEF, yalnız dış araç var (G-HEDEF-2, Bölüm 16.9) |

## 11.2 Sınıf, alan, metot, kurucu

```basic
CLASS Nokta
    PUBLIC
    DIM x AS I32
    DIM y AS I32
    CONSTRUCTOR(ax AS I32, ay AS I32)
        x = ax
        y = ay
    END CONSTRUCTOR
END CLASS

DIM p AS Nokta = NEW Nokta(3, 4)
```

* `DIM d AS Sinif = NEW Sinif(...)` ile oluşturulur. **`DIM` satırında başlangıç değeri ölçüm ikilisinde `NEW` olmak zorundadır**; farklı bir nesne atamak için ayrı satır yazılır (G-NESNE-45). **Kaynakta düzeltildi:** fabrika işlevi, başka değişken ya da `MAGIC` işleç sonucu da başlangıç değeri olabilir ve tür derleme zamanında sınanır.
* **Sınıf adı ve değişken adı aynı ad uzayındadır**: `CLASS K` varken `DIM k AS K` yazılamaz. Derleyici `variable K conflicts with CLASS K` der. Değişkene farklı ad verin.
* Boş bırakılan nesne değişkenine (`DIM k AS Kutu`) alan erişimi **çalışma anı hatasıdır**: `field access on a null object reference` (AST, x64 ve eski AST-x64 böyle durur). **İki kusur** kaynakta düzeltildi ama bu kılavuzun ölçüm ikilisinde (`20261014_0253`) hâlâ geçerlidir: **MIR**, programda başka bir nesne varsa boş başvuruyu **programın ilk nesnesine** çözer (okuma onun alanını verir, yazma onu bozar; ✖ SESSİZ, G-NESNE-37) ve **JS** alan okumada hata vermeyip `undefined` yazdırır (G-HATA-6, G-JS-16).
* Aynı sınıfta aynı adlı iki metot (aşırı yükleme) `duplicate member name` ile **reddedilir**.
* **Aynı sınıfın iki metodunda aynı adlı ama farklı tipli parametre** geçerli programı reddettirir (G-NESNE-16): `METHOD SetS(v AS STRING)` ve `METHOD SetF(v AS F64)` birlikte yazılırsa ikincide `v` hâlâ `STRING` sayılır (`assignment cannot convert TYPE_STRING to TYPE_F64`). Parametrelere farklı ad verin; farklı sınıflarda aynı ad sorun çıkarmaz.
* **Parametreli metot JS'te parametresini göremez** (✖ SESSİZ, G-JS-13, kök neden G-JS-15): her `METHOD` çağrısında argümanlar çağrılana ulaşmaz, parametre `undefined` olur; bu yüzden `deger = deger + d` `nan`, metot içinde `PRINT d` `undefined` verir (alana yazmak kendi başına bozuk değildir: kurucuda yazma ve dışarıdan `nesne.alan = …` çalışır). **Kaynakta düzeltildi** (2026-10-16, test: `tests/oop_parity/method_args`); ölçüm ikilisinde hâlâ geçerlidir.
* **Hiç yazılmamış alan sıfırdan başlar** (sayı `0`, metin boş): AST, MIR, x64, WASM ve eski AST-x64'te öyledir. **JS ölçüm ikilisinde `undefined` okur** (✖ SESSİZ, G-JS-17): `x.n = x.n + 1` `nan` olur. **Kaynakta düzeltildi** (2026-10-17, test `tests/oop_parity/field_default_zero`); ölçüm ikilisinde alanı kurucuda başlatın.
* **Sınıfın `BOOLEAN` alanını `STR` ile yazdırmak AST'de `255` verir** (G-NESNE-17; MIR, x64 ve JS `-1`). Mantık değerini `IF alan THEN …` ile sınayın.
* **Sınıf alanı olarak başka bir sınıf, `TYPE` ya da dizi** kullanımının sınırları vardır: nesne alanı `0` okunur (G-NESNE-10), `TYPE` alanına metot içinden erişim MIR/JS'te yanlış, x64'te derlenmez (G-NESNE-11), dizi alanı metot içinde reddedilir (G-NESNE-12). Ayrıntı: Bölüm 22.4.

{{ORNEK:07_yapi/class_new|baslik=CLASS, NEW ve METHOD}}

{{ORNEK:07_yapi/constructor_destructor|baslik=Kurucu, yıkıcı ve DELETE}}

> **Nesneler otomatik yıkılmaz.** Bir yordam bitince onun yerel nesnelerinin yıkıcısı **çalışmaz** (dört motorda aynı); yıkıcıyı yalnız `DELETE` çalıştırır. Kaynak
> (dosya, bellek) tutan sınıflarda `DELETE`'i unutmayın. **Ama yıkıcının kaç kez çalışacağı motora göre değişir (✖ FARK, G-NESNE-23):** aynı değişkene iki kez `DELETE` yazarsanız AST ve eski AST-x64 yıkıcıyı bir kez, MIR, x64, JS ve WASM iki kez çalıştırır; program sonunda `DELETE` edilmemiş genel nesneler için yalnız AST yıkıcıları (ters sırayla) çalıştırır. Her nesneyi tam bir kez `DELETE` edin.

> **`DELETE`'ten sonra değişkeni kullanmayın (✖ SESSİZ, G-NESNE-20, G-NESNE-37).** `DELETE o` sonrasında `o.v` okumak AST, x64, eski AST-x64 ve WASM'da hatayla durur; **MIR** ise silinmiş nesnenin eski değerini okur (`3`) ya da, silinen nesne programın ilk nesnesi değilse, **başka bir nesnenin alanını** okur (`DELETE` değişkene boş başvuruyu yazar ve MIR boş başvuruyu programın ilk nesnesine çözer); JS `undefined` yazdırır. Silinen nesne değişkenini bir daha okumayın. Aynı nesneye **başka bir değişkenle** (`b = a`, sonra `DELETE a`) erişmek ise altı yolda da hata vermez ve nesne yıkıcısı çalışmış olduğu halde kullanılabilir kalır (✖ SESSİZ, G-NESNE-22).

### Nesne ataması referanstır

`b = a` nesneyi kopyalamaz, aynı nesneye ikinci bir ad verir. Kopya için yeni nesne üretip alanları kopyalayın:

{{ORNEK:49_kv_nesne/nesne_referansi|baslik=Referans ve kopya}}

## 11.3 Erişim: `PUBLIC`, `PRIVATE`, `PROTECTED`

`PUBLIC`/`PRIVATE`/`PROTECTED` satırı, kendinden sonra gelen üyelerin erişimini belirler. **Metotlar için denetim vardır**: `PRIVATE` metodu sınıfın dışından çağırırsanız
`PRIVATE method KUTU.GIZLI cannot be called from outside its class` derleme hatasını alırsınız.

{{ORNEK:08_erisim/public_private|baslik=PRIVATE metodu yalnız sınıf içinden çağrılır}}

> **✖ SINIR (G-NESNE-2):** `PRIVATE` ve `PROTECTED` **alanlara** dışarıdan erişim bugün **denetlenmez** (`k.gizli = 5` sessizce çalışır). Alanları sınıfın içinden `PUBLIC` metotlarla
> yönetmek iyi alışkanlıktır; ama dilin sizi korumasına güvenmeyin.

## 11.4 Kalıtım ve çok biçimlilik

`CLASS Cocuk EXTENDS Ata` ile alt sınıf, üst sınıfın üyelerini devralır. `VIRTUAL` metot alt sınıfta `OVERRIDE` ile yeniden yazılabilir. Taban tipte bir değişken
türemiş nesneyi tutabilir; çağrıda **gerçek sınıfın** metodu çalışır. Üst sınıfın metodunu çağırmak için `SUPER.Ad()` yazılır.

{{ORNEK:07_yapi/class_miras|baslik=EXTENDS, VIRTUAL, OVERRIDE}}

{{ORNEK:49_kv_nesne/sekil_polimorfizm|baslik=Orta düzey: üç seviyeli kalıtım ve çok biçimlilik}}

| Konu | Durum |
|---|---|
| `SUPER.Ad()` | ✔ |
| `BASE.Ad()` | ✖ Yoktur (`unknown symbol: base`) |
| Orta sınıfın `OVERRIDE`'ını alt-alt sınıfta yeniden yazmadan kullanmak | ✖ SINIR (G-NESNE-7): MIR `MIR method target not found: C1_F` verir. Alt-alt sınıfta metodu yeniden yazın |
| Bir metotta **iki F64 alanı aynı ifadede** okumak, x64'te | ✖ SESSİZ (G-NESNE-43, G-NESNE-8): `RETURN k * k` ya da `RETURN k + k` `0`/çöp verir; sanal olmak şart değildir, tek başına sanal F64 metot doğrudur. Alanı önce yerel değişkene kopyalayın (`DIM a AS F64 = k`). **Kaynakta düzeltildi** (kök neden: üye okumasının kayan nokta türü bilinmiyordu; test `f64_field_arith`), ölçüm ikilisinde hâlâ geçerlidir. Ondalıklı **alana tamsayı sabiti** (`d.en = 3`) yazmak da x64'te çöp üretir; `3.0` yazın |
| `INSTANCEOF(nesne, Sinif)` | ✖ Yalnız AST'de |
| Nesne dizisi (`DIM d(1) AS Sinif`) | AST/MIR ✔; x64 `STORE_INDEXED element width unsupported: 16` ile reddeder |
| Yöntem zinciri (`RETURN THIS` ile kendi tipini döndürmek) | ✖ (G-NESNE-5): `explicit cast TYPE_OBJECT to ...` |
| Taban sınıfın kurucusu (`CLASS A`, `CLASS B EXTENDS A`, `NEW B()`) | ✔ **Parametresiz** taban kurucusu altı yolda çalışır (üç seviyede her kurucu bir sayı yazarsa `1 2 3`; yıkıcılar `3 2 1`). Türetilmiş sınıfın kendi kurucusu yoksa MIR taban kurucusunu çalıştırmıyordu (**kaynakta düzeltildi**, test `ctor_chain_derived_without_ctor`). ✖ **FARK (G-NESNE-25):** taban kurucusu **parametreliyse** altı yol beş ayrı davranır: türetilmiş kurucu yokken `NEW D(7)` x64 ve JS'te `x = 7`, ötekilerde `0` bırakır; türetilmiş sınıfın kendi parametresiz kurucusu varsa AST, WASM ve eski AST-x64 tabanı çalıştırmaz (`0`), MIR çalışma anında, x64 derlemede durur, JS `undefined` yazar |
| `SUPER(değer)` ile tabana kurucu çağrısı | ✖ Yoktur (G-NESNE-27): AST `MAGIC_CALL missing`, MIR kurucu argüman sayısı hatası, x64 derlemez, JS yürütme anında durur; **WASM ve eski AST-x64 hata vermeden yok sayar** (`0`) |
| Taban sınıf metodunun içinden `Value()`, `THIS.Value()`, `ME.Value()` | ✔ **Kaynakta düzeltildi (G-NESNE-24, G-NESNE-46):** `THIS.Value()` taban uygulamasını (`10`) doğrudan, `ME.Value()` ve niteliksiz `Value()` türetilmiş geçersiz kılmayı (`20`) sanal çağırır; altı yolda aynı. **Ölçüm ikilisinde (`20261014_0253`)** AST üçünde de taban uygulamasını (`10`), öbür beş motor üçünde de türetilmiş geçersiz kılmayı (`20`) çağırır. Dışarıdan `c.Value()` her zaman `20` verir |
| Taban tipli değişkenle `DELETE` (`DIM x AS A = NEW B()`, `DELETE x`) | ✖ **FARK (G-NESNE-26):** AST `B.dtor` ve `A.dtor` çalıştırır; MIR, x64, JS, WASM ve eski AST-x64 yalnız `A.dtor` çalıştırır, türetilmiş yıkıcı atlanır |
| Aynı adlı alanı taban ve türetilmiş sınıfta yinelemek | ✔ Altı yolda `semantic: CLASS field hides inherited member …` ile **reddedilir** (kapandı; G-NESNE-28, test `neg_inherited_field_hiding`) |
| Kurucuda ve yıkıcıda metot çağrısı | ✔ **Kaynakta düzeltildi (G-NESNE-40):** **sanal** bir `m` için `ME.m()` ve niteliksiz `m()` derleme hatasıdır (altı yolda «ME virtual method call is not allowed in CONSTRUCTOR» / «… DESTRUCTOR»); `THIS.m()` (doğrudan, kurucunun kendi sınıfının uygulaması) ve **sanal olmayan** her biçim serbesttir. **Ölçüm ikilisinde** yalnız açık `ME.` öneki reddedilirdi (sanal olmayanı da), `THIS.Sanal()` ve niteliksiz `Sanal()` kabul edilir ve motorlar ayrışırdı (AST `1`, x64, JS, WASM ve eski AST-x64 `2`, **MIR hiçbir şey yazmazdı**) |
| Parametreli tabanı `SUPER(...)` olmadan kurmak | ✖ SESSİZ: hata vermez (G-NESNE-28, G-NESNE-25) |
| `ABSTRACT CLASS`, `FINAL CLASS`, `SEALED CLASS` | ✖ Ölçüm ikilisinde ayrıştırılamaz (G-NESNE-38). Kaynakta düzeltildi: soyut sınıfa `NEW` ve `FINAL`/`SEALED` sınıfı türetmek derleme hatasıdır, soyut tipli değişken türemiş nesneyi tutabilir |
| Bir işlevin/`MAGIC` işlecin döndürdüğü nesneleri art arda saklamak (`x = Yap(2)`, `y = Yap(3)`) ya da işleç sonucunu zincirlemek (`a = a * b`) | ✖ SINIR (G-NESNE-9): AST iki sonucu aynı nesneye bağlar (`3 3`); MIR ve x64 doğru (`2 3`). İşleç sonucunu hemen kullanın, nesneleri `NEW Sinif(...)` ile yaratın |

## 11.5 Arayüz

`INTERFACE`, bir sınıfın uyması gereken metot imzalarını tanımlar. `CLASS X IMPLEMENTS IA, IB` ile bir sınıf **birden çok arayüz** uygulayabilir. Metotlardan biri eksikse
derleme hatası alırsınız (`interface method missing implementation CM.A for IA`). Arayüz tipli değişken yalnız o arayüzün metotlarını görür.

{{ORNEK:07_yapi/interface|baslik=INTERFACE ve IMPLEMENTS}}

{{ORNEK:49_kv_nesne/arayuz_coklu|baslik=İki arayüz, iki arayüz tipli değişken}}

## 11.6 Özellik: `PROPERTY`

Alan gibi okunup yazılan, arkada metot gibi çalışan üyedir. Bugün yalnızca **kısa biçim** çalışır: `PROPERTY Ad AS tip GET SET`.

{{ORNEK:07_yapi/property|baslik=PROPERTY GET SET}}

| Konu | Durum |
|---|---|
| `PROPERTY Ad AS tip GET` (yalnız okunur) | ◐ AST yazmayı `property SET accessor denied` ile reddeder; MIR ve x64 **sessizce yazar** (G-NESNE-3) |
| `PROPERTY ... GET ... END GET ... SET(v) ... END SET` blok biçimi | ✖ ◇ HEDEF: ayrıştırılamaz ("PROPERTY SET: unexpected trailing tokens"), G-HEDEF-3 |
| `PRIVATE` bölümünde `PROPERTY ad AS T` ve metotlarda çıplak adla kullanım | ✖ SESSİZ (G-NESNE-18): `deger = deger + d` sonrası okuma AST `42`, MIR `0`, x64 `1`, JS `undefined`. Sınıf içi durum için düz `DIM` alanı kullanın |

## 11.7 Sihirli metotlar: `MAGIC`

`MAGIC ADI(...) ... END MAGIC` biçimindedir (`END METHOD` ile **kapanmaz**). Sınıfın işleçlerle ve yerleşik işlevlerle nasıl davranacağını belirler:

| `MAGIC` | Ne zaman çağrılır? | Durum |
|---|---|---|
| `ADD(o)`, `SUB(o)`, `MUL(o)` | `a + b`, `a - b`, `a * b` | ✔ dört motorda |
| `DIV(o)`, `IDIV(o)`, `MOD(o)` | `a / b`, `a \ b`, `a MOD b` | ✔ dört motorda |
| `SHL(o)`, `SHR(o)` | `a SHL b`, `a SHR b` | ✔ dört motorda |
| `EQ(o)`, `NE(o)`, `LT(o)`, `LE(o)`, `GT(o)`, `GE(o)` | `=`, `<>`, `<`, `<=`, `>`, `>=` (tamsayı döndürür: doğru -1, yanlış 0) | ✔ dört motorda; sonuç `IF` koşulunda doğrudan kullanılır |
| `TOSTRING()` | `STR(nesne)` | ✔ Metin gösterimi. ✖ **AST gerilemesi (G-NESNE-29, `20261013` 12:37'den beri):** bu sihirli metot tanımlı bir sınıfın `F64` (ve bazı programlarda `I32`) dönüşlü metodunun sonucunu bir **değişkene** yazmak AST'de `0` verir (`b = f.GetB()` → `0`; `PRINT f.GetB()` doğrudur); MIR, x64 ve JS doğrudur, `20261007`'de AST de doğruydu |
| `AND(o)`, `OR(o)`, `XOR(o)` | `a AND b` … | ◐ 20261007 derlemesinde AST ve MIR ✔, x64 ve JS **derlemede reddeder** (`ADIM25 … BINARY: FAIL_EXPECTED_OPCODE_NOT_FOUND`); 20261013 sonrası derlemelerde dört motorda ✔ (S-443). Kanca gövdesinde alana bit sonucu atarken ifadeyi parantezleyin: `r.v = (v AND o.v)` (G-ISLEC-7: parantezsiz yazım `0` verir) |
| `CALL(x)` | `a(3)` | ✖ (G-NESNE-21): yalnız `PRINT a(3)` içinde ve yalnız AST'de |
| `GET(ad)`, `SET(ad, x)` | olmayan alanı okuma / yazma | ✖ (G-NESNE-21): `GET` yalnız AST'de çalışır (MIR `0`, JS `undefined`, x64 derlemez); `SET` her motorda reddedilir |

{{ORNEK:22_kurallar/operator_magic_add|baslik=MAGIC ADD}}

{{ORNEK:49_kv_nesne/vektor_magic|baslik=Orta düzey: vektör sınıfı + - * ve TOSTRING}}

{{ORNEK:49_kv_nesne/magic_islec_kumesi|baslik=Bölme, kalan, kaydırma ve karşılaştırma kancaları}}

> **✖ SINIR (G-NESNE-4):** Nesneyi doğrudan `PRINT n` ile yazdırmak motorlara göre `0`, `OBJECT#0` ya da çöp sayı verir. **Her zaman `PRINT STR(n)` yazın.**

`OPERATOR +(...) ... END OPERATOR` biçimi (eski tasarım kılavuzundaki) **ayrıştırılır ama işleci bağlamaz** (G-NESNE-15): `c = a + b` ikisi sınıf tipliyken `+` sonucu `I32` sayılır ve "assignment cannot convert TYPE_I32 to …" ile reddedilir. İşleç için `MAGIC ADD` yazın.

> **Tanınmayan `MAGIC` adı hata vermez (G-NESNE-14, ✖ SESSİZ):** `MAGIC BU_YOK() … END MAGIC` ve henüz hiçbir şeye bağlı olmayan `MAGIC ITER()` kabul edilir, işe yaramaz. Yazım hatasını derleyici yakalamaz; adları yukarıdaki listeyle karşılaştırın.

## 11.8 Orta düzey örnek: banka hesabı

Alan `PRIVATE` tutulur, değişiklik metotlarla yapılır, kural ihlali `THROW` ile bildirilir, çağıran `TRY/CATCH` ile yakalar:

{{ORNEK:49_kv_nesne/banka_hesabi|baslik=Kapsülleme + hata yönetimi}}

## 11.9 Benzerlerinden farkı

| İkili | Fark |
|---|---|
| `TYPE` ve `CLASS` | `TYPE` değer tipi (atama kopyalar), davranışı yok; `CLASS` referans tipi, metotları var |
| `EXTENDS` ve `IMPLEMENTS` | Başka sınıftan **gerçek kod** devralma / arayüzün **sözleşmesine** uyma |
| `VIRTUAL` ve `OVERRIDE` | Metodu değiştirilebilir ilan etme / alt sınıfta değiştirme |
| `THIS` ve `ME` | İkisi de geçerli nesnedir; ayrı çağırırlar: `THIS.m()` yazıldığı sınıfın uygulamasını **doğrudan**, `ME.m()` (ve niteliksiz `m()`) gerçek nesne türüne göre **sanal** çağırır (11.10; **kaynakta düzeltildi**, G-NESNE-24: ölçüm ikilisinde AST ikisini de doğrudan, öbür motorlar ikisini de sanal çağırırdı) |
| `SUPER` ve `BASE` | `SUPER` çalışır; `BASE` yoktur |
| `MAGIC` ve `METHOD` | `MAGIC` dilin tanıdığı özel davranışları bağlar (işleç, `STR`); `METHOD` sıradan metottur |
| `NEW`/`DELETE` ve kapsam çıkışı | Nesne yaşamı **elle** yönetilir; kapsam bitince yıkıcı çalışmaz. Yeniden atama (`a = NEW …`) eski nesneyi yıkmaz (dört motorda aynı) |

## 11.10 Tasarlanan OOP sözleşmesi (◇ HEDEF)

`docs/OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md` (2026-09-15), nesne yönelimli yüzeyi tek bir sözleşme altında toplayan bir **tasarım önerisidir** ("v1"). Belge, uygulandığı ya da motorların geçtiği iddiası olmadığını yazar; `DELETE`/başvuru sayımı modeli, `MIXIN`'in trait'e geçişi ve `VALUE` profili gibi başlıkları da **ürün onayına** bırakır (`THIS`'in doğrudan anlamı da böyleydi; Mete'nin 2026-10-16 tasarım belgesi `THIS` doğrudan, `ME` sanal diye açıkça yazdığından karar verilmiş ve uygulanmıştır: aşağıda). Aşağıdakiler bu yüzden kesin karar değil ◇ HEDEF'tir (G-HEDEF-4, G-HEDEF-25); "Bugün" sütunları bu kılavuzun hazırlığında ölçülenleri gösterir.

### `THIS`, `ME` ve `SUPER`: görev ayrımı

| Biçim | Tasarlanan anlam | Metot çağrısı |
|---|---|---|
| `THIS` | Bu metodun gövdesini yazan sınıfın uygulama görünümü | **Doğrudan**; sanal yuvayı yeniden dağıtmaz |
| `ME` | Aynı nesnenin çok biçimli davranışı | Sanal ya da arayüz yuvası varsa **gerçek nesne türüne göre**; sıradan metotta doğrudan |
| `SUPER` | Bu gövdenin sahibinin **doğrudan** tabanından başlayan uygulama | Doğrudan taban uygulaması; türetilmiş geçersiz kılmaya dönmez |

Üçü de aynı nesnenin kimliğini taşır; fark üye çözümlemesinde ve çağrı seçimindedir. Gövdedeki niteliksiz **alan** kullanımı `THIS.alan` ile eşdeğerdir; niteliksiz **metot çağrısı** `ME.metot()` (sanal) ile eşdeğerdir, doğrudan çağrı `THIS.metot()` ile açık yazılır. Planın ayırt edici örneği:

```basic
CLASS Base
    PUBLIC
    VIRTUAL METHOD Value() AS I32
        RETURN 10
    END METHOD
    METHOD Inspect() AS I32
        RETURN THIS.Value() * 100 + ME.Value()
    END METHOD
END CLASS
CLASS Child EXTENDS Base
    PUBLIC
    OVERRIDE METHOD Value() AS I32
        RETURN SUPER.Value() + 10
    END METHOD
END CLASS
DIM c AS Child = NEW Child()
PRINT c.Inspect()
```

Sonuç **`1020`** olur: `THIS.Value()` taban uygulamasını (10), `ME.Value()` türetilmiş uygulamayı (20) çağırır. **Kaynakta düzeltildi (2026-10-17, G-NESNE-24, G-NESNE-46):** altı yolda `1020`. Ölçüm ikilisinde (`20261014_0253`) hiçbir motor ayrımı uygulamıyordu: AST `1010`, MIR, x64, JS, WASM ve eski AST-x64 `2020` yazıyordu. Ek kurallar (◇ HEDEF): `ME` dinamik üye araması değildir, yani taban sınıf kodu yalnız türetilmiş sınıftaki bir alana `ME` ile erişemez (bugün de reddedilir, ama iletisi yanıltıcıdır: `explicit cast TYPE_OBJECT to …`); `THIS` ve `ME` yeniden atanamaz (`THIS = NEW K()` bugün de reddedilir, ama iletisi yine yanıltıcıdır: `assignment requires explicit cast K to TYPE_OBJECT`); `SUPER` tek başına değer değildir (`x = SUPER` bugün aynı yanıltıcı iletiyle reddedilir); `STATIC` üyede üçü de yasaktır (bugün de `THIS/ME cannot be used in a STATIC class member` ile reddedilir); `THIS`/`ME` erişim denetimini aşmaz; kurucu ve yıkıcı içinden sanal çağrı yasaktır (**kaynakta uygulandı**, G-NESNE-40: `ME.m()` ve niteliksiz `m()` **sanal** `m` için derleme hatasıdır, `THIS.m()` ve sanal olmayan çağrı serbesttir). Eski `THIS.sanalMetot()` kodunun davranışı değişti (artık doğrudan çağırır): depodaki 565 programın (413'ü sınıflı ya da arayüzlü) anlamsal denetimi eski ve yeni derleyicide karşılaştırıldı ve yeni kurallarla reddedilen hiçbir mevcut program çıkmadı; kendi kodunuzda dinamik davranış istediğiniz yerde `ME.sanalMetot()` yazın.

### Türler, kimlik ve kopyalama

| Yapı | Tasarlanan sözleşme | Bugün |
|---|---|---|
| `TYPE` | Yönetilen değer kaydı; atama alan alan kopyalar; içindeki `CLASS` alanları başvuru olarak kopyalanır | Atama değer kopyasıdır (dört motor); `CLASS` alanı sınırları: G-NESNE-10 |
| `STRUCT … ABI C` | C yerleşimli kayıt; ham blok kopyası yalnız basit kopyalanabilir türlerde | Bölüm 10 |
| `UNION … ABI C` | Ortak bayt depolama; yönetilen başvuru reddedilir | Bölüm 10 (G-VERI-11) |
| `ENUM` | Adlandırılmış sabit kümesi; tamsayı taban türü; aralık doğrulaması; açık sayısal dönüşüm | Bölüm 10 |
| `CLASS` | Kimlikli başvuru nesnesi; atama başvuruyu paylaşır, kopyalamaz | Dört motorda ✔ |
| `INTERFACE` | Ayrı nesne oluşturmayan, kimlik + arayüz dağıtım görünümü | AST, MIR, x64 ✔; JS'te `nan` (G-JS-3; asıl neden argümanın düşmesi, G-JS-15, kaynakta düzeltildi); `IMPLEMENTS`'siz sınıf: G-NESNE-41; eski AST-x64'te arayüz tipli parametre: G-NESNE-42 |

* Varsayılan eşitlik **kimlik eşitliğidir** (`a = b`, iki değişken aynı nesneyi gösteriyorsa `-1`; bugün dört motorda ✔). Değer eşitliği kullanıcı sözleşmesiyle gelir; `EQ` ve `HASH` birlikte tutarlı olmalı, eşit nesneler aynı özeti vermelidir.
* Kopyalama: `CloneShallow` ile `CloneDeep` ayrımı açık yazılır; derin kopya döngüleri ve ortak başvuruları koruyan bir ziyaret tablosu ister; yerel kaynaklar varsayılan olarak kopyalanamaz. Bugün ikisi de yoktur.
* `NULL` ile sarkan başvuru ayrılır; tür sınama ve **denetimli dönüştürme** (checked cast) tek sözleşmedir; başarısız daraltma sessiz sıfır ya da yanlış işaretçi üretmez. Bugün `INSTANCEOF` yalnız AST'dedir (11.4).

### Kalıtım, erişim ve metot

* 15 Eylül önerisi: bir sınıfın **tek uygulama tabanı** ve **çok arayüzü** vardır; çoklu durum kalıtımı yoktur (bugün de böyledir). **Bu madde 2026-10-15'te Mete'nin kararıyla değişti:** uXBasic nesne yönelimli paradigmayla doğduğu için OOP, çoklu kalıtım ve karışım dahil çok güçlü olmalıdır (G-NESNE-30, karar bekliyor; seçenekler 11.12'de).
* `OVERRIDE` yalnız var olan sanal yuvayla, aynı parametre / `BYREF` yönü ve dönüşle eşleşir (ilk sürümde dönüş tipi birebir; kovaryans sonradan). Bugün imza uyuşmazlığı ayrıştırmada reddedilir (`METHOD: OVERRIDE signature …`).
* `FINAL` sınıf türetilemez, `FINAL` metot geçersiz kılınamaz; `SEALED`, `FINAL CLASS`'ın belgelenmiş eşanlamlısıdır; `ABSTRACT` sınıf doğrudan oluşturulamaz ve soyut ya da arayüz yuvaları tamamlanmadan somut sınıf olmaz. **Ölçüm ikilisinde ayrıştırılamaz** (G-NESNE-6): anlamsal ve çalışma anı denetimleri vardı (soyut sınıfa `NEW` reddi, `FINAL`/`SEALED` sınıfı türetme reddi) ama `ABSTRACT CLASS` yazımına kaynaktan ulaşılamıyordu; kök neden bulundu ve kaynakta düzeltildi (G-NESNE-38).
* `PUBLIC` herkese, `PRIVATE` yalnız bildiren sınıfa, `PROTECTED` bildiren sınıfa ve türevlerine açıktır; `PROTECTED` için alıcı kuralı da denetlenir (türetilmiş sınıf rastgele bir taban örneğinin korumalı durumuna erişemez). `RESTRICTED` paket ya da modül içi erişimdir (ham klasör yoluna bağlı değildir); `FRIEND` yalnız açıkça adı geçen sembollere sınırlı yetki verir. Bugün alanlarda erişim denetimi yoktur (G-NESNE-2) ve `RESTRICTED` yalnız AST'de zorlanır (G-NESNE-19).
* Alan adını kalıtımla gizlemek **varsayılan hatadır** (bugün sessiz: G-NESNE-28). Aşırı yükleme ile geçersiz kılma farklı şeylerdir; aşırı yükleme derleme zamanında çözülür, eşit iyi aday belirsizlik hatasıdır ve dönüş tipi tek başına aşırı yüklemeyi ayıramaz. Bugün aynı adlı iki metot `duplicate member` ile reddedilir.
* **Genel (jenerik) sınıf ve arayüzler** hedeftedir: açık tür parametreleri, kısıt denetimi, varsayılan değişmezlik (invariance); ilk uygulama somutlaştırmadır (monomorphization). Bugün yoktur (G-HEDEF-4).

### Özellik, sihirli metot ve işleç

* `PROPERTY` saklama alanı değil, `GET`/`SET` erişimci sözleşmesidir. Yalnız `GET` olan özellik dışarıdan okunur, yalnız `SET` olan okunamaz; indeksli özellikte iki erişimcinin indeksleri aynı tiptedir. Sanal özelliğin `GET` ve `SET` yuvaları ayrı ama aynı özellik kimliği altındadır. Bugün yalnız-`GET` özelliğe yazmak AST'de reddedilir, MIR/x64/JS'te sessizce yazar (G-NESNE-3).
* `READONLY` alan kurulum sonunda sabitlenir ama başvurunun hedefini dondurmaz; `IMMUTABLE` nesne grafiği için daha güçlü bir güvencedir; `MUTABLE` bu güvenceyi sessizce delmez.
* `OPERATOR` ile ona karşılık gelen bilinen `MAGIC` aynı davranış yuvasına normalleşir; ikisini aynı sınıfta çelişkili tanımlamak hatadır. `MAGIC GET/SET/CALL` yalnız normal üye çözümlemesinde üye **bulunamayınca** devreye girer; `PRIVATE` ihlalini ya da yanlış imzayı gizleyemez. `TOSTRING` açık dönüşüm ve yazdırma sözleşmesine bağlıdır (biçim, hata, özyineleme koruması). `ANDALSO`/`ORELSE` kısa devresi korunur.
* `a().P += f()` sırası: alıcı bir kez, `GET` bir kez, sağ taraf bir kez, işleç bir kez, `SET` bir kez; ara adım hata verirse sonrakiler çalışmaz.

### Karışım (trait), dekoratör ve nesne ömrü

* `MIXIN` gizlice tek tabana dönüştürülmez; **açık trait bileşimi** olur. Trait varsayılan metot gövdelerini ve gereken arayüzleri bildirir, ilk sürümde durum taşımaz. İki trait aynı imzayı verirse sonuncusu kazanmaz: açık seçim, yeniden adlandırma ya da sınıfta geçersiz kılma gerekir. Trait içinde `SUPER` yasaktır. `USES` ise nesne bileşimidir (içerilen parça + açık delegasyon) ve `MIXIN` ile eşanlamlı değildir.
* `DECORATOR`'ın her biri için kimlik/sürüm, tür, geçerli hedef, argüman tipleri, tekrarlanabilirlik ve sıra kayıtlıdır. Üç türü vardır: **metadata** (türlenmiş öznitelik kaydı), **derleme dönüşümü** (normal AST üyeleri üretir), **çağrı sarmalama** (tek genel giriş + özgün gövde çağrısı). Bilinmeyen dekoratör hatadır; metadata kendi başına iş yapmaz; `D`, `E` sırasıyla bildirilirse `D(E(gövde))` olur (giriş `D`, `E`; çıkış `E`, `D`; temizlik `FINALLY` güvencesiyle).
* **Nesne ömrü:** yönetilen `CLASS` için güçlü başvuru sayımı + **zayıf (weak) başvuru**; güçlü döngüler otomatik toplanmış sayılmaz, zayıf bağlantı ya da açık döngü kırma gerekir. `NEW` önce taban alanlarını, sonra türetilmiş alanları hazırlar; taban kurucu önce çalışır; parametreli tabanda `SUPER(...)` zorunludur. Kurucu hata verirse yalnız kurulmuş parçalar ters sırayla temizlenir ve nesne yayımlanmaz. Son güçlü başvuru bırakılınca yıkıcı **türetilmişten tabana, bir kez** çalışır; yıkıcıdan istisna dışarı kaçmaz. `DELETE` hedef değişkendeki güçlü başvuruyu bırakıp `NULL` yapar, öbür takma adları geçersizleştirmez; `Close`/`Dispose` kaynağı erken kapatır ve tekrar çağrılabilir. Nesne durumları: `allocated`, `constructing`, `live`, `disposing`, `disposed`.
* Bugün: başvuru sayımı ve zayıf başvuru yoktur (yaşam **elle** yönetilir, 11.2); parametresiz taban kurucusu altı yolda çalışır, parametreli olanı beş ayrı davranır (G-NESNE-25); `SUPER(...)` yoktur (G-NESNE-27); taban tipli değişkenle `DELETE` AST dışında beş yolda türetilmiş yıkıcıyı atlar (G-NESNE-26); `DELETE` aslında «statik yıkıcı zinciri + değişken = 0»dır ve nesnede ölü işareti yoktur (G-HEDEF-31).

### `UXClazz` profilleri ve kütüphane sınırı

| Profil | Hedefte gerçek garanti | Sınır |
|---|---|---|
| `DATA` | Kurucu, denetimli erişimciler, açık `DERIVE` üretimi | Normal `CLASS` çıktısı |
| `VALUE` | Değer eşitliği, kopyalama, değişmezlik | Sıradan `CLASS` üretmekle "değer depolaması" sağlanmaz; ayrı değer indirgemesi gerekir |
| `ENTITY` | Sabit kimlik, sürüm, kimlik temelli eşitlik | Veritabanı kaydı otomatik değildir |
| `COMPONENT` | İçerilme, sahiplik, bağlama / ayırma ömrü | Bileşen-varlık zamanlayıcısı otomatik değildir |
| `ACTOR` | Posta kutusu, sıralı işlem, ileti tipleri, kapanış | Gerçek aktör çalışma zamanı gelmeden "destekleniyor" sayılmaz |
| `NATIVE` | Dış kaynağa tipli tutamaç, ABI ve sahiplik sözleşmesi | C++ nesne adresi BASIC sınıf adresi değildir |

Bugün bu profiller derleyicide yoktur; üretici `tools/uxclazz/uxclazz.py` dış araçtır (G-HEDEF-2, Bölüm 16.9). Tasarım ayrıca şunları ister: `uxclz` köprüsünde `TypeId`, `ObjectId`, `InterfaceId` ve `MethodId` ayrı alanlardır; iki çalışma zamanının başvuru sayımı açık bir bağdaştırıcıyla bağlanır; ödünç alınan sonuç sahibinden uzun yaşayamaz; FFI'da nesne ya da metot istisnası C sınırından taşmaz (durum kodu + türlenmiş hata sonucu); web hedefinde DLL yüklenmiş varsayılmaz.

### Anahtar sözcük politikası ve uygulama sırası

`THIS`/`ME`/`SUPER` örnek bağlamında özel alıcı sözcüklerdir ve aynı bağlamda kullanıcı değişkeni olamaz. `VIRTUAL` bellek deyimi ile `VIRTUAL METHOD`, `GET` dosya deyimi ile özellik/`MAGIC`, `SET` koleksiyon tipi ile özellik/`MAGIC` açık ayrıştırıcı bağlamlarıyla ayrılır. Dekoratör, profil ve `DERIVE` adları gereksiz yere ayrılmış sözcük yapılmaz. Plan, uygulamayı şu paketlerle önerir: P0 dil sözleşmesi ve motor matrisi → P1 adlar ve bağlamsal anahtar sözcükler → P2 alıcı biçimleri (`THIS`/`ME`/`SUPER`, `1020` örneği) → P3 yöntem/yuva kimliği ve ortak çözümlenmiş plan → P4 nesne ömrü, takma ad, zayıf başvuru, kurucu hatası → P5 bütün motorlarda çekirdek OOP eşliği → P6 özellik/işleç/aşırı yükleme → P7 trait ve dekoratör hattı → P8 `UXClazz`/`uxclz`/FFI sahipliği → P9 jenerikler, `VALUE`, yansıma, aktör/bileşen → P10 geçiş aracı, belge, editör, yayın kapısı. Kabul ölçütü: her test yalnız çıktıyı değil dönüş/istisna, yan etki sırası, yıkıcı sayısı ve sahiplik dengesini de doğrular; **iki motor aynı yanlış sonucu verince geçmiş sayılmaz**; desteklenmeyen yetenek görünür biçimde `UNSUPPORTED` olarak kalır ve hedef kapsamındaysa paketin kapanmasını engeller.

## 11.11 Nesne yönelimli programlamayla ilgili programlama kararları

* **Parametreli taban kurucusuna güvenmeyin** (G-NESNE-25, G-NESNE-27): parametresiz taban kurucusu altı yolda çalışır; ama taban kurucusu parametre istiyorsa altı yol beş ayrı davranır ve `SUPER(...)` yoktur. Ortak başlatmayı bir `Baslat()` metoduna koyup `NEW`'dan sonra açıkça çağırın; parametreli kurucusu olan bir sınıftan türetmeyin.
* **Şablon-metot için (taban metodunun türetilmiş geçersiz kılmayı çağırması) `ME.m()` ya da niteliksiz `m()` yazın**; `THIS.m()` her zaman yazıldığı sınıfın uygulamasını çağırır (G-NESNE-24, altı yolda aynı; ölçüm ikilisinde AST'de ikisi de doğrudandı). Kurucuda ve yıkıcıda sanal metodu `ME`/niteliksiz çağırmak derleme hatasıdır; ortak işi sanal olmayan bir metoda koyun ya da `THIS.m()` yazın (G-NESNE-40); taban ve türetilmiş sınıfta aynı alan adını yinelemek artık derleme hatasıdır.
* Nesneyi **yarattığınız sınıfın tipiyle** tutup `DELETE` edin: taban tipli değişkenle silmek türetilmiş yıkıcıyı AST dışında beş yolda atlar (G-NESNE-26).

* **Veri ile davranış birlikteyse `CLASS`, yalnız veriyse `TYPE`** yazın. `TYPE` değer tipidir (atama kopyalar), `CLASS` referans tipidir (atama aynı nesneye ikinci ad verir).
* Nesneyi `DIM d AS Sinif = NEW Sinif(...)` ile üretin ve **değişken adını sınıf adından farklı** seçin (`CLASS Kutu` varken `DIM kutu1 AS Kutu`); aynı ad `variable K conflicts with CLASS K` hatası verir.
* **Her `NEW` için bir `DELETE` yazın.** Yıkıcı kapsam bitince çalışmaz, yalnız `DELETE` ile çalışır; dosya, bellek ya da tutamaç tutan sınıflarda temizliği unutmayın.
* Nesneyi kopyalamak için `b = a` yazmayın: aynı nesneye ikinci ad verir. Kopya gerekiyorsa **yeni nesne üretip alanları tek tek kopyalayın**.
* Alanları metotlarla yönetin, kuralları `THROW`/`ASSERT` ile koruyun; **`PRIVATE` alan erişimi dışarıdan denetlenmez** (G-NESNE-2), yani dilin sizi korumasına güvenmeyin.
* Çok biçimlilik için `VIRTUAL` + `OVERRIDE` kullanın; üst sınıf metodunu `SUPER.Ad()` ile çağırın (`BASE` yoktur). Ara sınıfın `OVERRIDE`'ını alt-alt sınıfta **yeniden yazın** (G-NESNE-7).
* Soyutluk gerektiğinde `INTERFACE` kullanın (`ABSTRACT`, `FINAL`, `SEALED` ölçüm ikilisinde ayrıştırılamaz; iki `MIXIN` ve `EXTENDS`'li `MIXIN` reddedilir: G-NESNE-6, G-NESNE-38). İşlev parametresini arayüz tipinde alırsanız bağımlılık tek yerde kalır; bir sınıf birden çok arayüz uygulayabilir; ama arayüz tipli parametreye `IMPLEMENTS` yazmamış sınıf verirseniz altı yol ayrışır (G-NESNE-41).
* Nesneyi yazdırırken **her zaman `PRINT STR(n)`** yazın ve sınıfa `MAGIC TOSTRING()` ekleyin (G-NESNE-4); ama AST'de `MAGIC TOSTRING` tanımlı sınıfın sayısal dönüşlü metodunun sonucunu değişkene yazmayın (✖ G-NESNE-29, geçici çözüm yoktur: sonucu doğrudan `PRINT` edin ya da programı MIR, x64 ya da JS ile çalıştırın). İşleç sonucunu hemen kullanın; ardışık saklama ya da `a = a * b` zinciri AST'de yanlış olabilir (G-NESNE-9).
* x64'e derleyecekseniz **bir ifadede iki ondalıklı alanı birlikte okumayın** (`k * k`, `k + k`: sonuç `0`/çöp çıkar, G-NESNE-43; alanı önce yerel değişkene kopyalayın) ve ondalıklı alana tamsayı sabiti yazmayın (`3.0` yazın): sonuç çöp çıkar (G-NESNE-8). Eski AST-x64'te `F64` parametreli **kurucu** alana çöp yazar (G-NESNE-44; kaynakta düzeltildi, `NEW` argümanı tamsayı yazmacında gidiyordu). Nesne dizisi (`DIM d(n) AS Sinif`) x64'te derlenmez; bu hedefte nesneleri ayrı değişkenlerde tutun.
* `RETURN THIS` ile yöntem zinciri kurmayın (G-NESNE-5); `STATIC` üyeye güvenmeyin, motorlar farklı davranır (G-NESNE-1).
* `PROPERTY` yalnız kısa biçimde (`PROPERTY Ad AS tip GET SET`) kullanın; yalnız okunur (`GET`) özelliğe yazmak AST'de reddedilir ama MIR ve x64'te sessizce çalışır (G-NESNE-3).

## 11.12 OOP'de neler eksik? (2026-10-15 denetimi)

Mete (2026-10-15): uXBasic nesne yönelimli programlama paradigmasıyla doğdu; OOP sistemi çok güçlü ve farklı kullanımlara açık olmalı. Aşağıdaki tablo, 15 Eylül tasarımına (11.10) ve altı yolda ölçüme (`20261014_0253`) göre yetenek yetenek durumu gösterir.

| Yetenek | Durum | Kayıt |
|---|---|---|
| Tek tabanlı kalıtım, `VIRTUAL`/`OVERRIDE`, `SUPER.Ad()` | ✔ (sınırlar 11.4'te) | G-NESNE-7, G-NESNE-24, G-NESNE-25 |
| Çok arayüz (`IMPLEMENTS IA, IB`) | ✔ AST, MIR, x64; JS ≠, WASM ≠ | G-JS-3 |
| **Çoklu kalıtım** (`EXTENDS A, B`) | ✖ ayrıştırma hatası; **karar: B (2026-10-16)**, çakışma anahtar sözcükleriyle denetlenir (11.13) | G-NESNE-30, G-HEDEF-40 |
| **Karışım / trait** (`MIXIN`) | ◐ gövdede tek `MIXIN Sinif` ✔ (altı yol); iki karışım, `EXTENDS`'li karışım, blok biçimi ✖; tasarımda açık trait bileşimi ◇ HEDEF | G-NESNE-6, G-HEDEF-4, G-HEDEF-39 |
| `USES` bileşimi, jenerik sınıf, `DECORATOR` | ✖ ◇ HEDEF | G-HEDEF-4, G-HEDEF-25 |
| `ABSTRACT`, `FINAL`, `SEALED` | ✖ ölçüm ikilisinde ayrıştırılamaz; kaynakta düzeltildi (anlamsal denetimler zaten vardı) | G-NESNE-6, G-NESNE-38 |
| Arayüz mirası (`INTERFACE IB EXTENDS IA`) | ✖ ayrıştırma hatası | G-NESNE-31 |
| Arayüzde gövdeli (varsayılan) metot | ✖ ayrıştırma hatası | G-NESNE-34 |
| Taban kurucu zinciri, `SUPER(...)` | ◐ parametresiz zincir altı yolda ✔; parametreli taban kurucusu beş ayrı davranış; `SUPER(...)` yok (WASM ve eski AST-x64 sessizce `0` yazar) | G-NESNE-25, G-NESNE-27 |
| Kurucu aşırı yükleme (birden çok `CONSTRUCTOR`) | ✖ ayrıştırma hatası | G-NESNE-35 |
| Metot aşırı yükleme | ✖ AST `duplicate routine`; MIR ve JS yanlış sonuç; x64 derlemez | G-YORDAM-1 |
| İç içe sınıf | ✖ ayrıştırma hatası | G-NESNE-32 |
| Sınıf sabiti (sınıf içinde `CONST`) | ✖ ayrıştırma hatası | G-NESNE-33 |
| `STATIC` üye | ◐ motorlara göre değişir | G-NESNE-1 |
| Tür sınama `INSTANCEOF(nesne, Sinif)`, `IS`, `AS` | ◐ `INSTANCEOF` yalnız AST (`-1`); `s IS Kare` ve `s AS Kare` ayrıştırma hatası ◇ HEDEF | G-NESNE-36, G-HEDEF-32 |
| Boş nesne / boş başvuru (`NULL`, `NOTHING`) | ✖ yüzeyde yok; **çalışacak (Mete kararı, ◇ HEDEF, S-564)** | G-TIP-31 |
| Alan erişim denetimi | ✖ metotta denetlenir, alanda denetlenmez | G-NESNE-2 |
| `PROPERTY` blok biçimi | ✖ ◇ HEDEF | G-HEDEF-3 |
| Zayıf başvuru, başvuru sayımı, kapsam çıkışında yıkıcı | ✖ ◇ HEDEF (yaşam elle yönetilir) | G-HEDEF-25 |
| İşleç yükleme (`MAGIC ADD` …) | ✔ AST, MIR, x64, JS; WASM ≠ | G-NESNE-9, G-NESNE-15 |
| İşlev değeri / geri çağrı (`FUNCTION_PTR`), lambda | ✖ ◇ HEDEF | G-TIP-8, G-HEDEF-26 |

### Çoklu kalıtım nedir, A, B ve C ne demek? (karar: **B**, 2026-10-16, S-555)

**Mete'nin cevabı (2026-10-15):** «önerdiğin gibi» (C) dedi, ama seçeneklerin içeriğini tam anlamadığını söyledi; sade anlatım bu yüzden eklendi. **2026-10-16'da kararını verdi: «B ile devam».** Yani sınıf birden çok tabandan hem davranışı hem alanları devralabilecek. Aynı mesajda bir fikir getirdi: iki tabandan **aynı adlı metot** gelirse çakışma çıkar; miras alan sınıf bazı anahtar sözcüklerle bu birleştirmeyi durdurabilsin. **Cevap: evet**; tasarım 11.13'te ve `docs/tasarim/UXB_S555_COKLU_KALITIM_B_VE_CAKISMA_DENETIMI_20261016_TR.md` içindedir. Aşağıdaki A/B/C anlatımı, kararın neyi seçtiğini anlamak için bırakıldı.

**Önce kısa bir anlatım.** *Kalıtım*, bir sınıfın başka bir sınıftan özellik ve davranış devralmasıdır: `Kopek` sınıfı `Hayvan` sınıfından türeyince hayvanın yaptığı her şeyi (yemek, uyumak) kendiliğinden yapar. Bugün bir sınıfın **tek bir** tabanı (ebeveyni) olabilir (`CLASS Kopek EXTENDS Hayvan`). Bir sınıf ayrıca istediği kadar **arayüz** imzalayabilir (`IMPLEMENTS`); arayüz yalnız bir sözdür ("şu işlevleri yapabilirim"), içinde hazır kod ve veri yoktur. *Çoklu kalıtım* ise bir sınıfın birden çok ebeveynden devralmasıdır; örneğin `AmfibiArac`, hem `KaraAraci` hem `SuAraci` sınıfından.

Üç seçenek, bu işin ne kadarını ve hangi sırayla yapacağımızı belirler (örneklerdeki yazım yalnız anlatım içindir; gerçek yazım uygulamada kesinleşir):

| Seçenek | Sade anlatım | Küçük örnek (◇ HEDEF; bugün çalışmaz) | Artısı | Eksisi |
|---|---|---|---|---|
| **A. Durumsuz karışım** | Sınıfın yine **tek** ebeveyni (verisini taşıyan sınıf) olur; üstüne istediği kadar "yetenek kutusu" (`MIXIN`) takılır. Kutuların içinde yalnız işlevler vardır, **veri (alan) yoktur** | `CLASS Rapor EXTENDS Belge MIXIN Yazdirilabilir, Kaydedilebilir` | Basit ve güvenli; kutularda veri olmadığı için çakışma çıkmaz; altı motora taşımak kolay | Kutu kendi verisini tutamaz (örneğin "kaç kez yazdırıldı" sayacı kutuya konamaz, sınıfın alanı olmalıdır) |
| **B. Gerçek çoklu kalıtım** | Sınıfın birden çok **gerçek** ebeveyni olur; hem işlevlerini hem **verilerini** devralır | `CLASS AmfibiArac EXTENDS KaraAraci, SuAraci` | En güçlüsü; C++ ve Python bilenlere tanıdık | **"Elmas sorunu":** iki ebeveyn de aynı büyükbabadan (`Arac`) türemişse çocuğun içinde büyükbabanın verisinden (örneğin `hiz` alanı) bir mi, iki kopya mı olur? Çocuk `hiz`i kullanınca hangisi kastedilir? Kurucular hangi sırayla çalışır? `SUPER` hangi ebeveyni çağırır? Bu soruların kuralı yazılmalı ve **altı motor aynı cevabı vermeli**; JS ve WASM'da nesnenin bellekteki dizilişi farklı olduğundan en pahalısı budur |
| **C. Aşamalı (önerim)** | **Önce A** yapılır; sonra kutular kendi verilerini de taşıyabilsin diye genişletilir (durum taşıyan karışım); **B**'ye ancak bunlar altı motorda sınanıp oturunca geçilir | A'dan B'ye yürümek | Her adım ayrı sınanır; mevcut programlar bozulmaz; B'nin zor kuralları (elmas, kurucu sırası) A'nın deneyimiyle yazılır | İki aşama sürer |

**Neden C'yi önermiştim, B seçilince ne olur?** Riskli parçayı (B) temel taşlar sağlam olduktan sonra yapmak istiyordum. Mete B'yi seçti; bu yüzden uygulama planı B'yi **aşama aşama** teslim eder (M0: tek kalıtımı altı yolda eşitle, M1: ayrık hiyerarşilerde `EXTENDS A, B`, M2: elmas, M3: karışımlar). C'nin güvenli yanı B'nin içinde kalır. Doğrudan tek adımda B, altı motoru birden riske atardı.

Hangisi seçilirse seçilsin ön koşullar aynıdır: taban kurucu zinciri (G-NESNE-25, G-NESNE-27), `ABSTRACT`/`FINAL` (G-NESNE-6), `THIS`/`ME` ayrımı (G-NESNE-24; uygulandı) ve altı motorda eşlik.

## 11.13 Yeni OOP tasarım belgeleri ve kaynak denetimi (2026-10-16)

Mete iki belge verdi ve «incele, kılavuza işle, bulduğun sorunları plan yaparak çözmeye başla» dedi: **`UXB OPP SISTEMI TASARIM VE TARTISMALARI.md`** (Mete'nin tasarım konuşması: çoklu kalıtım, `THIS`/`ME`/`SUPER[Taban]`, karışımlar, motorlara indirgeme, eksik ve deneysel özellikler) ve **`uXBasic_OOP_Tam_Sistem_Denetimi_2026-10-16.md`** (kaynak denetimi: bulgular K-01 … K-12, iş sırası P0 … P3). Denetim derleyiciyi çalıştırmadan, kaynak paketini okuyarak yapılmıştı; bu bölümdeki her satır ise **gerçek derleyicide altı yolda denendi** (123 küçük program; düzeltme turunda eklenen `THIS`/`ME`, kurucu zinciri, boş gövde ve `FUNCTION` sonucu vakalarıyla birlikte; vakalar `tools/kitap/kilavuz_v2/yoklama/iddia_oop_20261016/`, ham sonuçlar `docs/kitaplar/_ortak/oop_partisi_20261016/`). İş planı: `ai_koordinasyon/OOP_DUZELTME_PLANI_20261016.md`. Yeni kayıtlar S-570 … S-599.

### 11.13.1 Denetim bulguları gerçekte nasıl çıktı?

| Bulgu | Denetimin iddiası | Altı yolda ölçüm (`20261014_0253`) | Kayıt |
|---|---|---|---|
| K-01 MIR `DELETE_OBJECT` | yalnız olay yazıyor, nesneyi öldürmüyor | ✔ doğru; ama asıl durum daha derin: **`DELETE` komutu o işlemi hiç üretmiyor** (statik yıkıcı zinciri + «değişken = 0»), ve **MIR boş başvuruyu (`0`) programın ilk nesnesine çözüyor**: boş değişkenden okumak başka nesnenin alanını verir, yazmak onu bozar (yeni bulgu) | G-NESNE-37 (S-570), G-NESNE-20 |
| K-02 JS silinmiş nesne | `fieldLoad/fieldStore` canlılık sormuyor | ✔ doğru (`undefined`); `DELETE` hiç `objectDelete` çağırmadığından `__uxbDeleted` hiç ayarlanmıyor | G-JS-16 (S-573), G-HEDEF-31 |
| K-03 `THIS`/`ME` ayrımı yok | MIR ikisini de sanal seçiyor | ✔ ve daha kötü: AST ikisini de **doğrudan**, MIR/x64/JS/eski AST-x64 ikisini de **sanal** çağırır (üç seviyede `100` ↔ `300`). **Kaynakta düzeltildi:** altı yolda `THIS` doğrudan, `ME` sanal | G-NESNE-24, G-NESNE-46 |
| K-04 sınıf metodunda aşırı yükleme yok | aynı ad üye reddi | ✔ `CLASS: duplicate member name: F`, altı yolda aynı açık ret | G-NESNE-16, G-NESNE-35 |
| K-05 WASM nesne modeli | eksik özellikler **açıkça** reddediliyor | ◐ metin ve ondalık açıkça reddedilir; ama **nesne alanları sessizce `0`** idi — kök neden bulundu (üç yerde yanlış operand tabanı) ve düzeltildi | G-WASM-26 (S-575), G-WASM-1 |
| K-06 `MemoryRef` | ham adresleri eksik izliyor | ✔ ölçüldü: 4096 canlı bölgeden sonra koruma **sessizce kapanır** (4200 dizide bayat işaretçi `11` okur, çıkış 0) | G-TIP-32 |
| K-07 parametreli taban kurucusu | `SUPER(...)` yok | ✔ beş ayrı davranış; `SUPER(5)` WASM ve eski AST-x64'te sessizce yok sayılır | G-NESNE-25, G-NESNE-27 |
| K-08 `UXClazz` profilleri | yalnız üstveri | ✔ (`CLAZZ ACTOR` düz `CLASS` üretir) | G-ARAC-3, G-HEDEF-36 |
| K-09 `MIXIN`/`DECORATOR` | en çok bir karışım | ✔ tek karışım çalışır, iki karışım ve `EXTENDS`'li karışım açık ret | G-HEDEF-39 |
| K-10 JS argümanlar | kurucu argümanları paylaşılıyor | ✔ ve **metot argümanları JS'te tümden düşüyordu** (yeni bulgu) | G-JS-15 (S-571) |
| K-12 yığıt ölçeği | `ReDim Preserve` her ayırmada | ✔ MIR'de 64 000 nesne 60 sn (aşırı doğrusal); AST doğrusal | G-HIZ-4 |
| «`tests/oop_parity` yok» | paketlerde yok | bizde var: 126/126 geçiyordu; ama boş başvuru testleri hiç nesne yaratmadığından G-NESNE-37'yi yakalamıyordu | — |

**Ders:** «Reddetme testi geçiyor» demek özelliğin çalıştığını kanıtlamaz. `neg_null_*` testleri programın ilk ve tek nesnesi olmadan sınadığı için MIR'in sessiz bozulmasını yıllarca göstermedi; yeni testler (`null_read_after_alloc`, `null_write_after_alloc`) önce başka bir nesne yaratır.

### 11.13.2 Tasarım belgesindeki örnekler altı yolda

| Örnek (belgeden) | Sonuç | Neden | Kayıt |
|---|---|---|---|
| `Nokta` + `IF p = NOTHING` | ✖ derlenmez: `unknown symbol: nothing` | `NULL`/`NOTHING` yok (Mete kararı: çalışacak) | S-564 |
| `BankaHesabi` (F64, `PRIVATE`, `ParaYatira`) | AST, MIR, x64 `150`; **JS `100`**; **eski AST-x64 `50`**; WASM ondalık reddi | JS: metot argümanı düşer; eski AST-x64: F64 kurucu parametresi çöp | G-JS-15, G-NESNE-44, G-WASM-7 |
| `Sekil` / `Kare` / `IYazdirilabilir` (F64) | AST, MIR, JS `25`; **x64 ve eski AST-x64 `0`**; WASM ondalık reddi | x64: iki F64 alan çarpımı (`kenar * kenar`) | G-NESNE-43 |
| `Vektor2D` + `MAGIC ADD`, `TOSTRING`; `DIM v3 AS Vektor2D = v1 + v2` | ✖ `DIM class initializer must be NEW` (altı yol); `DIM v3 …` sonra `v3 = v1 + v2` ✔ (tamsayılı sürümle AST, MIR, x64, JS, eski AST-x64 `6`, `4`) | `DIM` başlangıcı yalnız `NEW` | G-NESNE-45 |
| `Ogrenci`: `PROPERTY Puan AS I32 … GET … END GET SET(v) … END SET` | ✖ `PROPERTY SET: unexpected trailing tokens near OP('(')` | `PROPERTY` blok biçimi yok; kısa biçim çalışır | G-HEDEF-3 |
| `Arac.Sür()`, `Yüz()` (Türkçe harfli ad) | ✖ `Lexer diagnostic bridge hata buldu: 4` | tanımlayıcıda Türkçe harf yok; ileti nedeni söylemez | G-DIL-19 |
| `ANDALSO` | ✔ AST, MIR, x64, JS ve eski AST-x64'te çalışır; WASM'da karşılaştırma sonucu `1` (öbürlerinde `-1`) | `IF` içinde fark görünmez | G-WASM-18 |
| `CLASS AmfibiArac EXTENDS KaraAraci, SuAraci` | ✖ ayrıştırma hatası | çoklu kalıtım yok; karar B | G-NESNE-30, G-HEDEF-40 |
| `SUPER[KaraAraci](t)` | ✖ `statement parse failed near OP('[')` | `SUPER[Taban]` yok | G-HEDEF-40 |
| `CLASS Rapor EXTENDS Belge MIXIN A, B`; `MIXIN … END MIXIN` | ✖ `MIXIN currently supports single-base model` / `CALL: missing (` | tek `MIXIN` sınırı | G-HEDEF-39 |
| `THIS.Value() * 100 + ME.Value()` (`1020`) | ✔ **kaynakta düzeltildi:** altı yolda `1020` (ölçüm ikilisinde AST `1010`, öbürleri `2020`) | `THIS`/`ME` ayrımı uygulandı | G-NESNE-24 |
| `CLASS Depo<T>` | ✖ `CLASS: field identifier expected near OP('<')` | jenerik sınıf yok | G-HEDEF-4 |
| `s IS Kare`, `s AS Kare` | ✖ `missing THEN near KEYWORD('IS')` | `IS`/`AS` yok; `INSTANCEOF` yalnız AST | G-HEDEF-32, G-NESNE-36 |
| `CASE IS k AS Sekil` | ✖ `CASE IS: relational operator expected` | desen eşleme yok | G-HEDEF-33 |
| `USING f AS Akis = NEW Akis() … END USING` | ✖ `USING: unexpected trailing tokens near KEYWORD('AS')` | `USING` bugün **ad uzayı içe aktarımıdır**; RAII bloğu aynı sözcüğü ister | G-HEDEF-34 |
| `ACTOR CLASS`; `CLASS DATA_PARALLEL`; `BORROWED n AS Nokta` | ✖ ayrıştırma hataları | deneysel öneriler | G-HEDEF-36, G-HEDEF-37, G-HEDEF-38 |
| `IMPLEMENTS` yazmadan arayüze sınıf vermek (yapısal arayüz) | AST, MIR `4`; x64, JS, WASM, eski AST-x64 derleme ya da çalışma anı hatası | anlamsal denetim `IMPLEMENTS`'e bakmıyor | G-NESNE-41, G-HEDEF-35 |

### 11.13.3 Çoklu kalıtım (B) ve çakışma denetimi: kısa özet

Mete (2026-10-16): «B ile devam» ve «aynı isimde iki metot varsa çakışma olabilir; miras alan sınıf bazı anahtar kelimelerle metotların birleştirilmesini durduramaz mı?» **Cevap: evet.** İlke: **derleyici aynı adlı iki üyeyi asla sessizce birleştirmez.** Çakışma varsa program derlenmez (`UXB_AMBIGUOUS_MEMBER`); miras alan sınıf kararını **yazar**:

| Cümle | Anlamı |
|---|---|
| `OVERRIDE METHOD Sur() … END METHOD` | kendi metodunu yazar; iki tabanınkine `SUPER[Taban].Sur()` ile ulaşır |
| `PREFER KaraAraci.Sur` | `Sur` adı KaraAraci'nın metodudur; öbürü bu sınıfın yüzeyinde görünmez |
| `RENAME SuAraci.Sur AS SuSur` | sudaki metot yeni adıyla kalır; ikisi de kullanılabilir |
| `EXCLUDE SuAraci.Sur` | tabanın o üyesi bu sınıfa alınmaz |

```basic
CLASS Amfibi EXTENDS KaraAraci, SuAraci     ' ◇ HEDEF: bugün çalışmaz
    PUBLIC
    RENAME SuAraci.Sur AS SuSur              ' Sur() karadaki, SuSur() sudaki
END CLASS
```

`PREFER/RENAME/EXCLUDE` **bağlamsal sözcüklerdir** (yalnız sınıf gövdesinde satır başında anlam taşırlar); yeni ayrılmış sözcük oluşturmazlar. Ortak taban (elmas) bir kez saklanır; ortak tabandaki metodu yalnız bir kol geçersiz kıldıysa o kol kazanır (çakışma yok). Taban kurucusu parametre istiyorsa `SUPER[Taban](...)` yazılmalıdır (yoksa `UXB_BASE_CTOR_REQUIRED`). Uygulama aşamaları: M0 tek kalıtımı altı yolda eşitle → M1 ayrık hiyerarşilerde `EXTENDS A, B` → M2 elmas → M3 karışımlar (G-HEDEF-39). Kabul testleri T1 … T20 ve tüm kurallar: `docs/tasarim/UXB_S555_COKLU_KALITIM_B_VE_CAKISMA_DENETIMI_20261016_TR.md`. Kayıtlar: G-NESNE-30 (S-555), G-HEDEF-40 (S-595).

### 11.13.4 Bu turda kaynakta düzeltilenler

On sekiz hızlı ve yerel düzeltme (ve bir kısmi düzeltme) yapıldı, her biri `tests/oop_parity` içine eklenen testle altı yolda doğrulandı. **Bu kılavuzun ölçüm ikilisi `20261014_0253` olduğundan, yukarıdaki sütunlar o ikiliyi gösterir; düzeltmeler yeni ikilide (`bin\uxb_oop1024.exe`) geçerlidir ve kılavuz bu ikiliyle yeniden ölçülene kadar «düzeltildi» olarak anılır.**

| Kayıt | Düzeltilen | Nasıl |
|---|---|---|
| G-NESNE-37 (S-570) | MIR'de boş başvuru ilk nesneye düşüyor | boş başvuru artık tutamaçsız (`-1`); alan okuma ve yazma önce canlılığı sınar |
| G-JS-15 (S-571) | JS'te metot argümanları düşüyor | argümanlar tek dizi olarak geçirilir; `banka_hesabi`, `arayuz_coklu` doğru çıktı verir (G-JS-3, G-JS-13 de bununla kapanır) |
| G-NESNE-38 (S-572) | `ABSTRACT/FINAL/SEALED CLASS` ayrıştırılamıyor | sözcük çözümleyici sonraki sözcüğü kimliğe indiriyordu; dağıtıcı artık metne göre eşler; soyut tipli değişkeni reddeden yanlış denetim kaldırıldı |
| G-JS-16 (S-573) | JS'te boş nesneden alan okuma sessiz | artık hata, ileti ortak ifadeyi taşır |
| G-WASM-26 (S-575) | WASM'da nesne alanları `0`, kurucu ve sanal çağrı argümanları kayıp | üç yerde operand tabanı düzeltildi (`OBJECT_NEW`, `FIELD_STORE`, sanal çağrı) |
| G-NESNE-43 (S-580) | x64'te iki F64 alanın birlikte okunması (`k * k`) `0`/çöp | üye okumasına kayan nokta türü verildi; `FADD/FMUL` seçilir |
| G-NESNE-44 (S-581) | Eski AST-x64'te F64 kurucu parametresi çöp | `NEW` argümanları xmm yazmacına yüklenir |
| G-NESNE-45 (S-584) | `DIM x AS Sinif = ifade` reddi | yalnız `NEW`'ı sınayan kural kaldırıldı; tür adım-3 geçidinde sınanır; AST'nin çalışma sınıfı nesne başlığından okunur |
| G-WASM-27 (S-586) | WASM'da `ME`/`SUPER` geçersiz WAT | `ME` ve `SUPER` alıcıyı (`THIS`) gösterir |
| G-NESNE-41 (S-577) | `IMPLEMENTS` yazmamış sınıf arayüz parametresine verilebiliyor; altı yol ayrışıyor | düz adlı `SUB`/`FUNCTION` çağrısında argümanın sınıfı arayüzü gerçeklemiyorsa derleme hatası (`does not implement INTERFACE`) |
| G-TIP-32 (S-582) | 4096'dan fazla canlı dizide `MemoryRef` koruması sessizce kapanıyor | tablo büyür (65536'ya kadar); dolarsa bilinmeyen adrese NATIVE erişim reddedilir |
| G-HIZ-4 (S-583) | MIR'de nesne ayırma süresi nesne sayısıyla artıyor | yuva tablosu ikiye katlanır (her ayırmada kopya yok); boşta makinede 64 000 nesne 50,6 sn → 33,8 sn, nesne başına süre sabit |
| G-NESNE-24 (S-484) | `THIS`/`ME`/niteliksiz çağrı ayrımı yok: AST üçünü doğrudan, öbürleri üçünü sanal çağırıyor | `THIS.m()` doğrudan, `ME.m()` ve niteliksiz `m()` sanal: örtük `THIS` dönüşümü niteliksiz çağrıyı `ME` yapar; MIR üretimi `THIS` alıcısında sanal yuvaya bakmaz; eski AST-x64 `THIS`'te sanal yuva aramaz |
| G-NESNE-46 (S-596) | AST sanal çağrıyı `SUB` parametresinde ve `ME`'de bildirilen sınıfa göre dağıtıyor | alıcı sınıfı nesne başlığından okunur (sanal dağıtım); sanal olmayan bağlama bildirilen sınıfla; `THIS` doğrudan |
| G-NESNE-40 (S-576) | Kurucu kuralı yalnız `ME.` önekini yakalıyor (sanal olmayanı da reddediyor); `THIS.`/niteliksiz çağrı delik, MIR kurucuda sessiz | kural kurucu **ve yıkıcıda** yalnız **sanal** hedefli `ME`/niteliksiz çağrıyı reddeder; `THIS.m()` ve sanal olmayan çağrı serbest |
| G-NESNE-25 (S-485, kısmen) | Türetilmiş sınıfın kendi kurucusu yoksa MIR taban kurucusunu çalıştırmıyor | zincir kurucusu olmayan sınıfları atlar, kalanları çalıştırır (parametreli taban ve `SUPER(...)` hâlâ açık) |
| G-YORDAM-11 (S-597) | Gövdesi boş rutin: AST çöküyor, MIR/x64/JS çağrıyı bulamıyor, eski AST-x64 derlemiyor | `And` → `AndAlso` (AST); boş `SUB`/`FUNCTION`/sınıf rutini MIR ve eski AST-x64'te de üretilir |
| G-JS-17 (S-598) | JS'te hiç yazılmamış alan `undefined` / `nan` | `fieldLoad` türün sıfır değerini döndürür (metin için `""`) |
| G-YORDAM-12 (S-599) | Sonucu atanmayan `FUNCTION`/`METHOD`: x64 çöp, JS `undefined`, WASM derlenmez, eski AST-x64 son değer; `F = değer` ardından başka deyim varsa eski AST-x64 yanlış | sonuç değişkeni girişte türün sıfırıyla başlar (MIR üretimi); eski AST-x64'te işlev adını taşıyan çerçeve yuvası |

Çözülmeyen ve sıradaki işler (öncelik sırasıyla): nesne yaşam döngüsü (G-HEDEF-31: `DELETE` sözleşmesi, ölü işareti, gerçek türe göre yıkıcı), parametreli taban kurucusu ve `SUPER(...)` (G-NESNE-25, G-NESNE-27), eski AST-x64'te arayüz tipli parametre (G-NESNE-42) ve `NAMESPACE`/`USING` (G-MODUL-8), Türkçe tanımlayıcı (G-DIL-19), sonra `IS`/`AS`, desen eşleme, `USING` kaynak kapsamı ve çoklu kalıtım. Deneysel öneriler (yapısal arayüz, `ACTOR CLASS`, `DATA_PARALLEL`, `OWNED`/`BORROWED`) Mete'nin kararını bekler.
