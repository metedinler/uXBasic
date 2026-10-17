# DATA / READ / RESTORE (etiketli) ve Python tarzı veri sabitleri: tasarım sözleşmesi

**Tarih:** 2026-10-15 · **Hazırlayan:** Claude (tasarım ve belgeleme) · **Karar sahibi:** Mete · **Durum:** tasarım onaylandı, **uygulanmadı** · **Uygulama:** Codex (kaynak) · **Doğrulama:** Claude (altı yolda, değer düzeyinde) · **Kayıtlar:** S-550 (`DATA`/`READ`/`RESTORE`), S-551 (veri sabitleri); ilgili: S-552 (`TUPLE`, `DATAFRAME`), S-326 (`CONST` adlı dizi sınırı), S-568 (dizi bildiriminde skaler başlangıç değeri), S-566/S-567 (etiket sınırları)

## 0. Mete'nin kararı

* İlk istek (2026-10-15): değişkenlere, dizilere ve `LIST`, `DICT`, `SET` gibi yapılara Python tarzı kodla, parantez, süslü parantez ve köşeli parantezle veri yazılabilsin; eski `DATA` / `READ` / `RESTORE` komutları da bu yapılara veri yerleştirmekte kullanılabilsin.
* Karar (2026-10-15, akşam; yazım düzeltilerek aktarılmıştır): "S-549 ve S-551 tasarımlarını onaylıyorum. `DATA`, `READ` ve `RESTORE` **etiket (label) tasarımlı** olsun ve **BASIC tarzı program içi verileri okuyabilsin**. Bu şekilde verileri `LIST`, `DICT`, `SET` içine aktarabiliriz, dizilerin verilerini de yükleyebiliriz. Üst yoğun kullanımda bilgiler zaten dosyalardan okunacak; bu BASIC uyumluluğu ve kolaylık sağladığı için olsun. Ayrıca bir dizi bilgiyi parantez içinde virgülle ayırarak ya da küme parantezi veya braketle yazarak `LIST`, `DICT` ve `SET` yapılarına kolayca yükleyebiliriz."
* S-551 tasarımı (onaylandı): sabitler **hedef tipe göre** yorumlanır (`DIM d AS DICT = { … }` bir sözlüktür).

## 1. Kapsam

| Var | Yok (ayrı karar ya da kayıt gerekir) |
|---|---|
| **Bölüm A:** etiketli `DATA` / `READ` / `RESTORE` (klasik BASIC) | `TUPLE` ve `DATAFRAME` tipleri (S-552; demet ayracı `( )` bu belgede ayrılmıştır) |
| **Bölüm B:** dizi, `LIST`, `DICT`, `SET` için sabit yazımı | `TYPE` kaydı sabiti (`{x: 1, y: 2}`), tür çıkarımı (`DIM y = [1, 2]`: dil bugün `DIM y = 5`i bile kabul etmez), `FOR EACH x IN [1, 2]` |
| Bölüm A ve B'nin altı yolda aynı davranışı | Dosyadan veri yükleme (zaten dosya kütüphaneleri vardır) |

## 2. Bugünkü durum (ölçüm: `bin\uxb_kilavuz_20261014_0253.exe`, altı yol, 2026-10-15)

