# uXBasic Programlayıcının Cep Kitabı — Cilt 2
# Anahtar Sözcükler, Komutlar, Ön-İşleyici, Tipler, İşleçler ve Yerel Fonksiyonlar

Bu ciltte tablo hücreleri kısa ve işe yarar tutuldu: sözdizimi ne yazacağını, görev ise komutun ne yaptığını söyler. Uzun anlatım tablonun altında sınıf başlıklarına ayrılmıştır. Böylece aynı cümle tekrarı yerine her komutun program yazarken nerede işe yaradığı görülür.

## Tüm anahtar sözcükler
|No|Sözcük|Sınıf|Sözdizimi|Görev|
|---|---|---|---|---|
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
|16|THREAT|Olay ve eşzamanlılık|THREAT IsAdi ... END THREAT|THREAD için eski/uyumluluk yazımı olarak ele alınır.|
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
|47|SIHIRLIMETOT|Nesne ve tip bildirimi|SIHIRLIMETOT Ad(...)|Özel davranışlı sihirli yöntem tanımlar.|
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

## Sınıflara göre komut anlatımı

### Akış

Akış komutları programın yol ayrımlarıdır. Bir genç programcı bu grubu iyi anlarsa programı çizgi film sahnesi gibi düşünebilir: bir sahnede karar verilir, başka sahnede tekrar yapılır, hata çıkarsa temizlik sahnesine geçilir. `IF`, `SELECT`, `FOR`, `DO`, `TRY` ve `RETURN` aynı ailenin farklı araçlarıdır. Veri ölçümleri, kullanıcı menüleri, dosya okuma döngüleri ve bilimsel hesaplar hep akışla yönetilir. Bu komutları kullanırken önce koşulu kısa yaz, sonra o koşulun neden var olduğunu yorumla açıkla. Döngü yazarken çıkış yolunu unutma; çıkış yolu olmayan döngü genç programcının ilk büyük tuzağıdır. Hata yakalamayı da akışın parçası say; çünkü gerçek programda dosya her zaman bulunmaz, API her zaman cevap vermez, kullanıcı her zaman beklediğin veriyi yazmaz.

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

#### IF
**Sözdizimi:** `IF koşul THEN komutlar ELSE komutlar END IF`  
**Ne işe yarar:** Koşula bakar; doğru yolda ayrı, yanlış yolda ayrı komutlar çalıştırır.  
**Nerede kullanılır:** Karar vermen gereken her yerde kullanılır: kullanıcı yetkisi, ölçüm sınırı, dosya var mı, hata var mı, hedef tarayıcı mı gibi.

```uxbasic
IF ph < 6.5 THEN PRINT "asit" ELSE PRINT "normal" END IF
```
#### THEN
**Sözdizimi:** `IF koşul THEN komutlar`  
**Ne işe yarar:** IF koşulu doğru olduğunda başlayacak komut bölümünü gösterir.  
**Nerede kullanılır:** Tek başına program başlatmaz; IF satırındaki doğru dalı açar.

```uxbasic
IF sicaklik > 30 THEN PRINT "fan ac"
```
#### ELSE
**Sözdizimi:** `IF koşul THEN ... ELSE ... END IF`  
**Ne işe yarar:** IF koşulu yanlışsa çalışacak yedek yolu gösterir.  
**Nerede kullanılır:** Olumsuz durumun da planlı olmasını sağlar.

```uxbasic
IF stok > 0 THEN PRINT "sat" ELSE PRINT "siparis ver" END IF
```
#### ELSEIF
**Sözdizimi:** `IF a THEN ... ELSEIF b THEN ... ELSE ... END IF`  
**Ne işe yarar:** Birden çok koşulu sırayla dener; ilk doğru koşulun bölümünü çalıştırır.  
**Nerede kullanılır:** Çok sınıflı karar ağacı kurarken kullanılır.

```uxbasic
IF notu>=85 THEN PRINT "AA" ELSEIF notu>=70 THEN PRINT "BB" ELSE PRINT "CC" END IF
```
#### END
**Sözdizimi:** `END IF | END SELECT | END SUB | END FUNCTION | END CLASS | END MODULE`  
**Ne işe yarar:** Açılmış bloğu kapatır ve sınırını belli eder.  
**Nerede kullanılır:** Blokların birbirine karışmamasını sağlar.

```uxbasic
SUB Selam(): PRINT "merhaba": END SUB
```
#### SELECT
**Sözdizimi:** `SELECT CASE ifade ... CASE değer ... END SELECT`  
**Ne işe yarar:** Tek bir değeri birçok olası değere göre dallandırır.  
**Nerede kullanılır:** Menü, durum kodu, hedef adı, işlem türü gibi seçeneklerde IF zincirinden daha okunur.

```uxbasic
SELECT CASE secim
CASE 1: PRINT "basla"
CASE 2: PRINT "yardim"
END SELECT
```
#### CASE
**Sözdizimi:** `CASE değer | CASE IS > değer | CASE ELSE`  
**Ne işe yarar:** SELECT içindeki tek seçeneği belirtir.  
**Nerede kullanılır:** SELECT olmadan anlamı yoktur; bir sınıflandırma satırıdır.

```uxbasic
CASE IS > 100: PRINT "buyuk"
```
#### IS
**Sözdizimi:** `CASE IS > değer | CASE IS <= değer`  
**Ne işe yarar:** CASE içinde karşılaştırmalı seçenek kurar.  
**Nerede kullanılır:** Sadece eşitlik değil aralık/sınır denetimi gerektiğinde kullanılır.

```uxbasic
CASE IS <= 0: PRINT "gecersiz"
```
#### TRY
**Sözdizimi:** `TRY ... CATCH hata ... FINALLY ... END TRY`  
**Ne işe yarar:** Hata çıkabilecek işi korumalı bölümde dener.  
**Nerede kullanılır:** Dosya, ağ, DLL ve kullanıcı girdisi gibi bozulabilecek işlerde kullanılır.

```uxbasic
TRY
  OPEN "veri.csv" FOR INPUT AS #1
CATCH e
  PRINT "dosya acilamadi"
END TRY
```
#### CATCH
**Sözdizimi:** `CATCH hataAdi`  
**Ne işe yarar:** TRY içindeki hata yakalanırsa çalışacak bölümü başlatır.  
**Nerede kullanılır:** Programın çökmesini önler, hatayı anlaşılır mesaja çevirir.

```uxbasic
CATCH e: PRINT "hata: "; e
```
#### FINALLY
**Sözdizimi:** `FINALLY ...`  
**Ne işe yarar:** Hata olsa da olmasa da en son çalışacak temizlik bölümünü açar.  
**Nerede kullanılır:** Açılan dosyayı kapatmak, belleği bırakmak, bağlantıyı sonlandırmak için kullanılır.

```uxbasic
FINALLY: CLOSE #1
```
#### THROW
**Sözdizimi:** `THROW "hata metni"`  
**Ne işe yarar:** Senin belirlediğin hatayı bilinçli olarak fırlatır.  
**Nerede kullanılır:** Yanlış veri geldiğinde sessizce devam etmek yerine hatayı görünür yapar.

```uxbasic
IF yas < 0 THEN THROW "yas negatif olamaz"
```
#### ASSERT
**Sözdizimi:** `ASSERT koşul`  
**Ne işe yarar:** Test amacıyla bir koşulun doğru olmasını zorunlu tutar.  
**Nerede kullanılır:** Derleyici, kütüphane ve bilimsel hesap testlerinde beklenen sonucu korur.

```uxbasic
ASSERT toplam >= 0
```
#### FOR
**Sözdizimi:** `FOR sayac = ilk TO son STEP adim ... NEXT sayac`  
**Ne işe yarar:** Sayaçlı döngü kurar.  
**Nerede kullanılır:** Kaç kere çalışacağı belli olan işlerde kullanılır.

```uxbasic
FOR i = 1 TO 10 STEP 1
  PRINT i
NEXT i
```
#### TO
**Sözdizimi:** `FOR i = başlangıç TO bitiş`  
**Ne işe yarar:** Döngünün son değerini gösterir.  
**Nerede kullanılır:** FOR satırında hedef sınırı belirtir.

```uxbasic
FOR gun = 1 TO 30: PRINT gun: NEXT gun
```
#### STEP
**Sözdizimi:** `FOR i = ilk TO son STEP adim`  
**Ne işe yarar:** Sayaç artışını veya azalışını belirler.  
**Nerede kullanılır:** Atlamalı okuma, geri sayım, seyrek örnekleme işlerinde kullanılır.

```uxbasic
FOR i = 10 TO 0 STEP -2: PRINT i: NEXT i
```
#### NEXT
**Sözdizimi:** `NEXT sayac`  
**Ne işe yarar:** FOR döngüsünün sonunu ve sonraki adıma geçişini gösterir.  
**Nerede kullanılır:** Sayaçlı tekrarın kapanışıdır.

```uxbasic
NEXT i
```
#### DO
**Sözdizimi:** `DO WHILE koşul ... LOOP | DO ... LOOP UNTIL koşul`  
**Ne işe yarar:** Koşullu döngü başlatır.  
**Nerede kullanılır:** Kaç tekrar olacağı önceden bilinmeyen işlerde kullanılır.

```uxbasic
DO WHILE EOF(1)=0
  INPUT #1, satir
LOOP
```
#### LOOP
**Sözdizimi:** `LOOP | LOOP UNTIL koşul`  
**Ne işe yarar:** DO döngüsünü kapatır; gerekirse çıkış koşulunu taşır.  
**Nerede kullanılır:** Dosya sonuna kadar, tuş gelene kadar veya iş bitene kadar döndürür.

```uxbasic
LOOP UNTIL tus = "Q"
```
#### WHILE
**Sözdizimi:** `DO WHILE koşul | WHILE koşul ... WEND`  
**Ne işe yarar:** Koşul doğru kaldığı sürece çalışmayı sürdürür.  
**Nerede kullanılır:** Sürekli izleme, kuyruk boşalana kadar çalışma ve oyun döngüsünde kullanılır.

```uxbasic
DO WHILE pil > 20: PRINT pil: pil = pil - 1: LOOP
```
#### UNTIL
**Sözdizimi:** `LOOP UNTIL koşul`  
**Ne işe yarar:** Koşul doğru olunca döngüyü bitirir.  
**Nerede kullanılır:** En az bir kez çalışması gereken sorgularda kullanılır.

