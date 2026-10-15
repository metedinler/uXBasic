# 22. İç içe kullanım: bir yapının çıktısı ötekinin girdisidir

uXBasic'in yapıları birbirinin **içine girer** ve birbirinin **çıktısını girdi olarak alır** (İlke 4, Bölüm 1.2). Bir işlevin sonucu başka bir işlevin argümanı olur; bir görev başka görevi başlatır; önişlemci bir
`THREAD` yazar, o `THREAD` bir `FUNCTION` çağırır; bir kütüphanenin çıktısı dilin sözlüğüne, sözlüğün çıktısı bir istatistik kütüphanesine girer. Bu bölüm bu birleşimlerin **hangisinin bugün gerçekten çalıştığını**,
hangisinin çalışmadığını ve çalışmayanın nasıl kapandığını (açık ret mi, sessiz yanlış mı) gösterir. Buradaki her birleşim gerçek derleyicide, ayrı ayrı motorlarda denenmiştir.

> **Okuma anahtarı:** ✔ dört motorda doğru, ◐ kısmen (koşulu yazılı), ✖ SESSİZ yanlış sonuç verir, ◌ açık ret (derleyici nedenini söyler), ◇ tasarımda var, kodda yok. Sessiz yanlışlar kayıtlıdır (`G-…`) ve
> `ai_koordinasyon/SORUN_TAKIP.md` içinde sırayla düzeltilmek üzere beklemektedir; buradaki geçici yollar sorunu **çözmez**, yalnız çalışan bir yol gösterir.

## 22.1 Bileşim düzeyleri

| Düzey | Birleşim | Durum | Kanıt |
|---|---|---|---|
| İfade | İşlev sonucu başka işlevin argümanı; `IFF`, `?:`, `\|>` ve metin işlevleri iç içe | ✔ | 22.2 |
| Yordam | Özyineleme, karşılıklı özyineleme, dizi parametresi, `BYREF` çıkışı | ✔ | Bölüm 8, 22.3 |
| Veri yapısı | Kayıt içinde kayıt, kayıt dizisi, `LIST`/`DICT` iç içe, sınıfın koleksiyon alanı | ◐ | 22.4 |
| Nesne | Kalıtım zinciri, arayüz, `MAGIC`, nesne listesi ve sanal çağrı | ◐ | 22.5 |
| Görev | `THREAD` → `PARALEL` → `THREAD`, özyinelemeli görev, `EVENT` → `PIPE` → `THREAD` | ✔ AST, MIR, x64 | 22.6, Bölüm 15.4 |
| Derleme zamanı → çalışma zamanı | Önişlemci `FUNCTION` ve `THREAD` üretir; görev bunları çağırır | ✔ AST, MIR, x64 | 22.7 |
| Kütüphane ↔ dil | JSON → düzenli ifade → sözlük → istatistik → karar | ✔ AST, MIR, x64 | 22.8 |
| Meta ↔ derleyici | `REM %%ATTR` derleyici kaydına girer | ◇ HEDEF (bugün yalnız JSON raporları ve dış araçlar) | 22.9, Bölüm 18 |
| Hedefler arası | Aynı kaynak beş motor | ◐ | 22.10, Bölüm 21 |

## 22.2 İfade düzeyi: ifade ifadenin içinde

Bir ifadenin değeri, başka bir ifadenin girdisi olabilir. Bunun için özel bir söz dizimi yoktur; her yerde çalışır:

{{ORNEK:66_kv_ic_ice/ifade_zinciri|baslik=İşlev, metin işlevi, IFF, ?: ve |> iç içe}}

| Birleşim | Örnek | Not |
|---|---|---|
| İşlev ← işlev | `Topla(Kare(3), Kare(Topla(1, 2)))` | Argüman sayısı ve tipi sizin sorumluluğunuzdadır (G-YORDAM-3, G-YORDAM-4) |
| Yerleşik işlev ← kullanıcı işlevi | `UCASE(LEFT(Etiket(Kare(4)) + "xyz", 6))` | Metinler bayt temellidir (G-TIP-4) |
| `IFF` / `?:` ← işlev | `Etiket(n > 5 ? Kare(n) : Topla(n, n))` | Yalnız seçilen dal değerlendirilir |
| Boru `\|>` | `3 \|> Kare \|> Kare` | Soldan sağa; `Kare(Kare(3))` ile aynıdır |
| Sayı ve metni birleştirmek | `5 + "a"` | ✖ AST, MIR ve JS hata vermeden `5a` yazar, **x64 çöker**, ondalıkta sonuçlar ayrışır (G-DIL-8, G-DIL-13, G-DIL-14): `STR(5) + "a"` yazın |

