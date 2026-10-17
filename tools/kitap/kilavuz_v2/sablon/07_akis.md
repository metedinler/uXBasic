# 7. Akış denetimi: koşullar ve döngüler

Program normalde satırları yukarıdan aşağıya çalıştırır. **Akış denetimi** yapıları bu sırayı değiştirir: koşula göre dallanır, işi tekrar eder, bir yere atlar.

## 7.1 Hızlı bakış

| İhtiyaç | Yapı | Bölüm |
|---|---|---|
| Koşula göre bir ya da birkaç yoldan birini seç | `IF` / `ELSEIF` / `ELSE` | 7.2 |
| Bir değeri birçok değerle karşılaştır | `SELECT CASE` | 7.3 |
| Belli sayıda tekrar | `FOR` ... `NEXT` | 7.4 |
| Koşul doğru olduğu sürece tekrar | `WHILE` ... `WEND`, `DO WHILE/UNTIL` ... `LOOP` | 7.4 |
| Gövde en az bir kez çalışsın | `DO` ... `LOOP WHILE/UNTIL` | 7.4 |
| Koleksiyonun her elemanı | `FOR EACH`, `DO EACH` | 7.5 |
| Döngüden çık / sonraki tura geç | `EXIT FOR/DO/WHILE`, `CONTINUE` | 7.4 |
| Etikete atla (eski biçim) | `GOTO`, `GOSUB` ... `RETURN` | 7.6 |
| Programı bitir | `END` | 7.7 |

## 7.2 Koşul: `IF`

{{ORNEK:01_akis/if_elseif|baslik=IF / ELSEIF / ELSE}}

* **Tek satırlık** biçimde `THEN` sonrası tek deyim yazılır: `IF a > 0 THEN PRINT "pozitif"`. `ELSE` de aynı satırda olabilir.
* `IF`'ten **erken çıkmak** için `EXIT IF` kullanılır.
* Koşul sıfırdan farklıysa doğrudur; `TRUE` zaten -1'dir.
* `THEN` yazılmazsa derleyici `missing THEN` hatası verir (derleme zamanı).

{{ORNEK:01_akis/if_tek_satir|baslik=Tek satırlık IF}}

{{ORNEK:01_akis/exit_if|baslik=EXIT IF}}

## 7.3 Çoklu seçim: `SELECT CASE`

`SELECT CASE`, tek bir ifadeyi (seçici) birkaç değerle karşılaştırır. İfade **bir kez** hesaplanır.

| `CASE` biçimi | Ne eşleşir? | Örnek |
|---|---|---|
| `CASE 3` | Tek değer | `CASE 3` |
| `CASE 1, 3, 5` | Değer listesi | `CASE "elma", "armut"` |
| `CASE 4 TO 6` | Aralık (uçlar dahil) | `CASE 90 TO 100` |
| `CASE IS > 8` | Karşılaştırma | `CASE IS <= 0` |
| `CASE 1 TO 3, 7 TO 9` | Aralıkların listesi | |
| `CASE ELSE` | Hiçbiri eşleşmezse | |

Seçici tamsayı, ondalıklı ya da metin olabilir. **İlk eşleşen** `CASE` çalışır; sonrakilere bakılmaz (başka dillerdeki "aşağı düşme" yoktur).

{{ORNEK:01_akis/select_case|baslik=IS karşılaştırması ve liste}}

{{ORNEK:01_akis/select_case_to|baslik=Aralık}}

{{ORNEK:01_akis/select_case_metin|baslik=Metinle SELECT CASE}}

## 7.4 Döngüler

| Yapı | Koşul nerede? | Gövde en az kaç kez? | Ne zaman? |
|---|---|---|---|
| `FOR i = a TO b [STEP s]` ... `NEXT` | Başta, sayaçla | 0 | Tekrar sayısı belli |
| `WHILE koşul` ... `WEND` | Başta | 0 | Koşul sürdükçe |
| `DO WHILE koşul` ... `LOOP` | Başta | 0 | `WHILE` ile aynı, `DO` biçimi |
| `DO UNTIL koşul` ... `LOOP` | Başta | 0 | Koşul **doğru olana kadar** |
| `DO` ... `LOOP WHILE koşul` | Sonda | **1** | En az bir kez çalışmalı |
| `DO` ... `LOOP UNTIL koşul` | Sonda | **1** | Koşul doğru olana kadar, en az bir kez |
| `DO` ... `LOOP` + `EXIT DO` | Gövdede | 1 | Karmaşık çıkış koşulları |

