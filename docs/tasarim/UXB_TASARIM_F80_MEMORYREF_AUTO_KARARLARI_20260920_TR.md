İnceledim. Yüklediğin dosya doğrudan soru-cevap biçiminde değil; önceki incelemede kalan **açık sorunları ve karar bekleyen noktaları** sıralıyor. Özellikle bellek, OOP, yineleyici, paralellik, motor eşliği ve kütüphane sorunları belirtilmiş.  Bunları karar sorularına dönüştürdüğümüzde cevaplarım şöyle.

## 1. F80 kaç bayt olmalı?

**Karar: uXBasic içinde F80 gerçek veri olarak 10 bayt olmalı.**

Şu an kaynakta aynı tip için 8, 10 ve 16 baytlık üç farklı davranış bulunduğu belirtiliyor.  Bu mutlaka tekleştirilmeli.

Ben şu sözleşmeyi kullanırım:

```text
F80 gerçek veri boyutu = 10 bayt
SIZEOF(F80)            = 10

Normal uXBasic F80 dizisi:
elementSize             = 10
elementStride           = 10
```

Bir dış C ABI'si veya belirli bir platform 16 baytlık hizalanmış alan istiyorsa, bu **F80'ın boyutunu değiştirmemeli**. O yalnız dış ABI yerleşimi olmalı:

```text
veri       = 10 bayt
ABI slotu  = gerekirse 16 bayt
```

Böylece sıradan uXBasic kodunda:

```basic
DIM a(9) AS F80
p = VARPTR(a)
```

için ikinci elemanın adresi:

```text
p + 10
```

olur.

Bu sistem programlama dili açısından en anlaşılır sözleşme.

---

## 2. Skaler `VARPTR` nasıl düzeltilmeli?

Dosyada canonical-MIR'in skaler değişkende her tür için `intValue` alanının adresini kullandığı belirtiliyor. Bu F64, U64, PTR gibi türlerde doğru değil. 

**Kararım: her değişkenin tek ve sabit gerçek depolama alanı olmalı.**

Örneğin:

```text
x AS I32 -> 4 gerçek bayt
y AS F64 -> 8 gerçek bayt
p AS PTR -> 8 gerçek bayt
z AS F80 -> 10 gerçek bayt
```

Normal değişken okuması ile `VARPTR` üzerinden yapılan okuma/yazma **aynı baytları** görmeli.

Yani şu mutlaka çalışmalı:

```basic
DIM x AS F64
x = 12.5

p = VARPTR(x)
```

`p`, `intValue` gibi başka bir yardımcı alanın değil, gerçekten `x` değerinin bulunduğu alanın adresi olmalı.

**İkinci sanal kopya veya eşleme kullanılmamalı.**

Bu, diziler için S-071'de yaptığımız kararın skaler değişkenlere uygulanmasıdır.

---

# 3. AUTO konusunda karar değişiyor mu?

**Hayır. Önceki kararımız geçerli.**

Dosyada AUTO'nun henüz kodlanmadığı açıkça belirtiliyor. 

Kesin davranış:

```text
Açık VIRTUAL -> VIRTUAL
Açık NATIVE  -> NATIVE

Mod yazılmamışsa:

PTR türü      -> NATIVE
normal sayı   -> VIRTUAL
```

Örneğin:

```basic
POKED 100, 5
```

VIRTUAL.

```basic
DIM p AS PTR
POKED p, 5
```

NATIVE.

```basic
POKED VARPTR(x), 5
```

NATIVE.

```basic
POKED VARPTR(a) + 4, 5
```

NATIVE.

```basic
DIM n AS U64
n = &h12345678
POKED n, 5
```

VIRTUAL.

Ama:

```basic
POKED PTR(n), 5
```

NATIVE.

Bu son derece temiz bir ayrım.

---

# 4. EXTERNAL ayrı bellek türü mü?

**Hayır. Bu karar da kesinleşti.**

