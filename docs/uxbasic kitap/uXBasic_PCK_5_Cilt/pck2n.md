# uXBasic Programlayıcının Cep Kitabı — Cilt 2
## Dil Yüzeyi, Komutlar, Ön-İşleyici, Tipler, İşleçler ve Yerel Fonksiyonlar

Bu ciltte amaç komut ezberletmek değil, her komutun program içindeki yerini göstermektir. Önce anahtar kelimeleri görürsün; sonra gerçek parser dağıtımındaki komutlar gelir. Bir anahtar kelime lexer tarafından tanınıyor olabilir ama her hedefte aynı derinlikte işlenmeyebilir. Bu kitapta her şeyin çalıştığını varsayıyoruz; yine de iyi programcı her hedefte test alır.
## Anahtar kelime tablosu

|No|Anahtar|Kısa anlam|
|---|---|---|
|1|IF|Şarta göre iki yoldan birini seçtirir.|
|2|THEN|Dil tarafından tanınan sözcük veya yerel ad.|
|3|ELSE|Dil tarafından tanınan sözcük veya yerel ad.|
|4|ELSEIF|Dil tarafından tanınan sözcük veya yerel ad.|
|5|END|Programı veya bloğu bitirir.|
|6|SELECT|Bir değeri birçok olasılığa göre dallandırır.|
|7|CASE|Dil tarafından tanınan sözcük veya yerel ad.|
|8|IS|Dil tarafından tanınan sözcük veya yerel ad.|
|9|TRY|Hata yakalama bloğu açar.|
|10|CATCH|Dil tarafından tanınan sözcük veya yerel ad.|
|11|FINALLY|Dil tarafından tanınan sözcük veya yerel ad.|
|12|THROW|Bilerek hata fırlatır.|
|13|ASSERT|Bir şart doğru değilse testte hata üretir.|
|14|EVENT|Olay tanımlar.|
|15|THREAD|İş parçacığı başlatır.|
|16|THREAT|Dil tarafından tanınan sözcük veya yerel ad.|
|17|PARALEL|Paralel iş bloğu kurar.|
|18|PARALLEL|Dil tarafından tanınan sözcük veya yerel ad.|
|19|PIPE|İki iş arasında veri borusu kurar.|
|20|SLOT|Olayın bağlanacağı alıcı yuva tanımlar.|
|21|ON|Olay, hata veya ayarı açar/bağlar.|
|22|OFF|Olay, hata veya ayarı kapatır.|
|23|TRIGGER|Olayı tetikler.|
|24|BYTE|Dil tarafından tanınan sözcük veya yerel ad.|
|25|FOR|Sayı ile döngü kurar.|
|26|TO|Dil tarafından tanınan sözcük veya yerel ad.|
|27|STEP|Dil tarafından tanınan sözcük veya yerel ad.|
|28|NEXT|Dil tarafından tanınan sözcük veya yerel ad.|
|29|DO|Şartlı veya açık uçlu döngü kurar.|
|30|LOOP|Dil tarafından tanınan sözcük veya yerel ad.|
|31|WHILE|Dil tarafından tanınan sözcük veya yerel ad.|
|32|UNTIL|Dil tarafından tanınan sözcük veya yerel ad.|
|33|EXIT|Döngüden, yordamdan veya bloktan çıkar.|
|34|EACH|Dil tarafından tanınan sözcük veya yerel ad.|
|35|IN|Dil tarafından tanınan sözcük veya yerel ad.|
|36|SUB|Geri değer döndürmeyen yordam tanımlar.|
|37|FUNCTION|Geri değer döndüren yordam tanımlar.|
|38|DECLARE|Dış fonksiyon, DLL veya API bildirimini yapar.|
|39|RETURN|Fonksiyon veya GOSUB dönüşünü yapar.|
|40|GOTO|Etikete doğrudan atlar; az kullanılmalıdır.|
|41|GOSUB|Eski BASIC tarzı alt bölüme gider, RETURN ile döner.|
|42|CALL|İç yordamı, dış DLL/API çağrısını veya kayıtlı servisi çağırır.|
|43|TYPE|Alanlardan oluşan kayıt tipi kurar.|
|44|CLASS|Nesne yönelimli sınıf tanımlar.|
|45|INTERFACE|Sınıfların uyması gereken sözleşmeyi tanımlar.|
|46|IMPLEMENTS|Dil tarafından tanınan sözcük veya yerel ad.|
|47|METHOD|Dil tarafından tanınan sözcük veya yerel ad.|
|48|SIHIRLIMETOT|Dil tarafından tanınan sözcük veya yerel ad.|
|49|MAGIC|Dil tarafından tanınan sözcük veya yerel ad.|
|50|VIRTUAL|Dil tarafından tanınan sözcük veya yerel ad.|
|51|OVERRIDE|Dil tarafından tanınan sözcük veya yerel ad.|
|52|CONSTRUCTOR|Dil tarafından tanınan sözcük veya yerel ad.|
|53|DESTRUCTOR|Dil tarafından tanınan sözcük veya yerel ad.|
|54|NEW|Dil tarafından tanınan sözcük veya yerel ad.|
|55|DELETE|NEW ile açılmış nesne veya kaynağı bırakır.|
|56|DIM|Değişken veya dizi tanımlar.|
|57|REDIM|Dizinin boyutunu sonradan değiştirir.|
|58|AS|Dil tarafından tanınan sözcük veya yerel ad.|
|59|CONST|Değişmeyen sabit tanımlar.|
|60|INCLUDE|Başka uXBasic başlık/kaynak dosyasını ekler.|
|61|IMPORT|Derleme zamanında C/C++/ASM gibi dış kaynak dosyasını projeye alır.|
|62|ABSTRACT|Dil tarafından tanınan sözcük veya yerel ad.|
|63|FINAL|Dil tarafından tanınan sözcük veya yerel ad.|
|64|SEALED|Dil tarafından tanınan sözcük veya yerel ad.|
|65|STATIC|Dil tarafından tanınan sözcük veya yerel ad.|
|66|PROPERTY|Dil tarafından tanınan sözcük veya yerel ad.|
|67|OPERATOR|Dil tarafından tanınan sözcük veya yerel ad.|
|68|MIXIN|Dil tarafından tanınan sözcük veya yerel ad.|
|69|DECORATOR|Dil tarafından tanınan sözcük veya yerel ad.|
|70|PUBLIC|Dil tarafından tanınan sözcük veya yerel ad.|
|71|PRIVATE|Dil tarafından tanınan sözcük veya yerel ad.|
|72|PROTECTED|Dil tarafından tanınan sözcük veya yerel ad.|
|73|RESTRICTED|Dil tarafından tanınan sözcük veya yerel ad.|
|74|FRIEND|Dil tarafından tanınan sözcük veya yerel ad.|
|75|READONLY|Dil tarafından tanınan sözcük veya yerel ad.|
|76|MUTABLE|Dil tarafından tanınan sözcük veya yerel ad.|
|77|IMMUTABLE|Dil tarafından tanınan sözcük veya yerel ad.|
|78|MAIN|Programın ana giriş bölümünü belirtir.|
|79|NAMESPACE|Ad çakışmasını önleyen ad alanı açar.|
|80|MODULE|Bir işi yapan kod/kütüphane birimini tanımlar.|
|81|USING|Bir ad alanını veya modülü kısa adla kullanmaya açar.|
|82|ALIAS|Uzun bir adı kısa veya uyumlu başka bir ada bağlar.|
|83|DEFINT|Dil tarafından tanınan sözcük veya yerel ad.|
|84|DEFLNG|Dil tarafından tanınan sözcük veya yerel ad.|
|85|DEFSNG|Dil tarafından tanınan sözcük veya yerel ad.|
|86|DEFDBL|Dil tarafından tanınan sözcük veya yerel ad.|
|87|DEFEXT|Dil tarafından tanınan sözcük veya yerel ad.|
|88|DEFSTR|Dil tarafından tanınan sözcük veya yerel ad.|
|89|DEFBYT|Dil tarafından tanınan sözcük veya yerel ad.|
|90|PRINT|Ekrana, dosyaya veya çalışma günlüğüne değer yazdırır. İlk denemelerde en çok kullanılan komuttur.|
|91|INPUT|Kullanıcıdan metin/sayı alır.|
|92|OPEN|Dosya açar.|
|93|CLOSE|Dosyayı kapatır.|
|94|GET|Dosyadan veya bellekten okur.|
|95|PUT|Dosyaya veya belleğe yazar.|
|96|SEEK|Dosya konumunu değiştirir.|
|97|CLS|Ekranı temizler.|
|98|COLOR|Ekran yazı/zemin rengini ayarlar.|
|99|LOCATE|Ekranda yazı konumunu ayarlar.|
|100|AND|Dil tarafından tanınan sözcük veya yerel ad.|
|101|OR|Dil tarafından tanınan sözcük veya yerel ad.|
|102|NOT|Dil tarafından tanınan sözcük veya yerel ad.|
|103|XOR|Dil tarafından tanınan sözcük veya yerel ad.|
|104|MOD|Dil tarafından tanınan sözcük veya yerel ad.|
|105|SHL|Dil tarafından tanınan sözcük veya yerel ad.|
|106|SHR|Dil tarafından tanınan sözcük veya yerel ad.|
|107|ROL|Dil tarafından tanınan sözcük veya yerel ad.|
|108|ROR|Dil tarafından tanınan sözcük veya yerel ad.|
|109|INLINE|C, C++, ASM veya başka ara kod parçasını kaynak içine yerleştirir.|
|110|I8|Dil tarafından tanınan sözcük veya yerel ad.|
|111|U8|Dil tarafından tanınan sözcük veya yerel ad.|
|112|I16|Dil tarafından tanınan sözcük veya yerel ad.|
|113|U16|Dil tarafından tanınan sözcük veya yerel ad.|
|114|I32|Dil tarafından tanınan sözcük veya yerel ad.|
|115|U32|Dil tarafından tanınan sözcük veya yerel ad.|
|116|I64|Dil tarafından tanınan sözcük veya yerel ad.|
|117|U64|Dil tarafından tanınan sözcük veya yerel ad.|
|118|F32|Dil tarafından tanınan sözcük veya yerel ad.|
|119|F64|Dil tarafından tanınan sözcük veya yerel ad.|
|120|F80|Dil tarafından tanınan sözcük veya yerel ad.|
|121|F128|Dil tarafından tanınan sözcük veya yerel ad.|
|122|BIGF|Dil tarafından tanınan sözcük veya yerel ad.|
|123|BIGD|Dil tarafından tanınan sözcük veya yerel ad.|
|124|BALL|Dil tarafından tanınan sözcük veya yerel ad.|
|125|BOOLEAN|Dil tarafından tanınan sözcük veya yerel ad.|
|126|STRING|Dil tarafından tanınan sözcük veya yerel ad.|
|127|OBJECT|Dil tarafından tanınan sözcük veya yerel ad.|
|128|PTR|Dil tarafından tanınan sözcük veya yerel ad.|
|129|STRPTR|Dil tarafından tanınan sözcük veya yerel ad.|
|130|BYREF|Dil tarafından tanınan sözcük veya yerel ad.|
|131|BYVAL|Dil tarafından tanınan sözcük veya yerel ad.|
|132|CDECL|Dil tarafından tanınan sözcük veya yerel ad.|
|133|STDCALL|Dil tarafından tanınan sözcük veya yerel ad.|
|134|ARRAY|Dil tarafından tanınan sözcük veya yerel ad.|
|135|LIST|Dil tarafından tanınan sözcük veya yerel ad.|
|136|DICT|Dil tarafından tanınan sözcük veya yerel ad.|
|137|SET|Dil tarafından tanınan sözcük veya yerel ad.|
|138|SETSTRINGSIZE|Dil tarafından tanınan sözcük veya yerel ad.|
|139|TIMER|Dil tarafından tanınan sözcük veya yerel ad.|
|140|LOF|Dil tarafından tanınan sözcük veya yerel ad.|
|141|EOF|Dil tarafından tanınan sözcük veya yerel ad.|
|142|LEN|Dil tarafından tanınan sözcük veya yerel ad.|
|143|MID|Dil tarafından tanınan sözcük veya yerel ad.|
|144|STR|Dil tarafından tanınan sözcük veya yerel ad.|
|145|VAL|Dil tarafından tanınan sözcük veya yerel ad.|
|146|ABS|Dil tarafından tanınan sözcük veya yerel ad.|
|147|INT|Dil tarafından tanınan sözcük veya yerel ad.|
|148|UCASE|Dil tarafından tanınan sözcük veya yerel ad.|
|149|LCASE|Dil tarafından tanınan sözcük veya yerel ad.|
|150|ASC|Dil tarafından tanınan sözcük veya yerel ad.|
|151|CHR|Dil tarafından tanınan sözcük veya yerel ad.|
|152|LTRIM|Dil tarafından tanınan sözcük veya yerel ad.|
|153|RTRIM|Dil tarafından tanınan sözcük veya yerel ad.|
|154|SPACE|Dil tarafından tanınan sözcük veya yerel ad.|
|155|SGN|Dil tarafından tanınan sözcük veya yerel ad.|
|156|SQRT|Dil tarafından tanınan sözcük veya yerel ad.|
|157|SIN|Dil tarafından tanınan sözcük veya yerel ad.|
|158|COS|Dil tarafından tanınan sözcük veya yerel ad.|
|159|TAN|Dil tarafından tanınan sözcük veya yerel ad.|
|160|ATN|Dil tarafından tanınan sözcük veya yerel ad.|
|161|EXP|Dil tarafından tanınan sözcük veya yerel ad.|
|162|LOG|Dil tarafından tanınan sözcük veya yerel ad.|
|163|INKEY|Dil tarafından tanınan sözcük veya yerel ad.|
|164|GETKEY|Dil tarafından tanınan sözcük veya yerel ad.|
|165|VARPTR|Dil tarafından tanınan sözcük veya yerel ad.|
|166|SADD|Dil tarafından tanınan sözcük veya yerel ad.|
|167|LPTR|Dil tarafından tanınan sözcük veya yerel ad.|
|168|CODEPTR|Dil tarafından tanınan sözcük veya yerel ad.|
|169|SIZEOF|Dil tarafından tanınan sözcük veya yerel ad.|
|170|OFFSETOF|Dil tarafından tanınan sözcük veya yerel ad.|
|171|CINT|Dil tarafından tanınan sözcük veya yerel ad.|
|172|CLNG|Dil tarafından tanınan sözcük veya yerel ad.|
|173|CDBL|Dil tarafından tanınan sözcük veya yerel ad.|
|174|CSNG|Dil tarafından tanınan sözcük veya yerel ad.|
|175|FIX|Dil tarafından tanınan sözcük veya yerel ad.|
|176|SQR|Dil tarafından tanınan sözcük veya yerel ad.|
|177|RND|Dil tarafından tanınan sözcük veya yerel ad.|
|178|RANDOMIZE|Rastgele sayı tohumunu kurar.|
|179|PEEKB|Dil tarafından tanınan sözcük veya yerel ad.|
|180|PEEKW|Dil tarafından tanınan sözcük veya yerel ad.|
|181|PEEKD|Dil tarafından tanınan sözcük veya yerel ad.|
|182|POKE|Belleğe yazar.|
|183|POKEB|Belleğe bayt yazar.|
|184|POKEW|Belleğe kelime yazar.|
|185|POKED|Belleğe çift kelime yazar.|
|186|POKES|Belleğe metin yazar.|
|187|MEMCOPYB|Bayt bellek kopyalar.|
|188|MEMCOPYW|Kelime bellek kopyalar.|
|189|MEMCOPYD|Çift kelime bellek kopyalar.|
|190|MEMFILLB|Bayt bellek doldurur.|
|191|MEMFILLW|Kelime bellek doldurur.|
|192|MEMFILLD|Çift kelime bellek doldurur.|
|193|SETNEWOFFSET|Nesne/bellek yerleşim ofsetini ayarlar.|
|194|INC|Sayıyı artırır.|
|195|DEC|Sayıyı azaltır.|
|196|ENUM|Dil tarafından tanınan sözcük veya yerel ad.|