```uxbasic
LOOP UNTIL cevap = "EVET"
```
#### EXIT
**Sözdizimi:** `EXIT FOR | EXIT DO | EXIT FUNCTION | EXIT SUB`  
**Ne işe yarar:** İçinde bulunulan döngüden veya yordamdan erken çıkar.  
**Nerede kullanılır:** Gereksiz çalışmayı keser; özellikle arama ve hata durumunda işe yarar.

```uxbasic
IF hata THEN EXIT FOR
```
#### EACH
**Sözdizimi:** `FOR EACH eleman IN liste ... NEXT`  
**Ne işe yarar:** Bir koleksiyonun elemanlarını tek tek dolaşır.  
**Nerede kullanılır:** Liste, sözlük anahtarları ve veri satırları için okunur döngü kurar.

```uxbasic
FOR EACH ad IN isimler: PRINT ad: NEXT
```
#### IN
**Sözdizimi:** `FOR EACH x IN koleksiyon | x IN liste`  
**Ne işe yarar:** Bir elemanın hangi koleksiyondan geleceğini belirtir veya üyelik sınaması yapar.  
**Nerede kullanılır:** Koleksiyonla çalışan modern BASIC yazımını güçlendirir.

```uxbasic
FOR EACH v IN olcumler: PRINT v: NEXT
```
#### RETURN
**Sözdizimi:** `RETURN değer`  
**Ne işe yarar:** Fonksiyondan sonuç döndürür veya alt yordamdan geri döner.  
**Nerede kullanılır:** Hesap sonucunu çağıran yere verir.

```uxbasic
FUNCTION IkiKat(x AS I32) AS I32
  RETURN x*2
END FUNCTION
```
#### GOTO
**Sözdizimi:** `GOTO etiket`  
**Ne işe yarar:** Belirtilen etikete doğrudan atlar.  
**Nerede kullanılır:** Kısa kurtarma veya eski BASIC uyumluluğunda kullanılır; yeni kodda dikkatli kullanılmalıdır.

```uxbasic
GOTO Temizle
```
#### GOSUB
**Sözdizimi:** `GOSUB etiket ... RETURN`  
**Ne işe yarar:** Etikete gider ve RETURN ile geri döner.  
**Nerede kullanılır:** Eski BASIC alt yordam düzenini taşır; büyük kodda SUB daha temizdir.

```uxbasic
GOSUB YazBaslik
```
**Birlikte kullanım örneği — veri sınıflandırma:**
```uxbasic
DIM toplam AS F64
DIM adet AS I32
FOR i = 1 TO 5 STEP 1
  INPUT olcum
  IF olcum < 0 THEN EXIT FOR ELSE toplam = toplam + olcum
  adet = adet + 1
NEXT i
IF adet > 0 THEN PRINT "ortalama="; toplam/adet ELSE PRINT "veri yok" END IF
```

### Olay ve eşzamanlılık

Olay ve eşzamanlılık komutları, programın dış dünyadan gelen işaretlere tepki vermesini sağlar. GUI düğmesine basılması, tarayıcıda tıklama, sensörden veri gelmesi, zamanlayıcının dolması veya başka bir işin sonuç üretmesi olaydır. `EVENT` olayın adını koyar, `SLOT` o olaya verilecek tepkiyi taşır, `TRIGGER` olayı elle çalıştırır. `THREAD`, `PARALEL` ve `PIPE` programın tek sıra halinde değil, düzenli iş bölümüyle çalışmasına yardım eder. Burada hayal gücü şöyle gelişir: bir iş veri üretir, boruya koyar; ikinci iş borudan alır, hesaplar; üçüncü iş ekrana veya dosyaya yazar. Bu yapı GUI, tarayıcı, sensör, oyun, sunucu ve uzun hesaplamalarda kullanılır. Genç programcı için püf noktası şudur: eşzamanlı işlerde paylaşılan değişkeni gelişigüzel değiştirme; boru, olay ve kuyruk kullan.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|EVENT|EVENT OlayAdi|Daha sonra tetiklenecek olay adını bildirir.|
|THREAD|THREAD IsAdi ... END THREAD|Ayrı iş parçası olarak çalışacak işi tanımlar.|
|THREAT|THREAT IsAdi ... END THREAT|THREAD için eski/uyumluluk yazımı olarak ele alınır.|
|PARALEL|PARALEL GrupAdi ... END PARALEL|Birden fazla işi paralel görev ailesi olarak düzenler.|
|PIPE|PIPE Ad AS Tip|İki iş arasında veri taşıyan boru tanımlar.|
|SLOT|SLOT Ad ON Olay ... END SLOT|Bir olaya bağlı çalışacak kod yuvasını tanımlar.|
|ON|SLOT Ad ON Olay \| ON ERROR ...|Bir eylemi olaya veya duruma bağlar.|
|OFF|OFF Olay \| OFF SLOT Ad|Olay dinlemeyi veya bağlı tepkiyi kapatır.|
|TRIGGER|TRIGGER OlayAdi[, veri]|Bir olayı elle tetikler.|

#### EVENT
**Sözdizimi:** `EVENT OlayAdi`  
**Ne işe yarar:** Daha sonra tetiklenecek olay adını bildirir.  
**Nerede kullanılır:** GUI düğmesi, tarayıcı tıklaması, seri port verisi, zamanlayıcı ve sensör bildirimi için kullanılır.

```uxbasic
EVENT VeriGeldi
SLOT EkranaYaz ON VeriGeldi
  PRINT "veri geldi"
END SLOT
```
#### THREAD
**Sözdizimi:** `THREAD IsAdi ... END THREAD`  
**Ne işe yarar:** Ayrı iş parçası olarak çalışacak işi tanımlar.  
**Nerede kullanılır:** Ekranı dondurmadan dosya okuma, ağ bekleme veya hesap yapma için kullanılır.

```uxbasic
THREAD ArkaPlan
  PRINT "uzun is"
END THREAD
```
#### THREAT
**Sözdizimi:** `THREAT IsAdi ... END THREAT`  
**Ne işe yarar:** THREAD için eski/uyumluluk yazımı olarak ele alınır.  
**Nerede kullanılır:** Eski dosyalarda kalmış yazımı kırmadan taşımak için kullanılır.

```uxbasic
THREAT EskiYazim
  PRINT "uyumlu is"
END THREAT
```
#### PARALEL
**Sözdizimi:** `PARALEL GrupAdi ... END PARALEL`  
**Ne işe yarar:** Birden fazla işi paralel görev ailesi olarak düzenler.  
**Nerede kullanılır:** Bağımsız hesaplar, veri dönüştürme ve tarayıcı işleri birlikte ilerlesin diye kullanılır.

```uxbasic
PARALEL Hesaplar
  CALL OrtalamaAl()
  CALL GrafikHazirla()
END PARALEL
```
#### PIPE
**Sözdizimi:** `PIPE Ad AS Tip`  
**Ne işe yarar:** İki iş arasında veri taşıyan boru tanımlar.  
**Nerede kullanılır:** Bir iş veri üretirken diğer işin tüketmesini sağlar.

```uxbasic
PIPE Olcumler AS F64
```
#### SLOT
**Sözdizimi:** `SLOT Ad ON Olay ... END SLOT`  
**Ne işe yarar:** Bir olaya bağlı çalışacak kod yuvasını tanımlar.  
**Nerede kullanılır:** Olay geldiğinde hangi işin yapılacağını gösterir.

```uxbasic
SLOT Kaydet ON VeriGeldi
  PRINT "kaydedildi"
END SLOT
```
#### ON
**Sözdizimi:** `SLOT Ad ON Olay | ON ERROR ...`  
**Ne işe yarar:** Bir eylemi olaya veya duruma bağlar.  
**Nerede kullanılır:** Bağlama cümlesidir; olayı ve tepkiyi birbirine bağlar.

```uxbasic
SLOT Tiklama ON ButonTiklandi
```
#### OFF
**Sözdizimi:** `OFF Olay | OFF SLOT Ad`  
**Ne işe yarar:** Olay dinlemeyi veya bağlı tepkiyi kapatır.  
**Nerede kullanılır:** Geçici durdurma, güvenli kapanış ve kaynak bırakma sırasında kullanılır.

```uxbasic
OFF VeriGeldi
```
#### TRIGGER
**Sözdizimi:** `TRIGGER OlayAdi[, veri]`  
**Ne işe yarar:** Bir olayı elle tetikler.  
**Nerede kullanılır:** Testte, GUI benzetiminde ve donanım gelmiş gibi davranmak istediğinde kullanılır.

```uxbasic
TRIGGER VeriGeldi, 42
```
**Birlikte kullanım örneği — sensör olayını ekrana ve dosyaya bağlama:**
```uxbasic
EVENT VeriGeldi
PIPE OlcumHatti AS F64
SLOT EkranaYaz ON VeriGeldi
  INPUT yeniDeger
  PRINT "yeni olcum="; yeniDeger
  OPEN "olcum.log" FOR APPEND AS #1
  PRINT #1, STR(TIMER()) + ";" + STR(yeniDeger)
  CLOSE #1
END SLOT
TRIGGER VeriGeldi
```

### Yordam ve çağrı

Yordam ve çağrı komutları, programı küçük ve tekrar kullanılabilir parçalara böler. `SUB` sonuç döndürmeyen işi, `FUNCTION` sonuç döndüren hesabı taşır. `DECLARE` ve `CALL` ise dış dünyaya açılan kapıdır: Windows DLL, C kütüphanesi, REST köprüsü veya yerel yapay zeka sarmalayıcısı buradan çağrılır. Parametreyi kopya mı göndereceğin (`BYVAL`) yoksa değiştirilebilir adres gibi mi göndereceğin (`BYREF`) çoğu hatanın kaynağıdır. Dış çağrıda çağrı düzeni [fonksiyonun bellekte nasıl çağrıldığı] (calling convention) önemlidir; C tarafında `CDECL`, Windows tarafında çoğu eski API için `STDCALL` görülebilir. İyi genç programcı, her dış çağrıya küçük bir uXBasic fonksiyonu yazar ve programın geri kalanını DLL ayrıntısından korur.

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

#### SUB
**Sözdizimi:** `SUB Ad(param AS Tip) ... END SUB`  
**Ne işe yarar:** Değer döndürmeyen tekrar kullanılabilir iş bloğu tanımlar.  
**Nerede kullanılır:** Yazdırma, kaydetme, ekran temizleme gibi sonuç döndürmeyen işlerde kullanılır.

