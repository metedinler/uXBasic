# 13. Dosya, konsol ve süreç işlemleri

## 13.1 Konsol: `PRINT`, `INPUT`, `CLS`, `COLOR`, `LOCATE`

| Komut | Ne yapar? | Not |
|---|---|---|
| `PRINT öğe; öğe` | Ekrana yazar; `;` bitişik, `,` 14 sütunluk bölgelere hizalar, sondaki `;` satır sonunu bastırır | Bölüm 3 |
| `INPUT [istem,] değişken` | Klavyeden bir satır okur: `INPUT "Ad: ", ad` | Deyimdir (✔ üç motorda). `s = INPUT("istem")` işlev biçimi AST'de yoktur |
| `CLS` | Ekranı siler | ✔ |
| `COLOR ön, arka` | Yazı ve zemin rengi (0-15) | ✔ |
| `LOCATE satır, sütun` | İmleci konumlar | ✔ |
| `INKEY`, `GETKEY` | Tuş okur (beklemeden / bekleyerek) | ? DENENMEDİ (etkileşimli) |
| `TIMER` | Saniye cinsinden saat ölçümü | ✔ |

{{ORNEK:12_ekran/cls_color_locate|baslik=CLS, COLOR, LOCATE}}

{{ORNEK:11_io/print_virgul|baslik=PRINT virgül bölgeleri}}

## 13.2 Metin dosyaları

Dosya **kanal numarası** (`#1`) ile açılır, yazılır ya da okunur, sonra kapatılır.

| Komut | Anlamı |
|---|---|
| `OPEN "ad" FOR OUTPUT AS #n` | Yazmak için aç (dosya sıfırlanır) |
| `OPEN "ad" FOR APPEND AS #n` | Sonuna eklemek için aç |
| `OPEN "ad" FOR INPUT AS #n` | Okumak için aç (dosya yoksa AST ve MIR durur; **x64 hata vermez**, G-DOSYA-5) |
| `PRINT #n, öğe` | Dosyaya bir satır yaz |
| `INPUT #n, değişken` | Dosyadan bir satır oku. (`INPUTF #n, …` yoktur: deyim kaydında bulunur ama sözcük tablosunda yoktur, işlev çağrısı sanılıp `UXB_CALL_PAREN_REQUIRED` ile reddedilir, G-DOSYA-6) |
| `EOF(n)` | Dosya sonu mu? (-1 / 0) |
| `LOF(n)` | Dosya boyutu (bayt) |
| `CLOSE #n` | Kanalı kapat |

* Kanal numarası bir değişkenle de verilebilir: `OPEN "x" FOR OUTPUT AS #f`. Numara bir `I32` değişkenden, bir `TYPE` alanından (`AS #k.no`) ya da ifadeden (`AS #(1 + 1)`) gelebilir; AST, MIR, x64 ve eski AST-x64'te ölçüldü (`20261014_0253`).
* **Tipli dosya tutamacı (◇ HEDEF, tasarım onaylandı 2026-10-15, G-DOSYA-10, S-549):** `DIM f AS FILE_HANDLE` gerçek bir tip olacak; `OPEN "x" FOR OUTPUT AS f` boş bir kanal numarasını kendisi seçip `f`ye verecek; `PRINT #f`, `INPUT #f`, `EOF(f)`, `LOF(f)` ve `CLOSE f` hem tutamaçla hem eski `#n` sayısıyla çalışacak; tutamaç bir `TYPE` alanı da olabilecek ve `#n` yazımı bozulmayacak. Bugün `DIM f AS FILE` `unknown type: FILE`, `DIM f AS FILE_HANDLE` bir ayrıştırma hatasıyla reddedilir; `OPEN "x" FOR OUTPUT AS f` (`#` işaretsiz) ve `f = OPEN(…)` biçimleri yoktur. `FILE_HANDLE`, tasarımın 35 kanonik tipinden biridir (G-TIP-8). Sözleşme: `docs/tasarim/UXB_S544_S549_S564_DECLARE_DOSYA_TUTAMACI_NULL_20261015_TR.md` Bölüm 2.
* **`FREEFILE` (◇ HEDEF, tasarım onaylandı, G-DOSYA-9, S-548):** boş kanal numarasını döndürecek (`TIMER` gibi parantezsiz); bugün yoktur, numaraları kendiniz dağıtın.
* **Dosyadan okunan her şey metindir**; sayı gerekiyorsa `CINT(VAL(satir))` ile çevrilir (bkz. örnek).
* Kapatılmamış bir dosya program bitince sessizce bırakılır; `CLOSE` her zaman yazın.

{{ORNEK:11_io/dosya_yaz_oku|baslik=Yazıp okumak}}

{{ORNEK:11_io/eof_lof|baslik=EOF ve LOF}}

{{ORNEK:51_kv_dosya/dosya_toplam|baslik=Orta düzey: sayıları dosyaya yazıp okuyarak toplamak}}

### Dosya işleminde bilinen sınırlar

