# 4. Veri tipleri

Bir **tip**, bir değerin bellekte kaç bayt yer kapladığını, hangi değerleri alabileceğini ve üzerinde hangi işlemlerin yapılabileceğini
söyler. uXBasic'te tipler **adlarında boyutlarını taşır**: `I32` "32 bitlik işaretli tamsayı", `U8` "8 bitlik işaretsiz tamsayı"
demektir. Böylece bir programı okurken "bu sayı kaç bite sığar?" sorusunu tahmin etmek gerekmez.

## 4.1 Hızlı bakış

| Aile | Tipler | Ne için? | Durum |
|---|---|---|---|
| **Tamsayı** | `I8` `U8` `I16` `U16` `I32` `U32` `I64` `U64` | Sayaç, indeks, bayt, para (kuruş), kimlik | ✔ |
| **Kayan noktalı** | `F32` `F64` | Ölçüm, oran, bilimsel hesap | ✔ |
| **Genişletilmiş kayan noktalı** | `F80` `F128` | Daha yüksek duyarlık | ◐ (`F80` aritmetiği yalnız AST'de, G-TIP-12; `F128` MIR ve x64'te ondalık kısmı **sessizce atar**, G-TIP-10) |
| **Büyük sayılar** | `BIGINT` `BIGF` `BIGD` `BALL` | Sınırsız büyüklükte ya da çok duyarlıklı hesap | ◐ (AST'de çalışır; MIR ve x64'te sıradan atamada **sessiz yanlış**, G-TIP-11) |
| **Mantıksal** | `BOOLEAN` | Evet/hayır değeri (`TRUE` = -1, `FALSE` = 0) | ✔ |
| **Metin** | `STRING` | Yazı | ◐ (bayt temelli; Unicode sınırı: Ek G) |
| **İşaretçi** | `PTR` | Bellek adresi | ✔ (yerel motorlarda) |
| **Koleksiyon** | `LIST` `DICT` `SET` ve dizi | Çok değer tutmak | ✔ (Bölüm 10) |
| **Görev** | `TASK` `TASKGROUP` `MUTEX` `ATOMIC` | Eşzamanlı çalışma | ✔ (Bölüm 15) |
| **Kullanıcı tipi** | `TYPE` `STRUCT` `UNION` `ENUM` `CLASS` `INTERFACE` | Kendi veri yapın | ✔ (Bölüm 10, 11) |
| **Kütüphane tipi** | `RATIONAL` ve manifestle gelenler | Kesirli sayı, karmaşık sayı… | ◐ (Bölüm 19) |

## 4.2 Tamsayılar

| Tip | Bayt | En küçük | En büyük | Örnek kullanım |
|---|---|---|---|---|
| `I8` | 1 | -128 | 127 | Küçük işaretli değer |
| `U8` | 1 | 0 | 255 | Bayt, renk bileşeni |
| `I16` | 2 | -32 768 | 32 767 | Ses örneği |
| `U16` | 2 | 0 | 65 535 | Bağlantı noktası numarası |
| `I32` | 4 | -2 147 483 648 | 2 147 483 647 | **Varsayılan sayaç/indeks tipi** |
| `U32` | 4 | 0 | 4 294 967 295 | Kimlik, bit alanı |
| `I64` | 8 | -9 223 372 036 854 775 808 | 9 223 372 036 854 775 807 | Büyük sayaç, zaman damgası, **para (kuruş)** |
| `U64` | 8 | 0 | 18 446 744 073 709 551 615 | Özet (hash) değeri, bellek boyutu |

{{ORNEK:42_kv_tipler/tip_boyutlari|baslik=Tip boyutlarını SIZEOF ile görmek}}

### Sabit aralık denetimi

Bir tamsayı **sabiti** tipin aralığına sığmıyorsa derleyici programı **reddeder**; değeri sessizce kırpmaz:

```
DIM a AS I32
a = 3000000000
ERROR: ... integer literal out of range for TYPE_I32: 3000000000
```

### Taşma (sarma)

Çalışma anında hesapla aralığın dışına çıkan değer **sarar** (modül aritmetiği). `I8` için 127'den sonra -128 gelir. Dar tipler (`I8`, `U8`,
`I16`, `U16`) aritmetikte `I32`'ye yükselir; sonucu aynı dar tipe geri atamak için **açık dönüşüm** gerekir: `k = I8(k + 1)`.

{{ORNEK:42_kv_tipler/tasma|baslik=Sarma davranışı}}

