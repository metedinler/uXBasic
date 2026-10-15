# uXBasic Programlayıcının Cep Kitabı — Cilt 4
## Kütüphaneler, Fonksiyonlar, Dış Çalışma Zamanı ve Test Alışkanlığı

Bu cilt, ilk üç ciltte kurulan temel düşüncenin dış dünyaya açılan kapısıdır. Bir program değişken, dizi, sınıf ve döngü ile kendi içinde çalışabilir; fakat gerçek hayatta dosya okuyacak, veri tablosu işleyecek, büyük sayı hesaplayacak, yapay zeka modeline soru soracak, graf çizecek, DLL çağıracak, tarayıcıda ses veya çizim üretecek ve bütün bunları test edecektir. uXBasic kütüphane düzeni bu yüzden yalnız “hazır fonksiyon listesi” değildir. Her kütüphane, başlık dosyası, çalışma zamanı servisi, dış DLL imzası, hata raporu ve duman testi [küçük ama gerçek çalışma testi] ile birlikte düşünülmelidir.

Bu ciltte her şeyin çalıştığı varsayılır. Yani `uxcollections`, `uxmath`, `uxstats`, `uxmatrix`, `uxtensor`, `uxdataframe`, `uxdataset`, `uxgraph`, `uxaimath`, `uxnn`, `uxonnx`, `uxllama`, `fp80`, `fp128`, `bigfp` ve çalışma zamanı servisleri normal uXBasic yüzeyi gibi anlatılır. Genç programcı için kural şudur: kütüphane çağrısı yaptığında yalnız sonucu değil, yolunu, tipini, hata durumunu ve temizliğini de düşün.

## 4.1 Kütüphane kullanmanın genel yolu

Kütüphane kullanımı dört adımdır: önce başlığı dahil edersin, sonra gerekirse modül veya ad alanını açarsın, sonra fonksiyonu doğru tiplerle çağırırsın, en sonda hata ve kaynak temizliği yaparsın. Bu sıra bozulursa program küçük örnekte çalışabilir ama büyüyünce hata avına dönüşür.

| Adım | uXBasic kalıbı | Ne yapar? | Dikkat edilecek nokta |
|---:|---|---|---|
| 1 | `INCLUDE "modules/uxstats.uxmh"` | Kütüphane bildirimlerini programa alır. | Başlık dosyası yoksa program derleme öncesi kırılır. |
| 2 | `USING MODULE uxstats` | Uzun adları kısa kullanmaya izin verir. | İsim çakışması varsa `NAMESPACE` kullan. |
| 3 | `sonuc = uxstats.mean_f64(adres, adet)` | Fonksiyonu çağırır. | Parametre tipi ve adet doğru olmalıdır. |
| 4 | `ASSERT sonuc >= 0` | Sonucu denetler. | Bilinen veriyle küçük test yaz. |
| 5 | `CALL free(handle)` | Açılan kaynağı kapatır. | Handle [kaynak tutamacı] sıfırsa kullanma. |

### Genel çağrı iskeleti

Aşağıdaki örnek küçük görünür ama doğru alışkanlığı öğretir. Başlık eklenir, veri hazırlanır, kütüphane çağrılır, sonuç yorumlanır, dosyaya yazılır ve hata olursa kullanıcıya anlaşılır bilgi verilir.

```uxbasic
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxcollections.uxmh"

MAIN
    DIM olcumler AS LIST
    DIM i AS I32
    DIM ort AS F64
    DIM n AS I32

    TRY
        olcumler = LIST.NEW()
        FOR i = 1 TO 5
            CALL olcumler.PUSH(7.10 + i * 0.03)
        NEXT i

        n = olcumler.COUNT()
        ASSERT n > 0
        ort = uxstats.MEAN_LIST_F64(olcumler)

        OPEN "rapor/kutuphane_ilk_ornek.txt" FOR OUTPUT AS #1
        PRINT #1, "olcum adedi="; n
        PRINT #1, "ortalama="; ort
        CLOSE #1

        IF ort < 6.8 OR ort > 7.6 THEN
            PRINT "uyari: pH araligi disinda"
        ELSE
            PRINT "pH normal"
        END IF
    CATCH hata
        PRINT "kutuphane kullanimi hatasi: "; hata
    FINALLY
        IF n > 0 THEN PRINT "kontrol tamamlandi"
    END TRY
END MAIN
```

Bu örneğin püf noktası şudur: `LIST` sadece değerleri tutar, `uxstats` hesabı yapar, `OPEN/PRINT/CLOSE` sonucu belgeye taşır, `TRY/CATCH` programı çökmeden korur. Genç programcı böyle yazarsa tek fonksiyon çağırmış olmaz; küçük bir iş akışı kurmuş olur.

## 4.2 INCLUDE, DECLARE, CALL, CALL(DLL) ve CALL(API)

uXBasic’te dış dünyaya açılmanın üç yolu vardır. `INCLUDE` hazır uXBasic başlığını içeri alır. `DECLARE` dış fonksiyonun imzasını bildirir. `CALL` ise bildirilen işi çalıştırır. Büyük projede doğrudan `CALL(DLL,...)` satırlarını her yere saçmak yerine küçük sarmalayıcı [dış işi temiz uXBasic yordamı gibi gösteren katman] yazılır.

| Araç | Sözdizimi | Görev | Ne zaman kullanılır? |
|---|---|---|---|
| `INCLUDE` | `INCLUDE "modules/ad.uxmh"` | Bildirim ve yardımcı kodu ekler. | uXBasic kütüphanesi kullanırken. |
| `DECLARE` | `DECLARE FUNCTION Ad LIB "x.dll" ALIAS "GercekAd" (...) AS Tip` | DLL/API fonksiyonunu tanıtır. | Windows, C DLL veya runtime çağrısında. |
| `CALL` | `CALL Ad(argler)` | Bildirilmiş yordamı çağırır. | Kendi yordamın veya deklarasyonlu fonksiyon için. |
| `CALL(DLL,...)` | `CALL(DLL,"dll","fonksiyon",tip,çağrı,argler...)` | Düşük düzey dinamik çağrı yapar. | Geçici test veya genel FFI köprüsü için. |
| `CALL(API,...)` | `CALL(API,"servis","iş",argler...)` | Çalışma zamanı API servisini çağırır. | JSON, HTTP, OS, browser, Llama gibi servislerde. |
| `ALIAS` | `ALIAS Kisa = Uzun.Ad` | Uzun adı kısaltır. | Okunabilirliği artırır. |
| `NAMESPACE` | `NAMESPACE ad ... END NAMESPACE` | İsim çakışmasını önler. | Büyük kütüphane ve modül ailesinde. |

### Windows DLL çağrısını sarmalayıcıya çevirmek

```uxbasic
NAMESPACE sistem
    DECLARE FUNCTION GetTickCount LIB "kernel32.dll" ALIAS "GetTickCount" () AS U32

    FUNCTION SimdiMs() AS U32
        RETURN GetTickCount()
    END FUNCTION
END NAMESPACE

MAIN
    DIM basla AS U32
    DIM bitis AS U32
    basla = sistem.SimdiMs()
    FOR i = 1 TO 10000
        ' burada küçük bir işlem varmış gibi düşün
    NEXT i
    bitis = sistem.SimdiMs()
    PRINT "gecen ms="; bitis - basla
END MAIN
```

Burada kullanıcıya gösterilen yüzey `sistem.SimdiMs()` olur. Böylece programın geri kalanı `kernel32.dll`, `ALIAS`, `U32` ayrıntısına boğulmaz. Zeka dolu çözüm budur: dış dünyanın çirkin ayrıntısını bir yerde sakla, temiz adı her yerde kullan.

## 4.3 Çalışma zamanı servisleri