{{ORNEK:05_dongu/for_step|baslik=FOR, STEP ve geri sayım}}

{{ORNEK:05_dongu/do_while_until|baslik=Dört DO biçimi}}

* **`STEP`** adımdır; negatif olabilir (`FOR i = 9 TO 1 STEP -2`). Başlangıç bitişten büyük ve adım pozitifse gövde hiç çalışmaz.
* **Sayaç** döngü bitince son değerin bir adım ötesinde kalır (Bölüm 5.5).
* **`EXIT FOR`**, **`EXIT DO`**, **`EXIT WHILE`**: İçinde bulunulan en yakın döngüden çıkar. İç içe döngülerde yalnızca **iç** döngüyü bitirir.
* **`CONTINUE`**: Gövdenin kalanını atlayıp sonraki tura geçer. `FOR`, `WHILE`, `DO` döngülerinin hepsinde ve beş hedefte de çalışır.

{{ORNEK:05_dongu/continue|baslik=CONTINUE}}

{{ORNEK:05_dongu/exit_for_do|baslik=EXIT FOR ve EXIT DO}}

### Orta düzey örnekler

{{ORNEK:45_kv_akis/fizzbuzz|baslik=FizzBuzz: ELSEIF zinciri}}

{{ORNEK:45_kv_akis/elek_asal|baslik=Eratosthenes eleği: iç içe döngü ve STEP}}

{{ORNEK:45_kv_akis/collatz|baslik=Collatz: DO WHILE ve I64}}

### Dikkat edilecek sınırlar

| Konu | Durum |
|---|---|
| `EXIT SUB`, `EXIT FUNCTION` | ✖ SINIR: yoktur (`EXIT: expected FOR, DO, WHILE, IF`). Yordamdan çıkmak için `RETURN` kullanılır |
| `ON n GOTO a, b` | ✖ Yoktur (`ON` sözcüğü SLOT sistemine aittir) |
| `FOR x = 0 TO 1 STEP 0.25` (ondalıklı sayaç) | ✖ SINIR (G-AKIS-1): AST `FOR step cannot be zero` der; MIR ve x64 doğru çalışır |
| `FOR i = 1 TO n` içinde `n` değişirse | ✖ SINIR (G-AKIS-2): AST bitiş değerini **bir kez** hesaplar (doğru); MIR ve x64 her turda yeniden okur. Bitiş değerini değişkene almadan değiştirmeyin |
| `/' blok yorum '/` | ✖ Yoktur (Bölüm 3) |

## 7.5 Koleksiyon dolaşımı: `FOR EACH` ve `DO EACH`

`FOR EACH` bir kaynağın bütün elemanlarını sırayla alır. İkinci bir değişken verilirse 0'dan başlayan **sıra numarasını** da alır:
`FOR EACH x, i IN kaynak`.

| Kaynak | Her tur ne gelir? | Not |
|---|---|---|
| Dizi | Eleman | Tanımlı sırayla |
| `LIST` | Eleman | Eklenme sırasıyla |
| `SET` | Eleman | Benzersiz değerler |
| `DICT` | **Anahtar** | Değer için `DICTGET(d, anahtar)`. JS'te yürütme anında düşer: `host binding missing: DICTKEYAT` (`SET` için `SETMEMBERAT`; G-JS-7) |
| `STRING` **değişkeni** | Karakter (kod noktası) | Metin **sabiti** tek değer sayılır |
| Virgüllü değer listesi | Sırayla her ifade | `FOR EACH x IN 10, 20, 30` |

{{ORNEK:45_kv_akis/foreach_listeler|baslik=Beş farklı kaynak}}

### `FOR EACH` ile `DO EACH` aynı şey değildir

Virgüllü bir liste verildiğinde ikisinin **ne zaman hesaplama yaptığı** farklıdır:

| | `FOR EACH` | `DO EACH` |
|---|---|---|
| Liste ifadeleri | Gövdeden **önce**, hepsi birden hesaplanır (anlık görüntü) | **Sırası gelince** hesaplanır (canlı) |
| Gövde `a`'yı değiştirirse | Sonraki değerler eski `a` ile hesaplanmıştır | Sonraki ifade yeni `a`'yı görür |
| Kapanış | `NEXT` | `LOOP` |

{{ORNEK:23_tasarim/each_snapshot|baslik=FOR EACH: anlık görüntü (10, 15, 30)}}

{{ORNEK:23_tasarim/each_canli|baslik=DO EACH: canlı hesap (10, 105, 120)}}

{{ORNEK:23_tasarim/each_metin_kodnoktasi|baslik=Metin değişkeni karakter karakter gezilir}}

> **Kural:** Virgüllü `IN` listesi yalnızca **tek değerli (skaler) ifadelerden** oluşur. İki diziyi virgülle birleştirmek
> (`FOR EACH x IN a, b`, ikisi de dizi) derleme hatasıdır: `a comma-separated EACH list holds scalar values only`.

**◇ HEDEF (S-135, G-KOLEKSIYON-6):** Ortak yineleyici sözleşmesi (`ITER_CREATE` / `ITER_NEXT` / `ITER_CLOSE`), `MAGIC ITER` ile kullanıcı tanımlı yineleyiciler,
`CHAIN(a, b)` ve `ZIP(a, b)` ile çok kaynaklı gezinti ve `DO EACH` ile boru/akış/üretici gezintisi tasarlanmıştır; henüz yoktur. `FOR EACH x IN CHAIN(a, b)` AST'de "unsupported call CHAIN", MIR'de `RT_LIBRARY_CALL`, x64'te derleme hatası verir; `MAGIC ITER()` yazımı hata vermeden kabul edilir ama hiçbir şeye bağlanmaz (G-NESNE-14).

> **Sınır (G-KOLEKSIYON-3):** `FOR EACH v IN ifade` yalnız **düz bir koleksiyon değişkeniyle** güvenlidir. Kaynak bir işlev çağrısı (`LISTGET(dis, 0)`), bir nesne alanı (`s.urunler`) ya da koleksiyon olmayan bir nesne ise döngü hata vermez, kaynağın tutamacını **tek eleman** gibi gezer (AST tutamaç numarasını, MIR `ARRAY#1`, x64 nesne alanında erişim ihlaliyle çöker).

## 7.6 `GOTO` ve `GOSUB`

| Yapı | Ne yapar? | Durum (`20261014_0253`) |
|---|---|---|
| `GOTO etiket` | Etikete atlar (ileri ve geri) | ✔ AST, MIR, MIR-x64, JS; WASM'da ✔ (metinsiz, tamsayı programlarda) |
| `GOSUB etiket` ... `RETURN` | Etiketteki altprogramı çalıştırıp `RETURN` ile geri döner (iç içe de olur) | ✔ MIR, MIR-x64, JS; WASM'da ✔ (metinsiz programlarda); AST'de **döngü içinde yanlış** (✖ G-AKIS-4) |
| `RETURN` (önce `GOSUB` yapılmadan) | Hata olmalıdır | ✖ yollar ayrışır (G-AKIS-5) |
| `etiket:` | Etiket tanımı (satır başında, iki nokta ile) | |

{{ORNEK:01_akis/goto_etiket|baslik=GOTO}}

{{ORNEK:01_akis/gosub_return|baslik=GOSUB / RETURN}}