> **Dikkat (JS/WASM):** `I32` taşması JS'te sarmaz (2147483648 yazar), `U32` alt taşması WASM'da işaretli yazılır. Bu iki fark **✖ SINIR** olarak
> Ek G'dedir (G-TIP-2, G-TIP-3). Yerel motorlar (AST, MIR, x64) üçü de aynı sonucu verir.

**Yalnız sabitlerden oluşan hesap sarmaz.** Aynı ifade değişkenlerle yazılırsa tipin genişliğinde sarar; ama işlenenlerin hepsi sabitse derleyici onu tamsayı olarak değil **ondalık sayıyla katlar**: sarma görmezsiniz ve 2^53'ün üstünde sonuç kesin de olmaz. AST, MIR, x64 ve JS sabitte aynı sonucu verir, değişkende yerel motorlar sarar (✖ **SINIR, G-TIP-14**; S-078):

| İfade | Yalnız sabitlerle | Değişkenle (AST, MIR, x64) |
|---|---|---|
| `2147483647 + 1` | `2147483648` | `-2147483648` (`I32`) |
| `4000000000 * 4000000000` | `1.6e+19` | `-2446744073709551616` (`I64`) |
| `9223372036854775807 + 10` | `9.223372036854776e+18` | `-9223372036854775799` (`I64`) |
| `9007199254740993 + 2` | `9007199254740994` | `9007199254740995` (`I64`) |

