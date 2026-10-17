Eklenen belgelere ve alınan kararlara uygun olarak, **uXBasic Nesne Yönelimli Programlama (OOP)** sisteminin tüm komutları, adları, işlevleri ve kod örnekleriyle detaylı tasarımı aşağıda sunulmuştur.

---

# uXBasic OOP Sistemi Tasarım Belgesi

## 1. Temel Yapı ve Nesne Tanımlama

### Komutlar ve İşlevleri

* **`CLASS ... END CLASS`**: Yeni bir sınıf (nesne şablonu) tanımlar.


* **`DIM ad AS Sınıf = NEW Sınıf(...)`**: Bellekte yeni bir nesne örneği (instance) oluşturur ve kurucusunu çağırır.


* **`DELETE nesne`**: Nesneyi bellekten siler, yıkıcısını çalıştırır ve nesne değişkenini otomatik olarak `NOTHING` / `NULL` yapar.


* **`NULL` / `NOTHING**`: Başlatılmamış veya silinmiş nesne referansını temsil eder.



### Kod Örneği

```basic
CLASS Nokta
    PUBLIC
    DIM x AS I32
    DIM y AS I32

    CONSTRUCTOR(ax AS I32, ay AS I32)
        x = ax
        y = ay
    END CONSTRUCTOR

    DESTRUCTOR()
        PRINT "Nokta temizlendi"
    END DESTRUCTOR
END CLASS

' Nesne oluşturma
DIM p AS Nokta = NEW Nokta(10, 20)
PRINT p.x

' Nesne silme (p otomatik olarak NOTHING olur)
DELETE p

IF p = NOTHING THEN
    PRINT "Referans bosaltildi"
END IF

```

---

## 2. Erişim Belirteçleri ve Kapsülleme

### Komutlar ve İşlevleri

* **`PUBLIC`**: Kendinden sonra gelen alan ve metotların dışarıdan erişilebilir olmasını sağlar.


* **`PRIVATE`**: Kendinden sonra gelen alan ve metotların yalnızca ilgili sınıf içinden kullanılabilmesini sağlar (Sınıf dışı erişim derleme hatası verir).


* **`PROTECTED`**: Yalnızca tanımlandığı sınıf ve o sınıftan türeyen alt sınıflar içinden erişilebilir.



### Kod Örneği

```basic
CLASS BankaHesabi
    PRIVATE
    DIM bakiye AS F64

    PUBLIC
    CONSTRUCTOR(ilkBakiye AS F64)
        bakiye = ilkBakiye
    END CONSTRUCTOR

    METHOD ParaYatira(miktar AS F64)
        IF miktar > 0 THEN
            bakiye = bakiye + miktar
        END IF
    END METHOD

    METHOD BakiyeOku() AS F64
        RETURN bakiye
    END METHOD
END CLASS

DIM hesap AS BankaHesabi = NEW BankaHesabi(100.0)
hesap.ParaYatira(50.0)
PRINT hesap.BakiyeOku()
DELETE hesap

```

---

## 3. Metotlar, Alıcı Sözlükleri ve Özellikler (Property)

### Komutlar ve İşlevleri

* **`METHOD ... END METHOD`**: Sınıfın fonksiyon/yordam üyesini tanımlar.


* **`THIS`**: Metodu çalıştıran sınıfın statik/doğrudan alan ve metotlarına erişim sağlar.


* **`ME`**: Çok biçimli (polimorfik) olarak nesnenin kendisini temsil eder (türetilmiş sınıftaki ezilmiş metodun çalışmasını garantiler).


* **`PROPERTY`**: Alan gibi okunan ve yazılan kapsüllenmiş özellikler tanımlar.


* *Kısa biçim*: `PROPERTY Ad AS Tip GET SET`

* *Blok biçim*: `PROPERTY Ad AS Tip GET ... END GET SET(v) ... END SET`




### Kod Örneği

```basic
CLASS Ogrenci
    PRIVATE
    DIM _not AS I32

    PUBLIC
    CONSTRUCTOR(n AS I32)
        THIS._not = n
    END CONSTRUCTOR

    ' Blok biçimli PROPERTY
    PROPERTY Puan AS I32
        GET
            RETURN _not
        END GET
        SET(yeniNot AS I32)
            IF yeniNot >= 0 ANDALSO yeniNot <= 100 THEN
                _not = yeniNot
            END IF
        END SET
    END PROPERTY
END CLASS

DIM o AS Ogrenci = NEW Ogrenci(80)
o.Puan = 95
PRINT o.Puan
DELETE o

```