Çalışma zamanı servisi, derlenen programın çalışırken ihtiyaç duyduğu ortak yardımdır. Ekrana yazmak, metin kesmek, rastgele sayı üretmek, dosya açmak, HTTP çağrısı yapmak, tarayıcıda çizim yaptırmak veya WASM dış çağrısı almak bu ailededir.

| Aile | Servisler | Sözdizimi fikri | Nerede kullanılır? |
|---|---|---|---|
| Konsol | `RT_PRINT`, `RT_INPUT`, `RT_CLS`, `RT_COLOR`, `RT_LOCATE` | `PRINT`, `INPUT`, `CLS`, `COLOR`, `LOCATE` | Konsol ve tarayıcı ekranı. |
| Metin | `RT_STR_LEN`, `RT_STR_MID`, `RT_STR_TO_UPPER`, `RT_STR_VAL`, `RT_STR_CHR` | `LEN`, `MID`, `UCASE`, `VAL`, `CHR` | Rapor, CSV, kullanıcı girdisi. |
| Matematik | `RT_MATH_ABS`, `RT_MATH_SQRT`, `RT_MATH_LOG`, `RT_RND`, `RT_TIMER` | `ABS`, `SQRT`, `LOG`, `RND`, `TIMER` | Hesap, süre ölçme, benzetim. |
| Bellek | `RT_MEM_LOAD`, `RT_MEM_STORE`, `RT_MEM_COPY`, `RT_MEM_FILL`, `RT_PEEK`, `RT_POKE` | `PEEK`, `POKE`, `MEMCOPY`, `MEMFILL` | Tampon, düşük seviye, hızlı veri taşıma. |
| Dosya | `RT_FILE_OPEN`, `RT_FILE_READ`, `RT_FILE_WRITE`, `RT_FILE_EOF`, `RT_FILE_LOF` | `OPEN`, `INPUT #`, `PRINT #`, `EOF`, `LOF` | Veri dosyası, rapor, günlük. |
| Dış çağrı | `RT_DLL_LOAD`, `RT_DLL_CALL`, `RT_API_CALL`, `RT_INLINE_NATIVE` | `CALL(DLL,...)`, `CALL(API,...)`, `INLINE` | Windows DLL, C/ASM, dış servis. |
| Kütüphane | `RT_LIBRARY_CALL`, `RT_JSON_CALL`, `RT_REGEX_CALL`, `RT_SQLITE_CALL` | `CALL(API,"json",...)` | JSON, düzenli ifade, veritabanı. |
| Ağ | `RT_HTTP_CALL`, `RT_CURL_CALL`, `RT_SERVER_CALL` | `CALL(API,"http",...)` | REST, Flask, yerel sunucu. |
| Yapay zeka | `RT_LLAMA_CALL`, `RT_ONNX_CALL` | `uxllama.*`, `uxonnx.*` | Yerel metin modeli, ONNX çıkarım. |
| Tarayıcı | `RT_BROWSER_CANVAS`, `RT_BROWSER_AUDIO`, `RT_BROWSER_FETCH`, `RT_WEBGPU_CALL` | `CALL(API,"browser",...)` | HTML/JS oyun, grafik, ses, fetch. |
| WASM | `RT_WASM_IMPORT_CALL`, `RT_WASM_EXPORT_CALL`, `RT_HOST_CALL` | `CALL(API,"wasm",...)` | WASM host köprüsü. |
| Geniş sayı | `RT_EXTFP_CALL` | `fp80`, `fp128`, `bigfp` | Yüksek duyarlıklı hesap. |

### Servis kullanımı örneği — günlük dosyası ve metin temizleme

```uxbasic
MAIN
    DIM satir AS STRING
    DIM temiz AS STRING
    DIM adet AS I32

    TRY
        OPEN "veri/giris.txt" FOR INPUT AS #1
        OPEN "rapor/temiz.txt" FOR OUTPUT AS #2

        DO WHILE EOF(#1) = 0
            INPUT #1, satir
            temiz = UCASE(LTRIM(RTRIM(satir)))
            IF LEN(temiz) = 0 THEN
                PRINT #2, "BOS_SATIR"
            ELSE
                PRINT #2, temiz
                adet = adet + 1
            END IF
        LOOP

        PRINT "temizlenen satir="; adet
    CATCH hata
        PRINT "dosya/metin servisi hatasi: "; hata
    FINALLY
        CLOSE #1
        CLOSE #2
    END TRY
END MAIN
```

Bu örnek, çalışma zamanı servislerinin aslında komutların arkasındaki gerçek işçi olduğunu gösterir. `EOF` dosya servisinden, `UCASE/LTRIM/RTRIM/LEN` metin servisinden, `PRINT #` dosya yazma servisinden beslenir.

# 4.4 Geniş sayı ailesi: `fp80`, `fp128`, `bigfp`, `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL`

Normal `F64` günlük hesap için yeterlidir; fakat bilimsel hesapta, finansal kuruş hesabında, büyük tamsayıda, çok hassas farklarda veya aralık belirsizliğinde geniş sayı gerekir. uXBasic’te bu aileyi iki gözle düşün: dilde görünen tipler ve dış çalışma zamanı handle’ları.

| Ad | Görev | Örnek kullanım | Genç programcıya not |
|---|---|---|---|
| `F80` | 80 bit genişletilmiş kayan sayı | `DIM x AS F80` | Eski x87 hassasiyeti gereken hesaplarda. |
| `F128` | 128 bit yüksek duyarlık | `DIM x AS F128` | Küçük farklar büyüyorsa kullan. |
| `BIGI` | Büyük tamsayı | `DIM n AS BIGI` | Çok basamaklı sayaç, kombinasyon, kripto. |
| `BIGINT` | Büyük tamsayı eş adı | `DIM n AS BIGINT` | Okunurluk için kullanılır. |
| `BIGD` | Çok basamaklı ondalık | `DIM para AS BIGD` | Finans, hassas ölçüm. |
| `BIGF` | Çok hassas kayan sayı | `DIM x AS BIGF` | Bilimsel yaklaşık hesap. |
| `BALL` | Aralık/top sayı | `DIM aralik AS BALL` | Belirsizlik taşıyan sonuçlarda. |

## `bigfp` fonksiyon ailesi

| Fonksiyon | Sözdizimi | Ne yapar? |
|---|---|---|
| `uxb_big_runtime_version` | `v = bigfp.RUNTIME_VERSION()` | Runtime sürümünü verir. Uyumsuz DLL’i erken yakalarsın. |
| `uxb_bigf_init` | `h = bigfp.BIGF_INIT(bit)` | BIGF handle açar. |
| `uxb_bigf_free` | `CALL bigfp.BIGF_FREE(h)` | BIGF kaynağını bırakır. |
| `uxb_bigf_from_str` | `CALL bigfp.BIGF_FROM_STR("3.14", h)` | Metinden yüksek duyarlıklı sayı kurar. |
| `uxb_bigf_to_str` | `CALL bigfp.BIGF_TO_STR(h, out, byte)` | Sayıyı metne çevirir. |
| `uxb_bigf_add/sub/mul/div` | `CALL bigfp.BIGF_ADD(a,b,out)` | Dört işlem yapar. |
| `uxb_bigf_cmp` | `c = bigfp.BIGF_CMP(a,b)` | Karşılaştırma yapar. |
| `uxb_bigd_init` | `h = bigfp.BIGD_INIT(basamak)` | Ondalık büyük sayı açar. |
| `uxb_ball_init` | `h = bigfp.BALL_INIT(bit)` | Aralık/top sayı açar. |
| `uxb_ball_cmp_mid` | `c = bigfp.BALL_CMP_MID(a,b)` | Aralık merkezlerini karşılaştırır. |

