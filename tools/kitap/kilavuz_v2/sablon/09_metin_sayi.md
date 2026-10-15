# 9. Metin ve sayı işlevleri

Bu bölüm, derleyicinin kayıt defterindeki **yerleşik işlevleri** (`--type-infer-report-csv-out` ile dökülen 77 kayıt ve ayrıca ayrıştırıcıda tanınan `HEX`, `OCT`, `BIN`, `FIX`,
`SPACE`, `STRING`) gruplar halinde anlatır. Aşağıdaki **her satır** çalıştırılarak sınanmıştır; üç yerel motorda (AST, MIR, x64) aynı sonucu vermeyenler ✖ ile işaretlidir.

## 9.1 Metin işlevleri

Metin indeksleri **1'den** başlar. Aşağıdaki örneklerde `s = "merhaba"` (ASCII) alınmıştır. Türkçe karakterli metinlerde `STRING` bayt temellidir (Bölüm 4.6).

| İşlev | Ne yapar? | Örnek | Sonuç |
|---|---|---|---|
| `LEN(s)` | Uzunluk (bayt) | `LEN("merhaba")` | 7 |
| `LEFT(s, n)` | Soldan n karakter; n uzunluğu aşarsa tamamı | `LEFT("merhaba", 3)` | `mer` |
| `RIGHT(s, n)` | Sağdan n karakter | `RIGHT("merhaba", 3)` | `aba` |
| `MID(s, b)` | b. karakterden sona kadar | `MID("merhaba", 4)` | `haba` |
| `MID(s, b, n)` | b. karakterden n karakter | `MID("merhaba", 2, 3)` | `erh` |
| `INSTR(a, s, x)` | **a. konumdan başlayarak** s içinde x'in konumu (yoksa 0) | `INSTR(3, "abcabc", "b")` | 5 |
| `INSTR(s, x)` | Baştan arama | `INSTR("merhaba", "ha")` | 4 |
| `UCASE(s)`, `LCASE(s)` | Büyük / küçük harf (yalnız ASCII harfler) | `UCASE("aBc")` | `ABC` |
| `TRIM(s)` | Baştaki ve sondaki boşlukları atar | `TRIM("  a b  ")` | `a b` |
| `LTRIM(s)`, `RTRIM(s)` | Yalnız baştaki / sondaki boşlukları atar | `LTRIM("  a ")` | `a ` |
| `SPACE(n)` | n boşluk | `SPACE(3)` | `   ` |
| `STRING(n, x)` | x'i n kez tekrarlar (x metinse ilk karakter, sayıysa kod) | `STRING(3, "xy")`, `STRING(2, 65)` | `xxx`, `AA` |
| `CHR(k)` | Kod → karakter | `CHR(72)` | `H` |
| `ASC(s)` | İlk karakterin kodu | `ASC("A")` | 65 |
| `STR(x)` | Sayıyı metne çevirir | `STR(7)` | `7` |
| `VAL(s)` | Metni sayıya çevirir; çeviremezse 0 | `VAL("12.5")` | 12.5 |
| `HEX(n)`, `OCT(n)`, `BIN(n)` | Onaltılık / sekizlik / ikilik gösterim | `HEX(255)`, `BIN(5)` | `FF`, `101` |
| `MID(s, b, n) = x` | Metnin **içine yazar** | `MID(s,2,2) = "XY"` | `aXYdef` (s = "abcdef") |

{{ORNEK:17_metin/len_mid_instr|baslik=LEN, MID, INSTR}}

**Dikkat — AST'de `INSTR` sonucu (G-METIN-4).** Konumla hesap yapacaksanız (`konum + LEN(parca)`) sonucu `CINT` ile sarın; aşağıdaki program AST, MIR ve x64'te aynı sonucu verir:

{{ORNEK:47_kv_metin/instr_konum_hesabi|baslik=Bir parçanın bütün konumlarını bulmak}}

{{ORNEK:17_metin/left_right_case|baslik=LEFT, RIGHT, UCASE, LCASE}}

