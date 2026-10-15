# uXBasic Programlayıcının Cep Kitabı — Cilt 2
# Anahtar Sözcükler, Komutlar, Ön-İşleyici, Tipler, İşleçler ve Yerel Fonksiyonlar

Bu cilt dil yüzeyini öğretir. Tabloyu ezberlemek yerine her satırdan küçük program çıkar. Bir komutun görevi, sözdizimi ve iki satırlık örneği birlikte verilmiştir.

## Tüm anahtar sözcükler
|No|Sözcük|Sınıf|Sözdizimi|Görev|
|---|---|---|---|---|
|1|IF|Akış|IF koşul THEN ... ELSE ... END IF|Koşula göre farklı komut yolu seçer.|
|2|THEN|Akış|THEN ...|THEN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|3|ELSE|Akış|ELSE ...|ELSE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|4|ELSEIF|Akış|ELSEIF ...|ELSEIF uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|5|END|Akış|END ...|END uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|6|SELECT|Akış|SELECT CASE ifade ... CASE değer ... END SELECT|Bir değeri çok seçenekli dallara ayırır.|
|7|CASE|Akış|CASE ...|CASE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|8|IS|Akış|IS ...|IS uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|9|TRY|Akış|TRY ... CATCH hata ... FINALLY ... END TRY|Hata yakalama bölümü başlatır.|
|10|CATCH|Akış|CATCH ...|CATCH uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|11|FINALLY|Akış|FINALLY ...|FINALLY uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|12|THROW|Akış|THROW "hata metni"|Denetimli hata fırlatır.|
|13|ASSERT|Akış|ASSERT koşul|Bir koşul doğru değilse test hatası üretir.|
|14|EVENT|Olay ve eşzamanlılık|EVENT Ad|Olay adı bildirir. GUI, tarayıcı, sensör ve zamanlayıcı işlerinde kullanılır.|
|15|THREAD|Olay ve eşzamanlılık|THREAD Ad ... END THREAD|Ayrı iş parçacığı bildirir.|
|16|THREAT|Olay ve eşzamanlılık|THREAT ...|THREAT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|17|PARALEL|Olay ve eşzamanlılık|PARALEL Ad ... END PARALEL|Paralel çalışacak iş bloğu bildirir.|
|18|PIPE|Olay ve eşzamanlılık|PIPE Ad AS TIP|İşler arasında veri akışı borusu kurar.|
|19|SLOT|Olay ve eşzamanlılık|SLOT Ad ON Olay ... END SLOT|Olaya bağlanan çalışma yuvası tanımlar.|
|20|ON|Olay ve eşzamanlılık|ON ...|ON uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|21|OFF|Olay ve eşzamanlılık|OFF ...|OFF uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|22|TRIGGER|Olay ve eşzamanlılık|TRIGGER ...|TRIGGER uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|23|BYTE|Tipler|DIM ad AS BYTE|BYTE veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|24|FOR|Akış|FOR i = başlangıç TO bitiş STEP adım ... NEXT i|Sayaçlı döngü kurar. Bir işi belli sayıda yapmak için kullanılır.|
|25|TO|Akış|TO ...|TO uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|26|STEP|Akış|STEP ...|STEP uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|27|NEXT|Akış|NEXT ...|NEXT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|28|DO|Akış|DO WHILE koşul ... LOOP  \|  DO ... LOOP UNTIL koşul|Koşullu veya sürekli döngü kurar.|
|29|LOOP|Akış|LOOP ...|LOOP uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|30|WHILE|Akış|WHILE ...|WHILE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|31|UNTIL|Akış|UNTIL ...|UNTIL uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|32|EXIT|Akış|EXIT ...|EXIT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|33|EACH|Akış|EACH ...|EACH uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|34|IN|Akış|IN ...|IN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|35|SUB|Yordam ve çağrı|SUB ad(param AS TIP) ... END SUB|Değer döndürmeyen yordam tanımlar.|
|36|FUNCTION|Yordam ve çağrı|FUNCTION ad(param AS TIP) AS TIP ... RETURN değer ... END FUNCTION|Değer döndüren yordam tanımlar.|
|37|DECLARE|Yordam ve çağrı|DECLARE FUNCTION ad LIB "dll" ALIAS "gercek_ad" (...) AS TIP|Dış yordam, DLL veya API imzasını bildirir.|
|38|RETURN|Akış|RETURN ...|RETURN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|39|GOTO|Akış|GOTO ...|GOTO uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|40|GOSUB|Akış|GOSUB ...|GOSUB uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|41|CALL|Yordam ve çağrı|CALL ad(arg1, arg2)  \|  CALL(DLL, "dll", "fn", argler)|Yordam, DLL, API veya çalışma zamanı servisini çağırır.|
|42|TYPE|Nesne ve tip bildirimi|TYPE ...|TYPE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|43|CLASS|Nesne ve tip bildirimi|CLASS Ad ... END CLASS|Sınıf tanımlar. Veri ve davranışı aynı kalıpta toplar.|
|44|INTERFACE|Nesne ve tip bildirimi|INTERFACE Ad ... END INTERFACE|Bir sınıfın hangi işleri yapacağını sözleşme olarak bildirir.|
|45|IMPLEMENTS|Nesne ve tip bildirimi|IMPLEMENTS ...|IMPLEMENTS uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|46|METHOD|Nesne ve tip bildirimi|METHOD ...|METHOD uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|47|SIHIRLIMETOT|Nesne ve tip bildirimi|SIHIRLIMETOT ...|SIHIRLIMETOT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|48|MAGIC|Nesne ve tip bildirimi|MAGIC ...|MAGIC uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|49|VIRTUAL|Nesne ve tip bildirimi|VIRTUAL ...|VIRTUAL uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|50|OVERRIDE|Nesne ve tip bildirimi|OVERRIDE ...|OVERRIDE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|51|CONSTRUCTOR|Nesne ve tip bildirimi|CONSTRUCTOR ...|CONSTRUCTOR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|52|DESTRUCTOR|Nesne ve tip bildirimi|DESTRUCTOR ...|DESTRUCTOR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|53|NEW|Nesne ve tip bildirimi|NEW ...|NEW uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|54|DELETE|Nesne ve tip bildirimi|DELETE ...|DELETE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|55|DIM|Değişken ve varsayılan tip|DIM ad AS TIP  \|  DIM dizi(0 TO n) AS TIP|Yeni değişken veya dizi bildirir. Programın bellekte tutacağı kutular burada açılır.|
|56|REDIM|Değişken ve varsayılan tip|REDIM dizi(0 TO yeniSon) AS TIP|Dizinin boyutunu çalışma sırasında yeniden ayarlar.|
|57|AS|Değişken ve varsayılan tip|AS ...|AS uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|58|CONST|Değişken ve varsayılan tip|CONST ...|CONST uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|59|INCLUDE|Ad alanı ve modül|INCLUDE "include/modul.uxmh"|Başka uXBasic başlık/kaynak dosyasını ekler.|
|60|IMPORT|Ad alanı ve modül|IMPORT(C,"dosya.c")  \|  IMPORT(CPP,"dosya.cpp")  \|  IMPORT(ASM,"dosya.asm")|C, C++ veya ASM dosyasını derleme zamanında projeye alır.|
|61|ABSTRACT|Nesne ve tip bildirimi|ABSTRACT ...|ABSTRACT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|62|FINAL|Nesne ve tip bildirimi|FINAL ...|FINAL uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|63|SEALED|Nesne ve tip bildirimi|SEALED ...|SEALED uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|64|STATIC|Nesne ve tip bildirimi|STATIC ...|STATIC uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|65|PROPERTY|Nesne ve tip bildirimi|PROPERTY ...|PROPERTY uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|66|OPERATOR|Nesne ve tip bildirimi|OPERATOR ...|OPERATOR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|67|MIXIN|Nesne ve tip bildirimi|MIXIN ...|MIXIN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|68|DECORATOR|Nesne ve tip bildirimi|DECORATOR ...|DECORATOR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|69|PUBLIC|Nesne ve tip bildirimi|PUBLIC ...|PUBLIC uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|70|PRIVATE|Nesne ve tip bildirimi|PRIVATE ...|PRIVATE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|71|PROTECTED|Nesne ve tip bildirimi|PROTECTED ...|PROTECTED uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|72|RESTRICTED|Nesne ve tip bildirimi|RESTRICTED ...|RESTRICTED uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|73|FRIEND|Nesne ve tip bildirimi|FRIEND ...|FRIEND uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|74|READONLY|Nesne ve tip bildirimi|READONLY ...|READONLY uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|75|MUTABLE|Nesne ve tip bildirimi|MUTABLE ...|MUTABLE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|76|IMMUTABLE|Nesne ve tip bildirimi|IMMUTABLE ...|IMMUTABLE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|77|MAIN|Yordam ve çağrı|MAIN ...|MAIN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|78|NAMESPACE|Ad alanı ve modül|NAMESPACE ...|NAMESPACE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|79|MODULE|Ad alanı ve modül|MODULE ...|MODULE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|80|USING|Ad alanı ve modül|USING ...|USING uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|81|ALIAS|Ad alanı ve modül|ALIAS ...|ALIAS uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|82|DEFINT|Değişken ve varsayılan tip|DEFINT ...|DEFINT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|83|DEFLNG|Değişken ve varsayılan tip|DEFLNG ...|DEFLNG uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|84|DEFSNG|Değişken ve varsayılan tip|DEFSNG ...|DEFSNG uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|85|DEFDBL|Değişken ve varsayılan tip|DEFDBL ...|DEFDBL uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|86|DEFEXT|Değişken ve varsayılan tip|DEFEXT ...|DEFEXT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|87|DEFSTR|Değişken ve varsayılan tip|DEFSTR ...|DEFSTR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|88|DEFBYT|Değişken ve varsayılan tip|DEFBYT ...|DEFBYT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|89|PRINT|Giriş çıkış ve ekran|PRINT ifade[, ifade...]  \|  PRINT #dosyaNo, ifade[, ifade...]|Ekrana veya dosyaya değer yazar. Tanıtım, günlük ve rapor çıktısı için kullanılır.|
|90|INPUT|Giriş çıkış ve ekran|INPUT değişken  \|  INPUT #dosyaNo, değişken|Kullanıcıdan veya dosyadan değer okur. Küçük araçlarda hızlı veri girişi sağlar.|
|91|OPEN|Giriş çıkış ve ekran|OPEN ...|OPEN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|92|CLOSE|Giriş çıkış ve ekran|CLOSE ...|CLOSE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|93|GET|Giriş çıkış ve ekran|GET ...|GET uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|94|PUT|Giriş çıkış ve ekran|PUT ...|PUT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|95|SEEK|Giriş çıkış ve ekran|SEEK ...|SEEK uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|96|CLS|Giriş çıkış ve ekran|CLS ...|CLS uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|97|COLOR|Giriş çıkış ve ekran|COLOR ...|COLOR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|98|LOCATE|Giriş çıkış ve ekran|LOCATE ...|LOCATE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|
|99|AND|İşleç sözcükleri|sonuc = sol AND sağ|AND mantıksal veya bit düzeyi işlem sözcüğüdür.|
|100|OR|İşleç sözcükleri|sonuc = sol OR sağ|OR mantıksal veya bit düzeyi işlem sözcüğüdür.|
|101|NOT|İşleç sözcükleri|sonuc = sol NOT sağ|NOT mantıksal veya bit düzeyi işlem sözcüğüdür.|
|102|XOR|İşleç sözcükleri|sonuc = sol XOR sağ|XOR mantıksal veya bit düzeyi işlem sözcüğüdür.|
|103|MOD|İşleç sözcükleri|sonuc = sol MOD sağ|MOD mantıksal veya bit düzeyi işlem sözcüğüdür.|
|104|SHL|İşleç sözcükleri|sonuc = sol SHL sağ|SHL mantıksal veya bit düzeyi işlem sözcüğüdür.|
|105|SHR|İşleç sözcükleri|sonuc = sol SHR sağ|SHR mantıksal veya bit düzeyi işlem sözcüğüdür.|
|106|ROL|İşleç sözcükleri|sonuc = sol ROL sağ|ROL mantıksal veya bit düzeyi işlem sözcüğüdür.|
|107|ROR|İşleç sözcükleri|sonuc = sol ROR sağ|ROR mantıksal veya bit düzeyi işlem sözcüğüdür.|
|108|INLINE|Ad alanı ve modül|INLINE C ... END INLINE|Kaynak içinde doğrudan C, C++ veya ASM bloğu taşır.|
|109|I8|Tipler|DIM ad AS I8|I8 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|110|U8|Tipler|DIM ad AS U8|U8 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|111|I16|Tipler|DIM ad AS I16|I16 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|112|U16|Tipler|DIM ad AS U16|U16 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|113|I32|Tipler|DIM ad AS I32|I32 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|114|U32|Tipler|DIM ad AS U32|U32 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|115|I64|Tipler|DIM ad AS I64|I64 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|116|U64|Tipler|DIM ad AS U64|U64 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|117|F32|Tipler|DIM ad AS F32|F32 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|118|F64|Tipler|DIM ad AS F64|F64 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|119|F80|Tipler|DIM ad AS F80|F80 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|120|F128|Tipler|DIM ad AS F128|F128 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|121|BIGF|Tipler|DIM ad AS BIGF|BIGF veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|122|BIGD|Tipler|DIM ad AS BIGD|BIGD veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|123|BALL|Tipler|DIM ad AS BALL|BALL veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|124|BOOLEAN|Tipler|DIM ad AS BOOLEAN|BOOLEAN veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|125|STRING|Tipler|DIM ad AS STRING|STRING veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|126|OBJECT|Tipler|DIM ad AS OBJECT|OBJECT veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|127|PTR|Tipler|DIM ad AS PTR|PTR veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|128|STRPTR|Tipler|DIM ad AS STRPTR|STRPTR veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|129|BYREF|Tipler|DIM ad AS BYREF|BYREF veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|130|BYVAL|Tipler|DIM ad AS BYVAL|BYVAL veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|131|CDECL|Tipler|DIM ad AS CDECL|CDECL veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|132|STDCALL|Tipler|DIM ad AS STDCALL|STDCALL veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|133|ARRAY|Tipler|DIM ad AS ARRAY|ARRAY veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|134|LIST|Tipler|DIM ad AS LIST|LIST veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|135|DICT|Tipler|DIM ad AS DICT|DICT veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|136|SET|Tipler|DIM ad AS SET|SET veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.|
|137|SETSTRINGSIZE|Yerel fonksiyonlar|sonuc = SETSTRINGSIZE(...)|SETSTRINGSIZE yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|138|TIMER|Yerel fonksiyonlar|sonuc = TIMER(...)|TIMER yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|139|LOF|Yerel fonksiyonlar|sonuc = LOF(...)|LOF yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|140|EOF|Yerel fonksiyonlar|sonuc = EOF(...)|EOF yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|141|LEN|Yerel fonksiyonlar|sonuc = LEN(...)|LEN yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|142|MID|Yerel fonksiyonlar|sonuc = MID(...)|MID yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|143|STR|Yerel fonksiyonlar|sonuc = STR(...)|STR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|144|VAL|Yerel fonksiyonlar|sonuc = VAL(...)|VAL yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|145|ABS|Yerel fonksiyonlar|sonuc = ABS(...)|ABS yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|146|INT|Yerel fonksiyonlar|sonuc = INT(...)|INT yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|147|UCASE|Yerel fonksiyonlar|sonuc = UCASE(...)|UCASE yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|148|LCASE|Yerel fonksiyonlar|sonuc = LCASE(...)|LCASE yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|149|ASC|Yerel fonksiyonlar|sonuc = ASC(...)|ASC yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|150|CHR|Yerel fonksiyonlar|sonuc = CHR(...)|CHR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|151|LTRIM|Yerel fonksiyonlar|sonuc = LTRIM(...)|LTRIM yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|152|RTRIM|Yerel fonksiyonlar|sonuc = RTRIM(...)|RTRIM yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|153|SPACE|Yerel fonksiyonlar|sonuc = SPACE(...)|SPACE yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|154|SGN|Yerel fonksiyonlar|sonuc = SGN(...)|SGN yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|155|SQRT|Yerel fonksiyonlar|sonuc = SQRT(...)|SQRT yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|156|SIN|Yerel fonksiyonlar|sonuc = SIN(...)|SIN yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|157|COS|Yerel fonksiyonlar|sonuc = COS(...)|COS yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|158|TAN|Yerel fonksiyonlar|sonuc = TAN(...)|TAN yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|159|ATN|Yerel fonksiyonlar|sonuc = ATN(...)|ATN yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|160|EXP|Yerel fonksiyonlar|sonuc = EXP(...)|EXP yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|161|LOG|Yerel fonksiyonlar|sonuc = LOG(...)|LOG yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|162|INKEY|Yerel fonksiyonlar|sonuc = INKEY(...)|INKEY yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|163|GETKEY|Yerel fonksiyonlar|sonuc = GETKEY(...)|GETKEY yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|164|VARPTR|Yerel fonksiyonlar|sonuc = VARPTR(...)|VARPTR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|165|SADD|Yerel fonksiyonlar|sonuc = SADD(...)|SADD yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|166|LPTR|Yerel fonksiyonlar|sonuc = LPTR(...)|LPTR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|167|CODEPTR|Yerel fonksiyonlar|sonuc = CODEPTR(...)|CODEPTR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|168|SIZEOF|Yerel fonksiyonlar|sonuc = SIZEOF(...)|SIZEOF yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|169|OFFSETOF|Yerel fonksiyonlar|sonuc = OFFSETOF(...)|OFFSETOF yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|170|CINT|Yerel fonksiyonlar|sonuc = CINT(...)|CINT yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|171|CLNG|Yerel fonksiyonlar|sonuc = CLNG(...)|CLNG yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|172|CDBL|Yerel fonksiyonlar|sonuc = CDBL(...)|CDBL yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|173|CSNG|Yerel fonksiyonlar|sonuc = CSNG(...)|CSNG yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|174|FIX|Yerel fonksiyonlar|sonuc = FIX(...)|FIX yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|175|SQR|Yerel fonksiyonlar|sonuc = SQR(...)|SQR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|176|RND|Yerel fonksiyonlar|sonuc = RND(...)|RND yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|177|RANDOMIZE|Yerel fonksiyonlar|sonuc = RANDOMIZE(...)|RANDOMIZE yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.|
|178|PEEKB|Bellek|PEEKB adres[, değer[, uzunluk]]|PEEKB bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|179|PEEKW|Bellek|PEEKW adres[, değer[, uzunluk]]|PEEKW bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|180|PEEKD|Bellek|PEEKD adres[, değer[, uzunluk]]|PEEKD bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|181|POKE|Bellek|POKE adres[, değer[, uzunluk]]|POKE bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|182|POKEB|Bellek|POKEB adres[, değer[, uzunluk]]|POKEB bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|183|POKEW|Bellek|POKEW adres[, değer[, uzunluk]]|POKEW bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|184|POKED|Bellek|POKED adres[, değer[, uzunluk]]|POKED bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|185|POKES|Bellek|POKES adres[, değer[, uzunluk]]|POKES bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|186|MEMCOPYB|Bellek|MEMCOPYB adres[, değer[, uzunluk]]|MEMCOPYB bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|187|MEMCOPYW|Bellek|MEMCOPYW adres[, değer[, uzunluk]]|MEMCOPYW bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|188|MEMCOPYD|Bellek|MEMCOPYD adres[, değer[, uzunluk]]|MEMCOPYD bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|189|MEMFILLB|Bellek|MEMFILLB adres[, değer[, uzunluk]]|MEMFILLB bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|190|MEMFILLW|Bellek|MEMFILLW adres[, değer[, uzunluk]]|MEMFILLW bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|191|MEMFILLD|Bellek|MEMFILLD adres[, değer[, uzunluk]]|MEMFILLD bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|192|SETNEWOFFSET|Bellek|SETNEWOFFSET adres[, değer[, uzunluk]]|SETNEWOFFSET bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|193|INC|Bellek|INC adres[, değer[, uzunluk]]|INC bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|194|DEC|Bellek|DEC adres[, değer[, uzunluk]]|DEC bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.|
|195|ENUM|Listeleme|ENUM ...|ENUM uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.|