## Parser komutları

|No|Komut|Bağlam|Bakış|Söz dizimi|
|---|---|---|---|---|
|1|PRINT|STMT_HANDLER_PRINT||PRINT ifade [, ifade...]|
|2|INLINE|STMT_HANDLER_INLINE||INLINE(C\|CPP\|ASM, "ad") ... END INLINE|
|3|CALL|STMT_HANDLER_CALL||CALL ad(arg1, arg2)  veya CALL(DLL, "dll", "fonksiyon", ...)|
|4|IF|STMT_HANDLER_IF||IF şart THEN ... ELSE ... END IF|
|5|SELECT|STMT_HANDLER_SELECT||SELECT CASE ifade ... CASE değer ... END SELECT|
|6|FOR|STMT_HANDLER_FOR|EACH|FOR i = başlangıç TO bitiş STEP adım ... NEXT|
|7|DO|STMT_HANDLER_DO|EACH|DO WHILE şart ... LOOP|
|8|GOTO|STMT_HANDLER_GOTO||GOTO etiket|
|9|GOSUB|STMT_HANDLER_GOSUB||GOSUB etiket|
|10|RETURN|STMT_HANDLER_RETURN||RETURN [ifade]|
|11|EXIT|STMT_HANDLER_EXIT||EXIT FOR\|DO\|SUB\|FUNCTION|
|12|END|STMT_HANDLER_END||END [IF\|SELECT\|TYPE\|CLASS\|NAMESPACE\|MODULE]|
|13|TRY|STMT_HANDLER_TRY||TRY ... CATCH e ... FINALLY ... END TRY|
|14|THROW|STMT_HANDLER_THROW||THROW "hata mesajı"|
|15|ASSERT|STMT_HANDLER_ASSERT||ASSERT şart, "mesaj"|
|16|DELETE|STMT_HANDLER_DELETE||DELETE nesne|
|17|DECLARE|STMT_HANDLER_DECLARE||DECLARE FUNCTION ad LIB "dll" ALIAS "gerçek_ad" (...) AS tip|
|18|SUB|STMT_HANDLER_SUB||SUB ad(parametreler) ... END SUB|
|19|FUNCTION|STMT_HANDLER_FUNCTION||FUNCTION ad(parametreler) AS tip ... END FUNCTION|
|20|CONST|STMT_HANDLER_CONST||CONST AD AS tip = değer|
|21|DIM|STMT_HANDLER_DIM||DIM ad AS tip  veya DIM a(10,10) AS I32|
|22|REDIM|STMT_HANDLER_REDIM||REDIM dizi(yeniBoyut)|
|23|TYPE|STMT_HANDLER_TYPE||TYPE Ad ... alan AS tip ... END TYPE|
|24|CLASS|STMT_HANDLER_CLASS||CLASS Ad ... END CLASS|
|25|ABSTRACT|STMT_HANDLER_CLASS|CLASS|ABSTRACT ...|
|26|FINAL|STMT_HANDLER_CLASS|CLASS|FINAL ...|
|27|SEALED|STMT_HANDLER_CLASS|CLASS|SEALED ...|
|28|INTERFACE|STMT_HANDLER_INTERFACE||INTERFACE Ad ... END INTERFACE|
|29|NAMESPACE|STMT_HANDLER_NAMESPACE||NAMESPACE Ad ... END NAMESPACE|
|30|MODULE|STMT_HANDLER_MODULE||MODULE Ad ... END MODULE|
|31|MAIN|STMT_HANDLER_MAIN||MAIN ... END MAIN|
|32|USING|STMT_HANDLER_USING||USING NamespaceAdi|
|33|ALIAS|STMT_HANDLER_ALIAS||ALIAS kısaAd = uzunAd|
|34|DEFINT|STMT_HANDLER_DEFTYPE||DEFINT A-Z|
|35|DEFLNG|STMT_HANDLER_DEFTYPE||DEFLNG A-Z|
|36|DEFSNG|STMT_HANDLER_DEFTYPE||DEFSNG A-Z|
|37|DEFDBL|STMT_HANDLER_DEFTYPE||DEFDBL A-Z|
|38|DEFEXT|STMT_HANDLER_DEFTYPE||DEFEXT A-Z|
|39|DEFSTR|STMT_HANDLER_DEFTYPE||DEFSTR A-Z|
|40|DEFBYT|STMT_HANDLER_DEFTYPE||DEFBYT A-Z|
|41|SETSTRINGSIZE|STMT_HANDLER_SETSTRINGSIZE||SETSTRINGSIZE 255|
|42|INCLUDE|STMT_HANDLER_INCLUDE||INCLUDE "dosya.uxmh"|
|43|IMPORT|STMT_HANDLER_IMPORT||IMPORT(C, "dosya.c")|
|44|INPUT|STMT_HANDLER_INPUT||INPUT "Soru"; degisken|
|45|INPUTF|STMT_HANDLER_INPUTF||INPUTF "%d", sayi|
|46|OPEN|STMT_HANDLER_OPEN||OPEN "dosya.txt" FOR OUTPUT AS #1|
|47|CLOSE|STMT_HANDLER_CLOSE||CLOSE #1|
|48|GET|STMT_HANDLER_GET||GET #1, , degisken|
|49|PUT|STMT_HANDLER_PUT||PUT #1, , degisken|
|50|SEEK|STMT_HANDLER_SEEK||SEEK #1, konum|
|51|LOCATE|STMT_HANDLER_LOCATE||LOCATE satir, sutun|
|52|COLOR|STMT_HANDLER_COLOR||COLOR önRenk, arkaRenk|
|53|CLS|STMT_HANDLER_CLS||CLS|
|54|INC|STMT_HANDLER_INC||INC sayi [, adım]|
|55|DEC|STMT_HANDLER_DEC||DEC sayi [, adım]|
|56|RANDOMIZE|STMT_HANDLER_RANDOMIZE||RANDOMIZE TIMER|
|57|POKEB|STMT_HANDLER_POKEB||POKEB adres, değer|
|58|POKEW|STMT_HANDLER_POKEW||POKEW adres, değer|
|59|POKED|STMT_HANDLER_POKED||POKED adres, değer|
|60|POKE|STMT_HANDLER_POKE||POKE adres, değer|
|61|MEMCOPYB|STMT_HANDLER_MEMCOPYB||MEMCOPYB hedef, kaynak, adet|
|62|MEMFILLB|STMT_HANDLER_MEMFILLB||MEMFILLB hedef, değer, adet|
|63|POKES|STMT_HANDLER_POKES||POKES adres, metin|
|64|MEMCOPYW|STMT_HANDLER_MEMCOPYW||MEMCOPYW hedef, kaynak, adet|
|65|MEMCOPYD|STMT_HANDLER_MEMCOPYD||MEMCOPYD hedef, kaynak, adet|
|66|MEMFILLW|STMT_HANDLER_MEMFILLW||MEMFILLW hedef, değer, adet|
|67|MEMFILLD|STMT_HANDLER_MEMFILLD||MEMFILLD hedef, değer, adet|
|68|SETNEWOFFSET|STMT_HANDLER_SETNEWOFFSET||SETNEWOFFSET tipAdi, alanAdi, ofset|
|69|EVENT|STMT_HANDLER_EVENT||EVENT ad(parametreler)|
|70|THREAD|STMT_HANDLER_THREAD||THREAD ad(args)|
|71|PARALEL|STMT_HANDLER_PARALEL||PARALEL ... END PARALEL|
|72|PIPE|STMT_HANDLER_PIPE||PIPE kaynak TO hedef|
|73|SLOT|STMT_HANDLER_SLOT||SLOT ad(parametreler)|
|74|ON|STMT_HANDLER_ON||ON eventAdi CALL slotAdi|
|75|OFF|STMT_HANDLER_OFF||OFF eventAdi|
|76|TRIGGER|STMT_HANDLER_TRIGGER||TRIGGER eventAdi(args)|