---

## 4. Kalıtım, Polimorfizm ve Arayüzler (Seçenek C1 - Mixin Destekli)

### Komutlar ve İşlevleri

* **`EXTENDS`**: Tek bir taban sınıftan türetme yapar (`CLASS Alt EXTENDS Taban`).


* **`MIXIN`**: Durumsuz yetenek kutularını sınıfa ekler (`CLASS Alt EXTENDS Taban MIXIN Yazar, Siler`).


* **`VIRTUAL`**: Alt sınıflar tarafından yeniden yazılabilecek (ezilebilecek) metotları belirtir.


* **`OVERRIDE`**: Taban sınıftaki `VIRTUAL` metodu ezen alt sınıf metodunu belirtir.


* **`SUPER`**: Taban sınıfın metotlarını veya kurucusunu çağırır (`SUPER.Metot()`).


* **`INTERFACE ... END INTERFACE`**: Sınıfların uymak zorunda olduğu sözleşmeleri tanımlar.


* **`IMPLEMENTS`**: Bir sınıfın bir veya birden fazla arayüzü uygulamasını sağlar.



### Kod Örneği

```basic
' Arayüz
INTERFACE IYazdirilabilir
    METHOD Yazdir()
END INTERFACE

' Taban Sınıf
CLASS Sekil
    PUBLIC
    VIRTUAL METHOD AlanHesapla() AS F64
        RETURN 0.0
    END METHOD
END CLASS

' Türetilmiş Sınıf ve Arayüz Uygulaması
CLASS Kare EXTENDS Sekil IMPLEMENTS IYazdirilabilir
    PRIVATE
    DIM kenar AS F64

    PUBLIC
    CONSTRUCTOR(k AS F64)
        kenar = k
    END CONSTRUCTOR

    OVERRIDE METHOD AlanHesapla() AS F64
        RETURN kenar * kenar
    END METHOD

    METHOD Yazdir()
        PRINT "Kare Alani: "; THIS.AlanHesapla()
    END METHOD
END CLASS

DIM k AS Kare = NEW Kare(5.0)
k.Yazdir()
DELETE k

```

---

## 5. Sihirli Metotlar (MAGIC Operator Loading)

### Komutlar ve İşlevleri

Sınıfların matematiksel ve mantıksal operatörlerle doğrudan çalışabilmesini ve metinsel temsilini sağlar.

* **`MAGIC ADD(o)`**, **`MAGIC SUB(o)`**, **`MAGIC MUL(o)`**, **`MAGIC DIV(o)`**: `+`, `-`, `*`, `/` operatörlerini yükler.


* **`MAGIC EQ(o)`**, **`MAGIC NE(o)`**, **`MAGIC LT(o)`**, **`MAGIC GT(o)`**: Karşılaştırma operatörlerini (`=`, `<>`, `<`, `>`) yükler.


* **`MAGIC TOSTRING()`**: Nesne `STR(nesne)` ile metne dönüştürüldüğünde tetiklenir.



### Kod Örneği

```basic
CLASS Vektor2D
    PUBLIC
    DIM x AS F64
    DIM y AS F64

    CONSTRUCTOR(ax AS F64, ay AS F64)
        x = ax
        y = ay
    END CONSTRUCTOR

    ' + Operatörü yükleme
    MAGIC ADD(diger AS Vektor2D) AS Vektor2D
        RETURN NEW Vektor2D(THIS.x + diger.x, THIS.y + diger.y)
    END MAGIC

    ' Metin dönüşümü
    MAGIC TOSTRING() AS STRING
        RETURN "(" + STR(THIS.x) + ", " + STR(THIS.y) + ")"
    END MAGIC
END CLASS

DIM v1 AS Vektor2D = NEW Vektor2D(2.0, 3.0)
DIM v2 AS Vektor2D = NEW Vektor2D(4.0, 1.0)
DIM v3 AS Vektor2D = v1 + v2

PRINT STR(v3) ' Çıktı: (6.0, 4.0)

DELETE v1
DELETE v2
DELETE v3

```
uXBasic'te **Çoklu Kalıtım (Multiple Inheritance)**, **Karışım (Mixin/Trait)** ve **Çoklu Miras Altında Çok Biçimlilik (Polymorphism)** tam olarak desteklendiğinde, dilin söz dizimi, bellek modeli ve yürütme motorlarındaki davranış şöyle olacaktır:

---

## 1. Çoklu Kalıtım (Multiple Inheritance: `EXTENDS A, B`)

Birden fazla somut/soyut sınıftan aynı anda veri (alan) ve davranış (metot) devralınmasını sağlar.

```basic
CLASS KaraAraci
    PUBLIC
    DIM tekerSayisi AS I32
    CONSTRUCTOR(t AS I32)
        tekerSayisi = t
    END CONSTRUCTOR
    VIRTUAL METHOD Sür()
        PRINT "Karada gidiyor..."
    END METHOD
END CLASS

CLASS SuAraci
    PUBLIC
    DIM pervaneSayisi AS I32
    CONSTRUCTOR(p AS I32)
        pervaneSayisi = p
    END CONSTRUCTOR
    VIRTUAL METHOD Yüz()
        PRINT "Suda yüzüyor..."
    END METHOD
END CLASS

' Çoklu Kalıtım: Hem KaraAraci hem SuAraci
CLASS AmfibiArac EXTENDS KaraAraci, SuAraci
    PUBLIC
    CONSTRUCTOR(t AS I32, p AS I32)
        SUPER[KaraAraci](t)   ' Belirli taban sınıfın kurucusu
        SUPER[SuAraci](p)
    END CONSTRUCTOR

    OVERRIDE METHOD Sür()
        PRINT "Amfibi mod: Karada ilerleniyor."
    END METHOD
END CLASS

```

### Elmas Sorunu (Diamond Problem) Çözümü

Eğer `KaraAraci` ve `SuAraci` sınıflarının ikisi de ortak bir `Arac` taban sınıfından türiyorsa:

1. **Sanal Taban Kalıtımı (Virtual Base / Single Storage):** `Arac` sınıfının alanları (`hiz`, `id`) `AmfibiArac` içinde yalnızca **bir kez** yer kaplar.
2. **Çakışan Metot Çözümü:** İki tabanda aynı isimli metot varsa (`Sür()`), türetilmiş sınıf bunu açıkça `OVERRIDE` etmek zorundadır; aksi takdirde derleyici `ambiguous member resolution` hatası verir.

---

## 2. Karışımlar (Mixins / Traits: `MIXIN`)

Kod tekrarını önleyen, sınıflara **esnek yetenekler katan** yapılardır. uXBasic tasarımında iki aşamada çalışır:

### A) Durumsuz Karışım (Stateless Mixin)

İçinde `DIM` alanı barındırmayan, yalnızca metot gövdeleri veren yetenek kutularıdır.

```basic
MIXIN Yazdirilabilir
    METHOD Yazdir()
        PRINT "Nesne metin temsili: "; ME.TOSTRING()
    END METHOD
END MIXIN

MIXIN Kaydedilebilir
    METHOD Kaydet(dosyaYolu AS STRING)
        PRINT "Dosyaya yazildi: "; dosyaYolu
    END METHOD
END MIXIN

' Tek taban sınıf + İstendiği kadar Mixin
CLASS Rapor EXTENDS Belge MIXIN Yazdirilabilir, Kaydedilebilir
    PUBLIC
    ' Yazdir() ve Kaydet() metotları otomatik olarak kazanılır
END CLASS

```

### B) Durum Taşıyan Karışım (Stateful Mixin)

Genişletilmiş aşamada, karışımlar kendi yerel `DIM` alanlarını da taşıyabilir.

```basic
MIXIN Sayacli
    PRIVATE
    DIM _kullanimSayisi AS I32 = 0

    PUBLIC
    METHOD SayacArttir()
        _kullanimSayisi = _kullanimSayisi + 1
    END METHOD

    METHOD KullanimSayisiOku() AS I32
        RETURN _kullanimSayisi
    END METHOD
END MIXIN

```

---

## 3. Çoklu Miras Altında Çok Biçimlilik (Polymorphism)

