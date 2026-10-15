# 10. Veri yapıları

Bir **veri yapısı**, birden çok değeri düzenli bir biçimde bir arada tutar. Bu bölümde dizi dışındaki yapıları anlatıyoruz (diziler Bölüm 5.4'te).

## 10.1 Hızlı bakış ve seçim rehberi

| İhtiyaç | Yapı | Eleman tipi | Sayısı | Anahtar |
|---|---|---|---|---|
| Aynı tipten sabit sayıda değer | Dizi | Tek tip | Önceden bilinir (`REDIM` ile değişir) | Sıra numarası |
| Farklı tipte alanlar, tek varlık | `TYPE` | Her alanın kendi tipi | Sabit | Alan adı |
| Dış dünya (DLL) ile birebir bellek düzeni | `STRUCT` / `UNION` | Her alanın kendi tipi | Sabit | Alan adı |
| Adlandırılmış sabitler | `ENUM` | Tamsayı | Sabit | Üye adı |
| Büyüyen değer listesi | `LIST` | Karışık | Değişir | Sıra numarası |
| Anahtar → değer eşlemesi | `DICT` | Karışık | Değişir | Anahtar (metin ya da sayı) |
| Benzersiz değer kümesi | `SET` | Karışık | Değişir | Değerin kendisi |
| Veri + davranış | `CLASS` | Alanlar + metotlar | Sabit | Bölüm 11 |

## 10.2 `TYPE`: kayıt

`TYPE`, farklı tipte alanları tek bir adla toplar. Alanlara `ad.alan` ile erişilir. `TYPE` bir **değer tipidir**: atama kopyalar.

{{ORNEK:07_yapi/type|baslik=TYPE: kayıt dizisi}}

{{ORNEK:48_kv_veri/kayit_siralama|baslik=Orta düzey: kayıtları yaşa göre sıralamak}}

| Konu | Durum |
|---|---|
| İç içe `TYPE` (`c.a.x`) | ✔ |
| `TYPE` dizisi, alan erişimi (`k(i).alan = …`, `k(i).alan` okumak) | ✔ AST, MIR, x64 (sayısal ve `STRING` alanlı, **değişken indisle**); JS yürütme anında reddeder (`ARRAY_FIELD_STORE`, G-JS-7). Sabit indisle yazıp sabit indisle okumak x64 ve JS'te derlenmez (✖ G-VERI-7) |
| `b = a` (kayıt kopyası) | ✔ dört motorda; iç içe kayıtta kopya **derindir** (`q = p` sonrası `q.a.x = 9` `p.a.x`'i değiştirmez) |
| `TYPE` içinde sayısal dizi alanı (`v(2) AS I32`) | ✖ Reddedilir (`left side is not writable: CALL_EXPR`) |
| `TYPE` içinde kayıt dizisi alanı (`kose(3) AS Nokta`) | ✖ SINIR (G-VERI-8): nedeni söylemeyen bir "explicit cast" hatasıyla reddedilir |
| `WITH` bloğu | ✖ Yoktur |
| `FUNCTION ... AS TYPE` (kayıt döndüren işlev) | ✖ SINIR (G-VERI-3): bugün alanlar sıfırlanır (hiçbir motorda doğru değildir). `BYREF` çıkış parametresi kullanın |
| Kaydı işleve **değerle** geçirmek (`T(a)`) | ✖ SINIR (G-VERI-6): AST/MIR `0`, JS `nan` okur, x64 derlemez. **Alanları ayrı parametre** olarak verin (`T(a.x, a.y)` dört motorda doğrudur) |
| `BYREF` kayıt parametresi | ✖ SINIR (G-VERI-2): AST doğru, MIR ve JS değişikliği görmez, x64 derlemez |
| Kayıt dizisinde eleman takası (`t = k(j)`, `k(j) = k(j+1)`) | ✖ SINIR (G-VERI-1): AST'de etkisiz, MIR doğru, x64 yalnız sayısal alanlıda doğru (`STRING` alanlıysa `element width unsupported: 16`). Örnekteki gibi **alanları tek tek** takas edin |
| Kayıt dizisi iki boyutlu (`m(1,1) AS Hucre`) | ✖ MIR, x64 ve JS `indexed field root expects one index` ile reddeder |

## 10.3 `STRUCT` ve `UNION`: bellek düzeni belli yapılar

`STRUCT`/`UNION`, dış kütüphanelerle (DLL) konuşurken **alanların bellekteki yerini** belirler: `ABI C` C uyumu, `PACK n` hizalama sınırı. `UNION`'da bütün alanlar aynı belleği paylaşır **ve boyut en büyük alana göre belirlenir** (aşağıdaki örnek `SIZEOF`'u gösterir). Ama alanları gerçekten **üst üste bindirmek** (bir alana yazıp başka alandan okumak) 20261007 ikilisinde yalnız AST'de çalışırdı: MIR `0`, JS `undefined` okur, x64 derlemezdi (✖ SESSİZ, G-VERI-11). 20261013 ve sonrasında (S-442) MIR, x64 ve JS de aynı belleği paylaşır: `u.i = 258` sonra `u.b` (`U8`) dört motorda `2` verir; `I64`/`I32`, `F32`/`I32` ve `F64`/`I64` çiftleri de AST ile aynı sonucu verir. WAT/WASM'da 20261007 ikilisi `UNION` alanı kullanan programı geçersiz WAT üretip `wat2wasm` hatasıyla düşürürdü (çıkış 23: `undefined local variable "$U_BAY"`); 20261013_1704'te ofset 0'daki 1, 2 ve 4 baytlık tamsayı alanlar çalışır (`u.tam = 258` sonra `u.bay` → `2`, MIR ile aynı), 8 baytlık `I64` alanı ise `WASM UNION_FIELD_STORE supports only 1, 2 or 4 byte integer fields` ile açıkça reddedilir (çıkış 23).
`SIZEOF(tip)` boyutu, `OFFSETOF(tip, "alan")` alanın ofsetini verir.

{{ORNEK:07_yapi/struct_union|baslik=STRUCT, UNION, PACK, OFFSETOF}}

> `UNION` içinde dizi alanı bugün çalışmaz (✖ G-VERI-5): `bayt(3) AS U8` gibi alan `method call on a null object reference` hatası verir.

> **ABI ve PACK nereye yazılır? (G-VERI-10)** Çalışan yazım ABI ve PACK'in **başlık satırında** olmasıdır: `STRUCT Paket ABI C PACK 1`. Tasarım kılavuzundaki gövdede satır satır yazım (`ABI CDECL`, `PACK 8`, `ALIGN 8` ayrı satırlar)
> "STRUCT: field identifier expected near KEYWORD('ABI')" ile reddedilir. Başlık satırında `ALIGN n` de kabul edilir ve yapının **toplam boyutunu n'nin katına yuvarlar**, alan ofsetlerini değiştirmez (AST, MIR, x64 ve JS'te aynı; 20261007 ve 20261013_1704): iki `U8` alanlı yapı `SIZEOF` ile 2 iken `ALIGN 4`'te 4, `ALIGN 8`'de 8, `ALIGN 16`'da 16 olur; `U8`, `I64`, `I64` alanlı 24 baytlık yapı `ALIGN 16`'da 32 olur (`OFFSETOF` 8 ve 16 kalır). Yapı örneğinin bellekte n'ye hizalı bir adrese konup konmadığı ölçülmedi.