```uxbasic
SUB BaslikYaz(): PRINT "RAPOR": END SUB
```
#### FUNCTION
**Sözdizimi:** `FUNCTION Ad(param AS Tip) AS Tip ... RETURN değer ... END FUNCTION`  
**Ne işe yarar:** Değer döndüren hesap veya dönüştürme bloğu tanımlar.  
**Nerede kullanılır:** Hesap, metin işleme, doğrulama ve kütüphane sarmalayıcılarında kullanılır.

```uxbasic
FUNCTION Kare(x AS F64) AS F64
  RETURN x*x
END FUNCTION
```
#### DECLARE
**Sözdizimi:** `DECLARE FUNCTION Ad LIB "dll" ALIAS "gercek_ad" (...) AS Tip`  
**Ne işe yarar:** Dış kütüphane fonksiyonunun uXBasic tarafındaki imzasını bildirir.  
**Nerede kullanılır:** DLL/API çağırmadan önce ad, parametre ve dönüş tipini netleştirir.

```uxbasic
DECLARE FUNCTION MessageBox LIB "user32.dll" ALIAS "MessageBoxA" (BYVAL hwnd AS PTR, BYVAL text AS STRING, BYVAL title AS STRING, BYVAL tip AS I32) AS I32
```
#### CALL
**Sözdizimi:** `CALL Ad(argler) | CALL(DLL,"dll","fonksiyon",argler) | CALL(API,"ad",argler)`  
**Ne işe yarar:** Tanımlı yordamı, dış DLL fonksiyonunu veya API çağrısını çalıştırır.  
**Nerede kullanılır:** uXBasic’in çekirdeğini büyütmeden dış dünyaya açılma kapısıdır.

```uxbasic
CALL BaslikYaz()
```
#### BYREF
**Sözdizimi:** `param AS BYREF Tip | BYREF param AS Tip`  
**Ne işe yarar:** Parametrenin kendisini gönderir; fonksiyon değeri değiştirebilir.  
**Nerede kullanılır:** Dış kütüphane dönüş tamponları ve hızlı veri güncellemede kullanılır.

```uxbasic
SUB Artir(BYREF x AS I32): x = x + 1: END SUB
```
#### BYVAL
**Sözdizimi:** `BYVAL param AS Tip`  
**Ne işe yarar:** Parametrenin kopyasını gönderir; çağıranın değişkeni etkilenmez.  
**Nerede kullanılır:** DLL imzalarında ve güvenli çağrılarda önemlidir.

```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32
```
#### CDECL
**Sözdizimi:** `DECLARE CDECL FUNCTION ...`  
**Ne işe yarar:** C çağrı düzenini belirtir.  
**Nerede kullanılır:** C/C++ kütüphanesiyle uyum için kullanılır.

```uxbasic
DECLARE CDECL FUNCTION sin LIB "msvcrt.dll" ALIAS "sin" (BYVAL x AS F64) AS F64
```
#### STDCALL
**Sözdizimi:** `DECLARE STDCALL FUNCTION ...`  
**Ne işe yarar:** Windows çağrı düzenini belirtir.  
**Nerede kullanılır:** Windows API tarafında sık kullanılır.

```uxbasic
DECLARE STDCALL FUNCTION MessageBox LIB "user32.dll" ALIAS "MessageBoxA" (...) AS I32
```
**Birlikte kullanım örneği — DLL çağrısını güvenli sarmalama:**
```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32
FUNCTION UyariSesi(hz AS I32, ms AS I32) AS BOOLEAN
  IF hz < 37 THEN RETURN FALSE
  sonuc = CALL(DLL, "kernel32.dll", "Beep", hz, ms)
  IF sonuc = 0 THEN RETURN FALSE ELSE RETURN TRUE END IF
END FUNCTION
IF UyariSesi(880, 150) THEN PRINT "ses verildi" ELSE PRINT "ses hatasi" END IF
```

### Nesne ve tip bildirimi

Nesne ve tip bildirimi komutları büyük projede düzen kurar. `TYPE` yalnız veri alanlarını toplarken, `CLASS` veriyle davranışı aynı çatıya alır. `INTERFACE` sözleşme kurar: bu sınıf şu işleri yapmayı vaat eder. `PUBLIC`, `PRIVATE`, `PROTECTED` gibi erişim sözcükleri kimin neyi görebileceğini anlatır. `CONSTRUCTOR` nesne doğarken, `DESTRUCTOR` nesne giderken çalışır. `VIRTUAL` ve `OVERRIDE` aynı işin farklı sınıflarda farklı yapılmasını sağlar. Genç programcı için akıllı hile şudur: önce TYPE ile sade veri modelini kur, sonra gerçekten davranış gerekiyorsa CLASS'a geç; her şeyi sınıf yapma, ama sınıfsız da büyük sistem yazmaya çalışma.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|TYPE|TYPE Ad ... END TYPE|Kayıt biçiminde veri alanları toplar.|
|CLASS|CLASS Ad ... END CLASS|Veri ve davranışı aynı nesne kalıbında toplar.|
|INTERFACE|INTERFACE Ad ... END INTERFACE|Bir sınıfın yerine getireceği yöntem sözleşmesini tanımlar.|
|IMPLEMENTS|CLASS Ad IMPLEMENTS Arayuz|Sınıfın arayüz sözleşmesini üstlendiğini belirtir.|
|METHOD|METHOD Ad(...) AS Tip|Sınıf içindeki işlevi tanımlar.|
|SIHIRLIMETOT|SIHIRLIMETOT Ad(...)|Özel davranışlı sihirli yöntem tanımlar.|
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

#### TYPE
**Sözdizimi:** `TYPE Ad ... END TYPE`  
**Ne işe yarar:** Kayıt biçiminde veri alanları toplar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
TYPE Nokta
  x AS F64
  y AS F64
END TYPE
```
#### CLASS
**Sözdizimi:** `CLASS Ad ... END CLASS`  
**Ne işe yarar:** Veri ve davranışı aynı nesne kalıbında toplar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
CLASS Sensor
  PROPERTY Deger AS F64
END CLASS
```
#### INTERFACE
**Sözdizimi:** `INTERFACE Ad ... END INTERFACE`  
**Ne işe yarar:** Bir sınıfın yerine getireceği yöntem sözleşmesini tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
INTERFACE Okunur
  METHOD Oku() AS F64
END INTERFACE
```
#### IMPLEMENTS
**Sözdizimi:** `CLASS Ad IMPLEMENTS Arayuz`  
**Ne işe yarar:** Sınıfın arayüz sözleşmesini üstlendiğini belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
CLASS Sensor IMPLEMENTS Okunur
```
#### METHOD
**Sözdizimi:** `METHOD Ad(...) AS Tip`  
**Ne işe yarar:** Sınıf içindeki işlevi tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
METHOD Oku() AS F64: RETURN Deger: END METHOD
```
#### SIHIRLIMETOT
**Sözdizimi:** `SIHIRLIMETOT Ad(...)`  
**Ne işe yarar:** Özel davranışlı sihirli yöntem tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
SIHIRLIMETOT __str__() AS STRING
```
#### MAGIC
**Sözdizimi:** `MAGIC Ad(...)`  
**Ne işe yarar:** Sihirli yöntem için kısa/alternatif yazım sağlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
MAGIC ToString() AS STRING
```
#### VIRTUAL
**Sözdizimi:** `VIRTUAL METHOD Ad(...)`  
**Ne işe yarar:** Alt sınıfın değiştirebileceği yöntem bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
VIRTUAL METHOD Ciz()
```
#### OVERRIDE
**Sözdizimi:** `OVERRIDE METHOD Ad(...)`  
**Ne işe yarar:** Üst sınıftaki yöntemi bilinçli olarak değiştirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
OVERRIDE METHOD Ciz()
```
#### CONSTRUCTOR
**Sözdizimi:** `CONSTRUCTOR(...)`  
**Ne işe yarar:** Nesne oluşurken çalışan kurucu bölümdür.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
CONSTRUCTOR(v AS F64): Deger=v: END CONSTRUCTOR
```
#### DESTRUCTOR
**Sözdizimi:** `DESTRUCTOR()`  
**Ne işe yarar:** Nesne yok olurken temizlik yapar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
DESTRUCTOR(): PRINT "kapanis": END DESTRUCTOR
```
#### NEW
**Sözdizimi:** `NEW Sinif(argler)`  
**Ne işe yarar:** Yeni nesne oluşturur.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
DIM s AS Sensor = NEW Sensor(12.5)
```
#### DELETE
**Sözdizimi:** `DELETE nesne`  
**Ne işe yarar:** Nesne/ayrılmış kaynağı bırakır.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
DELETE s
```
#### ABSTRACT
**Sözdizimi:** `ABSTRACT CLASS Ad`  
**Ne işe yarar:** Doğrudan üretilmeyen temel sınıf tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
ABSTRACT CLASS Sekil
```
#### FINAL
**Sözdizimi:** `FINAL CLASS Ad | FINAL METHOD Ad`  
**Ne işe yarar:** Daha fazla miras/değiştirme yapılmasını engeller.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
FINAL METHOD Kimlik() AS STRING
```
#### SEALED
**Sözdizimi:** `SEALED CLASS Ad`  
**Ne işe yarar:** Kapatılmış sınıf bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
SEALED CLASS Ayar
```
#### STATIC
**Sözdizimi:** `STATIC alan AS Tip | STATIC METHOD Ad`  
**Ne işe yarar:** Sınıfa ait tek ortak alan/yöntem tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
STATIC Sayac AS I32
```
#### PROPERTY
**Sözdizimi:** `PROPERTY Ad AS Tip`  
**Ne işe yarar:** Nesne alanını kontrollü özellik olarak tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
PROPERTY Ad AS STRING
```
#### OPERATOR
**Sözdizimi:** `OPERATOR +(a,b)`  
**Ne işe yarar:** Sınıf için işlemci davranışı tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
OPERATOR +(a AS Vektor, b AS Vektor)
```
#### MIXIN
**Sözdizimi:** `MIXIN Ad`  
**Ne işe yarar:** Bir sınıfa ek davranış karışımı ekler.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
MIXIN Loglanabilir
```
#### DECORATOR
**Sözdizimi:** `DECORATOR Ad`  
**Ne işe yarar:** Yordam/sınıf etrafına ek davranış sarar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
DECORATOR ZamanOlc
```
#### PUBLIC
**Sözdizimi:** `PUBLIC ad`  
**Ne işe yarar:** Dışarıdan erişilebilir üye bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
PUBLIC METHOD Oku()
```
#### PRIVATE
**Sözdizimi:** `PRIVATE ad`  
**Ne işe yarar:** Sadece kendi sınıf/modülü içinden erişilir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
PRIVATE hamDeger AS F64
```
#### PROTECTED
**Sözdizimi:** `PROTECTED ad`  
**Ne işe yarar:** Kendi sınıfı ve alt sınıflar erişir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
PROTECTED id AS I32
```
#### RESTRICTED
**Sözdizimi:** `RESTRICTED ad`  
**Ne işe yarar:** Daraltılmış erişim kuralı belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
RESTRICTED token AS STRING
```
#### FRIEND
**Sözdizimi:** `FRIEND MODULE Ad`  
**Ne işe yarar:** Belirli modül/sınıfa özel erişim verir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
FRIEND MODULE Testler
```
#### READONLY
**Sözdizimi:** `READONLY ad AS Tip`  
**Ne işe yarar:** Dışarıdan değiştirilemeyen okuma alanı bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
READONLY Id AS I64
```
#### MUTABLE
**Sözdizimi:** `MUTABLE ad AS Tip`  
**Ne işe yarar:** Normalde sabit bağlamda bile değişebilir alan belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
MUTABLE Cache AS DICT
```
#### IMMUTABLE
**Sözdizimi:** `IMMUTABLE ad AS Tip`  
**Ne işe yarar:** Değişmez veri/nesne niyeti belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
IMMUTABLE Ayar AS STRING
```
**Birlikte kullanım örneği — ölçüm nesnesi:**
```uxbasic
CLASS Olcum
  PUBLIC PROPERTY Ad AS STRING
  PRIVATE PROPERTY Deger AS F64
  CONSTRUCTOR(a AS STRING, d AS F64)
    Ad = a: Deger = d
  END CONSTRUCTOR
  METHOD GecerliMi() AS BOOLEAN
    IF Deger >= 0 THEN RETURN TRUE ELSE RETURN FALSE END IF
  END METHOD