### Kallavi örnek — finansal yuvarlama hatasını BIGD ile önlemek

```uxbasic
INCLUDE "modules/bigfp.uxmh"

MAIN
    DIM fiyat AS PTR
    DIM kdv AS PTR
    DIM toplam AS PTR
    DIM cikti AS STRING
    DIM i AS I32

    TRY
        fiyat = bigfp.BIGD_INIT(80)
        kdv = bigfp.BIGD_INIT(80)
        toplam = bigfp.BIGD_INIT(80)
        ASSERT fiyat <> 0
        ASSERT kdv <> 0
        ASSERT toplam <> 0

        CALL bigfp.BIGD_FROM_STR("199.99", fiyat)
        CALL bigfp.BIGD_FROM_STR("1.20", kdv)
        CALL bigfp.BIGD_MUL(fiyat, kdv, toplam)

        cikti = SPACE(128)
        CALL bigfp.BIGD_TO_STR(toplam, cikti, 128)
        PRINT "KDV dahil fiyat="; RTRIM(cikti)

        OPEN "rapor/finans_bigd.txt" FOR OUTPUT AS #1
        PRINT #1, "fiyat=199.99"
        PRINT #1, "kdv=1.20"
        PRINT #1, "sonuc="; RTRIM(cikti)
        CLOSE #1
    CATCH hata
        PRINT "BIGD hesap hatasi: "; hata
    FINALLY
        IF fiyat <> 0 THEN CALL bigfp.BIGD_FREE(fiyat)
        IF kdv <> 0 THEN CALL bigfp.BIGD_FREE(kdv)
        IF toplam <> 0 THEN CALL bigfp.BIGD_FREE(toplam)
    END TRY
END MAIN
```

Buradaki hile şudur: para hesabını `F64` ile yapıp sonra yuvarlama hatasına kızmak yerine baştan `BIGD` seçilir. Handle açılır, metinden sayı kurulur, sonuç metne çevrilir, kaynak kapatılır. Kütüphane kullanımında “aç-kullan-yaz-kapat” disiplini bu yüzden altın kuraldır.

### Kallavi örnek — BALL ile ölçüm belirsizliği taşımak

```uxbasic
INCLUDE "modules/bigfp.uxmh"
INCLUDE "modules/uxstats.uxmh"

MAIN
    DIM phMin AS PTR
    DIM phMax AS PTR
    DIM phOrta AS PTR
    DIM rapor AS STRING

    TRY
        phMin = bigfp.BALL_INIT(128)
        phMax = bigfp.BALL_INIT(128)
        phOrta = bigfp.BALL_INIT(128)

        CALL bigfp.BALL_FROM_STR("7.18", phMin)
        CALL bigfp.BALL_FROM_STR("7.24", phMax)
        CALL bigfp.BALL_ADD(phMin, phMax, phOrta)
        ' varsayım: ikiye bölme ayrı çağrıyla yapılabilir
        CALL bigfp.BALL_DIV_STR(phOrta, "2", phOrta)

        rapor = SPACE(128)
        CALL bigfp.BALL_TO_STR(phOrta, rapor, 128)

        IF bigfp.BALL_CMP_MID(phOrta, phMin) >= 0 THEN
            PRINT "olcum araligi tasindi: "; RTRIM(rapor)
        ELSE
            PRINT "aralik hesap denetimi gerekli"
        END IF
    CATCH hata
        PRINT "BALL belirsizlik hesabi hatasi: "; hata
    FINALLY
        IF phMin <> 0 THEN CALL bigfp.BALL_FREE(phMin)
        IF phMax <> 0 THEN CALL bigfp.BALL_FREE(phMax)
        IF phOrta <> 0 THEN CALL bigfp.BALL_FREE(phOrta)
    END TRY
END MAIN
```

Bu örneğin mantığı şudur: bazı deneylerde tek sayı yalan söyler. Ölçüm cihazı `7.21` dese bile güven aralığı vardır. `BALL`, “sonuç şu aralıkta” düşüncesini programa taşır.

# 4.5 Koleksiyon kütüphanesi: `uxcollections`

`uxcollections`, liste, yığın, kuyruk, sözlük ve küme ailesidir. 3. ciltte `LIST`, `DICT`, `SET` dil yüzeyi anlatıldı; burada bunların dış çalışma zamanı karşılığı düşünülür. Büyük veriyi her seferinde BASIC dizisine kopyalamak yerine handle ile taşımak daha hızlı ve temizdir.

| Fonksiyon ailesi | Sözdizimi | Görev | Kullanım yeri |
|---|---|---|---|
| `uxc_list_new/free/count` | `l = uxc.LIST_NEW()` | Liste açar, kapatır, sayar. | Sıralı ölçüm, kayıt listesi. |
| `uxc_list_push_f64/get_f64` | `CALL uxc.LIST_PUSH_F64(l,x)` | Sayı ekler ve okur. | Sensör, kalite verisi. |
| `uxc_stack_push/pop_f64` | `CALL uxc.STACK_PUSH_F64(s,x)` | Son giren ilk çıkar. | Geri alma, parser yığını. |
| `uxc_queue_push/pop_f64` | `CALL uxc.QUEUE_PUSH_F64(q,x)` | İlk giren ilk çıkar. | Olay kuyruğu, iş listesi. |
| `uxc_set_add/contains` | `CALL uxc.SET_ADD(k,"A")` | Tekrarsız değer tutar. | Etiket, benzersiz parti kodu. |

### Kallavi örnek — üretim kalite kuyruğu, liste ve küme birlikte

```uxbasic
INCLUDE "modules/uxcollections.uxmh"
INCLUDE "modules/uxstats.uxmh"

MAIN
    DIM q AS PTR
    DIM tekrar AS PTR
    DIM i AS I32
    DIM deger AS F64
    DIM toplam AS F64
    DIM ort AS F64
    DIM red AS I32

    q = uxc.QUEUE_NEW()
    tekrar = uxc.SET_NEW()
    ASSERT q <> 0
    ASSERT tekrar <> 0

    FOR i = 1 TO 30
        deger = 99.5 + RND() * 1.4
        IF i = 7 THEN deger = 96.1
        IF i = 18 THEN deger = 103.4
        CALL uxc.QUEUE_PUSH_F64(q, deger)
    NEXT i

    OPEN "rapor/kalite_kuyruk.txt" FOR OUTPUT AS #1
    FOR i = 1 TO 30
        deger = uxc.QUEUE_POP_F64(q)
        toplam = toplam + deger
        IF deger < 98.0 OR deger > 102.0 THEN
            red = red + 1
            PRINT #1, "HATALI;"; i; ";"; deger
            CALL uxc.SET_ADD(tekrar, "HATALI_PARTI")
        ELSE
            PRINT #1, "OK;"; i; ";"; deger
        END IF
    NEXT i
    ort = toplam / 30
    PRINT #1, "ortalama="; ort
    PRINT #1, "hata_adedi="; red
    CLOSE #1

    IF uxc.SET_CONTAINS(tekrar, "HATALI_PARTI") THEN
        PRINT "kalite uyari: hata var"
    ELSE
        PRINT "kalite uygun"
    END IF

    CALL uxc.QUEUE_FREE(q)
    CALL uxc.SET_FREE(tekrar)
END MAIN
```

Bu programda kuyruk üretim hattını temsil eder. Ürünler sırayla gelir, kontrol edilir, rapora yazılır. Küme ise “hata var mı?” bilgisini tekrarsız tutar. Bu, yüz satırlık `IF parti = ...` zinciri yerine veri yapısıyla düşünmeyi öğretir.

# 4.6 Matematik çekirdeği: `uxmath` ve `uxmathcore`