## Komutların tek tek kullanımı

### 1. `PRINT`

**Görev:** Ekrana, dosyaya veya çalışma günlüğüne değer yazdırır. İlk denemelerde en çok kullanılan komuttur.

**Söz dizimi:** `PRINT ifade [, ifade...]`

**Küçük örnek:**

```basic
PRINT "Merhaba uXBasic"
PRINT 10 + 20
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 2. `INLINE`

**Görev:** C, C++, ASM veya başka ara kod parçasını kaynak içine yerleştirir.

**Söz dizimi:** `INLINE(C|CPP|ASM, "ad") ... END INLINE`

**Küçük örnek:**

```basic
INLINE(C|CPP|ASM, "ad") ... END INLINE
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 3. `CALL`

**Görev:** İç yordamı, dış DLL/API çağrısını veya kayıtlı servisi çağırır.

**Söz dizimi:** `CALL ad(arg1, arg2)  veya CALL(DLL, "dll", "fonksiyon", ...)`

**Küçük örnek:**

```basic
CALL Topla(3,4)
CALL(DLL, "kernel32.dll", "Beep", 750, 300)
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 4. `IF`

**Görev:** Şarta göre iki yoldan birini seçtirir.

**Söz dizimi:** `IF şart THEN ... ELSE ... END IF`

**Küçük örnek:**

```basic
IF yas >= 18 THEN
    PRINT "Yetiskin"