| Sınır | Açıklama |
|---|---|
| ✖ G-DOSYA-1 | `INPUT #n, sayiDegiskeni`: AST yalnız tamsayı okur (`F64` değişkende `2.5` → `2`), x64'te sayı değişkenine okuma bozuktur. **Metin okuyup `VAL` ile çevirin** |
| ✖ G-DOSYA-2 | İkili dosya (`FOR BINARY`, `GET`, `PUT`, `SEEK`) yalnız AST'de çalışır; MIR `RT_LIBRARY_CALL`, x64 yanlış sonuç verir |
| ✖ G-DOSYA-3 | Kanalsız `CLOSE`: AST kabul eder, MIR `CLOSE channel required` der, x64 derlemez |
| ✖ G-DOSYA-4 | Yoktur: `LINE INPUT`, `FREEFILE`, `KILL`, `MKDIR`, `NAME`, `DIR`, `WRITE #` |
| ✖ G-DOSYA-5 | **Olmayan dosya:** `OPEN … FOR INPUT` AST'de FreeBASIC'in ham iletisiyle (`Aborting due to runtime error 2 (file not found)`, çıkış 2) ve MIR'de `file open failed … err=2` (13) ile durur; **x64 hiçbir hata vermeden devam eder** (`EOF` `-1` döner). Olmayan klasöre `OPEN … FOR OUTPUT` de x64'te sessizce yutulur. Dosyanın varlığını `OPEN`'dan **önce** `uxfs.FileExists` ile denetleyin |

Dosya silme, dizin oluşturma, dosya arama gibi işler için `uxfs` ve `uxpath` kütüphanelerini ya da `SHELL`'i kullanın (Bölüm 20).

## 13.3 Dış komut: `SHELL`

`SHELL "komut"` bir işletim sistemi komutu çalıştırır. İsteğe bağlı sözcüklerle çıktı ve çıkış kodu yakalanır:

| Seçenek | Anlamı |
|---|---|
| `OUTVAR değişken` | Standart çıktıyı metin değişkenine alır (sonunda satır sonu karakterleri bulunur) |
| `ERRVAR değişken` | Hata çıktısını alır |
| `CODEVAR değişken` | Çıkış kodunu alır |
| `TIMEOUT ms` | En çok bekleme süresi (milisaniye) |
| `RUNPATH`, `OUTPATH`, `ERRPATH` | Çalışma klasörü ve çıktı dosya yolları |

{{ORNEK:14_shell/shell|baslik=SHELL ve OUTVAR}}

{{ORNEK:51_kv_dosya/shell_cikti|baslik=Çıktı ve çıkış kodunu almak}}

> **Güvenlik:** `SHELL`'e kullanıcıdan gelen metni doğrudan vermeyin. Komut enjeksiyonu (kullanıcının ek komut sokması) en sık yapılan hatalardan biridir.

## 13.4 Benzerlerinden farkı

| İkili | Fark |
|---|---|
| `PRINT` ve `PRINT #n` | Ekrana / kanal `n`'deki dosyaya |
| `FOR OUTPUT` ve `FOR APPEND` | Dosyayı sıfırlar / sonuna ekler |
| `EOF` ve `LOF` | Sona geldik mi? / dosya kaç bayt? |
| `OUTVAR` ve `CODEVAR` | Komutun yazdığı metin / komutun çıkış kodu |
| `SHELL` ve `CALL(DLL, ...)` | Ayrı bir süreç çalıştırır / aynı süreçte kütüphane işlevi çağırır (Bölüm 16) |

## 13.5 Dosya, konsol ve süreç işlemleriyle ilgili programlama kararları

* **Her `OPEN` için bir `CLOSE #n` yazın**; kanal numarasını bir değişkenle de verebilirsiniz. Kanalsız `CLOSE` yazmayın (G-DOSYA-3).
* Yazma kipini amaca göre seçin: `FOR OUTPUT` dosyayı sıfırlar (rapor, çıktı), `FOR APPEND` sonuna ekler (günlük). Okuyacağınız dosyanın var olduğundan **önceden** emin olun (`uxfs.FileExists`): `OPEN ... FOR INPUT` dosya yoksa AST ve MIR durur ama x64 sessizce devam eder (G-DOSYA-5).
* **Dosyadan sayıyı doğrudan sayı değişkenine okumayın** (G-DOSYA-1). Satırı `STRING` değişkene alın, `VAL` ve `CINT`/`CDBL` ile çevirin.
* **Yalnız metin dosyası kullanın**: ikili dosya (`BINARY`, `GET`, `PUT`, `SEEK`) yalnız AST'de çalışır (G-DOSYA-2). Dosya silme, dizin oluşturma ve arama için `uxfs`/`uxpath` kütüphanelerini ya da `SHELL`'i kullanın (G-DOSYA-4).
* **`SHELL`'e kullanıcıdan gelen metni vermeyin** (komut enjeksiyonu). Çıktıyı `OUTVAR`, hatayı `ERRVAR`, çıkış kodunu `CODEVAR` ile alın ve **çıkış kodunu denetleyin**; uzun sürebilecek komutlara `TIMEOUT` verin.
* JS hedefliyorsanız dosya G/Ç'si ve `SHELL ... OUTVAR` yürütme anında reddedilir (G-JS-7); WASM için doğrulanmış örnek yoktur. Bu işleri x64 tarafında yapıp sonucu programa veri olarak verin.
* Konsol çıktısını tablo gibi hizalayacaksanız `PRINT a, b` virgül bölgelerine güvenmeyin: JS'te yürütme anında reddedilir (G-JS-8). `;` ile yazın, boşlukla kendiniz hizalayın.
* `INPUT` deyim biçimiyle yazılır (`INPUT "Ad: ", ad`); etkileşimli (girdi bekleyen) programları otomatik testte çalıştırmayın, girdi gelmezse program bekler.
* Süre ölçmek için `TIMER` kullanın; ölçümü iki `TIMER` farkı olarak alın, tek değeri anlamlı saymayın.