| Konu | Sonuç |
|---|---|
| `DATA 10, 20, 30`, `READ a`, `RESTORE` | Altı yolda `UXB_CALL_PAREN_REQUIRED`: sözcükler anahtar sözcük değildir (S-550) |
| `data`, `read`, `restore` adlı değişken | **Çalışır**: `DIM data AS I32 = 5`, `data = 6`, `PRINT data` → `6` (altı yol). uXBasic kaynak ağacında (örnekler, testler, `libsx`) `data` kimlik olarak 6 test dosyasında geçer (hepsi `DECLARE … LIB` içinde `BYVAL data AS PTR` parametresi), `read` 2 test dosyasında (`METHOD Read()`), `restore` hiçbirinde; FreeBASIC ile yazılmış `runtime_ext` kaynakları bu sayıma girmez |
| `{ … }` | Sözcük çözümleyici hatası (`Lexer diagnostic bridge hata buldu: 2`, çıkış 2) |
| `[ … ]`, `( a, b )` | Ayrıştırma hatası |
| Ayraç içinde satır sonu | Ayrıştırma hatası; `_` ile satır devamı **çalışır** (`1 + _` ↵ `2` → `3`, altı yol) |
| Tür çıkarımı (`DIM y = 5`) | Ayrıştırma hatası: her bildirimde `AS tip` gerekir |
| `DIM a() AS I32` (boş parantez) | Ayrıştırma hatası |
| `DIM a(2) AS I32 = 7` | **Sessiz kusur** (S-568): AST, MIR, MIR-x64, JS değeri yok sayar; eski AST-x64 yalnız ilk elemanı doldurur; WASM yürütmede durur |
| Modül düzeyi etiket (`Son:` … `GOTO Son`) | Altı yolda çalışır (WASM yalnız metinsiz programda) |
| Rutin içi etiket | AST'de `GOTO target not found` (S-566); `RETURN` sonrası etiket derleme hatası (S-567) |
| Koleksiyonlar | Yalnız işlevlerle: `LISTADD`, `DICTSET`, `SETADD` (Bölüm 10.5); WASM'da bağsız (S-545) |

## 3. Bölüm A: `DATA`, `READ`, `RESTORE` (etiketli)

### 3.1 Yazım

```basic
DATA sabit [, sabit ...]
READ hedef [, hedef ...]
RESTORE [etiket]
```

### 3.2 Sözleşme