Çoklu kalıtım ve karışımlar aktif olduğunda polimorfizm **üç farklı görünüm üzerinden** kesintisiz çalışır:

### 1. Taban Tip Değişkeni ile Çok Biçimli Çağrı

Türetilmiş nesne, devraldığı **herhangi bir taban sınıfın değişkenine** atanabilir. Sanal tablo (vtable) off-set kaydırması ile doğru metot tetiklenir.

```basic
DIM a AS AmfibiArac = NEW AmfibiArac(4, 2)

' 1. KaraAraci görünümü
DIM k AS KaraAraci = a
k.Sür()    ' "Amfibi mod: Karada ilerleniyor." çalışır (Polimorfik)

' 2. SuAraci görünümü
DIM s AS SuAraci = a
s.Yüz()    ' "Suda yüzüyor..." çalışır

DELETE a

```

### 2. Mixin Tip Değişkeni ile Çağrı

Nesne, uyguladığı `MIXIN` tipiyle de tutulabilir:

```basic
DIM r AS Rapor = NEW Rapor()
DIM y AS Yazdirilabilir = r  ' Mixin arabirimi üzerinden tutma

y.Yazdir()                   ' Rapor'un Yazdir metodu çalışır

```

### 3. `THIS` vs `ME` Sözlük Ayrımı (Dinamik Dağıtım)

Çoklu miras altında belirsizliği önlemek için alıcı anahtar sözcükleri kesin kurallara bağlanır:

* **`THIS`**: Metodun yazıldığı **statik sınıfın** uygulamasını doğrudan çağırır (sanal yuvayı yeniden dağıtmaz, en hızlıdır).
* **`ME`**: Çok biçimli olarak **en alt türetilmiş gerçek nesne türüne** bakar ve en güncel `OVERRIDE` edilmiş metodu çağırır.
* **`SUPER[TabanSinis]`**: Çoklu kalıtımda hangi taban sınıfın metodunun kastedildiğini net olarak belirtir.

```basic
CLASS TabanA
    VIRTUAL METHOD Test()
        PRINT "TabanA"
    END METHOD
END CLASS

CLASS TabanB
    VIRTUAL METHOD Test()
        PRINT "TabanB"
    END METHOD
END CLASS

CLASS Torun EXTENDS TabanA, TabanB
    OVERRIDE METHOD Test()
        SUPER[TabanA].Test()  ' TabanA'nın Test'ini çalıştırır
        SUPER[TabanB].Test()  ' TabanB'nin Test'ini çalıştırır
        PRINT "Torun"
    END METHOD
END CLASS

```

---

## 4. Motorlar Düzeyinde Arka Plan (Derleyici Mühendisliği)

| Motor | Çoklu Kalıtım Hizalaması (Offset/Vtable) |
| --- | --- |
| **Native x64 (NASM)** | Nesne içinde her ek taban sınıf için ayrı bir vtable göstericisi (`vptr`) ve `this` kaydırma (thunk) kodları üretilir. |
| **MIR Yorumlayıcı** | MIR seviyesinde nesne hücreleri `baseOffsets` haritası üzerinden adreslenir, dinamik çağrıda yuva indeksi çözümlenir. |
| **AST Yorumlayıcı** | Düz sembol tablosunda üye isimleri `Sınıf.Üye` biçiminde nitelenerek tam erişim sağlanır. |
| **JS / WASM** | JS nesne prototiplerinde delegasyon zincirleri kurulur; WASM tarafında ise doğrusal bellekte blok birleştirme ve `call_indirect` indeks tabloları kullanılır. |


Doğru biliyorsunuz; **JS (JavaScript)** ve özellikle **WAT/WASM (WebAssembly)** hedeflerinde geleneksel/karmaşık C++ tarzı nesne yönelimli programlama (OOP) desteği, yerel makine kodlarına (x64) kıyasla oldukça kısıtlıdır veya farklı sınırlamalara sahiptir.

Ancak uXBasic derleyicinizin **6 farklı yürütme motorunun tümünde (AST, MIR, Native x64, AST-x64, JS, WASM)** birebir aynı OOP davranışını (parite) vermesi mümkündür. Bunun yolu, yüksek seviyeli OOP kavramlarını derleyicinin **orta aşamasında (Lowering / IR)** temel veri yapılarına ve fonksiyon çağrılarına indirgemektir.