`20261007` ve öncesinde JS ve WASM bu yapıları taşımazdı: JS'te `GOSUB` ve geriye `GOTO` yürütme anında `UXB host binding missing: GOSUB` ve `LABEL` ile düşer, ileriye `GOTO` bile zaman aşımına uğrardı; WASM `GOSUB`'u "does not support GOSUB/RETURN" ile reddeder, etiketli `GOTO` için geçersiz WAT üretirdi (G-JS-9, G-JS-7'nin `GOSUB` kısmı ve S-123 böylece kapandı). `20261014_0253`'te beş yol da şu programlarda aynı sonucu verir: düz `GOSUB` (`4`), iç içe `GOSUB` (`111`), geriye atlayan `GOTO` ile sayaç döngüsü (`5`) ve ileriye `GOTO` (`1`). WASM'ın genel sınırı burada da geçerlidir: **metin** içeren program derlenmez (`PRINT "once"` gibi), bu yüzden `gosub_return` örneği WASM'da açık ret alır, `GOSUB` yüzünden değil.

> **✖ SINIR (G-AKIS-4, yalnız AST):** Bir döngünün içinden `GOSUB` çağırırsanız AST'de `RETURN` **döngüyü de bitirir**; hata ve uyarı yoktur.
> ```
> DIM i AS I32
> DIM t AS I32 = 0
> FOR i = 1 TO 3
>     GOSUB Ekle
> NEXT
> PRINT t
> END
> Ekle:
>     t = t + i
> RETURN
> ```
> Beklenen `6`; AST `1` yazar, MIR, MIR-x64, JS ve WASM `6` yazar. `DO WHILE` ve `WHILE … WEND` içinde de aynıdır. Döngü dışındaki `GOSUB` ve alt programın kendi içindeki döngü doğrudur.
>
> **✖ SINIR (G-AKIS-5):** Önceden `GOSUB` yapılmamış bir `RETURN` her yolda başka davranır: AST `exec: RETURN used without GOSUB (9301)` ile durur (çıkış 5); MIR, MIR-x64, JS ve WASM **sessizce** biter (çıkış 0, ileti yok, sonraki satırlar çalışmaz); eski AST-x64 erişim ihlaliyle çöker. Her `RETURN`'ün bir `GOSUB`'tan geldiğinden emin olun; ana akışı etiketlerden `END` ile ayırın.
>
> **✖ SINIR (G-AKIS-6, yalnız AST):** Etiketi ve `GOTO`yu bir `SUB` **içinde** yazarsanız AST `exec: GOTO target not found` ile durur (çıkış 5); MIR, MIR-x64, eski AST-x64, JS ve WASM doğru çalışır (`SUB` içinde ileriye ve geriye `GOTO`: `2` ve `3`). Modül düzeyindeki etiket altı yolda çalışır. **Etiketleri modül düzeyinde kullanın**; etiketli `DATA` tasarımı da böyledir (Bölüm 10.5).
>
> **✖ SINIR (G-AKIS-7):** Bir `RETURN` satırından hemen sonra gelen etiketli satır, `GOTO` ile ulaşılabilir olsa da altı yolda `semantic: unreachable statement after RETURN_STMT` ile reddedilir (`PRINT` sonrasında etiket reddedilmez). Etiketten önceki `RETURN`'ü bir `IF` içine alın.

> **Tavsiye:** Yeni kodda `GOTO`/`GOSUB` yerine döngü, `IF` ve `SUB` kullanın. `GOSUB`'u en azından bir döngünün içinden çağırmayın (G-AKIS-4).

## 7.7 `END`

`END` programı **her yerden** bitirir; bir yordamın içinden çağrılsa bile (AST, MIR ve x64'te sınandı; **JS'te** `END` yürütme anında `host binding missing: PROGRAM_END` ile düşer, G-JS-7). Görev (`THREAD`) zincirinde `END` **yasaktır**: görev `RETURN` ya da `THROW`
ile biter (Bölüm 15).

## 7.8 Benzerlerinden farkı

| İkili | Fark |
|---|---|
| `FOR` ve `WHILE` | `FOR` sayaçlıdır, tekrar sayısı baştan bellidir; `WHILE` yalnızca koşula bakar |
| `WHILE ... WEND` ve `DO WHILE ... LOOP` | Aynı davranış, iki yazım. `WHILE/WEND`'de `EXIT WHILE`, `DO` biçiminde `EXIT DO` |
| `DO WHILE ... LOOP` ve `DO ... LOOP WHILE` | Koşul başta (0 kez çalışabilir) / sonda (en az 1 kez çalışır) |
| `WHILE` ve `UNTIL` | `WHILE` doğru olduğu sürece; `UNTIL` doğru olana **kadar** |
| `EXIT` ve `CONTINUE` | Döngüden tamamen çık / yalnız bu turu atla |
| `SELECT CASE` ve `IF/ELSEIF` | Tek ifadeyi çok değerle karşılaştırırken `SELECT CASE` daha okunaklı; farklı koşullar için `IF` |
| `FOR EACH` ve `FOR` | `FOR EACH` kaynağın sınırını kendisi bilir; `FOR` indeksi sizin yönettiğiniz sayaçtır |
| `FOR EACH` ve `DO EACH` | Anlık görüntü / canlı hesap (7.5) |
| `GOTO` ve `GOSUB` | `GOTO` geri dönüşsüz atlar; `GOSUB` `RETURN` ile geri döner |
| `END` ve `EXIT` | `END` programı bitirir; `EXIT` yalnız döngüden/`IF`'ten çıkar |

## 7.9 Hangisini ne zaman?

| Durum | Seç |
|---|---|
| "10 kez yap" | `FOR i = 1 TO 10` |
| "Dosya bitene kadar oku" | `DO WHILE NOT EOF(1)` ... `LOOP` |
| "Kullanıcı doğru girene kadar sor" | `DO` ... `LOOP UNTIL gecerli` |
| "Her elemana bir şey yap" | `FOR EACH` |
| "Listeye bak, ilk bulunca çık" | `FOR EACH` + `EXIT FOR` |
| "Not aralığına göre harf ver" | `SELECT CASE` + `TO` |

## 7.10 Akış denetimiyle ilgili programlama kararları

* **Tekrar sayısı belliyse `FOR`**, koşul sürdükçe tekrarlanacaksa `WHILE`/`DO WHILE`, gövde **en az bir kez** çalışmalıysa `DO … LOOP UNTIL` kullanın.
* Bir ifadeyi çok değerle karşılaştırıyorsanız **`SELECT CASE`** yazın: seçici bir kez hesaplanır, ilk eşleşen `CASE` çalışır ("aşağı düşme" yoktur); aralık için `CASE 90 TO 100`, karşılaştırma için `CASE IS < 0`.
* Yordamdan erken çıkmak için **`RETURN`** yazın; `EXIT SUB`/`EXIT FUNCTION` yoktur. `EXIT FOR/DO/WHILE` yalnız en yakın (iç) döngüyü bitirir; çok katlı çıkış için bir **bayrak değişkeni** kullanın.
* Yeni kodda **`GOTO`/`GOSUB` yazmayın**; döngü, `IF` ve `SUB` kullanın. `GOSUB`'u bir döngünün içinden çağırmayın (AST'de `RETURN` döngüyü bitirir, G-AKIS-4) ve her `RETURN`'ün bir `GOSUB`'tan geldiğinden emin olun (G-AKIS-5). `20261007` ve öncesinde JS'e gidecek programda geriye `GOTO` sonsuz döngü üretir, `GOSUB` yürütme anında düşerdi; `20261014_0253`'te her ikisi de çalışır.
* **`FOR` döngüsünün bitiş değerini gövdede değiştirmeyin** (G-AKIS-2): AST bir kez, MIR ve x64 her turda okur. Bitişi bir değişkene alıp dokunmayın.
* **Ondalıklı sayaç** (`STEP 0.25`) yerine tamsayı sayaç kullanın, ölçeği hesapta uygulayın (G-AKIS-1).
* Koleksiyonu gezerken **`FOR EACH`** yazın; kaynağın sınırını kendisi bilir. `DICT` gezerken her tur **anahtar** gelir. Virgüllü `IN` listesi yalnız skaler ifade içerir.
* Gövde, liste ifadelerinin kullandığı değişkeni değiştiriyorsa **`FOR EACH` (anlık görüntü)** ile **`DO EACH` (canlı)** farkını bilerek seçin.
* `END` programı her yerden bitirir; **görev içinde yazmayın** (görev `RETURN` ya da `THROW` ile biter).
* Sayaç değişkenini her zaman `DIM` ile tanımlayın; döngüden sonra sayacın değerine güvenmeyin.