`uxmath`, günlük vektör ve matematik işlerini; `uxmathcore` ise daha düşük seviyeli tampon, tip ve hızlı blok işlerini taşır. Basit programda `FOR` döngüsüyle toplam alabilirsin; ama veri büyüdüğünde vektör, tampon ve çekirdek fonksiyonlar hız kazandırır.

| Kütüphane | Fonksiyon ailesi | Görev |
|---|---|---|
| `uxmath` | `vec_create/free/push/get/count` | Sayısal vektör yönetimi. |
| `uxmath` | `sum/mean/min/max/dot/norm` | Temel sayısal özet. |
| `uxmath` | `scale/add/sub` | Vektör dönüşümü. |
| `uxmathcore` | `buffer_create/free/type/count` | Ham tampon açma ve yönetme. |
| `uxmathcore` | `buffer_data_ptr` | Dış DLL’e bellek adresi verme. |
| `uxmathcore` | `fill/copy/sort` | Büyük veriyi blok olarak işleme. |
| `uxmathcore` | `type_size/type_name` | Tip boyutu ve adı alma. |

### Tampon nasıl oluşturulur ve üzerinde nasıl işlem yapılır?

Tampon [büyük veriyi geçici olarak tutan ham alan] özellikle dış kütüphane ve hızlı hesap için kullanılır. Dizi programcıya kolay görünür; tampon ise bilgisayara hızlı görünür. İyi sarmalayıcı ikisini birleştirir: kullanıcı liste gibi kullanır, içeride tampon çalışır.

```uxbasic
INCLUDE "modules/uxmathcore.uxmh"
INCLUDE "modules/uxstats.uxmh"

MAIN
    DIM buf AS PTR
    DIM adres AS PTR
    DIM i AS I32
    DIM n AS I32
    DIM x AS F64
    DIM ort AS F64

    n = 1000
    TRY
        buf = uxmathcore.BUFFER_CREATE("F64", n)
        ASSERT buf <> 0
        adres = uxmathcore.BUFFER_DATA_PTR(buf)
        ASSERT adres <> 0

        FOR i = 0 TO n - 1
            x = 10.0 + SIN(i / 10.0) + RND() * 0.2
            CALL uxmathcore.BUFFER_SET_F64(buf, i, x)
        NEXT i

        ort = uxstats.MEAN_BUFFER_F64(adres, n)
        PRINT "tampon ortalama="; ort

        CALL uxmathcore.BUFFER_SORT_F64(buf)
        PRINT "en kucuk="; uxmathcore.BUFFER_GET_F64(buf, 0)
        PRINT "en buyuk="; uxmathcore.BUFFER_GET_F64(buf, n - 1)
    CATCH hata
        PRINT "tampon isleme hatasi: "; hata
    FINALLY
        IF buf <> 0 THEN CALL uxmathcore.BUFFER_FREE(buf)
    END TRY
END MAIN
```

Bu örnek, “tamponu nasıl oluşturacağım?” sorusuna doğrudan cevap verir: `BUFFER_CREATE` ile aç, `BUFFER_DATA_PTR` ile adresini al, `BUFFER_SET_F64` ile doldur, istatistik fonksiyonuna adres ve adet ver, sonunda `BUFFER_FREE` ile kapat.

# 4.7 İstatistik kütüphaneleri: `uxstats` ve `uxstats2`

`uxstats` temel istatistiği, `uxstats2` ileri istatistik ve testleri taşır. Ortalama tek başına çoğu zaman yetmez; standart sapma, varyans, güven aralığı, Z testi, T testi, F testi, korelasyon ve aykırı değer kontrolü gerekir.

| Fonksiyon ailesi | Sözdizimi | Görev | Kullanım örneği |
|---|---|---|---|
| `mean` | `ort = uxstats.MEAN_F64(ptr,n)` | Ortalama alır. | Üretim ölçümü. |
| `variance/stddev` | `sd = uxstats.STDDEV_F64(ptr,n)` | Dağılımı ölçer. | Kalite dalgalanması. |
| `min/max/range` | `mn = uxstats.MIN_F64(ptr,n)` | Sınırları bulur. | Tolerans kontrolü. |
| `zscore` | `z = uxstats2.Z_SCORE(x, ort, sd)` | Bir ölçüm ne kadar uçta? | Hata analizi. |
| `ttest` | `p = uxstats2.T_TEST(a,b)` | İki ortalama farkı. | Deney karşılaştırma. |
| `ftest` | `p = uxstats2.F_TEST(v1,v2)` | Varyans farkı. | İki üretim hattı. |
| `corr` | `r = uxstats2.CORR(x,y,n)` | İki seri ilişkisi. | Sıcaklık-verim. |

### Kallavi örnek — 30 ölçümle üretim kalite kontrolü

```uxbasic
INCLUDE "modules/uxmathcore.uxmh"
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxstats2.uxmh"

MAIN
    DIM buf AS PTR
    DIM i AS I32
    DIM n AS I32
    DIM x AS F64
    DIM ort AS F64
    DIM sd AS F64
    DIM z AS F64
    DIM hata AS I32

    n = 30
    buf = uxmathcore.BUFFER_CREATE("F64", n)
    ASSERT buf <> 0

    FOR i = 0 TO n - 1
        x = 100.0 + RND() * 1.2 - 0.6
        IF i = 11 THEN x = 96.8
        IF i = 24 THEN x = 103.1
        CALL uxmathcore.BUFFER_SET_F64(buf, i, x)
    NEXT i

    ort = uxstats.MEAN_BUFFER_F64(uxmathcore.BUFFER_DATA_PTR(buf), n)
    sd = uxstats.STDDEV_BUFFER_F64(uxmathcore.BUFFER_DATA_PTR(buf), n)

    OPEN "rapor/uretim_kalite_30.csv" FOR OUTPUT AS #1
    PRINT #1, "no;deger;z;karar"
    FOR i = 0 TO n - 1
        x = uxmathcore.BUFFER_GET_F64(buf, i)
        z = uxstats2.Z_SCORE(x, ort, sd)
        IF ABS(z) > 2.5 THEN
            hata = hata + 1
            PRINT #1, i + 1; ";"; x; ";"; z; ";KONTROL"
        ELSE
            PRINT #1, i + 1; ";"; x; ";"; z; ";OK"
        END IF
    NEXT i
    PRINT #1, "ortalama;"; ort
    PRINT #1, "stdsapma;"; sd
    PRINT #1, "hata_adedi;"; hata
    CLOSE #1

    IF hata > 0 THEN
        PRINT "uretim hatti yeniden ayarlanacak"
    ELSE
        PRINT "uretim dagilimi kabul edilebilir"
    END IF

    CALL uxmathcore.BUFFER_FREE(buf)
END MAIN
```

Burada kalite yorumu yalnız “ortalama iyi” değildir. Standart sapma ve Z skoru ile uç değerler bulunur. Bu zeka dolu bir alışkanlıktır: toplam sonucu değil, sonucu bozan satırı yakala.

### Kallavi örnek — iki yem denemesini F testi ve T testiyle karşılaştırma