Yalnız:

```text
Bellek çeşidi:
    VIRTUAL
    NATIVE
```

vardır.

EXTERNAL ise adresin **kökenidir**:

```text
memoryClass = NATIVE
origin      = EXTERNAL
```

Örneğin DLL tarafından döndürülen pointer budur.

Başka örnek:

```text
VARPTR(x)

memoryClass = NATIVE
origin      = LOCAL
```

```text
VARPTR(array)

memoryClass = NATIVE
origin      = ARRAY
```

Dolayısıyla ileride:

```text
EXTERNAL
```

diye üçüncü bir PEEK/POKE bellek modu oluşturmamalıyız.

---

# 5. MemoryRef ne olmalı?

Dosyada gerçek birleşik MemoryRef'in henüz yapılmadığı belirtiliyor. 

Bunu artık şu şekilde kurmak mantıklı:

```text
MemoryRef
    memoryClass
        VIRTUAL
        NATIVE

    origin
        LOCAL
        GLOBAL
        ARRAY
        HEAP
        STRING
        EXTERNAL
        VIRTUAL

    baseAddress
    byteOffset
    byteLength

    elementSize
    elementStride
    elementCount

    readable
    writable

    ownerId
    generation
```

Bunun faydası şu.

Bugün:

```text
VARPTR
PEEK
POKE
MEMCOPY
MEMFILL
ARRAY
FFI
```

çeşitli yerlerde kendi bellek mantıklarını uyguluyor.

MemoryRef'ten sonra:

```text
                 MemoryRef
                     │
        ┌────────────┼────────────┐
        ↓            ↓            ↓
     PEEK/POKE    MEMCOPY      VARPTR
        ↓            ↓            ↓
              ortak çözümleyici
```

olabilir.

### Ancak sıralama önemli

Önce:

1. skaler `VARPTR`,
2. F80,
3. AUTO

düzeltilmeli.

**Sonra MemoryRef kurulmalı.**

Yanlış fiziksel belleğin üzerine güzel bir MemoryRef sistemi kurmanın pek anlamı yok.

---

# 6. `VARPTR(array(i))` desteklenmeli mi?

**Evet. Kesinlikle desteklenmeli.**

Dosyada şu anda desteklenmediği belirtiliyor. 

Olması gereken:

```basic
DIM a(0 TO 99) AS I32

p1 = VARPTR(a)
p2 = VARPTR(a(3))
```

ve:

```text
p2 = p1 + 3 * 4
```

olmalı.

Alt sınır sıfır değilse:

```basic
DIM a(10 TO 20) AS I32
```

için:

```text
VARPTR(a(10)) = VARPTR(a)
VARPTR(a(11)) = VARPTR(a) + 4
```

olmalı.

Genel denklem:

```text
adres = base + (index - LBOUND) * elementStride
```

Bu sistem programlama için gerekli.

---

# 7. `SIZEOF(array)` ne döndürmeli?

Bence burada da sözleşmeyi netleştirelim:

> **`SIZEOF(array)` dizinin gerçek veri alanının toplam bayt sayısını döndürmeli.**

Örneğin:

```basic
DIM a(0 TO 99) AS I32
```

için:

```basic
PRINT SIZEOF(a)
```

sonucu:

```text
400
```

olmalı.

Yani:

```text
elementCount × elementStride
```

Dizi tanımlayıcısının, pointer'ın veya çalışma zamanı metadata'sının boyutu değil.

Çünkü programcının:

```basic
MEMCOPY VARPTR(b), VARPTR(a), SIZEOF(a)
```

yapabilmesi son derece yararlı.

Bu özellikle bizim düşük seviyeli bellek yaklaşımımıza uyuyor.

---

# 8. Dizi parametresi nasıl çalışmalı?

Dosyada:

```basic
SUB F(arr AS I32[])
```

kabul edildiği halde `arr(0)` erişiminin bozuk olduğu belirtiliyor. 