## Anahtar sözcüklerin tek tek kullanımı
### 1. IF
**Sınıf:** Akış  
**Sözdizimi:** `IF koşul THEN ... ELSE ... END IF`  
**Ne işe yarar:** Koşula göre farklı komut yolu seçer.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
IF toplam > 100 THEN PRINT "buyuk" ELSE PRINT "kucuk" END IF
```
### 2. THEN
**Sınıf:** Akış  
**Sözdizimi:** `THEN ...`  
**Ne işe yarar:** THEN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' THEN komutu bağlama göre kullanılır
```
### 3. ELSE
**Sınıf:** Akış  
**Sözdizimi:** `ELSE ...`  
**Ne işe yarar:** ELSE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' ELSE komutu bağlama göre kullanılır
```
### 4. ELSEIF
**Sınıf:** Akış  
**Sözdizimi:** `ELSEIF ...`  
**Ne işe yarar:** ELSEIF uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' ELSEIF komutu bağlama göre kullanılır
```
### 5. END
**Sınıf:** Akış  
**Sözdizimi:** `END ...`  
**Ne işe yarar:** END uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' END komutu bağlama göre kullanılır
```
### 6. SELECT
**Sınıf:** Akış  
**Sözdizimi:** `SELECT CASE ifade ... CASE değer ... END SELECT`  
**Ne işe yarar:** Bir değeri çok seçenekli dallara ayırır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' SELECT komutu bağlama göre kullanılır
```
### 7. CASE
**Sınıf:** Akış  
**Sözdizimi:** `CASE ...`  
**Ne işe yarar:** CASE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' CASE komutu bağlama göre kullanılır
```
### 8. IS
**Sınıf:** Akış  
**Sözdizimi:** `IS ...`  
**Ne işe yarar:** IS uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' IS komutu bağlama göre kullanılır
```
### 9. TRY
**Sınıf:** Akış  
**Sözdizimi:** `TRY ... CATCH hata ... FINALLY ... END TRY`  
**Ne işe yarar:** Hata yakalama bölümü başlatır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' TRY komutu bağlama göre kullanılır
```
### 10. CATCH
**Sınıf:** Akış  
**Sözdizimi:** `CATCH ...`  
**Ne işe yarar:** CATCH uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' CATCH komutu bağlama göre kullanılır
```
### 11. FINALLY
**Sınıf:** Akış  
**Sözdizimi:** `FINALLY ...`  
**Ne işe yarar:** FINALLY uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' FINALLY komutu bağlama göre kullanılır
```
### 12. THROW
**Sınıf:** Akış  
**Sözdizimi:** `THROW "hata metni"`  
**Ne işe yarar:** Denetimli hata fırlatır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' THROW komutu bağlama göre kullanılır
```
### 13. ASSERT
**Sınıf:** Akış  
**Sözdizimi:** `ASSERT koşul`  
**Ne işe yarar:** Bir koşul doğru değilse test hatası üretir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' ASSERT komutu bağlama göre kullanılır
```
### 14. EVENT
**Sınıf:** Olay ve eşzamanlılık  
**Sözdizimi:** `EVENT Ad`  
**Ne işe yarar:** Olay adı bildirir. GUI, tarayıcı, sensör ve zamanlayıcı işlerinde kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' EVENT komutu bağlama göre kullanılır
```
### 15. THREAD
**Sınıf:** Olay ve eşzamanlılık  
**Sözdizimi:** `THREAD Ad ... END THREAD`  
**Ne işe yarar:** Ayrı iş parçacığı bildirir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' THREAD komutu bağlama göre kullanılır
```
### 16. THREAT
**Sınıf:** Olay ve eşzamanlılık  
**Sözdizimi:** `THREAT ...`  
**Ne işe yarar:** THREAT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' THREAT komutu bağlama göre kullanılır
```
### 17. PARALEL
**Sınıf:** Olay ve eşzamanlılık  
**Sözdizimi:** `PARALEL Ad ... END PARALEL`  
**Ne işe yarar:** Paralel çalışacak iş bloğu bildirir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' PARALEL komutu bağlama göre kullanılır
```
### 18. PIPE
**Sınıf:** Olay ve eşzamanlılık  
**Sözdizimi:** `PIPE Ad AS TIP`  
**Ne işe yarar:** İşler arasında veri akışı borusu kurar.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' PIPE komutu bağlama göre kullanılır
```
### 19. SLOT
**Sınıf:** Olay ve eşzamanlılık  
**Sözdizimi:** `SLOT Ad ON Olay ... END SLOT`  
**Ne işe yarar:** Olaya bağlanan çalışma yuvası tanımlar.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' SLOT komutu bağlama göre kullanılır
```
### 20. ON
**Sınıf:** Olay ve eşzamanlılık  
**Sözdizimi:** `ON ...`  
**Ne işe yarar:** ON uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' ON komutu bağlama göre kullanılır
```
> İpucu: Bu noktaya kadar gördüğün sözcükleri tek bir dosyada karıştırma. Önce karar, sonra döngü, sonra dosya, sonra DLL çağrısı olarak ayrı ayrı dene.

