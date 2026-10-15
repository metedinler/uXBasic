# 5. Değişkenler, sabitler, diziler ve kapsam

Bir **değişken**, programın çalışırken değerini değiştirebildiği adlı bir bellek kutusudur. **Sabit** değeri hiç değişmeyen kutudur.
**Dizi** aynı tipten çok sayıda kutuyu tek adla ve sıra numarasıyla (indeks) tutar. **Kapsam** ise bir adın programın hangi bölümünde
görüldüğünü söyler.

## 5.1 Değişken tanımı: `DIM`

| Yazım | Anlamı | Durum |
|---|---|---|
| `DIM sayi AS I32` | `I32` tipinde değişken; ilk değeri 0 | ✔ |
| `DIM sayi AS I32 = 5` | Tanım ve ilk değer birlikte | ✔ |
| `DIM a AS I32, b AS F64` | Aynı satırda tipleri **farklı** olabilen iki tanım | ✔ |
| `DIM a, b AS I32` | Tek tipi birden çok ada vermek | ✖ SINIR: `DIM: AS expected near ','` ile reddedilir |
| `DIM d(9) AS I32` | 10 elemanlı dizi (indeks 0-9) | ✔ |
| `DIM d(2 TO 5) AS I32` | Alt sınırı 2 olan dizi | ✔ |
| `DIM m(1 TO 3, 1 TO 3) AS I32` | İki boyutlu dizi | ✔ |
| `DIM d(3) AS I32 = {1, 2, 3, 4}` | Dizi ilk değer listesi | ✖ SINIR: ayrıştırılamaz |
| `DIM ATOMIC x AS I64` / `DIM m AS MUTEX` | Görev tipli değişkenler | ✔ (Bölüm 15) |

* **Tanımsız adı okumak hatadır.** `PRINT yok` yazarsanız derleyici `unknown symbol: yok` der.
* **Bildirimsiz atama** (`a = 7`) eski BASIC uyumu için bir değişken oluşturur ve tipi atanan değerden çıkarır; **yeni kodda kullanılmaz**.
  Üstelik her yerde çalışmaz: `FOR i = 1 TO 3` yazdığınızda `i` önceden tanımlı olmalıdır.
* `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFDBL`, `DEFSTR` harf aralığına göre örtük tip verir; bu da eski uyumluluktur (⌛ ESKİ):

{{ORNEK:10_deftype/defint_aralik|baslik=DEFINT ile harf aralığına tip vermek}}

## 5.2 Başlangıç değerleri

İlk değer verilmeyen değişkenler ve dizi elemanları **sıfır** ile başlar. Bu, çöp değer okuma hatalarını ortadan kaldırır; tek istisna eski AST-x64 yolunda bir rutinin (`SUB`/`FUNCTION`) içinde bildirilen yerel değişkenlerdir: onlar sıfırlanmaz, önceki çağrıdan kalan değeri taşır (✖ G-YORDAM-7).

{{ORNEK:43_kv_degisken/baslangic_degeri|baslik=Sıfırla başlama}}

> **✖ SINIR (G-DIL-4):** İlk değer verilmeyen `STRING` değişkeni MIR ve x64'te boş metin (`""`), AST'de `0` yazdırır. Metin değişkenlere hemen ilk
> değer verin: `DIM s AS STRING = ""`.

## 5.3 Sabitler: `CONST`

`CONST` değeri derleme sırasında bilinen, **değiştirilemeyen** adlı değerdir. Başka sabitlerle ifade kurulabilir; tip yazılmazsa değerden çıkarılır.

{{ORNEK:43_kv_degisken/sabitler|baslik=Sabitlerle sabit ifadesi}}

| Karşılaştırma | `CONST` | `DIM` |
|---|---|---|
| Değişir mi? | Hayır. 20261007 ikilisinde derleyici bunu **denetlemezdi**: `CONST`'a yazmak hata vermez, AST yazmayı yok sayar, MIR, x64 ve JS sabiti değiştirirdi (✖ SESSİZ, G-DIL-12). 20261013 ve sonrasında `CONST`'a doğrudan, bileşik ya da `BYREF` ile yazmak dört motorda `UXB_CONST_ASSIGNMENT` ile reddedilir (S-441); yerel `DIM` aynı adı gölgeleyebilir | Evet |
| Ne zaman bilinir? | Derleme zamanı | Çalışma anı |
| Dizi sınırı olabilir mi? | AST/MIR/JS'te evet; **x64'te yalnızca sayısal sabit** (✖ G-DIL-1) | Değişken sınır AST/MIR'de çalışır, x64 reddeder |
| Örnek | `CONST MAX AS I32 = 100` | `DIM n AS I32 = 100` |

## 5.4 Diziler

Dizi tanımında verilen sayı **üst sınırdır**: `DIM d(9)` on elemanlıdır (0-9). Alt sınır `alt TO üst` ile açıkça yazılabilir ve negatif olabilir.
`LBOUND(d)` / `UBOUND(d)` sınırları verir; çok boyutlu dizilerde ikinci argüman boyutu seçer: `UBOUND(m, 2)`.

