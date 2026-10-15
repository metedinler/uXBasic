# 6. İşleçler

**İşleç**, değerleri birleştirip yeni bir değer üreten işaret ya da sözcüktür. Bu bölümdeki her işleç, derleyicinin kayıt defterindeki
(`uxb_surface_registry.fbs`, 71 öğe) listeyle karşılaştırılıp çalıştırılarak sınanmıştır; **aksi söylenmedikçe AST, MIR ve x64'te aynı sonucu verir**.

## 6.1 Aritmetik işleçler

| İşleç | Anlamı | Örnek | Sonuç | Not |
|---|---|---|---|---|
| `+` | Toplama (ve metin birleştirme) | `7 + 2` | 9 | Metinde `"a" + "b"` = `ab` |
| `-` | Çıkarma / olumsuzlama | `7 - 2`, `-(7)` | 5, -7 | |
| `*` | Çarpma | `7 * 2` | 14 | |
| `/` | **Ondalıklı** bölme | `7 / 2` | 3.5 | Sonuç her zaman ondalıklı |
| `\` | **Tamsayı** bölme | `7 \ 2`, `-7 \ 2` | 3, -3 | Sıfıra doğru keser |
| `MOD`, `%` | Bölümden kalan | `7 MOD 2`, `-7 MOD 3` | 1, -1 | Kalanın işareti bölünenin işaretidir; ondalık işlenenler **yuvarlanarak** tamsayıya çevrilir (`7.5 MOD 2` = 0 çünkü 7.5 → 8; `7.4 MOD 2` = 1; dört motorda aynı) |
| `**` | Üs alma | `2 ** 10` | 1024 | Sağdan sola: `2 ** 3 ** 2` = 512 |
| `^` | **XOR (üs değil!)** | `2 ^ 3` | 1 | Üs için `**` kullanılır |

> **Dikkat:** `-2 ** 2` sonucu `4`'tür (olumsuzlama `**`'dan önce bağlanır). Niyetiniz `-(2 ** 2)` ise parantezle yazın.

## 6.2 Karşılaştırma işleçleri

Sonuç doğruysa **-1** (`TRUE`), yanlışsa **0**'dır (`BOOLEAN` değil, tamsayı).

| İşleç | Anlamı | Not |
|---|---|---|
| `=` ve `==` | Eşit | Atama bağlamında `=` atamadır; koşul içinde ikisi de karşılaştırır. **Yeni kodda koşullarda `==` önerilir.** |
| `<>` ve `!=` | Eşit değil | İkisi aynı |
| `<`, `<=`, `>`, `>=` | Küçük, küçük-eşit, büyük, büyük-eşit | Metinler sözlük sırasına göre karşılaştırılır (`"abc" < "abd"` = -1) |

{{ORNEK:13_operator/karsilastirma|baslik=Karşılaştırmalar}}

## 6.3 Mantık ve bit işleçleri

Aynı işleçler tamsayılar üzerinde **bit düzeyinde** çalışır. `TRUE` = -1 (bütün bitler 1) olduğu için mantıksal kullanım da doğal çıkar.

| İşleç | Anlamı | `5` ve `3` için |
|---|---|---|
| `AND`, `&` | Bit VE | 1 |
| `OR`, `\|` | Bit VEYA | 7 |
| `XOR`, `^` | Dışlayan VEYA | 6 |
| `NOT`, `~` | Bit DEĞİL (her bit ters) | `NOT 5` = -6 |
| `!` | **Mantıksal** DEĞİL (sıfır mı?) | `!5` = 0, `!0` = -1 (değişkenle x64, JS ve WASM'da derlenmez, G-ISLEC-3) |
| `&&`, `\|\|` | **Mantıksal** VE / VEYA (sonuç -1 ya da 0) | `5 && 3` = -1, `5 \|\| 0` = -1 |
| `ANDALSO`, `ORELSE` | **Kısa devreli** mantıksal VE / VEYA | Sol taraf sonucu belirlerse sağ taraf hiç hesaplanmaz |

{{ORNEK:13_operator/kisa_devre|baslik=Kısa devre: sıfıra bölmeyi önlemek}}

### Genişletilmiş mantık ailesi

uXBasic, iki girişli bütün mantık kapılarını işleç olarak sunar. Aşağıdaki sonuçlar `a = 5` (`0101`) ve `b = 3` (`0011`) içindir:

| İşleç | Karşılığı | Sonuç | İşleç | Karşılığı | Sonuç |
|---|---|---|---|---|---|
| `NAND` | `NOT (a AND b)` | -2 | `NIMP` | `a AND NOT b` | 4 |
| `NOR` | `NOT (a OR b)` | -8 | `NCIMP` | `b AND NOT a` | 2 |
| `XNOR`, `NXOR`, `EQV`, `EQA`, `IFF` | `NOT (a XOR b)` | -7 | `IDA` | `a` | 5 |
| `IMP` | `(NOT a) OR b` | -5 | `IDB` | `b` | 3 |
| `CIMP` | `(NOT b) OR a` | -3 | `NOTA` / `NOTB` | `NOT a` / `NOT b` | -6 / -4 |

{{ORNEK:44_kv_isleclar/mantik_ailesi|baslik=Genişletilmiş mantık kapıları}}

> **Dikkat: `IFF` iki iş görür.** İki işlenenin **arasına** yazılırsa (`a IFF b`) `XNOR` ile aynı mantık işlecidir ("ancak ve ancak"). Hemen ardından parantez ve üç argüman gelirse (`IFF(koşul, değer1, değer2)`) Bölüm 6.6'daki **seçim işlevidir**. Aynı satırda ikisini birlikte yazacaksanız işleç biçimini parantez içine alın.

{{ORNEK:44_kv_isleclar/iff_iki_yuz|baslik=IFF: işleç ve işlev}}

## 6.4 Kaydırma işleçleri

| İşleç | Anlamı | Örnek | Sonuç |
|---|---|---|---|
| `SHL`, `<<` | Sola kaydır (2'nin kuvveti ile çarpma) | `1 SHL 4` | 16 (büyük kaydırmada x64 farklıdır: `I32` değişkenle `1 SHL 40` AST, MIR, JS'te `1099511627776`, x64'te `0`; G-ISLEC-6) |
| `SHR`, `>>` | Sağa kaydır | `256 SHR 4` | 16 |
| `ROL`, `ROR` | Döndür: taşan bit öbür uçtan girer, tipin genişliğinde (`U8` 8 bit, `U32` 32 bit …) | `129 ROL 1` (`U8`) | 3 (`ROR 1` → 192). ✔ AST, MIR, x64, JS (`20261014_0253`'ten beri; `20261007`'de kaydırma gibi davranırdı ve x64 derlemezdi: G-ISLEC-1 kapandı). ✖ **WASM hep `0` verir** (G-WASM-22). ✖ bileşik `ROL=`/`ROR=` kaydırır (G-ISLEC-10). JS'te `U64`'te sayı kesinliği biter (G-TIP-2) |

{{ORNEK:44_kv_isleclar/bit_dondurme|baslik=Bit döndürme: ROL ve ROR}}

{{ORNEK:44_kv_isleclar/renk_paketleme|baslik=Orta düzey: renk bileşenlerini paketlemek}}

{{ORNEK:44_kv_isleclar/bit_sayma|baslik=Orta düzey: kümelenmiş bit sayısı}}

## 6.5 Atama ve bileşik atama

| İşleç | Anlamı | Eşdeğeri |
|---|---|---|
| `=` | Atama | |
| `+=` `-=` `*=` | Toplama, çıkarma, çarpma ile atama | `x = x + 3` |
| `/=` | Ondalıklı bölme ile atama | `x = x / 4` |
| `\=` `%=` | Tamsayı bölme / kalan ile atama | |
| `**=` | Üs ile atama | `x = x ** 5` |
| `\|=` `^=` `&=` | Bit VEYA / XOR / VE ile atama (`&=` yalnız tamsayı) | |
| `<<=` `>>=` | Kaydırıp atama | |
| `ROL=` `ROR=` | Döndürüp atama. ✖ **SESSİZ (G-ISLEC-10):** döndürme yerine kaydırır: `a ROL= 1` (`U8` 129) `2` verir (beklenen `3`), `b ROL= 2` (`U16` 32769) `4` verir (beklenen `6`) | `a = a ROL 1` yazın |
| `x++` `x--`, `INC x`, `DEC x` | Bir artır / azalt | `x = x + 1` |

`AND=`, `OR=` gibi sözcüklü bileşik atamalar ve `INC x, 5` biçimi **yoktur** (ayrıştırılamaz).

{{ORNEK:13_operator/bilesik_atama|baslik=Bileşik atamalar}}

## 6.6 Üçlü seçim, `IFF` ve boru işleci

| Yapı | Yazım | Ne yapar? |
|---|---|---|
| Üçlü seçim | `koşul ? değer1 : değer2` | Koşul doğruysa ilk, değilse ikinci değer. İç içe yazılabilir |
| `IFF` | `IFF(koşul, değer1, değer2)` | Aynı iş, işlev biçiminde |
| Boru | `değer \|> F \|> G` | `G(F(değer))` ile aynıdır; soldan sağa okunur |

{{ORNEK:44_kv_isleclar/uclu_ve_boru|baslik=Üçlü seçim, IFF ve boru}}

`?:` ve `IFF` **yalnız seçilen dalı hesaplar**; öbür dalda yan etkisi olan bir çağrı varsa o çalışmaz. Aynı kural `ANDALSO` ve `ORELSE` için de geçerlidir; `AND` ve `OR` ise iki tarafı da hesaplar. Bu davranış AST, MIR, x64 ve JS motorlarında aynıdır.

{{ORNEK:44_kv_isleclar/secim_kisa_devre|baslik=Hangi dal hesaplanır?}}

> `|>` ifade işleciyle `PIPE ... END PIPE` **görev bloğu** farklı şeylerdir (Bölüm 15).

## 6.7 İşleç önceliği (yüksekten düşüğe)

Sıra, bu kılavuz yazılırken **işleç çiftleri tek tek çalıştırılarak** çıkarılmıştır (50'den fazla ikili sınama; üç yerel motorda aynı sonuç).

| Sıra | İşleçler | Birleşme | Kanıt örneği |
|---|---|---|---|
| 1 | Parantez `( )`, işlev çağrısı, dizi indeksi | — | |
| 2 | Tekli: `-x`, `+x`, `NOT`, `~`, `!` | Sağdan | `-2 ** 2` = 4; `NOT 2 ** 2` = 9; `NOT 1 + 1` = -1 |
| 3 | `**` | Sağdan sola | `2 ** 3 ** 2` = 512; `5 \ 2 ** 2` = 1 |
| 4 | `*` `/` `\` `MOD` `%` | Soldan sağa (hepsi aynı düzey) | `8 \ 2 * 2` = 8; `2 * 7 MOD 4` = 2; `12 \ 4 / 2` = 1.5 |
| 5 | `+` `-` | Soldan | `1 SHL 2 + 1` = 8 |
| 6 | `SHL` `SHR` `ROL` `ROR` `<<` `>>` | Soldan | `2 * 3 SHL 1` = 12; `8 SHR 1 = 4` = -1; `1 ROL 2 SHL 1` ve `1 SHL 2 ROL 1` ikisi de 8 (`ROL` ile `SHL` aynı düzeydedir); `1 + 1 ROL 1` = 4 (`ROL`, `+`'dan düşüktür) |
| 7 | `=` `==` `<>` `!=` `<` `<=` `>` `>=` | Soldan | `1 + 1 = 2` = -1; `5 AND 3 = 3` = 5 |
| 8 | `AND` `&` `&&` `ANDALSO` | Soldan sağa (hepsi aynı düzey) | `4 AND 2 ANDALSO 1` = 0; `2 ANDALSO 1 AND 4` = 4 |
| 9 | `XOR` `^` | Soldan | `6 XOR 3 AND 1` = 7; `1 \| 6 ^ 3` = 5 |
| 10 | `OR` `\|` `\|\|` `ORELSE` | Soldan | `1 OR 2 AND 4` = 1; `1 ORELSE 0 ANDALSO 0` = -1 |
| 11 | `? :` (üçlü seçim) | Sağdan | `1 OR 0 ? 10 : 20` = 10 |

Henüz öncelikleri **sınanmamış** olanlar (? DENENMEDİ): `NAND`, `NOR`, `XNOR`, `NXOR`, `EQV`, `EQA`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB`,
`|>` ve araya yazılan `IFF` (işlev biçimi bu listeye girmez). Bunları başka işleçlerle karıştırırken **parantez kullanın**. Genel kural: emin değilseniz parantez yazın.