### 21. OFF
**Sınıf:** Olay ve eşzamanlılık  
**Sözdizimi:** `OFF ...`  
**Ne işe yarar:** OFF uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' OFF komutu bağlama göre kullanılır
```
### 22. TRIGGER
**Sınıf:** Olay ve eşzamanlılık  
**Sözdizimi:** `TRIGGER ...`  
**Ne işe yarar:** TRIGGER uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' TRIGGER komutu bağlama göre kullanılır
```
### 23. BYTE
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS BYTE`  
**Ne işe yarar:** BYTE veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS BYTE
```
### 24. FOR
**Sınıf:** Akış  
**Sözdizimi:** `FOR i = başlangıç TO bitiş STEP adım ... NEXT i`  
**Ne işe yarar:** Sayaçlı döngü kurar. Bir işi belli sayıda yapmak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
FOR i = 1 TO 10 : toplam = toplam + i : NEXT i
```
### 25. TO
**Sınıf:** Akış  
**Sözdizimi:** `TO ...`  
**Ne işe yarar:** TO uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' TO komutu bağlama göre kullanılır
```
### 26. STEP
**Sınıf:** Akış  
**Sözdizimi:** `STEP ...`  
**Ne işe yarar:** STEP uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' STEP komutu bağlama göre kullanılır
```
### 27. NEXT
**Sınıf:** Akış  
**Sözdizimi:** `NEXT ...`  
**Ne işe yarar:** NEXT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' NEXT komutu bağlama göre kullanılır
```
### 28. DO
**Sınıf:** Akış  
**Sözdizimi:** `DO WHILE koşul ... LOOP  |  DO ... LOOP UNTIL koşul`  
**Ne işe yarar:** Koşullu veya sürekli döngü kurar.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DO komutu bağlama göre kullanılır
```
### 29. LOOP
**Sınıf:** Akış  
**Sözdizimi:** `LOOP ...`  
**Ne işe yarar:** LOOP uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' LOOP komutu bağlama göre kullanılır
```
### 30. WHILE
**Sınıf:** Akış  
**Sözdizimi:** `WHILE ...`  
**Ne işe yarar:** WHILE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' WHILE komutu bağlama göre kullanılır
```
### 31. UNTIL
**Sınıf:** Akış  
**Sözdizimi:** `UNTIL ...`  
**Ne işe yarar:** UNTIL uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' UNTIL komutu bağlama göre kullanılır
```
### 32. EXIT
**Sınıf:** Akış  
**Sözdizimi:** `EXIT ...`  
**Ne işe yarar:** EXIT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' EXIT komutu bağlama göre kullanılır
```
### 33. EACH
**Sınıf:** Akış  
**Sözdizimi:** `EACH ...`  
**Ne işe yarar:** EACH uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' EACH komutu bağlama göre kullanılır
```
### 34. IN
**Sınıf:** Akış  
**Sözdizimi:** `IN ...`  
**Ne işe yarar:** IN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' IN komutu bağlama göre kullanılır
```
### 35. SUB
**Sınıf:** Yordam ve çağrı  
**Sözdizimi:** `SUB ad(param AS TIP) ... END SUB`  
**Ne işe yarar:** Değer döndürmeyen yordam tanımlar.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' SUB komutu bağlama göre kullanılır
```
### 36. FUNCTION
**Sınıf:** Yordam ve çağrı  
**Sözdizimi:** `FUNCTION ad(param AS TIP) AS TIP ... RETURN değer ... END FUNCTION`  
**Ne işe yarar:** Değer döndüren yordam tanımlar.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' FUNCTION komutu bağlama göre kullanılır
```
### 37. DECLARE
**Sınıf:** Yordam ve çağrı  
**Sözdizimi:** `DECLARE FUNCTION ad LIB "dll" ALIAS "gercek_ad" (...) AS TIP`  
**Ne işe yarar:** Dış yordam, DLL veya API imzasını bildirir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DECLARE komutu bağlama göre kullanılır
```
### 38. RETURN
**Sınıf:** Akış  
**Sözdizimi:** `RETURN ...`  
**Ne işe yarar:** RETURN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' RETURN komutu bağlama göre kullanılır
```
### 39. GOTO
**Sınıf:** Akış  
**Sözdizimi:** `GOTO ...`  
**Ne işe yarar:** GOTO uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' GOTO komutu bağlama göre kullanılır
```
### 40. GOSUB
**Sınıf:** Akış  
**Sözdizimi:** `GOSUB ...`  
**Ne işe yarar:** GOSUB uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' GOSUB komutu bağlama göre kullanılır
```
> İpucu: Bu noktaya kadar gördüğün sözcükleri tek bir dosyada karıştırma. Önce karar, sonra döngü, sonra dosya, sonra DLL çağrısı olarak ayrı ayrı dene.

### 41. CALL
**Sınıf:** Yordam ve çağrı  
**Sözdizimi:** `CALL ad(arg1, arg2)  |  CALL(DLL, "dll", "fn", argler)`  
**Ne işe yarar:** Yordam, DLL, API veya çalışma zamanı servisini çağırır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
CALL(DLL, "user32.dll", "MessageBeep", 0)
```
### 42. TYPE
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `TYPE ...`  
**Ne işe yarar:** TYPE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' TYPE komutu bağlama göre kullanılır
```
### 43. CLASS
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `CLASS Ad ... END CLASS`  
**Ne işe yarar:** Sınıf tanımlar. Veri ve davranışı aynı kalıpta toplar.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' CLASS komutu bağlama göre kullanılır
```
### 44. INTERFACE
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `INTERFACE Ad ... END INTERFACE`  
**Ne işe yarar:** Bir sınıfın hangi işleri yapacağını sözleşme olarak bildirir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' INTERFACE komutu bağlama göre kullanılır
```
### 45. IMPLEMENTS
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `IMPLEMENTS ...`  
**Ne işe yarar:** IMPLEMENTS uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' IMPLEMENTS komutu bağlama göre kullanılır
```
### 46. METHOD
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `METHOD ...`  
**Ne işe yarar:** METHOD uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' METHOD komutu bağlama göre kullanılır
```
### 47. SIHIRLIMETOT
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `SIHIRLIMETOT ...`  
**Ne işe yarar:** SIHIRLIMETOT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' SIHIRLIMETOT komutu bağlama göre kullanılır
```
### 48. MAGIC
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `MAGIC ...`  
**Ne işe yarar:** MAGIC uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' MAGIC komutu bağlama göre kullanılır
```
### 49. VIRTUAL
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `VIRTUAL ...`  
**Ne işe yarar:** VIRTUAL uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' VIRTUAL komutu bağlama göre kullanılır
```
### 50. OVERRIDE
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `OVERRIDE ...`  
**Ne işe yarar:** OVERRIDE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' OVERRIDE komutu bağlama göre kullanılır
```
### 51. CONSTRUCTOR
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `CONSTRUCTOR ...`  
**Ne işe yarar:** CONSTRUCTOR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' CONSTRUCTOR komutu bağlama göre kullanılır
```
### 52. DESTRUCTOR
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `DESTRUCTOR ...`  
**Ne işe yarar:** DESTRUCTOR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DESTRUCTOR komutu bağlama göre kullanılır
```
### 53. NEW
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `NEW ...`  
**Ne işe yarar:** NEW uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' NEW komutu bağlama göre kullanılır
```
### 54. DELETE
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `DELETE ...`  
**Ne işe yarar:** DELETE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DELETE komutu bağlama göre kullanılır
```
### 55. DIM
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `DIM ad AS TIP  |  DIM dizi(0 TO n) AS TIP`  
**Ne işe yarar:** Yeni değişken veya dizi bildirir. Programın bellekte tutacağı kutular burada açılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM toplam AS F64
```
### 56. REDIM
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `REDIM dizi(0 TO yeniSon) AS TIP`  
**Ne işe yarar:** Dizinin boyutunu çalışma sırasında yeniden ayarlar.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' REDIM komutu bağlama göre kullanılır
```
### 57. AS
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `AS ...`  
**Ne işe yarar:** AS uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' AS komutu bağlama göre kullanılır
```
### 58. CONST
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `CONST ...`  
**Ne işe yarar:** CONST uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' CONST komutu bağlama göre kullanılır
```
### 59. INCLUDE
**Sınıf:** Ad alanı ve modül  
**Sözdizimi:** `INCLUDE "include/modul.uxmh"`  
**Ne işe yarar:** Başka uXBasic başlık/kaynak dosyasını ekler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
```
### 60. IMPORT
**Sınıf:** Ad alanı ve modül  
**Sözdizimi:** `IMPORT(C,"dosya.c")  |  IMPORT(CPP,"dosya.cpp")  |  IMPORT(ASM,"dosya.asm")`  
**Ne işe yarar:** C, C++ veya ASM dosyasını derleme zamanında projeye alır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
IMPORT(C, "src/native/hizli_toplam.c")
```
> İpucu: Bu noktaya kadar gördüğün sözcükleri tek bir dosyada karıştırma. Önce karar, sonra döngü, sonra dosya, sonra DLL çağrısı olarak ayrı ayrı dene.

### 61. ABSTRACT
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `ABSTRACT ...`  
**Ne işe yarar:** ABSTRACT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' ABSTRACT komutu bağlama göre kullanılır
```
### 62. FINAL
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `FINAL ...`  
**Ne işe yarar:** FINAL uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' FINAL komutu bağlama göre kullanılır
```
### 63. SEALED
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `SEALED ...`  
**Ne işe yarar:** SEALED uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' SEALED komutu bağlama göre kullanılır
```
### 64. STATIC
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `STATIC ...`  
**Ne işe yarar:** STATIC uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' STATIC komutu bağlama göre kullanılır
```
### 65. PROPERTY
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `PROPERTY ...`  
**Ne işe yarar:** PROPERTY uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' PROPERTY komutu bağlama göre kullanılır
```
### 66. OPERATOR
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `OPERATOR ...`  
**Ne işe yarar:** OPERATOR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' OPERATOR komutu bağlama göre kullanılır
```
### 67. MIXIN
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `MIXIN ...`  
**Ne işe yarar:** MIXIN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' MIXIN komutu bağlama göre kullanılır
```
### 68. DECORATOR
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `DECORATOR ...`  
**Ne işe yarar:** DECORATOR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DECORATOR komutu bağlama göre kullanılır
```
### 69. PUBLIC
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `PUBLIC ...`  
**Ne işe yarar:** PUBLIC uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' PUBLIC komutu bağlama göre kullanılır
```
### 70. PRIVATE
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `PRIVATE ...`  
**Ne işe yarar:** PRIVATE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' PRIVATE komutu bağlama göre kullanılır
```
### 71. PROTECTED
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `PROTECTED ...`  
**Ne işe yarar:** PROTECTED uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' PROTECTED komutu bağlama göre kullanılır
```
### 72. RESTRICTED
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `RESTRICTED ...`  
**Ne işe yarar:** RESTRICTED uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' RESTRICTED komutu bağlama göre kullanılır
```
### 73. FRIEND
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `FRIEND ...`  
**Ne işe yarar:** FRIEND uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' FRIEND komutu bağlama göre kullanılır
```
### 74. READONLY
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `READONLY ...`  
**Ne işe yarar:** READONLY uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' READONLY komutu bağlama göre kullanılır
```
### 75. MUTABLE
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `MUTABLE ...`  
**Ne işe yarar:** MUTABLE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' MUTABLE komutu bağlama göre kullanılır
```
### 76. IMMUTABLE
**Sınıf:** Nesne ve tip bildirimi  
**Sözdizimi:** `IMMUTABLE ...`  
**Ne işe yarar:** IMMUTABLE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' IMMUTABLE komutu bağlama göre kullanılır
```
### 77. MAIN
**Sınıf:** Yordam ve çağrı  
**Sözdizimi:** `MAIN ...`  
**Ne işe yarar:** MAIN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' MAIN komutu bağlama göre kullanılır
```
### 78. NAMESPACE
**Sınıf:** Ad alanı ve modül  
**Sözdizimi:** `NAMESPACE ...`  
**Ne işe yarar:** NAMESPACE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' NAMESPACE komutu bağlama göre kullanılır
```
### 79. MODULE
**Sınıf:** Ad alanı ve modül  
**Sözdizimi:** `MODULE ...`  
**Ne işe yarar:** MODULE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' MODULE komutu bağlama göre kullanılır
```
### 80. USING
**Sınıf:** Ad alanı ve modül  
**Sözdizimi:** `USING ...`  
**Ne işe yarar:** USING uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' USING komutu bağlama göre kullanılır
```
> İpucu: Bu noktaya kadar gördüğün sözcükleri tek bir dosyada karıştırma. Önce karar, sonra döngü, sonra dosya, sonra DLL çağrısı olarak ayrı ayrı dene.

### 81. ALIAS
**Sınıf:** Ad alanı ve modül  
**Sözdizimi:** `ALIAS ...`  
**Ne işe yarar:** ALIAS uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' ALIAS komutu bağlama göre kullanılır
```
### 82. DEFINT
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `DEFINT ...`  
**Ne işe yarar:** DEFINT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DEFINT komutu bağlama göre kullanılır
```
### 83. DEFLNG
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `DEFLNG ...`  
**Ne işe yarar:** DEFLNG uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DEFLNG komutu bağlama göre kullanılır
```
### 84. DEFSNG
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `DEFSNG ...`  
**Ne işe yarar:** DEFSNG uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DEFSNG komutu bağlama göre kullanılır
```
### 85. DEFDBL
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `DEFDBL ...`  
**Ne işe yarar:** DEFDBL uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DEFDBL komutu bağlama göre kullanılır
```
### 86. DEFEXT
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `DEFEXT ...`  
**Ne işe yarar:** DEFEXT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DEFEXT komutu bağlama göre kullanılır
```
### 87. DEFSTR
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `DEFSTR ...`  
**Ne işe yarar:** DEFSTR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DEFSTR komutu bağlama göre kullanılır
```
### 88. DEFBYT
**Sınıf:** Değişken ve varsayılan tip  
**Sözdizimi:** `DEFBYT ...`  
**Ne işe yarar:** DEFBYT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' DEFBYT komutu bağlama göre kullanılır
```
### 89. PRINT
**Sınıf:** Giriş çıkış ve ekran  
**Sözdizimi:** `PRINT ifade[, ifade...]  |  PRINT #dosyaNo, ifade[, ifade...]`  
**Ne işe yarar:** Ekrana veya dosyaya değer yazar. Tanıtım, günlük ve rapor çıktısı için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT "Sonuc="; toplam
```
### 90. INPUT
**Sınıf:** Giriş çıkış ve ekran  
**Sözdizimi:** `INPUT değişken  |  INPUT #dosyaNo, değişken`  
**Ne işe yarar:** Kullanıcıdan veya dosyadan değer okur. Küçük araçlarda hızlı veri girişi sağlar.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' INPUT komutu bağlama göre kullanılır
```
### 91. OPEN
**Sınıf:** Giriş çıkış ve ekran  
**Sözdizimi:** `OPEN ...`  
**Ne işe yarar:** OPEN uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' OPEN komutu bağlama göre kullanılır
```
### 92. CLOSE
**Sınıf:** Giriş çıkış ve ekran  
**Sözdizimi:** `CLOSE ...`  
**Ne işe yarar:** CLOSE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' CLOSE komutu bağlama göre kullanılır
```
### 93. GET
**Sınıf:** Giriş çıkış ve ekran  
**Sözdizimi:** `GET ...`  
**Ne işe yarar:** GET uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' GET komutu bağlama göre kullanılır
```
### 94. PUT
**Sınıf:** Giriş çıkış ve ekran  
**Sözdizimi:** `PUT ...`  
**Ne işe yarar:** PUT uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' PUT komutu bağlama göre kullanılır
```
### 95. SEEK
**Sınıf:** Giriş çıkış ve ekran  
**Sözdizimi:** `SEEK ...`  
**Ne işe yarar:** SEEK uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' SEEK komutu bağlama göre kullanılır
```
### 96. CLS
**Sınıf:** Giriş çıkış ve ekran  
**Sözdizimi:** `CLS ...`  
**Ne işe yarar:** CLS uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' CLS komutu bağlama göre kullanılır
```
### 97. COLOR
**Sınıf:** Giriş çıkış ve ekran  
**Sözdizimi:** `COLOR ...`  
**Ne işe yarar:** COLOR uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' COLOR komutu bağlama göre kullanılır
```
### 98. LOCATE
**Sınıf:** Giriş çıkış ve ekran  
**Sözdizimi:** `LOCATE ...`  
**Ne işe yarar:** LOCATE uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' LOCATE komutu bağlama göre kullanılır
```
### 99. AND
**Sınıf:** İşleç sözcükleri  
**Sözdizimi:** `sonuc = sol AND sağ`  
**Ne işe yarar:** AND mantıksal veya bit düzeyi işlem sözcüğüdür.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' AND komutu bağlama göre kullanılır
```
### 100. OR
**Sınıf:** İşleç sözcükleri  
**Sözdizimi:** `sonuc = sol OR sağ`  
**Ne işe yarar:** OR mantıksal veya bit düzeyi işlem sözcüğüdür.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' OR komutu bağlama göre kullanılır
```
> İpucu: Bu noktaya kadar gördüğün sözcükleri tek bir dosyada karıştırma. Önce karar, sonra döngü, sonra dosya, sonra DLL çağrısı olarak ayrı ayrı dene.

### 101. NOT
**Sınıf:** İşleç sözcükleri  
**Sözdizimi:** `sonuc = sol NOT sağ`  
**Ne işe yarar:** NOT mantıksal veya bit düzeyi işlem sözcüğüdür.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' NOT komutu bağlama göre kullanılır
```
### 102. XOR
**Sınıf:** İşleç sözcükleri  
**Sözdizimi:** `sonuc = sol XOR sağ`  
**Ne işe yarar:** XOR mantıksal veya bit düzeyi işlem sözcüğüdür.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' XOR komutu bağlama göre kullanılır
```
### 103. MOD
**Sınıf:** İşleç sözcükleri  
**Sözdizimi:** `sonuc = sol MOD sağ`  
**Ne işe yarar:** MOD mantıksal veya bit düzeyi işlem sözcüğüdür.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' MOD komutu bağlama göre kullanılır
```
### 104. SHL
**Sınıf:** İşleç sözcükleri  
**Sözdizimi:** `sonuc = sol SHL sağ`  
**Ne işe yarar:** SHL mantıksal veya bit düzeyi işlem sözcüğüdür.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' SHL komutu bağlama göre kullanılır
```
### 105. SHR
**Sınıf:** İşleç sözcükleri  
**Sözdizimi:** `sonuc = sol SHR sağ`  
**Ne işe yarar:** SHR mantıksal veya bit düzeyi işlem sözcüğüdür.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' SHR komutu bağlama göre kullanılır
```
### 106. ROL
**Sınıf:** İşleç sözcükleri  
**Sözdizimi:** `sonuc = sol ROL sağ`  
**Ne işe yarar:** ROL mantıksal veya bit düzeyi işlem sözcüğüdür.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' ROL komutu bağlama göre kullanılır
```
### 107. ROR
**Sınıf:** İşleç sözcükleri  
**Sözdizimi:** `sonuc = sol ROR sağ`  
**Ne işe yarar:** ROR mantıksal veya bit düzeyi işlem sözcüğüdür.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' ROR komutu bağlama göre kullanılır
```
### 108. INLINE
**Sınıf:** Ad alanı ve modül  
**Sözdizimi:** `INLINE C ... END INLINE`  
**Ne işe yarar:** Kaynak içinde doğrudan C, C++ veya ASM bloğu taşır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' INLINE komutu bağlama göre kullanılır
```
### 109. I8
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS I8`  
**Ne işe yarar:** I8 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS I8
```
### 110. U8
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS U8`  
**Ne işe yarar:** U8 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS U8
```
### 111. I16
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS I16`  
**Ne işe yarar:** I16 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS I16
```
### 112. U16
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS U16`  
**Ne işe yarar:** U16 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS U16
```
### 113. I32
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS I32`  
**Ne işe yarar:** I32 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS I32
```
### 114. U32
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS U32`  
**Ne işe yarar:** U32 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS U32
```
### 115. I64
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS I64`  
**Ne işe yarar:** I64 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS I64
```
### 116. U64
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS U64`  
**Ne işe yarar:** U64 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS U64
```
### 117. F32
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS F32`  
**Ne işe yarar:** F32 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS F32
```
### 118. F64
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS F64`  
**Ne işe yarar:** F64 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS F64
```
### 119. F80
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS F80`  
**Ne işe yarar:** F80 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS F80
```
### 120. F128
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS F128`  
**Ne işe yarar:** F128 veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS F128
```
> İpucu: Bu noktaya kadar gördüğün sözcükleri tek bir dosyada karıştırma. Önce karar, sonra döngü, sonra dosya, sonra DLL çağrısı olarak ayrı ayrı dene.

### 121. BIGF
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS BIGF`  
**Ne işe yarar:** BIGF veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS BIGF
```
### 122. BIGD
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS BIGD`  
**Ne işe yarar:** BIGD veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS BIGD
```
### 123. BALL
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS BALL`  
**Ne işe yarar:** BALL veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS BALL
```
### 124. BOOLEAN
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS BOOLEAN`  
**Ne işe yarar:** BOOLEAN veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS BOOLEAN
```
### 125. STRING
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS STRING`  
**Ne işe yarar:** STRING veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS STRING
```
### 126. OBJECT
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS OBJECT`  
**Ne işe yarar:** OBJECT veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS OBJECT
```
### 127. PTR
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS PTR`  
**Ne işe yarar:** PTR veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS PTR
```
### 128. STRPTR
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS STRPTR`  
**Ne işe yarar:** STRPTR veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS STRPTR
```
### 129. BYREF
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS BYREF`  
**Ne işe yarar:** BYREF veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS BYREF
```
### 130. BYVAL
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS BYVAL`  
**Ne işe yarar:** BYVAL veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS BYVAL
```
### 131. CDECL
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS CDECL`  
**Ne işe yarar:** CDECL veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS CDECL
```
### 132. STDCALL
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS STDCALL`  
**Ne işe yarar:** STDCALL veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS STDCALL
```
### 133. ARRAY
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS ARRAY`  
**Ne işe yarar:** ARRAY veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS ARRAY
```
### 134. LIST
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS LIST`  
**Ne işe yarar:** LIST veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS LIST
```
### 135. DICT
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS DICT`  
**Ne işe yarar:** DICT veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS DICT
```
### 136. SET
**Sınıf:** Tipler  
**Sözdizimi:** `DIM ad AS SET`  
**Ne işe yarar:** SET veri tipi veya çağrı imzası işaretidir. Değişkenin sınırını, saklama biçimini veya dış çağrı uyumunu belirler.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DIM x AS SET
```
### 137. SETSTRINGSIZE
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = SETSTRINGSIZE(...)`  
**Ne işe yarar:** SETSTRINGSIZE yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT SETSTRINGSIZE(deger)
```
### 138. TIMER
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = TIMER(...)`  
**Ne işe yarar:** TIMER yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT TIMER(deger)
```
### 139. LOF
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = LOF(...)`  
**Ne işe yarar:** LOF yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT LOF(deger)
```
### 140. EOF
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = EOF(...)`  
**Ne işe yarar:** EOF yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT EOF(deger)
```
> İpucu: Bu noktaya kadar gördüğün sözcükleri tek bir dosyada karıştırma. Önce karar, sonra döngü, sonra dosya, sonra DLL çağrısı olarak ayrı ayrı dene.