```uxbasic
INCLUDE "modules/uxmathcore.uxmh"
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxstats2.uxmh"

MAIN
    DIM kontrol AS PTR
    DIM deneme AS PTR
    DIM i AS I32
    DIM n AS I32
    DIM ortK AS F64
    DIM ortD AS F64
    DIM varK AS F64
    DIM varD AS F64
    DIM pT AS F64
    DIM pF AS F64

    n = 12
    kontrol = uxmathcore.BUFFER_CREATE("F64", n)
    deneme = uxmathcore.BUFFER_CREATE("F64", n)

    FOR i = 0 TO n - 1
        CALL uxmathcore.BUFFER_SET_F64(kontrol, i, 1.20 + RND() * 0.12)
        CALL uxmathcore.BUFFER_SET_F64(deneme, i, 1.33 + RND() * 0.14)
    NEXT i

    ortK = uxstats.MEAN_BUFFER_F64(uxmathcore.BUFFER_DATA_PTR(kontrol), n)
    ortD = uxstats.MEAN_BUFFER_F64(uxmathcore.BUFFER_DATA_PTR(deneme), n)
    varK = uxstats.VARIANCE_BUFFER_F64(uxmathcore.BUFFER_DATA_PTR(kontrol), n)
    varD = uxstats.VARIANCE_BUFFER_F64(uxmathcore.BUFFER_DATA_PTR(deneme), n)
    pT = uxstats2.T_TEST_BUFFER_F64(uxmathcore.BUFFER_DATA_PTR(kontrol), uxmathcore.BUFFER_DATA_PTR(deneme), n, n)
    pF = uxstats2.F_TEST_VARIANCE(varK, varD, n - 1, n - 1)

    PRINT "kontrol ort="; ortK
    PRINT "deneme ort="; ortD
    PRINT "T testi p="; pT
    PRINT "F testi p="; pF

    IF pT < 0.05 THEN PRINT "yem etkisi anlamli olabilir" ELSE PRINT "fark zayif"
    IF pF < 0.05 THEN PRINT "varyanslar farkli; yoruma dikkat" ELSE PRINT "varyans farki buyuk degil"

    CALL uxmathcore.BUFFER_FREE(kontrol)
    CALL uxmathcore.BUFFER_FREE(deneme)
END MAIN
```

Bu örnekte T testi ortalama farkını, F testi dağılım farkını düşündürür. Genç programcıya ders: bilimsel yorumda tek p değeriyle sevinme; varyans, örnek sayısı ve deney düzeni birlikte okunur.

# 4.8 Matris ve tensör: `uxmatrix` ve `uxtensor`

Matris iki boyutlu sayısal tablodur; tensör [çok boyutlu sayı kabı] iki, üç, dört veya daha fazla boyutlu veriyi taşır. Görüntü işleme, yapay zeka, zaman serisi, deney x tank x gün x parametre gibi yapılarda tensör gerekir.

| Kütüphane | Fonksiyon ailesi | Görev |
|---|---|---|
| `uxmatrix` | `create/free/rows/cols` | Matris açar, kapatır, boyut verir. |
| `uxmatrix` | `set/get/data_ptr` | Hücre yazar/okur ve ham adres verir. |
| `uxmatrix` | `add/mul/transpose/inverse` | Matris işlemleri yapar. |
| `uxtensor` | `create1d/2d/3d/4d/free` | Çok boyutlu veri alanı açar. |
| `uxtensor` | `shape/set/get/reshape` | Şekil ve eleman yönetir. |
| `uxtensor` | `sum/mean/axis` | Boyutlara göre özet alır. |

### Kallavi örnek — 4 boyutlu deney tensörü

```uxbasic
INCLUDE "modules/uxtensor.uxmh"
INCLUDE "modules/uxstats.uxmh"

MAIN
    DIM t AS PTR
    DIM tank AS I32
    DIM gun AS I32
    DIM tekrar AS I32
    DIM param AS I32
    DIM deger AS F64
    DIM toplam AS F64
    DIM adet AS I32

    ' boyutlar: tank x gun x tekrar x parametre
    t = uxtensor.CREATE4D_F64(3, 7, 4, 2)
    ASSERT t <> 0

    FOR tank = 0 TO 2
        FOR gun = 0 TO 6
            FOR tekrar = 0 TO 3
                FOR param = 0 TO 1
                    IF param = 0 THEN
                        deger = 7.1 + tank * 0.05 + RND() * 0.1
                    ELSE
                        deger = 24.0 + gun * 0.2 + RND() * 0.5
                    END IF
                    CALL uxtensor.SET4D_F64(t, tank, gun, tekrar, param, deger)
                NEXT param
            NEXT tekrar
        NEXT gun
    NEXT tank

    FOR tank = 0 TO 2
        toplam = 0
        adet = 0
        FOR gun = 0 TO 6
            FOR tekrar = 0 TO 3
                toplam = toplam + uxtensor.GET4D_F64(t, tank, gun, tekrar, 0)
                adet = adet + 1
            NEXT tekrar
        NEXT gun
        PRINT "tank "; tank + 1; " pH ort="; toplam / adet
    NEXT tank

    CALL uxtensor.FREE(t)
END MAIN
```

Bu örnekte dört boyut korkulacak şey değildir. Boyutlara gerçek ad verirsen akıl karışmaz: tank, gün, tekrar, parametre. Genç programcı için püf noktası: çok boyutlu dizide indeksleri `i,j,k,l` diye bırakma; anlamlı ad ver.

# 4.9 Tablo ve veri kümesi: `uxdataframe` ve `uxdataset`

Veri çerçevesi [satır ve sütundan oluşan tablo] (dataframe), CSV ve veritabanı işlerinin merkezidir. `uxdataset` ise makine öğrenmesi için giriş/çıkış ayrımı, eğitim/test bölme ve toplu işleme düzeni sağlar.

| Fonksiyon ailesi | Görev | Örnek sözdizimi |
|---|---|---|
| `uxdf_open_memory/open_database` | Bellekte veya dosyada tablo oturumu açar. | `db = uxdf.OPEN_MEMORY()` |
| `uxdf_load_csv/save_csv` | CSV yükler/kaydeder. | `CALL uxdf.LOAD_CSV(db,"veri.csv","olcum")` |
| `uxdf_query` | SQL benzeri sorgu çalıştırır. | `sonuc = uxdf.QUERY(db,"SELECT ...")` |
| `uxdf_row_count/column_count` | Tablo boyutunu verir. | `n = uxdf.ROW_COUNT(df)` |
| `uxdataset_load_csv` | Veri kümesi yükler. | `ds = uxdataset.LOAD_CSV("train.csv")` |
| `uxdataset_split` | Eğitim/test ayırır. | `CALL uxdataset.SPLIT(ds,0.8,train,test)` |
| `uxdataset_batch` | Toplu eğitim parçası verir. | `batch = uxdataset.BATCH(ds,32)` |

### Kallavi örnek — CSV’den kalite raporu ve SQL süzme

```uxbasic
INCLUDE "modules/uxdataframe.uxmh"
INCLUDE "modules/uxstats.uxmh"

MAIN
    DIM db AS PTR
    DIM tablo AS PTR
    DIM hatali AS PTR
    DIM adet AS I32
    DIM ort AS F64

    TRY
        db = uxdf.OPEN_MEMORY()
        ASSERT db <> 0
        tablo = uxdf.LOAD_CSV(db, "veri/uretim.csv", "uretim")
        ASSERT tablo <> 0

        adet = uxdf.ROW_COUNT(tablo)
        ort = uxdf.COLUMN_MEAN_F64(tablo, "agirlik")
        hatali = uxdf.QUERY(db, "SELECT * FROM uretim WHERE agirlik < 98 OR agirlik > 102")

        PRINT "satir="; adet
        PRINT "agirlik ort="; ort
        PRINT "hatali satir="; uxdf.ROW_COUNT(hatali)

        CALL uxdf.SAVE_CSV(hatali, "rapor/hatalilar.csv")
    CATCH hata
        PRINT "dataframe hatasi: "; hata
    FINALLY
        IF db <> 0 THEN CALL uxdf.FREE(db)
    END TRY
END MAIN
```

Bu örnekte tabloyu döngüyle satır satır gezmek yerine sorgu kullanılır. Zeka dolu çözüm şudur: veri büyüyünce kararı kod satırıyla değil, sorgu cümlesiyle anlat.

# 4.10 Graf kütüphanesi: `uxgraph`