| # | Kural |
|---|---|
| **D1** | **`DATA` yalnız modül düzeyinde yazılır** (klasik BASIC geleneği). `SUB`, `FUNCTION`, `CLASS`, `MAIN` gövdesinde `DATA` derleme hatasıdır: `UXB_DATA_NOT_AT_MODULE_LEVEL`. `READ` ve `RESTORE` her yerde yazılabilir |
| **D2** | **Öğeler sabittir:** sayı (onluk, `&H`, `&B`, `&O`, ondalık, bilimsel `1.5E3`, işaretli `-5`), **tırnaklı** metin (`"…"`), `TRUE` / `FALSE`, bir `CONST` adı ya da derleme zamanında katlanabilen sabit ifade (`2 * 3`). Tırnaksız bir sözcük `CONST` adı değilse derleme hatasıdır (`UXB_DATA_ITEM_NOT_CONSTANT`); klasik BASIC'teki tırnaksız metin burada yoktur |
| **D3** | **Etiket:** `ad:` yazımı, `GOTO` etiketiyle **aynı yazım ve aynı ad alanı**. Etiket birden çok ardışık `DATA` satırının başında durabilir. Bir satır sonunda ya da (tırnak dışında) `:` karakterinde biter; `DATA` satırında `_` satır devamı çalışır |
| **D4** | **Veri akışı:** modüldeki bütün `DATA` öğeleri kaynak sırasıyla **tek bir akıştır**; etiket yalnız bir **giriş noktasıdır**. Blok sonu yoktur (klasik BASIC): bir etiketin öğeleri bitince okumaya devam edilirse bir sonraki etiketin öğeleri gelir. Veri işaretçisi program başında ilk öğededir |
| **D5** | **`READ`:** her hedef için sıradaki öğeyi okur, işaretçiyi bir ilerletir. Hedef: basit değişken, dizi elemanı (`a(i)`), `TYPE` alanı (`k.x`), nesne alanı |
| **D6** | **Dönüşümler** (öğe → hedef tipi), aşağıdaki tablo. Sessiz kesme ya da sessiz çevirme yoktur |
| **D7** | **`RESTORE`:** etiketsiz → işaretçi akışın başına. `RESTORE etiket` → işaretçi etiketten sonraki ilk öğeye; etiket **derleme zamanında** çözülür. Etiket yoksa `UXB_DATA_LABEL_UNKNOWN`, etiketten sonra hiç `DATA` yoksa `UXB_DATA_LABEL_EMPTY` (ikisi de derleme hatası) |
| **D8** | **Çalışma anı hataları** (altı yolda aynı tanı kodu, ileti anlamı ve çıkış durumu; S-409/S-410/S-500 sözleşmesi): akış bitmişken `READ` → `UXB_DATA_EXHAUSTED`; tür uyuşmuyor → `UXB_DATA_TYPE_MISMATCH`; sayı hedefe sığmıyor → `UXB_DATA_RANGE`. **Hiçbiri sessizce `0` ya da boş metin üretmez** (İlke 2) |
| **D9** | **Anahtar sözcük politikası (uyumluluk):** `DATA`, `READ`, `RESTORE` **deyim başı sözcüğüdür**. Bir deyimin ilk sözcüğüyse ve ardından `=` ya da `.` gelmiyorsa BASIC deyimidir; **başka her yerde sıradan addır** (parametre adı, alan adı, metot adı, ifade içi). Böylece bugün çalışan `data = 6`, `BYVAL data AS PTR`, `METHOD Read()` bozulmaz. `data(2) = 5` (dizi elemanı) ile `DATA (1 + 2), 3` ayrımı için kural: `data` adında bildirilmiş bir değişken ya da dizi kapsamdaysa deyim değişken kullanımıdır, değilse `DATA` deyimidir. Codex daha basit bir ayrım bulabilir; ölçüt D9'un yanındaki kabul programlarının bozulmamasıdır |
| **D10** | **Görevler:** `READ` / `RESTORE` tek paylaşılan işaretçiyi değiştirir. Görev gövdesinde (`THREAD`, `PARALEL`, `SPAWN` edilen rutin, `EVENT` işleyicisi) kullanımı ilk aşamada derleme hatasıdır: `UXB_DATA_IN_TASK` (görev başına işaretçi sonraki aşama) |
| **D11** | **`INCLUDE` ve modüller:** eklenen dosyanın `DATA` öğeleri açılımdan sonraki kaynak sırasına girer. Ayrı derlenen modülün (kütüphane) tablosu o modüle özeldir; bir modül başka modülün etiketine `RESTORE` edemez |
| **D12** | **Yüzey kaydı:** üç komut yüzey kaydına, ayrıştırıcı kapsam kapısına ve yetenek kapısına işlenir; Ek A'daki anahtar sözcük listesi güncellenir (`MOTOR_SORUMLULUK_VE_PARITE_SOZLESMESI`: her yeni komut için zorunlu kayıt) |

**D6 dönüşüm tablosu**

| `DATA` öğesi | Hedef tipi | Sonuç |
|---|---|---|
| tamsayı | `I8`…`I64`, `U8`…`U64` | atanır; hedef aralığı dışındaysa `UXB_DATA_RANGE` |
| tamsayı | `F32`, `F64` | atanır |
| ondalık | `F32`, `F64` | atanır |
| ondalık | tamsayı tipleri | `UXB_DATA_TYPE_MISMATCH` |
| metin | `STRING` | atanır |
| metin | sayı, `BOOLEAN` | `UXB_DATA_TYPE_MISMATCH` |
| sayı | `STRING` | `UXB_DATA_TYPE_MISMATCH` (`UXB_MIXED_STRING_NUMERIC` ruhu) |
| `TRUE` / `FALSE` | `BOOLEAN` ve tamsayı tipleri | `-1` / `0` olarak atanır |

### 3.3 Örnekler (◇ HEDEF; bugün derlenmez)