### 141. LEN
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = LEN(...)`  
**Ne işe yarar:** LEN yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT LEN(deger)
```
### 142. MID
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = MID(...)`  
**Ne işe yarar:** MID yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT MID(deger)
```
### 143. STR
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = STR(...)`  
**Ne işe yarar:** STR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT STR(deger)
```
### 144. VAL
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = VAL(...)`  
**Ne işe yarar:** VAL yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT VAL(deger)
```
### 145. ABS
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = ABS(...)`  
**Ne işe yarar:** ABS yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT ABS(deger)
```
### 146. INT
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = INT(...)`  
**Ne işe yarar:** INT yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT INT(deger)
```
### 147. UCASE
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = UCASE(...)`  
**Ne işe yarar:** UCASE yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT UCASE(deger)
```
### 148. LCASE
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = LCASE(...)`  
**Ne işe yarar:** LCASE yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT LCASE(deger)
```
### 149. ASC
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = ASC(...)`  
**Ne işe yarar:** ASC yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT ASC(deger)
```
### 150. CHR
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = CHR(...)`  
**Ne işe yarar:** CHR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT CHR(deger)
```
### 151. LTRIM
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = LTRIM(...)`  
**Ne işe yarar:** LTRIM yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT LTRIM(deger)
```
### 152. RTRIM
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = RTRIM(...)`  
**Ne işe yarar:** RTRIM yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT RTRIM(deger)
```
### 153. SPACE
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = SPACE(...)`  
**Ne işe yarar:** SPACE yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT SPACE(deger)
```
### 154. SGN
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = SGN(...)`  
**Ne işe yarar:** SGN yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT SGN(deger)
```
### 155. SQRT
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = SQRT(...)`  
**Ne işe yarar:** SQRT yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT SQRT(deger)
```
### 156. SIN
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = SIN(...)`  
**Ne işe yarar:** SIN yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT SIN(deger)
```
### 157. COS
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = COS(...)`  
**Ne işe yarar:** COS yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT COS(deger)
```
### 158. TAN
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = TAN(...)`  
**Ne işe yarar:** TAN yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT TAN(deger)
```
### 159. ATN
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = ATN(...)`  
**Ne işe yarar:** ATN yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT ATN(deger)
```
### 160. EXP
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = EXP(...)`  
**Ne işe yarar:** EXP yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT EXP(deger)
```
> İpucu: Bu noktaya kadar gördüğün sözcükleri tek bir dosyada karıştırma. Önce karar, sonra döngü, sonra dosya, sonra DLL çağrısı olarak ayrı ayrı dene.