ELSE
    PRINT "Genc"
END IF
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 5. `SELECT`

**Görev:** Bir değeri birçok olasılığa göre dallandırır.

**Söz dizimi:** `SELECT CASE ifade ... CASE değer ... END SELECT`

**Küçük örnek:**

```basic
SELECT CASE ifade ... CASE değer ... END SELECT
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 6. `FOR`

**Görev:** Sayı ile döngü kurar.

**Söz dizimi:** `FOR i = başlangıç TO bitiş STEP adım ... NEXT`

**Küçük örnek:**

```basic
FOR i = 1 TO 5
    PRINT i
NEXT
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 7. `DO`

**Görev:** Şartlı veya açık uçlu döngü kurar.

**Söz dizimi:** `DO WHILE şart ... LOOP`

**Küçük örnek:**

```basic
DO WHILE n < 10
    INC n
LOOP
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 8. `GOTO`

**Görev:** Etikete doğrudan atlar; az kullanılmalıdır.

**Söz dizimi:** `GOTO etiket`

**Küçük örnek:**

```basic
GOTO etiket
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 9. `GOSUB`

**Görev:** Eski BASIC tarzı alt bölüme gider, RETURN ile döner.

**Söz dizimi:** `GOSUB etiket`

**Küçük örnek:**

```basic
GOSUB etiket
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 10. `RETURN`

**Görev:** Fonksiyon veya GOSUB dönüşünü yapar.

**Söz dizimi:** `RETURN [ifade]`

**Küçük örnek:**

```basic
RETURN [ifade]
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 11. `EXIT`