Burada diziyi fonksiyona kopyalamamalıyız.

Bir dizi parametresi küçük bir **dizi görünümü/tanımlayıcısı** taşımalı:

```text
baseAddress
lowerBound
upperBound
elementCount
elementSize
elementStride
```

Yani:

```basic
SUB Topla(a AS I32[])
```

çağrıldığında `a`, orijinal dizinin gerçek veri alanını göstermeli.

Böylece:

```basic
a(3) = 100
```

orijinal dizinin üçüncü elemanını değiştirir.

Bu hem hızlı hem pointer sistemimizle tutarlı.

---

# 9. `MEMFILLB/W/D/Q` aynı sözdizimine getirilmeli mi?

**Evet.**

Dosyada B sürümünün özel `VIRTUAL/NATIVE` öneki kabul ettiği, W/D/Q'nun ise eski sabit üç parametre yolunda kaldığı belirtiliyor. 

Bu gereksiz bir tutarsızlık.

Hepsi:

```basic
MEMFILLB hedef, değer, adet
MEMFILLW hedef, değer, adet
MEMFILLD hedef, değer, adet
MEMFILLQ hedef, değer, adet
```

ve:

```basic
MEMFILLD NATIVE, hedef, değer, adet
MEMFILLD VIRTUAL, hedef, değer, adet
```

biçimini kabul etmeli.

Aynı ortak parser kullanılmalı.

---

# 10. WASM'daki VIRTUAL sınırı hata mı?

**Hayır.**

Dosyada WASM'ın 1 MiB güvenli sanal alan kullandığı ve Q/disk genişletmesini desteklemediği belirtiliyor. 

Bunu çekirdek hata kabul etmem.

Tarayıcı ortamındaki WASM ile Windows native belleğin aynı yeteneklere sahip olması gerekmez.

Ancak iki şeyi ayırırım:

```text
1 MiB sınırı / disk desteği yok
    -> hedef kısıtı

Q işlemleri yok
    -> ileride tamamlanabilecek özellik
```

WASM'ın kendisi 64 bit tamsayı yükleme/saklama yapabildiği için Q ailesi teknik olarak ileride eklenebilir.

Ama bu uXBasic çekirdeğini engellemez.

---

# 11. WASM `BYREF` tamamlanmalı mı?

**Evet, WASM tam backend olacaksa tamamlanmalı.**

WASM'da BYREF:

```text
host pointer
```

değil,

```text
WASM linear memory offset/address
```

olarak uygulanmalı.

Örneğin:

```basic
SUB Artir(BYREF x AS I32)
    x = x + 1
END SUB
```

WASM'da `x`'in lineer bellek adresi gönderilir ve yordam aynı alana yazar.

Burada özel bir hileye gerek yok.

---

# 12. `FOR EACH` / `DO EACH` nasıl tamamlanmalı?

Dosyada ARRAY/LIST/DICT/SET yollarının bulunduğu, fakat ortak bir yineleyici sisteminin olmadığı belirtiliyor. 

Çözüm ortak iç protokol:

```text
ITER_CREATE
ITER_NEXT
ITER_CLOSE
```

olmalı.

`FOR EACH` kaynak seviyesinde:

```basic
FOR EACH x IN collection
    ...
NEXT
```

yazılır.

MIR bunu kabaca:

```text
iterator = ITER_CREATE(collection)

WHILE ITER_NEXT(iterator, x)
    ...
WEND

ITER_CLOSE(iterator)
```

haline getirir.

ARRAY, LIST, DICT, SET ve STRING kendi yineleyicisini uygular.

Böylece parser'ın her veri yapısı için ayrı ayrı büyümesi durur.

---

# 13. STRING de `FOR EACH` desteklemeli mi?

**Evet.**

Örneğin:

```basic
FOR EACH ch IN text
    PRINT ch
NEXT
```

mantıklı.

Burada ayrıca ileride şu karar gerekir:

> `ch` bir **bayt** mı, Unicode kod noktası mı?

Ben modern uXBasic için STRING UTF-8 ise **karakter/kod noktası** davranışını tercih ederim; ham bayt dolaşımı isteyen programcı zaten `SADD`, `PEEKB` gibi düşük seviye araçlara sahip.

---

# 14. THREAD/PARALEL sıradan fonksiyon çağrısına düşebilir mi?

**Final dil davranışında hayır.**

Dosyada typed yolun bazı durumlarda normal çağrı gibi çalıştığı belirtiliyor. 

Şöyle ayırmak gerekir:

```text
PIPE
EVENT
```

tasarımına göre eşzamanlı veya normal çağrı olabilir.

Ama:

```text
THREAD
PARALEL
```

adını taşıyan bir şey sessizce normal fonksiyon çağrısına dönüşmemeli.

Eğer hedef bunu desteklemiyorsa:

```text
derleme hatası
```

veya açıkça belgelenmiş bir:

```text
sequential fallback
```

seçeneği kullanılmalı.

Sessiz davranış değişikliği istemiyorum.

---

# 15. OOP için hangi motor gerçek referans olmalı?

**Canonical MIR.**

Dosyada CLASS/INTERFACE ve virtual/override davranışlarının bütün motorlarda eş olmadığı belirtiliyor. 

Yeni OOP özelliği artık:

```text
AST-x64'te ayrı uygula
MIR-x64'te ayrı uygula
interpreter'da ayrı uygula
```

şeklinde geliştirilmemeli.

Önce:

```text
AST
 ↓
semantic
 ↓
Canonical MIR
```

davranışı tanımlanmalı.

Sonra:

```text
MIR interpreter
MIR-x64
WASM
JS
```

aynı MIR sözleşmesini uygulamalı.

Legacy AST-x64 uyumluluk yolu olarak kalabilir.

Bu, ileride yüzlerce parity hatasını engeller.

---

# 16. `SUB MAIN()` özel giriş noktası olmalı mı?

**Hayır.**

`SUB MAIN()` normal kullanıcı yordamı olmalı.

Özel program girişi zaten:

```basic
MAIN
    ...
END MAIN
```

ise onunla temsil edilmeli.

Derleyicinin kendi ana fonksiyonuna da kullanıcıdan çakışamayacak dahili bir ad verilmeli:

```text
__uxb_program_entry
```

gibi.

Dosyada belirtilen `RET` sonrası ölü kod sorunu da böyle daha temiz çözülür. 

---

# 17. PRINT tamponlanmaya devam etmeli mi?

**Program sonuna kadar tamponlanmamalı.**

Dosyadaki problem gerçek: hata olursa önceki PRINT'ler kayboluyor. 

Ben ortak bir çıktı katmanı yaparım.

Normal:

```basic
PRINT "A"
```

çağrısı satır bazında çıktı verir.

En azından şu durumlarda tampon kesin boşaltılmalı:

```text
PRINT satırı tamamlandığında
DLL/dış çağrıdan önce
program hatasında
normal EXIT'te
```

Böylece:

```basic
PRINT "başladı"
HATALI_ISLEM
```

programında kullanıcı `"başladı"` çıktısını görür.

Bu özellikle hata ayıklamada önemli.

---

# 18. `POKED → WAT` kapı hatasında derleyiciyi mi düzeltelim?

**Henüz hayır.**

Dosya yalnız kabul denetiminin beklenen MIR opcode'u bulamadığını söylüyor. 

Önce şunu ayırmak gerekir:

```text
Gerçek üretilen WAT yanlış mı?

yoksa

gate betiği eski opcode adını mı arıyor?
```

Eğer program gerçek WASM'da doğru çalışıyorsa, compiler değil **gate testi** düzeltilmeli.

Bu nedenle S-072'nin önemi burada ortaya çıkıyor.

---

# 19. GSL pointer hatasını nasıl ele almalıyız?