### 161. LOG
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = LOG(...)`  
**Ne işe yarar:** LOG yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT LOG(deger)
```
### 162. INKEY
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = INKEY(...)`  
**Ne işe yarar:** INKEY yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT INKEY(deger)
```
### 163. GETKEY
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = GETKEY(...)`  
**Ne işe yarar:** GETKEY yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT GETKEY(deger)
```
### 164. VARPTR
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = VARPTR(...)`  
**Ne işe yarar:** VARPTR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT VARPTR(deger)
```
### 165. SADD
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = SADD(...)`  
**Ne işe yarar:** SADD yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT SADD(deger)
```
### 166. LPTR
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = LPTR(...)`  
**Ne işe yarar:** LPTR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT LPTR(deger)
```
### 167. CODEPTR
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = CODEPTR(...)`  
**Ne işe yarar:** CODEPTR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT CODEPTR(deger)
```
### 168. SIZEOF
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = SIZEOF(...)`  
**Ne işe yarar:** SIZEOF yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT SIZEOF(deger)
```
### 169. OFFSETOF
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = OFFSETOF(...)`  
**Ne işe yarar:** OFFSETOF yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT OFFSETOF(deger)
```
### 170. CINT
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = CINT(...)`  
**Ne işe yarar:** CINT yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT CINT(deger)
```
### 171. CLNG
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = CLNG(...)`  
**Ne işe yarar:** CLNG yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT CLNG(deger)
```
### 172. CDBL
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = CDBL(...)`  
**Ne işe yarar:** CDBL yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT CDBL(deger)
```
### 173. CSNG
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = CSNG(...)`  
**Ne işe yarar:** CSNG yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT CSNG(deger)
```
### 174. FIX
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = FIX(...)`  
**Ne işe yarar:** FIX yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT FIX(deger)
```
### 175. SQR
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = SQR(...)`  
**Ne işe yarar:** SQR yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT SQR(deger)
```
### 176. RND
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = RND(...)`  
**Ne işe yarar:** RND yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT RND(deger)
```
### 177. RANDOMIZE
**Sınıf:** Yerel fonksiyonlar  
**Sözdizimi:** `sonuc = RANDOMIZE(...)`  
**Ne işe yarar:** RANDOMIZE yerel fonksiyon ailesindedir. Metin, sayı, zaman, tuş veya adres bilgisi almak için kullanılır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PRINT RANDOMIZE(deger)
```
### 178. PEEKB
**Sınıf:** Bellek  
**Sözdizimi:** `PEEKB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** PEEKB bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PEEKB hedef, kaynak, uzunluk
```
### 179. PEEKW
**Sınıf:** Bellek  
**Sözdizimi:** `PEEKW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** PEEKW bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PEEKW hedef, kaynak, uzunluk
```
### 180. PEEKD
**Sınıf:** Bellek  
**Sözdizimi:** `PEEKD adres[, değer[, uzunluk]]`  
**Ne işe yarar:** PEEKD bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
PEEKD hedef, kaynak, uzunluk
```
> İpucu: Bu noktaya kadar gördüğün sözcükleri tek bir dosyada karıştırma. Önce karar, sonra döngü, sonra dosya, sonra DLL çağrısı olarak ayrı ayrı dene.

### 181. POKE
**Sınıf:** Bellek  
**Sözdizimi:** `POKE adres[, değer[, uzunluk]]`  
**Ne işe yarar:** POKE bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
POKE hedef, kaynak, uzunluk
```
### 182. POKEB
**Sınıf:** Bellek  
**Sözdizimi:** `POKEB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** POKEB bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
POKEB hedef, kaynak, uzunluk
```
### 183. POKEW
**Sınıf:** Bellek  
**Sözdizimi:** `POKEW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** POKEW bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
POKEW hedef, kaynak, uzunluk
```
### 184. POKED
**Sınıf:** Bellek  
**Sözdizimi:** `POKED adres[, değer[, uzunluk]]`  
**Ne işe yarar:** POKED bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
POKED hedef, kaynak, uzunluk
```
### 185. POKES
**Sınıf:** Bellek  
**Sözdizimi:** `POKES adres[, değer[, uzunluk]]`  
**Ne işe yarar:** POKES bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
POKES hedef, kaynak, uzunluk
```
### 186. MEMCOPYB
**Sınıf:** Bellek  
**Sözdizimi:** `MEMCOPYB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** MEMCOPYB bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
MEMCOPYB hedef, kaynak, uzunluk
```
### 187. MEMCOPYW
**Sınıf:** Bellek  
**Sözdizimi:** `MEMCOPYW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** MEMCOPYW bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
MEMCOPYW hedef, kaynak, uzunluk
```
### 188. MEMCOPYD
**Sınıf:** Bellek  
**Sözdizimi:** `MEMCOPYD adres[, değer[, uzunluk]]`  
**Ne işe yarar:** MEMCOPYD bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
MEMCOPYD hedef, kaynak, uzunluk
```
### 189. MEMFILLB
**Sınıf:** Bellek  
**Sözdizimi:** `MEMFILLB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** MEMFILLB bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
MEMFILLB hedef, kaynak, uzunluk
```
### 190. MEMFILLW
**Sınıf:** Bellek  
**Sözdizimi:** `MEMFILLW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** MEMFILLW bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
MEMFILLW hedef, kaynak, uzunluk
```
### 191. MEMFILLD
**Sınıf:** Bellek  
**Sözdizimi:** `MEMFILLD adres[, değer[, uzunluk]]`  
**Ne işe yarar:** MEMFILLD bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
MEMFILLD hedef, kaynak, uzunluk
```
### 192. SETNEWOFFSET
**Sınıf:** Bellek  
**Sözdizimi:** `SETNEWOFFSET adres[, değer[, uzunluk]]`  
**Ne işe yarar:** SETNEWOFFSET bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
SETNEWOFFSET hedef, kaynak, uzunluk
```
### 193. INC
**Sınıf:** Bellek  
**Sözdizimi:** `INC adres[, değer[, uzunluk]]`  
**Ne işe yarar:** INC bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
INC hedef, kaynak, uzunluk
```
### 194. DEC
**Sınıf:** Bellek  
**Sözdizimi:** `DEC adres[, değer[, uzunluk]]`  
**Ne işe yarar:** DEC bellek ve ham veri işlemlerinde kullanılır. Yanlış adres veri bozacağı için testle kullanılmalıdır.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
DEC hedef, kaynak, uzunluk
```
### 195. ENUM
**Sınıf:** Listeleme  
**Sözdizimi:** `ENUM ...`  
**Ne işe yarar:** ENUM uXBasic dil yüzeyinde tanınan anahtar sözcüktür; bulunduğu bağlama göre parser tarafından ilgili düğüme çevrilir.  
**Nerede kullanılır:** Program akışı, veri tutma, dış dünya ile haberleşme veya derleyici hedefi kurma sırasında kullanılır.
```uxbasic
' ENUM komutu bağlama göre kullanılır
```
## Ön-işleyici komutları