END CLASS
DIM o AS Olcum = NEW Olcum("pH", 7.2)
IF o.GecerliMi() THEN PRINT "gecerli"
```

### Değişken ve bellek

Değişken ve bellek komutları verinin adını, tipini ve yerini belirler. `DIM` bir kutu açar, `AS` kutunun türünü söyler, `CONST` değişmeyecek değeri korur, `REDIM` büyüyen diziye yeni yer açar. İyi programda değişken adı, ne tuttuğunu anlatır; `x` yerine `phDegeri`, `toplamAgirlik`, `satirSayisi` yazmak hatayı azaltır. Tip sınırı önemlidir: 0-255 arası için `U8`, günlük sayaç için `I32`, çok büyük dosya sayacı için `I64`, bilimsel ölçüm için `F64`, yüksek duyarlık için `BIGD` veya `BIGF` seçilir. Genç programcı erken öğrenmelidir: yanlış tip seçimi bazen hata vermez, sessizce yanlış sonuç üretir.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|DIM|DIM ad AS Tip|Yeni değişken, dizi veya nesne başvurusu bildirir.|
|REDIM|REDIM dizi(yeniBoyut)|Diziyi yeni boyuta taşır.|
|AS|ad AS Tip|Bir adın tipini belirtir.|
|CONST|CONST ad AS Tip = değer|Değişmeyen sabit tanımlar.|

#### DIM
**Sözdizimi:** `DIM ad AS Tip`  
**Ne işe yarar:** Yeni değişken, dizi veya nesne başvurusu bildirir.  
**Nerede kullanılır:** Her veri işi DIM ile başlar; ad, tip ve bellek düzeni görünür olur.

```uxbasic
DIM toplam AS F64
toplam = 0
```
#### REDIM
**Sözdizimi:** `REDIM dizi(yeniBoyut)`  
**Ne işe yarar:** Diziyi yeni boyuta taşır.  
**Nerede kullanılır:** Önceden eleman sayısı bilinmeyen veri girişlerinde kullanılır.

```uxbasic
REDIM olcum(100)
```
#### AS
**Sözdizimi:** `ad AS Tip`  
**Ne işe yarar:** Bir adın tipini belirtir.  
**Nerede kullanılır:** Okunurluk ve dış çağrı uyumu için kullanılır.

```uxbasic
DIM yas AS I32
```
#### CONST
**Sözdizimi:** `CONST ad AS Tip = değer`  
**Ne işe yarar:** Değişmeyen sabit tanımlar.  
**Nerede kullanılır:** Ayar, sınır ve fiziksel sabitlerde kullanılır.

```uxbasic
CONST PI AS F64 = 3.14159265
```
**Birlikte kullanım örneği — tip sınırı ve doğru değişken seçimi:**
```uxbasic
CONST MAX_SATIR AS I32 = 1000
DIM satirSayisi AS I32
DIM ph AS F64
DIM etiket AS STRING
DIM hassas AS BIGD(80)
etiket = "deneme-1"
ph = 7.15
IF ph >= 6.5 AND ph <= 8.5 THEN PRINT etiket; " uygun"
```

### Tipler

Tip sözcükleri değişkenin içinde hangi tür veri tutulacağını belirler. Tam sayılar sayaç ve indeks için, ondalıklı sayılar ölçüm ve hesap için, metin tipi rapor ve kullanıcı girdisi için, koleksiyon tipleri çoklu veri için kullanılır. `PTR` ve `STRPTR` gibi işaretçi tipleri dış kütüphaneye bellek adresi vermek içindir; aceleyle kullanılmaz. `BIGF`, `BIGD`, `BALL`, `F80`, `F128` yüksek duyarlık ve özel matematik için düşünülür. Tip seçimi yalnız bellek konusu değildir; aynı zamanda niyet beyanıdır.

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

#### BYTE
**Sözdizimi:** `DIM ad AS BYTE`  
**Ne işe yarar:** tek baytlık ham veri tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS BYTE
PRINT deger
```
#### I8
**Sözdizimi:** `DIM ad AS I8`  
**Ne işe yarar:** -128 ile 127 arasında işaretli 8 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS I8
PRINT deger
```
#### U8
**Sözdizimi:** `DIM ad AS U8`  
**Ne işe yarar:** 0 ile 255 arasında işaretsiz 8 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS U8
PRINT deger
```
#### I16
**Sözdizimi:** `DIM ad AS I16`  
**Ne işe yarar:** işaretli 16 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS I16
PRINT deger
```
#### U16
**Sözdizimi:** `DIM ad AS U16`  
**Ne işe yarar:** işaretsiz 16 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS U16
PRINT deger
```
#### I32
**Sözdizimi:** `DIM ad AS I32`  
**Ne işe yarar:** günlük sayaç ve indeksler için 32 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS I32
PRINT deger
```
#### U32
**Sözdizimi:** `DIM ad AS U32`  
**Ne işe yarar:** negatif olmayan 32 bit sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS U32
PRINT deger
```
#### I64
**Sözdizimi:** `DIM ad AS I64`  
**Ne işe yarar:** büyük sayaç ve dosya boyutu için 64 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS I64
PRINT deger
```
#### U64
**Sözdizimi:** `DIM ad AS U64`  
**Ne işe yarar:** çok büyük pozitif sayaçlar için 64 bit sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS U64
PRINT deger
```
#### F32
**Sözdizimi:** `DIM ad AS F32`  
**Ne işe yarar:** tek duyarlıklı ondalıklı sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS F32
PRINT deger
```
#### F64
**Sözdizimi:** `DIM ad AS F64`  
**Ne işe yarar:** çift duyarlıklı ondalıklı sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS F64
PRINT deger
```
#### F80
**Sözdizimi:** `DIM ad AS F80`  
**Ne işe yarar:** genişletilmiş kayan nokta sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS F80
PRINT deger
```
#### F128
**Sözdizimi:** `DIM ad AS F128`  
**Ne işe yarar:** 128 bit yüksek duyarlıklı sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS F128
PRINT deger
```
#### BIGF
**Sözdizimi:** `DIM ad AS BIGF`  
**Ne işe yarar:** çok büyük/yüksek duyarlıklı ikili kayan sayı ailesidir.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS BIGF
PRINT deger
```
#### BIGD
**Sözdizimi:** `DIM ad AS BIGD`  
**Ne işe yarar:** çok basamaklı ondalık sayı ailesidir.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS BIGD
PRINT deger
```
#### BALL
**Sözdizimi:** `DIM ad AS BALL`  
**Ne işe yarar:** aralık/top mantığıyla güvenli yaklaşık sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS BALL
PRINT deger
```
#### BOOLEAN
**Sözdizimi:** `DIM ad AS BOOLEAN`  
**Ne işe yarar:** TRUE/FALSE doğru-yanlış değeri tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS BOOLEAN
PRINT deger
```
#### STRING
**Sözdizimi:** `DIM ad AS STRING`  
**Ne işe yarar:** metin tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS STRING
PRINT deger
```
#### OBJECT
**Sözdizimi:** `DIM ad AS OBJECT`  
**Ne işe yarar:** nesne başvurusu tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS OBJECT
PRINT deger
```
#### PTR
**Sözdizimi:** `DIM ad AS PTR`  
**Ne işe yarar:** ham adres veya dış kütüphane işaretçisi tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS PTR
PRINT deger
```
#### STRPTR
**Sözdizimi:** `DIM ad AS STRPTR`  
**Ne işe yarar:** metnin bellek adresini dış çağrıya verir.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS STRPTR
PRINT deger
```
#### ARRAY
**Sözdizimi:** `DIM ad AS ARRAY`  
**Ne işe yarar:** sabit veya yeniden boyutlanabilir dizi tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS ARRAY
PRINT deger
```
#### LIST
**Sözdizimi:** `DIM ad AS LIST`  
**Ne işe yarar:** sıralı, büyüyebilen liste tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS LIST
PRINT deger
```
#### DICT
**Sözdizimi:** `DIM ad AS DICT`  
**Ne işe yarar:** anahtar/değer sözlüğü tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS DICT
PRINT deger
```
#### SET
**Sözdizimi:** `DIM ad AS SET`  
**Ne işe yarar:** tekrarsız küme tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS SET
PRINT deger
```
**Birlikte kullanım örneği — tip sınırı ve doğru değişken seçimi:**
```uxbasic
CONST MAX_SATIR AS I32 = 1000
DIM satirSayisi AS I32
DIM ph AS F64
DIM etiket AS STRING
DIM hassas AS BIGD(80)
etiket = "deneme-1"
ph = 7.15
IF ph >= 6.5 AND ph <= 8.5 THEN PRINT etiket; " uygun"
```