```basic
' Etiketli veri tabloları dosyanın düzeyinde yazılır
Renkler:
    DATA 3, "kirmizi", "yesil", "mavi"
Puanlar:
    DATA 2, "ali", 90, "veli", 75
Sayilar:
    DATA 10, 20, 30

DIM n AS I32
DIM i AS I32
DIM ad AS STRING
DIM p AS I32
DIM renkler AS LIST
DIM puan AS DICT
DIM kume AS SET
DIM a(2) AS I32

RESTORE Renkler          ' önce eleman sayısı, sonra elemanlar (sayı başlığı deseni)
READ n
FOR i = 1 TO n
    READ ad
    LISTADD(renkler, ad)
NEXT

RESTORE Puanlar          ' ad, puan çiftleri sözlüğe
READ n
FOR i = 1 TO n
    READ ad, p
    DICTSET(puan, ad, p)
NEXT

RESTORE Sayilar          ' diziye ve kümeye
FOR i = 0 TO 2
    READ a(i)
    SETADD(kume, a(i))
NEXT
```

Beklenen: `renkler` 3, `puan` 2, `kume` 3 öğeli; `a(0)`…`a(2)` = `10`, `20`, `30`.

### 3.4 Önerilen uygulama yolu (kısıt değil)

Bağlayıcı olan **gözlenebilir davranıştır** (3.2 ve 3.6); yol Codex'indir. Önerilen: ön uçta indirgeme. Bütün `DATA` öğeleri derleme zamanında modül düzeyi sabit tablolara toplanır (öğe türü, tamsayı/ondalık/metin değeri) ve bir genel veri işaretçisi tutulur; `RESTORE etiket` işaretçiyi etiketin tablo indisine eşitler (indis derleme zamanında bilinir); `READ hedef` önce akışın bitip bitmediğine, sonra öğe türünün hedef tipe uyup uymadığına bakar, atar ve işaretçiyi artırır. Böylece MIR, MIR-x64, JS ve WASM **yeni işlem kodu gerektirmeden**, var olan dizi ve atama işlemleriyle çalışır; AST aynı indirgemeyi kullanır.

### 3.5 Motor notları

| Yol | Not |
|---|---|
| AST, MIR, MIR-x64, eski AST-x64, JS | Sayı ve metin tabloları sorunsuz taşınır |
| WASM | **Metin** öğeleri WASM'ın doğrusal bellekte metin desteğine bağlıdır (bugün `WAT string linear-memory lowering is not implemented`); o gelene dek metin içeren `DATA` tabloları mevcut metin kapısının **açık iletisiyle** reddedilir, sessiz davranılmaz. Sayısal tablolar çalışır. Koleksiyon örnekleri WASM'da koleksiyon desteği gelene dek kapsam dışıdır (S-545 ailesi) |
| Eski AST-x64 | Eski AST-x64 dondurulmaz (Mete, 2026-10-14): aynı davranış beklenir; metin geçici halkası (S-157-L) metin `READ`'ini etkileyebilir, kabul programlarına eklenir |

### 3.6 Kabul ölçütleri (model testi paketi önerisi: `tests/data_read_restore/`)

1. Sayısal tablo: `RESTORE etiket`, `READ` zinciri; altı yolda aynı çıktı.
2. Metin ve karışık tablo (WASM hariç): çiftler, sayı başlığı deseni.
3. Dönüşümler: tamsayı → `F64` doğru; ondalık → `I32` `UXB_DATA_TYPE_MISMATCH`; metin → sayı hata; sayı → `STRING` hata; `I8`'e `300` `UXB_DATA_RANGE`.
4. Akış bitince `READ`: `UXB_DATA_EXHAUSTED`, aynı ileti ve çıkış durumu.
5. `RESTORE` etiketsiz ilk öğeye döner; bilinmeyen ve boş etiket derleme hatası.
6. **Bozulmayan programlar:** `DIM data AS I32 = 5 : data = 6 : PRINT data` → `6`; `DIM read AS I32` ve `DIM restore AS I32` aynı biçimde; `BYVAL data AS PTR` parametreli `DECLARE … LIB`; `METHOD Read()`.
7. Yorum içinde `DATA` (`' DATA 1`, `REM DATA 1`) yok sayılır (bugün de böyledir).
8. Dizi, `LIST`, `DICT`, `SET` yükleme örneği (3.3).
9. Rutin içinde `DATA` → `UXB_DATA_NOT_AT_MODULE_LEVEL`; görev gövdesinde `READ` → `UXB_DATA_IN_TASK`.
10. `INCLUDE` edilen dosyanın `DATA` sırası.