Graf [düğüm ve bağlantılardan oluşan yapı] yol, ilişki, ağ ve bağımlılık problemlerinde kullanılır. Şehirler arası yol, paket bağımlılığı, atıf ağı, sınıf ilişkisi, sosyal ağ veya üretim hattı akışı grafla modellenir.

| Fonksiyon | Görev | Örnek |
|---|---|---|
| `uxgraph_create/free` | Graf açar/kapatır. | `g = uxgraph.CREATE(TRUE)` |
| `uxgraph_add_vertex` | Düğüm ekler. | `CALL uxgraph.ADD_VERTEX(g,"A")` |
| `uxgraph_add_edge` | Kenar ekler. | `CALL uxgraph.ADD_EDGE(g,"A","B",2.5)` |
| `uxgraph_vcount/ecount` | Düğüm/kenar sayısı verir. | `PRINT uxgraph.VCOUNT(g)` |
| `uxgraph_shortest_path` | En kısa yol bulur. | `p = uxgraph.SHORTEST_PATH(g,"A","D")` |
| `uxgraph_degree` | Bağlantı sayısı verir. | `d = uxgraph.DEGREE(g,"A")` |
| `uxgraph_export_dot` | Graphviz DOT çıktısı yazar. | `CALL uxgraph.EXPORT_DOT(g,"g.dot")` |

### Kallavi örnek — üretim hattında darboğaz bulma

```uxbasic
INCLUDE "modules/uxgraph.uxmh"

MAIN
    DIM g AS PTR
    DIM yol AS STRING
    DIM maliyet AS F64

    g = uxgraph.CREATE(TRUE)
    ASSERT g <> 0

    CALL uxgraph.ADD_VERTEX(g, "HAMMADDE")
    CALL uxgraph.ADD_VERTEX(g, "KESIM")
    CALL uxgraph.ADD_VERTEX(g, "YIKAMA")
    CALL uxgraph.ADD_VERTEX(g, "PAKET")
    CALL uxgraph.ADD_VERTEX(g, "DEPO")

    CALL uxgraph.ADD_EDGE(g, "HAMMADDE", "KESIM", 4.0)
    CALL uxgraph.ADD_EDGE(g, "KESIM", "YIKAMA", 3.5)
    CALL uxgraph.ADD_EDGE(g, "YIKAMA", "PAKET", 2.0)
    CALL uxgraph.ADD_EDGE(g, "PAKET", "DEPO", 1.0)
    CALL uxgraph.ADD_EDGE(g, "KESIM", "PAKET", 7.5)

    yol = uxgraph.SHORTEST_PATH_TEXT(g, "HAMMADDE", "DEPO")
    maliyet = uxgraph.SHORTEST_PATH_COST(g, "HAMMADDE", "DEPO")

    PRINT "en uygun yol="; yol
    PRINT "toplam sure="; maliyet
    CALL uxgraph.EXPORT_DOT(g, "rapor/uretim_hatti.dot")
    CALL uxgraph.FREE(g)
END MAIN
```

Genç programcı için ders: bazen `IF` ile karar vermek yerine problemi modele çevirmek gerekir. Üretim hattı bir graf olunca “nereden gideyim?” sorusu algoritmaya dönüşür.

# 4.11 Yapay zeka matematiği ve sinir ağı: `uxaimath`, `uxnn`, `uxnn2`, `uxnn3`

Bu aile, aktivasyon, kayıp, gradyan, katman ve eğitim işlerini taşır. `uxaimath` ham matematik, `uxnn` küçük sinir ağı, `uxnn2` katmanlı ağ, `uxnn3` veri kümesi ve eğitim düzeni tarafını güçlendirir.

| Kütüphane | Fonksiyon ailesi | Görev |
|---|---|---|
| `uxaimath` | `sigmoid/relu/gelu/swish/softmax` | Aktivasyon hesabı. |
| `uxaimath` | `mse/mae/bce/cce` | Kayıp hesabı. |
| `uxaimath` | `sgd/momentum/clip` | Öğrenme güncellemesi. |
| `uxnn` | `neuron_create/set_weight/forward` | Tek nöron ve küçük ağ. |
| `uxnn2` | `network_create/add_dense/train` | Katmanlı ağ kurma. |
| `uxnn3` | `dataset_load/split/train/evaluate` | Veri kümesiyle eğitim. |

### Kallavi örnek — dört nöronlu karar sistemi

```uxbasic
INCLUDE "modules/uxaimath.uxmh"
INCLUDE "modules/uxnn.uxmh"

MAIN
    DIM x1 AS F64
    DIM x2 AS F64
    DIM h1 AS F64
    DIM h2 AS F64
    DIM h3 AS F64
    DIM h4 AS F64
    DIM skor AS F64

    x1 = 0.72   ' pH uygunluk skoru
    x2 = 0.41   ' sicaklik risk skoru

    h1 = uxaimath.RELU(x1 * 0.8 + x2 * -0.2 + 0.1)
    h2 = uxaimath.RELU(x1 * -0.4 + x2 * 0.9 + 0.2)
    h3 = uxaimath.SIGMOID(x1 * 0.3 + x2 * 0.3)
    h4 = uxaimath.SWISH(x1 - x2)
    skor = uxaimath.SIGMOID(h1 * 0.6 + h2 * -0.5 + h3 * 0.4 + h4 * 0.3)

    IF skor > 0.65 THEN
        PRINT "risk var: kontrol et"
    ELSE
        PRINT "sistem kabul edilebilir"
    END IF
END MAIN
```

Bu örnek eğitimli büyük model değildir; genç programcıya sinir ağının mantığını öğretir. Girişler ağırlıklarla çarpılır, ara nöronlar hesaplanır, son skor karar verir. Zeka dolu çözüm: her yapay zeka işini hemen dev modele atma; önce küçük modelle aklı kur.

# 4.12 ONNX ve Llama: `uxonnx`, `uxonnx2`, `uxllama`

`uxonnx`, hazır makine öğrenmesi modelini yükleyip çalıştırmaya yarar. `uxllama`, yerel metin modeline soru sorma köprüsüdür. Bu iki kütüphane farklıdır: ONNX sayısal model çalıştırır, Llama metin cevabı üretir.

| Kütüphane | Fonksiyon ailesi | Görev |
|---|---|---|
| `uxonnx` | `global_init/session_create/free` | ONNX oturumu açar/kapatır. |
| `uxonnx` | `input_count/output_count/input_name` | Model giriş/çıkışlarını okur. |
| `uxonnx` | `run` | Modeli çalıştırır. |
| `uxonnx2` | `provider_available/session_create_advanced` | CPU/GPU sağlayıcı seçimi. |
| `uxllama` | `create/free/set_cli_path/set_model_path` | Llama oturumu hazırlar. |
| `uxllama` | `set_threads/set_context/set_predict` | Çalışma ayarlarını yapar. |
| `uxllama` | `generate` | Metin üretir. |

### Kallavi örnek — yerel Llama ile laboratuvar rapor yorumu

```uxbasic
INCLUDE "modules/uxllama.uxmh"

MAIN
    DIM llm AS PTR
    DIM soru AS STRING
    DIM cevap AS STRING

    TRY
        llm = uxllama.CREATE()
        ASSERT llm <> 0
        CALL uxllama.SET_CLI_PATH(llm, "tools/llama/llama-cli.exe")
        CALL uxllama.SET_MODEL_PATH(llm, "models/yerel.gguf")
        CALL uxllama.SET_THREADS(llm, 4)
        CALL uxllama.SET_CONTEXT(llm, 4096)
        CALL uxllama.SET_PREDICT(llm, 256)

        soru = "pH 7.2, sicaklik 24.8, oksijen 6.1 mg/L. Kisa yetistiricilik yorumu yap."
        cevap = uxllama.GENERATE(llm, soru)

        OPEN "rapor/llama_laboratuvar_yorum.txt" FOR OUTPUT AS #1
        PRINT #1, cevap
        CLOSE #1
        PRINT cevap
    CATCH hata
        PRINT "llama calisma hatasi: "; hata
    FINALLY
        IF llm <> 0 THEN CALL uxllama.FREE(llm)
    END TRY
END MAIN
```

