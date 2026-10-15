# 12. Hata yönetimi, doğrulama ve tanılar

Programlarda üç farklı hata türü vardır ve her birine farklı araçla yaklaşılır:

| Tür | Ne zaman ortaya çıkar? | Kim yakalar? | Örnek |
|---|---|---|---|
| **Derleme hatası** | Program çalışmadan önce | Derleyici | Eksik `THEN`, tanımsız ad, tip uyuşmazlığı |
| **Çalışma anı hatası** | Program çalışırken, beklenmedik durumda | `TRY/CATCH` ya da program durur | Sıfıra bölme, dizi sınırı, boş nesne |
| **Programcı hatası bildirimi** | Sizin tanımladığınız kural bozulunca | `THROW`, `ASSERT` | "Bakiye yetersiz" |

uXBasic'in temel ilkesi (Bölüm 1): **hata sessiz geçmez**. Derleyici anlamadığı ya da yapamadığı şeyi reddeder ve nedenini söyler.

## 12.1 `TRY` / `CATCH` / `FINALLY` / `THROW`

```basic
TRY
    ' hata çıkabilecek kod
CATCH
    ' hata olursa burası çalışır
FINALLY
    ' hata olsa da olmasa da burası çalışır
END TRY
```

* `THROW değer` bir hata fırlatır. Değer metin, tamsayı ya da ondalık olabilir. `THROW` **değersiz yazılamaz**.
* `CATCH` kendisinden önceki `TRY` bloğundaki (ve çağırdığı yordamlardaki) `THROW`'u yakalar. Yordamın içinde atılan hata, çağırandaki `TRY` tarafından yakalanır.
* `FINALLY` bloğu isteğe bağlıdır; hata olsa da olmasa da çalışır.
* `TRY` iç içe yazılabilir; `CATCH` içinde yeniden `THROW` ile hata bir üst düzeye iletilebilir.
* Yakalanmayan `THROW`, programı hata iletisiyle sonlandırır (AST çıkış 5, MIR 13, x64 1). **JS'te 20261007 ikilisinde ileti yazılmaz ve çıkış kodu 0 kalırdı** (✖ SESSİZ, G-JS-14); aynı şey başarısız `ASSERT` için de geçerliydi. 20261013_1514 ve sonrasında (S-444) JS `uXBasic runtime error: kotu` yazar ve çıkış kodu `1` olur; bir yordamdan fırlatılan `THROW`'un çağıranın `TRY`'ında yakalanması ise hâlâ eksiktir (G-JS-2).

{{ORNEK:02_hata/try_catch_finally|baslik=TRY / CATCH / FINALLY / THROW}}

{{ORNEK:02_hata/throw_rutinden|baslik=Yordamdan atılan hata çağıranda yakalanır}}

{{ORNEK:50_kv_hata/hata_zinciri|baslik=Orta düzey: iç içe TRY ve yeniden atma}}

### Hata değerine erişim

`CATCH` bugün atılan değeri **bir değişkene vermez**. `CATCH e` yazmak sessiz bir yanlıştır (`e` bir ifade sayılır); `ERR` ya da `ERRORTEXT` gibi yerleşik adlar da yoktur.
Hata bilgisi gerekiyorsa genel bir değişkene yazıp sonra `THROW` edin; görevlerde hata metni `t.ERRORTEXT` ile okunur (Bölüm 15). **◇ HEDEF:** `CATCH ad AS tip` ile hata değerini alma.

### Bilinen sınırlar