**Görev:** Döngüden, yordamdan veya bloktan çıkar.

**Söz dizimi:** `EXIT FOR|DO|SUB|FUNCTION`

**Küçük örnek:**

```basic
EXIT FOR|DO|SUB|FUNCTION
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 12. `END`

**Görev:** Programı veya bloğu bitirir.

**Söz dizimi:** `END [IF|SELECT|TYPE|CLASS|NAMESPACE|MODULE]`

**Küçük örnek:**

```basic
END [IF|SELECT|TYPE|CLASS|NAMESPACE|MODULE]
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 13. `TRY`

**Görev:** Hata yakalama bloğu açar.

**Söz dizimi:** `TRY ... CATCH e ... FINALLY ... END TRY`

**Küçük örnek:**

```basic
TRY
    CALL RiskliIs()
CATCH e
    PRINT "Hata yakalandi"
END TRY
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 14. `THROW`

**Görev:** Bilerek hata fırlatır.

**Söz dizimi:** `THROW "hata mesajı"`

**Küçük örnek:**

```basic
THROW "hata mesajı"
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 15. `ASSERT`

**Görev:** Bir şart doğru değilse testte hata üretir.

**Söz dizimi:** `ASSERT şart, "mesaj"`

**Küçük örnek:**

```basic
ASSERT şart, "mesaj"
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 16. `DELETE`

**Görev:** NEW ile açılmış nesne veya kaynağı bırakır.

**Söz dizimi:** `DELETE nesne`

**Küçük örnek:**

```basic
DELETE nesne
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 17. `DECLARE`

**Görev:** Dış fonksiyon, DLL veya API bildirimini yapar.

**Söz dizimi:** `DECLARE FUNCTION ad LIB "dll" ALIAS "gerçek_ad" (...) AS tip`

**Küçük örnek:**

```basic
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "MessageBoxA" (hwnd AS PTR, text AS STRING, title AS STRING, flags AS I32) AS I32
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 18. `SUB`

**Görev:** Geri değer döndürmeyen yordam tanımlar.

**Söz dizimi:** `SUB ad(parametreler) ... END SUB`

**Küçük örnek:**

```basic
SUB ad(parametreler) ... END SUB
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 19. `FUNCTION`

**Görev:** Geri değer döndüren yordam tanımlar.

**Söz dizimi:** `FUNCTION ad(parametreler) AS tip ... END FUNCTION`

**Küçük örnek:**

```basic
FUNCTION ad(parametreler) AS tip ... END FUNCTION
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 20. `CONST`

**Görev:** Değişmeyen sabit tanımlar.

**Söz dizimi:** `CONST AD AS tip = değer`

**Küçük örnek:**

```basic
CONST AD AS tip = değer
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 21. `DIM`

**Görev:** Değişken veya dizi tanımlar.

**Söz dizimi:** `DIM ad AS tip  veya DIM a(10,10) AS I32`

**Küçük örnek:**

```basic
DIM toplam AS I32
DIM ad AS STRING
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 22. `REDIM`

**Görev:** Dizinin boyutunu sonradan değiştirir.

**Söz dizimi:** `REDIM dizi(yeniBoyut)`

**Küçük örnek:**

```basic
REDIM dizi(yeniBoyut)
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 23. `TYPE`

**Görev:** Alanlardan oluşan kayıt tipi kurar.

**Söz dizimi:** `TYPE Ad ... alan AS tip ... END TYPE`

**Küçük örnek:**

```basic
TYPE Ad ... alan AS tip ... END TYPE
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 24. `CLASS`

**Görev:** Nesne yönelimli sınıf tanımlar.

**Söz dizimi:** `CLASS Ad ... END CLASS`

**Küçük örnek:**

```basic
CLASS Balik
    DIM agirlik AS F64
END CLASS
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 25. `ABSTRACT`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `ABSTRACT ...`

**Küçük örnek:**

```basic
ABSTRACT ...
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 26. `FINAL`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `FINAL ...`

**Küçük örnek:**

```basic
FINAL ...
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 27. `SEALED`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `SEALED ...`

**Küçük örnek:**

```basic
SEALED ...
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 28. `INTERFACE`

**Görev:** Sınıfların uyması gereken sözleşmeyi tanımlar.

**Söz dizimi:** `INTERFACE Ad ... END INTERFACE`

**Küçük örnek:**

```basic
INTERFACE Ad ... END INTERFACE
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 29. `NAMESPACE`

**Görev:** Ad çakışmasını önleyen ad alanı açar.

**Söz dizimi:** `NAMESPACE Ad ... END NAMESPACE`

**Küçük örnek:**

```basic
NAMESPACE Ad ... END NAMESPACE
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 30. `MODULE`

**Görev:** Bir işi yapan kod/kütüphane birimini tanımlar.

**Söz dizimi:** `MODULE Ad ... END MODULE`

**Küçük örnek:**

```basic
MODULE Ad ... END MODULE
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 31. `MAIN`

**Görev:** Programın ana giriş bölümünü belirtir.

**Söz dizimi:** `MAIN ... END MAIN`

**Küçük örnek:**

```basic
MAIN ... END MAIN
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 32. `USING`

**Görev:** Bir ad alanını veya modülü kısa adla kullanmaya açar.

**Söz dizimi:** `USING NamespaceAdi`

**Küçük örnek:**

```basic
USING NamespaceAdi
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 33. `ALIAS`

**Görev:** Uzun bir adı kısa veya uyumlu başka bir ada bağlar.

**Söz dizimi:** `ALIAS kısaAd = uzunAd`

**Küçük örnek:**

```basic
ALIAS kısaAd = uzunAd
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 34. `DEFINT`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `DEFINT A-Z`

**Küçük örnek:**

```basic
DEFINT A-Z
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 35. `DEFLNG`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `DEFLNG A-Z`

**Küçük örnek:**

```basic
DEFLNG A-Z
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 36. `DEFSNG`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `DEFSNG A-Z`

**Küçük örnek:**

```basic
DEFSNG A-Z
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 37. `DEFDBL`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `DEFDBL A-Z`

**Küçük örnek:**

```basic
DEFDBL A-Z
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 38. `DEFEXT`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `DEFEXT A-Z`

**Küçük örnek:**

```basic
DEFEXT A-Z
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 39. `DEFSTR`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `DEFSTR A-Z`

**Küçük örnek:**

```basic
DEFSTR A-Z
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 40. `DEFBYT`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `DEFBYT A-Z`

**Küçük örnek:**

```basic
DEFBYT A-Z
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 41. `SETSTRINGSIZE`

**Görev:** Bu komut uXBasic dil yüzeyinde tanınan bir yapı kurar.

**Söz dizimi:** `SETSTRINGSIZE 255`

**Küçük örnek:**