Burada önemli güvenlik notu vardır: yerel model cevabı bilimsel gerçek sayılmaz; öneri üretir. Genç programcı bunu rapor yardımcısı gibi kullanır, hakem veya laboratuvar cihazı gibi değil.

### Kallavi örnek — ONNX ile sınıflandırma modeli çalıştırma

```uxbasic
INCLUDE "modules/uxonnx2.uxmh"
INCLUDE "modules/uxmathcore.uxmh"

MAIN
    DIM sess AS PTR
    DIM giris AS PTR
    DIM cikis AS PTR
    DIM sinif AS I32

    TRY
        CALL uxonnx2.INIT()
        IF uxonnx2.PROVIDER_AVAILABLE("CPU") = 0 THEN THROW "CPU provider yok"

        sess = uxonnx2.SESSION_CREATE_ADVANCED("models/kalite.onnx", "CPU")
        ASSERT sess <> 0

        giris = uxmathcore.BUFFER_CREATE("F64", 4)
        CALL uxmathcore.BUFFER_SET_F64(giris, 0, 7.20)
        CALL uxmathcore.BUFFER_SET_F64(giris, 1, 24.5)
        CALL uxmathcore.BUFFER_SET_F64(giris, 2, 6.8)
        CALL uxmathcore.BUFFER_SET_F64(giris, 3, 0.12)

        cikis = uxonnx2.RUN_F64(sess, uxmathcore.BUFFER_DATA_PTR(giris), 4)
        sinif = uxonnx2.ARGMAX_OUTPUT(cikis)

        SELECT CASE sinif
        CASE 0: PRINT "normal"
        CASE 1: PRINT "uyari"
        CASE 2: PRINT "kritik"
        CASE ELSE: PRINT "bilinmeyen"
        END SELECT
    CATCH hata
        PRINT "ONNX hata: "; hata
    FINALLY
        IF giris <> 0 THEN CALL uxmathcore.BUFFER_FREE(giris)
        IF sess <> 0 THEN CALL uxonnx2.SESSION_FREE(sess)
    END TRY
END MAIN
```

# 4.13 JSON, düzenli ifade, HTTP, SQLite, OS, Lua ve Prolog servisleri

Bu grup genel amaçlı dış dünya servisleridir. JSON API verisini taşır; düzenli ifade [metin içinde desen arama] (regex) metni ayıklar; HTTP ve curl ağ isteği yapar; SQLite küçük veritabanıdır; OS işletim sistemi işlemleridir; Lua gömülü betik, Prolog mantıksal sorgu motorudur.

| Servis | Sözdizimi fikri | Görev | Örnek kullanım |
|---|---|---|---|
| JSON | `CALL(API,"json","parse",metin)` | Metni nesneye çevirir. | API cevabı okuma. |
| Regex | `CALL(API,"regex","match",metin,desen)` | Desen bulur. | Log ayıklama. |
| HTTP | `CALL(API,"http","get",url)` | Ağdan veri alır. | REST çağrısı. |
| Curl | `CALL(API,"curl","post",url,json)` | Daha gelişmiş ağ çağrısı. | ChatGPT/Gemini köprüsü. |
| SQLite | `CALL(API,"sqlite","query",db,sql)` | Yerel SQL çalıştırır. | Küçük veri deposu. |
| OS | `CALL(API,"os","exists",yol)` | Dosya/dizin/süreç bilgisi. | Kurulum kontrolü. |
| Lua | `CALL(API,"lua","eval",kod)` | Küçük betik çalıştırır. | Kullanıcı eklentisi. |
| Prolog | `CALL(API,"prolog","query",sorgu)` | Mantıksal sorgu yapar. | Kural motoru. |

### Kallavi örnek — REST API, JSON ve SQLite ile küçük veri toplayıcı

```uxbasic
INCLUDE "modules/uxhttp.uxmh"
INCLUDE "modules/uxjson.uxmh"
INCLUDE "modules/uxsqlite.uxmh"

MAIN
    DIM cevap AS STRING
    DIM json AS PTR
    DIM db AS PTR
    DIM sicaklik AS F64
    DIM ph AS F64

    TRY
        cevap = CALL(API, "http", "get", "http://localhost:5000/olcum")
        json = CALL(API, "json", "parse", cevap)
        ASSERT json <> 0

        sicaklik = CALL(API, "json", "get_f64", json, "sicaklik")
        ph = CALL(API, "json", "get_f64", json, "ph")

        db = CALL(API, "sqlite", "open", "rapor/olcum.db")
        CALL(API, "sqlite", "exec", db, "CREATE TABLE IF NOT EXISTS olcum(ph REAL, sicaklik REAL)")
        CALL(API, "sqlite", "exec", db, "INSERT INTO olcum VALUES(" + STR(ph) + "," + STR(sicaklik) + ")")

        IF ph < 6.8 OR ph > 7.8 THEN
            PRINT "pH uyarisi"
        ELSE
            PRINT "pH uygun"
        END IF
    CATCH hata
        PRINT "REST/JSON/SQLite hatasi: "; hata
    FINALLY
        IF db <> 0 THEN CALL(API, "sqlite", "close", db)
        IF json <> 0 THEN CALL(API, "json", "free", json)
    END TRY
END MAIN
```

Bu örnek gerçek program mantığını öğretir: veri ağdan gelir, JSON ile ayrılır, SQLite’a yazılır, karar ekrana döner. Tek tek komut bilmek değil, akışı kurmak önemlidir.

# 4.14 Tarayıcı, grafik, ses, görüntü, WebGPU ve WASM servisleri

Tarayıcı hedefinde uXBasic çıktısı yalnız JS dosyası değildir. HTML kabuğu, manifest, canvas, ses, fetch, WebGPU ve WASM köprüsü birlikte düşünülür. Bu aile 5. ciltte daha geniş işlenecek; burada kütüphane olarak görevleri verilir.

| Servis | Görev | Örnek sözdizimi |
|---|---|---|
| Browser canvas | 2B çizim yapar. | `CALL(API,"browser.canvas","line",x1,y1,x2,y2)` |
| Browser audio | Ses üretir/çalır. | `CALL(API,"browser.audio","beep",440,100)` |
| Browser input | Klavye/fare okur. | `CALL(API,"browser.input","key")` |
| Browser fetch | Ağdan veri alır. | `CALL(API,"browser.fetch","get",url)` |
| WebGPU | GPU üzerinde hesap/çizim. | `CALL(API,"webgpu","dispatch",shader,args)` |
| Image | Görüntü yükler/işler. | `CALL(API,"image","load",yol)` |
| Graphics | Masaüstü grafik katmanı. | `CALL(API,"graphics","rect",x,y,w,h)` |
| WASM import/export | Host ile WASM arası çağrı. | `CALL(API,"wasm","import",ad)` |

### Kallavi örnek — tarayıcıda kalite grafiği