| Sınır | Açıklama |
|---|---|
| ✖ G-HATA-1 | `TRY` içindeki `RETURN`: AST `FINALLY`'yi çalıştırır, **MIR ve x64 çalıştırmaz** |
| ✖ G-HATA-2 | **Çalışma anı hataları** (dizi sınırı, sıfıra bölme, boş nesne) `TRY` ile yalnız **AST'de** yakalanır; MIR ve x64'te program durur |
| ✖ G-HATA-3 | `CATCH` içinden yeniden `THROW` edilirse aynı `TRY`'ın `FINALLY` bloğu MIR ve x64'te atlanır. `FINALLY`'yi dıştaki `TRY`'a koyun (örnekteki gibi) |
| ✖ G-HATA-4 | `CATCH e` biçimi hata değerini vermez (yukarıda) |
| ✖ G-DIL-10 | Programın herhangi bir yerinde `ASSERT`, `TRY` ya da `THROW` varsa, bir yordamda `DIM dizi(n)` bir **çağrıdan sonra** yazılıp dizi daha önce yazılan bir döngüde kullanılırsa x64 `array not declared` ile derlemez; AST ve MIR doğrudur. **Dizileri yordamın en başında, ilk çağrıdan önce bildirin** |

## 12.2 `ASSERT`: varsayım denetimi

`ASSERT koşul` koşul doğruysa hiçbir şey yapmaz, **yanlışsa programı durdurur**. İkinci argüman iletidir: `ASSERT b <> 0, "bolen sifir olamaz"`.
`ASSERT`, "bu noktada şu doğru olmalı" diyen bir sözleşmedir; kullanıcı girdisi doğrulamak için değil, **programcı hatalarını yakalamak** için kullanılır.

{{ORNEK:02_hata/assert|baslik=ASSERT}}

{{ORNEK:50_kv_hata/dogrulama_assert|baslik=Bir işlevin sözleşmesini ASSERT ile yazmak}}

## 12.3 `TRY` mı, `ASSERT` mi, döndürülen kod mu?

| Durum | Seç |
|---|---|
| Beklenen, kurtarılabilir hata (dosya yok, yetersiz bakiye) | `THROW` + `TRY/CATCH` |
| "Bu asla olmamalı" (programcı hatası) | `ASSERT` |
| Hatanın önceden kontrolü ucuz | `IF` ile denetle, hiç fırlatma |
| Temizlik her durumda şart (dosya kapatma) | `FINALLY` (G-HATA-1/3 sınırlarına dikkat) |

## 12.4 Derleyici tanıları: nasıl okunur?

Derleyici hataları **sabit kalıplarla** bildirir. En sık karşılaşılanlar (hepsi gerçek çıktıdır):

| İleti (kısaltılmış) | Anlamı | Ne yapmalı? |
|---|---|---|
| `unknown symbol: x` | `x` adı tanımlı değil | `DIM` ile tanımlayın, adı kontrol edin |
| `assignment requires explicit cast TYPE_F64 to TYPE_I32` | Ondalığı tamsayıya atıyorsunuz | `I32(x)` ile açıkça dönüştürün |
| `integer literal out of range for TYPE_I32: ...` | Sabit tipe sığmıyor | Daha geniş tip (`I64`) kullanın |
| `missing THEN` / `missing END IF` / `missing NEXT` | Blok kapanmamış | Eksik sözcüğü ekleyin |
| `no matching overload for F with 2 argument(s)` | Argüman sayısı yanlış | Çağrıyı imzaya uydurun |
| `variable K conflicts with CLASS K` | Sınıf ve değişken aynı ad | Değişkeni yeniden adlandırın |
| `PRIVATE method ... cannot be called from outside its class` | Özel metoda dışarıdan çağrı | Kamuya açık bir metot kullanın |
| `interface method missing implementation` | Arayüz metodu yazılmamış | Eksik metodu ekleyin |
| `array index out of bounds A` | Dizi sınırı aşıldı (çalışma anı) | İndeksi `LBOUND`/`UBOUND` ile sınırlayın |
| `field access on a null object reference` | Boş nesnede alan okuma | `NEW` ile oluşturun |
| `call stack limit exceeded` | Özyineleme çok derin | Döngüye çevirin |
| `step limit exceeded (--max-steps N)` | Yorumlayıcı adım sınırı aşıldı | Sınırı artırın ya da sonsuz döngüyü düzeltin |

Hata kodları (`E.0300` gibi) JSON tanı çıktısında bulunur:

```
uxb run program.uxb --diag-format json
```

Ayrıca her çalıştırma `build/.../json/diagnostics/all_diagnostics.json` dosyasını (ve `json/live/vscode_diagnostics.json` dosyasını) üretir; bu iki dosya ayrıştırma, anlam çözümleme ve hedef doğrulama tanılarının yanında **AST ve MIR yorumlayıcılarının çalışma anı hatalarını** da içerir (yakalanmayan `THROW`, `ASSERT`, dizi sınırı, tanımsız işlev: AST çıkış `5`, MIR çıkış `13`; `20261013_2052` derlemesinden beri, S-498; `20261007` ikilisinde dosya oluşurdu ama `count` 0 kalırdı, G-HATA-11). Yerel x64 EXE, JS ve WASM çalışma anı hataları ayrı süreçte oluştuğundan bu dosyalara girmez. Çıkış kodları Bölüm 1.6'dadır.

**Bu kodlara güvenmeyin (✖ G-HATA-10).** Derleyici bir tanının `E.xxxx` kodunu ve katmanını, ileti metninde geçen sözcükleri sırayla arayarak **tahmin eder**; sözcük sınırı yoktur. Gözlenen sonuçlar:

| Hata | Beklenen | Gerçekte |
|---|---|---|
| `a = 5 / 2` (`I32`'ye ondalık atama: "requires explicit cast") | `Semantic/E.0300` ya da `Type/E.0310` | `AST/E.0210` ("cast" içinde "ast" geçer) |
| Yakalanmayan `THROW`, `ASSERT`, tamsayı sıfıra bölme, dizi sınırı (AST) | `Interpreter/E.0410` | `AST/E.0210` ("AST contract or AST structure error") |
| Aynı hatalar (MIR yorumlayıcı) | `Interpreter/E.0410` | `MIR/E.0400` ("MIR lowering or verification error") |
| Ayrıştırma hatasının ikinci tanısı | `Parser/E.0200` | `--out-root` yolunda `meta` ya da `preprocess` geçerse `Preprocessor/E.0110`, `lexer` geçerse `Lexer/E.0100` |

Yani aynı çalışma anı hatası AST'de başka, MIR'de başka kodla gelir ve klasör adınız bile kodu değiştirebilir. Betiklerde **çıkış koduna** (Bölüm 1.6) ve ileti metnine dayanın.
`--diag-format json` çıktısı **art arda yazılmış JSON nesneleridir**, tek bir belge değildir (✖ G-CLI-18): ayrıştırma hatası her zaman iki nesne verir. Bu kip `--quiet`'i de açar (`INFO` satırları basılmaz) ve tanınmayan bir değer (`--diag-format xyz`) hata vermeden metin kipine düşer (✖ G-CLI-19).

**◇ HEDEF (G-HEDEF-20, S-193):** Tasarım, **tek bir yapılandırılmış tanı kaydı** koyar: sabit kod, önem, katman, aşama, gerçek kaynak aralığı, ilgili sembol, parametreler, Türkçe ve İngilizce mesaj, çözüm ipucu ve sebep zinciri. Metin (TXT), JSON ve VS Code çıktısı aynı kaydı biçimlendirir,
bilinmeyen konum sahte `1:1` yazılmaz, bir işlem için tek oturum kimliği ve tek nihai durum olur, eski `E.*` ve servis kodları uyumluluk eşlemesiyle korunur. Bugün üç ayrı yol vardır (katalog biçimi, yapılandırılmış liste, metinden Türkçeye çeviri): ayrıntı metni İngilizce kalır,
konum çoğu tanıda `0:0` ya da `1:1`'dir ve tanı kodu ileti sözcüklerinden tahmin edilir (G-HATA-10).

**Bağlayıcı karar (Mete, 2026-10-11):** bir komutun tasarım dışı bir hedefte çalışmaması, hedefe göre sessizce farklı davranmak yerine **ortak bir tanı koduyla** bildirilecektir. İlk uygulama kütüphane tipi sağlayıcı hatalarıdır: `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` (seçilen hedefte yaşam döngüsü ya da sağlayıcı yok), `UXB_LIBTYPE_PROVIDER_MISSING` (MIR sağlayıcı kayıt defterinde sağlayıcı yok), `UXB_LIBTYPE_PROVIDER_TYPE_MISMATCH` (sağlayıcı kayıtlı ama bu tipi desteklemiyor) ve `UXB_LIBTYPE_PROVIDER_OPERATION_UNAVAILABLE` (sağlayıcı tipi destekliyor ama bu işlemi desteklemiyor); bu kodlar hata merkezi kataloğuna, birleşik tanı listesine (`all_diagnostics.json`) ve VS Code çıktısına aynı kodla taşınır.
**Ölçülmüş durum (`20261014_0253`).** Bu değişiklik kılavuzun ilk doğrulama ikilisinden (`20261007`) sonra yapıldı. `TEXT_REF` gibi yaşam döngülü bir kütüphane tipini kullanan program (`tests\library_type_contract\library_shared_value.uxb`) yedi hedefte **çıkış 1** ile ve iletinin başında kodla reddedilir; MIR yorumlayıcısı aynı programı çalıştırır:

| Hedef (komut) | Çıkış | İlk metin satırı |
|---|---|---|
| AST (`run --interpreter-backend AST`) | 1 | `ERROR: UXB_LIBTYPE_PROVIDER_UNAVAILABLE: library type lifecycle provider unavailable for AST: TEXT_REF` |
| AST-x64, MIR-x64, yerel x64 (`bld --build-x64 …`) | 1 | aynı cümle, sonu `… unavailable for NATIVE: TEXT_REF` |
| JS (`jsw`) | 1 | aynı cümle, sonu `… unavailable for JS: TEXT_REF` |
| WAT ve WASM (`wat`, `wat --emit-wasm`) | 1 | aynı cümle, sonu `… unavailable for WAT: TEXT_REF` |
| MIR (`run --interpreter-backend MIR`) | 0 | `HELLO`, `hello`, `HELLO` (program çalışır) |

`--all-diagnostics-json-out` dosyasında bu ret, `code`, `severity`, `layer = "library_type"`, `phase = "target_validation"`, Türkçe ve İngilizce ileti, ipucu ve `source.known = false` alanlarını taşıyan **tek bir kayıt** olarak bulunur. `20261007` ikilisi aynı yedi hedefi aynı çıkış koduyla ama kodsuz iletiyle reddederdi ve bu JSON dosyası **boştu** (`count` 0). Pakette (`tests\library_type_contract`) 38 denetim vardır; `20261013_2224` hepsini geçer, `20261007` ikilisi 30'unu geçer.

Öteki üç kod **çalışma anı hatalarıdır**: yalnız MIR'de, program çalışırken çıkar (çıkış 13). JSON kaydında `layer` yine `library_type`, `phase` ise `provider_call` yazar; iki dilli ileti, ipucu (`hint_tr`) ve ilgili yüzey (`related_surface`) doludur:

| Kod | Ne zaman? | Metin satırı (örnek) |
|---|---|---|
| `UXB_LIBTYPE_PROVIDER_MISSING` | Manifestin `mir_provider` adı kayıtlı değil | `ERROR: MIR interpreter basarisiz: UXB_LIBTYPE_PROVIDER_MISSING: library type provider missing: RATIONAL.ADD via RATIONAL_PROVIDER_NOT_INSTALLED` |
| `UXB_LIBTYPE_PROVIDER_TYPE_MISMATCH` | Sağlayıcı kayıtlı ama bu tipi desteklemiyor (örnek: `RATIONAL` manifestinde `mir_provider = OWNED_TEXT_REFERENCE`) | `ERROR: MIR interpreter basarisiz: UXB_LIBTYPE_PROVIDER_TYPE_MISMATCH: library type provider type mismatch: RATIONAL via OWNED_TEXT_REFERENCE` |
| `UXB_LIBTYPE_PROVIDER_OPERATION_UNAVAILABLE` | Sağlayıcı tipi destekliyor ama işlemi desteklemiyor (örnek: `RATIONAL.CMP(a, b)`) | `ERROR: MIR interpreter basarisiz: UXB_LIBTYPE_PROVIDER_OPERATION_UNAVAILABLE: library type provider operation unavailable: RATIONAL.CMP via RATIONAL_REFERENCE` |

`RATIONAL` gibi değer tipleri de artık aynı kodla reddedilir: `RATIONAL` kullanan program AST, MIR-x64, eski AST-x64, JS ve WASM yollarında `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` ile derleme aşamasında reddedilir, yalnız MIR çalıştırır (Bölüm 19.2). `20261013_2224` ve öncesinde çalışma anı kayıtları ham kod metniydi (ipucu "compiler failure diagnostic", `related_surface` boş), dördüncü kod yoktu ve `20261013_1341` … `2052` arasında AST-x64 ile WASM `RATIONAL` programını reddetmeyip yanlış sonuç veriyordu (Ek K).

Ölçüm üç sınırı hâlâ gösterir; her biri ayrı kayıttır:

1. **Hedef adı üç gruba indirgenir.** AST-x64, MIR-x64 ve yerel x64 hepsi `NATIVE`, WAT ve WASM ikisi de `WAT` yazar; hangi yolun reddettiği iletiden ayırt edilemez (✖ G-HATA-13).
2. **Metin satırı ile JSON iletisi aynı cümleyi söylemez.** `UNAVAILABLE` için metin satırı "library type lifecycle provider unavailable for NATIVE: TEXT_REF", JSON iletisi "Library type provider is unavailable for the execution target: NATIVE: TEXT_REF" yazar (✖ G-HATA-13); VS Code dosyası bilinmeyen konumu dosyanın ilk karakteri olarak (satır 0, sütun 0–1) yazarken `all_diagnostics.json` `known: false` der.
3. **Türkçe iletiler Türkçe harfsizdir.** `message_tr` değeri `Calistirma hedefi icin kutuphane tipi saglayicisi kullanilamiyor` biçimindedir (ç, ğ, ı, ö, ş, ü yerine c, g, i, o, s, u; ✖ G-HATA-12, karar Mete'nin).

Diğer hedef farklarında (örneğin `UXB host binding missing`, `NATIVE_ONLY_UNSUPPORTED_ON_JS`, WAT metin reddi) her motor bugün kendi iletisini verir (Ek F).

## 12.5 Derleyicinin sessiz kabul ettiği hatalar

"Hata sessiz geçmez" ilkesine rağmen, aşağıdaki hatalı programlar **bugün hata vermeden çalışır**. Bunların hepsi Ek G'de izlenir; programınızda bunlara karşı **kendiniz** dikkatli olun:

| Hatalı kod | Ne olur? | Kayıt |
|---|---|---|
| `PRINT (1 +` (eksik ifade) | Hata yok, boş satır yazar (üç motorda) | G-DIL-5 |
| `FUNCTION F() AS I32` içinde `RETURN`'süz bitiş | AST/MIR `0`, x64 rastgele değer | G-YORDAM-2 |
| `I32` parametreye metin ya da `2.5` vermek | AST/MIR `0` / `2`, x64 çöp | G-YORDAM-3, -4 |
| `DIM a` iki kez | Yalnız AST reddeder; MIR ve x64 kabul eder | G-DIL-6 |
| Tanımsız işlev çağrısı `PRINT Bilinen(3)` | AST/MIR çalışma anı hatası, x64 derleme hatası (derleme zamanı değil) | G-DIL-7 |
| `PRIVATE` alana dışarıdan yazma | Sessizce çalışır | G-NESNE-2 |
| `DIM x AS LONG` (eski tip adı) | `I32` olarak kabul edilir | G-TIP-6 |
| `s += 7` (`s` bir `STRING`; bileşik atama) | AST, MIR, eski AST-x64, JS: `a7` yazar (sayı + metin sessizce birleşir); **yerel x64: erişim ihlaliyle çöker**; `s += 2.5` dört ayrı sonuç verir (`a2.5`, MIR boş, `a2`, çöker). Açık biçimler (`5 + "a"`, `s = s + 7`, `n = "5"`) `20261014_0253`'te `UXB_MIXED_STRING_NUMERIC` ile reddedilir; `20261007`'de AST, MIR ve JS `5a` yazardı | G-DIL-16 (G-DIL-8, -13, -14 kapandı) |

### Aynı çalışma anı hatası, farklı motorlar

Aşağıdaki tablo, hatalı bir işlemin her motorda gerçekte ne yaptığını gösterir (her satır bu kılavuzun hazırlığında dört motorda çalıştırılmıştır; "hata" = program ileti yazıp durur). **✖ işaretli hücreler hata vermeden yanlış devam eder.**

| Durum | AST | MIR | x64 | JS | Kayıt |
|---|---|---|---|---|---|
| `5 \ 0` (tamsayı sıfıra bölme) | hata (çıkış 5) | hata (13) | ✖ iletisiz durur (çıkış 2) | ✖ `inf` yazar, devam eder | G-HATA-8, G-HATA-9 |
| `5 MOD 0` | hata | hata | ✖ iletisiz durur (2) | ✖ `nan`, devam | G-HATA-8, G-HATA-9 |
| `f / 0` (`F64`) | hata | hata | `inf`, devam | `inf`, devam | G-HATA-5 |
| `SQR(-1)`, `LOG(0)` | hata | hata | `nan`, `-inf` | `nan`, `-inf` | G-HATA-5 |
| `EXP(1000)`, `1E308 * 10` | `inf` | `inf` | `inf` | `inf` | tutarlı |
| Dizi sınır dışı okuma, yazma, negatif indeks | hata | hata | hata (1) | ✖ okuma `0`; yazma yok sayılır | G-HATA-6 |
| `LISTGET` sınır dışı, `DICTGET` olmayan anahtar | hata | hata | hata | ✖ `undefined` | G-HATA-6 |
| Boş nesne: metot çağrısı, alan yazma | hata | hata | hata | hata (`callMethod`/`fieldStore target is missing`) | — |
| Boş nesne: alan okuma | hata | hata | hata | ✖ `undefined` | G-HATA-6 |
| `DELETE o` sonrası `o.v` okuma | hata | ✖ eski değer (`3`) | hata | ✖ `undefined` | G-NESNE-20 |
| Olmayan dosyayı `OPEN … FOR INPUT` | durur (2; ham FreeBASIC iletisi) | durur (13) | ✖ sessizce devam (`EOF` `-1`) | ◌ `host binding missing: OPEN` | G-DOSYA-5, G-JS-7 |
| `VAL("abc")` | `0` | `0` | `0` | `nan` | G-METIN-5 |
| `ASC(CHR(300))` | hata | `44` | `44` | `300` | G-METIN-5 |
| `1 SHL s` (`s` = 40, `I32`) | `1099511627776` | `1099511627776` | ✖ `0` | `1099511627776` | G-ISLEC-6 |

Çıkış kodları da motora göre değişir: AST 5, MIR 13, x64 1 ya da 2, JS 0 ya da 1 (G-HATA-7); betikte yalnız "sıfır mı?" diye bakın. **Hata çıktısından önce yazılanlar kaybolmaz:** `PRINT "once"` sonrasındaki hatada dört motor da `once` satırını yazar; `PRINT "deger: "; a \ 0` gibi satır içi hatada yazılan kısım (`deger: `) çıkışın içinde kalır.

## 12.6 Benzerlerinden farkı

| İkili | Fark |
|---|---|
| `THROW` ve `ASSERT` | `THROW` yakalanabilir bir hata fırlatır; `ASSERT` yanlışsa programı durdurur |
| `CATCH` ve `FINALLY` | Hata olursa / her durumda çalışır |
| `END` ve `THROW` | `END` programı bitirir; `THROW` kontrolü bir üst `TRY`'a devreder |
| Derleme hatası ve çalışma anı hatası | Program hiç başlamaz / program başlar, bir noktada durur |

## 12.7 Hata yönetimiyle ilgili programlama kararları

* **Hata türüne göre aracı seçin** (12.3): beklenen ve kurtarılabilir durum → `THROW` + `TRY/CATCH`; "bu asla olmamalı" → `ASSERT`; denetimi ucuz olan durum → `IF` ile önceden bakın, hiç fırlatmayın.
* **Kullanıcı girdisini `ASSERT` ile doğrulamayın.** `ASSERT` programcı hatalarını yakalar ve programı durdurur; girdi hatası `IF` ya da `THROW` ile yönetilir.
* `THROW`'a her zaman bir değer verin (metin, tamsayı ya da ondalık). **`CATCH e` yazmayın**: hata değerini vermez (G-HATA-4). Hata bilgisini genel bir değişkenle taşıyın; görevlerde `t.ERRORTEXT` okunur.
* **`TRY` içinde `RETURN` yazmayın** (G-HATA-1): MIR ve x64 `FINALLY`'yi çalıştırmaz. Değeri bir değişkene alın, `TRY` bittikten sonra döndürün.
* `CATCH` içinden yeniden `THROW` edecekseniz temizlik kodunu **dıştaki `TRY`'ın `FINALLY`'sine** koyun (G-HATA-3).
* **Çalışma anı hatalarını (sıfıra bölme, dizi sınırı, boş nesne) `TRY` ile yakalamaya güvenmeyin**: yalnız AST yakalar (G-HATA-2). `IF b <> 0`, `LBOUND`/`UBOUND` ve nesnenin atandığına bakan denetimleri **önceden** yazın.
* **JS'e gidecek programda bu denetimler zorunludur:** JS tamsayı sıfıra bölmede `inf`, sınır dışı okumada `0` ya da `undefined` verip **hata vermeden devam eder** (G-HATA-6, G-HATA-8); x64 ise tamsayı sıfıra bölmede iletisiz durur (G-HATA-9). Betiklerde çıkış kodunun sıfır olmasına bakın, ileti metnine değil (G-HATA-7).
* Ondalık işlemlerde (`SQR`, `LOG`, `/`) alan dışı girdiyi önceden eleyin: AST ve MIR durur, x64 ve JS `nan`/`inf` yazıp devam eder (G-HATA-5); sonucu `nan`/`inf` için de denetleyin.
* Dosya açmadan önce varlığını `uxfs.FileExists` ile sınayın: x64 olmayan dosyayı sessizce açmış gibi davranır (G-DOSYA-5). `DELETE`'ten sonra nesneyi okumayın: MIR eski değeri verir (G-NESNE-20).
* Her yordam yalnız bir iş yapsın ve önkoşullarını başında `ASSERT` ile belirtsin; kaynak açan yordamda temizliği `FINALLY` içine koyun.
* Programda `ASSERT` ya da `TRY` varsa ve x64'e derleyecekseniz **dizileri yordamın en başında bildirin** (G-DIL-10).
* Sessizce kabul edilen hataları (12.5) kendiniz denetleyin: her yolun `RETURN` ile bittiğine, argüman tiplerinin uyduğuna ve aynı adın iki kez `DIM` edilmediğine bakın.
* Kütüphane çağrılarının sonucunu **her zaman denetleyin**: her kütüphane başarısızlığı farklı bildirir (`0`, `-1`, `nan`, boş metin, `LastError`); ayrıntı Bölüm 20'dedir.
* Derleyici iletilerini kalıplarından tanıyın (12.4); araçla okumak için `--diag-format json` kullanın. `step limit exceeded` iletisinde önce sonsuz döngüyü arayın, sonra `--max-steps`'i artırın.