```basic
SETSTRINGSIZE 255
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 42. `INCLUDE`

**Görev:** Başka uXBasic başlık/kaynak dosyasını ekler.

**Söz dizimi:** `INCLUDE "dosya.uxmh"`

**Küçük örnek:**

```basic
INCLUDE "core.uxmh"
INCLUDE "modules/uxstats.uxmh"
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 43. `IMPORT`

**Görev:** Derleme zamanında C/C++/ASM gibi dış kaynak dosyasını projeye alır.

**Söz dizimi:** `IMPORT(C, "dosya.c")`

**Küçük örnek:**

```basic
IMPORT(C, "kutuphane.c")
IMPORT(ASM, "hizli_rutin.asm")
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 44. `INPUT`

**Görev:** Kullanıcıdan metin/sayı alır.

**Söz dizimi:** `INPUT "Soru"; degisken`

**Küçük örnek:**

```basic
INPUT "Soru"; degisken
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 45. `INPUTF`

**Görev:** Biçimli giriş alır.

**Söz dizimi:** `INPUTF "%d", sayi`

**Küçük örnek:**

```basic
INPUTF "%d", sayi
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 46. `OPEN`

**Görev:** Dosya açar.

**Söz dizimi:** `OPEN "dosya.txt" FOR OUTPUT AS #1`

**Küçük örnek:**

```basic
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "Baslik"
CLOSE #1
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 47. `CLOSE`

**Görev:** Dosyayı kapatır.

**Söz dizimi:** `CLOSE #1`

**Küçük örnek:**

```basic
CLOSE #1
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 48. `GET`

**Görev:** Dosyadan veya bellekten okur.

**Söz dizimi:** `GET #1, , degisken`

**Küçük örnek:**

```basic
OPEN "veri.bin" FOR BINARY AS #1
GET #1, , x
CLOSE #1
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 49. `PUT`

**Görev:** Dosyaya veya belleğe yazar.

**Söz dizimi:** `PUT #1, , degisken`

**Küçük örnek:**

```basic
OPEN "veri.bin" FOR BINARY AS #1
PUT #1, , x
CLOSE #1
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 50. `SEEK`

**Görev:** Dosya konumunu değiştirir.

**Söz dizimi:** `SEEK #1, konum`

**Küçük örnek:**

```basic
SEEK #1, konum
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 51. `LOCATE`

**Görev:** Ekranda yazı konumunu ayarlar.

**Söz dizimi:** `LOCATE satir, sutun`

**Küçük örnek:**

```basic
LOCATE satir, sutun
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 52. `COLOR`

**Görev:** Ekran yazı/zemin rengini ayarlar.

**Söz dizimi:** `COLOR önRenk, arkaRenk`

**Küçük örnek:**

```basic
COLOR önRenk, arkaRenk
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 53. `CLS`

**Görev:** Ekranı temizler.

**Söz dizimi:** `CLS`

**Küçük örnek:**

```basic
CLS
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 54. `INC`

**Görev:** Sayıyı artırır.

**Söz dizimi:** `INC sayi [, adım]`

**Küçük örnek:**

```basic
INC sayi [, adım]
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 55. `DEC`

**Görev:** Sayıyı azaltır.

**Söz dizimi:** `DEC sayi [, adım]`

**Küçük örnek:**

```basic
DEC sayi [, adım]
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 56. `RANDOMIZE`

**Görev:** Rastgele sayı tohumunu kurar.

**Söz dizimi:** `RANDOMIZE TIMER`

**Küçük örnek:**

```basic
RANDOMIZE TIMER
PRINT RND()
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 57. `POKEB`

**Görev:** Belleğe bayt yazar.

**Söz dizimi:** `POKEB adres, değer`

**Küçük örnek:**

```basic
POKEB adres, değer
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 58. `POKEW`

**Görev:** Belleğe kelime yazar.

**Söz dizimi:** `POKEW adres, değer`

**Küçük örnek:**

```basic
POKEW adres, değer
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 59. `POKED`

**Görev:** Belleğe çift kelime yazar.

**Söz dizimi:** `POKED adres, değer`

**Küçük örnek:**

```basic
POKED adres, değer
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 60. `POKE`

**Görev:** Belleğe yazar.

**Söz dizimi:** `POKE adres, değer`

**Küçük örnek:**

```basic
POKE adres, değer
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 61. `MEMCOPYB`

**Görev:** Bayt bellek kopyalar.

**Söz dizimi:** `MEMCOPYB hedef, kaynak, adet`

**Küçük örnek:**

```basic
MEMCOPYB hedef, kaynak, adet
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 62. `MEMFILLB`

**Görev:** Bayt bellek doldurur.

**Söz dizimi:** `MEMFILLB hedef, değer, adet`

**Küçük örnek:**

```basic
MEMFILLB hedef, değer, adet
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 63. `POKES`

**Görev:** Belleğe metin yazar.

**Söz dizimi:** `POKES adres, metin`

**Küçük örnek:**

```basic
POKES adres, metin
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 64. `MEMCOPYW`

**Görev:** Kelime bellek kopyalar.

**Söz dizimi:** `MEMCOPYW hedef, kaynak, adet`

**Küçük örnek:**

```basic
MEMCOPYW hedef, kaynak, adet
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 65. `MEMCOPYD`

**Görev:** Çift kelime bellek kopyalar.

**Söz dizimi:** `MEMCOPYD hedef, kaynak, adet`

**Küçük örnek:**

```basic
MEMCOPYD hedef, kaynak, adet
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 66. `MEMFILLW`

**Görev:** Kelime bellek doldurur.

**Söz dizimi:** `MEMFILLW hedef, değer, adet`

**Küçük örnek:**

```basic
MEMFILLW hedef, değer, adet
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 67. `MEMFILLD`

**Görev:** Çift kelime bellek doldurur.

**Söz dizimi:** `MEMFILLD hedef, değer, adet`

**Küçük örnek:**

```basic
MEMFILLD hedef, değer, adet
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 68. `SETNEWOFFSET`

**Görev:** Nesne/bellek yerleşim ofsetini ayarlar.

**Söz dizimi:** `SETNEWOFFSET tipAdi, alanAdi, ofset`

**Küçük örnek:**

```basic
SETNEWOFFSET tipAdi, alanAdi, ofset
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 69. `EVENT`

**Görev:** Olay tanımlar.

**Söz dizimi:** `EVENT ad(parametreler)`

**Küçük örnek:**

```basic
EVENT VeriGeldi(deger AS I32)
SLOT Yaz(deger AS I32)
ON VeriGeldi CALL Yaz
TRIGGER VeriGeldi(42)
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 70. `THREAD`

**Görev:** İş parçacığı başlatır.

**Söz dizimi:** `THREAD ad(args)`

**Küçük örnek:**