### 3.7 Sonraki aşama (isteğe bağlı genişlemeler; karar gerektirmez, sırası serbest)

* **Toplu okuma:** `READ dizi` (çıplak dizi adı) bütün elemanları sırayla doldurur. Dizi tamamının tek adla anılması bugün parametre geçirmede vardır (`a AS I32[]`, Bölüm 8.2); `a()` yazımı yoktur.
* **Koleksiyona toplu aktarma:** `READ … INTO koleksiyon, n` biçimi; ancak Bölüm B'nin sabitleri çoğu ihtiyacı karşılar.
* **Görev başına veri işaretçisi** (D10).

## 4. Bölüm B: Python tarzı veri sabitleri (S-551)

### 4.1 Biçimler

| Hedef tip | Kanonik yazım | Örnek | Hedef tipi bilinen yerde kabul edilen ayraçlar |
|---|---|---|---|
| Dizi | `{ a, b, c }` | `DIM a(2) AS I32 = {1, 2, 3}` | `{ }`, `( )`, `[ ]` |
| `LIST` | `[ a, b, c ]` | `DIM l AS LIST = [1, "iki", 3.5]` | üçü de |
| `SET` | `{ a, b, c }` | `DIM s AS SET = {1, 2, 3}` | üçü de |
| `DICT` | `{ k: v, … }` | `DIM d AS DICT = {"a": 1, "b": 2}` | üçü de (öğeler `k: v` çiftidir) |
| Demet (`TUPLE` gelince, S-552) | `( a, b, c )` | `(1, 2, 3)` | — |

### 4.2 Sözleşme