### Varsayılan tip

Varsayılan tip komutları eski BASIC geleneğinden gelir. Harf aralığına göre değişken tipi seçer. Modern uXBasic kodunda açık `DIM ad AS Tip` daha okunur ve güvenlidir. Yine de eski kaynakları taşırken veya kısa deneme yazarken bu komutlar işe yarar. Genç programcı bunları tanımalı ama büyük projede açık tip yazmayı alışkanlık yapmalıdır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|DEFINT|DEFINT A-Z|harfle başlayan adsız tipleri I32 yapar|
|DEFLNG|DEFLNG A-Z|harfle başlayan adsız tipleri I64 yapar|
|DEFSNG|DEFSNG A-Z|harfle başlayan adsız tipleri F32 yapar|
|DEFDBL|DEFDBL A-Z|harfle başlayan adsız tipleri F64 yapar|
|DEFEXT|DEFEXT A-Z|harfle başlayan adsız tipleri geniş ondalık yapar|
|DEFSTR|DEFSTR A-Z|harfle başlayan adsız tipleri STRING yapar|
|DEFBYT|DEFBYT A-Z|harfle başlayan adsız tipleri BYTE yapar|

#### DEFINT
**Sözdizimi:** `DEFINT A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri I32 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFINT A-Z
DIM sayac
```
#### DEFLNG
**Sözdizimi:** `DEFLNG A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri I64 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFLNG A-Z
DIM sayac
```
#### DEFSNG
**Sözdizimi:** `DEFSNG A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri F32 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFSNG A-Z
DIM sayac
```
#### DEFDBL
**Sözdizimi:** `DEFDBL A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri F64 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFDBL A-Z
DIM sayac
```
#### DEFEXT
**Sözdizimi:** `DEFEXT A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri geniş ondalık yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFEXT A-Z
DIM sayac
```
#### DEFSTR
**Sözdizimi:** `DEFSTR A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri STRING yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFSTR A-Z
DIM sayac
```
#### DEFBYT
**Sözdizimi:** `DEFBYT A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri BYTE yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFBYT A-Z
DIM sayac
```

### Modül ve kaynak

Modül ve kaynak komutları büyük projeyi dosyalara böler. `INCLUDE` hazır başlık ve modül yüzeyini içeri alır, `IMPORT` C/C++/ASM kaynaklarını derleme işine bağlar, `NAMESPACE` ve `MODULE` ad karmaşasını önler. `USING` uzun adları kısa kullanmayı sağlar, `ALIAS` okunur adlar kurar. `INLINE` küçük dış dil parçalarını kaynak içinde taşır; ama büyük dış kod ayrı dosyada ve `IMPORT` ile daha temizdir. Genç programcı için kural: bir dosya çok uzadıysa önce modüle böl; aynı adlar çakışmaya başladıysa ad alanı aç; dış kütüphane çağrısı çirkinleştiyse sarmalayıcı yaz.

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

#### INCLUDE
**Sözdizimi:** `INCLUDE "dosya.uxbh"`  
**Ne işe yarar:** Başka uXBasic başlık/destek dosyasını kaynak içine katar.  
**Nerede kullanılır:** Ortak yordamları, kütüphane imzalarını ve tip tanımlarını paylaşmak için kullanılır.

```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
```
#### IMPORT
**Sözdizimi:** `IMPORT(C,"dosya.c") | IMPORT(CPP,"dosya.cpp") | IMPORT(ASM,"dosya.asm")`  
**Ne işe yarar:** Derleme zamanında C, C++ veya ASM kaynak dosyasını projeye bağlar.  
**Nerede kullanılır:** DLL değil kaynak ekleme işidir; dış çalışma zamanı ile çekirdeği büyütmeden güç verir.

```uxbasic
IMPORT(C,"runtime/hizli.c")
```
#### MAIN
**Sözdizimi:** `MAIN ... END MAIN`  
**Ne işe yarar:** Programın ana giriş bölümünü belirtir.  
**Nerede kullanılır:** Büyük projede nereden başlanacağını görünür yapar.

```uxbasic
MAIN
  PRINT "basladi"
END MAIN
```
#### NAMESPACE
**Sözdizimi:** `NAMESPACE Ad ... END NAMESPACE`  
**Ne işe yarar:** Adları çakışmadan ayıran alan açar.  
**Nerede kullanılır:** Aynı isimli fonksiyonları farklı alanlarda tutar.

```uxbasic
NAMESPACE Lab
  SUB Yaz(): PRINT "lab": END SUB
END NAMESPACE
```
#### MODULE
**Sözdizimi:** `MODULE Ad ... END MODULE`  
**Ne işe yarar:** Bir dosya veya iş ailesini modül olarak toplar.  
**Nerede kullanılır:** Kütüphane, araç ve büyük uygulama parçalarında kullanılır.

```uxbasic
MODULE Rapor
  SUB Baslik(): PRINT "RAPOR": END SUB
END MODULE
```
#### USING
**Sözdizimi:** `USING MODULE Ad | USING NAMESPACE Ad`  
**Ne işe yarar:** Bir modül/alan adını kısa kullanım için etkinleştirir.  
**Nerede kullanılır:** Sürekli uzun ad yazmayı azaltır; ama çakışma varsa tam ad kullanılır.

```uxbasic
USING MODULE uxstats
```
#### ALIAS
**Sözdizimi:** `ALIAS yeniAd = eskiAd | ALIAS KISA AS uzunAd`  
**Ne işe yarar:** Uzun çağrıya kısa veya yerel ad verir.  
**Nerede kullanılır:** Okunabilirlik ve dış kütüphane sarmalama için kullanılır.

```uxbasic
ALIAS ORT AS uxstats.mean
```
#### INLINE
**Sözdizimi:** `INLINE C ... END INLINE | INLINE ASM ... END INLINE`  
**Ne işe yarar:** uXBasic dosyası içinde küçük C/C++/ASM bölümü taşır.  
**Nerede kullanılır:** Kısa ve özel hızlandırma parçaları için kullanılır.

```uxbasic
INLINE C
  int hizli(int x){return x*x;}
END INLINE
```
**Birlikte kullanım örneği — modül ve dış kaynak düzeni:**
```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
IMPORT(C, "runtime_ext/kucuk_hizlandirici.c")
NAMESPACE Lab
  ALIAS ORT AS uxstats_mean_f64
  SUB RaporYaz()
    PRINT "Laboratuvar raporu"
  END SUB
END NAMESPACE
USING NAMESPACE Lab
CALL RaporYaz()
```

### Girdi çıktı ve ekran

Girdi çıktı komutları programın insanla, dosyayla ve terminalle konuşmasını sağlar. `PRINT` yalnız ekrana yazmaz; dosyaya rapor da yazabilir. `INPUT` kullanıcıdan veya dosyadan veri alır. `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK` dosya işlerinin temelidir. `CLS`, `COLOR`, `LOCATE` terminal arayüzünü düzenler. Programlamayı yeni öğrenen biri için dosya işlemleri çok öğreticidir; çünkü veri dışarıdan gelir, satır satır okunur, kontrol edilir, sonuç rapora yazılır. Her açılan dosyayı kapatmak, her okunan değeri doğrulamak ve her hatayı kullanıcıya anlaşılır söylemek gerekir.

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

#### PRINT
**Sözdizimi:** `PRINT ifade[, ifade] | PRINT #dosya, ifade`  
**Ne işe yarar:** Ekrana veya dosyaya metin/sayı yazar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
PRINT "sonuc="; toplam
```
#### INPUT
**Sözdizimi:** `INPUT değişken | INPUT #dosya, değişken`  
**Ne işe yarar:** Kullanıcıdan veya dosyadan veri okur.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
INPUT yas
```
#### OPEN
**Sözdizimi:** `OPEN "dosya" FOR INPUT|OUTPUT|APPEND AS #no`  
**Ne işe yarar:** Dosyayı okuma/yazma/ekleme için açar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
OPEN "rapor.txt" FOR OUTPUT AS #1
```
#### CLOSE
**Sözdizimi:** `CLOSE #no`  
**Ne işe yarar:** Açık dosyayı kapatır.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
CLOSE #1
```
#### GET
**Sözdizimi:** `GET #no, konum, değişken`  
**Ne işe yarar:** Dosyadan ham veri okur.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
GET #1, 1, b
```
#### PUT
**Sözdizimi:** `PUT #no, konum, değişken`  
**Ne işe yarar:** Dosyaya ham veri yazar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
PUT #1, 1, b
```
#### SEEK
**Sözdizimi:** `SEEK #no, konum`  
**Ne işe yarar:** Dosya okuma/yazma konumunu değiştirir.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
SEEK #1, 128
```
#### CLS
**Sözdizimi:** `CLS`  
**Ne işe yarar:** Ekranı temizler.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
CLS
```
#### COLOR
**Sözdizimi:** `COLOR ön[, arka]`  
**Ne işe yarar:** Yazı/arka plan rengini ayarlar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
COLOR 10,0
```
#### LOCATE
**Sözdizimi:** `LOCATE satır, sütun`  
**Ne işe yarar:** Ekran imlecini konuma taşır.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
LOCATE 5,10: PRINT "menu"
```
**Birlikte kullanım örneği — belge oluşturma:**
```uxbasic
CLS
COLOR 10, 0
LOCATE 1, 1: PRINT "Rapor hazirlaniyor"
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "baslik;deger"
PRINT #1, "ph;7.2"
CLOSE #1
PRINT "rapor yazildi"
```

### İşleç