```basic
THREAD Hesapla(1000)
PRINT "Ana is devam ediyor"
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 71. `PARALEL`

**Görev:** Paralel iş bloğu kurar.

**Söz dizimi:** `PARALEL ... END PARALEL`

**Küçük örnek:**

```basic
PARALEL ... END PARALEL
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 72. `PIPE`

**Görev:** İki iş arasında veri borusu kurar.

**Söz dizimi:** `PIPE kaynak TO hedef`

**Küçük örnek:**

```basic
PIPE sensorVerisi TO analizci
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 73. `SLOT`

**Görev:** Olayın bağlanacağı alıcı yuva tanımlar.

**Söz dizimi:** `SLOT ad(parametreler)`

**Küçük örnek:**

```basic
SLOT ad(parametreler)
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 74. `ON`

**Görev:** Olay, hata veya ayarı açar/bağlar.

**Söz dizimi:** `ON eventAdi CALL slotAdi`

**Küçük örnek:**

```basic
ON eventAdi CALL slotAdi
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 75. `OFF`

**Görev:** Olay, hata veya ayarı kapatır.

**Söz dizimi:** `OFF eventAdi`

**Küçük örnek:**

```basic
OFF eventAdi
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### 76. `TRIGGER`

**Görev:** Olayı tetikler.

**Söz dizimi:** `TRIGGER eventAdi(args)`

**Küçük örnek:**

```basic
TRIGGER eventAdi(args)
```

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

## Ön-işleyici komutları

|No|Komut|Görev|Söz dizimi|
|---|---|---|---|
|1|%%DEFINE|Derleme öncesi sabit tanımlar.|%%DEFINE değer|
|2|%%SET|Derleme ayarı yazar.|%%SET değer|
|3|%%MACRO|Derleme öncesi makro tanımlar.|%%MACRO değer|
|4|%%UNDEF|Tanımı kaldırır.|%%UNDEF değer|
|5|%%IF|Şartlı derleme açar.|%%IF değer|
|6|%%IFC|Karşılaştırmalı şartlı derleme yapar.|%%IFC değer|
|7|%%ELSE|Şartın ters kolu.|%%ELSE değer|
|8|%%ENDIF|Şartlı bloğu kapatır.|%%ENDIF değer|
|9|%%INCLUDE|Derleme öncesi dosya ekler.|%%INCLUDE değer|
|10|%%ENDCOMP|Derlemeyi burada bitirir.|%%ENDCOMP değer|
|11|%%ERRORENDCOMP|Hata ile derlemeyi bitirir.|%%ERRORENDCOMP değer|
|12|%%PLATFORM|Platform bilgisi kullanır.|%%PLATFORM değer|
|13|%%DESTOS|Hedef işletim sistemi seçer.|%%DESTOS değer|
|14|%%NOZEROVARS|Sıfırlama davranışını değiştirir.|%%NOZEROVARS değer|
|15|%%SECSTACK|Güvenli yığın ayarı yapar.|%%SECSTACK değer|
### Ön-işleyici 1. `%%DEFINE`

Derleme öncesi sabit tanımlar. Söz dizimi: `%%DEFINE ...`

```basic
%%DEFINE DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 2. `%%SET`

Derleme ayarı yazar. Söz dizimi: `%%SET ...`

```basic
%%SET DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 3. `%%MACRO`

Derleme öncesi makro tanımlar. Söz dizimi: `%%MACRO ...`

```basic
%%MACRO DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 4. `%%UNDEF`

Tanımı kaldırır. Söz dizimi: `%%UNDEF ...`

```basic
%%UNDEF DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 5. `%%IF`

Şartlı derleme açar. Söz dizimi: `%%IF ...`

```basic
%%IF DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 6. `%%IFC`

Karşılaştırmalı şartlı derleme yapar. Söz dizimi: `%%IFC ...`

```basic
%%IFC DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 7. `%%ELSE`

Şartın ters kolu. Söz dizimi: `%%ELSE ...`

```basic
%%ELSE DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 8. `%%ENDIF`

Şartlı bloğu kapatır. Söz dizimi: `%%ENDIF ...`

```basic
%%ENDIF DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 9. `%%INCLUDE`

Derleme öncesi dosya ekler. Söz dizimi: `%%INCLUDE ...`

```basic
%%INCLUDE DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 10. `%%ENDCOMP`

Derlemeyi burada bitirir. Söz dizimi: `%%ENDCOMP ...`

```basic
%%ENDCOMP DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 11. `%%ERRORENDCOMP`

Hata ile derlemeyi bitirir. Söz dizimi: `%%ERRORENDCOMP ...`

```basic
%%ERRORENDCOMP DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 12. `%%PLATFORM`

Platform bilgisi kullanır. Söz dizimi: `%%PLATFORM ...`

```basic
%%PLATFORM DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 13. `%%DESTOS`

Hedef işletim sistemi seçer. Söz dizimi: `%%DESTOS ...`

```basic
%%DESTOS DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 14. `%%NOZEROVARS`

Sıfırlama davranışını değiştirir. Söz dizimi: `%%NOZEROVARS ...`

```basic
%%NOZEROVARS DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Ön-işleyici 15. `%%SECSTACK`

Güvenli yığın ayarı yapar. Söz dizimi: `%%SECSTACK ...`

```basic
%%SECSTACK DEMO
PRINT "Derleme oncesi ayar denendi"
```

## Veri tipleri

|Tip|Anlam|
|---|---|
|I8|-128..127 küçük tamsayı|
|U8|0..255 işaretsiz küçük tamsayı|
|I16|16 bit tamsayı|
|U16|16 bit işaretsiz|
|I32|genel amaç tamsayı|
|U32|genel amaç işaretsiz|
|I64|büyük tamsayı|
|U64|büyük işaretsiz|
|F32|tek duyarlıklı kesirli sayı|
|F64|çift duyarlıklı kesirli sayı|
|F80|geniş kayan nokta|
|F128|çok geniş kayan nokta|
|BIGF|çok büyük kesirli sayı|
|BIGD|çok büyük ondalık sayı|
|BALL|çok büyük mantıksal/özel geniş tip|
|BOOLEAN|TRUE/FALSE|
|STRING|metin|
|OBJECT|nesne|
|PTR|adres gösterici|
### `I8`

-128..127 küçük tamsayı. Kullanım: `DIM x AS I8`.

```basic
DIM x AS I8
PRINT x
```

### `U8`

0..255 işaretsiz küçük tamsayı. Kullanım: `DIM x AS U8`.

```basic
DIM x AS U8
PRINT x
```

### `I16`

16 bit tamsayı. Kullanım: `DIM x AS I16`.

```basic
DIM x AS I16
PRINT x
```

### `U16`

16 bit işaretsiz. Kullanım: `DIM x AS U16`.

```basic
DIM x AS U16
PRINT x
```