Dosya yalnız şunu kesin destekliyor:

> `uxgsl` callback/root testlerinde `stale or invalid pointer handle token` hatası var. 

Bundan kök nedeni kesin söylemek doğru olmaz.

Ama düzeltmede şu yapılmamalı:

> “pointer doğrulamasını kapatalım, test geçsin.”

GSL callback ve `userData` pointerlarının yaşam süresi açık biçimde yönetilmeli.

Bu da gelecekteki `MemoryRef` için iyi bir gerçek kullanım alanıdır:

```text
origin = EXTERNAL
owner  = GSL callback context
```

Önceliği yüksek tutarım.

---

# 20. `uxstats2` için karar basit

Burada mimari tartışma gerekmiyor.

Dosyada başlığın yanlış klasöre baktığı belirtiliyor. 

Şu yanlış:

```text
libsx/uxstats2/uxstats2.bas
```

Gerçek yer:

```text
libsx/uxstats/uxstats2.bas
```

**Doğrudan düzeltilmeli.**

---

# 21. Raylib ve SDL3 tamamlanmadan uXBasic tamamlanmamış mı sayılır?

**Hayır.**

`uxraylib` ve `uxsdl3` kısmi kütüphanelerdir; eksik bölümler belgede açıkça belirtilmiş. 

Bunlar:

```text
uXBasic çekirdek dilinin tamamlanması
```

ile:

```text
uXBasic kütüphane ekosisteminin genişlemesi
```

arasında ikinci gruba giriyor.

Dolayısıyla çekirdeği bunlar yüzünden bekletmem.

---

# Benim bu dosyadan çıkardığım kesin çalışma sırası

| Sıra | İş                 | Karar                                           |
| ---: | ------------------ | ----------------------------------------------- |
|    1 | **F80**            | Her iç motor için 10 bayt                       |
|    2 | **Skaler VARPTR**  | Gerçek, sabit, tipli veri alanı                 |
|    3 | **AUTO**           | PTR=NATIVE, sayı=VIRTUAL                        |
|    4 | `<1 MiB` kalıntısı | Tamamen sil                                     |
|    5 | **MemoryRef**      | VIRTUAL/NATIVE + ayrı köken bilgisi             |
|    6 | `VARPTR(array(i))` | Gerçek eleman adresini destekle                 |
|    7 | `SIZEOF(array)`    | Gerçek toplam veri baytı                        |
|    8 | Dizi parametresi   | Kopyasız array-view/tanımlayıcı                 |
|    9 | `MEMFILL*` parser  | B/W/D/Q tek sözleşme                            |
|   10 | OOP                | Canonical MIR merkezli eşlik                    |
|   11 | Yineleyici         | CREATE/NEXT/CLOSE ortak protokol                |
|   12 | THREAD/PARALEL     | Sessiz normal çağrıya düşmemeli                 |
|   13 | PRINT              | Ortak çıktı katmanı ve hata öncesi flush        |
|   14 | `SUB MAIN`         | Normal yordam; dahili entry adı ayrı            |
|   15 | `uxgsl`            | Pointer/callback ömrünü gerçek sebebiyle düzelt |
|   16 | Gate sistemi       | Tek güvenilir kabul koşucusu                    |
|   17 | `uxstats2`         | Yanlış yolu doğrudan düzelt                     |
|   18 | raylib/SDL3        | Çekirdekten sonra genişlet                      |

Bu şekilde ilerlersek dosyanın sonunda verilen 12 maddelik öncelik sırasını biraz daha kesin hale getirmiş oluyoruz. Özellikle **F80 + skaler VARPTR + AUTO + MemoryRef aynı bellek mimarisi çalışmasının ardışık dört adımıdır**; bunları birbirinden kopuk yamalar olarak yaptırmamak gerekir. Dosyanın kendisi de belleğin ve motorlar arası eşliğin kalan ana mimari borç olduğunu gösteriyor. 