## 10.4 `ENUM`: adlandırılmış sabitler

Üyeler 0'dan başlar, ya da `= değer` ile başlangıç verilir; sonraki üyeler birer artar. Üyeye `Enum.Üye` ile erişilir. `ENUM` adı bir **tip** olarak kullanılabilir.

{{ORNEK:07_yapi/enum|baslik=ENUM}}

{{ORNEK:48_kv_veri/enum_ve_secim|baslik=ENUM tipli değişken ve SELECT CASE}}

## 10.5 Koleksiyonlar: `LIST`, `DICT`, `SET`

Üç koleksiyon da **karışık tipte** değer tutar ve **işlevlerle** yönetilir. Değerler `OBJECT` olarak döner; sayıya `CINT(...)`, ondalığa `CDBL(...)`, metne `STR(...)`
ile çevrilir ya da doğrudan `PRINT`/`FOR EACH` ile kullanılır.

| | `LIST` | `DICT` | `SET` |
|---|---|---|---|
| Tanım | `DIM l AS LIST` | `DIM d AS DICT` | `DIM s AS SET` |
| Ekle | `LISTADD(l, x)` | `DICTSET(d, anahtar, x)` | `SETADD(s, x)` |
| Oku | `LISTGET(l, i)` | `DICTGET(d, anahtar)` | `SETHAS(s, x)` |
| Değiştir | `LISTSET(l, i, x)` | `DICTSET(d, anahtar, x)` | — |
| Var mı? | — | `DICTHAS(d, anahtar)` | `SETHAS(s, x)` |
| Sil | `LISTREMOVE(l, i)` | — | `SETREMOVE(s, x)` |
| Boşalt | `LISTCLEAR(l)` | `DICTCLEAR(d)` | `SETCLEAR(s)` |
| Sayı | `LISTLEN(l)` | `DICTLEN(d)` | `SETLEN(s)` |
| `FOR EACH` | Elemanlar | **Anahtarlar** | Elemanlar |
| Yeni üret | `LIST_NEW()` | `DICT_NEW()` | `SET_NEW()` |