### `I32`

genel amaç tamsayı. Kullanım: `DIM x AS I32`.

```basic
DIM x AS I32
PRINT x
```

### `U32`

genel amaç işaretsiz. Kullanım: `DIM x AS U32`.

```basic
DIM x AS U32
PRINT x
```

### `I64`

büyük tamsayı. Kullanım: `DIM x AS I64`.

```basic
DIM x AS I64
PRINT x
```

### `U64`

büyük işaretsiz. Kullanım: `DIM x AS U64`.

```basic
DIM x AS U64
PRINT x
```

### `F32`

tek duyarlıklı kesirli sayı. Kullanım: `DIM x AS F32`.

```basic
DIM x AS F32
PRINT x
```

### `F64`

çift duyarlıklı kesirli sayı. Kullanım: `DIM x AS F64`.

```basic
DIM x AS F64
PRINT x
```

### `F80`

geniş kayan nokta. Kullanım: `DIM x AS F80`.

```basic
DIM x AS F80
PRINT x
```

### `F128`

çok geniş kayan nokta. Kullanım: `DIM x AS F128`.

```basic
DIM x AS F128
PRINT x
```

### `BIGF`

çok büyük kesirli sayı. Kullanım: `DIM x AS BIGF`.

```basic
DIM x AS BIGF
PRINT x
```

### `BIGD`

çok büyük ondalık sayı. Kullanım: `DIM x AS BIGD`.

```basic
DIM x AS BIGD
PRINT x
```

### `BALL`

çok büyük mantıksal/özel geniş tip. Kullanım: `DIM x AS BALL`.

```basic
DIM x AS BALL
PRINT x
```

### `BOOLEAN`

TRUE/FALSE. Kullanım: `DIM x AS BOOLEAN`.

```basic
DIM x AS BOOLEAN
PRINT x
```

### `STRING`

metin. Kullanım: `DIM x AS STRING`.

```basic
DIM x AS STRING
PRINT x
```

### `OBJECT`

nesne. Kullanım: `DIM x AS OBJECT`.

```basic
DIM x AS OBJECT
PRINT x
```

### `PTR`

adres gösterici. Kullanım: `DIM x AS PTR`.

```basic
DIM x AS PTR
PRINT x
```

## İşleçler

|İşleç|Görev|
|---|---|
|+|toplama veya metin birleştirme|
|-|çıkarma veya negatif yapma|
|*|çarpma|
|/|bölme|
|MOD|kalan|
|=|eşitlik/atama bağlamına göre|
|<>|eşit değil|
|< <= > >=|karşılaştırma|
|AND OR NOT XOR|mantıksal işlemler|
|SHL SHR|bit kaydırma|
|ROL ROR|bit döndürme|
|&|adres veya özel birleştirme bağlamı|
|BYREF/BYVAL|parametre aktarım biçimi|
### `+`

toplama veya metin birleştirme. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a + b
```

### `-`

çıkarma veya negatif yapma. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a - b
```

### `*`

çarpma. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a * b
```

### `/`

bölme. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a / b
```

### `MOD`

kalan. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a MOD b
```

### `=`

eşitlik/atama bağlamına göre. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a = b
```

### `<>`

eşit değil. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a + b
```

### `< <= > >=`

karşılaştırma. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a + b
```

### `AND OR NOT XOR`

mantıksal işlemler. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a AND b
```

### `SHL SHR`

bit kaydırma. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a SHL b
```

### `ROL ROR`

bit döndürme. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a ROL b
```

### `&`

adres veya özel birleştirme bağlamı. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a + b
```

### `BYREF/BYVAL`

parametre aktarım biçimi. Küçük deneme:

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a BYREF/BYVAL b
```

## Yerel fonksiyonlar

|Fonksiyon|Görev|
|---|---|
|TIMER|zaman sayacı|
|LOF|dosya uzunluğu|
|EOF|dosya sonu|
|LEN|metin/dizi uzunluğu|
|MID|metin parçası|
|STR|sayıyı metne çevirir|
|VAL|metni sayıya çevirir|
|ABS|mutlak değer|
|INT|tam sayı kısmı|
|UCASE/LCASE|büyük/küçük harf|
|ASC/CHR|karakter kodu dönüşümü|
|LTRIM/RTRIM|boşluk temizliği|
|SPACE|boşluk metni üretir|
|SGN|işaret|
|SQRT/SQR|karekök|
|SIN/COS/TAN/ATN|trigonometri|
|EXP/LOG|üstel/logaritma|
|INKEY/GETKEY|klavye okuma|
|VARPTR/STRPTR/SADD/LPTR/CODEPTR|adres alma|
|SIZEOF/OFFSETOF|boyut ve ofset|
|CINT/CLNG/CDBL/CSNG/FIX|tip dönüşümleri|
|RND|rastgele sayı|
|PEEKB/PEEKW/PEEKD|bellekten okuma|
### `TIMER`

zaman sayacı.

```basic
PRINT TIMER(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `LOF`

dosya uzunluğu.

```basic
PRINT LOF(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `EOF`

dosya sonu.

```basic
PRINT EOF(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `LEN`

metin/dizi uzunluğu.

```basic
PRINT LEN(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `MID`

metin parçası.

```basic
PRINT MID(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `STR`

sayıyı metne çevirir.

```basic
PRINT STR(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `VAL`

metni sayıya çevirir.

```basic
PRINT VAL(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `ABS`

mutlak değer.

```basic
PRINT ABS(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `INT`

tam sayı kısmı.

```basic
PRINT INT(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `UCASE/LCASE`

büyük/küçük harf.

```basic
PRINT UCASE(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `ASC/CHR`

karakter kodu dönüşümü.

```basic
PRINT ASC(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `LTRIM/RTRIM`

boşluk temizliği.

```basic
PRINT LTRIM(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `SPACE`

boşluk metni üretir.

```basic
PRINT SPACE(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `SGN`

işaret.

```basic
PRINT SGN(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `SQRT/SQR`

karekök.

```basic
PRINT SQRT(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `SIN/COS/TAN/ATN`

trigonometri.

```basic
PRINT SIN(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `EXP/LOG`

üstel/logaritma.

```basic
PRINT EXP(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `INKEY/GETKEY`

klavye okuma.

```basic
PRINT INKEY(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `VARPTR/STRPTR/SADD/LPTR/CODEPTR`

adres alma.

```basic
PRINT VARPTR(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `SIZEOF/OFFSETOF`

boyut ve ofset.

```basic
PRINT SIZEOF(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `CINT/CLNG/CDBL/CSNG/FIX`

tip dönüşümleri.

```basic
PRINT CINT(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `RND`

rastgele sayı.

```basic
PRINT RND(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### `PEEKB/PEEKW/PEEKD`

bellekten okuma.

```basic
PRINT PEEKB(10)
```

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