Ön-işleyici komutları `%%` ile başlar. Bunlar normal BASIC komutu değildir; parser/AST/MIR içine normal komut olarak girmez. Kaynak daha derlenmeden hedef dosya, makro, koşul, yapılandırma ve web varlığı üretir.
|No|Komut|Sınıf/Durum|Sözdizimi|Görev|
|---|---|---|---|---|
|1|%%DEFINE|existing|legacy textual define / boolean symbol|legacy textual define / boolean symbol|
|2|%%SET|new|meta variable assignment|meta variable assignment|
|3|%%ALIAS|new|single-line text alias: %%ALIAS {old} AS {new}|single-line text alias: %%ALIAS {old} AS {new}|
|4|%%MACRO|existing|single-line macro/function macro|single-line macro/function macro|
|5|%%IF|existing|conditional source selection|conditional source selection|
|6|%%IFC|existing|textual conditional compare|textual conditional compare|
|7|%%FOR|new|compile-time numeric loop|compile-time numeric loop|
|8|%%FOREACH|new|compile-time list loop|compile-time list loop|
|9|%%REPEAT|new|compile-time fixed repeat|compile-time fixed repeat|
|10|%%TARGET|new|select active artifact target|select active artifact target|
|11|%%OUTDIR|new|set artifact output directory|set artifact output directory|
|12|%%SECTION|new|set current artifact section|set current artifact section|
|13|%%JS_BEGIN|new|capture JS block|capture JS block|
|14|%%JS_LINE|new|capture one JS line|capture one JS line|
|15|%%JS_FILE|new|register external JS file|register external JS file|
|16|%%WAT_BEGIN|new|capture WAT block|capture WAT block|
|17|%%WAT_IMPORT|new|declare WAT host import|declare WAT host import|
|18|%%WAT_EXPORT|new|declare WAT export|declare WAT export|
|19|%%WASM_HOST_JS_BEGIN|new|capture WASM host JS glue|capture WASM host JS glue|
|20|%%HTML_BEGIN|new|capture HTML block/file|capture HTML block/file|
|21|%%HTML_LINE|new|capture one HTML line|capture one HTML line|
|22|%%HTML_SCRIPT|new|emit script tag metadata|emit script tag metadata|
|23|%%HTML_STYLE|new|emit stylesheet tag metadata|emit stylesheet tag metadata|
|24|%%CSS_BEGIN|new|capture CSS block/file|capture CSS block/file|
|25|%%CSS_LINE|new|capture one CSS line|capture one CSS line|
|26|%%JSON_BEGIN|new|capture JSON block/file|capture JSON block/file|
|27|%%JSON_SET|new|set JSON key/value|set JSON key/value|
|28|%%MANIFEST_SET|new|set build manifest key/value|set build manifest key/value|
|29|%%MANIFEST_REQUIRE|new|declare required artifact/binding|declare required artifact/binding|
|30|%%MD_BEGIN|new|capture markdown block|capture markdown block|
|31|%%MD_FILE|new|register markdown file|register markdown file|
|32|%%ASSET_ROOT|new|set asset root|set asset root|
|33|%%ASSET_COPY|new|copy/register asset|copy/register asset|
|34|%%ASSET_FILE|new|register generic file asset|register generic file asset|
|35|%%ASSET_IMAGE|new|register image asset|register image asset|
|36|%%ASSET_AUDIO|new|register audio asset|register audio asset|
|37|%%ALLOW_RAW_JS|new|allow raw JS blocks|allow raw JS blocks|
|38|%%ALLOW_RAW_WAT|new|allow raw WAT blocks|allow raw WAT blocks|
|39|%%SAFE_PATHS|new|path safety policy|path safety policy|
|40|%%REQUIRE_HOST_BINDING|new|require host binding for WAT imports|require host binding for WAT imports|
|41|%%ASSERT_META|new|fail compile-time if condition false|fail compile-time if condition false|
|42|%%WARN_META|new|emit compile-time warning|emit compile-time warning|
|43|%%IFN|condition|%%IFN WIDTH >= 800|numeric compile-time condition|
|44|%%ELIF|condition|%%ELIF TARGET == \WEB\""|intermediate branch for IF/IFN/IFC|
|45|%%PROFILE|build|%%PROFILE DEBUG|select build profile|
|46|%%CONFIG_FILE|config|%%CONFIG_FILE \build.json\""|load flat config into meta variables|
|47|%%PATH_ALIAS|path|%%PATH_ALIAS \@assets\" AS \"assets\""|define path alias|
|48|%%LOCK_META|meta|%%LOCK_META TITLE|prevent further mutation of meta variable|
|49|%%DUMP_META|diagnostic|%%DUMP_META \reports/meta.json\""|dump preprocessor state to json|
|50|%%SOURCE_MAP|source-map|%%SOURCE_MAP \main.uxb:html-head\""|set source map tag for next artifact blocks|
|51|%%EMITNOTE|artifact|%%EMITNOTE \Generated by uXBasic\""|emit note/comment into current target|
|52|%%ENV|environment|%%ENV \PATH\" AS PATH_VALUE"|read environment variable into meta variable|
|53|%%DEPRECATED|diagnostic|%%DEPRECATED \OLD_FN\"|register deprecated symbol warning|
|54|%%TEMPLATE_BEGIN|template|%%TEMPLATE_BEGIN CARD|begin reusable artifact template|
|55|%%TEMPLATE_END|template|%%TEMPLATE_END|end reusable template|
|56|%%TEMPLATE_USE|template|%%TEMPLATE_USE CARD INTO \index.html\""|apply template into target file|
|57|%%MINIFY|policy|%%MINIFY JS ON|set minify policy|
|58|%%FINGERPRINT_ASSETS|asset|%%FINGERPRINT_ASSETS ON|set asset fingerprint policy|
|59|%%HASHFILE|file|%%HASHFILE \a.png\" AS A_HASH"|hash file into meta variable|
|60|%%COPY_DIR|asset|%%COPY_DIR \assets\" TO \"dist/assets\""|add directory copy action to manifest|
|61|%%EMBEDTEXT|embed|%%EMBEDTEXT \shader.wgsl\" AS SHADER"|embed text file into meta variable|
|62|%%EMBEDBASE64|embed|%%EMBEDBASE64 \icon.png\" AS ICON64"|embed small binary as base64 meta variable|
|63|%%LICENSEFILE|release|%%LICENSEFILE \LICENSE.txt\""|add license file to release manifest|
|64|%%HTMLIMAGE|html|%%HTMLIMAGE \player\"|emit img tag plus image asset|
|65|%%HTMLAUDIO|html|%%HTMLAUDIO \music\"|emit audio tag plus audio asset|
|66|%%CSS_RULE|css|%%CSS_RULE \#app\"|emit css selector rule|
|67|%%CSS_IMPORT|css|%%CSS_IMPORT \reset.css\""|emit css import line|
|68|%%MD_SAFE|markdown|%%MD_SAFE ON|set markdown sanitize policy|
|69|%%MD_CSS|markdown|%%MD_CSS \doc.css\""|attach css to markdown html|
|70|%%BREAK|meta-loop|%%BREAK|break current meta loop|
|71|%%CONTINUE|meta-loop|%%CONTINUE|continue current meta loop|
|72|%%INFOMETA|diagnostic|%%INFOMETA \message\""|compile-time info message|
### Ön-işleyici 1: %%DEFINE
`legacy textual define / boolean symbol` biçiminde kullanılır. Görevi: legacy textual define / boolean symbol. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%DEFINE ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 2: %%SET
`meta variable assignment` biçiminde kullanılır. Görevi: meta variable assignment. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%SET ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 3: %%ALIAS
`single-line text alias: %%ALIAS {old} AS {new}` biçiminde kullanılır. Görevi: single-line text alias: %%ALIAS {old} AS {new}. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 4: %%MACRO
`single-line macro/function macro` biçiminde kullanılır. Görevi: single-line macro/function macro. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 5: %%IF
`conditional source selection` biçiminde kullanılır. Görevi: conditional source selection. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%IF ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 6: %%IFC
`textual conditional compare` biçiminde kullanılır. Görevi: textual conditional compare. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 7: %%FOR
`compile-time numeric loop` biçiminde kullanılır. Görevi: compile-time numeric loop. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 8: %%FOREACH
`compile-time list loop` biçiminde kullanılır. Görevi: compile-time list loop. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 9: %%REPEAT
`compile-time fixed repeat` biçiminde kullanılır. Görevi: compile-time fixed repeat. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 10: %%TARGET
`select active artifact target` biçiminde kullanılır. Görevi: select active artifact target. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%TARGET ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 11: %%OUTDIR
`set artifact output directory` biçiminde kullanılır. Görevi: set artifact output directory. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%OUTDIR ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 12: %%SECTION
`set current artifact section` biçiminde kullanılır. Görevi: set current artifact section. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 13: %%JS_BEGIN
`capture JS block` biçiminde kullanılır. Görevi: capture JS block. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%JS_BEGIN ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 14: %%JS_LINE
`capture one JS line` biçiminde kullanılır. Görevi: capture one JS line. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 15: %%JS_FILE
`register external JS file` biçiminde kullanılır. Görevi: register external JS file. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 16: %%WAT_BEGIN
`capture WAT block` biçiminde kullanılır. Görevi: capture WAT block. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%WAT_BEGIN ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 17: %%WAT_IMPORT
`declare WAT host import` biçiminde kullanılır. Görevi: declare WAT host import. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 18: %%WAT_EXPORT
`declare WAT export` biçiminde kullanılır. Görevi: declare WAT export. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 19: %%WASM_HOST_JS_BEGIN
`capture WASM host JS glue` biçiminde kullanılır. Görevi: capture WASM host JS glue. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 20: %%HTML_BEGIN
`capture HTML block/file` biçiminde kullanılır. Görevi: capture HTML block/file. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%HTML_BEGIN ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 21: %%HTML_LINE
`capture one HTML line` biçiminde kullanılır. Görevi: capture one HTML line. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 22: %%HTML_SCRIPT
`emit script tag metadata` biçiminde kullanılır. Görevi: emit script tag metadata. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 23: %%HTML_STYLE
`emit stylesheet tag metadata` biçiminde kullanılır. Görevi: emit stylesheet tag metadata. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 24: %%CSS_BEGIN
`capture CSS block/file` biçiminde kullanılır. Görevi: capture CSS block/file. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 25: %%CSS_LINE
`capture one CSS line` biçiminde kullanılır. Görevi: capture one CSS line. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 26: %%JSON_BEGIN
`capture JSON block/file` biçiminde kullanılır. Görevi: capture JSON block/file. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 27: %%JSON_SET
`set JSON key/value` biçiminde kullanılır. Görevi: set JSON key/value. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 28: %%MANIFEST_SET
`set build manifest key/value` biçiminde kullanılır. Görevi: set build manifest key/value. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 29: %%MANIFEST_REQUIRE
`declare required artifact/binding` biçiminde kullanılır. Görevi: declare required artifact/binding. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 30: %%MD_BEGIN
`capture markdown block` biçiminde kullanılır. Görevi: capture markdown block. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 31: %%MD_FILE
`register markdown file` biçiminde kullanılır. Görevi: register markdown file. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 32: %%ASSET_ROOT
`set asset root` biçiminde kullanılır. Görevi: set asset root. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 33: %%ASSET_COPY
`copy/register asset` biçiminde kullanılır. Görevi: copy/register asset. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 34: %%ASSET_FILE
`register generic file asset` biçiminde kullanılır. Görevi: register generic file asset. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 35: %%ASSET_IMAGE
`register image asset` biçiminde kullanılır. Görevi: register image asset. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 36: %%ASSET_AUDIO
`register audio asset` biçiminde kullanılır. Görevi: register audio asset. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 37: %%ALLOW_RAW_JS
`allow raw JS blocks` biçiminde kullanılır. Görevi: allow raw JS blocks. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 38: %%ALLOW_RAW_WAT
`allow raw WAT blocks` biçiminde kullanılır. Görevi: allow raw WAT blocks. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 39: %%SAFE_PATHS
`path safety policy` biçiminde kullanılır. Görevi: path safety policy. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 40: %%REQUIRE_HOST_BINDING
`require host binding for WAT imports` biçiminde kullanılır. Görevi: require host binding for WAT imports. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 41: %%ASSERT_META
`fail compile-time if condition false` biçiminde kullanılır. Görevi: fail compile-time if condition false. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 42: %%WARN_META
`emit compile-time warning` biçiminde kullanılır. Görevi: emit compile-time warning. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 43: %%IFN
`%%IFN WIDTH >= 800` biçiminde kullanılır. Görevi: numeric compile-time condition. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%IFN ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 44: %%ELIF
`%%ELIF TARGET == \WEB\""` biçiminde kullanılır. Görevi: intermediate branch for IF/IFN/IFC. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%ELIF ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 45: %%PROFILE
`%%PROFILE DEBUG` biçiminde kullanılır. Görevi: select build profile. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 46: %%CONFIG_FILE
`%%CONFIG_FILE \build.json\""` biçiminde kullanılır. Görevi: load flat config into meta variables. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 47: %%PATH_ALIAS
`%%PATH_ALIAS \@assets\" AS \"assets\""` biçiminde kullanılır. Görevi: define path alias. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%PATH_ALIAS ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 48: %%LOCK_META
`%%LOCK_META TITLE` biçiminde kullanılır. Görevi: prevent further mutation of meta variable. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 49: %%DUMP_META
`%%DUMP_META \reports/meta.json\""` biçiminde kullanılır. Görevi: dump preprocessor state to json. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%DUMP_META ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 50: %%SOURCE_MAP
`%%SOURCE_MAP \main.uxb:html-head\""` biçiminde kullanılır. Görevi: set source map tag for next artifact blocks. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 51: %%EMITNOTE
`%%EMITNOTE \Generated by uXBasic\""` biçiminde kullanılır. Görevi: emit note/comment into current target. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 52: %%ENV
`%%ENV \PATH\" AS PATH_VALUE"` biçiminde kullanılır. Görevi: read environment variable into meta variable. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 53: %%DEPRECATED
`%%DEPRECATED \OLD_FN\"` biçiminde kullanılır. Görevi: register deprecated symbol warning. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 54: %%TEMPLATE_BEGIN
`%%TEMPLATE_BEGIN CARD` biçiminde kullanılır. Görevi: begin reusable artifact template. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 55: %%TEMPLATE_END
`%%TEMPLATE_END` biçiminde kullanılır. Görevi: end reusable template. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 56: %%TEMPLATE_USE
`%%TEMPLATE_USE CARD INTO \index.html\""` biçiminde kullanılır. Görevi: apply template into target file. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
```uxbasic
%%TEMPLATE_USE ORNEK = "deger"
PRINT "On isleyici kararindan sonra kalan BASIC kaynak"
```
### Ön-işleyici 57: %%MINIFY
`%%MINIFY JS ON` biçiminde kullanılır. Görevi: set minify policy. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 58: %%FINGERPRINT_ASSETS
`%%FINGERPRINT_ASSETS ON` biçiminde kullanılır. Görevi: set asset fingerprint policy. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 59: %%HASHFILE
`%%HASHFILE \a.png\" AS A_HASH"` biçiminde kullanılır. Görevi: hash file into meta variable. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 60: %%COPY_DIR
`%%COPY_DIR \assets\" TO \"dist/assets\""` biçiminde kullanılır. Görevi: add directory copy action to manifest. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 61: %%EMBEDTEXT
`%%EMBEDTEXT \shader.wgsl\" AS SHADER"` biçiminde kullanılır. Görevi: embed text file into meta variable. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 62: %%EMBEDBASE64
`%%EMBEDBASE64 \icon.png\" AS ICON64"` biçiminde kullanılır. Görevi: embed small binary as base64 meta variable. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 63: %%LICENSEFILE
`%%LICENSEFILE \LICENSE.txt\""` biçiminde kullanılır. Görevi: add license file to release manifest. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 64: %%HTMLIMAGE
`%%HTMLIMAGE \player\"` biçiminde kullanılır. Görevi: emit img tag plus image asset. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 65: %%HTMLAUDIO
`%%HTMLAUDIO \music\"` biçiminde kullanılır. Görevi: emit audio tag plus audio asset. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 66: %%CSS_RULE
`%%CSS_RULE \#app\"` biçiminde kullanılır. Görevi: emit css selector rule. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 67: %%CSS_IMPORT
`%%CSS_IMPORT \reset.css\""` biçiminde kullanılır. Görevi: emit css import line. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 68: %%MD_SAFE
`%%MD_SAFE ON` biçiminde kullanılır. Görevi: set markdown sanitize policy. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 69: %%MD_CSS
`%%MD_CSS \doc.css\""` biçiminde kullanılır. Görevi: attach css to markdown html. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 70: %%BREAK
`%%BREAK` biçiminde kullanılır. Görevi: break current meta loop. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 71: %%CONTINUE
`%%CONTINUE` biçiminde kullanılır. Görevi: continue current meta loop. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
### Ön-işleyici 72: %%INFOMETA
`%%INFOMETA \message\""` biçiminde kullanılır. Görevi: compile-time info message. Bu komut kaynak derlenmeden önce çalışır; bu yüzden normal `IF` ile karıştırılmaz.
## Veri tipleri
|No|Tip|Anlam|Sözdizimi|Örnek|
|---|---|---|---|---|
|1|I8|-128..127 arası küçük işaretli tam sayı|DIM x AS I8|DIM x AS I8|
|2|U8|0..255 arası küçük işaretsiz tam sayı|DIM x AS U8|DIM x AS U8|
|3|I16|16 bit işaretli tam sayı|DIM x AS I16|DIM x AS I16|
|4|U16|16 bit işaretsiz tam sayı|DIM x AS U16|DIM x AS U16|
|5|I32|genel amaçlı işaretli tam sayı|DIM x AS I32|DIM x AS I32|
|6|U32|genel amaçlı işaretsiz tam sayı|DIM x AS U32|DIM x AS U32|
|7|I64|büyük tam sayı sayaç ve dosya boyutu|DIM x AS I64|DIM x AS I64|
|8|U64|handle, adres, büyük sayaç|DIM x AS U64|DIM x AS U64|
|9|F32|32 bit kayan nokta|DIM x AS F32|DIM x AS F32|
|10|F64|genel bilimsel ondalık|DIM x AS F64|DIM x AS F64|
|11|F80|genişletilmiş kayan nokta runtime DLL ile|DIM x AS F80|DIM x AS F80|
|12|F128|dört duyarlıklı kayan nokta runtime DLL ile|DIM x AS F128|DIM x AS F128|
|13|BIGF|yüksek duyarlıklı ikili kayan sayı|DIM x AS BIGF|DIM x AS BIGF|
|14|BIGD|ondalık duyarlık odaklı büyük sayı|DIM x AS BIGD|DIM x AS BIGD|
|15|BALL|orta değer + hata yarıçapı mantığıyla güvenli aralık|DIM x AS BALL|DIM x AS BALL|
|16|BIGI|büyük tam sayı kısa adı|DIM x AS BIGI|DIM x AS BIGI|
|17|BIGINT|büyük tam sayı uzun adı; içte TYPE_BIGINT|DIM x AS BIGINT|DIM x AS BIGINT|
|18|BOOLEAN|doğru/yanlış|DIM x AS BOOLEAN|DIM x AS BOOLEAN|
|19|STRING|metin|DIM x AS STRING|DIM x AS STRING|
|20|OBJECT|nesne handle/kapsayıcı|DIM x AS OBJECT|DIM x AS OBJECT|
|21|PTR|ham adres/işaretçi|DIM x AS PTR|DIM x AS PTR|
|22|STRPTR|metin adresi|DIM x AS STRPTR|DIM x AS STRPTR|
|23|BYTE|ham bayt|DIM x AS BYTE|DIM x AS BYTE|
|24|ARRAY|sabit düzenli dizi|DIM x AS ARRAY|DIM x AS ARRAY|
|25|LIST|sıralı büyüyen liste|DIM x AS LIST|DIM x AS LIST|
|26|DICT|anahtar-değer sözlüğü|DIM x AS DICT|DIM x AS DICT|
|27|SET|benzersiz değer kümesi|DIM x AS SET|DIM x AS SET|
## İşleçler
|No|İşleç|Görev|Sözdizimi|Kısa örnek|
|---|---|---|---|---|
|1|+|toplama veya metin birleştirme|sonuc = sol + sağ|PRINT 7 + 3|
|2|-|çıkarma veya işaret değiştirme|sonuc = sol - sağ|PRINT 7 - 3|
|3|*|çarpma|sonuc = sol * sağ|PRINT 7 * 3|
|4|/|bölme|sonuc = sol / sağ|PRINT 7 / 3|
|5|\|tam sayı bölme|sonuc = sol \ sağ|PRINT 7 \ 3|
|6|MOD|kalan bulma|sonuc = sol MOD sağ|PRINT 7 MOD 3|
|7|^|üs alma|sonuc = sol ^ sağ|PRINT 7 ^ 3|
|8|=|eşitlik veya atama bağlamı|sonuc = sol = sağ|PRINT 7 = 3|
|9|<>|eşit değil|sonuc = sol <> sağ|PRINT 7 <> 3|
|10|<|küçüktür|sonuc = sol < sağ|PRINT 7 < 3|
|11|<=|küçük eşittir|sonuc = sol <= sağ|PRINT 7 <= 3|
|12|>|büyüktür|sonuc = sol > sağ|PRINT 7 > 3|
|13|>=|büyük eşittir|sonuc = sol >= sağ|PRINT 7 >= 3|
|14|AND|mantıksal ve / bit ve|sonuc = sol AND sağ|PRINT 7 AND 3|
|15|OR|mantıksal veya / bit veya|sonuc = sol OR sağ|PRINT 7 OR 3|
|16|XOR|özel veya|sonuc = sol XOR sağ|PRINT 7 XOR 3|
|17|NOT|değil|sonuc = NOT ifade|PRINT NOT 0|
|18|SHL|sola bit kaydırma|sonuc = sol SHL sağ|PRINT 7 SHL 3|
|19|SHR|sağa bit kaydırma|sonuc = sol SHR sağ|PRINT 7 SHR 3|
|20|ROL|döndürerek sola kaydırma|sonuc = sol ROL sağ|PRINT 7 ROL 3|
|21|ROR|döndürerek sağa kaydırma|sonuc = sol ROR sağ|PRINT 7 ROR 3|
|22|&|adres veya metin bağlama göre birleşim|sonuc = sol & sağ|PRINT 7 & 3|
|23|.|üye erişimi|bağlama göre kullanılır|PRINT NOT 0|
|24|#|dosya kanal işareti|bağlama göre kullanılır|PRINT NOT 0|
|25|:|aynı satırda komut ayırıcı|bağlama göre kullanılır|PRINT NOT 0|