{{ORNEK:16_koleksiyon/list|baslik=LIST}}

{{ORNEK:16_koleksiyon/dict|baslik=DICT}}

{{ORNEK:16_koleksiyon/set|baslik=SET}}

{{ORNEK:48_kv_veri/kelime_sayaci|baslik=Orta düzey: kelime sayacı (DICT)}}

{{ORNEK:48_kv_veri/genislik_oncelikli|baslik=Üst düzey: LIST ile kuyruk, dizi ile komşuluk matrisi (BFS)}}

> **Sınır (G-KOLEKSIYON-1):** Koleksiyondaki **metin** değeri doğrudan `PRINT LISTGET(l, 1)` ile yazdırırsanız motorlar farklı davranır (AST `0`, MIR doğru, x64 çöp sayı). Metinleri
> `FOR EACH s IN l` ile (typed `STRING` değişkenle) okuyun. `DICT` değeri için `DICTGET` sonucu doğrudan `STRING` değişkene atanamaz (`explicit cast TYPE_OBJECT to TYPE_STRING`).

### Koleksiyonların iç içe kullanımındaki sınırlar

Koleksiyonlar birbirinin içine konabilir (Bölüm 22.4'te tablo halinde), ama dört noktada dikkat gerekir:

* **Koleksiyonu değişkene geri almak yoktur** (G-KOLEKSIYON-2): `geri = LISTGET(dis, 0)` ve `DIM q AS Nokta = LISTGET(l, 0)` "assignment requires explicit cast TYPE_OBJECT to …" ile reddedilir; ileti açık bir dönüşüm ister ama böyle bir dönüşüm yazımı yoktur (`LIST(...)` de olmaz). İç koleksiyona doğrudan iç içe çağrıyla erişin: `LISTLEN(LISTGET(dis, 0))`. Nesne listesini tipli bir değişkenle `FOR EACH n IN l` ile gezin.
* **`FOR EACH` kaynağı düz bir değişken olmalıdır** (G-KOLEKSIYON-3): `LISTGET(...)` ya da nesne alanı üzerinde döngü sessizce yanlış çalışır.
* **Koleksiyon tipli dizi elemanı ve sınıf alanı kendiliğinden üretilmez** (G-KOLEKSIYON-4): `DIM dz(2) AS LIST` ve sınıf içinde `DIM urunler AS LIST` ilk kullanımda çalışma anı hatası verir ("invalid collection handle"). Elemanı ve alanı `LIST_NEW()`, `DICT_NEW()`, `SET_NEW()` ile (sınıf alanı için kurucuda) üretin.
* **Tipli koleksiyon yoktur** (◇ HEDEF, G-HEDEF-26): `DIM l AS LIST OF I32` "unknown symbol: of" ile reddedilir (iletide tipli koleksiyondan söz edilmez); `n = LISTGET(l, 0)` ile `I32` değişkene doğrudan atanamaz ("explicit cast TYPE_OBJECT to TYPE_I32"). Değeri `FOR EACH v IN l` ya da `CINT(LISTGET(l, i))` ile okuyun.
* **`TYPE` kaydı `LIST` içinde saklanamaz** (G-KOLEKSIYON-5): `LISTADD(l, kayit)` hata vermez, ama okunan kaydın alanları `0` gelir. Kayıtları kayıt dizisinde tutun.

### Veriyi kısa yoldan tanımlamak: bugün yok

Mete (2026-10-15) değişkenlere, dizilere ve `LIST`, `DICT`, `SET`, demet, veri çerçevesi gibi yapılara **Python tarzı** parantez, süslü parantez ve köşeli parantezle veri tanımlanabilmesini; eski `DATA` / `READ` / `RESTORE` komutlarının da bu yapılara veri yerleştirmekte kullanılabilmesini istedi. Altı yolda ölçülen durum (`20261014_0253`):

| İstek | Örnek | Bugün |
|---|---|---|
| Dizi başlangıç değeri | `DIM a(2) AS I32 = {1, 2, 3}` | ✖ sözcük çözümleyici hatası (`Lexer diagnostic bridge hata buldu: 2`, çıkış 2) — G-VERI-15 |
| `DICT` sabiti | `DIM d AS DICT = {"a": 1, "b": 2}` | ✖ aynı hata — G-VERI-15 |
| `SET` sabiti | `DIM s AS SET = {1, 2, 3}` | ✖ aynı hata — G-VERI-15 |
| `LIST` sabiti | `DIM l AS LIST = [1, 2, 3]` | ✖ ayrıştırma hatası — G-VERI-15 |
| Demet | `DIM t AS TUPLE = (1, 2, 3)` | ✖ ayrıştırma hatası; `TUPLE` tipi yok — G-VERI-16 |
| Veri çerçevesi | `DIM df AS DATAFRAME` | ✖ `unknown type: DATAFRAME`; `uxdataframe` kütüphanesi işlev tabanlıdır — G-VERI-16 |
| Klasik veri satırları | `DATA 10, 20, 30`, `READ a`, `RESTORE` | ✖ üçü de yok: `UXB_CALL_PAREN_REQUIRED` — G-VERI-14 |

`DATA` bir anahtar sözcük bile değildir: `DIM data AS I32 = 5` altı yolda çalışır. Bu komutların eski sözcük çözümleyicide bulunduğu bilgisi (Mete) bu çalışmada kaynakla doğrulanamadı; bugünkü yüzey kaydında ve 239 anahtar sözcüğün listesinde (Ek A) yoktur. Koleksiyonlar bugün yalnız işlevlerle kurulur (`LISTADD`, `DICTSET`, `SETADD`, yukarıdaki tablolar). Hepsi ◇ HEDEF'tir; kayıtlar: S-550 … S-552.

## 10.6 Dizi yapısı için ek sınırlar

| Konu | Durum |
|---|---|
| Tüm diziyi kopyalama `b = a` | ✖ SINIR (G-VERI-4): MIR kopyalar, AST ve x64 **kopyalamaz** (sessiz). Elemanları döngüyle kopyalayın |
| Dizi ilk değer listesi `= {1, 2, 3}` | ✖ Yoktur |
| `DIM a(n)` değişken sınır | AST/MIR ✔; x64 yalnız sayısal sabit kabul eder (G-DIL-1) |

## 10.7 Benzerlerinden farkı

| İkili | Fark |
|---|---|
| Dizi ve `LIST` | Dizi: tek tip, sabit boyut, hızlı. `LIST`: karışık tip, büyür, işlevlerle yönetilir |
| `LIST` ve `SET` | Sıra ve yineleme var / benzersiz değerler |
| `DICT` ve `LIST` | Anahtarla erişim / sıra numarasıyla erişim |
| `TYPE` ve `CLASS` | `TYPE` yalnız veri ve değer semantiği (atama kopyalar); `CLASS` veri + davranış ve **referans** semantiği |
| `TYPE` ve `STRUCT` | `STRUCT` bellek düzenini (`ABI`, `PACK`) kontrol eder; DLL ile konuşmak için |
| `STRUCT` ve `UNION` | Alanlar art arda / aynı bellekte üst üste |
| `ENUM` ve `CONST` | `ENUM` ilişkili sabitleri gruplar ve tip olur; `CONST` tek değerdir |

## 10.8 Veri yapılarıyla ilgili programlama kararları

* **Yapıyı veriye göre seçin** (10.1): aynı tipten sabit sayıda değer → dizi; tek varlığın farklı tipli alanları → `TYPE`; büyüyen, karışık tipli liste → `LIST`; anahtarla erişim → `DICT`; benzersiz değerler → `SET`; veri + davranış → `CLASS`.
* **Kaydı (`TYPE`) yordamlara alanlarıyla geçirin**; kaydı değerle ya da `BYREF` parametre vermeyin, kayıt döndüren işlev yazmayın (G-VERI-6, G-VERI-2, G-VERI-3). Kayıt kopyası `b = a` güvenlidir ve derindir.
* **Kayıt dizisinde indeksi değişkenle verin**: sabit indisle yazıp sabit indisle okumak x64 ve JS'te derlenmez (G-VERI-7). Dizi elemanını başka elemana kopyalamak yerine **alanları tek tek** takas edin (G-VERI-1). Kayıt içinde dizi alanı tanımlamayın (G-VERI-8).
* Tüm diziyi `b = a` ile kopyalamayın (G-VERI-4); **döngüyle** kopyalayın. İlk değer listesi (`= {…}`) yoktur: diziyi döngüyle ya da atamalarla doldurun.
* `DICT`/`LIST` değerlerini **tipli değişkenle** okuyun (`FOR EACH s IN l` ya da `CINT(...)`/`CDBL(...)`); metin değerini doğrudan `PRINT LISTGET(l, 1)` ile yazdırmayın (G-KOLEKSIYON-1).
* `DICT` üzerinde `FOR EACH` **anahtarları** verir; değer için `DICTGET(d, anahtar)` çağırın. Anahtarların sırasını **varsayılan sayılmayın**: sıralı çıktı gerekiyorsa anahtarları listeye alıp sıralayın.
* Koleksiyonu iş bitince kütüphane işleviyle bırakın (`uxcollections` kullanıyorsanız `Free`); dil içi `LIST`/`DICT`/`SET` için ayrı bir bırakma işlevi yoktur.
* **`STRUCT`/`UNION` yalnız dış dünya (DLL) ile bellek düzeni gerektiğinde** kullanın; `UNION` içinde dizi alanı tanımlamayın (G-VERI-5) ve `UNION` alanlarını bit düzeyinde dönüşüm için üst üste bindirirken ikilinin `20261013` ya da sonrası olduğundan emin olun (öncesinde yalnız AST'de çalışırdı, G-VERI-11; WASM'da yalnız ofset 0'daki 1, 2 ve 4 baytlık tamsayı alanlar). Normal veri için `TYPE`.
* Koleksiyon için dil içinde **serbest bırakma işlevi yoktur** (`LISTFREE` gibi bir işlev bulunmaz); boşaltmak için `LISTCLEAR`/`DICTCLEAR`/`SETCLEAR` kullanın.
* Büyük veri için `LIST` yerine dizi, dizinin sınırı belliyse `DIM d(n)` (x64'te `n` sayısal sabit olmalı, G-DIL-1).
