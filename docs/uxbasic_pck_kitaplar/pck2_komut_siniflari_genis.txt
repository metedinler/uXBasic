# uXBasic Programlayıcının Cep Kitabı — Cilt 2

# Komutlar, Ön-İşleyici, Tipler, İşleçler ve Yerel Fonksiyonlar

Bu ciltte tek kitaptaki güçlü anahtar sözcük tablosu korunur; fakat tablo altındaki anlatım artık yalnız kısa tanım değildir. Her sınıfta önce o sınıfın düşünme biçimi verilir, sonra sınıfa ait komutlar tek tek anlatılır, her komut için küçük bir kullanım gösterilir ve sınıf sonunda bir veya birkaç büyük örnekle komutların birlikte nasıl çalıştığı öğretilir. Amaç ezber değil, program kurma aklı kazandırmaktır.

Genç programcı için kural: Bir komutu tek başına öğren, sonra onu başka komutlarla birlikte kullan. Gerçek programda `IF`, `FOR`, `DIM`, `PRINT`, `FUNCTION`, `TRY`, `DICT`, `OPEN`, `CALL` ve kütüphane çağrıları aynı işin parçalarıdır. Bu yüzden örnekler tek satırlık oyuncaklar değil, küçük ama anlamlı problemlerdir.

## Tüm anahtar sözcükler