### Yan etkili çağrı ve değerlendirme sırası

Öncelik, işlenenlerin **hangi sırayla hesaplanacağını** söylemez. Bir ifadede aynı genel değişkeni hem okuyan hem de bir işlev çağrısıyla değiştiren iki parça varsa sonuç motora göre değişir (✖ **FARK, G-DIL-15**; S-161):

```
DIM g AS I32 = 1
FUNCTION F() AS I32
    g = 100
    RETURN 0
END FUNCTION
g = g + F()
PRINT g
```

AST `1` yazar (`g` çağrıdan **önce** okunur); MIR, x64, JS ve WASM `100` yazar (çağrı önce çalışır, `g` sonra okunur). İleti ve hata yoktur. Görev modeli tasarımı "çağrılar önce, sonra depo okumaları" kuralını koyar; AST buna henüz uyarlanmadı. Bu yüzden **yan etkisi olan çağrının sonucunu önce bir değişkene alın** (`t = F()` ardından `g = g + t`) ve bir ifadede aynı değişkeni hem okuyup hem de çağrıyla değiştirmeyin.

## 6.8 Benzerlerinden farkı

| İkili | Fark |
|---|---|
| `/` ve `\` | Ondalıklı bölme / tamsayı bölme (`7 / 2` = 3.5, `7 \ 2` = 3) |
| `**` ve `^` | Üs / **XOR** |
| `AND` ve `&&` | Bit düzeyinde / mantıksal (`5 AND 3` = 1, `5 && 3` = -1) |
| `AND` ve `ANDALSO` | Her iki taraf hesaplanır / sol taraf yeterliyse sağ taraf atlanır |
| `NOT` ve `!` | Bitleri ters çevirir (`NOT 5` = -6) / doğruluğu ters çevirir (`!5` = 0) |
| `=` ve `==` | Atama bağlamında yalnız `=` atar; koşulda ikisi de karşılaştırır, `==` niyeti açık yazar |
| `+` ve `&` | `+` metin birleştirir; `&` **bit VE**'dir (metinde hata verir). `+` ile sayı ve metni **karıştırmayın**: AST, MIR, JS sessizce birleştirir, x64 çöker (G-DIL-13) |
| `SHL` ve `ROL` | Sola kaydırır, boş kalan uca `0` girer (tipin genişliğini aşan bitlerin kaybolup kaybolmadığı motora göre değişir, G-ISLEC-6; `U8 129 SHL 1` AST, MIR, JS'te `258`, x64'te `2`) / taşan bit öbür uçtan girer (`U8 129 ROL 1` = 3) |
| `?:` ve `IFF` | Aynı sonuç ve aynı davranış (ikisi de yalnız seçilen dalı hesaplar); `?:` işleç, `IFF` işlev biçimi |
| `\|>` ve `PIPE` | İfade işleci / görev bloğu |

## 6.9 Çalışmayan ya da tuhaf davranan işleçler

| İşleç | Durum | Ne yapmalı? |
|---|---|---|
| `@x` (adres al) | ✖ SINIR (G-ISLEC-2): AST'de çalışma anı hatası, x64 derlemez | `VARPTR(x)` kullanın |
| `&` ile metin birleştirme | Hata: `integer or Boolean operands required for bit logic` | `+` kullanın |
| `ROL` / `ROR` (WASM) | ✖ **SESSİZ (G-WASM-22):** `0` verir; üretilen WAT'ta `rotl`/`rotr` komutu yoktur, işleç `1000` numaralı ana bilgisayar çağrısına gider ve bu çağrı yeni satır yazıp `0` döndürür (her `ROL`/`ROR` ifadesi fazladan boş satır da yazar) | WASM'a gidecek programda kullanmayın; yerel x64 ya da JS ile çalıştırın |
| `SHR` işaretsiz tiplerde (WASM) | ✖ **SESSİZ (G-WASM-21):** `U8`, `U16`, `U32` ile hep `0` verir (`I32` doğrudur: `20 SHR 2` → `5`) | WASM'a gidecek programda işaretsiz değeri `\` ile bölerek kaydırın ya da `I32` kullanın |
| `ROL=` / `ROR=` | ✖ **SESSİZ (G-ISLEC-10):** döndürme yerine kaydırır | `a = a ROL 1` yazın |
| `!x` ve `+x` (x **değişken**) | ◌ x64, JS ve WASM'da derlenmez: `ADIM25 AST->MIR coverage failed: UNARY` (G-ISLEC-3). Sabitle (`!5`) dört motorda çalışır | `NOT x` ya da `x = 0` yazın; `+x` yerine `x` |
| `(z = 0) * 3`, `3 - (a > b)` | ◌ Her motorda `type: numeric operands required` (G-ISLEC-4); `+`, `\`, `MOD`, `AND`, `OR`, `XOR` kabul eder | Sonucu önce `I32` değişkene atayın ya da `IFF(koşul, 1, 0)` yazın |
| `-(z = 0)` (z değişken), `-(x > 1)` (`x` `F64`) | `1` (doğru karşılaştırma `-1` olduğundan); `20261014_0253`'te AST, MIR, MIR-x64, eski AST-x64 ve JS aynı sonucu verir. `20261007`'de ayrışırdı: x64 `-(z = 0)` için `-1` (✖ G-ISLEC-5), MIR yorumlayıcı ondalık karşılaştırmada `-1` (✖ G-ISLEC-9); ikisi de `20261013_2209` ve sonrasında kapandı (S-505, S-417) | Gerekmez; eski ikililerde `IFF(koşul, 1, 0)` ile açık değer üretin |
| Ondalık işlenenli karşılaştırmanın **değerini** yazdırmak ya da atamak: `PRINT x >= 0`, `b = (x >= 0)` | ✖ **SESSİZ, yalnız yeni derlemelerde (20261013_1704 ve sonrası) ve yalnız MIR-x64'te (G-ISLEC-8, Ek K.4):** `nan` yazar, atanan değer `0` olur (beklenen `-1`). Referans ikilide (`20261007`) dört motorda doğrudur. Koşul olarak kullanım (`IF x >= 0 THEN`) ve tamsayı karşılaştırması etkilenmez | Karşılaştırmayı `IF` içinde koşul olarak kullanın; değerini `IF x >= 0 THEN b = -1 ELSE b = 0` ile üretin |
| `c.v = a.v AND b.v` (alana atama; parantezsiz `AND`, `OR`, `XOR`, `ANDALSO`) | ✖ **SESSİZ (G-ISLEC-7), dört motorda:** atama kaybolur, alan değişmez (`a.v = 12`, `b.v = 4` için `0`; JS `CLASS` alanında `undefined`). Yerel değişkene (`r = q AND 4` → `4`), dizi elemanına (`d(1) = q AND 4` → `4`), ve alana `+ - * \ MOD SHL SHR NOT` ile atama doğrudur | `c.v = (a.v AND b.v)` (parantez), `c.v = I32(…)` ya da önce yerel değişkene atayın |
| `(1, 2)` (demet) | Dilde yok | — |

## 6.10 İşleçlerle ilgili programlama kararları

* Bölmeyi bilerek seçin: **tamsayı bölme `\`**, ondalıklı bölme `/`, kalan `MOD`. `MOD`'un işareti bölünenin işaretidir; negatif sayılarda hep pozitif kalan istiyorsanız `((x MOD n) + n) MOD n` yazın.
* **Üs için `**`**, `^` yazmayın (XOR'dur). `-2 ** 2` sonucu 4 olduğundan olumsuzlamayı parantezle belirtin: `-(2 ** 2)`.
* Koşullarda **`==`** yazın (niyet açık olur), atamada `=`.
* Metni **yalnız `+` ile** birleştirin; `&` bit VE'dir ve metinde hata verir. Sayıyı metne `STR(x)` ile çevirip birleştirin: `5 + "a"` x64'te çöker, öbür motorlarda sessizce `5a` yazar (G-DIL-8, G-DIL-13). Sayıyla metni karşılaştırırken de `STR(n) = "5"` ya da `n = VAL("5")` yazın.
* Karşılaştırma sonucunun `TRUE` = -1, `FALSE` = 0 tamsayı olduğunu unutmayın. `BOOLEAN` değişkene doğrudan atanamaz (`b = (3 > 2)` dört motorda `requires explicit cast TYPE_I32 to TYPE_BOOL` ile reddedilir); `BOOLEAN(a > b)` yazın. Bir `BOOLEAN` yazdırılınca `-1` ya da `0` görünür.
* **Alana (`TYPE` ya da `CLASS` üyesine) bit ya da mantık sonucu atarken ifadeyi parantezleyin** (G-ISLEC-7): `c.v = a.v AND b.v` hiçbir motorda hata vermez ama atamayı sessizce kaybeder; `c.v = (a.v AND b.v)` doğru çalışır. Yerel değişkene ve dizi elemanına atamada bu sorun yoktur.
* İkinci işlenenin **hesaplanması zararlıysa** (sıfıra bölme, geçersiz indeks, pahalı çağrı) **`ANDALSO` / `ORELSE`** kullanın; `AND` ve `OR` iki tarafı da hesaplar.
* Bit düzeyi ve mantıksal işleçleri karıştırmayın: `AND` ≠ `&&`, `NOT` ≠ `!`.
* **Emin değilseniz parantez yazın.** Önceliği sınanmamış işleçlerde (`NAND`, `NOR`, `IMP`, `|>`, `IFF` …) parantez zorunludur.
* `ROL=`/`ROR=` bileşiklerini ve `@x` işlecini kullanmayın (G-ISLEC-10, G-ISLEC-2); döndürmeyi `a = a ROL 1` biçiminde açık yazın, adres için `VARPTR(x)` kullanın. WASM'a gidecek programda `ROL`/`ROR` ve işaretsiz `SHR` yazmayın (G-WASM-21, G-WASM-22).
* Bileşik atamayı (`+=`, `*=`, `<<=` …) tercih edin; `AND=`, `OR=` ve `INC x, 5` yoktur.