İşleçler küçük görünür ama programın karar ve hesap kaslarıdır. `AND`, `OR`, `NOT` koşul birleştirir; `XOR` özel fark mantığı verir; `MOD` kalan hesabı yapar; `SHL`, `SHR`, `ROL`, `ROR` bit düzeyinde hızlı iş yapar. Genç programcı önce koşul işleçlerini öğrenmeli, sonra bit işleçlerine geçmelidir. Bit işleçleri bayrak, renk, donanım, sıkıştırma ve hızlı maske işlerinde işe yarar. Püf noktası: karmaşık koşulu tek satıra gömme; ara değişkenle adlandır, sonra IF içinde oku.

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

#### AND
**Sözdizimi:** `a AND b`  
**Ne işe yarar:** iki koşul/bit birlikte doğruysa doğru verir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) AND TRUE THEN PRINT "kontrol"
```
#### OR
**Sözdizimi:** `a OR b`  
**Ne işe yarar:** koşullardan biri doğruysa doğru verir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) OR TRUE THEN PRINT "kontrol"
```
#### NOT
**Sözdizimi:** `NOT koşul`  
**Ne işe yarar:** koşulu tersine çevirir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) AND TRUE THEN PRINT "kontrol"
```
#### XOR
**Sözdizimi:** `a XOR b`  
**Ne işe yarar:** yalnız biri doğruysa doğru verir veya bitlerde özel fark alır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) XOR TRUE THEN PRINT "kontrol"
```
#### MOD
**Sözdizimi:** `a MOD b`  
**Ne işe yarar:** bölme kalanı verir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) MOD TRUE THEN PRINT "kontrol"
```
#### SHL
**Sözdizimi:** `a SHL b`  
**Ne işe yarar:** bitleri sola kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) SHL TRUE THEN PRINT "kontrol"
```
#### SHR
**Sözdizimi:** `a SHR b`  
**Ne işe yarar:** bitleri sağa kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) SHR TRUE THEN PRINT "kontrol"
```
#### ROL
**Sözdizimi:** `a ROL b`  
**Ne işe yarar:** bitleri döndürerek sola kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) ROL TRUE THEN PRINT "kontrol"
```
#### ROR
**Sözdizimi:** `a ROR b`  
**Ne işe yarar:** bitleri döndürerek sağa kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) ROR TRUE THEN PRINT "kontrol"
```
**Birlikte kullanım örneği — bayrak ve koşul:**
```uxbasic
DIM yetki AS U32
yetki = 1 SHL 2
IF (yetki AND 4) <> 0 THEN PRINT "yazma izni var"
IF NOT (yetki = 0) THEN PRINT "en az bir izin var"
PRINT 17 MOD 5
```

### Yerel fonksiyon

Yerel fonksiyonlar küçük yardımcı makinelerdir. Metni parçalar, sayıyı dönüştürür, zamanı ölçer, dosya sonunu denetler, tuş okur, bellek adresi verir veya matematik hesaplar. Bunları tek tek ezberlemek yerine ailelere ayır: metin ailesi, sayı ailesi, trigonometri ailesi, dosya ailesi, klavye ailesi, bellek adresi ailesi. Genç programcı `VAL` ve `STR` ile veri dönüşümünü, `LEN` ve `MID` ile metin parçalamayı, `TIMER` ile hız ölçmeyi, `EOF` ile güvenli dosya döngüsünü erken öğrenmelidir. Fonksiyon sonucu her zaman bir değişkene alınabilir; böylece hata ayıklamak kolaylaşır.

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

#### SETSTRINGSIZE
**Sözdizimi:** `sonuc = SETSTRINGSIZE metin, uzunluk`  
**Ne işe yarar:** Metin değişkeni için istenen uzunlukta alan hazırlar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SETSTRINGSIZE metin, uzunluk
PRINT sonuc
```
#### TIMER
**Sözdizimi:** `sonuc = TIMER()`  
**Ne işe yarar:** Geçen zamanı saniye türünden verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = TIMER()
PRINT sonuc
```
#### LOF
**Sözdizimi:** `sonuc = LOF(#no)`  
**Ne işe yarar:** Açık dosyanın uzunluğunu verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LOF(#no)
PRINT sonuc
```
#### EOF
**Sözdizimi:** `sonuc = EOF(#no)`  
**Ne işe yarar:** Dosya sonuna gelinip gelinmediğini söyler.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = EOF(#no)
PRINT sonuc
```
#### LEN
**Sözdizimi:** `sonuc = LEN(metin)`  
**Ne işe yarar:** Metnin veya verinin uzunluğunu verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LEN(metin)
PRINT sonuc
```
#### MID
**Sözdizimi:** `sonuc = MID(metin, başla, uzunluk)`  
**Ne işe yarar:** Metnin içinden parça alır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = MID(metin, başla, uzunluk)
PRINT sonuc
```
#### STR
**Sözdizimi:** `sonuc = STR(sayi)`  
**Ne işe yarar:** Sayıyı metne çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = STR(sayi)
PRINT sonuc
```
#### VAL
**Sözdizimi:** `sonuc = VAL(metin)`  
**Ne işe yarar:** Metni sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = VAL(metin)
PRINT sonuc
```
#### ABS
**Sözdizimi:** `sonuc = ABS(x)`  
**Ne işe yarar:** Mutlak değer alır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = ABS(x)
PRINT sonuc
```
#### INT
**Sözdizimi:** `sonuc = INT(x)`  
**Ne işe yarar:** Ondalıklı sayının tam kısmını alır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = INT(x)
PRINT sonuc
```
#### UCASE
**Sözdizimi:** `sonuc = UCASE(metin)`  
**Ne işe yarar:** Metni büyük harfe çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = UCASE(metin)
PRINT sonuc
```
#### LCASE
**Sözdizimi:** `sonuc = LCASE(metin)`  
**Ne işe yarar:** Metni küçük harfe çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LCASE(metin)
PRINT sonuc
```
#### ASC
**Sözdizimi:** `sonuc = ASC(karakter)`  
**Ne işe yarar:** Karakterin sayı kodunu verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = ASC(karakter)
PRINT sonuc
```
#### CHR
**Sözdizimi:** `sonuc = CHR(kod)`  
**Ne işe yarar:** Sayı kodundan karakter üretir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CHR(kod)
PRINT sonuc
```
#### LTRIM
**Sözdizimi:** `sonuc = LTRIM(metin)`  
**Ne işe yarar:** Sol boşlukları temizler.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LTRIM(metin)
PRINT sonuc
```
#### RTRIM
**Sözdizimi:** `sonuc = RTRIM(metin)`  
**Ne işe yarar:** Sağ boşlukları temizler.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = RTRIM(metin)
PRINT sonuc
```
#### SPACE
**Sözdizimi:** `sonuc = SPACE(n)`  
**Ne işe yarar:** Belirli sayıda boşluk üretir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SPACE(n)
PRINT sonuc
```
#### SGN
**Sözdizimi:** `sonuc = SGN(x)`  
**Ne işe yarar:** Sayının işaretini verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SGN(x)
PRINT sonuc
```
#### SQRT
**Sözdizimi:** `sonuc = SQRT(x)`  
**Ne işe yarar:** Karekök hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SQRT(x)
PRINT sonuc
```
#### SIN
**Sözdizimi:** `sonuc = SIN(x)`  
**Ne işe yarar:** Sinüs hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SIN(x)
PRINT sonuc
```
#### COS
**Sözdizimi:** `sonuc = COS(x)`  
**Ne işe yarar:** Kosinüs hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = COS(x)
PRINT sonuc
```
#### TAN
**Sözdizimi:** `sonuc = TAN(x)`  
**Ne işe yarar:** Tanjant hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = TAN(x)
PRINT sonuc
```
#### ATN
**Sözdizimi:** `sonuc = ATN(x)`  
**Ne işe yarar:** Arktanjant hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = ATN(x)
PRINT sonuc
```
#### EXP
**Sözdizimi:** `sonuc = EXP(x)`  
**Ne işe yarar:** e üzeri x hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = EXP(x)
PRINT sonuc
```
#### LOG
**Sözdizimi:** `sonuc = LOG(x)`  
**Ne işe yarar:** Doğal logaritma hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LOG(x)
PRINT sonuc
```
#### INKEY
**Sözdizimi:** `sonuc = INKEY()`  
**Ne işe yarar:** Basılmış tuşu beklemeden okur.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = INKEY()
PRINT sonuc
```
#### GETKEY
**Sözdizimi:** `sonuc = GETKEY()`  
**Ne işe yarar:** Tuş bekler ve okur.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = GETKEY()
PRINT sonuc
```
#### VARPTR
**Sözdizimi:** `sonuc = VARPTR(degisken)`  
**Ne işe yarar:** Değişkenin bellek adresini verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = VARPTR(degisken)
PRINT sonuc
```
#### SADD
**Sözdizimi:** `sonuc = SADD(metin)`  
**Ne işe yarar:** Metin içeriğinin adresini verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SADD(metin)
PRINT sonuc
```
#### LPTR
**Sözdizimi:** `sonuc = LPTR(degisken)`  
**Ne işe yarar:** Uzun adres/işaretçi değeri verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LPTR(degisken)
PRINT sonuc
```
#### CODEPTR
**Sözdizimi:** `sonuc = CODEPTR(yordam)`  
**Ne işe yarar:** Yordamın kod adresini verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CODEPTR(yordam)
PRINT sonuc
```
#### SIZEOF
**Sözdizimi:** `sonuc = SIZEOF(Tip|degisken)`  
**Ne işe yarar:** Tip veya değişken boyutunu bayt olarak verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SIZEOF(Tip|degisken)
PRINT sonuc
```
#### OFFSETOF
**Sözdizimi:** `sonuc = OFFSETOF(Tip, alan)`  
**Ne işe yarar:** Kayıt içindeki alanın başlangıç uzaklığını verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = OFFSETOF(Tip, alan)
PRINT sonuc
```
#### CINT
**Sözdizimi:** `sonuc = CINT(x)`  
**Ne işe yarar:** Değeri tam sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CINT(x)
PRINT sonuc
```
#### CLNG
**Sözdizimi:** `sonuc = CLNG(x)`  
**Ne işe yarar:** Değeri uzun tam sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CLNG(x)
PRINT sonuc
```
#### CDBL
**Sözdizimi:** `sonuc = CDBL(x)`  
**Ne işe yarar:** Değeri çift duyarlıklı sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CDBL(x)
PRINT sonuc
```
#### CSNG
**Sözdizimi:** `sonuc = CSNG(x)`  
**Ne işe yarar:** Değeri tek duyarlıklı sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CSNG(x)
PRINT sonuc
```
#### FIX
**Sözdizimi:** `sonuc = FIX(x)`  
**Ne işe yarar:** Ondalık kısmı keser.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = FIX(x)
PRINT sonuc
```
#### SQR
**Sözdizimi:** `sonuc = SQR(x)`  
**Ne işe yarar:** Karekök için BASIC uyumlu addır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SQR(x)
PRINT sonuc
```
#### RND
**Sözdizimi:** `sonuc = RND()`  
**Ne işe yarar:** Rastgele sayı üretir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = RND()
PRINT sonuc
```
#### RANDOMIZE
**Sözdizimi:** `sonuc = RANDOMIZE [tohum]`  
**Ne işe yarar:** Rastgele sayı üreticisini tohumlar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = RANDOMIZE [tohum]
PRINT sonuc
```
**Birlikte kullanım örneği — metni sayıya çevirip raporlamak:**
```uxbasic
INPUT satir
satir = LTRIM(RTRIM(satir))
IF LEN(satir) > 0 THEN
  deger = VAL(satir)
  PRINT "karekok="; SQRT(ABS(deger))
  PRINT "metin="; STR(deger)
END IF
```

### Bellek ve düşük seviye

Bellek komutları güçlü ama keskin araçlardır. `PEEK` ailesi adresten okur, `POKE` ailesi adrese yazar, `MEMCOPY` veri taşır, `MEMFILL` alan doldurur, `INC` ve `DEC` değer artırıp azaltır. Bu komutlar derleyici, gömülü sistem, ikili dosya, hız isteyen tampon ve dış kütüphane köprülerinde işe yarar. Yeni başlayan biri bu komutları normal veri işi için değil, kontrollü deney için kullanmalıdır. Her bellek örneği önce küçük tamponla, sonra ASSERT ile, sonra raporla denenmelidir. Yanlış adres, yanlış uzunluk veya yanlış tip sessizce veri bozabilir.

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

#### PEEKB
**Sözdizimi:** `PEEKB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adresten bayt okur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
PEEKB adres, deger
```
#### PEEKW
**Sözdizimi:** `PEEKW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adresten 16 bit sözcük okur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
PEEKW adres, deger
```
#### PEEKD
**Sözdizimi:** `PEEKD adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adresten 32 bit değer okur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
PEEKD adres, deger
```
#### POKE
**Sözdizimi:** `POKE adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adrese genel değer yazar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
POKE adres, deger
```
#### POKEB
**Sözdizimi:** `POKEB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adrese bayt yazar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
POKEB adres, deger
```
#### POKEW
**Sözdizimi:** `POKEW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adrese 16 bit değer yazar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
POKEW adres, deger
```
#### POKED
**Sözdizimi:** `POKED adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adrese 32 bit değer yazar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
POKED adres, deger
```
#### POKES
**Sözdizimi:** `POKES adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adrese metin/blok yazar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
POKES adres, deger
```
#### MEMCOPYB
**Sözdizimi:** `MEMCOPYB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Bayt blok kopyalar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMCOPYB adres, deger
```
#### MEMCOPYW
**Sözdizimi:** `MEMCOPYW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** 16 bit sözcük blok kopyalar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMCOPYW adres, deger
```
#### MEMCOPYD
**Sözdizimi:** `MEMCOPYD adres[, değer[, uzunluk]]`  
**Ne işe yarar:** 32 bit blok kopyalar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMCOPYD adres, deger
```
#### MEMFILLB
**Sözdizimi:** `MEMFILLB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Belleği bayt değeriyle doldurur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMFILLB adres, deger
```
#### MEMFILLW
**Sözdizimi:** `MEMFILLW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Belleği 16 bit değerle doldurur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMFILLW adres, deger
```
#### MEMFILLD
**Sözdizimi:** `MEMFILLD adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Belleği 32 bit değerle doldurur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMFILLD adres, deger
```
#### SETNEWOFFSET
**Sözdizimi:** `SETNEWOFFSET adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Yeni ayırma ofsetini belirler.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
SETNEWOFFSET adres, deger
```
#### INC
**Sözdizimi:** `INC adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Sayıyı veya adresteki değeri artırır.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
INC adres, deger
```
#### DEC
**Sözdizimi:** `DEC adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Sayıyı veya adresteki değeri azaltır.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
DEC adres, deger
```
**Birlikte kullanım örneği — küçük tampon fikri:**
```uxbasic
DIM adres AS PTR
DIM n AS I32
n = 10
adres = VARPTR(n)
POKED adres, 20
IF PEEKD(adres) = 20 THEN PRINT "tampon degisti"
INC n
DEC n
```

### Listeleme

Listeleme komutları sabit durumları adlandırır. Sayıya anlamlı ad vermek hatayı azaltır. Menü seçenekleri, hata kodları, durumlar ve renkler için çok yararlıdır. Genç programcı enum kullanarak `1`, `2`, `3` gibi sihirli sayıları temiz adlara dönüştürmelidir.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|ENUM|ENUM Ad ... END ENUM|Adlandırılmış sabitler grubu oluşturur.|

#### ENUM
**Sözdizimi:** `ENUM Ad ... END ENUM`  
**Ne işe yarar:** Adlandırılmış sabitler grubu oluşturur.  
**Nerede kullanılır:** Durum, renk, komut kodu gibi sayısal sabitleri okunur adlara bağlar.

```uxbasic
ENUM Durum
  Hazir
  Calisiyor
  Hata
END ENUM
```

## Ön-işleyici komutları

Ön-işleyici komutları program çalışmadan önce çalışır. Kaynağın hangi parçasının derleneceğini, hangi hedefin üretileceğini, hangi HTML/JS/WAT/JSON varlığının paketleneceğini ve hangi güvenlik kuralının uygulanacağını belirler. Bu bölümdeki komutlar normal çalışma zamanı komutu değildir; derleme hazırlığı ve çıktı üretimi içindir.

|No|Komut|Sözdizimi|Görev|
|---|---|---|---|
|1|%%DEFINE|%%DEFINE ...|metinsel tanım veya doğru/yanlış derleme simgesi oluşturur|
|2|%%SET|%%SET ad = değer|üst bilgi değişkeni atar|
|3|%%ALIAS|%%ALIAS eski AS yeni|tek satırlık metin kısaltması kurar: %%ALIAS {old} AS {new}|
|4|%%MACRO|%%MACRO ...|tek satırlık makro veya makro fonksiyon kurar|
|5|%%IF|%%IF koşul ... %%ELIF ... %%ENDIF|koşula göre kaynak bölümünü seçer|
|6|%%IFC|%%IFC ...|metinsel koşul karşılaştırması yapar|
|7|%%FOR|%%FOR ...|derleme zamanında sayısal döngü üretir|
|8|%%FOREACH|%%FOREACH ...|derleme zamanında liste üzerinde döner|
|9|%%REPEAT|%%REPEAT ...|derleme zamanında sabit tekrar üretir|
|10|%%TARGET|%%TARGET js\|wasm\|browser\|native|etkin çıktı hedefini seçer|
|11|%%OUTDIR|%%OUTDIR ...|çıktı dizinini belirler|
|12|%%SECTION|%%SECTION ...|etkin çıktı bölümünü seçer|
|13|%%JS_BEGIN|%%JS_BEGIN ...|JavaScript bloğunu çıktı olarak toplar|
|14|%%JS_LINE|%%JS_LINE console.log("...")|tek JavaScript satırı ekler|
|15|%%JS_FILE|%%JS_FILE ...|dış JavaScript dosyasını kayda alır|
|16|%%WAT_BEGIN|%%WAT_BEGIN ...|WAT bloğunu çıktı olarak toplar|
|17|%%WAT_IMPORT|%%WAT_IMPORT ...|WAT tarafında dış ev sahibi çağrısı bildirir|
|18|%%WAT_EXPORT|%%WAT_EXPORT ...|WAT dışa açılan adını bildirir|
|19|%%WASM_HOST_JS_BEGIN|%%WASM_HOST_JS_BEGIN ...|WASM ev sahibi JavaScript köprüsünü toplar|
|20|%%HTML_BEGIN|%%HTML_BEGIN ...|HTML bloğunu veya dosyasını toplar|
|21|%%HTML_LINE|%%HTML_LINE ...|tek HTML satırı ekler|
|22|%%HTML_SCRIPT|%%HTML_SCRIPT ...|betik etiketi bilgisini üretir|
|23|%%HTML_STYLE|%%HTML_STYLE ...|biçim dosyası etiketi bilgisini üretir|
|24|%%CSS_BEGIN|%%CSS_BEGIN ...|CSS bloğunu veya dosyasını toplar|
|25|%%CSS_LINE|%%CSS_LINE ...|tek CSS satırı ekler|
|26|%%JSON_BEGIN|%%JSON_BEGIN ...|JSON bloğunu veya dosyasını toplar|
|27|%%JSON_SET|%%JSON_SET anahtar = değer|JSON anahtar/değer yazar|
|28|%%MANIFEST_SET|%%MANIFEST_SET ...|yapı bildirgesine anahtar/değer yazar|
|29|%%MANIFEST_REQUIRE|%%MANIFEST_REQUIRE ...|zorunlu çıktı veya bağlantı bildirir|
|30|%%MD_BEGIN|%%MD_BEGIN ...|Markdown bloğunu toplar|
|31|%%MD_FILE|%%MD_FILE ...|Markdown dosyasını kayda alır|
|32|%%ASSET_ROOT|%%ASSET_ROOT ...|varlık kök dizinini belirler|
|33|%%ASSET_COPY|%%ASSET_COPY ...|varlık dosyasını kopyalar veya kayda alır|
|34|%%ASSET_FILE|%%ASSET_FILE ...|genel varlık dosyasını kayda alır|
|35|%%ASSET_IMAGE|%%ASSET_IMAGE ...|görsel varlığı kayda alır|
|36|%%ASSET_AUDIO|%%ASSET_AUDIO ...|ses varlığı kayda alır|
|37|%%ALLOW_RAW_JS|%%ALLOW_RAW_JS ...|ham JavaScript yazmaya izin verir|
|38|%%ALLOW_RAW_WAT|%%ALLOW_RAW_WAT ...|ham WAT yazmaya izin verir|
|39|%%SAFE_PATHS|%%SAFE_PATHS ...|yol güvenliği kuralını belirler|
|40|%%REQUIRE_HOST_BINDING|%%REQUIRE_HOST_BINDING ...|WAT içe çağrıları için ev sahibi bağlantısı ister|
|41|%%ASSERT_META|%%ASSERT_META ...|koşul yanlışsa derleme sırasında hata verir|
|42|%%WARN_META|%%WARN_META ...|derleme sırasında uyarı üretir|
|43|%%IFN|%%IFN ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|44|%%ELIF|%%ELIF ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|45|%%PROFILE|%%PROFILE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|46|%%CONFIG_FILE|%%CONFIG_FILE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|47|%%PATH_ALIAS|%%PATH_ALIAS ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|48|%%LOCK_META|%%LOCK_META ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|49|%%DUMP_META|%%DUMP_META ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|50|%%SOURCE_MAP|%%SOURCE_MAP ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|51|%%EMITNOTE|%%EMITNOTE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|52|%%ENV|%%ENV ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|53|%%DEPRECATED|%%DEPRECATED ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|54|%%TEMPLATE_BEGIN|%%TEMPLATE_BEGIN ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|55|%%TEMPLATE_END|%%TEMPLATE_END ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|56|%%TEMPLATE_USE|%%TEMPLATE_USE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|57|%%MINIFY|%%MINIFY ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|58|%%FINGERPRINT_ASSETS|%%FINGERPRINT_ASSETS ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|59|%%HASHFILE|%%HASHFILE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|60|%%COPY_DIR|%%COPY_DIR ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|61|%%EMBEDTEXT|%%EMBEDTEXT ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|62|%%EMBEDBASE64|%%EMBEDBASE64 ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|63|%%LICENSEFILE|%%LICENSEFILE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|64|%%HTMLIMAGE|%%HTMLIMAGE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|65|%%HTMLAUDIO|%%HTMLAUDIO ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|66|%%CSS_RULE|%%CSS_RULE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|67|%%CSS_IMPORT|%%CSS_IMPORT ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|68|%%MD_SAFE|%%MD_SAFE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|69|%%MD_CSS|%%MD_CSS ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|70|%%BREAK|%%BREAK ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|71|%%CONTINUE|%%CONTINUE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|72|%%INFOMETA|%%INFOMETA ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|

### 1. %%DEFINE
metinsel tanım veya doğru/yanlış derleme simgesi oluşturur. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%DEFINE DEBUG
%%IF DEBUG
PRINT "test modu"
%%ENDIF
```

### 2. %%SET
üst bilgi değişkeni atar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%SET APP_NAME = "Deneme"
%%MANIFEST_SET name = ${APP_NAME}
```

### 3. %%ALIAS
tek satırlık metin kısaltması kurar: %%ALIAS {old} AS {new}. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ALIAS ...
```

### 4. %%MACRO
tek satırlık makro veya makro fonksiyon kurar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MACRO ...
```

### 5. %%IF
koşula göre kaynak bölümünü seçer. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%IF ...
```

### 6. %%IFC
metinsel koşul karşılaştırması yapar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%IFC ...
```

### 7. %%FOR
derleme zamanında sayısal döngü üretir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%FOR ...
```

### 8. %%FOREACH
derleme zamanında liste üzerinde döner. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%FOREACH ...
```

### 9. %%REPEAT
derleme zamanında sabit tekrar üretir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%REPEAT ...
```

### 10. %%TARGET
etkin çıktı hedefini seçer. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%TARGET browser
%%OUTDIR "dist/web"
```

### 11. %%OUTDIR
çıktı dizinini belirler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%OUTDIR ...
```

### 12. %%SECTION
etkin çıktı bölümünü seçer. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%SECTION ...
```

### 13. %%JS_BEGIN
JavaScript bloğunu çıktı olarak toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%JS_BEGIN ...
```

### 14. %%JS_LINE
tek JavaScript satırı ekler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%JS_LINE console.log("uXBasic tarayici hazir");
```

### 15. %%JS_FILE
dış JavaScript dosyasını kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%JS_FILE ...
```

### 16. %%WAT_BEGIN
WAT bloğunu çıktı olarak toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%WAT_BEGIN ...
```

### 17. %%WAT_IMPORT
WAT tarafında dış ev sahibi çağrısı bildirir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%WAT_IMPORT ux.print_i32 AS print_i32(i32)
```

### 18. %%WAT_EXPORT
WAT dışa açılan adını bildirir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%WAT_EXPORT ...
```

### 19. %%WASM_HOST_JS_BEGIN
WASM ev sahibi JavaScript köprüsünü toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%WASM_HOST_JS_BEGIN ...
```

### 20. %%HTML_BEGIN
HTML bloğunu veya dosyasını toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTML_BEGIN ...
```

### 21. %%HTML_LINE
tek HTML satırı ekler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTML_LINE <div id="app"></div>
```

### 22. %%HTML_SCRIPT
betik etiketi bilgisini üretir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTML_SCRIPT ...
```

### 23. %%HTML_STYLE
biçim dosyası etiketi bilgisini üretir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTML_STYLE ...
```

### 24. %%CSS_BEGIN
CSS bloğunu veya dosyasını toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CSS_BEGIN ...
```

### 25. %%CSS_LINE
tek CSS satırı ekler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CSS_LINE ...
```

### 26. %%JSON_BEGIN
JSON bloğunu veya dosyasını toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%JSON_BEGIN ...
```

### 27. %%JSON_SET
JSON anahtar/değer yazar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%JSON_SET ...
```

### 28. %%MANIFEST_SET
yapı bildirgesine anahtar/değer yazar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MANIFEST_SET ...
```

### 29. %%MANIFEST_REQUIRE
zorunlu çıktı veya bağlantı bildirir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MANIFEST_REQUIRE ...
```

### 30. %%MD_BEGIN
Markdown bloğunu toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MD_BEGIN ...
```

### 31. %%MD_FILE
Markdown dosyasını kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MD_FILE ...
```

### 32. %%ASSET_ROOT
varlık kök dizinini belirler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSET_ROOT ...
```

### 33. %%ASSET_COPY
varlık dosyasını kopyalar veya kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSET_ROOT "assets"
%%ASSET_COPY "logo.png"
```

### 34. %%ASSET_FILE
genel varlık dosyasını kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSET_FILE ...
```

### 35. %%ASSET_IMAGE
görsel varlığı kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSET_IMAGE ...
```

### 36. %%ASSET_AUDIO
ses varlığı kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSET_AUDIO ...
```

### 37. %%ALLOW_RAW_JS
ham JavaScript yazmaya izin verir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ALLOW_RAW_JS ...
```

### 38. %%ALLOW_RAW_WAT
ham WAT yazmaya izin verir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ALLOW_RAW_WAT ...
```

### 39. %%SAFE_PATHS
yol güvenliği kuralını belirler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%SAFE_PATHS ...
```

### 40. %%REQUIRE_HOST_BINDING
WAT içe çağrıları için ev sahibi bağlantısı ister. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%REQUIRE_HOST_BINDING ...
```

### 41. %%ASSERT_META
koşul yanlışsa derleme sırasında hata verir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSERT_META TARGET <> ""
```

### 42. %%WARN_META
derleme sırasında uyarı üretir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%WARN_META ...
```

### 43. %%IFN
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%IFN ...
```

### 44. %%ELIF
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ELIF ...
```

### 45. %%PROFILE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%PROFILE ...
```

### 46. %%CONFIG_FILE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CONFIG_FILE ...
```

### 47. %%PATH_ALIAS
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%PATH_ALIAS ...
```

### 48. %%LOCK_META
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%LOCK_META ...
```

### 49. %%DUMP_META
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%DUMP_META ...
```

### 50. %%SOURCE_MAP
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%SOURCE_MAP ...
```

### 51. %%EMITNOTE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%EMITNOTE ...
```

### 52. %%ENV
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ENV ...
```

### 53. %%DEPRECATED
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%DEPRECATED ...
```

### 54. %%TEMPLATE_BEGIN
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%TEMPLATE_BEGIN ...
```

### 55. %%TEMPLATE_END
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%TEMPLATE_END ...
```

### 56. %%TEMPLATE_USE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%TEMPLATE_USE ...
```

### 57. %%MINIFY
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MINIFY ...
```

### 58. %%FINGERPRINT_ASSETS
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%FINGERPRINT_ASSETS ...
```

### 59. %%HASHFILE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HASHFILE ...
```

### 60. %%COPY_DIR
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%COPY_DIR ...
```

### 61. %%EMBEDTEXT
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%EMBEDTEXT ...
```

### 62. %%EMBEDBASE64
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%EMBEDBASE64 ...
```

### 63. %%LICENSEFILE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%LICENSEFILE ...
```

### 64. %%HTMLIMAGE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTMLIMAGE ...
```

### 65. %%HTMLAUDIO
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTMLAUDIO ...
```

### 66. %%CSS_RULE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CSS_RULE ...
```

### 67. %%CSS_IMPORT
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CSS_IMPORT ...
```

### 68. %%MD_SAFE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MD_SAFE ...
```

### 69. %%MD_CSS
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MD_CSS ...
```

### 70. %%BREAK
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%BREAK ...
```

### 71. %%CONTINUE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CONTINUE ...
```

### 72. %%INFOMETA
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%INFOMETA ...
```

## İşleçlerin toplu özeti
|İşleç|Sözdizimi|Görev|
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

## Veri tiplerinin toplu özeti
|Tip|Sözdizimi|Görev|
|---|---|---|
|BYTE|DIM ad AS BYTE|tek baytlık ham veri tutar.|
|DEFINT|DEFINT A-Z|harfle başlayan adsız tipleri I32 yapar|
|DEFLNG|DEFLNG A-Z|harfle başlayan adsız tipleri I64 yapar|
|DEFSNG|DEFSNG A-Z|harfle başlayan adsız tipleri F32 yapar|
|DEFDBL|DEFDBL A-Z|harfle başlayan adsız tipleri F64 yapar|
|DEFEXT|DEFEXT A-Z|harfle başlayan adsız tipleri geniş ondalık yapar|
|DEFSTR|DEFSTR A-Z|harfle başlayan adsız tipleri STRING yapar|
|DEFBYT|DEFBYT A-Z|harfle başlayan adsız tipleri BYTE yapar|
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