```uxbasic
%%TARGET BROWSER
%%HTML_BEGIN "index.html" BODY
<canvas id="c" width="640" height="360"></canvas>
<pre id="log"></pre>
%%HTML_END

MAIN
    DIM i AS I32
    DIM x AS I32
    DIM y AS I32
    DIM deger AS F64

    CALL(API, "browser.canvas", "bind", "c")
    CALL(API, "browser.canvas", "clear", 255, 255, 255)
    CALL(API, "browser.canvas", "line", 40, 300, 620, 300)
    CALL(API, "browser.canvas", "line", 40, 20, 40, 300)

    FOR i = 1 TO 30
        deger = 100 + RND() * 4 - 2
        x = 40 + i * 18
        y = 300 - CINT((deger - 96) * 30)
        IF deger < 98 OR deger > 102 THEN
            CALL(API, "browser.canvas", "circle", x, y, 5, "red")
            CALL(API, "browser.audio", "beep", 220, 80)
        ELSE
            CALL(API, "browser.canvas", "circle", x, y, 4, "green")
        END IF
    NEXT i

    CALL(API, "browser.log", "write", "kalite grafigi tamam")
END MAIN
```

Bu örnek genç programcıya şunu gösterir: aynı kalite fikri konsolda rapor, dosyada CSV, tarayıcıda grafik olabilir. Kütüphane, fikrin dış dünyadaki elidir.

# 4.15 Arşiv, kripto, sunucu ve stringx servisleri

Bu servisler üretim programlarında sık görünür. Arşiv dosya paketler, kripto hash/şifreleme yapar, server küçük yerel servis açar, stringx gelişmiş metin işleme sağlar.

| Servis | Görev | Güvenli kullanım notu |
|---|---|---|
| Archive | Zip açma/yazma. | Yol geçişi saldırılarına karşı dosya adını denetle. |
| Crypto | Hash, HMAC, şifreleme. | Anahtarı kaynak koda düz yazma. |
| Server | Yerel HTTP/REST sunucu. | Port çakışması ve erişim sınırı koy. |
| Stringx | Gelişmiş metin bölme, slug, normalize. | Türkçe karakter dönüşümünü test et. |

### Kallavi örnek — raporu arşivle, hash üret, küçük sunucuda sun

```uxbasic
INCLUDE "modules/uxarchive.uxmh"
INCLUDE "modules/uxcrypto.uxmh"
INCLUDE "modules/uxserver.uxmh"

MAIN
    DIM hash AS STRING
    DIM zip AS STRING

    TRY
        zip = "dist/rapor_paketi.zip"
        CALL(API, "archive", "create", zip)
        CALL(API, "archive", "add", zip, "rapor/uretim_kalite_30.csv")
        CALL(API, "archive", "add", zip, "rapor/hatalilar.csv")
        CALL(API, "archive", "close", zip)

        hash = CALL(API, "crypto", "sha256_file", zip)
        PRINT "paket sha256="; hash

        CALL(API, "server", "route_file", "/rapor.zip", zip)
        CALL(API, "server", "route_text", "/hash", hash)
        CALL(API, "server", "listen", 8080)
    CATCH hata
        PRINT "paket/sunucu hatasi: "; hata
    END TRY
END MAIN
```

Buradaki ders: çıktı üretmek yetmez, çıktının bütünlüğünü de kanıtlamak gerekir. Hash, dosyanın değişip değişmediğini gösteren kısa parmak izidir.

# 4.16 Kütüphane test alışkanlığı

Kütüphane yazmak, fonksiyon yazıp bırakmak değildir. Her kütüphanenin duman testi, hata testi, sınır testi ve sözleşme testi olmalıdır. uXBasic’te test komutları ve raporlar bu yüzden önemlidir.

| Test türü | Ne dener? | Örnek |
|---|---|---|
| Duman testi | Kütüphane açılıyor mu? | `run_uxstats_smoke.bat` |
| Bilinen sonuç testi | 2+2 gerçekten 4 mü? | Ortalama, toplam, sigmoid örneği. |
| Hata testi | Bozuk dosya, boş veri, sıfır handle. | `ASSERT h <> 0` |
| Sınır testi | 0, 1, çok büyük, negatif. | `n=0`, `n=1`, `n=1000000`. |
| Çıktı testi | Rapor dosyası gerçek mi? | JSON parse, dosya boş değil. |
| Sızıntı testi | Açılan kaynak kapandı mı? | Her handle için `free`. |

### Komut satırından kütüphane duman testleri

```powershell
compiler\scripts\run_uxcollections_smoke.bat
compiler\scripts\run_uxmath_smoke.bat
compiler\scripts\run_uxmathcore_smoke.bat
compiler\scripts\run_uxstats_smoke.bat
compiler\scripts\run_uxstats2_smoke.bat
compiler\scripts\run_uxmatrix_smoke.bat
compiler\scripts\run_uxtensor_smoke.bat
compiler\scripts\run_uxdataframe_smoke.bat
compiler\scripts\run_uxdataset_smoke.bat
compiler\scripts\run_uxgraph_smoke.bat
compiler\scripts\run_uxaimath_smoke.bat
compiler\scripts\run_uxnn_smoke.bat
compiler\scripts\run_uxnn2_smoke.bat
compiler\scripts\run_uxnn3_smoke.bat
compiler\scripts\run_uxonnx_smoke.bat
compiler\scripts\run_uxonnx2_smoke.bat
compiler\scripts\run_uxllama_smoke.bat
compiler\scripts\run_full_fp_runtime_smoke.bat
```

### Kallavi örnek — kendi küçük kütüphane test koşucunu yazmak

```uxbasic
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxaimath.uxmh"
INCLUDE "modules/uxcollections.uxmh"

SUB TestEt(ad AS STRING, kosul AS BOOLEAN, BYREF hata AS I32)
    IF kosul THEN
        PRINT "PASS "; ad
    ELSE
        PRINT "FAIL "; ad
        hata = hata + 1
    END IF
END SUB

MAIN
    DIM hata AS I32
    DIM s AS F64
    DIM l AS PTR

    s = uxaimath.SIGMOID(0.0)
    CALL TestEt("sigmoid0", ABS(s - 0.5) < 0.0001, hata)

    l = uxc.LIST_NEW()
    CALL uxc.LIST_PUSH_F64(l, 3.0)
    CALL uxc.LIST_PUSH_F64(l, 5.0)
    CALL TestEt("liste_count", uxc.LIST_COUNT(l) = 2, hata)
    CALL TestEt("liste_get", uxc.LIST_GET_F64(l, 1) = 5.0, hata)
    CALL uxc.LIST_FREE(l)

    IF hata = 0 THEN
        PRINT "tum kutuphane temel testleri gecti"
    ELSE
        PRINT "hata adedi="; hata
        THROW "kutuphane smoke fail"
    END IF
END MAIN
```

Bu test koşucu küçük ama değerlidir. Her kütüphaneye bir bilinen sonuç koyarsan, ileride yapılan değişiklik temel davranışı bozarsa hemen görürsün.

# 4.17 Cilt 4 için genç programcıya son öğütler

Kütüphane kullanmak hazır gücü kullanmaktır; ama hazır güç dikkatsiz elde tehlikelidir. `CALL(DLL,...)` yazmadan önce imzayı düşün. Handle açmadan önce ne zaman kapatacağını düşün. API çağırmadan önce hata cevabını düşün. Yapay zeka modelinden cevap almadan önce o cevabın doğrulanması gerektiğini düşün. İyi programcı, sonucu alan kişi değildir; sonucun nereden geldiğini, hangi tipten geçtiğini, hangi dosyaya yazıldığını ve hangi testle doğrulandığını bilen kişidir.

uXBasic’in güzel yanı, BASIC rahatlığını korurken seni derleyici geliştiricisi gibi düşünmeye zorlamasıdır. Kütüphane başlığı, çalışma zamanı servisi, dış DLL, JS/WASM host köprüsü, JSON raporu ve test kapısı aynı büyük sistemin parçalarıdır. Bu ciltte öğrendiğin düzeni 5. ciltte tarayıcı, API, yapay zeka ve bilimsel analiz programlarına büyüteceğiz.