|No|Sözcük|Sınıf|Sözdizimi|Görev|
|---:|---|---|---|---|
|1|IF|Akış|IF koşul THEN komutlar ELSE komutlar END IF|Koşula bakar; doğru yolda ayrı, yanlış yolda ayrı komutlar çalıştırır.|
|2|THEN|Akış|IF koşul THEN komutlar|IF koşulu doğru olduğunda başlayacak komut bölümünü gösterir.|
|3|ELSE|Akış|IF koşul THEN ... ELSE ... END IF|IF koşulu yanlışsa çalışacak yedek yolu gösterir.|
|4|ELSEIF|Akış|IF a THEN ... ELSEIF b THEN ... ELSE ... END IF|Birden çok koşulu sırayla dener; ilk doğru koşulun bölümünü çalıştırır.|
|5|END|Akış|END IF \| END SELECT \| END SUB \| END FUNCTION \| END CLASS \| END MODULE|Açılmış bloğu kapatır ve sınırını belli eder.|
|6|SELECT|Akış|SELECT CASE ifade ... CASE değer ... END SELECT|Tek bir değeri birçok olası değere göre dallandırır.|
|7|CASE|Akış|CASE değer \| CASE IS > değer \| CASE ELSE|SELECT içindeki tek seçeneği belirtir.|
|8|IS|Akış|CASE IS > değer \| CASE IS <= değer|CASE içinde karşılaştırmalı seçenek kurar.|
|9|TRY|Akış|TRY ... CATCH hata ... FINALLY ... END TRY|Hata çıkabilecek işi korumalı bölümde dener.|
|10|CATCH|Akış|CATCH hataAdi|TRY içindeki hata yakalanırsa çalışacak bölümü başlatır.|
|11|FINALLY|Akış|FINALLY ...|Hata olsa da olmasa da en son çalışacak temizlik bölümünü açar.|
|12|THROW|Akış|THROW "hata metni"|Senin belirlediğin hatayı bilinçli olarak fırlatır.|
|13|ASSERT|Akış|ASSERT koşul|Test amacıyla bir koşulun doğru olmasını zorunlu tutar.|
|14|EVENT|Olay ve eşzamanlılık|EVENT OlayAdi|Daha sonra tetiklenecek olay adını bildirir.|
|15|THREAD|Olay ve eşzamanlılık|THREAD IsAdi ... END THREAD|Ayrı iş parçası olarak çalışacak işi tanımlar.|
|16|THREAD|Olay ve eşzamanlılık|THREAD IsAdi ... END THREAD|Ayrı iş parçası olarak çalışacak işi tanımlar. Eski metinlerde THREAT görülürse yazım hatası kabul edilir; yeni kodda THREAD kullanılır.|
|17|PARALEL|Olay ve eşzamanlılık|PARALEL GrupAdi ... END PARALEL|Birden fazla işi paralel görev ailesi olarak düzenler.|
|18|PIPE|Olay ve eşzamanlılık|PIPE Ad AS Tip|İki iş arasında veri taşıyan boru tanımlar.|
|19|SLOT|Olay ve eşzamanlılık|SLOT Ad ON Olay ... END SLOT|Bir olaya bağlı çalışacak kod yuvasını tanımlar.|
|20|ON|Olay ve eşzamanlılık|SLOT Ad ON Olay \| ON ERROR ...|Bir eylemi olaya veya duruma bağlar.|
|21|OFF|Olay ve eşzamanlılık|OFF Olay \| OFF SLOT Ad|Olay dinlemeyi veya bağlı tepkiyi kapatır.|
|22|TRIGGER|Olay ve eşzamanlılık|TRIGGER OlayAdi[, veri]|Bir olayı elle tetikler.|
|23|BYTE|Tipler|DIM ad AS BYTE|tek baytlık ham veri tutar.|
|24|FOR|Akış|FOR sayac = ilk TO son STEP adim ... NEXT sayac|Sayaçlı döngü kurar.|
|25|TO|Akış|FOR i = başlangıç TO bitiş|Döngünün son değerini gösterir.|
|26|STEP|Akış|FOR i = ilk TO son STEP adim|Sayaç artışını veya azalışını belirler.|
|27|NEXT|Akış|NEXT sayac|FOR döngüsünün sonunu ve sonraki adıma geçişini gösterir.|
|28|DO|Akış|DO WHILE koşul ... LOOP \| DO ... LOOP UNTIL koşul|Koşullu döngü başlatır.|
|29|LOOP|Akış|LOOP \| LOOP UNTIL koşul|DO döngüsünü kapatır; gerekirse çıkış koşulunu taşır.|
|30|WHILE|Akış|DO WHILE koşul \| WHILE koşul ... WEND|Koşul doğru kaldığı sürece çalışmayı sürdürür.|
|31|UNTIL|Akış|LOOP UNTIL koşul|Koşul doğru olunca döngüyü bitirir.|
|32|EXIT|Akış|EXIT FOR \| EXIT DO \| EXIT FUNCTION \| EXIT SUB|İçinde bulunulan döngüden veya yordamdan erken çıkar.|
|33|EACH|Akış|FOR EACH eleman IN liste ... NEXT|Bir koleksiyonun elemanlarını tek tek dolaşır.|
|34|IN|Akış|FOR EACH x IN koleksiyon \| x IN liste|Bir elemanın hangi koleksiyondan geleceğini belirtir veya üyelik sınaması yapar.|
|35|SUB|Yordam ve çağrı|SUB Ad(param AS Tip) ... END SUB|Değer döndürmeyen tekrar kullanılabilir iş bloğu tanımlar.|
|36|FUNCTION|Yordam ve çağrı|FUNCTION Ad(param AS Tip) AS Tip ... RETURN değer ... END FUNCTION|Değer döndüren hesap veya dönüştürme bloğu tanımlar.|
|37|DECLARE|Yordam ve çağrı|DECLARE FUNCTION Ad LIB "dll" ALIAS "gercek_ad" (...) AS Tip|Dış kütüphane fonksiyonunun uXBasic tarafındaki imzasını bildirir.|
|38|RETURN|Akış|RETURN değer|Fonksiyondan sonuç döndürür veya alt yordamdan geri döner.|
|39|GOTO|Akış|GOTO etiket|Belirtilen etikete doğrudan atlar.|
|40|GOSUB|Akış|GOSUB etiket ... RETURN|Etikete gider ve RETURN ile geri döner.|
|41|CALL|Yordam ve çağrı|CALL Ad(argler) \| CALL(DLL,"dll","fonksiyon",argler) \| CALL(API,"ad",argler)|Tanımlı yordamı, dış DLL fonksiyonunu veya API çağrısını çalıştırır.|
|42|TYPE|Nesne ve tip bildirimi|TYPE Ad ... END TYPE|Kayıt biçiminde veri alanları toplar.|
|43|CLASS|Nesne ve tip bildirimi|CLASS Ad ... END CLASS|Veri ve davranışı aynı nesne kalıbında toplar.|
|44|INTERFACE|Nesne ve tip bildirimi|INTERFACE Ad ... END INTERFACE|Bir sınıfın yerine getireceği yöntem sözleşmesini tanımlar.|
|45|IMPLEMENTS|Nesne ve tip bildirimi|CLASS Ad IMPLEMENTS Arayuz|Sınıfın arayüz sözleşmesini üstlendiğini belirtir.|
|46|METHOD|Nesne ve tip bildirimi|METHOD Ad(...) AS Tip|Sınıf içindeki işlevi tanımlar.|
|47|MAGIC|Nesne ve tip bildirimi|MAGIC <.Ad.>(...)|Sihirli yöntem tanımlar. Eski metinlerde SIHIRLIMETOT görülürse uyumluluk/yazım hatası kabul edilir; yeni kodda MAGIC kullanılır.|
|48|MAGIC|Nesne ve tip bildirimi|MAGIC Ad(...)|Sihirli yöntem için kısa/alternatif yazım sağlar.|
|49|VIRTUAL|Nesne ve tip bildirimi|VIRTUAL METHOD Ad(...)|Alt sınıfın değiştirebileceği yöntem bildirir.|
|50|OVERRIDE|Nesne ve tip bildirimi|OVERRIDE METHOD Ad(...)|Üst sınıftaki yöntemi bilinçli olarak değiştirir.|
|51|CONSTRUCTOR|Nesne ve tip bildirimi|CONSTRUCTOR(...)|Nesne oluşurken çalışan kurucu bölümdür.|
|52|DESTRUCTOR|Nesne ve tip bildirimi|DESTRUCTOR()|Nesne yok olurken temizlik yapar.|
|53|NEW|Nesne ve tip bildirimi|NEW Sinif(argler)|Yeni nesne oluşturur.|
|54|DELETE|Nesne ve tip bildirimi|DELETE nesne|Nesne/ayrılmış kaynağı bırakır.|
|55|DIM|Değişken ve bellek|DIM ad AS Tip|Yeni değişken, dizi veya nesne başvurusu bildirir.|
|56|REDIM|Değişken ve bellek|REDIM dizi(yeniBoyut)|Diziyi yeni boyuta taşır.|
|57|AS|Değişken ve bellek|ad AS Tip|Bir adın tipini belirtir.|
|58|CONST|Değişken ve bellek|CONST ad AS Tip = değer|Değişmeyen sabit tanımlar.|
|59|INCLUDE|Modül ve kaynak|INCLUDE "dosya.uxbh"|Başka uXBasic başlık/destek dosyasını kaynak içine katar.|
|60|IMPORT|Modül ve kaynak|IMPORT(C,"dosya.c") \| IMPORT(CPP,"dosya.cpp") \| IMPORT(ASM,"dosya.asm")|Derleme zamanında C, C++ veya ASM kaynak dosyasını projeye bağlar.|
|61|ABSTRACT|Nesne ve tip bildirimi|ABSTRACT CLASS Ad|Doğrudan üretilmeyen temel sınıf tanımlar.|
|62|FINAL|Nesne ve tip bildirimi|FINAL CLASS Ad \| FINAL METHOD Ad|Daha fazla miras/değiştirme yapılmasını engeller.|
|63|SEALED|Nesne ve tip bildirimi|SEALED CLASS Ad|Kapatılmış sınıf bildirir.|
|64|STATIC|Nesne ve tip bildirimi|STATIC alan AS Tip \| STATIC METHOD Ad|Sınıfa ait tek ortak alan/yöntem tanımlar.|
|65|PROPERTY|Nesne ve tip bildirimi|PROPERTY Ad AS Tip|Nesne alanını kontrollü özellik olarak tanımlar.|
|66|OPERATOR|Nesne ve tip bildirimi|OPERATOR +(a,b)|Sınıf için işlemci davranışı tanımlar.|
|67|MIXIN|Nesne ve tip bildirimi|MIXIN Ad|Bir sınıfa ek davranış karışımı ekler.|
|68|DECORATOR|Nesne ve tip bildirimi|DECORATOR Ad|Yordam/sınıf etrafına ek davranış sarar.|
|69|PUBLIC|Nesne ve tip bildirimi|PUBLIC ad|Dışarıdan erişilebilir üye bildirir.|
|70|PRIVATE|Nesne ve tip bildirimi|PRIVATE ad|Sadece kendi sınıf/modülü içinden erişilir.|
|71|PROTECTED|Nesne ve tip bildirimi|PROTECTED ad|Kendi sınıfı ve alt sınıflar erişir.|
|72|RESTRICTED|Nesne ve tip bildirimi|RESTRICTED ad|Daraltılmış erişim kuralı belirtir.|
|73|FRIEND|Nesne ve tip bildirimi|FRIEND MODULE Ad|Belirli modül/sınıfa özel erişim verir.|
|74|READONLY|Nesne ve tip bildirimi|READONLY ad AS Tip|Dışarıdan değiştirilemeyen okuma alanı bildirir.|
|75|MUTABLE|Nesne ve tip bildirimi|MUTABLE ad AS Tip|Normalde sabit bağlamda bile değişebilir alan belirtir.|
|76|IMMUTABLE|Nesne ve tip bildirimi|IMMUTABLE ad AS Tip|Değişmez veri/nesne niyeti belirtir.|
|77|MAIN|Modül ve kaynak|MAIN ... END MAIN|Programın ana giriş bölümünü belirtir.|
|78|NAMESPACE|Modül ve kaynak|NAMESPACE Ad ... END NAMESPACE|Adları çakışmadan ayıran alan açar.|
|79|MODULE|Modül ve kaynak|MODULE Ad ... END MODULE|Bir dosya veya iş ailesini modül olarak toplar.|
|80|USING|Modül ve kaynak|USING MODULE Ad \| USING NAMESPACE Ad|Bir modül/alan adını kısa kullanım için etkinleştirir.|
|81|ALIAS|Modül ve kaynak|ALIAS yeniAd = eskiAd \| ALIAS KISA AS uzunAd|Uzun çağrıya kısa veya yerel ad verir.|
|82|DEFINT|Varsayılan tip|DEFINT A-Z|harfle başlayan adsız tipleri I32 yapar|
|83|DEFLNG|Varsayılan tip|DEFLNG A-Z|harfle başlayan adsız tipleri I64 yapar|
|84|DEFSNG|Varsayılan tip|DEFSNG A-Z|harfle başlayan adsız tipleri F32 yapar|
|85|DEFDBL|Varsayılan tip|DEFDBL A-Z|harfle başlayan adsız tipleri F64 yapar|
|86|DEFEXT|Varsayılan tip|DEFEXT A-Z|harfle başlayan adsız tipleri geniş ondalık yapar|
|87|DEFSTR|Varsayılan tip|DEFSTR A-Z|harfle başlayan adsız tipleri STRING yapar|
|88|DEFBYT|Varsayılan tip|DEFBYT A-Z|harfle başlayan adsız tipleri BYTE yapar|
|89|PRINT|Girdi çıktı ve ekran|PRINT ifade[, ifade] \| PRINT #dosya, ifade|Ekrana veya dosyaya metin/sayı yazar.|
|90|INPUT|Girdi çıktı ve ekran|INPUT değişken \| INPUT #dosya, değişken|Kullanıcıdan veya dosyadan veri okur.|
|91|OPEN|Girdi çıktı ve ekran|OPEN "dosya" FOR INPUT\|OUTPUT\|APPEND AS #no|Dosyayı okuma/yazma/ekleme için açar.|
|92|CLOSE|Girdi çıktı ve ekran|CLOSE #no|Açık dosyayı kapatır.|
|93|GET|Girdi çıktı ve ekran|GET #no, konum, değişken|Dosyadan ham veri okur.|
|94|PUT|Girdi çıktı ve ekran|PUT #no, konum, değişken|Dosyaya ham veri yazar.|
|95|SEEK|Girdi çıktı ve ekran|SEEK #no, konum|Dosya okuma/yazma konumunu değiştirir.|
|96|CLS|Girdi çıktı ve ekran|CLS|Ekranı temizler.|
|97|COLOR|Girdi çıktı ve ekran|COLOR ön[, arka]|Yazı/arka plan rengini ayarlar.|
|98|LOCATE|Girdi çıktı ve ekran|LOCATE satır, sütun|Ekran imlecini konuma taşır.|
|99|AND|İşleç|a AND b|iki koşul/bit birlikte doğruysa doğru verir|
|100|OR|İşleç|a OR b|koşullardan biri doğruysa doğru verir|
|101|NOT|İşleç|NOT koşul|koşulu tersine çevirir|
|102|XOR|İşleç|a XOR b|yalnız biri doğruysa doğru verir veya bitlerde özel fark alır|
|103|MOD|İşleç|a MOD b|bölme kalanı verir|
|104|SHL|İşleç|a SHL b|bitleri sola kaydırır|
|105|SHR|İşleç|a SHR b|bitleri sağa kaydırır|
|106|ROL|İşleç|a ROL b|bitleri döndürerek sola kaydırır|
|107|ROR|İşleç|a ROR b|bitleri döndürerek sağa kaydırır|
|108|INLINE|Modül ve kaynak|INLINE C ... END INLINE \| INLINE ASM ... END INLINE|uXBasic dosyası içinde küçük C/C++/ASM bölümü taşır.|
|109|I8|Tipler|DIM ad AS I8|-128 ile 127 arasında işaretli 8 bit tam sayı tutar.|
|110|U8|Tipler|DIM ad AS U8|0 ile 255 arasında işaretsiz 8 bit tam sayı tutar.|
|111|I16|Tipler|DIM ad AS I16|işaretli 16 bit tam sayı tutar.|
|112|U16|Tipler|DIM ad AS U16|işaretsiz 16 bit tam sayı tutar.|
|113|I32|Tipler|DIM ad AS I32|günlük sayaç ve indeksler için 32 bit tam sayı tutar.|
|114|U32|Tipler|DIM ad AS U32|negatif olmayan 32 bit sayı tutar.|
|115|I64|Tipler|DIM ad AS I64|büyük sayaç ve dosya boyutu için 64 bit tam sayı tutar.|
|116|U64|Tipler|DIM ad AS U64|çok büyük pozitif sayaçlar için 64 bit sayı tutar.|
|117|F32|Tipler|DIM ad AS F32|tek duyarlıklı ondalıklı sayı tutar.|
|118|F64|Tipler|DIM ad AS F64|çift duyarlıklı ondalıklı sayı tutar.|
|119|F80|Tipler|DIM ad AS F80|genişletilmiş kayan nokta sayı tutar.|
|120|F128|Tipler|DIM ad AS F128|128 bit yüksek duyarlıklı sayı tutar.|
|121|BIGF|Tipler|DIM ad AS BIGF|çok büyük/yüksek duyarlıklı ikili kayan sayı ailesidir.|
|122|BIGD|Tipler|DIM ad AS BIGD|çok basamaklı ondalık sayı ailesidir.|
|123|BALL|Tipler|DIM ad AS BALL|aralık/top mantığıyla güvenli yaklaşık sayı tutar.|
|124|BOOLEAN|Tipler|DIM ad AS BOOLEAN|TRUE/FALSE doğru-yanlış değeri tutar.|
|125|STRING|Tipler|DIM ad AS STRING|metin tutar.|
|126|OBJECT|Tipler|DIM ad AS OBJECT|nesne başvurusu tutar.|
|127|PTR|Tipler|DIM ad AS PTR|ham adres veya dış kütüphane işaretçisi tutar.|
|128|STRPTR|Tipler|DIM ad AS STRPTR|metnin bellek adresini dış çağrıya verir.|
|129|BYREF|Yordam ve çağrı|param AS BYREF Tip \| BYREF param AS Tip|Parametrenin kendisini gönderir; fonksiyon değeri değiştirebilir.|
|130|BYVAL|Yordam ve çağrı|BYVAL param AS Tip|Parametrenin kopyasını gönderir; çağıranın değişkeni etkilenmez.|
|131|CDECL|Yordam ve çağrı|DECLARE CDECL FUNCTION ...|C çağrı düzenini belirtir.|
|132|STDCALL|Yordam ve çağrı|DECLARE STDCALL FUNCTION ...|Windows çağrı düzenini belirtir.|
|133|ARRAY|Tipler|DIM ad AS ARRAY|sabit veya yeniden boyutlanabilir dizi tutar.|
|134|LIST|Tipler|DIM ad AS LIST|sıralı, büyüyebilen liste tutar.|
|135|DICT|Tipler|DIM ad AS DICT|anahtar/değer sözlüğü tutar.|
|136|SET|Tipler|DIM ad AS SET|tekrarsız küme tutar.|
|137|SETSTRINGSIZE|Yerel fonksiyon|sonuc = SETSTRINGSIZE metin, uzunluk|Metin değişkeni için istenen uzunlukta alan hazırlar.|
|138|TIMER|Yerel fonksiyon|sonuc = TIMER()|Geçen zamanı saniye türünden verir.|
|139|LOF|Yerel fonksiyon|sonuc = LOF(#no)|Açık dosyanın uzunluğunu verir.|
|140|EOF|Yerel fonksiyon|sonuc = EOF(#no)|Dosya sonuna gelinip gelinmediğini söyler.|
|141|LEN|Yerel fonksiyon|sonuc = LEN(metin)|Metnin veya verinin uzunluğunu verir.|
|142|MID|Yerel fonksiyon|sonuc = MID(metin, başla, uzunluk)|Metnin içinden parça alır.|
|143|STR|Yerel fonksiyon|sonuc = STR(sayi)|Sayıyı metne çevirir.|
|144|VAL|Yerel fonksiyon|sonuc = VAL(metin)|Metni sayıya çevirir.|
|145|ABS|Yerel fonksiyon|sonuc = ABS(x)|Mutlak değer alır.|
|146|INT|Yerel fonksiyon|sonuc = INT(x)|Ondalıklı sayının tam kısmını alır.|
|147|UCASE|Yerel fonksiyon|sonuc = UCASE(metin)|Metni büyük harfe çevirir.|
|148|LCASE|Yerel fonksiyon|sonuc = LCASE(metin)|Metni küçük harfe çevirir.|
|149|ASC|Yerel fonksiyon|sonuc = ASC(karakter)|Karakterin sayı kodunu verir.|
|150|CHR|Yerel fonksiyon|sonuc = CHR(kod)|Sayı kodundan karakter üretir.|
|151|LTRIM|Yerel fonksiyon|sonuc = LTRIM(metin)|Sol boşlukları temizler.|
|152|RTRIM|Yerel fonksiyon|sonuc = RTRIM(metin)|Sağ boşlukları temizler.|
|153|SPACE|Yerel fonksiyon|sonuc = SPACE(n)|Belirli sayıda boşluk üretir.|
|154|SGN|Yerel fonksiyon|sonuc = SGN(x)|Sayının işaretini verir.|
|155|SQRT|Yerel fonksiyon|sonuc = SQRT(x)|Karekök hesaplar.|
|156|SIN|Yerel fonksiyon|sonuc = SIN(x)|Sinüs hesaplar.|
|157|COS|Yerel fonksiyon|sonuc = COS(x)|Kosinüs hesaplar.|
|158|TAN|Yerel fonksiyon|sonuc = TAN(x)|Tanjant hesaplar.|
|159|ATN|Yerel fonksiyon|sonuc = ATN(x)|Arktanjant hesaplar.|
|160|EXP|Yerel fonksiyon|sonuc = EXP(x)|e üzeri x hesaplar.|
|161|LOG|Yerel fonksiyon|sonuc = LOG(x)|Doğal logaritma hesaplar.|
|162|INKEY|Yerel fonksiyon|sonuc = INKEY()|Basılmış tuşu beklemeden okur.|
|163|GETKEY|Yerel fonksiyon|sonuc = GETKEY()|Tuş bekler ve okur.|
|164|VARPTR|Yerel fonksiyon|sonuc = VARPTR(degisken)|Değişkenin bellek adresini verir.|
|165|SADD|Yerel fonksiyon|sonuc = SADD(metin)|Metin içeriğinin adresini verir.|
|166|LPTR|Yerel fonksiyon|sonuc = LPTR(degisken)|Uzun adres/işaretçi değeri verir.|
|167|CODEPTR|Yerel fonksiyon|sonuc = CODEPTR(yordam)|Yordamın kod adresini verir.|
|168|SIZEOF|Yerel fonksiyon|sonuc = SIZEOF(Tip\|degisken)|Tip veya değişken boyutunu bayt olarak verir.|
|169|OFFSETOF|Yerel fonksiyon|sonuc = OFFSETOF(Tip, alan)|Kayıt içindeki alanın başlangıç uzaklığını verir.|
|170|CINT|Yerel fonksiyon|sonuc = CINT(x)|Değeri tam sayıya çevirir.|
|171|CLNG|Yerel fonksiyon|sonuc = CLNG(x)|Değeri uzun tam sayıya çevirir.|
|172|CDBL|Yerel fonksiyon|sonuc = CDBL(x)|Değeri çift duyarlıklı sayıya çevirir.|
|173|CSNG|Yerel fonksiyon|sonuc = CSNG(x)|Değeri tek duyarlıklı sayıya çevirir.|
|174|FIX|Yerel fonksiyon|sonuc = FIX(x)|Ondalık kısmı keser.|
|175|SQR|Yerel fonksiyon|sonuc = SQR(x)|Karekök için BASIC uyumlu addır.|
|176|RND|Yerel fonksiyon|sonuc = RND()|Rastgele sayı üretir.|
|177|RANDOMIZE|Yerel fonksiyon|sonuc = RANDOMIZE [tohum]|Rastgele sayı üreticisini tohumlar.|
|178|PEEKB|Bellek ve düşük seviye|PEEKB adres[, değer[, uzunluk]]|Adresten bayt okur.|
|179|PEEKW|Bellek ve düşük seviye|PEEKW adres[, değer[, uzunluk]]|Adresten 16 bit sözcük okur.|
|180|PEEKD|Bellek ve düşük seviye|PEEKD adres[, değer[, uzunluk]]|Adresten 32 bit değer okur.|
|181|POKE|Bellek ve düşük seviye|POKE adres[, değer[, uzunluk]]|Adrese genel değer yazar.|
|182|POKEB|Bellek ve düşük seviye|POKEB adres[, değer[, uzunluk]]|Adrese bayt yazar.|
|183|POKEW|Bellek ve düşük seviye|POKEW adres[, değer[, uzunluk]]|Adrese 16 bit değer yazar.|
|184|POKED|Bellek ve düşük seviye|POKED adres[, değer[, uzunluk]]|Adrese 32 bit değer yazar.|
|185|POKES|Bellek ve düşük seviye|POKES adres[, değer[, uzunluk]]|Adrese metin/blok yazar.|
|186|MEMCOPYB|Bellek ve düşük seviye|MEMCOPYB adres[, değer[, uzunluk]]|Bayt blok kopyalar.|
|187|MEMCOPYW|Bellek ve düşük seviye|MEMCOPYW adres[, değer[, uzunluk]]|16 bit sözcük blok kopyalar.|
|188|MEMCOPYD|Bellek ve düşük seviye|MEMCOPYD adres[, değer[, uzunluk]]|32 bit blok kopyalar.|
|189|MEMFILLB|Bellek ve düşük seviye|MEMFILLB adres[, değer[, uzunluk]]|Belleği bayt değeriyle doldurur.|
|190|MEMFILLW|Bellek ve düşük seviye|MEMFILLW adres[, değer[, uzunluk]]|Belleği 16 bit değerle doldurur.|
|191|MEMFILLD|Bellek ve düşük seviye|MEMFILLD adres[, değer[, uzunluk]]|Belleği 32 bit değerle doldurur.|
|192|SETNEWOFFSET|Bellek ve düşük seviye|SETNEWOFFSET adres[, değer[, uzunluk]]|Yeni ayırma ofsetini belirler.|
|193|INC|Bellek ve düşük seviye|INC adres[, değer[, uzunluk]]|Sayıyı veya adresteki değeri artırır.|
|194|DEC|Bellek ve düşük seviye|DEC adres[, değer[, uzunluk]]|Sayıyı veya adresteki değeri azaltır.|
|195|ENUM|Listeleme|ENUM Ad ... END ENUM|Adlandırılmış sabitler grubu oluşturur.|

## Sınıflara göre derin anlatım

### Akış

Akış komutları programın yolunu çizer. Bir program yalnız satır satır ilerlemez; bazen karar verir, bazen tekrar eder, bazen erken çıkar, bazen hatayı yakalayıp temizlenir. Bu sınıfta önce koşul, sonra seçenek, sonra döngü, sonra hata güvenliği düşünülür. İyi akış yazmak, genç programcıya büyük programı küçük bölümlere ayırmayı öğretir. Bir ölçüm dosyasını okurken, kullanıcı menüsü kurarken, kalite kontrol yaparken ve derleyici kapısını çalıştırırken aynı temel akış mantığı kullanılır. Kural şudur: her döngünün bir çıkış yolu, her kararın anlaşılır nedeni, her riskli işin hata planı olmalıdır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|IF|IF koşul THEN komutlar ELSE komutlar END IF|Koşula bakar; doğru yolda ayrı, yanlış yolda ayrı komutlar çalıştırır.|
|THEN|IF koşul THEN komutlar|IF koşulu doğru olduğunda başlayacak komut bölümünü gösterir.|
|ELSE|IF koşul THEN ... ELSE ... END IF|IF koşulu yanlışsa çalışacak yedek yolu gösterir.|
|ELSEIF|IF a THEN ... ELSEIF b THEN ... ELSE ... END IF|Birden çok koşulu sırayla dener; ilk doğru koşulun bölümünü çalıştırır.|
|END|END IF \| END SELECT \| END SUB \| END FUNCTION \| END CLASS \| END MODULE|Açılmış bloğu kapatır ve sınırını belli eder.|
|SELECT|SELECT CASE ifade ... CASE değer ... END SELECT|Tek bir değeri birçok olası değere göre dallandırır.|
|CASE|CASE değer \| CASE IS > değer \| CASE ELSE|SELECT içindeki tek seçeneği belirtir.|
|IS|CASE IS > değer \| CASE IS <= değer|CASE içinde karşılaştırmalı seçenek kurar.|
|TRY|TRY ... CATCH hata ... FINALLY ... END TRY|Hata çıkabilecek işi korumalı bölümde dener.|
|CATCH|CATCH hataAdi|TRY içindeki hata yakalanırsa çalışacak bölümü başlatır.|
|FINALLY|FINALLY ...|Hata olsa da olmasa da en son çalışacak temizlik bölümünü açar.|
|THROW|THROW "hata metni"|Senin belirlediğin hatayı bilinçli olarak fırlatır.|
|ASSERT|ASSERT koşul|Test amacıyla bir koşulun doğru olmasını zorunlu tutar.|
|FOR|FOR sayac = ilk TO son STEP adim ... NEXT sayac|Sayaçlı döngü kurar.|
|TO|FOR i = başlangıç TO bitiş|Döngünün son değerini gösterir.|
|STEP|FOR i = ilk TO son STEP adim|Sayaç artışını veya azalışını belirler.|
|NEXT|NEXT sayac|FOR döngüsünün sonunu ve sonraki adıma geçişini gösterir.|
|DO|DO WHILE koşul ... LOOP \| DO ... LOOP UNTIL koşul|Koşullu döngü başlatır.|
|LOOP|LOOP \| LOOP UNTIL koşul|DO döngüsünü kapatır; gerekirse çıkış koşulunu taşır.|
|WHILE|DO WHILE koşul \| WHILE koşul ... WEND|Koşul doğru kaldığı sürece çalışmayı sürdürür.|
|UNTIL|LOOP UNTIL koşul|Koşul doğru olunca döngüyü bitirir.|
|EXIT|EXIT FOR \| EXIT DO \| EXIT FUNCTION \| EXIT SUB|İçinde bulunulan döngüden veya yordamdan erken çıkar.|
|EACH|FOR EACH eleman IN liste ... NEXT|Bir koleksiyonun elemanlarını tek tek dolaşır.|
|IN|FOR EACH x IN koleksiyon \| x IN liste|Bir elemanın hangi koleksiyondan geleceğini belirtir veya üyelik sınaması yapar.|
|RETURN|RETURN değer|Fonksiyondan sonuç döndürür veya alt yordamdan geri döner.|
|GOTO|GOTO etiket|Belirtilen etikete doğrudan atlar.|
|GOSUB|GOSUB etiket ... RETURN|Etikete gider ve RETURN ile geri döner.|

#### Tekil komut defteri

##### 1. IF
**Sözdizimi:** `IF koşul THEN komutlar ELSE komutlar END IF`  
**Ne yapar:** Koşula bakar; doğru yolda ayrı, yanlış yolda ayrı komutlar çalıştırır.  
**Nerede ve nasıl kullanılır:** Koşul doğruysa tek satır veya blok çalıştır; yanlış olasılığı da varsa `ELSE` yaz. Ölçüm sınırı, yetki, dosya durumu ve hedef seçimi için ilk araçtır.

```uxbasic
IF ph < 6.5 THEN PRINT "asit risk" ELSE PRINT "ph uygun" END IF
```

##### 2. THEN
**Sözdizimi:** `IF koşul THEN komutlar`  
**Ne yapar:** IF koşulu doğru olduğunda başlayacak komut bölümünü gösterir.  
**Nerede ve nasıl kullanılır:** `IF` cümlesinin karar çizgisidir; koşuldan sonra hangi komutun başlayacağını gösterir. Tek başına kullanılmaz, karar cümlesinin parçasıdır.

```uxbasic
IF sicaklik > 30 THEN PRINT "fan ac"
```

##### 3. ELSE
**Sözdizimi:** `IF koşul THEN ... ELSE ... END IF`  
**Ne yapar:** IF koşulu yanlışsa çalışacak yedek yolu gösterir.  
**Nerede ve nasıl kullanılır:** Yanlış durumu sessiz bırakmamak için kullanılır. Genç programcı özellikle kullanıcı girdisinde ve dosya işlerinde `ELSE` dalını ihmal etmemelidir.

```uxbasic
IF stok > 0 THEN PRINT "satis yap" ELSE PRINT "siparis ver" END IF
```

##### 4. ELSEIF
**Sözdizimi:** `IF a THEN ... ELSEIF b THEN ... ELSE ... END IF`  
**Ne yapar:** Birden çok koşulu sırayla dener; ilk doğru koşulun bölümünü çalıştırır.  
**Nerede ve nasıl kullanılır:** Çok seçenekli karar ağacı kurar. Bir sınırdan diğerine giderken aralıkların çakışmamasına dikkat et.

```uxbasic
IF notu >= 85 THEN PRINT "AA" ELSEIF notu >= 70 THEN PRINT "BB" ELSE PRINT "CC" END IF
```

##### 5. END
**Sözdizimi:** `END IF | END SELECT | END SUB | END FUNCTION | END CLASS | END MODULE`  
**Ne yapar:** Açılmış bloğu kapatır ve sınırını belli eder.  
**Nerede ve nasıl kullanılır:** Başlatılan bloğun nerede bittiğini açık eder. Büyük kodda her `END` aslında okuyucuya “bu fikir burada bitti” demektir.

```uxbasic
IF hazir THEN PRINT "tamam" END IF
```

##### 6. SELECT
**Sözdizimi:** `SELECT CASE ifade ... CASE değer ... END SELECT`  
**Ne yapar:** Tek bir değeri birçok olası değere göre dallandırır.  
**Nerede ve nasıl kullanılır:** Menü, durum kodu ve sınıflandırma işlerinde `IF` zincirinden daha temizdir. Aynı değişkenin birçok olası değerini yönetir.

```uxbasic
SELECT CASE menu: CASE 1: PRINT "derle": CASE 2: PRINT "calistir": CASE ELSE: PRINT "bilinmiyor": END SELECT
```

##### 7. CASE
**Sözdizimi:** `CASE değer | CASE IS > değer | CASE ELSE`  
**Ne yapar:** SELECT içindeki tek seçeneği belirtir.  
**Nerede ve nasıl kullanılır:** `SELECT` içinde tek seçeneği temsil eder. `CASE ELSE` bilinmeyen durumu güvenli yakalar.

```uxbasic
CASE IS > 100: PRINT "sinir ustu"
```

##### 8. IS
**Sözdizimi:** `CASE IS > değer | CASE IS <= değer`  
**Ne yapar:** CASE içinde karşılaştırmalı seçenek kurar.  
**Nerede ve nasıl kullanılır:** `CASE` satırında yalnız eşitlik değil büyüktür/küçüktür gibi sınır yazmanı sağlar.

```uxbasic
CASE IS <= 0: PRINT "gecersiz"
```

##### 9. TRY
**Sözdizimi:** `TRY ... CATCH hata ... FINALLY ... END TRY`  
**Ne yapar:** Hata çıkabilecek işi korumalı bölümde dener.  
**Nerede ve nasıl kullanılır:** Bozulabilecek işi güvenli kutuya alır. Dosya, ağ, DLL, veri dönüşümü ve büyük sayı hesaplarında kullanılmalıdır.

```uxbasic
TRY: OPEN "veri.csv" FOR INPUT AS #1: CATCH e: PRINT "dosya acilamadi": END TRY
```

##### 10. CATCH
**Sözdizimi:** `CATCH hataAdi`  
**Ne yapar:** TRY içindeki hata yakalanırsa çalışacak bölümü başlatır.  
**Nerede ve nasıl kullanılır:** Hatanın programı öldürmesi yerine anlaşılır mesaja veya yedek yola dönmesini sağlar.

```uxbasic
CATCH e: PRINT "hata="; e
```

##### 11. FINALLY
**Sözdizimi:** `FINALLY ...`  
**Ne yapar:** Hata olsa da olmasa da en son çalışacak temizlik bölümünü açar.  
**Nerede ve nasıl kullanılır:** Kaynak kapatma bölümüdür. Dosya kapatma, bağlantı bırakma ve geçici tampon temizleme burada yapılır.

```uxbasic
FINALLY: CLOSE #1
```

##### 12. THROW
**Sözdizimi:** `THROW "hata metni"`  
**Ne yapar:** Senin belirlediğin hatayı bilinçli olarak fırlatır.  
**Nerede ve nasıl kullanılır:** Sessiz yanlış sonuç üretmek yerine bilerek hata üretir. Verinin imkânsız olduğu yerde kullanılır.

```uxbasic
IF yas < 0 THEN THROW "yas negatif olamaz"
```

##### 13. ASSERT
**Sözdizimi:** `ASSERT koşul`  
**Ne yapar:** Test amacıyla bir koşulun doğru olmasını zorunlu tutar.  
**Nerede ve nasıl kullanılır:** Geliştirme ve test sırasında beklenen koşulu kilitler. Üretimden önce hatayı yakalamak için değerlidir.

```uxbasic
ASSERT adet > 0
```

##### 24. FOR
**Sözdizimi:** `FOR sayac = ilk TO son STEP adim ... NEXT sayac`  
**Ne yapar:** Sayaçlı döngü kurar.  
**Nerede ve nasıl kullanılır:** Kaç tekrar yapılacağı belliyse en temiz döngüdür. Dizi, veri satırı, test listesi ve gün sayımı için kullan.

```uxbasic
FOR i = 1 TO 10 STEP 1: PRINT i: NEXT i
```

##### 25. TO
**Sözdizimi:** `FOR i = başlangıç TO bitiş`  
**Ne yapar:** Döngünün son değerini gösterir.  
**Nerede ve nasıl kullanılır:** `FOR` döngüsünün sınırını söyler. Yanlış sınır eksik veya fazla tekrar üretir.

```uxbasic
FOR gun = 1 TO 30: PRINT gun: NEXT gun
```

##### 26. STEP
**Sözdizimi:** `FOR i = ilk TO son STEP adim`  
**Ne yapar:** Sayaç artışını veya azalışını belirler.  
**Nerede ve nasıl kullanılır:** Sayaç artışını belirler. Geri sayım, ikişer okuma ve seyreltme işleri için kullanılır.

```uxbasic
FOR i = 10 TO 0 STEP -2: PRINT i: NEXT i
```

##### 27. NEXT
**Sözdizimi:** `NEXT sayac`  
**Ne yapar:** FOR döngüsünün sonunu ve sonraki adıma geçişini gösterir.  
**Nerede ve nasıl kullanılır:** Sayaçlı döngüyü kapatır. Okunurluk için sayaç adını yazmak iyi alışkanlıktır.

```uxbasic
FOR i = 1 TO 3: PRINT i: NEXT i
```

##### 28. DO
**Sözdizimi:** `DO WHILE koşul ... LOOP | DO ... LOOP UNTIL koşul`  
**Ne yapar:** Koşullu döngü başlatır.  
**Nerede ve nasıl kullanılır:** Bitiş koşulu veriye bağlıysa kullanılır. Kullanıcı çıkış yazana kadar, dosya bitene kadar veya kuyruk boşalana kadar döner.

```uxbasic
DO WHILE EOF(#1)=0: INPUT #1, satir: LOOP
```

##### 29. LOOP
**Sözdizimi:** `LOOP | LOOP UNTIL koşul`  
**Ne yapar:** DO döngüsünü kapatır; gerekirse çıkış koşulunu taşır.  
**Nerede ve nasıl kullanılır:** `DO` bloğunu kapatır. `UNTIL` ile birlikte en az bir kez çalışacak döngü kurar.

```uxbasic
DO: INPUT cevap: LOOP UNTIL cevap = "EVET"
```

##### 30. WHILE
**Sözdizimi:** `DO WHILE koşul | WHILE koşul ... WEND`  
**Ne yapar:** Koşul doğru kaldığı sürece çalışmayı sürdürür.  
**Nerede ve nasıl kullanılır:** Koşul doğru kaldığı sürece çalışır. Başta koşul denetimi isteniyorsa uygundur.

```uxbasic
DO WHILE pil > 20: pil = pil - 1: LOOP
```

##### 31. UNTIL
**Sözdizimi:** `LOOP UNTIL koşul`  
**Ne yapar:** Koşul doğru olunca döngüyü bitirir.  
**Nerede ve nasıl kullanılır:** Döngü sonunda çıkış koşulunu yazar. Kullanıcıya en az bir kez soru sorulacak işlerde iyidir.

```uxbasic
DO: INPUT cevap: LOOP UNTIL cevap = "Q"
```

##### 32. EXIT
**Sözdizimi:** `EXIT FOR | EXIT DO | EXIT FUNCTION | EXIT SUB`  
**Ne yapar:** İçinde bulunulan döngüden veya yordamdan erken çıkar.  
**Nerede ve nasıl kullanılır:** Arama bittiğinde veya hata bulunduğunda gereksiz tekrarları keser.

```uxbasic
FOR i = 1 TO 100: IF i = hedef THEN EXIT FOR: NEXT i
```

##### 33. EACH
**Sözdizimi:** `FOR EACH eleman IN liste ... NEXT`  
**Ne yapar:** Bir koleksiyonun elemanlarını tek tek dolaşır.  
**Nerede ve nasıl kullanılır:** Koleksiyonları sayaçla uğraşmadan dolaşır. Liste ve sözlük anahtarlarında okunurluk sağlar.

```uxbasic
FOR EACH ad IN isimler: PRINT ad: NEXT
```

##### 34. IN
**Sözdizimi:** `FOR EACH x IN koleksiyon | x IN liste`  
**Ne yapar:** Bir elemanın hangi koleksiyondan geleceğini belirtir veya üyelik sınaması yapar.  
**Nerede ve nasıl kullanılır:** `EACH` ile veri kaynağını gösterir; üyelik mantığında da “şurada var mı?” sorusunu anlatır.

```uxbasic
FOR EACH v IN olcumler: PRINT v: NEXT
```

##### 38. RETURN
**Sözdizimi:** `RETURN değer`  
**Ne yapar:** Fonksiyondan sonuç döndürür veya alt yordamdan geri döner.  
**Nerede ve nasıl kullanılır:** Fonksiyon sonucunu çağırana verir. Fonksiyonun tek amacı net sonuç döndürmektir.

```uxbasic
FUNCTION IkiKat(x AS I32) AS I32: RETURN x * 2: END FUNCTION
```

##### 39. GOTO
**Sözdizimi:** `GOTO etiket`  
**Ne yapar:** Belirtilen etikete doğrudan atlar.  
**Nerede ve nasıl kullanılır:** Doğrudan atlar. Eski BASIC uyumu ve kısa kurtarma dışında yeni kodda dikkatli kullanılmalıdır.

```uxbasic
GOTO Temizle
```

##### 40. GOSUB
**Sözdizimi:** `GOSUB etiket ... RETURN`  
**Ne yapar:** Etikete gider ve RETURN ile geri döner.  
**Nerede ve nasıl kullanılır:** Eski alt yordam düzenidir. Eğitim ve uyumlulukta görülür; yeni kodda `SUB` daha temizdir.

```uxbasic
GOSUB YazBaslik
```

#### Bu sınıfı birlikte kullanma örnekleri

##### Üretim kalite kontrolü: 30 ölçümle hata sınıflandırma

```uxbasic
CONST ALT AS F64 = 98.5
CONST UST AS F64 = 101.5
DIM olcum(30) AS F64
DIM i AS I32
DIM hatali AS I32
DIM toplam AS F64
FOR i = 1 TO 30
    INPUT olcum(i)
    IF olcum(i) < ALT OR olcum(i) > UST THEN
        hatali = hatali + 1
        PRINT "uyari satir="; i; " deger="; olcum(i)
    ELSE
        toplam = toplam + olcum(i)
    END IF
NEXT i
SELECT CASE hatali
CASE 0
    PRINT "parti temiz"
CASE IS <= 3
    PRINT "parti kosullu kabul; ek kontrol gerekli"
CASE ELSE
    PRINT "parti reddedildi; makine ayari incelenecek"
END SELECT
IF hatali < 30 THEN PRINT "saglam ortalama="; toplam / (30-hatali)
```

Bu örnek `CONST`, `DIM`, `FOR`, `IF`, `OR`, `SELECT`, `CASE`, `PRINT` komutlarını birlikte kullanır. Hile şudur: kalite kararını yüzlerce `IF` yerine önce sayaçla özetliyoruz, sonra `SELECT CASE` ile yönetim kararına çeviriyoruz.

##### Menü, dosya ve hata yakalama ile küçük derleyici yardımcısı

```uxbasic
DIM secim AS I32
DIM kaynak AS STRING
PRINT "1=AST  2=MIR  3=JS  4=Cikis"
INPUT secim
INPUT kaynak
TRY
    SELECT CASE secim
    CASE 1
        PRINT "uxb ast "; kaynak; " --ast-json-out out/ast.json"
    CASE 2
        PRINT "uxb mir "; kaynak; " --mir-full-json-out out/mir.json"
    CASE 3
        PRINT "uxb jsw "; kaynak; " --emit-js --js-out dist/program.js"
    CASE 4
        PRINT "cikis"
    CASE ELSE
        THROW "bilinmeyen secim"
    END SELECT
CATCH e
    PRINT "menu hatasi: "; e
FINALLY
    PRINT "oturum kapandi"
END TRY
```

Bu örnek kullanıcıya seçenek verip derleyici komut satırı üretir. Kullanıcı yanlış seçim yaparsa `THROW` ile hata görünür olur, `CATCH` bunu yakalar, `FINALLY` oturumun kapandığını bildirir.

##### Dosya sonuna kadar okuma ve erken çıkış

```uxbasic
OPEN "olcum.csv" FOR INPUT AS #1
DIM satir AS STRING
DIM adet AS I32
DIM toplam AS F64
DO WHILE EOF(#1)=0
    INPUT #1, satir
    IF LEN(satir) = 0 THEN EXIT DO
    deger = VAL(satir)
    IF deger < 0 THEN EXIT DO
    toplam = toplam + deger
    adet = adet + 1
LOOP
CLOSE #1
IF adet > 0 THEN PRINT "ortalama="; toplam/adet ELSE PRINT "gecerli veri yok" END IF
```

Burada döngü sayısı önceden bilinmez. `EOF`, `DO WHILE`, `EXIT DO`, `VAL`, `LEN`, `OPEN`, `CLOSE` birlikte dosya okuma akışını güvenli yapar.

### Olay ve eşzamanlılık

Olay ve eşzamanlılık komutları programı bekleyen, tepki veren ve aynı anda iş bölümü yapabilen bir sisteme dönüştürür. Olay [bir şey oldu bilgisi] (event), boru [veri taşıma hattı] (pipe), yuva [olaya cevap veren kod] (slot), iş parçacığı [arka planda çalışan iş] (thread) ve koşut çalışma [bağımsız işleri birlikte planlama] (parallel) birlikte düşünülür. Bu sınıf GUI, tarayıcı, sensör, oyun, sunucu, dosya izleme ve uzun hesaplarda kullanılır. Genç programcı için en önemli ders şudur: aynı değişkeni birçok işin rastgele değiştirmesine izin verme; veriyi boruyla taşı, olayı açık adla tetikle, tepkiyi yuva içinde topla.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|EVENT|EVENT OlayAdi|Daha sonra tetiklenecek olay adını bildirir.|
|THREAD|THREAD IsAdi ... END THREAD|Ayrı iş parçası olarak çalışacak işi tanımlar.|
|THREAD|THREAD IsAdi ... END THREAD|Ayrı iş parçası olarak çalışacak işi tanımlar. Eski metinlerde THREAT görülürse yazım hatası kabul edilir; yeni kodda THREAD kullanılır.|
|PARALEL|PARALEL GrupAdi ... END PARALEL|Birden fazla işi paralel görev ailesi olarak düzenler.|
|PIPE|PIPE Ad AS Tip|İki iş arasında veri taşıyan boru tanımlar.|
|SLOT|SLOT Ad ON Olay ... END SLOT|Bir olaya bağlı çalışacak kod yuvasını tanımlar.|
|ON|SLOT Ad ON Olay \| ON ERROR ...|Bir eylemi olaya veya duruma bağlar.|
|OFF|OFF Olay \| OFF SLOT Ad|Olay dinlemeyi veya bağlı tepkiyi kapatır.|
|TRIGGER|TRIGGER OlayAdi[, veri]|Bir olayı elle tetikler.|

#### Tekil komut defteri

##### 14. EVENT
**Sözdizimi:** `EVENT OlayAdi`  
**Ne yapar:** Daha sonra tetiklenecek olay adını bildirir.  
**Nerede ve nasıl kullanılır:** Olay adını belirler. Düğme tıklaması, sensör verisi, dosya geldi bildirimi ve zaman doldu bilgisi için kullanılır.

```uxbasic
EVENT VeriGeldi
```

##### 15. THREAD
**Sözdizimi:** `THREAD IsAdi ... END THREAD`  
**Ne yapar:** Ayrı iş parçası olarak çalışacak işi tanımlar.  
**Nerede ve nasıl kullanılır:** Uzun işi ana akışı durdurmadan yapar. Dosya okuma, ağ bekleme ve hesaplama için uygundur.

```uxbasic
THREAD ArkaPlan: PRINT "uzun is": END THREAD
```

##### 16. THREAD
**Sözdizimi:** `THREAD IsAdi ... END THREAD`  
**Ne yapar:** Ayrı iş parçası olarak çalışacak işi tanımlar. Eski metinlerde THREAT görülürse yazım hatası kabul edilir; yeni kodda THREAD kullanılır.  
**Nerede ve nasıl kullanılır:** Uzun işi ana akışı durdurmadan yapar. Dosya okuma, ağ bekleme ve hesaplama için uygundur.

```uxbasic
THREAD ArkaPlan: PRINT "uzun is": END THREAD
```

##### 17. PARALEL
**Sözdizimi:** `PARALEL GrupAdi ... END PARALEL`  
**Ne yapar:** Birden fazla işi paralel görev ailesi olarak düzenler.  
**Nerede ve nasıl kullanılır:** Bağımsız işleri aynı aile altında planlar. Birbirine veri bağı olmayan hesaplar burada hız kazanır.

```uxbasic
PARALEL Isler: CALL Oku(): CALL Hesapla(): END PARALEL
```

##### 18. PIPE
**Sözdizimi:** `PIPE Ad AS Tip`  
**Ne yapar:** İki iş arasında veri taşıyan boru tanımlar.  
**Nerede ve nasıl kullanılır:** İşler arasında veri hattı kurar. Paylaşılan değişken karmaşası yerine düzenli akış sağlar.

```uxbasic
PIPE OlcumHatti AS F64
```

##### 19. SLOT
**Sözdizimi:** `SLOT Ad ON Olay ... END SLOT`  
**Ne yapar:** Bir olaya bağlı çalışacak kod yuvasını tanımlar.  
**Nerede ve nasıl kullanılır:** Olay geldiğinde çalışacak cevabı taşır. GUI ve sensör mantığında çok kullanılır.

```uxbasic
SLOT Kaydet ON VeriGeldi: PRINT "kaydedildi": END SLOT
```

##### 20. ON
**Sözdizimi:** `SLOT Ad ON Olay | ON ERROR ...`  
**Ne yapar:** Bir eylemi olaya veya duruma bağlar.  
**Nerede ve nasıl kullanılır:** Olay ile tepkiyi bağlar. “Bu olunca şunu yap” cümlesinin bağlama parçasıdır.

```uxbasic
SLOT Tiklama ON ButonTiklandi: PRINT "tiklandi": END SLOT
```

##### 21. OFF
**Sözdizimi:** `OFF Olay | OFF SLOT Ad`  
**Ne yapar:** Olay dinlemeyi veya bağlı tepkiyi kapatır.  
**Nerede ve nasıl kullanılır:** Olay dinlemeyi kapatır. Güvenli kapanış, geçici durdurma ve testte kullanılır.

```uxbasic
OFF VeriGeldi
```

##### 22. TRIGGER
**Sözdizimi:** `TRIGGER OlayAdi[, veri]`  
**Ne yapar:** Bir olayı elle tetikler.  
**Nerede ve nasıl kullanılır:** Olayı elle tetikler. Testte sensör varmış gibi davranmak için çok iyidir.

```uxbasic
TRIGGER VeriGeldi, 42
```

#### Bu sınıfı birlikte kullanma örnekleri

##### Sensör verisini olay, boru ve yuva ile taşıma

```uxbasic
EVENT VeriGeldi
PIPE OlcumHatti AS F64
SLOT DosyayaYaz ON VeriGeldi
    INPUT deger
    OPEN "saha.log" FOR APPEND AS #1
    PRINT #1, STR(TIMER()) + ";" + STR(deger)
    CLOSE #1
    IF deger < 6.5 OR deger > 8.5 THEN PRINT "ph alarm="; deger
END SLOT
THREAD SensorOku
    FOR i = 1 TO 5
        TRIGGER VeriGeldi
    NEXT i
END THREAD
PARALEL SahaIzleme
    CALL SensorOku()
    PRINT "ana ekran donmedi"
END PARALEL
```

Büyük fikir: sensör verisini doğrudan her yerden değişkene yazdırmıyoruz. Olay adı, tepki yuvası ve arka plan işi belirgin. Bu, GUI ve tarayıcıda da aynı mantıkla büyür.

##### Tarayıcı butonu ve yapay gecikmeli hesap

```uxbasic
EVENT ButonTiklandi
EVENT HesapBitti
SLOT Baslat ON ButonTiklandi
    PRINT "hesap basladi"
    TRIGGER HesapBitti, 100
END SLOT
SLOT SonucuGoster ON HesapBitti
    INPUT skor
    IF skor >= 90 THEN PRINT "basarili" ELSE PRINT "tekrar dene" END IF
END SLOT
TRIGGER ButonTiklandi
```

Burada gerçek buton yokken bile `TRIGGER` ile olay sınanır. Genç programcı önce olayı elle tetikler; sonra aynı olayı GUI veya tarayıcı tıklamasına bağlar.

### Yordam ve çağrı

Yordam ve çağrı komutları programı tekrar kullanılabilir parçaya böler. Sonuç döndürmeyen iş için alt yordam [tekrar kullanılabilir işlem bloğu] (SUB), sonuç döndüren iş için fonksiyon [değer üreten işlem] (FUNCTION), dış kütüphane için bildirim [imza tanımı] (DECLARE), çalıştırmak için çağrı (CALL) kullanılır. `BYVAL` kopya gönderir, `BYREF` değişkenin kendisini verir. `CDECL` ve `STDCALL` dış dünyanın çağrı düzenini anlatır. Bu sınıfta amaç çekirdeği şişirmeden dış gücü temiz bir kapıdan kullanmaktır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|SUB|SUB Ad(param AS Tip) ... END SUB|Değer döndürmeyen tekrar kullanılabilir iş bloğu tanımlar.|
|FUNCTION|FUNCTION Ad(param AS Tip) AS Tip ... RETURN değer ... END FUNCTION|Değer döndüren hesap veya dönüştürme bloğu tanımlar.|
|DECLARE|DECLARE FUNCTION Ad LIB "dll" ALIAS "gercek_ad" (...) AS Tip|Dış kütüphane fonksiyonunun uXBasic tarafındaki imzasını bildirir.|
|CALL|CALL Ad(argler) \| CALL(DLL,"dll","fonksiyon",argler) \| CALL(API,"ad",argler)|Tanımlı yordamı, dış DLL fonksiyonunu veya API çağrısını çalıştırır.|
|BYREF|param AS BYREF Tip \| BYREF param AS Tip|Parametrenin kendisini gönderir; fonksiyon değeri değiştirebilir.|
|BYVAL|BYVAL param AS Tip|Parametrenin kopyasını gönderir; çağıranın değişkeni etkilenmez.|
|CDECL|DECLARE CDECL FUNCTION ...|C çağrı düzenini belirtir.|
|STDCALL|DECLARE STDCALL FUNCTION ...|Windows çağrı düzenini belirtir.|

#### Tekil komut defteri

##### 35. SUB
**Sözdizimi:** `SUB Ad(param AS Tip) ... END SUB`  
**Ne yapar:** Değer döndürmeyen tekrar kullanılabilir iş bloğu tanımlar.  
**Nerede ve nasıl kullanılır:** Sonuç döndürmeyen işi adlandırır. Başlık yazma, dosyaya kaydetme, ekran güncelleme için uygundur.

```uxbasic
SUB BaslikYaz(): PRINT "RAPOR": END SUB
```

##### 36. FUNCTION
**Sözdizimi:** `FUNCTION Ad(param AS Tip) AS Tip ... RETURN değer ... END FUNCTION`  
**Ne yapar:** Değer döndüren hesap veya dönüştürme bloğu tanımlar.  
**Nerede ve nasıl kullanılır:** Hesap yapar ve sonuç döndürür. Ortalama, dönüştürme, doğrulama, metin temizleme gibi işlerde kullanılır.

```uxbasic
FUNCTION Kare(x AS F64) AS F64: RETURN x*x: END FUNCTION
```

##### 37. DECLARE
**Sözdizimi:** `DECLARE FUNCTION Ad LIB "dll" ALIAS "gercek_ad" (...) AS Tip`  
**Ne yapar:** Dış kütüphane fonksiyonunun uXBasic tarafındaki imzasını bildirir.  
**Nerede ve nasıl kullanılır:** Dış fonksiyonun adını, dönüşünü ve parametrelerini bildirir. DLL/API çağrısının güvenlik kapısıdır.

```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32
```

##### 41. CALL
**Sözdizimi:** `CALL Ad(argler) | CALL(DLL,"dll","fonksiyon",argler) | CALL(API,"ad",argler)`  
**Ne yapar:** Tanımlı yordamı, dış DLL fonksiyonunu veya API çağrısını çalıştırır.  
**Nerede ve nasıl kullanılır:** Tanımlı işi çalıştırır. uXBasic fonksiyonu, DLL, API veya servis çağrısı burada tetiklenir.

```uxbasic
CALL BaslikYaz()
```

##### 129. BYREF
**Sözdizimi:** `param AS BYREF Tip | BYREF param AS Tip`  
**Ne yapar:** Parametrenin kendisini gönderir; fonksiyon değeri değiştirebilir.  
**Nerede ve nasıl kullanılır:** Değişkenin kendisini gönderir; çağrılan yordam değeri değiştirebilir.

```uxbasic
SUB Artir(BYREF x AS I32): x = x + 1: END SUB
```

##### 130. BYVAL
**Sözdizimi:** `BYVAL param AS Tip`  
**Ne yapar:** Parametrenin kopyasını gönderir; çağıranın değişkeni etkilenmez.  
**Nerede ve nasıl kullanılır:** Değerin kopyasını gönderir; çağıranın değişkeni korunur.

```uxbasic
DECLARE FUNCTION Uyku LIB "kernel32.dll" ALIAS "Sleep" (BYVAL ms AS U32) AS I32
```

##### 131. CDECL
**Sözdizimi:** `DECLARE CDECL FUNCTION ...`  
**Ne yapar:** C çağrı düzenini belirtir.  
**Nerede ve nasıl kullanılır:** C kütüphaneleri için çağrı düzenini belirtir.

```uxbasic
DECLARE CDECL FUNCTION cos LIB "msvcrt.dll" ALIAS "cos" (BYVAL x AS F64) AS F64
```

##### 132. STDCALL
**Sözdizimi:** `DECLARE STDCALL FUNCTION ...`  
**Ne yapar:** Windows çağrı düzenini belirtir.  
**Nerede ve nasıl kullanılır:** Windows API çağrılarında sık görülen çağrı düzenini belirtir.

```uxbasic
DECLARE STDCALL FUNCTION MessageBox LIB "user32.dll" ALIAS "MessageBoxA" (...) AS I32
```

#### Bu sınıfı birlikte kullanma örnekleri

##### DLL/API ayrıntısını sarmalayan güvenli fonksiyon

```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32
FUNCTION UyariSesi(seviye AS I32) AS I32
    IF seviye <= 0 THEN RETURN 0
    IF seviye = 1 THEN RETURN Beep(800, 120)
    IF seviye = 2 THEN RETURN Beep(1200, 180)
    RETURN Beep(1600, 250)
END FUNCTION
SUB HataBildir(metin AS STRING)
    PRINT "HATA: "; metin
    CALL UyariSesi(2)
END SUB
CALL HataBildir("ph sinir disi")
```

Hile: programın her yerine doğrudan DLL çağrısı yazmıyoruz. Önce `DECLARE`, sonra uXBasic fonksiyonu, sonra programın kalanına temiz `HataBildir` çağrısı veriyoruz.

##### BYREF ile toplam ve adet döndürme

```uxbasic
SUB OlcumEkle(BYREF toplam AS F64, BYREF adet AS I32, BYVAL deger AS F64)
    IF deger < 0 THEN EXIT SUB
    toplam = toplam + deger
    adet = adet + 1
END SUB
DIM t AS F64
DIM n AS I32
FOR i = 1 TO 5
    INPUT x
    CALL OlcumEkle(t, n, x)
NEXT i
IF n > 0 THEN PRINT "ortalama="; t/n
```

`BYREF` sayesinde `toplam` ve `adet` çağıran tarafta değişir. `BYVAL deger` ise güvenli kopyadır; yordam ölçüm değerini değiştirse bile asıl değişkene zarar vermez.

### Nesne ve tip bildirimi

Nesne ve tip bildirimi, büyük programlarda veri ile davranışı düzenler. Kayıt tipi [alanları olan düz veri] (TYPE) ölçüm kaydı gibi basit yapılar için iyidir. Sınıf [veri ve davranış kalıbı] (CLASS) nesne kurar; arayüz [sözleşme] (INTERFACE) hangi yöntemlerin bulunacağını söyler. Kurucu, yıkıcı, özellik, erişim belirleyici ve sihirli yöntemler nesneyi güvenli ve okunur hâle getirir. Genç programcı burada şunu öğrenir: veri dağınık durursa program dağılır; veri ve davranış aynı kavramın etrafında toplanırsa kod büyürken anlaşılır kalır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|TYPE|TYPE Ad ... END TYPE|Kayıt biçiminde veri alanları toplar.|
|CLASS|CLASS Ad ... END CLASS|Veri ve davranışı aynı nesne kalıbında toplar.|
|INTERFACE|INTERFACE Ad ... END INTERFACE|Bir sınıfın yerine getireceği yöntem sözleşmesini tanımlar.|
|IMPLEMENTS|CLASS Ad IMPLEMENTS Arayuz|Sınıfın arayüz sözleşmesini üstlendiğini belirtir.|
|METHOD|METHOD Ad(...) AS Tip|Sınıf içindeki işlevi tanımlar.|
|MAGIC|MAGIC <.Ad.>(...)|Sihirli yöntem tanımlar. Eski metinlerde SIHIRLIMETOT görülürse uyumluluk/yazım hatası kabul edilir; yeni kodda MAGIC kullanılır.|
|MAGIC|MAGIC Ad(...)|Sihirli yöntem için kısa/alternatif yazım sağlar.|
|VIRTUAL|VIRTUAL METHOD Ad(...)|Alt sınıfın değiştirebileceği yöntem bildirir.|
|OVERRIDE|OVERRIDE METHOD Ad(...)|Üst sınıftaki yöntemi bilinçli olarak değiştirir.|
|CONSTRUCTOR|CONSTRUCTOR(...)|Nesne oluşurken çalışan kurucu bölümdür.|
|DESTRUCTOR|DESTRUCTOR()|Nesne yok olurken temizlik yapar.|
|NEW|NEW Sinif(argler)|Yeni nesne oluşturur.|
|DELETE|DELETE nesne|Nesne/ayrılmış kaynağı bırakır.|
|ABSTRACT|ABSTRACT CLASS Ad|Doğrudan üretilmeyen temel sınıf tanımlar.|
|FINAL|FINAL CLASS Ad \| FINAL METHOD Ad|Daha fazla miras/değiştirme yapılmasını engeller.|
|SEALED|SEALED CLASS Ad|Kapatılmış sınıf bildirir.|
|STATIC|STATIC alan AS Tip \| STATIC METHOD Ad|Sınıfa ait tek ortak alan/yöntem tanımlar.|
|PROPERTY|PROPERTY Ad AS Tip|Nesne alanını kontrollü özellik olarak tanımlar.|
|OPERATOR|OPERATOR +(a,b)|Sınıf için işlemci davranışı tanımlar.|
|MIXIN|MIXIN Ad|Bir sınıfa ek davranış karışımı ekler.|
|DECORATOR|DECORATOR Ad|Yordam/sınıf etrafına ek davranış sarar.|
|PUBLIC|PUBLIC ad|Dışarıdan erişilebilir üye bildirir.|
|PRIVATE|PRIVATE ad|Sadece kendi sınıf/modülü içinden erişilir.|
|PROTECTED|PROTECTED ad|Kendi sınıfı ve alt sınıflar erişir.|
|RESTRICTED|RESTRICTED ad|Daraltılmış erişim kuralı belirtir.|
|FRIEND|FRIEND MODULE Ad|Belirli modül/sınıfa özel erişim verir.|
|READONLY|READONLY ad AS Tip|Dışarıdan değiştirilemeyen okuma alanı bildirir.|
|MUTABLE|MUTABLE ad AS Tip|Normalde sabit bağlamda bile değişebilir alan belirtir.|
|IMMUTABLE|IMMUTABLE ad AS Tip|Değişmez veri/nesne niyeti belirtir.|

#### Tekil komut defteri

##### 42. TYPE
**Sözdizimi:** `TYPE Ad ... END TYPE`  
**Ne yapar:** Kayıt biçiminde veri alanları toplar.  
**Nerede ve nasıl kullanılır:** Alanları olan düz kayıt kurar. Dosya satırı, ölçüm kaydı ve binary yapı için idealdir.

```uxbasic
TYPE Olcum: ph AS F64: sicaklik AS F64: END TYPE
```

##### 43. CLASS
**Sözdizimi:** `CLASS Ad ... END CLASS`  
**Ne yapar:** Veri ve davranışı aynı nesne kalıbında toplar.  
**Nerede ve nasıl kullanılır:** Veri ve davranışı bir araya getirir. Büyük programda kavramları nesne olarak toplar.

```uxbasic
CLASS Numune: PUBLIC ph AS F64: END CLASS
```

##### 44. INTERFACE
**Sözdizimi:** `INTERFACE Ad ... END INTERFACE`  
**Ne yapar:** Bir sınıfın yerine getireceği yöntem sözleşmesini tanımlar.  
**Nerede ve nasıl kullanılır:** Sınıfa sözleşme koyar. “Bu sınıf şu yöntemleri sağlayacak” demektir.

```uxbasic
INTERFACE Yazilabilir: METHOD Yaz() AS I32: END INTERFACE
```

##### 45. IMPLEMENTS
**Sözdizimi:** `CLASS Ad IMPLEMENTS Arayuz`  
**Ne yapar:** Sınıfın arayüz sözleşmesini üstlendiğini belirtir.  
**Nerede ve nasıl kullanılır:** Sınıfın bir arayüz sözleşmesini üstlendiğini söyler.

```uxbasic
CLASS Rapor IMPLEMENTS Yazilabilir
```

##### 46. METHOD
**Sözdizimi:** `METHOD Ad(...) AS Tip`  
**Ne yapar:** Sınıf içindeki işlevi tanımlar.  
**Nerede ve nasıl kullanılır:** Sınıf içindeki fonksiyondur. Nesnenin davranışını taşır.

```uxbasic
METHOD Ortalama() AS F64: RETURN toplam/adet: END METHOD
```

##### 47. MAGIC
**Sözdizimi:** `MAGIC <.Ad.>(...)`  
**Ne yapar:** Sihirli yöntem tanımlar. Eski metinlerde SIHIRLIMETOT görülürse uyumluluk/yazım hatası kabul edilir; yeni kodda MAGIC kullanılır.  
**Nerede ve nasıl kullanılır:** Sihirli yöntem tanımlar; nesnenin özel davranışını dil yüzeyine bağlar.

```uxbasic
MAGIC <.toString.>() AS STRING: RETURN ad: END MAGIC
```

##### 48. MAGIC
**Sözdizimi:** `MAGIC Ad(...)`  
**Ne yapar:** Sihirli yöntem için kısa/alternatif yazım sağlar.  
**Nerede ve nasıl kullanılır:** Sihirli yöntem tanımlar; nesnenin özel davranışını dil yüzeyine bağlar.

```uxbasic
MAGIC <.toString.>() AS STRING: RETURN ad: END MAGIC
```

##### 49. VIRTUAL
**Sözdizimi:** `VIRTUAL METHOD Ad(...)`  
**Ne yapar:** Alt sınıfın değiştirebileceği yöntem bildirir.  
**Nerede ve nasıl kullanılır:** Alt sınıfın değiştirebileceği yöntemi işaretler.

```uxbasic
VIRTUAL METHOD Hesapla() AS F64
```

##### 50. OVERRIDE
**Sözdizimi:** `OVERRIDE METHOD Ad(...)`  
**Ne yapar:** Üst sınıftaki yöntemi bilinçli olarak değiştirir.  
**Nerede ve nasıl kullanılır:** Üst sınıftan gelen davranışı bilinçli olarak değiştirir.

```uxbasic
OVERRIDE METHOD Hesapla() AS F64: RETURN yeniSonuc: END METHOD
```

##### 51. CONSTRUCTOR
**Sözdizimi:** `CONSTRUCTOR(...)`  
**Ne yapar:** Nesne oluşurken çalışan kurucu bölümdür.  
**Nerede ve nasıl kullanılır:** Nesne oluşurken başlangıç değerlerini kurar.

```uxbasic
CONSTRUCTOR(p AS F64): ph = p: END CONSTRUCTOR
```

##### 52. DESTRUCTOR
**Sözdizimi:** `DESTRUCTOR()`  
**Ne yapar:** Nesne yok olurken temizlik yapar.  
**Nerede ve nasıl kullanılır:** Nesne bırakılırken kaynak temizler.

```uxbasic
DESTRUCTOR(): PRINT "kaynak kapandi": END DESTRUCTOR
```

##### 53. NEW
**Sözdizimi:** `NEW Sinif(argler)`  
**Ne yapar:** Yeni nesne oluşturur.  
**Nerede ve nasıl kullanılır:** Yeni nesne oluşturur.

```uxbasic
numune = NEW Numune(7.2)
```

##### 54. DELETE
**Sözdizimi:** `DELETE nesne`  
**Ne yapar:** Nesne/ayrılmış kaynağı bırakır.  
**Nerede ve nasıl kullanılır:** Nesneyi veya kaynağı bırakır.

```uxbasic
DELETE numune
```

##### 61. ABSTRACT
**Sözdizimi:** `ABSTRACT CLASS Ad`  
**Ne yapar:** Doğrudan üretilmeyen temel sınıf tanımlar.  
**Nerede ve nasıl kullanılır:** `ABSTRACT` nesne düzeninin okunur ve güvenli kalması için kullanılır. Doğrudan üretilmeyen temel sınıf tanımlar. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
ABSTRACT CLASS Ad
```

##### 62. FINAL
**Sözdizimi:** `FINAL CLASS Ad | FINAL METHOD Ad`  
**Ne yapar:** Daha fazla miras/değiştirme yapılmasını engeller.  
**Nerede ve nasıl kullanılır:** `FINAL` nesne düzeninin okunur ve güvenli kalması için kullanılır. Daha fazla miras/değiştirme yapılmasını engeller. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
FINAL CLASS Ad | FINAL METHOD Ad
```

##### 63. SEALED
**Sözdizimi:** `SEALED CLASS Ad`  
**Ne yapar:** Kapatılmış sınıf bildirir.  
**Nerede ve nasıl kullanılır:** `SEALED` nesne düzeninin okunur ve güvenli kalması için kullanılır. Kapatılmış sınıf bildirir. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
SEALED CLASS Ad
```

##### 64. STATIC
**Sözdizimi:** `STATIC alan AS Tip | STATIC METHOD Ad`  
**Ne yapar:** Sınıfa ait tek ortak alan/yöntem tanımlar.  
**Nerede ve nasıl kullanılır:** `STATIC` nesne düzeninin okunur ve güvenli kalması için kullanılır. Sınıfa ait tek ortak alan/yöntem tanımlar. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
STATIC alan AS Tip | STATIC METHOD Ad
```

##### 65. PROPERTY
**Sözdizimi:** `PROPERTY Ad AS Tip`  
**Ne yapar:** Nesne alanını kontrollü özellik olarak tanımlar.  
**Nerede ve nasıl kullanılır:** `PROPERTY` nesne düzeninin okunur ve güvenli kalması için kullanılır. Nesne alanını kontrollü özellik olarak tanımlar. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
PROPERTY Ad AS Tip
```

##### 66. OPERATOR
**Sözdizimi:** `OPERATOR +(a,b)`  
**Ne yapar:** Sınıf için işlemci davranışı tanımlar.  
**Nerede ve nasıl kullanılır:** `OPERATOR` nesne düzeninin okunur ve güvenli kalması için kullanılır. Sınıf için işlemci davranışı tanımlar. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
OPERATOR +(a,b)
```

##### 67. MIXIN
**Sözdizimi:** `MIXIN Ad`  
**Ne yapar:** Bir sınıfa ek davranış karışımı ekler.  
**Nerede ve nasıl kullanılır:** `MIXIN` nesne düzeninin okunur ve güvenli kalması için kullanılır. Bir sınıfa ek davranış karışımı ekler. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
MIXIN Ad
```

##### 68. DECORATOR
**Sözdizimi:** `DECORATOR Ad`  
**Ne yapar:** Yordam/sınıf etrafına ek davranış sarar.  
**Nerede ve nasıl kullanılır:** `DECORATOR` nesne düzeninin okunur ve güvenli kalması için kullanılır. Yordam/sınıf etrafına ek davranış sarar. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
DECORATOR Ad
```

##### 69. PUBLIC
**Sözdizimi:** `PUBLIC ad`  
**Ne yapar:** Dışarıdan erişilebilir üye bildirir.  
**Nerede ve nasıl kullanılır:** `PUBLIC` nesne düzeninin okunur ve güvenli kalması için kullanılır. Dışarıdan erişilebilir üye bildirir. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
PUBLIC ad
```

##### 70. PRIVATE
**Sözdizimi:** `PRIVATE ad`  
**Ne yapar:** Sadece kendi sınıf/modülü içinden erişilir.  
**Nerede ve nasıl kullanılır:** `PRIVATE` nesne düzeninin okunur ve güvenli kalması için kullanılır. Sadece kendi sınıf/modülü içinden erişilir. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
PRIVATE ad
```

##### 71. PROTECTED
**Sözdizimi:** `PROTECTED ad`  
**Ne yapar:** Kendi sınıfı ve alt sınıflar erişir.  
**Nerede ve nasıl kullanılır:** `PROTECTED` nesne düzeninin okunur ve güvenli kalması için kullanılır. Kendi sınıfı ve alt sınıflar erişir. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
PROTECTED ad
```

##### 72. RESTRICTED
**Sözdizimi:** `RESTRICTED ad`  
**Ne yapar:** Daraltılmış erişim kuralı belirtir.  
**Nerede ve nasıl kullanılır:** `RESTRICTED` nesne düzeninin okunur ve güvenli kalması için kullanılır. Daraltılmış erişim kuralı belirtir. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
RESTRICTED ad
```

##### 73. FRIEND
**Sözdizimi:** `FRIEND MODULE Ad`  
**Ne yapar:** Belirli modül/sınıfa özel erişim verir.  
**Nerede ve nasıl kullanılır:** `FRIEND` nesne düzeninin okunur ve güvenli kalması için kullanılır. Belirli modül/sınıfa özel erişim verir. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
FRIEND MODULE Ad
```

##### 74. READONLY
**Sözdizimi:** `READONLY ad AS Tip`  
**Ne yapar:** Dışarıdan değiştirilemeyen okuma alanı bildirir.  
**Nerede ve nasıl kullanılır:** `READONLY` nesne düzeninin okunur ve güvenli kalması için kullanılır. Dışarıdan değiştirilemeyen okuma alanı bildirir. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
READONLY ad AS Tip
```

##### 75. MUTABLE
**Sözdizimi:** `MUTABLE ad AS Tip`  
**Ne yapar:** Normalde sabit bağlamda bile değişebilir alan belirtir.  
**Nerede ve nasıl kullanılır:** `MUTABLE` nesne düzeninin okunur ve güvenli kalması için kullanılır. Normalde sabit bağlamda bile değişebilir alan belirtir. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
MUTABLE ad AS Tip
```

##### 76. IMMUTABLE
**Sözdizimi:** `IMMUTABLE ad AS Tip`  
**Ne yapar:** Değişmez veri/nesne niyeti belirtir.  
**Nerede ve nasıl kullanılır:** `IMMUTABLE` nesne düzeninin okunur ve güvenli kalması için kullanılır. Değişmez veri/nesne niyeti belirtir. Büyük projede erişim, miras ve davranış sınırını netleştirir.

```uxbasic
IMMUTABLE ad AS Tip
```

#### Bu sınıfı birlikte kullanma örnekleri

##### Laboratuvar numunesini sınıf olarak modelleme

```uxbasic
INTERFACE Raporlanabilir
    METHOD RaporYaz() AS I32
END INTERFACE
CLASS Numune IMPLEMENTS Raporlanabilir
PUBLIC
    PROPERTY Kod AS STRING
    PROPERTY Ph AS F64
    CONSTRUCTOR(k AS STRING, p AS F64)
        Kod = k
        Ph = p
    END CONSTRUCTOR
    METHOD UygunMu() AS BOOLEAN
        RETURN Ph >= 6.5 AND Ph <= 8.5
    END METHOD
    METHOD RaporYaz() AS I32
        IF UygunMu() THEN PRINT Kod + " uygun" ELSE PRINT Kod + " alarm"
        RETURN 1
    END METHOD
END CLASS
DIM n AS Numune
n = NEW Numune("N-001", 7.22)
CALL n.RaporYaz()
DELETE n
```

Bu örnek veri ve davranışı bir araya getirir. `Kod` ve `Ph` çıplak değişken olarak dağılmaz; `UygunMu` ve `RaporYaz` davranışı sınıf içinde durur.

##### TYPE ile binary dosya kaydı

```uxbasic
TYPE OlcumKaydi
    zaman AS F64
    ph AS F64
    sicaklik AS F64
END TYPE
DIM k AS OlcumKaydi
k.zaman = TIMER()
k.ph = 7.15
k.sicaklik = 24.3
OPEN "kayit.bin" FOR OUTPUT AS #1
PUT #1, 1, k
CLOSE #1
PRINT "kayit boyutu="; SIZEOF(OlcumKaydi)
```

`TYPE` davranış değil düzen ister. Binary dosya, dış C yapısı veya ham kayıt için sınıftan daha hafiftir.

### Değişken ve bellek

Değişken ve bellek komutları programın değerleri nerede tuttuğunu belirler. `DIM` ile değer için yer açılır, `REDIM` ile dizi büyütülür, `AS` ile tip açıklanır, `CONST` ile değişmeyecek değer korunur. uXBasic’te değişken yalnız isim değildir; sınır, tip ve niyet bilgisidir. Hata azaltmak için değişken adını yaptığı işe göre seç, tipini açık yaz, sabit değerleri `CONST` ile sabitle. Büyük veri taşırken her şeyi tek seferde metne çevirmek yerine tampon [geçici veri alanı] (buffer) ve handle [güvenli kaynak numarası] kullanmayı öğren.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|DIM|DIM ad AS Tip|Yeni değişken, dizi veya nesne başvurusu bildirir.|
|REDIM|REDIM dizi(yeniBoyut)|Diziyi yeni boyuta taşır.|
|AS|ad AS Tip|Bir adın tipini belirtir.|
|CONST|CONST ad AS Tip = değer|Değişmeyen sabit tanımlar.|

#### Tekil komut defteri

##### 55. DIM
**Sözdizimi:** `DIM ad AS Tip`  
**Ne yapar:** Yeni değişken, dizi veya nesne başvurusu bildirir.  
**Nerede ve nasıl kullanılır:** Yeni değişken, dizi veya nesne başvurusu tanımlar.

```uxbasic
DIM toplam AS F64
```

##### 56. REDIM
**Sözdizimi:** `REDIM dizi(yeniBoyut)`  
**Ne yapar:** Diziyi yeni boyuta taşır.  
**Nerede ve nasıl kullanılır:** Dizinin boyutunu yeniden kurar. Veri geldikçe büyüyen liste mantığında kullanılır.

```uxbasic
REDIM olcumler(100)
```

##### 57. AS
**Sözdizimi:** `ad AS Tip`  
**Ne yapar:** Bir adın tipini belirtir.  
**Nerede ve nasıl kullanılır:** Adın tipini açıklar. Okunur ve güvenli kodun anahtarıdır.

```uxbasic
DIM adet AS I32
```

##### 58. CONST
**Sözdizimi:** `CONST ad AS Tip = değer`  
**Ne yapar:** Değişmeyen sabit tanımlar.  
**Nerede ve nasıl kullanılır:** Değişmeyecek değeri sabitler. Sınır değerleri ve ayarları korur.

```uxbasic
CONST PH_ALT AS F64 = 6.5
```

#### Bu sınıfı birlikte kullanma örnekleri

##### Tampon oluşturma, doldurma ve güvenli özet alma

```uxbasic
CONST N AS I32 = 256
DIM tampon(N) AS U8
DIM i AS I32
DIM toplam AS U32
FOR i = 1 TO N
    tampon(i) = i MOD 256
NEXT i
FOR i = 1 TO N
    toplam = toplam + tampon(i)
NEXT i
PRINT "tampon checksum="; toplam
IF toplam = 0 THEN THROW "tampon bos gorunuyor"
```

Tampon, büyük veriyi parça parça taşımak için kullanılır. Burada dizi bir tampon gibi davranır; önce doldurulur, sonra ikinci döngüyle denetlenir.

##### Büyüyen ölçüm dizisi

```uxbasic
DIM olcum(10) AS F64
DIM kapasite AS I32
DIM adet AS I32
kapasite = 10
DO
    INPUT x
    IF x < 0 THEN EXIT DO
    adet = adet + 1
    IF adet > kapasite THEN
        kapasite = kapasite + 10
        REDIM olcum(kapasite)
    END IF
    olcum(adet) = x
LOOP
PRINT "adet="; adet; " kapasite="; kapasite
```

`REDIM` ile dizi büyütülür. İpucu: her ölçümde bir eleman büyütmek pahalı olabilir; kapasiteyi blok blok artırmak daha hızlıdır.

### Modül ve kaynak

Modül ve kaynak komutları büyük projeyi dosyalara ve ad alanlarına böler. `INCLUDE` başlık dosyasını alır, `IMPORT` C/C++/ASM kaynaklarını derleme zincirine ekler, `MODULE` bir iş ailesini toplar, `NAMESPACE` isim çakışmasını önler, `USING` uzun adları kısa kullanmayı sağlar, `ALIAS` okunur kısaltma verir. Bu sınıf dilin büyüme yoludur: yeni komut eklemeden yeni dünya bağlanır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|INCLUDE|INCLUDE "dosya.uxbh"|Başka uXBasic başlık/destek dosyasını kaynak içine katar.|
|IMPORT|IMPORT(C,"dosya.c") \| IMPORT(CPP,"dosya.cpp") \| IMPORT(ASM,"dosya.asm")|Derleme zamanında C, C++ veya ASM kaynak dosyasını projeye bağlar.|
|MAIN|MAIN ... END MAIN|Programın ana giriş bölümünü belirtir.|
|NAMESPACE|NAMESPACE Ad ... END NAMESPACE|Adları çakışmadan ayıran alan açar.|
|MODULE|MODULE Ad ... END MODULE|Bir dosya veya iş ailesini modül olarak toplar.|
|USING|USING MODULE Ad \| USING NAMESPACE Ad|Bir modül/alan adını kısa kullanım için etkinleştirir.|
|ALIAS|ALIAS yeniAd = eskiAd \| ALIAS KISA AS uzunAd|Uzun çağrıya kısa veya yerel ad verir.|
|INLINE|INLINE C ... END INLINE \| INLINE ASM ... END INLINE|uXBasic dosyası içinde küçük C/C++/ASM bölümü taşır.|

#### Tekil komut defteri

##### 59. INCLUDE
**Sözdizimi:** `INCLUDE "dosya.uxbh"`  
**Ne yapar:** Başka uXBasic başlık/destek dosyasını kaynak içine katar.  
**Nerede ve nasıl kullanılır:** Ortak başlık veya yordam dosyasını içeri alır.

```uxbasic
INCLUDE "uxstats.uxmh"
```

##### 60. IMPORT
**Sözdizimi:** `IMPORT(C,"dosya.c") | IMPORT(CPP,"dosya.cpp") | IMPORT(ASM,"dosya.asm")`  
**Ne yapar:** Derleme zamanında C, C++ veya ASM kaynak dosyasını projeye bağlar.  
**Nerede ve nasıl kullanılır:** C, C++ veya ASM kaynak dosyasını derleme zamanında projeye bağlar.

```uxbasic
IMPORT(C, "native/hizli_toplam.c")
```

##### 77. MAIN
**Sözdizimi:** `MAIN ... END MAIN`  
**Ne yapar:** Programın ana giriş bölümünü belirtir.  
**Nerede ve nasıl kullanılır:** Programın giriş bölümünü gösterir.

```uxbasic
MAIN: PRINT "basla": END MAIN
```

##### 78. NAMESPACE
**Sözdizimi:** `NAMESPACE Ad ... END NAMESPACE`  
**Ne yapar:** Adları çakışmadan ayıran alan açar.  
**Nerede ve nasıl kullanılır:** İsim çakışmasını önler; büyük projede düzen sağlar.

```uxbasic
NAMESPACE Lab: SUB Yaz(): PRINT "lab": END SUB: END NAMESPACE
```

##### 79. MODULE
**Sözdizimi:** `MODULE Ad ... END MODULE`  
**Ne yapar:** Bir dosya veya iş ailesini modül olarak toplar.  
**Nerede ve nasıl kullanılır:** Bir iş ailesini tek ad altında toplar.

```uxbasic
MODULE Kalite: CONST SINIR AS F64 = 1.5: END MODULE
```

##### 80. USING
**Sözdizimi:** `USING MODULE Ad | USING NAMESPACE Ad`  
**Ne yapar:** Bir modül/alan adını kısa kullanım için etkinleştirir.  
**Nerede ve nasıl kullanılır:** Modül veya ad alanını kısa kullanıma açar.

```uxbasic
USING MODULE Kalite
```

##### 81. ALIAS
**Sözdizimi:** `ALIAS yeniAd = eskiAd | ALIAS KISA AS uzunAd`  
**Ne yapar:** Uzun çağrıya kısa veya yerel ad verir.  
**Nerede ve nasıl kullanılır:** Uzun adlara kısa ve okunur ad verir.

```uxbasic
ALIAS ORT = uxstats.mean
```

##### 108. INLINE
**Sözdizimi:** `INLINE C ... END INLINE | INLINE ASM ... END INLINE`  
**Ne yapar:** uXBasic dosyası içinde küçük C/C++/ASM bölümü taşır.  
**Nerede ve nasıl kullanılır:** Kısa C/C++/ASM kodunu uXBasic kaynağında tutar.

```uxbasic
INLINE C: int hizli(int a){ return a*a; }: END INLINE
```

#### Bu sınıfı birlikte kullanma örnekleri

##### Modül, ad alanı ve takma adla temiz kütüphane kullanımı

```uxbasic
INCLUDE "uxstats.uxmh"
IMPORT(C, "native/hizli_filtre.c")
NAMESPACE Lab
    MODULE Kalite
        CONST ALT AS F64 = 6.5
        CONST UST AS F64 = 8.5
        FUNCTION Uygun(ph AS F64) AS BOOLEAN
            RETURN ph >= ALT AND ph <= UST
        END FUNCTION
    END MODULE
END NAMESPACE
USING MODULE Lab.Kalite
ALIAS PHOK = Lab.Kalite.Uygun
INPUT ph
IF PHOK(ph) THEN PRINT "uygun" ELSE PRINT "alarm" END IF
```

Burada çekirdeğe yeni komut eklemeden kütüphane yüzeyi kuruluyor. `ALIAS` okunurluk sağlar, `NAMESPACE` çakışmayı önler, `IMPORT` C hızını projeye katar.

##### INLINE ASM ile küçük hız deneyi

```uxbasic
INLINE ASM
; burada hedefe ozel hizli sayac kodu durur
END INLINE
MODULE Zaman
    FUNCTION Simdi() AS F64
        RETURN TIMER()
    END FUNCTION
END MODULE
USING MODULE Zaman
PRINT "basla="; Simdi()
```

Kısa hedefe özel kod `INLINE` içinde tutulabilir; ama genel program `MODULE` ve fonksiyon çağrısıyla temiz kalır.

### Varsayılan tip

Varsayılan tip komutları eski BASIC alışkanlığından gelir. Harfle başlayan değişkenlere tip önermesi yapar. Modern büyük projede her değişkeni açık tipli yazmak daha güvenlidir, ama eski kod taşırken veya hızlı denemede `DEFINT`, `DEFSTR` gibi komutlar işe yarar. Genç programcı bunları bilmeli, fakat yeni kodda açık `DIM ad AS Tip` alışkanlığını bırakmamalıdır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|DEFINT|DEFINT A-Z|harfle başlayan adsız tipleri I32 yapar|
|DEFLNG|DEFLNG A-Z|harfle başlayan adsız tipleri I64 yapar|
|DEFSNG|DEFSNG A-Z|harfle başlayan adsız tipleri F32 yapar|
|DEFDBL|DEFDBL A-Z|harfle başlayan adsız tipleri F64 yapar|
|DEFEXT|DEFEXT A-Z|harfle başlayan adsız tipleri geniş ondalık yapar|
|DEFSTR|DEFSTR A-Z|harfle başlayan adsız tipleri STRING yapar|
|DEFBYT|DEFBYT A-Z|harfle başlayan adsız tipleri BYTE yapar|

#### Tekil komut defteri

##### 82. DEFINT
**Sözdizimi:** `DEFINT A-Z`  
**Ne yapar:** harfle başlayan adsız tipleri I32 yapar  
**Nerede ve nasıl kullanılır:** `DEFINT` eski BASIC tarzı varsayılan tip davranışı verir. harfle başlayan adsız tipleri I32 yapar Yeni kodda açık `DIM ... AS ...` tercih edilse de uyumlulukta işe yarar.

```uxbasic
DEFINT A-Z
```

##### 83. DEFLNG
**Sözdizimi:** `DEFLNG A-Z`  
**Ne yapar:** harfle başlayan adsız tipleri I64 yapar  
**Nerede ve nasıl kullanılır:** `DEFLNG` eski BASIC tarzı varsayılan tip davranışı verir. harfle başlayan adsız tipleri I64 yapar Yeni kodda açık `DIM ... AS ...` tercih edilse de uyumlulukta işe yarar.

```uxbasic
DEFLNG A-Z
```

##### 84. DEFSNG
**Sözdizimi:** `DEFSNG A-Z`  
**Ne yapar:** harfle başlayan adsız tipleri F32 yapar  
**Nerede ve nasıl kullanılır:** `DEFSNG` eski BASIC tarzı varsayılan tip davranışı verir. harfle başlayan adsız tipleri F32 yapar Yeni kodda açık `DIM ... AS ...` tercih edilse de uyumlulukta işe yarar.

```uxbasic
DEFSNG A-Z
```

##### 85. DEFDBL
**Sözdizimi:** `DEFDBL A-Z`  
**Ne yapar:** harfle başlayan adsız tipleri F64 yapar  
**Nerede ve nasıl kullanılır:** `DEFDBL` eski BASIC tarzı varsayılan tip davranışı verir. harfle başlayan adsız tipleri F64 yapar Yeni kodda açık `DIM ... AS ...` tercih edilse de uyumlulukta işe yarar.

```uxbasic
DEFDBL A-Z
```

##### 86. DEFEXT
**Sözdizimi:** `DEFEXT A-Z`  
**Ne yapar:** harfle başlayan adsız tipleri geniş ondalık yapar  
**Nerede ve nasıl kullanılır:** `DEFEXT` eski BASIC tarzı varsayılan tip davranışı verir. harfle başlayan adsız tipleri geniş ondalık yapar Yeni kodda açık `DIM ... AS ...` tercih edilse de uyumlulukta işe yarar.

```uxbasic
DEFEXT A-Z
```

##### 87. DEFSTR
**Sözdizimi:** `DEFSTR A-Z`  
**Ne yapar:** harfle başlayan adsız tipleri STRING yapar  
**Nerede ve nasıl kullanılır:** `DEFSTR` eski BASIC tarzı varsayılan tip davranışı verir. harfle başlayan adsız tipleri STRING yapar Yeni kodda açık `DIM ... AS ...` tercih edilse de uyumlulukta işe yarar.

```uxbasic
DEFSTR A-Z
```

##### 88. DEFBYT
**Sözdizimi:** `DEFBYT A-Z`  
**Ne yapar:** harfle başlayan adsız tipleri BYTE yapar  
**Nerede ve nasıl kullanılır:** `DEFBYT` eski BASIC tarzı varsayılan tip davranışı verir. harfle başlayan adsız tipleri BYTE yapar Yeni kodda açık `DIM ... AS ...` tercih edilse de uyumlulukta işe yarar.

```uxbasic
DEFBYT A-Z
```

#### Bu sınıfı birlikte kullanma örnekleri

##### Eski BASIC kodunu açık tipe taşıma

```uxbasic
DEFINT A-Z
adet = 10
toplam = 0
FOR i = 1 TO adet
    toplam = toplam + i
NEXT i
PRINT toplam
' Yeni yazımda tercih edilen açık biçim:
DIM adet2 AS I32
DIM toplam2 AS I32
adet2 = 10
```

Varsayılan tip eski kaynakları taşımayı kolaylaştırır. Fakat kitap genç programcıya açık tip yazmayı önerir; çünkü açık tip hata mesajını ve kütüphane çağrısını güçlendirir.

### Girdi çıktı ve ekran

Girdi, çıktı, ekran ve dosya komutları programı kullanıcıya ve dosyaya bağlar. `PRINT` sonucu gösterir, `INPUT` veri alır, `OPEN` dosya açar, `CLOSE` kapatır, `GET` ve `PUT` ham veriyi taşır, `SEEK` dosya konumunu değiştirir. Konsol programı, günlük dosyası, kalite raporu, CSV okuma ve binary kayıt bu sınıfla kurulur. Kural: açtığın her kaynağı kapat, yazdığın her dosyanın gerçekten oluştuğunu kontrol et.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|PRINT|PRINT ifade[, ifade] \| PRINT #dosya, ifade|Ekrana veya dosyaya metin/sayı yazar.|
|INPUT|INPUT değişken \| INPUT #dosya, değişken|Kullanıcıdan veya dosyadan veri okur.|
|OPEN|OPEN "dosya" FOR INPUT\|OUTPUT\|APPEND AS #no|Dosyayı okuma/yazma/ekleme için açar.|
|CLOSE|CLOSE #no|Açık dosyayı kapatır.|
|GET|GET #no, konum, değişken|Dosyadan ham veri okur.|
|PUT|PUT #no, konum, değişken|Dosyaya ham veri yazar.|
|SEEK|SEEK #no, konum|Dosya okuma/yazma konumunu değiştirir.|
|CLS|CLS|Ekranı temizler.|
|COLOR|COLOR ön[, arka]|Yazı/arka plan rengini ayarlar.|
|LOCATE|LOCATE satır, sütun|Ekran imlecini konuma taşır.|

#### Tekil komut defteri

##### 89. PRINT
**Sözdizimi:** `PRINT ifade[, ifade] | PRINT #dosya, ifade`  
**Ne yapar:** Ekrana veya dosyaya metin/sayı yazar.  
**Nerede ve nasıl kullanılır:** Ekrana veya dosyaya değer yazar.

```uxbasic
PRINT "sonuc="; sonuc
```

##### 90. INPUT
**Sözdizimi:** `INPUT değişken | INPUT #dosya, değişken`  
**Ne yapar:** Kullanıcıdan veya dosyadan veri okur.  
**Nerede ve nasıl kullanılır:** Kullanıcıdan veya dosyadan veri okur.

```uxbasic
INPUT ph
```

##### 91. OPEN
**Sözdizimi:** `OPEN "dosya" FOR INPUT|OUTPUT|APPEND AS #no`  
**Ne yapar:** Dosyayı okuma/yazma/ekleme için açar.  
**Nerede ve nasıl kullanılır:** Dosya bağlantısı açar.

```uxbasic
OPEN "rapor.txt" FOR OUTPUT AS #1
```

##### 92. CLOSE
**Sözdizimi:** `CLOSE #no`  
**Ne yapar:** Açık dosyayı kapatır.  
**Nerede ve nasıl kullanılır:** Açık dosyayı kapatır.

```uxbasic
CLOSE #1
```

##### 93. GET
**Sözdizimi:** `GET #no, konum, değişken`  
**Ne yapar:** Dosyadan ham veri okur.  
**Nerede ve nasıl kullanılır:** Ham veriyi dosyadan okur.

```uxbasic
GET #1, 1, kayit
```

##### 94. PUT
**Sözdizimi:** `PUT #no, konum, değişken`  
**Ne yapar:** Dosyaya ham veri yazar.  
**Nerede ve nasıl kullanılır:** Ham veriyi dosyaya yazar.

```uxbasic
PUT #1, 1, kayit
```

##### 95. SEEK
**Sözdizimi:** `SEEK #no, konum`  
**Ne yapar:** Dosya okuma/yazma konumunu değiştirir.  
**Nerede ve nasıl kullanılır:** Dosya konumunu değiştirir.

```uxbasic
SEEK #1, 128
```

##### 96. CLS
**Sözdizimi:** `CLS`  
**Ne yapar:** Ekranı temizler.  
**Nerede ve nasıl kullanılır:** Ekranı temizler.

```uxbasic
CLS
```

##### 97. COLOR
**Sözdizimi:** `COLOR ön[, arka]`  
**Ne yapar:** Yazı/arka plan rengini ayarlar.  
**Nerede ve nasıl kullanılır:** Yazı veya arka plan rengini değiştirir.

```uxbasic
COLOR 15, 1
```

##### 98. LOCATE
**Sözdizimi:** `LOCATE satır, sütun`  
**Ne yapar:** Ekran imlecini konuma taşır.  
**Nerede ve nasıl kullanılır:** İmleci belirli satır/sütuna taşır.

```uxbasic
LOCATE 10, 5: PRINT "Hazir"
```

#### Bu sınıfı birlikte kullanma örnekleri

##### CSV raporu okuyup kalite sonucu yazma

```uxbasic
OPEN "kalite.csv" FOR INPUT AS #1
OPEN "sonuc.txt" FOR OUTPUT AS #2
DIM satir AS STRING
DIM deger AS F64
DIM sira AS I32
DO WHILE EOF(#1)=0
    INPUT #1, satir
    sira = sira + 1
    deger = VAL(satir)
    IF deger < 98.5 OR deger > 101.5 THEN
        PRINT #2, "satir="; sira; ";hata="; deger
    ELSE
        PRINT #2, "satir="; sira; ";ok="; deger
    END IF
LOOP
CLOSE #1
CLOSE #2
PRINT "rapor yazildi"
```

Dosya okuma/yazma örneği gerçek iş yapar: veri alır, sınıflandırır, başka dosyaya raporlar. `CLOSE` unutulmazsa dosya bozulma riski azalır.

##### Konsol ekranında küçük durum paneli

```uxbasic
CLS
COLOR 15, 1
LOCATE 1, 1: PRINT "uXBasic saha paneli"
COLOR 10, 0
FOR i = 1 TO 5
    LOCATE i+2, 3
    PRINT "sensor "; i; " aktif"
NEXT i
COLOR 7, 0
```

Ekran komutları küçük görünür ama kullanıcı deneyimi sağlar. `LOCATE` ile düzenli panel, `COLOR` ile durum vurgusu yapılır.

### İşleç

İşleçler değerleri birleştirir, karşılaştırır ve bit düzeyinde işler. Mantık işleçleri kararları temiz kurar; bit kaydırma işleçleri bayrak, renk, izin ve donanım değerlerinde işe yarar. `MOD` döngüsel işleri, kalan hesaplarını ve sınıflandırmayı kolaylaştırır. Genç programcı için ipucu: çok uzun `IF` zinciri yerine bazen bit bayrağı, `DICT` veya tablo kullanmak daha akıllıdır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|AND|a AND b|iki koşul/bit birlikte doğruysa doğru verir|
|OR|a OR b|koşullardan biri doğruysa doğru verir|
|NOT|NOT koşul|koşulu tersine çevirir|
|XOR|a XOR b|yalnız biri doğruysa doğru verir veya bitlerde özel fark alır|
|MOD|a MOD b|bölme kalanı verir|
|SHL|a SHL b|bitleri sola kaydırır|
|SHR|a SHR b|bitleri sağa kaydırır|
|ROL|a ROL b|bitleri döndürerek sola kaydırır|
|ROR|a ROR b|bitleri döndürerek sağa kaydırır|

#### Tekil komut defteri

##### 99. AND
**Sözdizimi:** `a AND b`  
**Ne yapar:** iki koşul/bit birlikte doğruysa doğru verir  
**Nerede ve nasıl kullanılır:** İki koşulun birlikte doğru olmasını ister; bit düzeyinde maskelemede de kullanılır.

```uxbasic
IF ph >= 6.5 AND ph <= 8.5 THEN PRINT "uygun"
```

##### 100. OR
**Sözdizimi:** `a OR b`  
**Ne yapar:** koşullardan biri doğruysa doğru verir  
**Nerede ve nasıl kullanılır:** Koşullardan birinin doğru olmasını yeterli sayar; bit bayrağı eklemek için de kullanılır.

```uxbasic
IF durum = "ACIL" OR stok = 0 THEN PRINT "uyari"
```

##### 101. NOT
**Sözdizimi:** `NOT koşul`  
**Ne yapar:** koşulu tersine çevirir  
**Nerede ve nasıl kullanılır:** Koşulu tersine çevirir.

```uxbasic
IF NOT bulundu THEN PRINT "kayit yok"
```

##### 102. XOR
**Sözdizimi:** `a XOR b`  
**Ne yapar:** yalnız biri doğruysa doğru verir veya bitlerde özel fark alır  
**Nerede ve nasıl kullanılır:** İki durumdan yalnız biri doğruysa doğru verir; bit farkı için kullanılır.

```uxbasic
mask = eski XOR yeni
```

##### 103. MOD
**Sözdizimi:** `a MOD b`  
**Ne yapar:** bölme kalanı verir  
**Nerede ve nasıl kullanılır:** Bölme kalanını verir; periyodik işlerde çok değerlidir.

```uxbasic
IF i MOD 2 = 0 THEN PRINT "cift"
```

##### 104. SHL
**Sözdizimi:** `a SHL b`  
**Ne yapar:** bitleri sola kaydırır  
**Nerede ve nasıl kullanılır:** Bitleri sola kaydırır; ikinin kuvvetleriyle çarpma ve bayrak üretmede kullanılır.

```uxbasic
bayrak = 1 SHL 3
```

##### 105. SHR
**Sözdizimi:** `a SHR b`  
**Ne yapar:** bitleri sağa kaydırır  
**Nerede ve nasıl kullanılır:** Bitleri sağa kaydırır; hızlı bölme ve bayrak ayıklamada kullanılır.

```uxbasic
kanal = renk SHR 8
```

##### 106. ROL
**Sözdizimi:** `a ROL b`  
**Ne yapar:** bitleri döndürerek sola kaydırır  
**Nerede ve nasıl kullanılır:** Bitleri döndürerek sola alır; düşük seviye kripto/grafik oyunlarında kullanılır.

```uxbasic
desen = desen ROL 1
```

##### 107. ROR
**Sözdizimi:** `a ROR b`  
**Ne yapar:** bitleri döndürerek sağa kaydırır  
**Nerede ve nasıl kullanılır:** Bitleri döndürerek sağa alır; bayt desen döndürme işlerinde kullanılır.

```uxbasic
desen = desen ROR 1
```

#### Bu sınıfı birlikte kullanma örnekleri

##### DICT yerine küçük bit bayrağıyla hızlı durum

```uxbasic
CONST BAYRAK_OK AS U32 = 1 SHL 0
CONST BAYRAK_ALARM AS U32 = 1 SHL 1
CONST BAYRAK_KAYIT AS U32 = 1 SHL 2
DIM durum AS U32
IF ph >= 6.5 AND ph <= 8.5 THEN durum = durum OR BAYRAK_OK ELSE durum = durum OR BAYRAK_ALARM
IF kayitAcik THEN durum = durum OR BAYRAK_KAYIT
IF (durum AND BAYRAK_ALARM) <> 0 THEN PRINT "alarm var"
```

Bit bayrağı tek sayıda birçok doğru/yanlış bilgisi tutar. Sistem programlama ve hızlı durum takibi için zekice bir çözümdür.

##### MOD ile iş bölme ve numune seçme

```uxbasic
FOR i = 1 TO 100
    IF i MOD 10 = 0 THEN PRINT "her 10. numune kontrol="; i
    IF i MOD 2 = 0 THEN PRINT "cift hat" ELSE PRINT "tek hat"
NEXT i
```

`MOD` sayesinde ayrı sayaç tutmadan periyodik iş yapılır. Her 10. ölçümü ayırmak, haftalık gün hesaplamak ve satır renklendirmek için kullanılır.

### Tipler

Tipler değişkenin hangi değerleri tutacağını ve bellekte nasıl davranacağını söyler. Küçük tam sayılar, büyük tam sayılar, kayan nokta, metin, nesne, işaretçi, liste, sözlük, küme ve büyük sayı tipleri farklı görevler içindir. Tip seçimi performans, güvenlik ve doğru sonuç için önemlidir. Laboratuvar ölçümü `F64`, para hesabı `BIGD`, çok büyük sayaç `BIGINT`, tekrarsız örnek kimlikleri `SET`, açıklamalı kayıtlar `DICT` ile daha doğru modellenir.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|BYTE|DIM ad AS BYTE|tek baytlık ham veri tutar.|
|I8|DIM ad AS I8|-128 ile 127 arasında işaretli 8 bit tam sayı tutar.|
|U8|DIM ad AS U8|0 ile 255 arasında işaretsiz 8 bit tam sayı tutar.|
|I16|DIM ad AS I16|işaretli 16 bit tam sayı tutar.|
|U16|DIM ad AS U16|işaretsiz 16 bit tam sayı tutar.|
|I32|DIM ad AS I32|günlük sayaç ve indeksler için 32 bit tam sayı tutar.|
|U32|DIM ad AS U32|negatif olmayan 32 bit sayı tutar.|
|I64|DIM ad AS I64|büyük sayaç ve dosya boyutu için 64 bit tam sayı tutar.|
|U64|DIM ad AS U64|çok büyük pozitif sayaçlar için 64 bit sayı tutar.|
|F32|DIM ad AS F32|tek duyarlıklı ondalıklı sayı tutar.|
|F64|DIM ad AS F64|çift duyarlıklı ondalıklı sayı tutar.|
|F80|DIM ad AS F80|genişletilmiş kayan nokta sayı tutar.|
|F128|DIM ad AS F128|128 bit yüksek duyarlıklı sayı tutar.|
|BIGF|DIM ad AS BIGF|çok büyük/yüksek duyarlıklı ikili kayan sayı ailesidir.|
|BIGD|DIM ad AS BIGD|çok basamaklı ondalık sayı ailesidir.|
|BALL|DIM ad AS BALL|aralık/top mantığıyla güvenli yaklaşık sayı tutar.|
|BOOLEAN|DIM ad AS BOOLEAN|TRUE/FALSE doğru-yanlış değeri tutar.|
|STRING|DIM ad AS STRING|metin tutar.|
|OBJECT|DIM ad AS OBJECT|nesne başvurusu tutar.|
|PTR|DIM ad AS PTR|ham adres veya dış kütüphane işaretçisi tutar.|
|STRPTR|DIM ad AS STRPTR|metnin bellek adresini dış çağrıya verir.|
|ARRAY|DIM ad AS ARRAY|sabit veya yeniden boyutlanabilir dizi tutar.|
|LIST|DIM ad AS LIST|sıralı, büyüyebilen liste tutar.|
|DICT|DIM ad AS DICT|anahtar/değer sözlüğü tutar.|
|SET|DIM ad AS SET|tekrarsız küme tutar.|

#### Tekil komut defteri

##### 23. BYTE
**Sözdizimi:** `DIM ad AS BYTE`  
**Ne yapar:** tek baytlık ham veri tutar.  
**Nerede ve nasıl kullanılır:** `BYTE` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. tek baytlık ham veri tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM ham AS BYTE
```

##### 109. I8
**Sözdizimi:** `DIM ad AS I8`  
**Ne yapar:** -128 ile 127 arasında işaretli 8 bit tam sayı tutar.  
**Nerede ve nasıl kullanılır:** `I8` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. -128 ile 127 arasında işaretli 8 bit tam sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM sicaklikFarki AS I8
```

##### 110. U8
**Sözdizimi:** `DIM ad AS U8`  
**Ne yapar:** 0 ile 255 arasında işaretsiz 8 bit tam sayı tutar.  
**Nerede ve nasıl kullanılır:** `U8` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. 0 ile 255 arasında işaretsiz 8 bit tam sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM renk AS U8
```

##### 111. I16
**Sözdizimi:** `DIM ad AS I16`  
**Ne yapar:** işaretli 16 bit tam sayı tutar.  
**Nerede ve nasıl kullanılır:** `I16` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. işaretli 16 bit tam sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM kisaSayac AS I16
```

##### 112. U16
**Sözdizimi:** `DIM ad AS U16`  
**Ne yapar:** işaretsiz 16 bit tam sayı tutar.  
**Nerede ve nasıl kullanılır:** `U16` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. işaretsiz 16 bit tam sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM port AS U16
```

##### 113. I32
**Sözdizimi:** `DIM ad AS I32`  
**Ne yapar:** günlük sayaç ve indeksler için 32 bit tam sayı tutar.  
**Nerede ve nasıl kullanılır:** `I32` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. günlük sayaç ve indeksler için 32 bit tam sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM adet AS I32
```

##### 114. U32
**Sözdizimi:** `DIM ad AS U32`  
**Ne yapar:** negatif olmayan 32 bit sayı tutar.  
**Nerede ve nasıl kullanılır:** `U32` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. negatif olmayan 32 bit sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM dosyaCrc AS U32
```

##### 115. I64
**Sözdizimi:** `DIM ad AS I64`  
**Ne yapar:** büyük sayaç ve dosya boyutu için 64 bit tam sayı tutar.  
**Nerede ve nasıl kullanılır:** `I64` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. büyük sayaç ve dosya boyutu için 64 bit tam sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM buyukSayac AS I64
```

##### 116. U64
**Sözdizimi:** `DIM ad AS U64`  
**Ne yapar:** çok büyük pozitif sayaçlar için 64 bit sayı tutar.  
**Nerede ve nasıl kullanılır:** `U64` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. çok büyük pozitif sayaçlar için 64 bit sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM boyut AS U64
```

##### 117. F32
**Sözdizimi:** `DIM ad AS F32`  
**Ne yapar:** tek duyarlıklı ondalıklı sayı tutar.  
**Nerede ve nasıl kullanılır:** `F32` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. tek duyarlıklı ondalıklı sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM hizliOndalik AS F32
```

##### 118. F64
**Sözdizimi:** `DIM ad AS F64`  
**Ne yapar:** çift duyarlıklı ondalıklı sayı tutar.  
**Nerede ve nasıl kullanılır:** `F64` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. çift duyarlıklı ondalıklı sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM ortalama AS F64
```

##### 119. F80
**Sözdizimi:** `DIM ad AS F80`  
**Ne yapar:** genişletilmiş kayan nokta sayı tutar.  
**Nerede ve nasıl kullanılır:** `F80` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. genişletilmiş kayan nokta sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM hassas AS F80
```

##### 120. F128
**Sözdizimi:** `DIM ad AS F128`  
**Ne yapar:** 128 bit yüksek duyarlıklı sayı tutar.  
**Nerede ve nasıl kullanılır:** `F128` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. 128 bit yüksek duyarlıklı sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM cokHassas AS F128
```

##### 121. BIGF
**Sözdizimi:** `DIM ad AS BIGF`  
**Ne yapar:** çok büyük/yüksek duyarlıklı ikili kayan sayı ailesidir.  
**Nerede ve nasıl kullanılır:** `BIGF` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. çok büyük/yüksek duyarlıklı ikili kayan sayı ailesidir. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM x AS BIGF
```

##### 122. BIGD
**Sözdizimi:** `DIM ad AS BIGD`  
**Ne yapar:** çok basamaklı ondalık sayı ailesidir.  
**Nerede ve nasıl kullanılır:** `BIGD` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. çok basamaklı ondalık sayı ailesidir. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM para AS BIGD
```

##### 123. BALL
**Sözdizimi:** `DIM ad AS BALL`  
**Ne yapar:** aralık/top mantığıyla güvenli yaklaşık sayı tutar.  
**Nerede ve nasıl kullanılır:** `BALL` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. aralık/top mantığıyla güvenli yaklaşık sayı tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM sonuc AS BALL
```

##### 124. BOOLEAN
**Sözdizimi:** `DIM ad AS BOOLEAN`  
**Ne yapar:** TRUE/FALSE doğru-yanlış değeri tutar.  
**Nerede ve nasıl kullanılır:** `BOOLEAN` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. TRUE/FALSE doğru-yanlış değeri tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM uygun AS BOOLEAN
```

##### 125. STRING
**Sözdizimi:** `DIM ad AS STRING`  
**Ne yapar:** metin tutar.  
**Nerede ve nasıl kullanılır:** `STRING` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. metin tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM ad AS STRING
```

##### 126. OBJECT
**Sözdizimi:** `DIM ad AS OBJECT`  
**Ne yapar:** nesne başvurusu tutar.  
**Nerede ve nasıl kullanılır:** `OBJECT` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. nesne başvurusu tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM nesne AS OBJECT
```

##### 127. PTR
**Sözdizimi:** `DIM ad AS PTR`  
**Ne yapar:** ham adres veya dış kütüphane işaretçisi tutar.  
**Nerede ve nasıl kullanılır:** `PTR` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. ham adres veya dış kütüphane işaretçisi tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM p AS PTR
```

##### 128. STRPTR
**Sözdizimi:** `DIM ad AS STRPTR`  
**Ne yapar:** metnin bellek adresini dış çağrıya verir.  
**Nerede ve nasıl kullanılır:** `STRPTR` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. metnin bellek adresini dış çağrıya verir. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
adres = STRPTR(metin)
```

##### 133. ARRAY
**Sözdizimi:** `DIM ad AS ARRAY`  
**Ne yapar:** sabit veya yeniden boyutlanabilir dizi tutar.  
**Nerede ve nasıl kullanılır:** `ARRAY` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. sabit veya yeniden boyutlanabilir dizi tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM matris(10,10) AS F64
```

##### 134. LIST
**Sözdizimi:** `DIM ad AS LIST`  
**Ne yapar:** sıralı, büyüyebilen liste tutar.  
**Nerede ve nasıl kullanılır:** `LIST` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. sıralı, büyüyebilen liste tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM satirlar AS LIST
```

##### 135. DICT
**Sözdizimi:** `DIM ad AS DICT`  
**Ne yapar:** anahtar/değer sözlüğü tutar.  
**Nerede ve nasıl kullanılır:** `DICT` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. anahtar/değer sözlüğü tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM ayarlar AS DICT
```

##### 136. SET
**Sözdizimi:** `DIM ad AS SET`  
**Ne yapar:** tekrarsız küme tutar.  
**Nerede ve nasıl kullanılır:** `SET` tipi, verinin bellekte hangi sınır ve biçimde tutulacağını belirler. tekrarsız küme tutar. Tip seçimini verinin büyüklüğüne, işaretli olup olmamasına ve hassasiyet ihtiyacına göre yap.

```uxbasic
DIM benzersizKodlar AS SET
```

#### Bu sınıfı birlikte kullanma örnekleri

##### LIST, DICT ve SET ile IF zincirini tabloya çevirme

```uxbasic
DIM komutlar AS DICT
DIM siralama AS LIST
DIM gorulen AS SET
komutlar("lex") = "tokens.json uret"
komutlar("ast") = "ast.json uret"
komutlar("mir") = "mir.json uret"
siralama.APPEND("lex")
siralama.APPEND("ast")
siralama.APPEND("mir")
FOR EACH k IN siralama
    gorulen.ADD(k)
    PRINT k; " -> "; komutlar(k)
NEXT k
IF gorulen.CONTAINS("mir") THEN PRINT "derleyici ara temsil uretecek"
```

Yüz satırlık `IF komut='...'` zinciri yerine `DICT` ile komut tablosu kurulur. `LIST` sıra tutar, `SET` tekrarsız kontrol yapar.

##### 2, 3, 4 ve 5 boyutlu dizi fikri

```uxbasic
DIM matris2(4,4) AS F64
DIM hacim3(10,10,5) AS F32
DIM deney4(3,4,5,6) AS F64
DIM model5(2,3,4,5,6) AS F32
matris2(1,1)=1.0
hacim3(2,3,1)=7.2
deney4(1,2,3,4)=12.5
model5(1,1,1,1,1)=0.75
PRINT matris2(1,1); hacim3(2,3,1); deney4(1,2,3,4); model5(1,1,1,1,1)
```

Çok boyutlu dizi; tablo, hacim, deney düzeni ve model ağırlığı için kullanılır. Her boyutun gerçek anlamını not etmezsen kod anlaşılmaz olur.

##### Büyük sayı ailesi ile güvenli hesap niyeti

```uxbasic
DIM adet AS BIGINT
DIM para AS BIGD
DIM hassas AS BIGF
DIM aralik AS BALL
adet = BIGINT("123456789012345678901234567890")
para = BIGD("19.99") * BIGD("1234567")
hassas = BIGF("3.1415926535897932384626")
aralik = BALL("0.3333333333", "0.3333333334")
PRINT adet
PRINT para
PRINT hassas
PRINT aralik
```

`BIGINT` çok büyük tam sayı, `BIGD` parasal/ondalık hesap, `BIGF` yüksek hassas ikili hesap, `BALL` aralıkla güvenli yaklaşık hesap için düşünülür.

### Yerel fonksiyon

Yerel fonksiyonlar dilin küçük alet kutusudur. Metin temizleme, sayı dönüştürme, matematik, dosya uzunluğu, zaman, tuş okuma ve adres alma işleri bu aileye girer. Bir fonksiyon tek başına küçük görünür, fakat doğru yerde kullanıldığında veri temizleme, istatistik, rapor ve dış çağrı güvenliği kurar. Genç programcı bunları ezberlemek yerine görevlerine göre gruplamalıdır: metin, sayı, matematik, dosya, zaman, bellek.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|SETSTRINGSIZE|sonuc = SETSTRINGSIZE metin, uzunluk|Metin değişkeni için istenen uzunlukta alan hazırlar.|
|TIMER|sonuc = TIMER()|Geçen zamanı saniye türünden verir.|
|LOF|sonuc = LOF(#no)|Açık dosyanın uzunluğunu verir.|
|EOF|sonuc = EOF(#no)|Dosya sonuna gelinip gelinmediğini söyler.|
|LEN|sonuc = LEN(metin)|Metnin veya verinin uzunluğunu verir.|
|MID|sonuc = MID(metin, başla, uzunluk)|Metnin içinden parça alır.|
|STR|sonuc = STR(sayi)|Sayıyı metne çevirir.|
|VAL|sonuc = VAL(metin)|Metni sayıya çevirir.|
|ABS|sonuc = ABS(x)|Mutlak değer alır.|
|INT|sonuc = INT(x)|Ondalıklı sayının tam kısmını alır.|
|UCASE|sonuc = UCASE(metin)|Metni büyük harfe çevirir.|
|LCASE|sonuc = LCASE(metin)|Metni küçük harfe çevirir.|
|ASC|sonuc = ASC(karakter)|Karakterin sayı kodunu verir.|
|CHR|sonuc = CHR(kod)|Sayı kodundan karakter üretir.|
|LTRIM|sonuc = LTRIM(metin)|Sol boşlukları temizler.|
|RTRIM|sonuc = RTRIM(metin)|Sağ boşlukları temizler.|
|SPACE|sonuc = SPACE(n)|Belirli sayıda boşluk üretir.|
|SGN|sonuc = SGN(x)|Sayının işaretini verir.|
|SQRT|sonuc = SQRT(x)|Karekök hesaplar.|
|SIN|sonuc = SIN(x)|Sinüs hesaplar.|
|COS|sonuc = COS(x)|Kosinüs hesaplar.|
|TAN|sonuc = TAN(x)|Tanjant hesaplar.|
|ATN|sonuc = ATN(x)|Arktanjant hesaplar.|
|EXP|sonuc = EXP(x)|e üzeri x hesaplar.|
|LOG|sonuc = LOG(x)|Doğal logaritma hesaplar.|
|INKEY|sonuc = INKEY()|Basılmış tuşu beklemeden okur.|
|GETKEY|sonuc = GETKEY()|Tuş bekler ve okur.|
|VARPTR|sonuc = VARPTR(degisken)|Değişkenin bellek adresini verir.|
|SADD|sonuc = SADD(metin)|Metin içeriğinin adresini verir.|
|LPTR|sonuc = LPTR(degisken)|Uzun adres/işaretçi değeri verir.|
|CODEPTR|sonuc = CODEPTR(yordam)|Yordamın kod adresini verir.|
|SIZEOF|sonuc = SIZEOF(Tip\|degisken)|Tip veya değişken boyutunu bayt olarak verir.|
|OFFSETOF|sonuc = OFFSETOF(Tip, alan)|Kayıt içindeki alanın başlangıç uzaklığını verir.|
|CINT|sonuc = CINT(x)|Değeri tam sayıya çevirir.|
|CLNG|sonuc = CLNG(x)|Değeri uzun tam sayıya çevirir.|
|CDBL|sonuc = CDBL(x)|Değeri çift duyarlıklı sayıya çevirir.|
|CSNG|sonuc = CSNG(x)|Değeri tek duyarlıklı sayıya çevirir.|
|FIX|sonuc = FIX(x)|Ondalık kısmı keser.|
|SQR|sonuc = SQR(x)|Karekök için BASIC uyumlu addır.|
|RND|sonuc = RND()|Rastgele sayı üretir.|
|RANDOMIZE|sonuc = RANDOMIZE [tohum]|Rastgele sayı üreticisini tohumlar.|

#### Tekil komut defteri

##### 137. SETSTRINGSIZE
**Sözdizimi:** `sonuc = SETSTRINGSIZE metin, uzunluk`  
**Ne yapar:** Metin değişkeni için istenen uzunlukta alan hazırlar.  
**Nerede ve nasıl kullanılır:** `SETSTRINGSIZE` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Metin değişkeni için istenen uzunlukta alan hazırlar. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
SETSTRINGSIZE tampon, 1024
```

##### 138. TIMER
**Sözdizimi:** `sonuc = TIMER()`  
**Ne yapar:** Geçen zamanı saniye türünden verir.  
**Nerede ve nasıl kullanılır:** `TIMER` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Geçen zamanı saniye türünden verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
basla = TIMER()
```

##### 139. LOF
**Sözdizimi:** `sonuc = LOF(#no)`  
**Ne yapar:** Açık dosyanın uzunluğunu verir.  
**Nerede ve nasıl kullanılır:** `LOF` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Açık dosyanın uzunluğunu verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
uzunluk = LOF(#1)
```

##### 140. EOF
**Sözdizimi:** `sonuc = EOF(#no)`  
**Ne yapar:** Dosya sonuna gelinip gelinmediğini söyler.  
**Nerede ve nasıl kullanılır:** `EOF` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Dosya sonuna gelinip gelinmediğini söyler. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
DO WHILE EOF(#1)=0: INPUT #1, satir: LOOP
```

##### 141. LEN
**Sözdizimi:** `sonuc = LEN(metin)`  
**Ne yapar:** Metnin veya verinin uzunluğunu verir.  
**Nerede ve nasıl kullanılır:** `LEN` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Metnin veya verinin uzunluğunu verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
uzunluk = LEN(ad)
```

##### 142. MID
**Sözdizimi:** `sonuc = MID(metin, başla, uzunluk)`  
**Ne yapar:** Metnin içinden parça alır.  
**Nerede ve nasıl kullanılır:** `MID` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Metnin içinden parça alır. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
parca = MID(kod, 1, 3)
```

##### 143. STR
**Sözdizimi:** `sonuc = STR(sayi)`  
**Ne yapar:** Sayıyı metne çevirir.  
**Nerede ve nasıl kullanılır:** `STR` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Sayıyı metne çevirir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
metin = STR(sayi)
```

##### 144. VAL
**Sözdizimi:** `sonuc = VAL(metin)`  
**Ne yapar:** Metni sayıya çevirir.  
**Nerede ve nasıl kullanılır:** `VAL` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Metni sayıya çevirir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
sayi = VAL("12.5")
```

##### 145. ABS
**Sözdizimi:** `sonuc = ABS(x)`  
**Ne yapar:** Mutlak değer alır.  
**Nerede ve nasıl kullanılır:** `ABS` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Mutlak değer alır. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
fark = ABS(hedef - olcum)
```

##### 146. INT
**Sözdizimi:** `sonuc = INT(x)`  
**Ne yapar:** Ondalıklı sayının tam kısmını alır.  
**Nerede ve nasıl kullanılır:** `INT` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Ondalıklı sayının tam kısmını alır. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
tam = INT(12.9)
```

##### 147. UCASE
**Sözdizimi:** `sonuc = UCASE(metin)`  
**Ne yapar:** Metni büyük harfe çevirir.  
**Nerede ve nasıl kullanılır:** `UCASE` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Metni büyük harfe çevirir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
kod = UCASE(kod)
```

##### 148. LCASE
**Sözdizimi:** `sonuc = LCASE(metin)`  
**Ne yapar:** Metni küçük harfe çevirir.  
**Nerede ve nasıl kullanılır:** `LCASE` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Metni küçük harfe çevirir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
mail = LCASE(mail)
```

##### 149. ASC
**Sözdizimi:** `sonuc = ASC(karakter)`  
**Ne yapar:** Karakterin sayı kodunu verir.  
**Nerede ve nasıl kullanılır:** `ASC` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Karakterin sayı kodunu verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
kod = ASC("A")
```

##### 150. CHR
**Sözdizimi:** `sonuc = CHR(kod)`  
**Ne yapar:** Sayı kodundan karakter üretir.  
**Nerede ve nasıl kullanılır:** `CHR` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Sayı kodundan karakter üretir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
harf = CHR(65)
```

##### 151. LTRIM
**Sözdizimi:** `sonuc = LTRIM(metin)`  
**Ne yapar:** Sol boşlukları temizler.  
**Nerede ve nasıl kullanılır:** `LTRIM` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Sol boşlukları temizler. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
temiz = LTRIM(satir)
```

##### 152. RTRIM
**Sözdizimi:** `sonuc = RTRIM(metin)`  
**Ne yapar:** Sağ boşlukları temizler.  
**Nerede ve nasıl kullanılır:** `RTRIM` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Sağ boşlukları temizler. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
temiz = RTRIM(satir)
```

##### 153. SPACE
**Sözdizimi:** `sonuc = SPACE(n)`  
**Ne yapar:** Belirli sayıda boşluk üretir.  
**Nerede ve nasıl kullanılır:** `SPACE` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Belirli sayıda boşluk üretir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
PRINT SPACE(4) + "girinti"
```

##### 154. SGN
**Sözdizimi:** `sonuc = SGN(x)`  
**Ne yapar:** Sayının işaretini verir.  
**Nerede ve nasıl kullanılır:** `SGN` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Sayının işaretini verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
yon = SGN(fark)
```

##### 155. SQRT
**Sözdizimi:** `sonuc = SQRT(x)`  
**Ne yapar:** Karekök hesaplar.  
**Nerede ve nasıl kullanılır:** `SQRT` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Karekök hesaplar. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
sapma = SQRT(varyans)
```

##### 156. SIN
**Sözdizimi:** `sonuc = SIN(x)`  
**Ne yapar:** Sinüs hesaplar.  
**Nerede ve nasıl kullanılır:** `SIN` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Sinüs hesaplar. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
y = SIN(aci)
```

##### 157. COS
**Sözdizimi:** `sonuc = COS(x)`  
**Ne yapar:** Kosinüs hesaplar.  
**Nerede ve nasıl kullanılır:** `COS` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Kosinüs hesaplar. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
x = COS(aci)
```

##### 158. TAN
**Sözdizimi:** `sonuc = TAN(x)`  
**Ne yapar:** Tanjant hesaplar.  
**Nerede ve nasıl kullanılır:** `TAN` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Tanjant hesaplar. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
egim = TAN(aci)
```

##### 159. ATN
**Sözdizimi:** `sonuc = ATN(x)`  
**Ne yapar:** Arktanjant hesaplar.  
**Nerede ve nasıl kullanılır:** `ATN` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Arktanjant hesaplar. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
aci = ATN(y/x)
```

##### 160. EXP
**Sözdizimi:** `sonuc = EXP(x)`  
**Ne yapar:** e üzeri x hesaplar.  
**Nerede ve nasıl kullanılır:** `EXP` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. e üzeri x hesaplar. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
buyume = EXP(k*t)
```

##### 161. LOG
**Sözdizimi:** `sonuc = LOG(x)`  
**Ne yapar:** Doğal logaritma hesaplar.  
**Nerede ve nasıl kullanılır:** `LOG` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Doğal logaritma hesaplar. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
lnx = LOG(x)
```

##### 162. INKEY
**Sözdizimi:** `sonuc = INKEY()`  
**Ne yapar:** Basılmış tuşu beklemeden okur.  
**Nerede ve nasıl kullanılır:** `INKEY` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Basılmış tuşu beklemeden okur. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
tus = INKEY()
```

##### 163. GETKEY
**Sözdizimi:** `sonuc = GETKEY()`  
**Ne yapar:** Tuş bekler ve okur.  
**Nerede ve nasıl kullanılır:** `GETKEY` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Tuş bekler ve okur. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
tus = GETKEY()
```

##### 164. VARPTR
**Sözdizimi:** `sonuc = VARPTR(degisken)`  
**Ne yapar:** Değişkenin bellek adresini verir.  
**Nerede ve nasıl kullanılır:** `VARPTR` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Değişkenin bellek adresini verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
adres = VARPTR(deger)
```

##### 165. SADD
**Sözdizimi:** `sonuc = SADD(metin)`  
**Ne yapar:** Metin içeriğinin adresini verir.  
**Nerede ve nasıl kullanılır:** `SADD` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Metin içeriğinin adresini verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
adres = SADD(metin)
```

##### 166. LPTR
**Sözdizimi:** `sonuc = LPTR(degisken)`  
**Ne yapar:** Uzun adres/işaretçi değeri verir.  
**Nerede ve nasıl kullanılır:** `LPTR` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Uzun adres/işaretçi değeri verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
adres = LPTR(etiket)
```

##### 167. CODEPTR
**Sözdizimi:** `sonuc = CODEPTR(yordam)`  
**Ne yapar:** Yordamın kod adresini verir.  
**Nerede ve nasıl kullanılır:** `CODEPTR` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Yordamın kod adresini verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
adres = CODEPTR(Hesapla)
```

##### 168. SIZEOF
**Sözdizimi:** `sonuc = SIZEOF(Tip|degisken)`  
**Ne yapar:** Tip veya değişken boyutunu bayt olarak verir.  
**Nerede ve nasıl kullanılır:** `SIZEOF` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Tip veya değişken boyutunu bayt olarak verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
bayt = SIZEOF(Olcum)
```

##### 169. OFFSETOF
**Sözdizimi:** `sonuc = OFFSETOF(Tip, alan)`  
**Ne yapar:** Kayıt içindeki alanın başlangıç uzaklığını verir.  
**Nerede ve nasıl kullanılır:** `OFFSETOF` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Kayıt içindeki alanın başlangıç uzaklığını verir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
yer = OFFSETOF(Olcum, ph)
```

##### 170. CINT
**Sözdizimi:** `sonuc = CINT(x)`  
**Ne yapar:** Değeri tam sayıya çevirir.  
**Nerede ve nasıl kullanılır:** `CINT` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Değeri tam sayıya çevirir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
n = CINT(12.6)
```

##### 171. CLNG
**Sözdizimi:** `sonuc = CLNG(x)`  
**Ne yapar:** Değeri uzun tam sayıya çevirir.  
**Nerede ve nasıl kullanılır:** `CLNG` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Değeri uzun tam sayıya çevirir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
n = CLNG(123456)
```

##### 172. CDBL
**Sözdizimi:** `sonuc = CDBL(x)`  
**Ne yapar:** Değeri çift duyarlıklı sayıya çevirir.  
**Nerede ve nasıl kullanılır:** `CDBL` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Değeri çift duyarlıklı sayıya çevirir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
x = CDBL("12.7")
```

##### 173. CSNG
**Sözdizimi:** `sonuc = CSNG(x)`  
**Ne yapar:** Değeri tek duyarlıklı sayıya çevirir.  
**Nerede ve nasıl kullanılır:** `CSNG` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Değeri tek duyarlıklı sayıya çevirir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
x = CSNG(12.7)
```

##### 174. FIX
**Sözdizimi:** `sonuc = FIX(x)`  
**Ne yapar:** Ondalık kısmı keser.  
**Nerede ve nasıl kullanılır:** `FIX` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Ondalık kısmı keser. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
n = FIX(-12.8)
```

##### 175. SQR
**Sözdizimi:** `sonuc = SQR(x)`  
**Ne yapar:** Karekök için BASIC uyumlu addır.  
**Nerede ve nasıl kullanılır:** `SQR` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Karekök için BASIC uyumlu addır. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
k = SQR(81)
```

##### 176. RND
**Sözdizimi:** `sonuc = RND()`  
**Ne yapar:** Rastgele sayı üretir.  
**Nerede ve nasıl kullanılır:** `RND` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Rastgele sayı üretir. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
x = RND()
```

##### 177. RANDOMIZE
**Sözdizimi:** `sonuc = RANDOMIZE [tohum]`  
**Ne yapar:** Rastgele sayı üreticisini tohumlar.  
**Nerede ve nasıl kullanılır:** `RANDOMIZE` yerel fonksiyonu, küçük ama sık kullanılan bir dönüşüm/hesap aracıdır. Rastgele sayı üreticisini tohumlar. Veri hazırlama, rapor yazma veya denetim sırasında tek satırda sonuç üretmek için kullanılır.

```uxbasic
RANDOMIZE TIMER()
```

#### Bu sınıfı birlikte kullanma örnekleri

##### Metin temizleme ve sayıya çevirme hattı

```uxbasic
DIM satir AS STRING
DIM kod AS STRING
DIM deger AS F64
satir = "  ph=7.42  "
satir = LTRIM(RTRIM(satir))
kod = UCASE(MID(satir, 1, 2))
deger = VAL(MID(satir, 4, LEN(satir)-3))
IF kod = "PH" THEN PRINT "ph="; deger ELSE PRINT "bilinmeyen satir"
```

Veri çoğu zaman kirli gelir. `LTRIM`, `RTRIM`, `MID`, `LEN`, `UCASE`, `VAL` birlikte küçük bir veri temizleme borusu kurar.

##### Ortalama, varyans ve sapma

```uxbasic
DIM x(5) AS F64
DIM toplam AS F64
DIM kareToplam AS F64
FOR i = 1 TO 5
    INPUT x(i)
    toplam = toplam + x(i)
NEXT i
ortalama = toplam / 5
FOR i = 1 TO 5
    kareToplam = kareToplam + (x(i)-ortalama) * (x(i)-ortalama)
NEXT i
varyans = kareToplam / 4
sapma = SQRT(varyans)
PRINT "ortalama="; ortalama; " sapma="; sapma
```

`SQRT`, aritmetik işlemler ve döngü birlikte istatistik temeli kurar. Kütüphane kullanmadan önce formülün mantığını böyle görmek yararlıdır.

##### Zaman ölçme ve tuşla çıkma

```uxbasic
basla = TIMER()
DO
    tus = INKEY()
    IF tus = "Q" THEN EXIT DO
    PRINT "calisiyor sure="; TIMER() - basla
LOOP UNTIL TIMER() - basla > 10
PRINT "bitti"
```

`TIMER` ve `INKEY` etkileşimli programların temelidir. `GETKEY` bekler, `INKEY` anlık okur; oyun döngüsü ve izleme panelinde bu ayrım önemlidir.

### Bellek ve düşük seviye

Bellek ve düşük seviye komutları ham adres, bayt, sözcük ve blokla çalışır. Bu alan güçlüdür ama dikkatsiz kullanılırsa programı bozabilir. `PEEK` okur, `POKE` yazar, `MEMCOPY` kopyalar, `MEMFILL` doldurur, `INC` ve `DEC` değer değiştirir. Bunlar DLL sarmalayıcılarında, binary dosyalarda, görüntü/ses tamponlarında, emülatör ve sistem programlamada kullanılır. Önce küçük tamponda dene; gerçek sistem adresine yazmadan önce iki kez düşün.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|PEEKB|PEEKB adres[, değer[, uzunluk]]|Adresten bayt okur.|
|PEEKW|PEEKW adres[, değer[, uzunluk]]|Adresten 16 bit sözcük okur.|
|PEEKD|PEEKD adres[, değer[, uzunluk]]|Adresten 32 bit değer okur.|
|POKE|POKE adres[, değer[, uzunluk]]|Adrese genel değer yazar.|
|POKEB|POKEB adres[, değer[, uzunluk]]|Adrese bayt yazar.|
|POKEW|POKEW adres[, değer[, uzunluk]]|Adrese 16 bit değer yazar.|
|POKED|POKED adres[, değer[, uzunluk]]|Adrese 32 bit değer yazar.|
|POKES|POKES adres[, değer[, uzunluk]]|Adrese metin/blok yazar.|
|MEMCOPYB|MEMCOPYB adres[, değer[, uzunluk]]|Bayt blok kopyalar.|
|MEMCOPYW|MEMCOPYW adres[, değer[, uzunluk]]|16 bit sözcük blok kopyalar.|
|MEMCOPYD|MEMCOPYD adres[, değer[, uzunluk]]|32 bit blok kopyalar.|
|MEMFILLB|MEMFILLB adres[, değer[, uzunluk]]|Belleği bayt değeriyle doldurur.|
|MEMFILLW|MEMFILLW adres[, değer[, uzunluk]]|Belleği 16 bit değerle doldurur.|
|MEMFILLD|MEMFILLD adres[, değer[, uzunluk]]|Belleği 32 bit değerle doldurur.|
|SETNEWOFFSET|SETNEWOFFSET adres[, değer[, uzunluk]]|Yeni ayırma ofsetini belirler.|
|INC|INC adres[, değer[, uzunluk]]|Sayıyı veya adresteki değeri artırır.|
|DEC|DEC adres[, değer[, uzunluk]]|Sayıyı veya adresteki değeri azaltır.|

#### Tekil komut defteri

##### 178. PEEKB
**Sözdizimi:** `PEEKB adres[, değer[, uzunluk]]`  
**Ne yapar:** Adresten bayt okur.  
**Nerede ve nasıl kullanılır:** `PEEKB` ham bellek veya tampon üzerinde çalışır. Adresten bayt okur. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
b = PEEKB(adres)
```

##### 179. PEEKW
**Sözdizimi:** `PEEKW adres[, değer[, uzunluk]]`  
**Ne yapar:** Adresten 16 bit sözcük okur.  
**Nerede ve nasıl kullanılır:** `PEEKW` ham bellek veya tampon üzerinde çalışır. Adresten 16 bit sözcük okur. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
w = PEEKW(adres)
```

##### 180. PEEKD
**Sözdizimi:** `PEEKD adres[, değer[, uzunluk]]`  
**Ne yapar:** Adresten 32 bit değer okur.  
**Nerede ve nasıl kullanılır:** `PEEKD` ham bellek veya tampon üzerinde çalışır. Adresten 32 bit değer okur. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
d = PEEKD(adres)
```

##### 181. POKE
**Sözdizimi:** `POKE adres[, değer[, uzunluk]]`  
**Ne yapar:** Adrese genel değer yazar.  
**Nerede ve nasıl kullanılır:** `POKE` ham bellek veya tampon üzerinde çalışır. Adrese genel değer yazar. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
POKE adres, deger
```

##### 182. POKEB
**Sözdizimi:** `POKEB adres[, değer[, uzunluk]]`  
**Ne yapar:** Adrese bayt yazar.  
**Nerede ve nasıl kullanılır:** `POKEB` ham bellek veya tampon üzerinde çalışır. Adrese bayt yazar. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
POKEB adres, 255
```

##### 183. POKEW
**Sözdizimi:** `POKEW adres[, değer[, uzunluk]]`  
**Ne yapar:** Adrese 16 bit değer yazar.  
**Nerede ve nasıl kullanılır:** `POKEW` ham bellek veya tampon üzerinde çalışır. Adrese 16 bit değer yazar. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
POKEW adres, 1024
```

##### 184. POKED
**Sözdizimi:** `POKED adres[, değer[, uzunluk]]`  
**Ne yapar:** Adrese 32 bit değer yazar.  
**Nerede ve nasıl kullanılır:** `POKED` ham bellek veya tampon üzerinde çalışır. Adrese 32 bit değer yazar. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
POKED adres, 65536
```

##### 185. POKES
**Sözdizimi:** `POKES adres[, değer[, uzunluk]]`  
**Ne yapar:** Adrese metin/blok yazar.  
**Nerede ve nasıl kullanılır:** `POKES` ham bellek veya tampon üzerinde çalışır. Adrese metin/blok yazar. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
POKES adres, "UXB"
```

##### 186. MEMCOPYB
**Sözdizimi:** `MEMCOPYB adres[, değer[, uzunluk]]`  
**Ne yapar:** Bayt blok kopyalar.  
**Nerede ve nasıl kullanılır:** `MEMCOPYB` ham bellek veya tampon üzerinde çalışır. Bayt blok kopyalar. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
MEMCOPYB hedef, kaynak, 64
```

##### 187. MEMCOPYW
**Sözdizimi:** `MEMCOPYW adres[, değer[, uzunluk]]`  
**Ne yapar:** 16 bit sözcük blok kopyalar.  
**Nerede ve nasıl kullanılır:** `MEMCOPYW` ham bellek veya tampon üzerinde çalışır. 16 bit sözcük blok kopyalar. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
MEMCOPYW hedef, kaynak, 32
```

##### 188. MEMCOPYD
**Sözdizimi:** `MEMCOPYD adres[, değer[, uzunluk]]`  
**Ne yapar:** 32 bit blok kopyalar.  
**Nerede ve nasıl kullanılır:** `MEMCOPYD` ham bellek veya tampon üzerinde çalışır. 32 bit blok kopyalar. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
MEMCOPYD hedef, kaynak, 16
```

##### 189. MEMFILLB
**Sözdizimi:** `MEMFILLB adres[, değer[, uzunluk]]`  
**Ne yapar:** Belleği bayt değeriyle doldurur.  
**Nerede ve nasıl kullanılır:** `MEMFILLB` ham bellek veya tampon üzerinde çalışır. Belleği bayt değeriyle doldurur. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
MEMFILLB tampon, 0, 1024
```

##### 190. MEMFILLW
**Sözdizimi:** `MEMFILLW adres[, değer[, uzunluk]]`  
**Ne yapar:** Belleği 16 bit değerle doldurur.  
**Nerede ve nasıl kullanılır:** `MEMFILLW` ham bellek veya tampon üzerinde çalışır. Belleği 16 bit değerle doldurur. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
MEMFILLW tampon, &HFFFF, 128
```

##### 191. MEMFILLD
**Sözdizimi:** `MEMFILLD adres[, değer[, uzunluk]]`  
**Ne yapar:** Belleği 32 bit değerle doldurur.  
**Nerede ve nasıl kullanılır:** `MEMFILLD` ham bellek veya tampon üzerinde çalışır. Belleği 32 bit değerle doldurur. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
MEMFILLD tampon, 0, 64
```

##### 192. SETNEWOFFSET
**Sözdizimi:** `SETNEWOFFSET adres[, değer[, uzunluk]]`  
**Ne yapar:** Yeni ayırma ofsetini belirler.  
**Nerede ve nasıl kullanılır:** `SETNEWOFFSET` ham bellek veya tampon üzerinde çalışır. Yeni ayırma ofsetini belirler. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
SETNEWOFFSET heapBaslangic
```

##### 193. INC
**Sözdizimi:** `INC adres[, değer[, uzunluk]]`  
**Ne yapar:** Sayıyı veya adresteki değeri artırır.  
**Nerede ve nasıl kullanılır:** `INC` ham bellek veya tampon üzerinde çalışır. Sayıyı veya adresteki değeri artırır. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
INC sayac
```

##### 194. DEC
**Sözdizimi:** `DEC adres[, değer[, uzunluk]]`  
**Ne yapar:** Sayıyı veya adresteki değeri azaltır.  
**Nerede ve nasıl kullanılır:** `DEC` ham bellek veya tampon üzerinde çalışır. Sayıyı veya adresteki değeri azaltır. Gerçek adresle çalışıyorsan önce küçük güvenli tamponda dene; yanlış adres programı bozabilir.

```uxbasic
DEC kalan
```

#### Bu sınıfı birlikte kullanma örnekleri

##### Ham tamponu doldur, kopyala ve denetle

```uxbasic
DIM kaynak(256) AS U8
DIM hedef(256) AS U8
DIM toplam AS U32
MEMFILLB VARPTR(kaynak(1)), 0, 256
FOR i = 1 TO 256
    kaynak(i) = i MOD 256
NEXT i
MEMCOPYB VARPTR(hedef(1)), VARPTR(kaynak(1)), 256
FOR i = 1 TO 256
    toplam = toplam + hedef(i)
NEXT i
PRINT "kopya checksum="; toplam
```

Düşük seviye komutları doğrudan adresle düşünür. `VARPTR` adres verir, `MEMFILLB` temizler, `MEMCOPYB` taşır. Önce dizi tamponuyla öğrenmek güvenlidir.

##### Binary kayıt alanına metin yazma fikri

```uxbasic
DIM tampon(64) AS U8
MEMFILLB VARPTR(tampon(1)), 0, 64
POKES VARPTR(tampon(1)), "UXBASIC"
ilk = PEEKB(VARPTR(tampon(1)))
PRINT "ilk karakter kodu="; ilk
```

`POKES` metni ham alana yazar, `PEEKB` ilk baytı okur. Bu mantık dosya formatı, emulator ve dış kütüphane tamponunda kullanılır.

### Listeleme

Listeleme komutu `ENUM`, anlamlı sabit grubu kurar. Sayı yerine ad kullanmak hem okumayı kolaylaştırır hem hata riskini azaltır. Durum makinesi, hata kodu, renk, hedef türü ve işlem modu için kullanılır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|ENUM|ENUM Ad ... END ENUM|Adlandırılmış sabitler grubu oluşturur.|

#### Tekil komut defteri

##### 195. ENUM
**Sözdizimi:** `ENUM Ad ... END ENUM`  
**Ne yapar:** Adlandırılmış sabitler grubu oluşturur.  
**Nerede ve nasıl kullanılır:** Adlandırılmış sabitler grubu oluşturur.

```uxbasic
ENUM Durum: HAZIR=1: CALISIYOR=2: HATA=3: END ENUM
```

#### Bu sınıfı birlikte kullanma örnekleri

##### ENUM ile durum makinesi

```uxbasic
ENUM DerlemeDurumu
    HAZIR = 1
    LEX_OK = 2
    AST_OK = 3
    MIR_OK = 4
    HATA = 9
END ENUM
DIM durum AS I32
durum = HAZIR
IF kaynakVar THEN durum = LEX_OK ELSE durum = HATA
SELECT CASE durum
CASE LEX_OK: PRINT "sozlukleme tamam"
CASE HATA: PRINT "derleme durdu"
END SELECT
```

Sayı yerine ad kullanmak kodu okunur yapar. `HAZIR` yazısı `1` sayısından daha anlamlıdır; hata ayıklarken de daha güvenlidir.

## Ön-işleyici komutları

Ön-işleyici komutları program çalışmadan önce çalışır. Bunlar normal çalışma zamanı komutu değildir; kaynak dosyayı, hedefi, HTML/JS/WAT/JSON çıktılarını, varlıkları, şablonları ve derleme zamanı güvenlik kurallarını hazırlar. Bu yüzden ön-işleyici kullanırken iki şeyi ayrı düşün: çalışma zamanı `PRINT` gibi komutlarla programın yaptığı iş, ön-işleyici `%%HTML_BEGIN` gibi komutlarla derleme sırasında üretilecek dosyalar.

|No|Komut|Sözdizimi|Görev|
|---:|---|---|---|
|1|`%%DEFINE`|`%%DEFINE ...`|metinsel tanım veya doğru/yanlış derleme simgesi oluşturur|
|2|`%%SET`|`%%SET ad = değer`|üst bilgi değişkeni atar|
|3|`%%ALIAS`|`%%ALIAS eski AS yeni`|tek satırlık metin kısaltması kurar: %%ALIAS {old} AS {new}|
|4|`%%MACRO`|`%%MACRO ...`|tek satırlık makro veya makro fonksiyon kurar|
|5|`%%IF`|`%%IF koşul ... %%ELIF ... %%ENDIF`|koşula göre kaynak bölümünü seçer|
|6|`%%IFC`|`%%IFC ...`|metinsel koşul karşılaştırması yapar|
|7|`%%FOR`|`%%FOR ...`|derleme zamanında sayısal döngü üretir|
|8|`%%FOREACH`|`%%FOREACH ...`|derleme zamanında liste üzerinde döner|
|9|`%%REPEAT`|`%%REPEAT ...`|derleme zamanında sabit tekrar üretir|
|10|`%%TARGET`|`%%TARGET js\|wasm\|browser\|native`|etkin çıktı hedefini seçer|
|11|`%%OUTDIR`|`%%OUTDIR ...`|çıktı dizinini belirler|
|12|`%%SECTION`|`%%SECTION ...`|etkin çıktı bölümünü seçer|
|13|`%%JS_BEGIN`|`%%JS_BEGIN ...`|JavaScript bloğunu çıktı olarak toplar|
|14|`%%JS_LINE`|`%%JS_LINE console.log("...")`|tek JavaScript satırı ekler|
|15|`%%JS_FILE`|`%%JS_FILE ...`|dış JavaScript dosyasını kayda alır|
|16|`%%WAT_BEGIN`|`%%WAT_BEGIN ...`|WAT bloğunu çıktı olarak toplar|
|17|`%%WAT_IMPORT`|`%%WAT_IMPORT ...`|WAT tarafında dış ev sahibi çağrısı bildirir|
|18|`%%WAT_EXPORT`|`%%WAT_EXPORT ...`|WAT dışa açılan adını bildirir|
|19|`%%WASM_HOST_JS_BEGIN`|`%%WASM_HOST_JS_BEGIN ...`|WASM ev sahibi JavaScript köprüsünü toplar|
|20|`%%HTML_BEGIN`|`%%HTML_BEGIN ...`|HTML bloğunu veya dosyasını toplar|
|21|`%%HTML_LINE`|`%%HTML_LINE ...`|tek HTML satırı ekler|
|22|`%%HTML_SCRIPT`|`%%HTML_SCRIPT ...`|betik etiketi bilgisini üretir|
|23|`%%HTML_STYLE`|`%%HTML_STYLE ...`|biçim dosyası etiketi bilgisini üretir|
|24|`%%CSS_BEGIN`|`%%CSS_BEGIN ...`|CSS bloğunu veya dosyasını toplar|
|25|`%%CSS_LINE`|`%%CSS_LINE ...`|tek CSS satırı ekler|
|26|`%%JSON_BEGIN`|`%%JSON_BEGIN ...`|JSON bloğunu veya dosyasını toplar|
|27|`%%JSON_SET`|`%%JSON_SET anahtar = değer`|JSON anahtar/değer yazar|
|28|`%%MANIFEST_SET`|`%%MANIFEST_SET ...`|yapı bildirgesine anahtar/değer yazar|
|29|`%%MANIFEST_REQUIRE`|`%%MANIFEST_REQUIRE ...`|zorunlu çıktı veya bağlantı bildirir|
|30|`%%MD_BEGIN`|`%%MD_BEGIN ...`|Markdown bloğunu toplar|
|31|`%%MD_FILE`|`%%MD_FILE ...`|Markdown dosyasını kayda alır|
|32|`%%ASSET_ROOT`|`%%ASSET_ROOT ...`|varlık kök dizinini belirler|
|33|`%%ASSET_COPY`|`%%ASSET_COPY ...`|varlık dosyasını kopyalar veya kayda alır|
|34|`%%ASSET_FILE`|`%%ASSET_FILE ...`|genel varlık dosyasını kayda alır|
|35|`%%ASSET_IMAGE`|`%%ASSET_IMAGE ...`|görsel varlığı kayda alır|
|36|`%%ASSET_AUDIO`|`%%ASSET_AUDIO ...`|ses varlığı kayda alır|
|37|`%%ALLOW_RAW_JS`|`%%ALLOW_RAW_JS ...`|ham JavaScript yazmaya izin verir|
|38|`%%ALLOW_RAW_WAT`|`%%ALLOW_RAW_WAT ...`|ham WAT yazmaya izin verir|
|39|`%%SAFE_PATHS`|`%%SAFE_PATHS ...`|yol güvenliği kuralını belirler|
|40|`%%REQUIRE_HOST_BINDING`|`%%REQUIRE_HOST_BINDING ...`|WAT içe çağrıları için ev sahibi bağlantısı ister|
|41|`%%ASSERT_META`|`%%ASSERT_META ...`|koşul yanlışsa derleme sırasında hata verir|
|42|`%%WARN_META`|`%%WARN_META ...`|derleme sırasında uyarı üretir|
|43|`%%IFN`|`%%IFN ...`|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|44|`%%ELIF`|`%%ELIF ...`|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|45|`%%PROFILE`|`%%PROFILE ...`|derleme profili seçer; DEBUG, RELEASE veya WEB gibi farklı davranışları ayırır|
|46|`%%CONFIG_FILE`|`%%CONFIG_FILE ...`|dış yapılandırma dosyasını ön-işleyiciye bildirir|
|47|`%%PATH_ALIAS`|`%%PATH_ALIAS ...`|uzun dizin yollarına kısa takma ad verir|
|48|`%%LOCK_META`|`%%LOCK_META ...`|meta değişkenin sonradan değişmesini engeller|
|49|`%%DUMP_META`|`%%DUMP_META ...`|meta değişkenleri rapor dosyasına döker|
|50|`%%SOURCE_MAP`|`%%SOURCE_MAP ...`|kaynak/çıktı eşleştirme haritası ister|
|51|`%%EMITNOTE`|`%%EMITNOTE ...`|derleme raporuna açıklama notu ekler|
|52|`%%ENV`|`%%ENV ...`|ortam değişkeni veya ortamdan gelen değeri okur|
|53|`%%DEPRECATED`|`%%DEPRECATED ...`|eski kullanım için uyarı üretir|
|54|`%%TEMPLATE_BEGIN`|`%%TEMPLATE_BEGIN ...`|şablon tanımlama veya şablonu kullanma işini yönetir|
|55|`%%TEMPLATE_END`|`%%TEMPLATE_END ...`|şablon tanımlama veya şablonu kullanma işini yönetir|
|56|`%%TEMPLATE_USE`|`%%TEMPLATE_USE ...`|şablon tanımlama veya şablonu kullanma işini yönetir|
|57|`%%MINIFY`|`%%MINIFY ...`|web çıktısında küçültme isteğini belirtir|
|58|`%%FINGERPRINT_ASSETS`|`%%FINGERPRINT_ASSETS ...`|varlıklara değişiklik izi/hash eklenmesini ister|
|59|`%%HASHFILE`|`%%HASHFILE ...`|dosya özeti/hash üretir|
|60|`%%COPY_DIR`|`%%COPY_DIR ...`|dizin kopyalama kuralı bildirir|
|61|`%%EMBEDTEXT`|`%%EMBEDTEXT ...`|metin dosyasını çıktı içine gömer|
|62|`%%EMBEDBASE64`|`%%EMBEDBASE64 ...`|ikili dosyayı base64 metni olarak gömer|
|63|`%%LICENSEFILE`|`%%LICENSEFILE ...`|lisans dosyasını pakete ekler|
|64|`%%HTMLIMAGE`|`%%HTMLIMAGE ...`|HTML varlığı veya etiketi üretir|
|65|`%%HTMLAUDIO`|`%%HTMLAUDIO ...`|HTML varlığı veya etiketi üretir|
|66|`%%CSS_RULE`|`%%CSS_RULE ...`|CSS varlığı veya kuralı üretir|
|67|`%%CSS_IMPORT`|`%%CSS_IMPORT ...`|CSS varlığı veya kuralı üretir|
|68|`%%MD_SAFE`|`%%MD_SAFE ...`|Markdown raporu veya güvenlik kuralı üretir|
|69|`%%MD_CSS`|`%%MD_CSS ...`|Markdown raporu veya güvenlik kuralı üretir|
|70|`%%BREAK`|`%%BREAK ...`|ön-işleyici döngüsünde akışı değiştirir|
|71|`%%CONTINUE`|`%%CONTINUE ...`|ön-işleyici döngüsünde akışı değiştirir|
|72|`%%INFOMETA`|`%%INFOMETA ...`|meta bilgi satırı üretir|

### 15–21 arası geniş ön-işleyici örnekleri

#### 15. Tarayıcı uygulaması için HTML, CSS, JS ve manifest üretme

```uxbasic
%%TARGET browser
%%OUTDIR "dist/web"
%%MANIFEST_SET name = "Saha Paneli"
%%MANIFEST_REQUIRE "program.js"
%%HTML_BEGIN "index.html" BODY
<div id="app">Saha paneli hazir</div>
%%HTML_END
%%CSS_BEGIN "style.css"
body { font-family: sans-serif; }
%%CSS_LINE "#app { padding: 16px; }"
%%JS_BEGIN "program.js"
console.log("uXBasic web cikti calisti")
%%JS_LINE "document.getElementById('app').innerText='Olcum bekleniyor';"
%%JS_FILE "ux_runtime.js"
MAIN
    PRINT "web paketi hazir"
END MAIN
```

Bu örnekte ön-işleyici yalnız süs değildir; çıktı dosyası, hedef ortam, varlık, rapor veya güvenlik kuralı üretir. Genç programcı burada şunu görür: aynı `.uxb` dosyası hem program mantığı taşır hem de derleme zamanındaki paketleme aklını yönetir.

#### 16. WAT/WASM için ev sahibi çağrısı ve dışa açılan fonksiyon

```uxbasic
%%TARGET wasm
%%OUTDIR "dist/wasm"
%%ALLOW_RAW_WAT true
%%REQUIRE_HOST_BINDING "ux.print_i32"
%%WAT_IMPORT "ux" "print_i32" "(func $print_i32 (param i32))"
%%WAT_BEGIN "program.wat"
(module
  (import "ux" "print_i32" (func $print_i32 (param i32)))
  (func $main
    i32.const 42
    call $print_i32)
  (export "main" (func $main)))
%%WAT_EXPORT "main"
%%WAT_BEGIN_END
MAIN
    PRINT "WAT dosyasi uretildi"
END MAIN
```

Bu örnekte ön-işleyici yalnız süs değildir; çıktı dosyası, hedef ortam, varlık, rapor veya güvenlik kuralı üretir. Genç programcı burada şunu görür: aynı `.uxb` dosyası hem program mantığı taşır hem de derleme zamanındaki paketleme aklını yönetir.

#### 17. Profil ve koşullu derleme ile debug/ürün ayrımı

```uxbasic
%%PROFILE DEBUG
%%SET APP = "KaliteDenetim"
%%IF PROFILE == "DEBUG"
%%EMITNOTE "debug raporlari acik"
%%DUMP_META "out/meta_debug.json"
%%ELIF PROFILE == "RELEASE"
%%MINIFY true
%%FINGERPRINT_ASSETS true
%%ENDIF
MAIN
    PRINT "uygulama="; "{{APP}}"
END MAIN
```

Bu örnekte ön-işleyici yalnız süs değildir; çıktı dosyası, hedef ortam, varlık, rapor veya güvenlik kuralı üretir. Genç programcı burada şunu görür: aynı `.uxb` dosyası hem program mantığı taşır hem de derleme zamanındaki paketleme aklını yönetir.

#### 18. Varlık kökü, görsel/ses kopyalama ve güvenli yol

```uxbasic
%%TARGET browser
%%ASSET_ROOT "assets"
%%SAFE_PATHS "assets;dist/web"
%%ASSET_IMAGE "logo.png"
%%ASSET_AUDIO "alarm.wav"
%%ASSET_COPY "assets/logo.png" "dist/web/logo.png"
%%HTML_BEGIN "index.html" BODY
<img src="logo.png">
<audio id="alarm" src="alarm.wav"></audio>
%%HTML_END
MAIN
    PRINT "varliklar paketlendi"
END MAIN
```

Bu örnekte ön-işleyici yalnız süs değildir; çıktı dosyası, hedef ortam, varlık, rapor veya güvenlik kuralı üretir. Genç programcı burada şunu görür: aynı `.uxb` dosyası hem program mantığı taşır hem de derleme zamanındaki paketleme aklını yönetir.

#### 19. JSON ve Markdown raporu aynı kaynaktan üretme

```uxbasic
%%JSON_BEGIN "rapor.json"
%%JSON_SET "ad" = "Saha Deneyi"
%%JSON_SET "surum" = "1.0"
%%JSON_SET "hedef" = "browser"
%%MD_BEGIN "rapor.md"
# Saha Deneyi
Bu rapor uXBasic on-isleyici ile uretilmistir.
%%MD_FILE "ek_notlar.md"
%%MD_CSS "rapor.css"
MAIN
    PRINT "json ve markdown cikti hazir"
END MAIN
```

Bu örnekte ön-işleyici yalnız süs değildir; çıktı dosyası, hedef ortam, varlık, rapor veya güvenlik kuralı üretir. Genç programcı burada şunu görür: aynı `.uxb` dosyası hem program mantığı taşır hem de derleme zamanındaki paketleme aklını yönetir.

#### 20. Şablonla tekrar eden HTML kartları üretme

```uxbasic
%%TEMPLATE_BEGIN Kart
<div class="kart">
  <h2>{{baslik}}</h2>
  <p>{{metin}}</p>
</div>
%%TEMPLATE_END
%%HTML_BEGIN "index.html" BODY
%%TEMPLATE_USE Kart baslik="pH" metin="6.5 ile 8.5 arasi uygundur"
%%TEMPLATE_USE Kart baslik="Sicaklik" metin="20 ile 26 derece arasi izlenir"
%%HTML_END
MAIN
    PRINT "sablonlu sayfa uretildi"
END MAIN
```

Bu örnekte ön-işleyici yalnız süs değildir; çıktı dosyası, hedef ortam, varlık, rapor veya güvenlik kuralı üretir. Genç programcı burada şunu görür: aynı `.uxb` dosyası hem program mantığı taşır hem de derleme zamanındaki paketleme aklını yönetir.

#### 21. Derleme zamanı güvenlik kapısı ve hata uyarısı

```uxbasic
%%SET TARGET_NAME = "browser"
%%ASSERT_META TARGET_NAME != ""
%%WARN_META "API anahtarlarini kaynak dosyaya yazma"
%%LOCK_META "TARGET_NAME"
%%SOURCE_MAP "out/source_map.json"
%%EMITNOTE "cikti sozlesmesi denetlenecek"
MAIN
    PRINT "guvenli derleme hazir"
END MAIN
```

Bu örnekte ön-işleyici yalnız süs değildir; çıktı dosyası, hedef ortam, varlık, rapor veya güvenlik kuralı üretir. Genç programcı burada şunu görür: aynı `.uxb` dosyası hem program mantığı taşır hem de derleme zamanındaki paketleme aklını yönetir.

## Komutları öğrenirken uygulanacak çalışma yöntemi

Bir komutu öğrenirken dört küçük deney yap: önce doğru örneği çalıştır, sonra sözdizimini boz, sonra yanlış tip ver, sonra çıktıyı JSON raporuyla izle. Örneğin `IF` öğreniyorsan `--tokens-json-out`, `--ast-json-out` ve `--parser-diagnostics-json-out` çıktıları al. `OPEN` öğreniyorsan hem var olan hem olmayan dosyayla dene. `CALL(DLL)` öğreniyorsan önce yanlış imzayla değil, güvenli ve küçük bir API ile başla. Bu yöntem komutu ezberletmez; komutun hangi katmanda nasıl göründüğünü öğretir.