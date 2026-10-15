# Fonksiyonlar, Rekürsiyon ve İç İçe Çağrı

Fonksiyon, programın düşüncesini adlandırır. Aynı hesabı tekrar tekrar yazmak yerine bir kez tanımlar, sonra farklı değerlerle çağırırsın. uXBasic’te `FUNCTION` değer döndüren işlem bloğu, `SUB` değer döndürmeyen işlem bloğu, `RETURN` ise fonksiyondan çıkış ve sonuç verme yoludur.

## Temel fonksiyon

```basic
FUNCTION AddTwo(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

PRINT AddTwo(7, 8)
```

Beklenen çıktı:

```text
15
```

Bu örnekte `a` ve `b` parametredir. `AS I32`, hem parametrelerin hem de fonksiyon sonucunun tipini belirtir. Parser bu yapıyı fonksiyon AST düğümüne, semantic katman sembol tablosuna, MIR ise çağrılabilir işlem gövdesine indirir.

## Rekürsiyon

```basic
FUNCTION Fact(n AS I32) AS I32
    IF n <= 1 THEN
        RETURN 1
    END IF
    RETURN n * Fact(n - 1)
END FUNCTION

PRINT Fact(5)
```

Beklenen çıktı:

```text
120
```

Rekürsiyon, fonksiyonun kendisini çağırmasıdır. Bu yalnız gösterişli bir teknik değildir; ağaç, klasör, matematiksel seri ve böl-parçala çöz tarzı problemlerde güçlüdür. Rekürsiyonda durma koşulu zorunludur. Bu örnekte `n <= 1` durma koşuludur.

## İç içe çağrı

```basic
FUNCTION Add(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

FUNCTION Mul(a AS I32, b AS I32) AS I32
    RETURN a * b
END FUNCTION

PRINT Add(Mul(2, 3), Add(4, 5))
PRINT Mul(Add(1, 2), Add(3, 4))
PRINT LEN(UCASE("abc"))
```

Beklenen çıktı:

```text
15
21
3
```

İç içe çağrı, derleyici için ciddi bir sınavdır. Önce içteki çağrılar hesaplanır, sonra sonuçlar dıştaki fonksiyona parametre olarak verilir. AST bu ilişkiyi ağaç olarak taşır; MIR bunu yürütülebilir sıraya indirir. Bu yüzden iç içe çağrı bölümü AST ve MIR anlatımına doğal bir köprü kurar.
