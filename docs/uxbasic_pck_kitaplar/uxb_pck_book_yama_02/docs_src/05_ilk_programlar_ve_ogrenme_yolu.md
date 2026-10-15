# İlk Programlar ve Öğrenme Yolu

uXBasic öğrenmeye `PRINT` ile başlamak doğrudur; fakat `PRINT` yalnızca ekrana yazı basmak değildir. Bir dilin ilk komutu, kaynak koddan çıktı üretimine giden hattı gösterir. Programcı bir satır yazar, lexer bu satırı tokenlara ayırır, parser `PRINT_STMT` benzeri bir AST düğümü kurar, ifade çözülür ve runtime çıktı servisi değeri görünür hale getirir.

```basic
PRINT "uXBasic calisiyor"
```

Beklenen çıktı:

```text
uXBasic calisiyor
```

Bu ilk örnek bilinçli olarak küçüktür. Şimdi aynı yolu değişkenle genişletelim.

```basic
DIM a AS I32 = 10
DIM b AS I32 = 20
DIM c AS I32 = a + b
PRINT c
```

Beklenen çıktı:

```text
30
```

Bu kodda `DIM` bellek alanı açar, `AS` tipi bağlar, `I32` değerin 32 bit işaretli tam sayı olduğunu bildirir, `=` başlangıç değeri verir, `+` iki değeri toplar ve `PRINT` sonucu yazar. Tek bir küçük örnek içinde değişken, tip, atama, ifade ve çıktı birlikte görünür.

Project pack omurgasındaki ilk paket bu fikri biraz daha büyütür:

```basic
DIM a AS I32 = 10
DIM b AS I32 = 20
DIM c AS I32 = a + b
PRINT c
c = c + 5
PRINT c
c = c * 2
PRINT c
PRINT c - 15
PRINT (a + b) * 3
```

Beklenen çıktı:

```text
30
35
70
55
90
```

Bu örnek, değişkenin yalnız bir kez değer alan kutu olmadığını gösterir. `c` önce `a + b` değerini alır, sonra üstüne 5 eklenir, sonra ikiyle çarpılır. Programın akışı, değişkenin zaman içinde değişmesiyle izlenebilir hale gelir. Genç bir programcı için önemli fikir budur: program, satırların sırayla çalışması değil, değerlerin zaman içinde dönüşmesidir.

Bir sonraki adımda karar eklenir:

```basic
DIM sicaklik AS I32 = 24

IF sicaklik > 22 THEN
    PRINT "Havalandirma ac"
ELSE
    PRINT "Normal"
END IF
```

Beklenen çıktı:

```text
Havalandirma ac
```

Bu örnek yalnız bir `IF` göstermez. Ölçüm değeri alınır, eşik değeriyle karşılaştırılır ve program akışı iki kola ayrılır. `IF` burada gerçek bir kontrol düzeneğidir. İleride aynı fikir dizi, döngü ve fonksiyonla birleştiğinde küçük bir izleme sistemi kurulabilir.

```basic
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 24
sicaklik(3) = 21

DIM i AS I32
FOR i = 1 TO 3
    IF sicaklik(i) > 22 THEN
        PRINT "Yuksek"
    ELSE
        PRINT "Uygun"
    END IF
NEXT i
```

Beklenen çıktı:

```text
Uygun
Yuksek
Uygun
```

Bu programda `DIM`, dizi, indeks, `FOR`, `IF`, karşılaştırma ve `PRINT` aynı amaca bağlanır. Kitabın yöntemi budur: komutlar tek tek tanıtılır ama tek başına bırakılmaz. Her komut, kendinden önce öğrenilen komutlarla birleşerek daha akıllı bir programa dönüşür.
