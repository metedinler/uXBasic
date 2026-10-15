# 11. Nesne yönelimli programlama

**Nesne yönelimli programlama**, veriyi (alanlar) ve o veriyle çalışan kodu (metotlar) **sınıf** adı altında birleştirir. Sınıftan üretilen somut örneğe **nesne** denir.

## 11.1 Hızlı bakış

| Kavram | Anahtar sözcük | Ne işe yarar? | Durum |
|---|---|---|---|
| Sınıf | `CLASS` ... `END CLASS` | Alan + metot topluluğu | ✔ |
| Nesne oluşturma / silme | `NEW`, `DELETE` | Belleğe nesne ayırır / yıkıcıyı çalıştırır | ✔ |
| Kurucu / yıkıcı | `CONSTRUCTOR`, `DESTRUCTOR` | Başlangıç ve temizlik kodu | ◐ Tek sınıfta ✔ (yıkıcı `DELETE` ile çalışır; sayısı motora göre değişir: ✖ G-NESNE-23). **Kalıtımda taban kurucusu AST ve MIR'de çalışmaz** (✖ FARK, G-NESNE-25) |
| Metot | `METHOD` ... `END METHOD` | Sınıfın işlevi | ✔ |
| Kendine başvuru | `THIS`, `ME` | Geçerli nesne | ◐ Dışarıdan ✔; taban sınıf metodunun içinden sanal çağrıda **motorlar farklı** (✖ FARK, G-NESNE-24) |
| Erişim belirteci | `PUBLIC`, `PRIVATE`, `PROTECTED` | Üyenin kimler tarafından kullanılacağı | ◐ (metotta denetlenir, alanda **denetlenmez**) |
| Kalıtım | `EXTENDS` | Başka sınıfın üyelerini devralma | ✔ |
| Sanal metot | `VIRTUAL`, `OVERRIDE` | Çalışma anında gerçek sınıfın metodunu seçme | ✔ |
| Üst sınıf çağrısı | `SUPER.Metot()` | Devralınan metodu çağırma | ✔ (`BASE` yoktur; tabana kurucu çağrısı `SUPER(...)` da yoktur: ✖ G-NESNE-27) |
| Arayüz | `INTERFACE`, `IMPLEMENTS` | Uyulması gereken metot sözleşmesi | ✔ |
| Özellik | `PROPERTY ad AS tip GET SET` | Alan gibi görünen okuma/yazma | ◐ (yalnız kısa biçim) |
| Sihirli metot | `MAGIC ... END MAGIC` | Özel davranışlar: işleç, `TOSTRING` | ✔ |
| Soyut / son / mühürlü | `ABSTRACT`, `FINAL`, `SEALED` | Sınıf nitelikleri | ✖ Parser'da yok (G-NESNE-6) |
| Değişmezlik niteleyicileri | `READONLY`, `IMMUTABLE` (alana yazma zorlanır: AST'de çalışma anı, MIR ve x64'te derleme hatası), `MUTABLE` | Alanın değişip değişmeyeceği | ✔ |
| Erişim bölümleri | `RESTRICTED`, `FRIEND liste` | `RESTRICTED` bölümü kabul edilir ama yalnız AST'de metot çağrısında zorlanır; `FRIEND` bir arkadaş listesi ister ve `PUBLIC` bölümünde yazılamaz | ◐ FARK (G-NESNE-19) |
| Statik üye | `STATIC` | Nesnesiz üye | ✖ Motorlar farklı (G-NESNE-1) |
| Karışım | `MIXIN` | Kod paylaşımı | ✖ Yok (G-NESNE-6) |
| Çoklu kalıtım | `EXTENDS A, B` | Birden çok tabandan devralma | ✖ Yok; 15 Eylül tasarımı bilerek dışarıda bırakmıştı, **Mete'nin 2026-10-15 kararıyla istenir**, ayrıntılar karar bekliyor (G-NESNE-30, 11.12) |
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