Taşabilecek bir hesabı denemek için **değişken** kullanın; sabitlerle yazılmış bir taşma denemesi gerçek davranışı göstermez. (Değişkenli sütun JS'te de farklıdır: G-TIP-2, G-JS-4.)

## 4.3 Kayan noktalı sayılar

| Tip | Bayt | Yazdırmada kaç anlamlı hane | Ne için? |
|---|---|---|---|
| `F32` | 4 | 7 (yazdırmada; **değerin tek duyarlığa yuvarlanması motorlara göre farklıdır**: aşağıdaki "F32 tek duyarlıktır" tablosu, G-TIP-13 … G-TIP-22 ve Ek K) | Bellekten tasarruf, grafik |
| `F64` | 8 | 16 | **Varsayılan ondalıklı tip**, bilimsel hesap |
| `F80` | 10 (adımı 16) | — | Genişletilmiş duyarlık (aritmetik yalnız AST'de, G-TIP-12) |
| `F128` | 16 | — | Dört katlı duyarlık (**MIR ve x64'te kesir atılır**, G-TIP-10) |

Bölme işleci `/` **her zaman ondalıklı** sonuç verir (`7 / 2` = 3.5). Tamsayı bölmesi için `\` kullanılır (`7 \ 2` = 3).

### Eşitlik tuzağı

0.1 ve 0.2 ikili sistemde tam yazılamaz, bu yüzden `0.1 + 0.2` tam olarak 0.3 değildir. Ondalıklı sayılar `=` ile
karşılaştırılmaz; **fark, küçük bir eşikle** karşılaştırılır:

{{ORNEK:42_kv_tipler/ondalik_hassasiyet|baslik=0.1 + 0.2 = 0.3 mü?}}

> **Not:** Ondalıklı bir değeri tamsayı değişkene atamak için açık dönüşüm gerekir: `n = I32(x)`. Dönüşümsüz atama derleme hatasıdır
> (`assignment requires explicit cast TYPE_F64 to TYPE_I32`).

### `F32` tek duyarlıktır: değer yuvarlaması bağlama göre değişir

`F32` 4 bayttır ve yaklaşık 7 anlamlı basamak tutar: `16777217` sayısı tek duyarlıkta tutulamaz, `16777216`'ya yuvarlanır. Tasarım sözleşmesi (`docs/tasarim/UXB_S510_S511_S512_F32_DEGER_PARITESI_20261014_TR.md`) şöyledir: bir değer `F32` olarak bildirildiği, `F32(...)` ile dönüştürüldüğü ya da bir dizi elemanına ya da alana saklandığı anda **değere** uygulanan yuvarlama ile tek duyarlığa iner; sonraki hesap yuvarlanmış değeri kullanır. Yazdırmayı 7 haneye kısaltmak yetmez.
`PRINT f` yuvarlayan ve yuvarlamayan motorda aynı `1.677722e+07` yazdığı için yuvarlamayı ancak bir **çıkarma** ortaya çıkarır: `PRINT f - 16777216` yuvarlayan motorda `0`, yuvarlamayan motorda `1` verir. Aşağıdaki tablo bu yüzden yazdırmayı değil, değer hesabını sınar. Hücrelerde yalnız beklenenden **farklı** sonuç yazılıdır; `d` bir `F64`'tür:

| # | Program | Beklenen | AST | MIR | MIR-x64 | AST-x64 | JS | Kayıt |
|---|---|---|---|---|---|---|---|---|
| 1 | Ana programda `DIM f AS F32 = 16777217` sonra `PRINT f - 16777216` | `0` | ✔ | ✔ | ✔ | ✔ | ✔ | — |
| 2 | Bir yordamın içinde **yerel** `F32`'ye yazma (`DIM y AS F32 = 16777217` ya da `y = 16777217`), sonra `y - 16777216` | `0` | ✔ | ✖ `1` | ✔ | ✔ | ✔ | G-TIP-23 |
| 3 | Yordam içinden **genel** `F32`'ye atama (`gl = 16777217`), sonra `gl - 16777216` | `0` | ✔ | ✔ | ✖ `1` | ✔ | ✖ `1` | G-TIP-25 |
| 4 | `BYVAL p AS F32` parametre, `B(16777217)` ve yordamda `p - 16777216` | `0` | ✔ | ✔ | ✔ | ✔ | ✖ `1` | G-TIP-26 |
| 5 | Aritmetik ara sonuç: `DIM u AS F32 = 16777216` sonra `(u + 1) - 16777216` | `0` | ✖ `1` | ✔ | ✔ | ✔ | ✔ | G-TIP-27 |
| 6 | `TYPE` alanı: `r.v = 16777217` sonra `r.v - 16777216` | `0` | ✔ | ✔ | ✖ `4194304` | ✔ | ✔ | G-TIP-24 |
| 7 | `TYPE` alanı: `r.v = 2.5` sonra `r.v + 1` ve `r.v * 2` | `3.5` ve `5` | ✔ | ✔ | ✖ `2.5` ve `-5.877472e-39` | ✔ | ✔ | G-TIP-24 |
| 8 | `F32(d) + 1` (`d` = 2.5) ve `F32(d) - 16777216` (`d` = 16777217) | `3.5` ve `0` | ✔ | ✔ | ✔ | ✔ | ✔ | — |
| 9 | `DIM t AS F32 = d` sonra `t + 1` (`d` = 2.5) | `3.5` | ✔ | ✔ | ✔ | ✔ | ✔ | — |
| 10 | Dizi elemanı: `a(0) = 16777217` sonra `a(0) - 16777216`; `a(0) + a(1)` | `0`; toplam | ✔ | ✔ | ✔ | ✔ | ✔ | — |
| 11 | Gidiş dönüş: `F64(F32(x)) = x` ve `F64(y) - x` (`x` = 0.1) | `0` ve `1.490116113833651e-09` | ✔ | ✔ | ✔ | ✔ | ✔ | — |

*Ölçüm: `20261014_0253` (altı yoldan WASM hariç; WASM `F32`/`F64` değerlerini hiç taşımaz ve derlemede açıkça reddeder, G-WASM-7).* `20261013_2224` ve öncesinde tabloyu çok daha fazla ✖ doldururdu: bildirim başlangıcının AST'de ve JS'te yuvarlanmaması (G-TIP-13), MIR'in hiçbir yerde yuvarlamaması (G-TIP-20), `F32(d)` ve `F32` dizi elemanı okumasının MIR-x64'te çöp vermesi (G-TIP-21, G-TIP-19), `DIM t AS F32 = d` biçiminin eski AST-x64 yolunda bozuk olması (G-TIP-22), dizi elemanının dört yolda dört sonuç vermesi (G-TIP-15, G-TIP-16). Bu yedi kayıt `20261014_0253` derlemesinde kapandı (Ek K); tablodaki ✖ satırları kalan beş kayıttır.

**Ne yapmalı?** Tek duyarlık davranışına dayanan bir hesabı (birikimli toplam, yuvarlama) `F32` ile yazmayın; ondalık gerekiyorsa `F64`, para ise kuruş olarak `I64` kullanın (4.9). `F32` kullanacaksanız hesabı ana programda ya da bir `TYPE` alanı yerine düz değişkende yapın ve bir **değer sınaması** (`PRINT k - 16777216`) ekleyin; yalnız `PRINT` ile sınamak yuvarlama kusurlarını gizler (S-446'nın ilk kapanışı bu yüzden erkendi).

## 4.4 Büyük sayılar: `BIGINT`, `BIGF`, `BIGD`, `BALL`

| Tip | Ne tutar? |
|---|---|
| `BIGINT` | Sınırsız büyüklükte tamsayı |
| `BIGF` | Keyfi duyarlıklı kayan noktalı sayı |
| `BIGD` | Büyük ondalık (decimal) sayı |
| `BALL` | Değer + hata yarıçapı (aralık/topu aritmetiği) |

Bu tipler tek bir işlemci komutuna inmez; çalışma zamanı kütüphanesi ile hesaplanır. Başlatma `BIGINIT(tür, "metin", duyarlık)` ile yapılır:

{{ORNEK:42_kv_tipler/buyuk_sayi_bigint|baslik=İki 20 haneli sayıyı çarpmak}}

> **✖ SINIR (G-TIP-1):** `DIM g AS BIGINT = 1` yazıp çarpmaya devam ederseniz sayı **64 bite sarar** (25! yerine 7034535277573963776 çıkar);
> sessiz bir yanlıştır. Doğru yol `BIGINIT` ile başlatmaktır. Ayrıca MIR yorumlayıcı bu örnekte `0` yazar ve x64 derlemesi başarısız olur; hedef
> bu tipin her motorda ya doğru çalışması ya da açıkça reddedilmesidir.

**Geniş sayı ailesinin bugünkü durumu (G-TIP-9).** `DIM g AS BIGF` gibi bildirimler AST, MIR ve x64'te kabul edilir, ama değer üretme ve işlem yalnız AST'de çalışır:

| Yazım | AST | MIR | x64 | JS |
|---|---|---|---|---|
| `BIGF("1.5") + BIGF("2.25")` | ✔ `3.75` | ◌ "external-number calls must use the real BIGINIT/FP runtime bridge" | ◌ `UXB_RUNTIME_HOST_UNBOUND` | ◌ "host binding missing: BIGF" |
| `BALL("1.5")` | ✔ `1.5 +/- 0` | ◌ aynı | ◌ aynı | ◌ aynı |
| `F128("1.5")`, `F80("2.5")` | ◌ "unsupported call F128" | ◌ `RT_LIBRARY_CALL` bağlı değil | ◌ `UXB_RUNTIME_HOST_UNBOUND` | ◌ "host binding missing: F128" |

Bu tablodaki **kurucu çağrıları** kapalı başarısızlıktır (açık ret ya da hata). Ama tasarım (`F80/F128/BIG*` "birinci sınıf çalışma zamanı tipi") bu tiplerin her motorda gerçek bir karşılığı olmasıdır. Geniş duyarlık gereken hesabı AST'de çalıştırın.

**Dikkat: değişken olarak kullanım kapalı başarısız değildir.** Bu tipleri kurucu çağırmadan, sıradan sayı atamasıyla (`DIM a AS F128: a = 1.5`) kullanınca derleyici reddetmez; AST ve JS doğru çalışır, ama MIR, x64 ve WASM **sessizce yanlış** sonuç verebilir. Aşağıdaki tablo her tipin dört motorda gerçek davranışını gösterir (hücre: ✔ doğru, ✖ sessiz yanlış, ◌ açık ret):

| Tip | Tamsayı atama ve `+ - * /` | Ondalık atama (`a = 1.5`, `a * 2`) | Kayıt |
|---|---|---|---|
| `F32`, `F64` | ✔ AST, MIR, x64, JS (WASM ◌) | ✔ AST, MIR, x64, JS (WASM ◌) | G-WASM-7 |
| `F80` | Yalnız atama ve `PRINT`: ✔ dört motor. Aritmetik: ✔ AST; MIR, x64, JS ◌ `mir: F80 arithmetic not supported` (WASM her `F80` değişkenini ◌ reddeder) | Aynı | G-TIP-12 |
| `F128` | ✔ AST, MIR, x64, JS (WASM: `/` ✖) | ✔ AST, JS; ✖ **MIR ve x64** (`1.5` → `1`, `a * 2` → `2`) | G-TIP-10, G-WASM-20 |
| `BIGINT` | ✔ AST, MIR, x64, JS (WASM: `/` ✖) | ◌ derleme: `assignment requires explicit cast TYPE_F64 to TYPE_BIGINT` | G-WASM-20 |
| `BIGF`, `BIGD`, `BALL` | ✔ AST, x64, JS; ✖ **MIR** (çıplak `PRINT a` hiçbir şey yazmaz) | ✔ AST, JS; ✖ **MIR** (`1.5` → `2`) ve ✖ **x64** (`1.5` → `1`) | G-TIP-11, G-WASM-20 |

Bu yüzden `F128`, `BIGF`, `BIGD` ve `BALL`'ı **kurucu (`BIGINIT` …) kullanmadan** ve AST dışında kullanmayın; ondalık hesapta `F64` yazın.

**Tasarlanan söz dizimi ve terfi kuralları (◇ HEDEF, G-HEDEF-28).** `docs/FP_EXTENSION_ROADMAP_AFTER_STAGE4.md` kayan nokta ailesinin nasıl tamamlanacağını belirler; aşağıdakilerin hiçbiri bugün çalışmaz:

| Tasarım | Bugün |
|---|---|
| `F80` korunur; aritmetik harici bir çalışma zamanıyla (`uxb_f80_add` …) yapılır ve **F80/F128 değerleri yazmaçla değil işaretçi üzerinden döndürülür** | `F80` toplama yalnız AST'de (`3.75`); MIR ve x64 `mir: F80 arithmetic not supported` (G-TIP-12) |
| `F128`: 16 baytlık sabit çalışma zamanı tipi | Ondalık atama MIR ve x64'te yanlış (`1.5` → `1`, G-TIP-10) |
| Duyarlık tipin parçasıdır: `DIM X AS BIGF(256)`, `BIGD(80)` | AST kabul eder; MIR ve x64 `DIM array element layout failed: unknown type: BIGF(256)` der (ileti dizi gibi konuşur) |
| Uzun hassas sabit için **ham sayı sabiti** `X = {3.1415926535897932384626433832795028841971}` (`"…"` metindir, sayı değildir; `BIGF("3.1415")` isteğe bağlı kurucudur) | `{ … }` sabiti her motorda `Lexer diagnostic bridge hata buldu: 2` (çıkış 2) |
| Terfi: `BIGF op tamsayı → BIGF`, `BIGD op tamsayı → BIGD`, `F128 op tamsayı → F128`, `F80 op tamsayı → F80`, `BIGF op F64/F80/F128 → BIGF`; `BIGD op ikili kayan nokta` için açık dönüşüm önerilir, `BIGF op BIGD` için **zorunludur** | Yalnız AST'de kısmen; kural uygulanmaz |
| Açık dönüşüm işlevleri `TO_BIGF()`, `TO_BIGD()`, `TO_F128()` | Yoktur: `TO_BIGF(a)` `assignment requires explicit cast TYPE_OBJECT to TYPE_BIGF` ile reddedilir |
| `BALL` (aralık / top aritmetiği) en son aşamadır | AST'de `BALL("1.5")` → `1.5 +/- 0` |

**Tasarımın sistem tipleri.** Tasarım belgeleri 35 kanonik tip sayar. Bunlardan `FUNCTION_PTR`, `DLL_HANDLE`, `FILE_HANDLE`, `JS_OBJECT`, `WASM_EXTERNREF`, `WSTRING`, `WSTRPTR`, `VARIANT` ve `ANY`
tip adı olarak **kullanılamaz** (`unknown type: … [canonical=…]`, G-TIP-8). Tutamaçları `U64` ile, işaretçileri `PTR` ile tutun.

**`ANY`, `VARIANT`, `OBJECT`, `NONE`, `NAN`, `NODE` hakkında (Mete'nin sorusu, 2026-10-15).** Derleyicinin iç tip kümesinde `ANY`, `VARIANT`, `OBJECT`, `VOID`, `FILE_HANDLE`, `FUNCTION_PTR`, `DLL_HANDLE`, `JS_OBJECT` ve `WASM_EXTERNREF` vardır; yorumlayıcının değer türlerinde de `VAL_ANY`, `VAL_VARIANT` ve `VAL_OBJECT` bulunur. Kaynak yazımında (yüzeyde) altı yolda ölçülen durum (`20261014_0253`):

| Ad | Yüzeyde | Not |
|---|---|---|
| `OBJECT` | ✔ kabul edilir (`DIM x AS OBJECT`) | Koleksiyon işlevlerinin dönüş tipi (Bölüm 10.5) |
| `ANY`, `VARIANT`, `VOID` | ✖ `unknown type` | İç tip olarak var, yüzeyden reddedilir (G-TIP-8) |
| `FILE_HANDLE`, `FUNCTION_PTR`, `DLL_HANDLE`, `JS_OBJECT`, `WASM_EXTERNREF` | ✖ reddedilir | Tasarımın 35 kanonik tipindendir (G-TIP-8) |
| `NONE`, `NODE` | ✖ `unknown type` | **İç karşılığı da yoktur**; tasarımın 35 tipinde de yoktur. `NONE` yalnız seçenek adı olarak geçer (yıkım kipi, çağrı sözleşmesi sınıfı). **Karar (Mete, 2026-10-15): eklenmeyecek**; yokluk `NULL`/`NOTHING` ile, düğüm `CLASS`/`TYPE` ile ifade edilir (G-TIP-30) |
| `NULL`, `NOTHING` | ✖ `unknown symbol` (bugün) | **Karar (Mete, 2026-10-15): çalışacak** (◇ HEDEF, G-TIP-31, S-564). MIR indirgeyicisinde kod var, anlam kapısı tanımıyor. `NIL` istenmedi, eklenmeyecek |
| `NAN` (tip ya da sabit), `INF`, `ISNAN()` | ✖ yok | NaN yalnız kayan nokta işleminden doğar ve motorlar farklıdır (G-HATA-5, G-TIP-29) |

**Hedef anlam (◇ HEDEF, S-564).** `NULL` ve `NOTHING` aynı boş değerin iki yazılışıdır; işaretçiye (`PTR`), nesne başvurusuna ve (gelince) işlev göstericisine atanır, `=` / `<>` ile sınanır; sayı, metin ya da `BOOLEAN` değişkene atanması derleme hatasıdır; `PRINT NULL` `0` yazar. Boş işaretçi, dış kütüphane çağrılarında (`BYVAL NULL`) da gerekir. Örnek (bugün çalışmaz):

```basic
DIM k AS Kutu = NEW Kutu(3)
DELETE k
k = NOTHING
IF k = NOTHING THEN PRINT "bos"
```

Sözleşme: `docs/tasarim/UXB_S544_S549_S564_DECLARE_DOSYA_TUTAMACI_NULL_20261015_TR.md` Bölüm 3.

## 4.5 Mantıksal tip: `BOOLEAN`

* `TRUE` değeri **-1**, `FALSE` değeri **0**'dır (tüm bitler 1 = doğru). Bu sayede `AND`, `OR`, `NOT` hem mantıksal hem bit işleci gibi çalışır.
* Karşılaştırmalar (`5 > 3`) `BOOLEAN` değil tamsayı üretir; `BOOLEAN` değişkene atamak için `BOOLEAN(5 > 3)` yazılır. Doğru sonuç AST, MIR, x64 ve JS'te `-1`'dir, **WASM'da `1`'dir** (G-WASM-18). Sonucu doğrudan `-`, `*`, `/` ya da `**` işleneni yapmak reddedilir (G-ISLEC-4); önce bir `I32` değişkene atayın.

{{ORNEK:42_kv_tipler/mantiksal_tip|baslik=TRUE ve FALSE}}

## 4.6 Metin tipi: `STRING`

`STRING`, yazıyı **UTF-8 bayt dizisi** olarak tutar. `LEN`, `LEFT`, `MID`, `INSTR`, `ASC` gibi işlevler yerel motorlarda (AST, MIR, x64)
**bayt** sayar. Yalnızca ASCII harflerle (`a-z`, rakamlar) bu fark görünmez; Türkçe karakterlerde (`ç`, `ğ`, `ö` …) görünür:

| İfade (`s = "çğaö"`) | AST / MIR / x64 | JS |
|---|---|---|
| `LEN(s)` | 7 (bayt) | 4 (karakter) |
| `LEFT(s, 2)` | `ç` (2 bayt) | `çğ` |
| `ASC("ç")` | 195 (ilk bayt) | 231 |
| `UCASE("çağrı")` | `çAğRı` (yalnız ASCII) | `ÇAĞRI` |
| `FOR EACH c IN s` | 4 tur (kod noktası) | 4 tur |

Tasarım kararı, metin işlevlerinin **karakter (kod noktası)** temelli olmasıdır; bugün yalnızca `FOR EACH` bunu yapar. Bu fark
**✖ SINIR (G-TIP-4)** olarak izlenir. Türkçe metin işleyen programlarda şimdilik yalnızca `FOR EACH` ve `+` ile birleştirme güvenlidir.

> `WSTRING` (geniş karakterli metin) tasarımda vardır; bugün `DIM x AS WSTRING` reddedilir: **◇ HEDEF**.

## 4.7 Dönüşümler

Tip adı aynı zamanda **dönüşüm işlevidir**: `I32(x)`, `U8(x)`, `F64(x)`, `BOOLEAN(x)`. Klasik BASIC adları da vardır.

| İşlev | Ne yapar? | Örnek | Sonuç |
|---|---|---|---|
| `I32(x)` … `U64(x)` | Tamsayıya çevirir; ondalık kısmı **atar** (sıfıra doğru keser); aralığa sığmazsa **sarar** | `I32(-3.9)` | -3 |
| `F64(x)`, `F32(x)` | Ondalıklıya çevirir | `F64(1) / 3` | 0.3333333333333333 |
| `CINT(x)` | **En yakın** tamsayıya yuvarlar; tam yarımda **çifte** yuvarlar | `CINT(3.5)`, `CINT(2.5)` | 4, 2 |
| `CLNG(x)` | `CINT` ile aynı, 32 bitlik tamsayı | `CLNG(3.5)` | 4 |
| `CDBL(x)`, `CSNG(x)` | `F64` / `F32` | `CDBL(5) / 2` | 2.5 |
| `FIX(x)` | Sıfıra doğru keser (**yalnız doğrudan `PRINT FIX(x)` içinde**: sonucu değişkene atamak ya da aritmetiğe sokmak derleme hatasıdır, ✖ G-TIP-18) | `FIX(-3.9)` | -3 |
| `INT(x)` | **Aşağı** yuvarlar (en büyük tamsayı ≤ x) | `INT(-3.1)` | -4 |
| `VAL(s)` | Metni sayıya çevirir | `VAL("40") + 7` | 47 |
| `STR(x)` | Sayıyı metne çevirir | `"n=" + STR(5)` | `n=5` |

{{ORNEK:42_kv_tipler/donusum_kurallari|baslik=Dönüşümler yan yana}}

> **Benzerlerinden farkı:** `I32(x)` **keser**, `CINT(x)` **yuvarlar**, `INT(x)` **aşağı alır**, `FIX(x)` **sıfıra doğru keser**.
> `-3.9` için dörtlüsü sırasıyla `-3`, `-4`, `-4`, `-3` verir (`CINT(-3.9)` = -4).
> JS hedefinde `CINT` ve `INT` bugün kesme yapar (✖ SINIR G-TIP-5).
>
> **Yeni derlemelerde uyarı (Ek K, ✖ G-TIP-17):** `20261013` ve sonrasında AST yorumlayıcı `I32`'den başka tamsayı dönüşümlerinde (`I8`, `I16`, `I64`, `U8`, `U16`, `U32`, `U64`) ondalığı **keser yerine yuvarlar** (`I64(3.9)` → `4`; MIR, MIR-x64 ve JS `3` verir; referans `20261007` AST de `3` verirdi). Kuruş hesabı gibi `I64(x * 100 + 0.5)` kalıpları AST'de bir kuruş şaşar.

## 4.8 İşleç önceliği ve tipler

Karışık tiplerle işlem yapılırken sonuç **daha geniş tipe** yükselir: `I32 + I64` → `I64`; tamsayı + ondalıklı → ondalıklı.
İşleçlerin öncelik sırası Bölüm 6'dadır; özet olarak:

{{ORNEK:42_kv_tipler/islec_onceligi|baslik=Öncelik örneği}}

## 4.9 Hangi tipi seçmeli?

| İhtiyaç | Önerilen tip | Neden? |
|---|---|---|
| Döngü sayacı, indeks | `I32` | Varsayılan; her motorda en hızlı/en az sürprizli |
| Para tutarı | `I64` (kuruş) | Ondalıklı sayı parada yuvarlama hatası üretir |
| Bayt, renk bileşeni, dosya içeriği | `U8` | 0-255 aralığı doğal |
| Özet (hash), bellek boyutu | `U64` | İşaretsiz ve geniş |
| Ölçüm, oran, bilimsel hesap | `F64` | 16 hane yeterlidir |
| Bellek tasarrufu, grafik | `F32` | Yarı boyut; 7 hane |
| Çok büyük tamsayı (faktöriyel…) | `BIGINIT` ile `BIGINT` | Taşmaz (AST'de) |
| Evet/hayır | `BOOLEAN` | `TRUE`/`FALSE` |

{{ORNEK:42_kv_tipler/bilesik_faiz|baslik=Orta düzey: parayı kuruş olarak tutmak}}

## 4.10 Tip adı kuralları ve eski adlar

* Büyük/küçük harf farkı yoktur: `i32`, `I32` aynıdır.
* **`$ # % ! &` tip sonekleri yoktur** (`LEFT$` değil `LEFT`).
* Eski FreeBASIC adları **uyumluluk takma adı** olarak kabul edilir ama yeni kodda **kullanılmaz** (⌛ ESKİ):

| Eski ad | Gerçekte | Yerine yazılacak |
|---|---|---|
| `LONG`, `INTEGER` | `I32` | `I32` |
| `SHORT` | `I16` | `I16` |
| `BYTE` | `I8` | `I8` (işaretsiz için `U8`) |
| `UBYTE` | `U8` | `U8` |
| `UINT`, `ULONG` | `U32` | `U32` |
| `LONGINT` | `I64` | `I64` |
| `DOUBLE` | `F64` | `F64` |
| `SINGLE` | `F32` | `F32` |

Kabul **edilmeyen** adlar: `BOOL`, `CHAR`, `ZSTRING`, `WSTRING`, `VARIANT`, `ANY`, `VOID`, `STRPTR`/`WSTRPTR` (değişken tipi olarak); tasarımdaki `FUNCTION_PTR`, `DLL_HANDLE`, `FILE_HANDLE`, `JS_OBJECT`, `WASM_EXTERNREF` de aynı biçimde reddedilir (G-TIP-8).
Derleyici eski adları reddetmediği için yanlışlıkla kullanılabilir; bu **✖ SINIR (G-TIP-6)**'dır, hedef bu adların derleme hatası vermesidir. Eski adlar yalnız `DIM … AS` içinde tanınır; `SIZEOF(LONG)` gibi kullanımlar `unknown symbol` verir (G-TIP-13).

## 4.11 Tiplerle ilgili programlama kararları

* **Tipi ihtiyaca göre seçin** (4.9): sayaç ve indeks `I32`, zaman damgası ve büyük sayaç `I64`, **para kuruş olarak `I64`**, bayt ve renk bileşeni `U8`, özet ve bellek boyutu `U64`, ölçüm ve bilimsel hesap `F64`, bellek tasarrufu `F32`.
* Ondalıklı sayıları **`=` ile karşılaştırmayın**; farkın küçük bir eşikten küçük olup olmadığına bakın (`ABS(a - b) < 0.000001`).
* Ondalıklıdan tamsayıya geçerken **açık dönüşüm** yazın ve amacınıza uyanı seçin: `I32(x)` **keser** (`FIX(x)` de keser ama yalnız `PRINT` içinde kullanılabilir, G-TIP-18), `CINT(x)` **yuvarlar** (yarımda çifte), `INT(x)` **aşağı alır**. Dönüşümsüz atama zaten derleme hatasıdır.
* Dar tiplerde (`I8`, `U8`, `I16`, `U16`) aritmetik `I32`'de yapılır; sonucu geri atamak için `k = I8(k + 1)` gibi **açık dönüşüm** yazın. Sarma istemiyorsanız daha geniş tip seçin.
* Tamsayı sabiti tipe sığmıyorsa derleyici reddeder; sığmayan değeri çalışma anında hesapla üretmek **sarar**, bu yüzden sınır değerlerini denetleyin.
* Çok büyük sayı gerekiyorsa **`BIGINIT` ile başlatın**; `DIM g AS BIGINT = 1` ile başlayıp çarpmak 64 bite sarar (G-TIP-1). Üretim kodunda `BIGINT`'i yalnız doğrulanmış motorda kullanın.
* `TRUE` = -1, `FALSE` = 0'dır; karşılaştırma tamsayı üretir, `BOOLEAN` değişkene `BOOLEAN(a > b)` ile atayın.
* Türkçe metin işlerken `LEN`, `LEFT`, `MID`, `UCASE`'in **bayt** temelli olduğunu bilin (G-TIP-4); karakter sayısı gerekiyorsa `FOR EACH` ile sayın.
* Tip sonekleri (`$ # % !`) yazmayın; eski adlar (`LONG`, `INTEGER`, `DOUBLE` …) yerine boyutlu adları (`I32`, `F64`) kullanın (G-TIP-6).
* JS ya da WASM'a gidecek programda `I32` taşmasına, `U32` alt taşmasına ve `CINT`/`INT` davranışına **güvenmeyin** (G-TIP-2, G-TIP-3, G-TIP-5); sınırları yerel motorda deneyin.