| # | Kural |
|---|---|
| **L1** | **Hedef tipe göre yorumlanır** (Mete'nin onayı). Hedef tip bilinen yerde (`DIM` başlangıç değeri, atama, tipi belli parametre ve dönüş değeri) üç ayraç da (`( )`, `{ }`, `[ ]`) hedefe uyar. Kanonik yazım belgelerde ve örneklerde kullanılır; diğer ayraçlar kolaylık içindir |
| **L2** | **İç içe öğede hedef bilinmez**, ayraç belirler: `[ ]` `LIST`, `{ k: v }` `DICT`, `{ a, b }` `SET`, `{ }` boş `DICT`, `( )` demet (demet tipi yokken `UXB_LITERAL_TUPLE_UNSUPPORTED`) |
| **L3** | Öğeler **ifadedir** (yalnız sabit olmak zorunda değildir) ve `DIM`/atama deyimi yürütülürken soldan sağa değerlendirilir |
| **L4** | **Dizi:** öğe sayısı bildirilen sayıya eşit olmalıdır, aksi `UXB_LITERAL_COUNT_MISMATCH`. Çok boyutlu dizide iç içe `{ }`, her iç küme bir satırdır (son indis en hızlı): `DIM m(1, 2) AS I32 = {{1, 2, 3}, {4, 5, 6}}`. Boş parantezli bildirim (`DIM a() AS I32`) bugün dilde yoktur; sınır çıkarımı bu belgenin kapsamı değildir |
| **L5** | Her dizi öğesi, dizinin öğe tipine **mevcut atama kurallarıyla** atanır (aralık ve tür denetimi, `UXB_MIXED_STRING_NUMERIC` aynen geçerli); uymazsa `UXB_LITERAL_ELEMENT_TYPE` |
| **L6** | **Koleksiyon sabiti yeni bir koleksiyon üretir** ve değişkene bağlar (eşdeğeri `LIST_NEW()` + `LISTADD(…)`). `l = [1, 2]` eski koleksiyonun içeriğini değiştirmez, `l`yi yeni koleksiyona bağlar. Koleksiyon öğesi, ifadenin kendi tipinde saklanır |
| **L7** | **`DICT`:** her öğe `anahtar: değer`; çift olmayan öğe `UXB_LITERAL_DICT_PAIR_EXPECTED`. Yinelenen **sabit** anahtar derleme hatasıdır: `UXB_LITERAL_DUPLICATE_KEY`. `SET`'te yineleme tek öğe olur (kümenin doğası) |
| **L8** | Sondaki virgül serbesttir (`[1, 2, 3,]`). **Ayraç açıkken satır sonu boşluk sayılır** (çok satırlı tablo yazımı); bugün satır sonu ayraç içinde ayrıştırma hatasıdır, `_` devamı çalışır. Yeni kural, ayraç derinliğini izleyen sözcük çözümleyici ister; ilk aşamada yalnız `_` ile devam da kabul edilebilir |
| **L9** | **`{ }` çakışmaları:** (a) *Ham büyük sayı sabiti* (`X = {3.14…}`, S-495): hedef bir **sayı** tipiyse ham sayıdır, hedef dizi ya da `SET` ise tek öğeli kümedir. (b) *Önişlemci yer tutucuları* (`%%ALIAS {a} AS {b}`): yalnız yönerge satırında ve önişlemci aşamasında işlenir; kod aşamasındaki `{ }` bundan etkilenmez |
| **L10** | **Hedefsiz kullanım** (örneğin `PRINT [1, 2]`, ya da tür çıkarımı gerektiren `DIM l = [1, 2]`) `UXB_LITERAL_NEEDS_TARGET` ile reddedilir |
| **L11** | Tek öğeli ayraçlı dizi için sondaki virgül gerekir (`(5,)`); `(5)` parantezli ifadedir |
| **L12** | Koleksiyonların mevcut sınırları geçerlidir (Bölüm 10.5: iç koleksiyonu değişkene geri almak, tipli koleksiyon, `TYPE` kaydı saklama). Sabit yalnız **kurar**, okuma kurallarını değiştirmez |
| **L13** | **Dizi bildirimindeki skaler başlangıç değeri** (`DIM a(2) AS I32 = 7`) bu tasarımla birlikte kesin bir anlam kazanmalıdır: önerilen davranış **açık ret** (`UXB_ARRAY_INITIALIZER_NEEDS_SERIES`); bugünkü sessiz davranış (S-568) kapatılır |

### 4.3 İndirgeme (öneri)

| Sabit | Eşdeğer çağrılar |
|---|---|
| `DIM l AS LIST = [1, "a"]` | `DIM l AS LIST` · `LISTADD(l, 1)` · `LISTADD(l, "a")` |
| `DIM d AS DICT = {"a": 1}` | `DIM d AS DICT` · `DICTSET(d, "a", 1)` |
| `DIM s AS SET = {1, 2}` | `DIM s AS SET` · `SETADD(s, 1)` · `SETADD(s, 2)` |
| `DIM a(2) AS I32 = {1, 2, 3}` | `DIM a(2) AS I32` · `a(0) = 1` · `a(1) = 2` · `a(2) = 3` |
| İç içe `[[1, 2], [3]]` | iç koleksiyonlar önce `LIST_NEW()` ile üretilir, sonra dış koleksiyona eklenir |

Ön uçta indirgendiği için altı yol aynı çalışır; bugünkü koleksiyon sınırlarını (G-KOLEKSIYON-1…7, WASM'da koleksiyon yok) devralır.

### 4.4 Tanı kodları (öneri; ileti anlamı ve çıkış durumu ortak)

`UXB_LITERAL_NEEDS_TARGET` · `UXB_LITERAL_COUNT_MISMATCH` · `UXB_LITERAL_ELEMENT_TYPE` · `UXB_LITERAL_DICT_PAIR_EXPECTED` · `UXB_LITERAL_DUPLICATE_KEY` · `UXB_LITERAL_TUPLE_UNSUPPORTED` · `UXB_ARRAY_INITIALIZER_NEEDS_SERIES`

### 4.5 Kabul ölçütleri (model testi paketi önerisi: `tests/veri_sabitleri/`)

1. Her biçim, kanonik yazımla altı yolda (WASM'da koleksiyonsuz olanlar) aynı çıktıyı verir: dizi, `LIST` (karışık tip), `DICT`, `SET`.
2. Üç ayraç da hedef tipe göre çalışır: `DIM l AS LIST = (1, 2, 3)` ve `= {1, 2, 3}` ile `= [1, 2, 3]` aynı listeyi kurar.
3. İç içe: `[[1, 2], [3]]`, `{"a": [1, 2]}`: iç öğede ayraç belirler.
4. Öğe sayısı uyuşmazlığı, tür uyuşmazlığı, çiftsiz `DICT` öğesi, yinelenen sabit anahtar, hedefsiz kullanım: ilgili tanı koduyla ve altı yolda aynı iletiyle reddedilir.
5. `{ }` çakışması: `DIM x AS BIGF = {3.14}` ham sayıdır, `DIM s AS SET = {3.14}` tek öğeli kümedir.
6. `DIM a(2) AS I32 = 7` açık hata verir (L13).
7. Çok satırlı yazım ayraç içinde (L8) ve `_` ile.
8. `%%ALIAS {a} AS {b}` önişlemci yönergesi bozulmaz.

## 5. Uygulama sırası ve ön koşullar

1. **Sözcük çözümleyici:** `{`, `}`, `[`, `]` belirteçleri (bugün `{` hata verir) ve ayraç içi satır sonu (L8).
2. **`CONST` adlı dizi sınırı MIR-x64'te** (S-326/G-DIL-1): `DIM a(N - 1) AS I32 = {…}` taşınabilir olsun diye; bugün MIR-x64 yalnız sayısal sabit sınır kabul eder.
3. **Dizi bildiriminde skaler başlangıç değeri** (S-568): L13 ile birlikte.
4. **Bölüm B** (S-551): ön uç indirgemesi.
5. **Bölüm A** (S-550): yüzey kaydı, anahtar sözcük politikası (D9), indirgeme, tanı kodları.
6. **Kitap:** Bölüm 10.5'in ◇ HEDEF kutusu ✔'ya çevrilir; örnekler altı yolda doğrulanır.

## 6. Mete'ye ait olmayan, benim koyduğum varsayılanlar (değişebilir)

Aşağıdakiler Mete'nin cümlelerinden **çıkarım** değildir; tasarımı tamamlamak için ben seçtim. Biri istenmiyorsa söylenmesi yeterlidir:

| # | Varsayılan | Neden |
|---|---|---|
| V1 | `DATA` yalnız modül düzeyinde | Klasik BASIC geleneği; etiket ve işaretçi tek yerde |
| V2 | Metin öğeleri tırnaklı | Tırnaksız metin "ad mı, metin mi" belirsizliği üretir |
| V3 | Tür uyuşmazlığı çalışma anı hatası (sessiz çevirme yok) | İlke 2: hata sessiz geçmez |
| V4 | `DATA` / `READ` / `RESTORE` deyim başı sözcüğü (tam ayrılmış sözcük değil) | Bugün çalışan 8 test dosyasını (6 + 2) ve kullanıcı programlarını bozmamak |
| V5 | Üç ayraç da hedef tipe göre kabul | Mete'nin cümlesi; iç içe öğede kanonik ayraç şart |
| V6 | Toplu okuma (`READ dizi`, `READ … INTO`) sonraya | Önce çekirdek; sabitler çoğu ihtiyacı karşılıyor |
| V7 | Blok sonu yok (akış sürekli) | Klasik BASIC davranışı |
| V8 | Dizi bildiriminde skaler başlangıç değeri açık ret | S-568: altı yolda dört ayrı davranış var; reddetmek en güvenlisi |