* `DIM d AS Sinif = NEW Sinif(...)` ile oluşturulur. **`DIM` satırında başlangıç değeri `NEW` olmak zorundadır**; farklı bir nesne atamak için ayrı satır yazılır.
* **Sınıf adı ve değişken adı aynı ad uzayındadır**: `CLASS K` varken `DIM k AS K` yazılamaz. Derleyici `variable K conflicts with CLASS K` der. Değişkene farklı ad verin.
* Boş bırakılan nesne değişkenine (`DIM k AS Kutu`) alan erişimi **çalışma anı hatasıdır**: `field access on a null object reference` (üç yerel motorda aynı; **JS'te alan okuma hata vermez**, `undefined` yazdırıp devam eder — G-HATA-6).
* Aynı sınıfta aynı adlı iki metot (aşırı yükleme) `duplicate member name` ile **reddedilir**.
* **Aynı sınıfın iki metodunda aynı adlı ama farklı tipli parametre** geçerli programı reddettirir (G-NESNE-16): `METHOD SetS(v AS STRING)` ve `METHOD SetF(v AS F64)` birlikte yazılırsa ikincide `v` hâlâ `STRING` sayılır (`assignment cannot convert TYPE_STRING to TYPE_F64`). Parametrelere farklı ad verin; farklı sınıflarda aynı ad sorun çıkarmaz.
* **Durumu metotla değiştiren sınıflar JS'te yanlış çalışır** (G-JS-13): metot içinde alana yazma (`deger = deger + d` ya da `THIS.deger = …`) `nan`/`undefined` üretir; yalnız kurucuda yazma ve dışarıdan `nesne.alan = …` çalışır.
* **Sınıfın `BOOLEAN` alanını `STR` ile yazdırmak AST'de `255` verir** (G-NESNE-17; MIR, x64 ve JS `-1`). Mantık değerini `IF alan THEN …` ile sınayın.
* **Sınıf alanı olarak başka bir sınıf, `TYPE` ya da dizi** kullanımının sınırları vardır: nesne alanı `0` okunur (G-NESNE-10), `TYPE` alanına metot içinden erişim MIR/JS'te yanlış, x64'te derlenmez (G-NESNE-11), dizi alanı metot içinde reddedilir (G-NESNE-12). Ayrıntı: Bölüm 22.4.

{{ORNEK:07_yapi/class_new|baslik=CLASS, NEW ve METHOD}}

{{ORNEK:07_yapi/constructor_destructor|baslik=Kurucu, yıkıcı ve DELETE}}

> **Nesneler otomatik yıkılmaz.** Bir yordam bitince onun yerel nesnelerinin yıkıcısı **çalışmaz** (dört motorda aynı); yıkıcıyı yalnız `DELETE` çalıştırır. Kaynak
> (dosya, bellek) tutan sınıflarda `DELETE`'i unutmayın. **Ama yıkıcının kaç kez çalışacağı motora göre değişir (✖ FARK, G-NESNE-23):** aynı değişkene iki kez `DELETE` yazarsanız AST yıkıcıyı bir kez, MIR, x64 ve JS iki kez çalıştırır; program sonunda `DELETE` edilmemiş genel nesneler için yalnız AST yıkıcıları (ters sırayla) çalıştırır. Her nesneyi tam bir kez `DELETE` edin.

> **`DELETE`'ten sonra değişkeni kullanmayın (✖ SESSİZ, G-NESNE-20).** `DELETE o` sonrasında `o.v` okumak AST ve x64'te "field access on a null object reference" hatasıyla durur; ama **MIR silinmiş nesnenin eski değerini okur** (`3`) ve JS `undefined` yazdırır. Silinen nesne değişkenini bir daha okumayın. Aynı nesneye **başka bir değişkenle** (`b = a`, sonra `DELETE a`) erişmek ise dört motorda da hata vermez ve nesne yıkıcısı çalışmış olduğu halde kullanılabilir kalır (✖ SESSİZ, G-NESNE-22).

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
| `VIRTUAL METHOD ... AS F64` x64'te | ✖ SINIR (G-NESNE-8): ondalıklı dönüş `0`/çöp çıkar; ondalıklı **alana tamsayı sabiti** (`d.en = 3`) yazmak da x64'te çöp üretir. Ondalıklı sabiti `3.0` yazın, sanal metot için tamsayı döndürün |
| `INSTANCEOF(nesne, Sinif)` | ✖ Yalnız AST'de |
| Nesne dizisi (`DIM d(1) AS Sinif`) | AST/MIR ✔; x64 `STORE_INDEXED element width unsupported: 16` ile reddeder |
| Yöntem zinciri (`RETURN THIS` ile kendi tipini döndürmek) | ✖ (G-NESNE-5): `explicit cast TYPE_OBJECT to ...` |
| Taban sınıfın kurucusu (`CLASS A` kurucusu `x = 5`, `CLASS B EXTENDS A`, `NEW B()`) | ✖ **FARK, SESSİZ (G-NESNE-25):** AST ve MIR taban kurucusunu **hiç çalıştırmaz** (`x` = `0`), x64 ve JS çalıştırır (`x` = `5`) ve `NEW`'a verilen argümanları tabana da geçirir. Yıkıcılar dört motorda türetilmişten tabana çalışır |
| `SUPER(değer)` ile tabana kurucu çağrısı | ✖ Yoktur (G-NESNE-27): AST `MAGIC_CALL missing`, MIR `RT_LIBRARY_CALL` bağlı değil, x64 derlemez, JS yürütme anında durur |
| Taban sınıf metodunun içinden sanal çağrı (`Value()`, `THIS.Value()`, `ME.Value()`) | ✖ **FARK (G-NESNE-24):** AST üçünde de taban uygulamasını (`10`), MIR, x64 ve JS türetilmiş geçersiz kılmayı (`20`) çağırır. Dışarıdan `c.Value()` dört motorda `20` verir |
| Taban tipli değişkenle `DELETE` (`DIM x AS A = NEW B()`, `DELETE x`) | ✖ **FARK (G-NESNE-26):** AST `B.dtor` ve `A.dtor` çalıştırır; MIR, x64 ve JS yalnız `A.dtor` çalıştırır, türetilmiş yıkıcı atlanır |
| Aynı adlı alanı taban ve türetilmiş sınıfta yinelemek; kurucuda `ME` ile sanal çağrı; parametreli tabanı `SUPER(...)` olmadan kurmak | ✖ SESSİZ (G-NESNE-28): hata vermez |
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
| `THIS` ve `ME` | İkisi de geçerli nesnedir. **Tasarımda ayrıdırlar** (`THIS` doğrudan, `ME` sanal çağırır; 11.10), bugün ayrılmazlar ve motorlar farklıdır: MIR, x64, JS ikisini de sanal, AST ikisini de doğrudan çağırır (✖ G-NESNE-24) |
| `SUPER` ve `BASE` | `SUPER` çalışır; `BASE` yoktur |
| `MAGIC` ve `METHOD` | `MAGIC` dilin tanıdığı özel davranışları bağlar (işleç, `STR`); `METHOD` sıradan metottur |
| `NEW`/`DELETE` ve kapsam çıkışı | Nesne yaşamı **elle** yönetilir; kapsam bitince yıkıcı çalışmaz. Yeniden atama (`a = NEW …`) eski nesneyi yıkmaz (dört motorda aynı) |

## 11.10 Tasarlanan OOP sözleşmesi (◇ HEDEF)

`docs/OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md` (2026-09-15), nesne yönelimli yüzeyi tek bir sözleşme altında toplayan bir **tasarım önerisidir** ("v1"). Belge, uygulandığı ya da motorların geçtiği iddiası olmadığını yazar; `THIS`'in doğrudan anlamı, `DELETE`/başvuru sayımı modeli, `MIXIN`'in trait'e geçişi ve `VALUE` profili gibi başlıkları da **ürün onayına** bırakır. Aşağıdakiler bu yüzden kesin karar değil ◇ HEDEF'tir (G-HEDEF-4, G-HEDEF-25); "Bugün" sütunları bu kılavuzun hazırlığında ölçülenleri gösterir.

### `THIS`, `ME` ve `SUPER`: görev ayrımı

| Biçim | Tasarlanan anlam | Metot çağrısı |
|---|---|---|
| `THIS` | Bu metodun gövdesini yazan sınıfın uygulama görünümü | **Doğrudan**; sanal yuvayı yeniden dağıtmaz |
| `ME` | Aynı nesnenin çok biçimli davranışı | Sanal ya da arayüz yuvası varsa **gerçek nesne türüne göre**; sıradan metotta doğrudan |
| `SUPER` | Bu gövdenin sahibinin **doğrudan** tabanından başlayan uygulama | Doğrudan taban uygulaması; türetilmiş geçersiz kılmaya dönmez |

Üçü de aynı nesnenin kimliğini taşır; fark üye çözümlemesinde ve çağrı seçimindedir. Gövdedeki niteliksiz üye kullanımı `THIS` ile eşdeğerdir; dinamik niyet `ME` ile açık yazılır. Planın ayırt edici örneği:

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

Tasarıma göre sonuç **`1020`** olmalıdır: `THIS.Value()` taban uygulamasını (10), `ME.Value()` türetilmiş uygulamayı (20) çağırır. **Bugün** AST `1010`, MIR, x64 ve JS `2020` yazar (✖ FARK, G-NESNE-24): hiçbir motor ayrımı uygulamaz ve iki grup birbirinden de farklıdır. Ek kurallar (◇ HEDEF): `ME` dinamik üye araması değildir, yani taban sınıf kodu yalnız türetilmiş sınıftaki bir alana `ME` ile erişemez (bugün de reddedilir, ama iletisi yanıltıcıdır: `explicit cast TYPE_OBJECT to …`); `THIS` ve `ME` yeniden atanamaz (`THIS = NEW K()` bugün de reddedilir, ama iletisi yine yanıltıcıdır: `assignment requires explicit cast K to TYPE_OBJECT`); `SUPER` tek başına değer değildir (`x = SUPER` bugün aynı yanıltıcı iletiyle reddedilir); `STATIC` üyede üçü de yasaktır (bugün de `THIS/ME cannot be used in a STATIC class member` ile reddedilir); `THIS`/`ME` erişim denetimini aşmaz; kurucu ve yıkıcı içinden `ME` ile sanal çağrı yasaktır (bugün sessizce kabul edilir, G-NESNE-28). Yeni sözleşme **sürümlü** açılır; eski `THIS.Sanal()` kodunun davranışı değişeceğinden bir geçiş aracı eski kullanımları listeler.

### Türler, kimlik ve kopyalama

| Yapı | Tasarlanan sözleşme | Bugün |
|---|---|---|
| `TYPE` | Yönetilen değer kaydı; atama alan alan kopyalar; içindeki `CLASS` alanları başvuru olarak kopyalanır | Atama değer kopyasıdır (dört motor); `CLASS` alanı sınırları: G-NESNE-10 |
| `STRUCT … ABI C` | C yerleşimli kayıt; ham blok kopyası yalnız basit kopyalanabilir türlerde | Bölüm 10 |
| `UNION … ABI C` | Ortak bayt depolama; yönetilen başvuru reddedilir | Bölüm 10 (G-VERI-11) |
| `ENUM` | Adlandırılmış sabit kümesi; tamsayı taban türü; aralık doğrulaması; açık sayısal dönüşüm | Bölüm 10 |
| `CLASS` | Kimlikli başvuru nesnesi; atama başvuruyu paylaşır, kopyalamaz | Dört motorda ✔ |
| `INTERFACE` | Ayrı nesne oluşturmayan, kimlik + arayüz dağıtım görünümü | AST, MIR, x64 ✔; JS'te `nan` (G-JS-3) |

* Varsayılan eşitlik **kimlik eşitliğidir** (`a = b`, iki değişken aynı nesneyi gösteriyorsa `-1`; bugün dört motorda ✔). Değer eşitliği kullanıcı sözleşmesiyle gelir; `EQ` ve `HASH` birlikte tutarlı olmalı, eşit nesneler aynı özeti vermelidir.
* Kopyalama: `CloneShallow` ile `CloneDeep` ayrımı açık yazılır; derin kopya döngüleri ve ortak başvuruları koruyan bir ziyaret tablosu ister; yerel kaynaklar varsayılan olarak kopyalanamaz. Bugün ikisi de yoktur.
* `NULL` ile sarkan başvuru ayrılır; tür sınama ve **denetimli dönüştürme** (checked cast) tek sözleşmedir; başarısız daraltma sessiz sıfır ya da yanlış işaretçi üretmez. Bugün `INSTANCEOF` yalnız AST'dedir (11.4).

### Kalıtım, erişim ve metot

* 15 Eylül önerisi: bir sınıfın **tek uygulama tabanı** ve **çok arayüzü** vardır; çoklu durum kalıtımı yoktur (bugün de böyledir). **Bu madde 2026-10-15'te Mete'nin kararıyla değişti:** uXBasic nesne yönelimli paradigmayla doğduğu için OOP, çoklu kalıtım ve karışım dahil çok güçlü olmalıdır (G-NESNE-30, karar bekliyor; seçenekler 11.12'de).
* `OVERRIDE` yalnız var olan sanal yuvayla, aynı parametre / `BYREF` yönü ve dönüşle eşleşir (ilk sürümde dönüş tipi birebir; kovaryans sonradan). Bugün imza uyuşmazlığı ayrıştırmada reddedilir (`METHOD: OVERRIDE signature …`).
* `FINAL` sınıf türetilemez, `FINAL` metot geçersiz kılınamaz; `SEALED`, `FINAL CLASS`'ın belgelenmiş eşanlamlısıdır; `ABSTRACT` sınıf doğrudan oluşturulamaz ve soyut ya da arayüz yuvaları tamamlanmadan somut sınıf olmaz. **Bugün ayrıştırıcıda yoktur** (G-NESNE-6).
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
* Bugün: başvuru sayımı ve zayıf başvuru yoktur (yaşam **elle** yönetilir, 11.2); taban kurucusu AST ve MIR'de çalışmaz (G-NESNE-25); `SUPER(...)` yoktur (G-NESNE-27); taban tipli değişkenle `DELETE` MIR, x64 ve JS'te türetilmiş yıkıcıyı atlar (G-NESNE-26).

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

* **Kalıtımda taban sınıfın kurucusuna güvenmeyin** (G-NESNE-25, G-NESNE-27): AST ve MIR onu çalıştırmaz, x64 ve JS çalıştırır. Ortak başlatmayı bir `Baslat()` metoduna koyup `NEW`'dan sonra açıkça çağırın; parametreli kurucusu olan bir sınıftan türetmeyin (`SUPER(...)` yoktur).
* **Taban sınıf metodunun, türetilmiş sınıfın geçersiz kılmasını çağırmasına dayanan tasarım yazmayın** (G-NESNE-24): AST taban uygulamasını, öbür motorlar türetilmiş uygulamayı çağırır. Kurucuda sanal metot çağırmayın ve taban/türetilmiş sınıfta aynı alan adını yinelemeyin (G-NESNE-28).
* Nesneyi **yarattığınız sınıfın tipiyle** tutup `DELETE` edin: taban tipli değişkenle silmek türetilmiş yıkıcıyı üç motorda atlar (G-NESNE-26).

* **Veri ile davranış birlikteyse `CLASS`, yalnız veriyse `TYPE`** yazın. `TYPE` değer tipidir (atama kopyalar), `CLASS` referans tipidir (atama aynı nesneye ikinci ad verir).
* Nesneyi `DIM d AS Sinif = NEW Sinif(...)` ile üretin ve **değişken adını sınıf adından farklı** seçin (`CLASS Kutu` varken `DIM kutu1 AS Kutu`); aynı ad `variable K conflicts with CLASS K` hatası verir.
* **Her `NEW` için bir `DELETE` yazın.** Yıkıcı kapsam bitince çalışmaz, yalnız `DELETE` ile çalışır; dosya, bellek ya da tutamaç tutan sınıflarda temizliği unutmayın.
* Nesneyi kopyalamak için `b = a` yazmayın: aynı nesneye ikinci ad verir. Kopya gerekiyorsa **yeni nesne üretip alanları tek tek kopyalayın**.
* Alanları metotlarla yönetin, kuralları `THROW`/`ASSERT` ile koruyun; **`PRIVATE` alan erişimi dışarıdan denetlenmez** (G-NESNE-2), yani dilin sizi korumasına güvenmeyin.
* Çok biçimlilik için `VIRTUAL` + `OVERRIDE` kullanın; üst sınıf metodunu `SUPER.Ad()` ile çağırın (`BASE` yoktur). Ara sınıfın `OVERRIDE`'ını alt-alt sınıfta **yeniden yazın** (G-NESNE-7).
* Soyutluk gerektiğinde `INTERFACE` kullanın (`ABSTRACT`, `FINAL`, `SEALED`, `MIXIN` yoktur, G-NESNE-6). İşlev parametresini arayüz tipinde alırsanız bağımlılık tek yerde kalır; bir sınıf birden çok arayüz uygulayabilir.
* Nesneyi yazdırırken **her zaman `PRINT STR(n)`** yazın ve sınıfa `MAGIC TOSTRING()` ekleyin (G-NESNE-4); ama AST'de `MAGIC TOSTRING` tanımlı sınıfın sayısal dönüşlü metodunun sonucunu değişkene yazmayın (✖ G-NESNE-29, geçici çözüm yoktur: sonucu doğrudan `PRINT` edin ya da programı MIR, x64 ya da JS ile çalıştırın). İşleç sonucunu hemen kullanın; ardışık saklama ya da `a = a * b` zinciri AST'de yanlış olabilir (G-NESNE-9).
* x64'e derleyecekseniz **sanal metottan ondalıklı değer döndürmeyin** ve ondalıklı alana tamsayı sabiti yazmayın (`3.0` yazın): sonuç çöp çıkar (G-NESNE-8). Nesne dizisi (`DIM d(n) AS Sinif`) x64'te derlenmez; bu hedefte nesneleri ayrı değişkenlerde tutun.
* `RETURN THIS` ile yöntem zinciri kurmayın (G-NESNE-5); `STATIC` üyeye güvenmeyin, motorlar farklı davranır (G-NESNE-1).
* `PROPERTY` yalnız kısa biçimde (`PROPERTY Ad AS tip GET SET`) kullanın; yalnız okunur (`GET`) özelliğe yazmak AST'de reddedilir ama MIR ve x64'te sessizce çalışır (G-NESNE-3).

## 11.12 OOP'de neler eksik? (2026-10-15 denetimi)

Mete (2026-10-15): uXBasic nesne yönelimli programlama paradigmasıyla doğdu; OOP sistemi çok güçlü ve farklı kullanımlara açık olmalı. Aşağıdaki tablo, 15 Eylül tasarımına (11.10) ve altı yolda ölçüme (`20261014_0253`) göre yetenek yetenek durumu gösterir.

| Yetenek | Durum | Kayıt |
|---|---|---|
| Tek tabanlı kalıtım, `VIRTUAL`/`OVERRIDE`, `SUPER.Ad()` | ✔ (sınırlar 11.4'te) | G-NESNE-7, G-NESNE-24, G-NESNE-25 |
| Çok arayüz (`IMPLEMENTS IA, IB`) | ✔ AST, MIR, x64; JS ≠, WASM ≠ | G-JS-3 |
| **Çoklu kalıtım** (`EXTENDS A, B`) | ✖ ayrıştırma hatası; tasarım kararı değişti | G-NESNE-30 |
| **Karışım / trait** (`MIXIN`) | ✖ tanınır ama ayrıştırılmaz; tasarımda açık trait bileşimi olarak ◇ HEDEF | G-NESNE-6, G-HEDEF-4 |
| `USES` bileşimi, jenerik sınıf, `DECORATOR` | ✖ ◇ HEDEF | G-HEDEF-4, G-HEDEF-25 |
| `ABSTRACT`, `FINAL`, `SEALED` | ✖ ayrıştırıcıda yok | G-NESNE-6 |
| Arayüz mirası (`INTERFACE IB EXTENDS IA`) | ✖ ayrıştırma hatası | G-NESNE-31 |
| Arayüzde gövdeli (varsayılan) metot | ✖ ayrıştırma hatası | G-NESNE-34 |
| Taban kurucu zinciri, `SUPER(...)` | ✖ AST ve MIR taban kurucusunu çalıştırmaz; `SUPER(...)` yok (WASM ve eski AST-x64 sessizce `0` yazar) | G-NESNE-25, G-NESNE-27 |
| Kurucu aşırı yükleme (birden çok `CONSTRUCTOR`) | ✖ ayrıştırma hatası | G-NESNE-35 |
| Metot aşırı yükleme | ✖ AST `duplicate routine`; MIR ve JS yanlış sonuç; x64 derlemez | G-YORDAM-1 |
| İç içe sınıf | ✖ ayrıştırma hatası | G-NESNE-32 |
| Sınıf sabiti (sınıf içinde `CONST`) | ✖ ayrıştırma hatası | G-NESNE-33 |
| `STATIC` üye | ◐ motorlara göre değişir | G-NESNE-1 |
| Tür sınama `INSTANCEOF(nesne, Sinif)` | ◐ yalnız AST (`-1`) | G-NESNE-36 |
| Boş nesne / boş başvuru (`NULL`, `NOTHING`) | ✖ yüzeyde yok | G-TIP-31 |
| Alan erişim denetimi | ✖ metotta denetlenir, alanda denetlenmez | G-NESNE-2 |
| `PROPERTY` blok biçimi | ✖ ◇ HEDEF | G-HEDEF-3 |
| Zayıf başvuru, başvuru sayımı, kapsam çıkışında yıkıcı | ✖ ◇ HEDEF (yaşam elle yönetilir) | G-HEDEF-25 |
| İşleç yükleme (`MAGIC ADD` …) | ✔ AST, MIR, x64, JS; WASM ≠ | G-NESNE-9, G-NESNE-15 |
| İşlev değeri / geri çağrı (`FUNCTION_PTR`), lambda | ✖ ◇ HEDEF | G-TIP-8, G-HEDEF-26 |

### Çoklu kalıtım için tasarım seçenekleri (karar bekliyor, S-555)

| Seçenek | Ne olur? | Artısı | Eksisi |
|---|---|---|---|
| **A. Durumsuz karışım** | Tek durum tabanı + çok `MIXIN`/trait (alan taşımaz) + çok arayüz | Elmas sorunu yoktur; altı motora taşımak kolay | Alan paylaşan karışım yazılamaz |
| **B. Gerçek çoklu durum kalıtımı** | `EXTENDS A, B`: alanlar tabanların sırasıyla art arda yerleşir; kurucular soldan sağa çalışır; aynı tabanı iki yoldan almak hata (ya da C3 doğrusallaştırması) | En güçlü; C++ ve Python bilenlere tanıdık | Alan yerleşimi, `SUPER` çözümü ve JS/WASM taşıması pahalı |
| **C. Aşamalı (önerim)** | Önce durum taşıyabilen `MIXIN` (açık çakışma çözümüyle), sonra B | Her aşama sınanır, geriye dönük bozulma olmaz | İki aşama sürer |

Hangisi seçilirse seçilsin ön koşullar aynıdır: taban kurucu zinciri (G-NESNE-25, G-NESNE-27), `ABSTRACT`/`FINAL` (G-NESNE-6), `THIS`/`ME` ayrımı (G-NESNE-24) ve altı motorda eşlik.