Aşağıda JS/WAT tarafındaki kısıtlamaların nedenleri ve derleyici mimarisi düzeyinde **tüm motorlarda bu desteğin nasıl sağlanabileceği** detaylandırılmıştır:

---

### 1. JS ve WAT/WASM'daki Sınırlamaların Nedenleri

* **WASM (WebAssembly) Kısıtları:**
* WASM doğası gereği doğrusal bir bellek (Linear Memory - düz bir bayt dizisi) modeline sahiptir.
* Sanal metot tabloları (vtable), bellek hizalamaları (alignment), nesne kalıtım offset'leri ve çoklu kalıtımdaki "Elmas Sorunu" için yerel bir makine desteği yoktur.
* WASM sınıfları veya metot ezmeyi (override) doğrudan bilmez; yalnızca sayısal tipleri (`i32`, `i64`, `f32`, `f64`) ve `call_indirect` (dolaylı fonksiyon çağrısı) mekanizmasını tanır.


* **JS (JavaScript) Kısıtları:**
* JS prototip tabanlı bir dildir (`prototype`).
* Derleyicinizin ürettiği bellekteki ham Class yapısı JS nesnelerine birebir haritalandığında `this` bağlamı (context) kayıpları, performans düşüşü ve bellek sızıntıları oluşur.
* Çoklu kalıtım JS'te prototip zincirinde (`__proto__`) varsayılan olarak desteklenmez (JS sınıfı yalnızca tek bir sınıftan `extends` edebilir).



---

### 2. Tüm Motorlarda (JS ve WASM Dahil) OOP Desteği Nasıl Sağlanır?

Derleyicinizde tüm motorlara OOP desteği sunmanın anahtarı, **OOP kodunu alt seviye çıktılara (JS/WAT) göndermeden önce MIR (Medium-Level IR) aşamasında Düz C / Procedural yapıya indirgemektir (Lowering / Canonicalization).**

Aşağıdaki teknik adımlarla alt motorların karmaşık OOP kurallarını bilmesine gerek kalmaz:

#### A. Nesnelerin Bellek Düzeninin Düzleştirilmesi (Struct Flattening)

Çoklu kalıtım (`EXTENDS A, B`) veya tekli kalıtım fark etmeksizin, bir sınıf örneği derleyici tarafından düz bir bayt bloğuna veya indekslenmiş bir alanlar dizisine indirgenir:

* **Tüm motorlarda (WASM dahil):** `NEW Sinif()` ifadesi arka planda `MALLOC(SIZEOF_SINIF)` işlemine dönüşür.
* Nesne değişkeni, yalnızca bellekteki başlangıç adresini tutan bir **`i32` / `PTR` işaretçisine** indirgenir.
* Çoklu kalıtımda `A` ve `B` sınıflarının alanları art arda bellek bloğuna dizilir.

#### B. Sanal Metot Tablosu (vtable) ve `call_indirect` (WASM için)

Metot çağırma ve polimorfizm (`VIRTUAL` / `OVERRIDE`) derleme zamanında iki şekilde çözülür:

1. **WASM Tarafında (`call_indirect`):**
* Her nesne bloğunun ilk 4 baytına (`offset 0`) sanal metot tablosunun indeksi (`vptr`) yazılır.
* WASM kod üreticisi `nesne.SanalMetot()` gördüğünde, önce `vptr`'yi okur, ardından WASM'ın `call_indirect` komutunu kullanarak ilgili fonksiyon tablosundan (`Table`) doğru fonksiyonu çağırır.


2. **JS Tarafında (Fonksiyon İndeks Tablosu):**
* JS çıktısı üretilirken sınıflar JS `class` yapısına çevrilmek yerine, metotlar düz global fonksiyonlara dönüştürülür: `function Sinif_Metot(this_ptr, arg1)`.
* JS nesnesi düz bir dizi (`Array`) veya `TypedArray` olarak tutulur.



#### C. `THIS` / `ME` Alıcılarının Açık Parametreye Çevrilmesi (Explicit `this` Passing)

Tüm `METHOD` tanımları alt seviyede ilk argümanı `THIS` adresi olan sıradan yordamlara (SUB/FUNCTION) dönüştürülür:

* **uXBasic Kodu:**
```basic
METHOD BakiyeYatira(miktar AS F64)
    THIS.bakiye = THIS.bakiye + miktar
END METHOD

```


* **İndirgenmiş (Lowered / WASM & JS için Ortak) Hali:**
```basic
SUB BakiyeYatira_Lowered(THIS_PTR AS PTR, miktar AS F64)
    POKEF64(THIS_PTR + OFFSET_BAKIYE, PEEKF64(THIS_PTR + OFFSET_BAKIYE) + miktar)
END SUB

```



Bu dönüştürme sayesinde JS ve WASM motorlarının karmaşık nesne/prototip kurallarını bilmesine gerek kalmaz; yalnızca bellek okuma/yazma (`PEEK`/`POKE`) ve düz fonksiyon çağırma yeteneği yeterli olur.

#### D. Çoklu Kalıtımda Offset Kaydırma (Thunk Pointers)

Çoklu kalıtımda (`AmfibiArac EXTENDS KaraAraci, SuAraci`) nesne `SuAraci` tipindeki bir değişkene atandığında (`DIM s AS SuAraci = amfibiNesnesi`):

* Derleyici, `s` işaretçisine `KaraAraci`'nın bellek boyutu kadar bir offset ekler (`s = amfibiNesnesi + SIZEOF_KARA_ARACI`).
* Böylece JS ve WASM motorlarında `SuAraci` metotları çalışırken bellek erişimleri tamamen doğru alanlara denk gelir.

---

### Özet Mimari Yol Haritası

| OOP Özelliği | x64 Native Çıktısı | JS Çıktı Stratejisi | WAT / WASM Çıktı Stratejisi |
| --- | --- | --- | --- |
| **Nesne Yapısı** | C++ Struct / Malloc | Düz JS Dizi/Object Buffer | Doğrusal Bellek (`i32` Malloc adresi) |
| **Metot Çağrısı** | Doğrudan Assembly Call | Düz JS Fonksiyonu (`func(this, args)`) | `call` (Statik metotlar) |
| **Sanal Metot (`VIRTUAL`)** | Function Pointer / Vtable | JS Fonksiyon Dizi Indeksi | `call_indirect` (WASM Table) |
| **Kalıtım / Offset** | Assembly Displacement | Manuel Index Offset Hesabı | `i32.add` ile Offset Kaydırma |
| **Yıkıcı (`DELETE`)** | Free / Native Dtor | JS Garbage Collector / Manual Free | `free(this_ptr)` ve Manuel Temizlik |

**Sonuç:** JS ve WAT/WASM'ın kısıtlamalarını aşmanın yolu, OOP mantığını **Front-End / MIR (Orta Katman)** seviyesinde çözüp alt seviye kod üreteçlerine (Codegen) yalnızca **"Bellek Adresi + Düz Fonksiyon Çağrısı"** olarak indirmektir. Bu yaklaşımla uXBasic'in tüm yürütme motorlarında %100 OOP uyumu ve parite sağlanabilir.

uXBasic'in mevcut OOP ve bellek mimarisi (6 motorlu parite, MIR tabanlı indirme, `MemoryRef` izlemesi, `THIS`/`ME`/`SUPER` ayrımı) incelendiğinde; hem endüstri standartlarında **eksik kalan/olmazsa olmaz** nitelikteki bileşenler hem de dili öne çıkaracak **çığır açıcı, deneysel ama pratik** özellikler şu şekilde kurgulanabilir:

---

### 1. Standart OOP Açısından "Eksik Kalan / Olsa Çok İyi Olur" Dediğimiz Özellikler