### İşleç kullanma tekniği

Önce çarpma/bölme, sonra toplama/çıkarma, sonra karşılaştırma, sonra mantık düşünülür. Parantez kullanmak zayıflık değil, gelecekteki kendine mektuptur.
```uxbasic
DIM puan AS F64
puan = (vize * 0.40) + (final * 0.60)
IF puan >= 60 AND devamsizlik < 5 THEN
    PRINT "Gecti"
END IF
```

## Ek: Büyük sayı ailesi normal dil özelliği olarak nasıl düşünülür?

Bu bölümdeki adlar artık yama adı değildir; uXBasic programcısının normal tip ve başlatma düzenidir. Küçük sayılar için `I32`, `I64`, `F64` yeterlidir. Para hesabı, bilimsel hassasiyet, büyük tam sayı, aralık hesabı ve belirsizlik hesabı büyüdüğünde `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL` kullanılır. `BIGI` ve `BIGINT` programcı gözünde aynı aileye bağlı büyük tam sayı adlarıdır; iç tip raporlarında ana ad `BIGINT` olarak düşünülebilir. Başlatma işi tek kapıdan yapılır: `BIGINIT`.

|No|Tip|Anlam|Ne zaman kullanılır|Başlatma örneği|
|---:|---|---|---|---|
|BT-1|`BIGI`|Büyük tam sayı|çok büyük sayaç, kripto olmayan büyük numara, nüfus/üretim toplamı|`A = BIGINIT("BIGI", "123456789123456789", 0)`|
|BT-2|`BIGINT`|Büyük tam sayı adı|`BIGI` ile aynı kullanım ailesi|`B = BIGINIT("BIGINT", "999999999999999999", 0)`|
|BT-3|`BIGD`|Basamak sayısı yüksek ondalık|para, muhasebe, hassas tartım|`D = BIGINIT("BIGD", "123.456", 80)`|
|BT-4|`BIGF`|İkili hassasiyeti yüksek kayan sayı|sayısal yöntem, fizik, mühendislik|`F = BIGINIT("BIGF", "3.1415926535", 256)`|
|BT-5|`BALL`|Aralık/top hesabı|sonucun alt-üst güven aralığını taşımak|`R = BIGINIT("BALL", "3.14", 256)`|