{{ORNEK:17_metin/str_val_chr_asc|baslik=STR, VAL, CHR, ASC}}

{{ORNEK:17_metin/hex_oct_bin|baslik=HEX, OCT, BIN}}

{{ORNEK:17_metin/trim_space|baslik=LTRIM, RTRIM, SPACE}}

{{ORNEK:17_metin/mid_atama|baslik=MID ile metnin içine yazmak}}

### Birleştirme ve karşılaştırma

Metinler yalnız **`+`** ile birleşir (`&` bit VE'dir, Bölüm 6). Karşılaştırma işleçleri (`=`, `<`, `>` …) metinleri **sözlük sırasına** göre karşılaştırır ve -1/0 verir.
Sayıyı metinle birleştirmek için önce `STR(x)` yazılır: `"n=" + STR(5)`.

{{ORNEK:17_metin/birlestirme|baslik=Birleştirme}}

### Orta düzey örnekler

{{ORNEK:47_kv_metin/metin_analizi|baslik=Cümleyi çözümlemek: uzunluk, sesli harf, kelime}}

{{ORNEK:47_kv_metin/tersine_cevir|baslik=Metni ters çevirmek ve palindrom}}

{{ORNEK:47_kv_metin/ikilik_taban|baslik=Onluktan ikiliğe çevirmek}}

### Metin işlevlerinde bilinen sınırlar

| Sınır | Açıklama |
|---|---|
| ✖ G-METIN-1 | `MID(s, 0, n)`: başlangıç 0 verilirse AST hata verir (`MID start must be >= 1`), MIR boş, x64 `ab` döner. Başlangıcı hep 1 veya büyük verin |
| ✖ G-METIN-2 | `VAL("&HFF")`: AST ve MIR 255, x64 0 verir. Onaltılık metni elle çözün |
| ✖ G-METIN-3 | `INSTR(s, x, başlangıç)` (başlangıç **sonda**) çalışmaz; başlangıç her zaman **ilk** argüman olmalıdır |
| ✖ G-METIN-4 | **AST'de `INSTR` sonucu metin gibi davranır:** `k = INSTR("abc", "b")` sonra `k + 6` → `26`, `IF k = 2` yanlış çıkar (MIR/x64: `8`, doğru). Konumla hesap yapacaksanız `CINT(INSTR(...))` yazın |
| ✖ G-METIN-5 | `VAL("abc")` AST, MIR ve x64'te `0`, **JS'te `nan`** verir; `ASC(CHR(300))` AST'de hata, MIR ve x64'te `44` (300 mod 256), JS'te `300` verir. `CHR` argümanını 0..255 aralığında tutun, `VAL` sonucunu denetleyin |
| ✖ G-DIL-4 | İlk değeri verilmemiş `STRING` değişken AST'de `"0"` ile başlar. **Her zaman `= ""` yazın** |
| ✖ G-TIP-4 | Türkçe karakterlerde `LEN`/`LEFT`/`MID`/`ASC`/`UCASE` bayt temellidir |

## 9.2 Sayısal işlevler

| İşlev | Ne yapar? | Örnek | Sonuç | Dönüş tipi |
|---|---|---|---|---|
| `ABS(x)` | Mutlak değer | `ABS(-5)`, `ABS(-2.5)` | 5, 2.5 | Sayı |
| `SGN(x)` | İşaret (-1, 0, 1) | `SGN(-3)`, `SGN(0)`, `SGN(2.5)` | -1, 0, 1 | `I32` |
| `INT(x)` | **Aşağı** yuvarlar | `INT(2.7)`, `INT(-2.7)` | 2, -3 | `I32` |
| `FIX(x)` | Sıfıra doğru keser; **yalnız doğrudan `PRINT FIX(x)` içinde** (✖ G-TIP-18) | `FIX(2.7)`, `FIX(-2.7)` | 2, -2 | tür denetleyicisi için `TYPE_OBJECT`: değişkene atanamaz, aritmetiğe girmez |
| `CINT(x)`, `CLNG(x)` | En yakın tamsayı (yarım değer çifte) | `CINT(2.6)`, `CINT(2.5)` | 3, 2 | `I32` |
| `CSNG(x)`, `CDBL(x)` | `F32` / `F64`'e çevirir | `CDBL(1)` | 1 | |
| `SQR(x)`, `SQRT(x)` | Karekök | `SQR(16)`, `SQR(2)` | 4, 1.414213562373095 | `F64` |
| `SIN`, `COS`, `TAN`, `ATN` | Trigonometri (radyan); `ATN` = arktanjant | `ATN(1) * 4` | 3.141592653589793 | `F64` |
| `EXP(x)`, `LOG(x)` | e üssü / doğal logaritma | `EXP(0)`, `LOG(EXP(2))` | 1, 2 | `F64` |
| `RND` | [0, 1) aralığında rastgele sayı | `RND` | | `F64` |
| `RANDOMIZE n` | Rastgele sayı üretecini tohumlar | `RANDOMIZE 7` | | |
| `TIMER` | Saat ölçümü (saniye) | `TIMER >= 0` | -1 (yeni derlemelerde MIR-x64: `nan`, ✖ G-ISLEC-8) | `F64` |

{{ORNEK:18_matematik/temel|baslik=ABS, SGN, INT, FIX, SQR}}

{{ORNEK:18_matematik/trig_log|baslik=Trigonometri ve logaritma}}

{{ORNEK:18_matematik/rnd_randomize|baslik=RANDOMIZE ve RND}}

### Dilde olmayan, ama sık aranan işlevler

Aşağıdaki işlevler **yoktur**. Çağırırsanız AST/MIR çalışma anında `unsupported call`, x64 derlemede `CALL target ... is neither a known runtime call` hatası verir.
Yerine koyulacak yol sağdaki sütundadır (ya da standart kütüphane, Bölüm 20):

| Aranan | Yerine |
|---|---|
| `ROUND(x)` | `I64(INT(x + 0.5))` ya da `CINT(x)` (yarım değer çifte yuvarlar) |
| `FLOOR`, `CEIL` | `INT(x)` taban; tavan için `-INT(-x)` |
| `MIN(a, b)`, `MAX(a, b)` | `IFF(a < b, a, b)`, `IFF(a > b, a, b)` |
| `POW(x, y)` | `x ** y` |
| `LOG10(x)`, `LOG2(x)` | `LOG(x) / LOG(10)` |
| `ATAN2`, `PI` | `ATN` ile hesap; `PI = ATN(1) * 4`. Tam küme için `uxmath` kütüphanesi |
| `REPLACE`, `SPLIT`, `REVERSE`, `REPEAT`, `STARTSWITH`, `CONTAINS`, `FORMAT` | `MID`/`INSTR`/döngü ile (Bölüm 9.1 örnekleri); zengin işlevler için `uxregex`, `uxjson` |
| `DATE`, `TIME`, `NOW` | `uxdatetime` kütüphanesi |
| `SWAP a, b` | Geçici değişkenle takas (ya da `BYREF` ile `SUB`) |
| `SLEEP`, `ENVIRON`, `COMMAND`, `FRE` | `SHELL`, `uxsystem` kütüphanesi |
| `TAB(n)`, `SPC(n)` | `SPACE(n)` |

{{ORNEK:47_kv_metin/eksik_islevler|baslik=Eksik işlevleri kendimiz yazmak}}

> **Kayıtlı ama çalışmayan:** `VALINT` ve `CASTPTR`, tip kayıt defterinde bulunur ama çağrılınca `unsupported call` hatası verir. Yerine `CINT(VAL(s))` ve `VARPTR` kullanın. (✖ SINIR)

## 9.3 Dönüşümlerin özeti

Tip dönüşümleri ve `I32(x)` ailesi Bölüm 4.7'dedir. Kısa hatırlatma: **kesmek** için `I32(x)`/`FIX(x)`, **yuvarlamak** için `CINT(x)`, **aşağı almak** için `INT(x)`.

## 9.4 Benzerlerinden farkı

| İkili | Fark |
|---|---|
| `LEFT` ve `MID(s, 1, n)` | Aynı sonuç; `LEFT` daha okunaklı |
| `TRIM`, `LTRIM`, `RTRIM` | İki uç / yalnız baş / yalnız son |
| `SPACE(n)` ve `STRING(n, " ")` | Aynı; `STRING` istenen karakteri tekrarlar |
| `CHR` ve `ASC` | Kod → karakter / karakter → kod (birbirinin tersi) |
| `STR` ve `VAL` | Sayı → metin / metin → sayı (birbirinin tersi) |
| `INSTR(s, x)` ve `INSTR(a, s, x)` | Baştan arar / a. konumdan başlayarak arar |
| `SQR` ve `SQRT` | Aynı işlev (iki yazım) |
| `INT` ve `FIX` | Negatiflerde farklıdır: `INT(-2.7)` = -3, `FIX(-2.7)` = -2. `INT` sonucu `I32` değişkene atanır, `FIX` sonucu atanamaz (G-TIP-18) |
| `CINT` ve `INT` | En yakına yuvarlar / aşağı alır |

## 9.5 Metin ve sayı işlevleriyle ilgili programlama kararları

* **Metin indeksleri 1'den başlar.** `MID`'in başlangıcını hep 1 ya da büyük verin (`MID(s, 0, n)` motorlara göre hata, boş ya da farklı sonuç verir, G-METIN-1); `INSTR` konumları da 1'den sayılır, bulunamazsa 0 döner.
* **Başlangıçlı `INSTR`'de başlangıç ilk argümandır** (`INSTR(a, s, x)`; G-METIN-3). Konumla hesap yapacaksanız sonucu **`CINT(INSTR(...))`** ile sarın (AST'de `INSTR` sonucu metin gibi davranır, G-METIN-4); JS'te başlangıçlı `INSTR` kullanmayın (G-JS-6).
* Sayıyı metinle **`+` ile** birleştirin ve önce `STR(x)` yazın; `&` bit VE'dir.
* Metni sayıya `VAL(s)` ile çevirin, ama **onaltılık metni `VAL("&HFF")` ile çözmeyin** (x64'te 0 verir, G-METIN-2); basamakları elle çözün. Çevrilemeyen metin 0 verir: sayı olup olmadığını önceden denetleyin.
* **Dilde olmayan işlevleri** (`ROUND`, `MIN`, `MAX`, `POW`, `REPLACE`, `SPLIT`, `FORMAT`, `DATE` …) 9.2'deki karşılıklarıyla yazın (`CINT`, `IFF`, `**`, `MID`/`INSTR` döngüsü) ya da bir kütüphaneye (`uxregex`, `uxdatetime`) başvurun. `VALINT` ve `CASTPTR` kayıtlıdır ama çalışmaz.
* **Türkçe harfli metinde** `LEN`, `LEFT`, `MID`, `ASC`, `UCASE` bayt temellidir ve `UCASE`/`LCASE` yalnız ASCII harfleri çevirir (G-TIP-4); karakter sayısı için `FOR EACH`, büyük harf için kendi eşleme tablonuzu yazın.
* **Yuvarlamayı bilerek seçin**: `INT` aşağı, `FIX` sıfıra doğru, `CINT` en yakına (yarımda çifte). Para hesabını tamsayı (kuruş) ile yapın.
* Rastgele sayıyı `RANDOMIZE n` ile tohumlayın; `RND` [0, 1) aralığındadır. Tekrarlanabilir sınama için aynı tohumu kullanın. JS'te `RANDOMIZE` yürütme anında düşer (G-JS-7).
* Ondalıklı sonucu yazdırırken basamak sayısına güvenmeyin; biçim gerektiğinde sabit ondalıklı bir yardımcı işlev yazın (`F4(x)`), motor farklarına (JS, WASM) karşı kendi biçimlendiricinizi kullanın.