Günümüz modern dillerinde (C#, C++, Rust, Swift) bulunan ve uXBasic'in 6 motorlu yapısını güçlendirecek eksik yapısal katmanlar şunlardır:

#### A. Tür Jenerikleri ve Tür Kısıtlamaları (Generics & Type Constraints)

* **Neden Eksik?** `LIST`, `DICT` veya özel sınıflar bugün `OBJECT` (veya `TYPE_OBJECT`) üzerinden tip dönüşümüne zorlanmaktadır. Her okumada `CINT()`, `CDBL()` veya `FOR EACH` değişkeniyle döküm yapmak tür güvenliğini (type safety) zayıflatır.


* **Nasıl Olmalı?**
```basic
CLASS Depo<T>
    PRIVATE
    DIM elemanlar AS LIST OF T
    PUBLIC
    METHOD Ekle(oge AS T)
        LISTADD(elemanlar, oge)
    END METHOD
END CLASS

' Kullanım
DIM d AS Depo<Nokta> = NEW Depo<Nokta>()

```


* **Motor Paritesi (JS/WASM/x64):** Derleme zamanında *Monomorphization* (her somut tür için özel kod üretme) yöntemiyle indirgenir (Lowering). Böylece WASM ve Native x64 seviyesinde sıfır maliyetli (zero-cost) tür güvenliği sağlanır.

#### B. Desen Eşleme ve Model Eşleştirme (Pattern Matching)

* **Neden Eksik?** `SELECT CASE` yapısı yalnızca tamsayı/metin sabitlerini kontrol edebilmektedir. Nesne türlerini, durumları ve iç içe geçmiş yapıları sorgulamak için uzun `IF / ELSEIF` zincirleri gerekmektedir.


* **Nasıl Olmalı?**
```basic
SELECT CASE nesne
    CASE IS k AS Kare WHEN k.kenar > 10
        PRINT "Büyük Kare: "; k.AlanHesapla()
    CASE IS d AS Daire
        PRINT "Daire Yarıçapı: "; d.yaricap
    CASE NOTHING
        PRINT "Boş Referans"
END SELECT

```



#### C. Tür Dönüşüm Denetimi ve Güvenli Döküm (`IS` / `AS` Operators)

* **Neden Eksik?** `INSTANCEOF` yalnızca AST motorunda sınırlı olarak bulunup diğer motorlarda eksiktir. Çok biçimli bir değişkenden türetilmiş türe güvenli geçiş yapacak standart `AS` (safe cast) operatörü olmalıdır.


* **Nasıl Olmalı?**
```basic
DIM s AS Sekil = NEW Kare(5.0)
IF s IS Kare THEN
    DIM k AS Kare = s AS Kare
    PRINT k.AlanHesapla()
END IF

```



#### D. Kapsam Bağlamlı Otomatik Temizlik (`USING` / `RAII` Bloğu)

* **Neden Eksik?** `DELETE` işleminin unutulması bellek sızıntısına, manuel çağrılması ise karmaşık `TRY/FINALLY` bloklarına yol açar.


* **Nasıl Olmalı?**
```basic
USING f AS DosyaAkisi = NEW DosyaAkisi("veri.bin")
    f.Yaz("Merhaba")
END USING ' Kapsamdan çıkıldığında Otomatik DELETE f çalışır

```



---

### 2. Çığır Açıcı ve Gerçekçi "Deneysel" OOP Özellikleri

Deneysel derken fantezi olmayan, sistem/oyun/veri biliminde **gerçek bir problemi çözen** ve uXBasic'i öne çıkarabilecek konseptler:

#### A. Veri Odaklı OOP: Nesne Düzeninden ECS/AoS-to-SoA Dönüşümü (AoS to SoA Data Layout)

* **Problem:** Klasik OOP, nesne dizilerini bellekte *Array of Structures (AoS)* şeklinde tutar (`[x,y,z, x,y,z, ...]`). Ancak SIMD, grafik (Raylib/SDL3) ve matris hesaplamalarında CPU Önbellek Kaçırma (Cache Miss) oranını artırır.


* **Çığır Açan Çözüm:** `DATA_PARALLEL` niteliği alan sınıfların dizileri, derleyici tarafından arka planda otomatik olarak *Structure of Arrays (SoA)* biçimine indirgenir (`[x,x,x...], [y,y,y...], [z,z,z...]`).
* **Söz Dizi:**
```basic
CLASS DATA_PARALLEL Parcacik
    PUBLIC
    DIM x AS F32
    DIM y AS F32
    DIM vx AS F32
    DIM vy AS F32
END CLASS

DIM dizi(1000) AS Parcacik ' Arka planda SoA olarak depolanır

```


* **Etkisi:** Yazılımcı klasik `dizi(i).x = dizi(i).x + dizi(i).vx` şeklinde OOP kodu yazar; x64 ve WASM motorları ise bunu tek bir AVX/SIMD vektör komutuna çevirerek 4x-8x performans artışı elde eder.

#### B. Motor Odaklı Bellek Sahipliği ve Ömür Etiketleri (Lifetime & Region Annotations)

* **Problem:** JS'te GC vardır, WASM/x64'te ise manuel `DELETE` gerekir. Bu da motorlar arası ömür paritesini bozar.


* **Çığır Açan Çözüm:** `OWNED` ve `BORROWED` belirteçleri ile derleyici seviyesinde sıfır maliyetli sahiplik doğrulaması.
* **Söz Dizi:**
```basic
CLASS VeriIsleyici
    PUBLIC
    ' Bu metoda verilen nesne silinmeyecek, sadece ödünç alınacak
    METHOD Isle(BORROWED n AS Nokta)
        PRINT n.x
    END METHOD ' Metod bitince n SILINMEZ
END CLASS

```



#### C. Yapısal Arayüzleme / Örtük Sözleşmeler (Structural Typing / Compile-Time Duck Typing)

* **Problem:** Bir sınıfın bir arayüzü kullanabilmesi için açıkça `IMPLEMENTS IA` yazması gerekir. Dışarıdan gelen veya kütüphanelerdeki sınıfları değiştiremediğimizde bu durum engel oluşturur.


* **Çığır Açan Çözüm:** Sınıf `IMPLEMENTS` yazmasa bile, arayüzün metot imzalarını taşıyorsa derleme zamanında statik olarak o arayüzü karşılıyor kabul edilir.
* **Örnek:**
```basic
INTERFACE IKonumlanabilir
    METHOD GetX() AS F64
END INTERFACE

' Yapısal olarak GetX() metoduna sahip olan HERHANGİ bir sınıf, 
' IMPLEMENTS yazmasa dahi IKonumlanabilir parametresi alan metoda verilebilir.

```



#### D. Aktör Modeli Tabanlı Eşzamanlı OOP (Actor-Class / Isolation Boundaries)

* **Problem:** uXBasic'in güçlü bir görev/eşzamanlılık alt yapısı (`THREAD`, `PARALEL`, `ATOMIC`, `PIPE`) vardır. Ancak bir nesneye farklı thread'lerden aynı anda erişildiğinde veri yarışları (data race) oluşur.


* **Çığır Açan Çözüm:** `ACTOR CLASS` yapısı. Sınıfın metot çağrıları dışarıdan yapıldığında, derleyici bu çağrıları dahili bir `PIPE` veya `SLOT` mesajına çevirir. Nesne kendi durumunu (state) tek bir görevde yönetir ve kilit (`MUTEX`) ihtiyacını ortadan kaldırır.


* **Söz Dizi:**
```basic
ACTOR CLASS VeriSunucu
    PRIVATE
    DIM sayaç AS I32 = 0
    PUBLIC
    METHOD Artir()
        sayaç = sayaç + 1
    END METHOD
END CLASS

' Farklı THREAD'lerden güvenle çağrılabilir, veri yarışı imkansızdır.

```



---

### Özet Değerlendirme tablosu

| Özellik | Türü | Çözdüğü Kritik Problem | Motor Etkisi (AST/MIR/x64/JS/WASM) |
| --- | --- | --- | --- |
| **Generics `<T>**` | Standart Eksik | `OBJECT` dökümlerini kaldırma, tip güvenliği

 | Lowering ile sıfır çalışma zamanı maliyeti |
| **`IS` / `AS` & Pattern Matching** | Standart Eksik | Güvenli nesne dökümü ve tip kontrolü | MIR seviyesinde vtable/type-id sorgusu |
| **`USING` Bloğu** | Standart Eksik | Bellek ve kaynak sızıntılarını önleme | Otomatik `DELETE` / `FINALLY` üretimi

 |
| **AoS-to-SoA (`DATA_PARALLEL`)** | Deneysel / Çığır Açan | Önbellek kaçırma (Cache Miss) ve SIMD performansı | x64 AVX ve WASM SIMD için devasa hızlanma |
| **Aktör Sınıflar (`ACTOR CLASS`)** | Deneysel / Çığır Açan | Thread-safe nesne erişimi, kilitiz eşzamanlılık | Mevcut `PIPE`/`THREAD` altyapısına doğrudan indirgeme

 |