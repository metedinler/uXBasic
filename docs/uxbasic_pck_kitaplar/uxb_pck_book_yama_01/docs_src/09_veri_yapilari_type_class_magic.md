# Veri Yapıları, TYPE, CLASS ve MAGIC

Tek değişken bir değer taşır. Dizi aynı türden birçok değeri tek ad altında toplar. `TYPE` birden çok alanı tek kayıt tipinde birleştirir. `CLASS` veriyle birlikte davranış da taşır. `MAGIC` ise sınıfın özel davranış sözleşmelerini tanımlar.

## Dizi

```basic
DIM arr(5) AS I32
arr(1) = 3
arr(2) = 5
arr(3) = arr(1) + arr(2)
arr(4) = arr(3) * 2
PRINT arr(1)
PRINT arr(3)
PRINT arr(4)
```

Beklenen çıktı:

```text
3
8
16
```

Dizi, ölçüm, puan, zaman serisi, sensör değeri ve tablo mantığı için temel yapıdır. İndekslenebilir olması onu döngülerle birlikte güçlü yapar.

## TYPE

```basic
TYPE Nokta
    x AS I32
    y AS I32
END TYPE

DIM p AS Nokta
p.x = 12
p.y = 30
PRINT p.x + p.y
PRINT p.y - p.x
```

Beklenen çıktı:

```text
42
18
```

`TYPE`, veriyi anlamlı alanlara ayırır. `p.x` ve `p.y` iki ayrı değişken gibi değil, aynı kaydın iki alanı gibi düşünülür. Böylece programda dağınık değerler yerine anlamlı veri yapıları oluşur.

## CLASS ve MAGIC

```basic
CLASS Anahtar
    VALUE AS I32

    MAGIC HASH() AS I32
        RETURN VALUE + 100
    END MAGIC

    MAGIC CLONE() AS I32
        RETURN VALUE
    END MAGIC

    MAGIC ADD(other AS I32) AS I32
        RETURN VALUE + other
    END MAGIC
END CLASS
```

`CLASS`, veri ve davranışı aynı yapı altında toplar. `MAGIC`, sıradan metot değildir; sınıfın özel davranış sözleşmesini kurar. `HASH`, `CLONE`, `ADD` gibi adlar nesne yüzeyinin dil tarafından anlaşılabilecek davranış kapılarıdır. Bu bölümde `TYPE` ile `CLASS` ayrımı açık tutulur: `TYPE` veri taşır, `CLASS` veriyle birlikte davranış taşır.

## Koleksiyon tip yüzeyi

```basic
DIM a AS ARRAY
DIM l AS LIST
DIM d AS DICT
DIM s AS SET
PRINT "DATA_STRUCT_SURFACE"
```

`ARRAY`, `LIST`, `DICT` ve `SET` veri yapısı yüzeyini temsil eder. Kitapta bu tipler yalnız isim olarak değil, hangi düşünme biçimine karşılık geldikleriyle anlatılır: sıra, liste, anahtar-değer ve benzersiz küme.