| İşlem | Yazım | Not |
|---|---|---|
| Tanım | `DIM d(0 TO 9) AS I32` | |
| Eleman | `d(3) = 7` | Sınır dışı indeks **çalışma anı hatası** verir (`array index out of bounds`), üç yerel motorda da; **JS'te vermez**, okuma `0` döner ve yazma yok sayılır (G-HATA-6) |
| Sınırlar | `LBOUND(d)`, `UBOUND(d)` | |
| Yeniden boyutlandırma | `REDIM d(0 TO 19) AS I32` | Eski değerler **silinir** |
| Veriyi koruyarak | `REDIM PRESERVE d(0 TO 19) AS I32` | Eski değerler kalır, yeniler 0 olur |
| Çok boyutlu | `DIM m(1 TO 3, 1 TO 3) AS I32` | `m(i, j)` |
| Tüm elemanları gezmek | `FOR EACH v IN d` | Bölüm 7 |

{{ORNEK:43_kv_degisken/dizi_islemleri|baslik=Orta düzey: tablo ve büyüyen dizi}}

> **Dizi mi, LIST mi?** Boyutu başta belli ve elemanları aynı tipse **dizi** (hızlı, bellekte bitişik). Eleman sayısı sürekli değişiyorsa ve
> tip karışıksa **LIST** (Bölüm 10).

## 5.5 Kapsam

| Ad nerede tanımlı? | Nerede görünür? | Not |
|---|---|---|
| Dosyanın en üstünde (genel) | Dosyadaki bütün yordamlarda | Görevlerde otomatik senkron korumalıdır (Bölüm 15) |
| Yordamın içinde (yerel) | Yalnız o yordamda | Her çağrıda yeniden sıfırlanır |
| Yordam parametresi | Yalnız o yordamda | Genel adı **gölgeler** |
| `STATIC` yerel | Yalnız o yordamda | Değeri **çağrılar arasında korunur** |
| `MODULE` / `NAMESPACE` içinde | `Ad.üye` ya da `USING` ile | Bölüm 16 |

Yerel ya da parametre adı genel bir adla aynıysa **genel değişken değişmez**:

{{ORNEK:43_kv_degisken/kapsam_golge|baslik=Gölgeleme}}

`FOR` döngüsünün sayacı döngü bitince **son değerin bir adım ötesinde** kalır (`EXIT FOR` ile çıkılırsa çıkıldığı değerde):

{{ORNEK:43_kv_degisken/dongu_sayaci_sonrasi|baslik=Sayacın döngü sonrası değeri}}

`STATIC` bir yerel değişken, yordam bitse de değerini saklar:

{{ORNEK:06_rutin/static_yerel|baslik=STATIC yerel değişken}}

## 5.6 Benzerlerinden farkı

| İkili | Fark |
|---|---|
| `DIM` ve `CONST` | `DIM` değişir, `CONST` değişmez |
| `DIM` yerel ve `STATIC` yerel | `DIM` her çağrıda sıfırlanır, `STATIC` değerini korur |
| `REDIM` ve `REDIM PRESERVE` | Birincisi diziyi sıfırlar, ikincisi eski veriyi korur |
| `DIM` ve bildirimsiz atama | `DIM` tipi açıkça söyler (önerilir); bildirimsiz atama tipi değerden çıkarır (eski uyum) |
| Genel değişken ve `STATIC` | Genel değişkeni her yordam değiştirebilir, `STATIC` yalnız kendi yordamı |

## 5.7 Değişkenler ve diziyle ilgili programlama kararları

* Her değişkeni **`DIM ad AS TİP`** ile tanımlayın; bildirimsiz atamayı (`a = 7`) yeni kodda kullanmayın. Tanımsız adı okumak zaten hatadır.
* Değişkene **anlamlı ve kısa** bir ad verin (ASCII); döngü sayaçları (`i`, `j`) için bile `DIM i AS I32` yazın.
* **Metin değişkenlerine** her zaman ilk değer verin (`= ""`); AST'de başlangıç değeri `0` yazılır (G-DIL-4). Sayılar ve diziler sıfırla başlar; bunun çöp değer hatalarını önlediğine güvenin (eski AST-x64 yolunda rutin içindeki yerel değişkenler hariç: orada `DIM n AS I32 = 0` yazın, G-YORDAM-7).
* Değişmeyecek her değeri **`CONST`** yapın, ama **`CONST`'a asla yazmayın**: 20261007'de derleyici reddetmez, motorlar farklı davranırdı; 20261013 ve sonrasında açık hatadır (G-DIL-12, S-441). Dizi sınırını `CONST` ile verecekseniz x64'te **yalnız sayısal sabit** kullanın (G-DIL-1); sınır değişkense AST/MIR'de çalışır, x64 reddeder.
* `DIM a, b AS I32` ve `DIM d(3) AS I32 = {...}` yazımı yoktur: değişkenleri ayrı tanımlayın, diziyi döngüyle doldurun.
* Dizi tanımındaki sayı **üst sınırdır** (`DIM d(9)` on eleman). Alt sınırın 0 olmasına güvenmeyin; gerektiğinde `LBOUND`/`UBOUND` kullanın. Sınır dışı indeks çalışma anı hatasıdır; döngü sınırlarını diziden türetin (`FOR i = LBOUND(d) TO UBOUND(d)`).
* Büyüyen veri için **`REDIM PRESERVE`**; sıfırdan başlamak için `REDIM`. Eleman sayısı sürekli değişiyorsa ve tipler karışıksa dizi yerine **`LIST`** düşünün (Bölüm 10).
* Genel değişkeni **yalnız gerçekten paylaşılan durum** için kullanın; yordam parametresiyle genel adı aynı seçmeyin (gölgeleme yanlış anlaşılır). Çağrılar arasında değer saklayacaksanız `STATIC` yerel değişken kullanın.
* `FOR` sayacının döngüden sonra **son değerin bir adım ötesinde** kaldığını unutmayın; döngü dışında sayaca güvenmeyin.