### BT-1 `BIGI` kullanımı

Sözdizimi: `DIM ad AS BIGI` ve `ad = BIGINIT("BIGI", "deger", 0)`. Büyük tam sayı normal `I64` sınırını aşan ama kesir taşımayan değerdir.

```uxbasic
DIM balik_sayisi AS BIGI
DIM gun AS I32
balik_sayisi = BIGINIT("BIGI", "123456789123456789", 0)
FOR gun = 1 TO 5
    PRINT "Gun="; gun; " toplam="; balik_sayisi
NEXT gun
```

### BT-2 `BIGINT` kullanımı

Sözdizimi: `DIM ad AS BIGINT`. Raporlarda ve eğitim metninde uzun adı seven programcı için kullanılır.

```uxbasic
DIM seri_no AS BIGINT
seri_no = BIGINIT("BIGINT", "987654321987654321987654321", 0)
PRINT "Buyuk seri no="; seri_no
```

### BT-3 `BIGD` kullanımı

Sözdizimi: `DIM ad AS BIGD(hassasiyet)` ve `BIGINIT("BIGD", metin, basamak)`. Ondalık düşünür; para ve laboratuvar tartımında hatayı azaltır.

```uxbasic
DIM gram AS BIGD(80)
DIM fiyat AS BIGD(80)
gram = BIGINIT("BIGD", "12.3456789012345", 80)
fiyat = BIGINIT("BIGD", "0.125", 80)
PRINT "Hassas tartim="; gram; " fiyat katsayisi="; fiyat
```

### BT-4 `BIGF` kullanımı

Sözdizimi: `DIM ad AS BIGF(bit)` ve `BIGINIT("BIGF", metin, bit)`. Matematik hesabında daha yüksek hassasiyet ister.

```uxbasic
DIM pi AS BIGF(256)
DIM r AS BIGF(256)
pi = BIGINIT("BIGF", "3.141592653589793238462643383", 256)
r = BIGINIT("BIGF", "2.5", 256)
PRINT "Daire hesabinda pi="; pi; " r="; r
```

### BT-5 `BALL` kullanımı

Sözdizimi: `DIM ad AS BALL(bit)`. Tek sayı yerine aralık ruhu taşır. Ölçüm hatası, güven aralığı ve bilimsel belirsizlikte kullanılır.

```uxbasic
DIM sonuc AS BALL(256)
sonuc = BIGINIT("BALL", "7.80", 256)
PRINT "pH sonucu aralikli saklandi="; sonuc
```

### Büyük sayı ailesiyle beş komutlu anlamlı örnek

Bu örnekte `DIM`, `BIGINIT`, `FOR`, `IF`, `PRINT`, `CALL` birlikte kullanılır. Program, yem üretiminde çok büyük parti numarası ile hassas oranı aynı raporda tutar.

```uxbasic
INCLUDE "include/extfp.uxmh"
DIM parti AS BIGI
DIM oran AS BIGD(80)
DIM i AS I32
parti = BIGINIT("BIGI", "202605300000000000001", 0)
oran = BIGINIT("BIGD", "0.0375", 80)
FOR i = 1 TO 3
    IF i = 1 THEN PRINT "Ana parti="; parti
    PRINT "Deneme "; i; " oran="; oran
NEXT i
CALL log_big_report(parti, oran)
```

## Ek: Ön-işleyici geliştirmelerinin normal kullanım kitabı

Ön-işleyici, kaynak kod lexer katmanına girmeden önce çalışan hazırlık ustasıdır. Normal komut gibi AST üretmez; dosya birleştirir, hedef seçer, varlık üretir, koşula göre kod açar, tarayıcı veya WAT varlıkları hazırlar, kaynak haritası çıkarır. Genç programcı bunu gizli büyü gibi değil, matbaa kalıbı gibi düşünmelidir: aynı programı Windows, tarayıcı ve WASM için farklı kalıplarla çoğaltır.

|No|Komut ailesi|Görev|Kısa sözdizimi|
|---:|---|---|---|
|PP-1|`%%DEFINE`, `%%SET`, `%%UNDEF`|sabit/meta değişken tanımlar|`%%DEFINE AD "deger"`|
|PP-2|`%%IF`, `%%IFN`, `%%IFC`, `%%ELIF`, `%%ELSE`, `%%ENDIF`|kaynak parçasını koşula göre açar|`%%IF TARGET="BROWSER"`|
|PP-3|`%%FOR`, `%%FOREACH`, `%%REPEAT`|tekrarlı kaynak üretir|`%%FOREACH K IN A,B,C`|
|PP-4|`%%TARGET`, `%%OUTDIR`, `%%SECTION`|çıktı hedefini düzenler|`%%TARGET BROWSER`|
|PP-5|`%%JS_BEGIN`, `%%JS_LINE`, `%%JS_FILE`|JavaScript varlığı üretir|`%%JS_BEGIN "program.js" BODY`|
|PP-6|`%%HTML_BEGIN`, `%%CSS_BEGIN`, `%%ASSET`|tarayıcı kabuğu ve varlık ekler|`%%HTML_BEGIN "index.html" BODY`|
|PP-7|`%%WAT_BEGIN`, `%%WASM_IMPORT`, `%%WASM_EXPORT`|WAT/WASM köprüsü kurar|`%%WAT_BEGIN "math.wat" BODY`|
|PP-8|`%%PROFILE`, `%%CONFIG_FILE`, `%%PATH_ALIAS`|proje ayarı ve yol kısaltır|`%%PATH_ALIAS SRC "src"`|
|PP-9|`%%LOCK_META`, `%%DUMP_META`, `%%SOURCE_MAP`|meta güvenliği ve raporlama|`%%SOURCE_MAP "map.json"`|
|PP-10|`%%EVAL`, `%%EMITNOTE`, `%%ENV`|değer üretir, not yazar, çevre okur|`%%ENV APIKEY OPENAI_API_KEY`|

### PP-1 tanımlama ailesi

`%%DEFINE` sabit ad verir. `%%SET` değişebilen meta değer taşır. `%%UNDEF` artık istenmeyen adı kaldırır.

```uxbasic
%%DEFINE APP_NAME "HavuzIzleme"
%%SET SURUM "1.0"
PRINT "Uygulama hazir"
```

### PP-2 koşul ailesi

Hedefe göre kod seçer. Aynı kaynak tarayıcıda başka, yerelde başka çalışabilir.

```uxbasic
%%TARGET BROWSER
%%IF TARGET="BROWSER"
PRINT "Tarayici paketi uretilecek"
%%ELSE
PRINT "Yerel exe paketi uretilecek"
%%ENDIF
```

### PP-3 tekrar ailesi

Tekrarlı kodu elle kopyalamayı azaltır. Hata sayısı düşer.

```uxbasic
%%FOREACH AD IN PH,SICAKLIK,OKSIJEN
PRINT "Olcum alani: AD"
%%ENDFOREACH
```

### PP-4 hedef ve çıktı ailesi

Programın nereye çıktı vereceğini belirler.

```uxbasic
%%TARGET WASM
%%OUTDIR "dist/wasm"
PRINT "WASM hedefi secildi"
```

### PP-5 JS ailesi

uXBasic programı yanında tarayıcı kodu üretir.

```uxbasic
%%JS_BEGIN "program.js" BODY
console.log("uXBasic JS varligi");
%%JS_END
PRINT "JS dosyasi eklendi"
```

### PP-7 WAT/WASM ailesi

Çok küçük ama hızlı fonksiyonları WAT olarak üretmek için kullanılır.

```uxbasic
%%WAT_BEGIN "topla.wat" BODY
(module (func $topla (param i32 i32) (result i32) local.get 0 local.get 1 i32.add))
%%WAT_END
PRINT "WAT eklendi"
```

### PP-8 proje ayarı ailesi

Büyük projede yol karmaşasını azaltır.

```uxbasic
%%PROFILE "release"
%%PATH_ALIAS LIB "include/modules"
INCLUDE "LIB/uxmath.uxmh"
PRINT "Profil ve yol alias hazir"
```

### PP-9 rapor ailesi

Derleme sonunda nereden ne üretildiğini gösterir. Test kapılarında çok değerlidir.

```uxbasic
%%SOURCE_MAP "build/source_map.json"
%%DUMP_META "build/meta.json"
PRINT "Raporlu derleme"
```

### PP-10 çevre ve not ailesi

Gizli anahtarları kaynak koda gömmeden okutur.

```uxbasic
%%ENV OPENAI_KEY OPENAI_API_KEY
%%EMITNOTE "Anahtar kaynak koda yazilmadi"
PRINT "Guvenli ayar hazir"
```
