# Akış Kontrolü

Program yalnız yukarıdan aşağıya akan satırlar dizisi değildir. Karar ve döngü yapıları programın düşünme biçimini kurar. `IF` bir koşula göre yol seçer, `SELECT CASE` bir değeri çok kola ayırır, `FOR` sayısal tekrar kurar, `DO WHILE` koşul sürdükçe çalışır, `TRY` hata yakalama yüzeyi açar.

## IF ailesi

```basic
DIM ph AS I32 = 7

IF ph < 6 THEN
    PRINT "Asidik"
ELSEIF ph > 8 THEN
    PRINT "Bazik"
ELSE
    PRINT "Uygun"
END IF
```

Beklenen çıktı:

```text
Uygun
```

`IF` koşulu değerlendirir. `ELSEIF` ikinci ve üçüncü ihtimalleri açar. `ELSE`, hiçbir koşul doğru değilse çalışacak son koldur. `END IF`, karar bloğunu kapatır.

## FOR ve dizi birlikte

```basic
DIM ph(3) AS I32
ph(1) = 7
ph(2) = 5
ph(3) = 9

DIM i AS I32

FOR i = 1 TO 3
    IF ph(i) < 6 THEN
        PRINT "Dusuk"
    ELSEIF ph(i) > 8 THEN
        PRINT "Yuksek"
    ELSE
        PRINT "Normal"
    END IF
NEXT i
```

Beklenen çıktı:

```text
Normal
Dusuk
Yuksek
```

Bu örnekte `FOR`, `IF` ve dizi birlikte çalışır. Kitapta akış kontrolü tek başına anlatılmaz; veriyle birleştiğinde gerçek program parçasına dönüşür.

## DO WHILE

```basic
DIM j AS I32 = 0
DO WHILE j < 3
    PRINT j
    j = j + 1
LOOP
```

Beklenen çıktı:

```text
0
1
2
```

`DO WHILE`, koşul doğru kaldığı sürece döner. Sayaç artırılmazsa döngü sonsuza girebilir. Bu yüzden döngü örneklerinde sayaç değişimi açıkça gösterilir.

## TRY, CATCH, FINALLY

```basic
TRY
    PRINT "TRY_BODY"
CATCH err
    PRINT "CATCH_BODY"
FINALLY
    PRINT "FINALLY_BODY"
END TRY
```

Bu aile hata yakalama yüzeyidir. `TRY` denenen bloğu, `CATCH` hata kolunu, `FINALLY` ise sonuçtan bağımsız kapanış işini taşır. Semantic ve runtime tarafında hata akışı için ayrı bir sözleşme oluşturur.