## 22.3 Yordam düzeyi

Özyineleme (Bölüm 8.4), karşılıklı özyineleme, dizi parametresi ve `BYREF` çıkışı birlikte kullanılır. Derinlik sınırları motora göre değişir (G-YORDAM-5): AST'de 100'den az, MIR'de 50'den az (aşılınca `20261014_0253`'te iletisiz çökme, G-YORDAM-8), x64'te yaklaşık 8000.
Derin işleri döngüyle yazın. Bir yordamın içinde yalnız kendi parametreleriyle konuşmak, her motorda aynı sonucu almanın en güvenli yoludur.

## 22.4 Veri yapıları iç içe

Hangi yapının hangisini içerebildiği **tek tek denenmiştir**:

| İçeren ⊃ İçerilen | Durum | Ayrıntı |
|---|---|---|
| `TYPE` ⊃ `TYPE` | ✔ | İç içe alan `c.a.x`; `b = a` derin kopyadır (Bölüm 10.2) |
| `TYPE` ⊃ sayısal dizi / kayıt dizisi alanı | ◌ | Reddedilir (G-VERI-8) |
| `TYPE` ⊃ sınıf tipli alan | ✖ | Atama hata vermez, alanlar `0` okunur (G-VERI-9) |
| Kayıt dizisi | ◐ | Değişken indisle ✔; sabit indisle x64 ve JS derlenmez (G-VERI-7) |
| Dizi ⊃ `LIST` | ◐ | `DIM dz(2) AS LIST` elemanları otomatik üretilmez: her elemanı `LIST_NEW()` ile üretin, yoksa çalışma anı hatası (G-KOLEKSIYON-4); üretilince dört motorda ✔ |
| `LIST` ⊃ `LIST`, `LIST` ⊃ `DICT`, `DICT` ⊃ `LIST`, `DICT` ⊃ `DICT` | ✔ | **Doğrudan iç içe çağrıyla**: `LISTLEN(LISTGET(dis, 0))`, `DICTGET(DICTGET(d, "ic"), "x")`. İç koleksiyonu bir değişkene atamak ◌ (G-KOLEKSIYON-2); `FOR EACH` ile gezmek ✖ (G-KOLEKSIYON-3) |
| `LIST` ⊃ nesne | ◐ | `LISTADD(l, nesne)` ✔; geri okumak için tipli döngü değişkeniyle `FOR EACH n IN l` ✔; `q = LISTGET(l, 0)` ◌ (G-KOLEKSIYON-2) |
| `LIST` ⊃ `TYPE` kaydı | ✖ | Okunan kaydın alanları `0` gelir (G-KOLEKSIYON-5) |
| Sınıf ⊃ `LIST` / `DICT` alanı | ◐ | Kurucuda `LIST_NEW()` / `DICT_NEW()` ile üretin (G-KOLEKSIYON-4); metotlarla kullanım AST, MIR, x64'te ✔; JS'te `DICT` alanı ✖ (G-JS-12); nesne alanını `FOR EACH` ile gezmek ✖ (G-KOLEKSIYON-3) |
| Sınıf ⊃ `TYPE` alanı | ◐ | Dışarıdan `s.merkez.x = …` dört motorda ✔; metot içinden erişim MIR ve JS'te yanlış, x64'te derlenmez (G-NESNE-11) |
| Sınıf ⊃ sınıf alanı | ✖ | Atanan nesnenin alanları `0` okunur (G-NESNE-10) |
| Sınıf ⊃ dizi alanı | ◌ | Metot içinde `d(i) = v` reddedilir (G-NESNE-12) |
| İşlev → `LIST` döndürür, `LIST` parametresi | ✔ | Dört motorda doğru |
| İşlev → nesne döndürür | ✔ | Tek çağrıda; AST ardışık çağrılarda nesneyi paylaşır (G-NESNE-9) |
| İşlev → kayıt döndürür / kayıt parametresi | ✖ | G-VERI-3, G-VERI-6 |

Çalışan bir bileşim, **sınıf içinde sözlük, sözlükte liste** (stok takibi):

{{ORNEK:66_kv_ic_ice/depo_kategori_stok|baslik=Sınıfın DICT alanı, DICT'in değeri LIST}}

## 22.5 Nesne düzeyi

Kalıtım zinciri, arayüz ve `MAGIC` birlikte kullanılır (Bölüm 11). Nesneleri bir `LIST`'te toplayıp **taban tipli bir değişkenle** gezmek ve her turda **gerçek sınıfın** metodunu çağırmak şöyle yazılır:

{{ORNEK:66_kv_ic_ice/nesne_listesi_sanal|baslik=Nesne listesi, taban tipli değişken ve sanal çağrı}}

Bu örnekte `t = s` satırı bilerek vardır: AST'de `FOR EACH` döngü değişkeni sanal metodu taban sınıfta çağırır (`0` yazar), MIR, x64 ve JS doğru çalışır. Değişkeni başka bir taban tipli değişkene kopyalamak AST'yi de doğru yapar (G-NESNE-13).
Bu **geçici bir yoldur**; sorun düzeltilene dek kopya satırını koruyun, düzeltildiğinde silin.

| Birleşim | Durum |
|---|---|
| `EXTENDS` zinciri + `VIRTUAL`/`OVERRIDE` + `SUPER` | ✔ (Bölüm 11.4; ara sınıfın `OVERRIDE`'ı için G-NESNE-7) |
| Birden çok arayüz uygulayan sınıf, arayüz tipli değişken | ✔ (Bölüm 11.5; JS'te G-JS-3) |
| `MAGIC ADD/SUB/MUL/TOSTRING` + `STR(nesne)` | ✔ (Bölüm 11.7; zincirleme için G-NESNE-9) |
| Nesne ⊃ nesne, nesne ⊃ kayıt | ✖ G-NESNE-10, G-NESNE-11 |
| Aynı sınıfın iki metodunda aynı adlı, farklı tipli parametre | ◌ geçerli program reddedilir (G-NESNE-16); parametrelere farklı ad verin |
| Tanınmayan `MAGIC` adı | ✖ hata vermez (G-NESNE-14) |
| `OPERATOR +(…)` bloğu | ◌ ayrıştırılır ama bağlanmaz (G-NESNE-15); `MAGIC ADD` yazın |
| Sınıfın `BOOLEAN` alanını `STR` ile yazdırmak | ✖ AST `255` yazar (G-NESNE-17) |

## 22.6 Görev düzeyi

Görev yapıları birbirinin içinde serbestçe kullanılır (Bölüm 15.4: `uc_katman`, `paralel_fibonacci`, `olay_zinciri`, `main_ici_ve_disi`). Aşağıdaki program **sınıf, özyineleme, `PIPE`, `EVENT`, `THREAD`, `PARALEL` ve `ATOMIC`**
yapılarını bir arada kullanır: `EVENT` ham değeri `PIPE` ile normalleştirir, `THREAD` her çağrıda bir sınıf nesnesi üretir ve nesnenin özyinelemeli metodunu çağırır, `PARALEL` dört `THREAD` başlatır, ortak sayaç `ATOMIC`'tir.

{{ORNEK:66_kv_ic_ice/paradigmalar_birlikte|baslik=Altı yapı tek programda}}

### Tasarımdaki bütünleşik program ile bugünkü fark

Tasarım kılavuzunun (24 Eylül 2026) 28. bölümündeki bütünleşik örnek, aynı niyeti şu yazımlarla anlatır. Her satırın bugünkü karşılığı gerçek denemeyle belirlenmiştir:

| Tasarımdaki yazım | Bugün | Kayıt |
|---|---|---|
| `PUBLIC:` / `PRIVATE:` (iki nokta ile) | ✔ çalışır | — |
| `DIM SHARED lastMeasurement AS Measurement` | ◌ "DIM: AS expected near IDENT" | G-HEDEF-8 |
| `LOCK lastMeasurement … END LOCK` (genel `TYPE` değişkeni üzerinde, görevden) | ✔ AST, MIR, x64 | — |
| `DIM tasks(count - 1) AS TASK` (değişken sınır) | AST ✔, MIR ✔, x64 ◌ (sabit sınır ister) | G-DIL-1 |
| `SLOT … 1 ON EVENT Ad` tablosu, `TRIGGER THREAD` | ✔ | — |
| `TRIGGER EVENT Ad, 1, 72.5` | ✔ | — |
| `DELETE analyzer` | ✔ | — |
| `OPERATOR +(…)`, `BASE.Metot()`, `PROPERTY … GET … END GET` | ◌ | G-NESNE-15, G-HEDEF-3 |

## 22.7 Derleme zamanı → çalışma zamanı

Önişlemci (Bölüm 17) kaynağı **ayrıştırmadan önce** yazar. Üretilen metin sıradan uXBasic'tir; bu yüzden üretilen bir `THREAD` bir `FUNCTION` çağırabilir, ana program `SPAWN` ile onu başlatabilir:

{{ORNEK:66_kv_ic_ice/onislemci_gorev_zinciri|baslik=%%FOREACH ile THREAD üretmek, SPAWN ile çalıştırmak}}

Tasarımın daha ileri hâli (görev bir **kütüphane tipi** döndürür) bugün kapalı başarısızlıkla reddedilir: `THREAD … AS RATIONAL` ve `TASK OF RATIONAL`
"henuz uygulanmadi: S-146 adim 5 (kutuphane tipinin gorev sozlesmesi taskTransfer/threadSafety)" der (G-GOREV-12, G-HEDEF-9). Geçici yol: kesri iki `I64` olarak (pay, payda) döndürüp görev dışında `RATIONAL` kurmak.

## 22.8 Kütüphane ↔ dil

Kütüphane çağrıları dilin ifadeleriyle serbestçe birleşir: bir kütüphanenin çıktısı dilde işlenir, dilin çıktısı başka bir kütüphaneye girer. Altı aşamalı hat — JSON ayrıştırma, düzenli ifade ile doğrulama, sözlükte biriktirme,
liste sıralama, istatistik ve karar — **bir aşamanın çıktısının sonrakinin girdisi** olduğu en uzun zincirdir:

{{ORNEK:66_kv_ic_ice/kutuphane_dil_zinciri|baslik=Altı aşamalı kütüphane zinciri}}

> **Neden diziler en başta?** Bu program `ASSERT` içerir; x64'te `ASSERT`, `TRY` ya da `THROW` bulunan bir programda bir çağrıdan sonra `DIM dizi(n)` yazmak derlenmez (G-DIL-10, S-203). Üç dizi `MAIN`'in başına alınmıştır.

Kütüphane sonuçlarını önce değişkene alıp denetlemek, hata bildiriminin kütüphaneden kütüphaneye değişmesi (Bölüm 20.3) ve AST'de çağrı başına maliyet (G-HIZ-2) nedeniyle önemlidir.
Bir kütüphane sonucunun bir **doğrulama kuralına** girdiği daha kısa bir zincir:

{{ORNEK:66_kv_ic_ice/tc_kimlik_dogrula|baslik=Kimlik numarası doğrulama: işlev, dizi, döngü ve kütüphane birlikte}}

## 22.9 Meta ve derleyicinin iç sistemi

Tasarım, meta komutların (`REM %%ATTR`, `REM %%MIR`) derleyicinin iç aşamalarına bağlanmasıdır: AST'de bir kayıt, MIR'de veri, çıktı aşamasında manifest. Bu bağ bugün **yoktur** (G-META-1, Bölüm 18); `REM %%ATTR` yalnız yorumdur.
Derleyicinin iç bilgisine bugün **JSON raporları** üzerinden ulaşılır (`--ast-json-out`, `--mir-json-out`, `--canonical-mir-json-out`, `--type-infer-report-csv-out`); onları okuyan bir araç yeni kaynak üretip aynı derleyiciye geri verebilir.
Bölüm 18.6'daki iki araç örneği bunun çalışan hâlidir: kaynaktan **API belgesi** çıkarmak ve `Test_` ile başlayan işlevlerden **sınama koşucusu** üretmek.

Önişlemci ile meta zincirinin tasarlanan hâli (bugün çalışmayan kısmı işaretli):

```basic
%%FOREACH T IN (I32, F64)
REM %%ATTR TEST                 ' ◇ HEDEF: bugün yalnız yorum
FUNCTION Test_{{T}}() AS BOOLEAN
    RETURN TRUE
END FUNCTION
%%ENDFOREACH
```

Önişlemci iki işlev ve iki `REM %%ATTR TEST` satırı üretir; tasarıma göre meta tarayıcı genişletilmiş kaynakta bu satırları görür ve her biri doğru işleve bağlanır. Üretilen kaynağı görmek için `uxb lex dosya.uxb --preprocessed-out genisletilmis.uxb` yazın.

## 22.10 Hedefler arası bileşim

Bu bölümün örneklerinin motor durumu satırları, her birleşimin hangi hedefte çalıştığını gösterir. Özet:

* İfade zinciri (`ifade_zinciri`) ve nesne listesi (`nesne_listesi_sanal`) JS'te de doğrudur.
* Görev içeren birleşimler (`onislemci_gorev_zinciri`, `paradigmalar_birlikte`) JS'te ve WASM'da çalışmaz (G-GOREV-6, G-GOREV-7).
* Kütüphane çağrısı içeren birleşimler JS ve WASM'da açık retle kapanır (G-JS-7).
* Sınıfın koleksiyon alanı JS'te yanlış sonuç verir (G-JS-12).

## 22.11 Bileşimde bilinen sınırlar (özet)

| Birleşim | Kayıt |
|---|---|
| Koleksiyon ⊃ koleksiyon: iç koleksiyonu değişkene almak, `FOR EACH` ile gezmek | G-KOLEKSIYON-2, G-KOLEKSIYON-3 |
| Koleksiyon tipli dizi elemanı / sınıf alanı otomatik üretilmez | G-KOLEKSIYON-4 |
| `LIST` ⊃ `TYPE` kaydı | G-KOLEKSIYON-5 |
| Kayıt ⊃ nesne, kayıt ⊃ kayıt dizisi, kayıt parametresi/dönüşü | G-VERI-9, G-VERI-8, G-VERI-6, G-VERI-3 |
| Sınıf ⊃ nesne / kayıt / dizi alanı | G-NESNE-10, G-NESNE-11, G-NESNE-12 |
| AST: taban tipli `FOR EACH` değişkeninde sanal çağrı | G-NESNE-13 |
| Görev sınırından koleksiyon, nesne, kütüphane tipi geçirmek | G-GOREV-12, G-HEDEF-9 |
| Çağrıdan sonra `DIM dizi(n)` + `ASSERT`/`TRY` (x64) | G-DIL-10 |

## 22.12 İç içe kullanımla ilgili programlama kararları

* **Bileşimi önce küçük bir programda deneyin**: iç içe yapı yazmadan önce "bu yapı şunun içinde tutulabilir mi?" sorusunu 22.4 tablosundan okuyun; ✖ ve ◌ satırlarını kullanmayın.
* **İç koleksiyonlara doğrudan iç içe çağrıyla erişin** (`LISTGET(LISTGET(dis, 0), 1)`); bir değişkene atamaya ya da `FOR EACH` ile gezmeye çalışmayın (G-KOLEKSIYON-2, G-KOLEKSIYON-3).
* **Sınıf alanı ya da dizi elemanı olan koleksiyonu kendiniz üretin**: kurucuda `LIST_NEW()`, `DICT_NEW()`, `SET_NEW()` (G-KOLEKSIYON-4).
* **Nesne listesini tipli bir döngü değişkeniyle gezin**; AST'yi de hedefliyorsanız döngü değişkenini hemen başka bir taban tipli değişkene kopyalayın (G-NESNE-13).
* Nesne içine nesne, kayıt içine nesne ya da kayıt koymayın; ilişkiyi değişkenle ya da alan alan kopyalayarak tutun (G-NESNE-10, G-NESNE-11, G-VERI-9). Kaydı `LIST`'te saklamayın (G-KOLEKSIYON-5).
* **Aynı sınıfın metotlarında parametrelere farklı ad verin** (G-NESNE-16).
* Görev kullanan bir bileşimde yalnız **sayı, metin ve `ATOMIC`** değerleri görev sınırından geçirin; koleksiyonu görev içinde üretin ya da görev dışında toplayın (G-GOREV-12, G-HEDEF-9). Eşzamanlı programı x64'te çalıştırın.
* Önişlemciyle üretilen kodu `--preprocessed-out` ile mutlaka okuyun; üretimin kaynağını (`%%FOREACH` listesini) düzenleyin, üretileni değil.
* **Bir kütüphane çıktısını başka bir kütüphaneye vermeden önce denetleyin** (tutamaç `<> 0`, sonuç `nan` değil): zincirde sessiz yanlış sonuç en geç aşamada fark edilir (Bölüm 20.3).
* Programda `ASSERT` ya da `TRY` varsa x64 için dizileri yordamın başında bildirin (G-DIL-10).
* Bir birleşim çalışmıyorsa kendi hatanız saymadan önce 22.4 ve Ek G'ye bakın: kayıt numarası varsa derleyici düzeltilecektir; yoksa yeni kayıt açılması gerekir.
