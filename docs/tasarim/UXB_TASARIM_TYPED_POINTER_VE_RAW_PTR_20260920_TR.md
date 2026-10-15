Mete abi, **hatırladığın tasarım ile 18.09'da doğruladığımız mevcut uXBasic davranışı aynı değil.** Burada önemli bir ayrım yakaladın.

Son raporda mevcut davranış açıkça şöyle kayıtlı:

```text
PTR + INTEGER -> PTR
PTR - INTEGER -> PTR
PTR - PTR     -> I64
```

ve bu aritmetik **bayt tabanlı** kabul edilmiş. 

Yani **mevcut 18.09 davranışında**:

```basic
p + 1
```

= **1 bayt ilerle**

```basic
p + 4
```

= **4 bayt ilerle**

```basic
p + 8
```

= **8 bayt ilerle**

Burada `p`'nin I32, I64 veya F64 göstermesine göre otomatik ölçekleme yapıldığına dair son kaynak incelememizde kanıt yok.

## Senin hatırladığın tasarım farklı

Senin tarif ettiğin sistem aslında **tipli işaretçi aritmetiği**:

```text
p AS PTR TO I32
p + 1  -> adres + 4

p AS PTR TO I64
p + 1  -> adres + 8

p AS PTR TO F64
p + 1  -> adres + 8
```

Bu durumda:

```basic
p + n
```

aslında:

```text
adres + n × gösterilen_tipin_boyutu
```

demektir.

Bu, C'nin tipli pointer aritmetiğine yakın bir model.

### Neden Codex'te `p + 4` gördün?

Çünkü mevcut uXBasic'te pointer aritmetiği bayt tabanlı olduğundan, bir `I32` eleman ileri gitmek isteyen kod:

```basic
p + 4
```

yazıyor.

Bir `F64` eleman ilerlemek için:

```basic
p + 8
```

gerekir.

Dizi tarafında da son incelememiz gerçek ardışık veri alanı ve pointer aritmetiğinin düzeltildiğini gösteriyor. 

---

# Fakat burada üçüncü ve bence daha iyi bir seçenek var

Senin eski fikrin ile şu anki sistemi **birlikte koruyabiliriz**.

İki pointer çeşidi düşün:

### 1. Ham işaretçi

```basic
DIM p AS PTR
```

Bu sistem programlama pointer'ıdır:

```text
p + 1 -> +1 bayt
p + 4 -> +4 bayt
p + 8 -> +8 bayt
```

### 2. Tipli işaretçi

Kavramsal olarak:

```basic
DIM p AS PTR<I32>
```

veya BASIC'e daha uygun bir yazımla:

```basic
DIM p AS PTR TO I32
```

Bunun aritmetiği:

```text
p + 1 -> +4 bayt
p + 2 -> +8 bayt
p + 3 -> +12 bayt
```

F64:

```basic
DIM d AS PTR TO F64
```

için:

```text
d + 1 -> +8
d + 2 -> +16
```

F80'ı 10 bayt olarak kilitlersek:

```basic
DIM e AS PTR TO F80
```

için:

```text
e + 1 -> +10
e + 2 -> +20
```

Bu noktada insanlığın pointer aritmetiğini yarım yüzyıldır tartışmasının küçük bir faydasını nihayet kullanmış oluruz.

## `VARPTR` daha da ilginçleşir

Bugün:

```basic
DIM x AS I32
p = VARPTR(x)
```

sonuç yalnız `PTR` olarak düşünülüyor.

Ama yeni sistemde derleyici zaten `x`'in tipini biliyor.

Dolayısıyla:

```basic
VARPTR(x)
```

kavramsal olarak:

```text
PTR TO I32
```

üretebilir.

Ve:

```basic
DIM a(100) AS F64
p = VARPTR(a)
```

şunu üretebilir:

```text
PTR TO F64
```

Böylece:

```basic
p + 1
```

otomatik **8 bayt** ilerler.

Bu senin hatırladığın tasarıma çok yakın.

---

## Ama bir sorun çıkıyor

Biraz önce 6502 düşüncesini konuşurken bayt tabanlı adreslemenin avantajını gördük.

Mesela:

```basic
p + 3
```

ile gerçekten üç bayt ilerlemek istiyorsak tipli pointer buna engel olur.

Bu nedenle **ham PTR'yi kaybetmemeliyiz.**

Ben iki sistemi şöyle ayırırdım:

| İşaretçi          |  `+1` anlamı |
| ----------------- | -----------: |
| `PTR`             |      +1 bayt |
| `PTR TO BYTE`     |      +1 bayt |
| `PTR TO I16`      |      +2 bayt |
| `PTR TO I32`      |      +4 bayt |
| `PTR TO I64`      |      +8 bayt |
| `PTR TO F32`      |      +4 bayt |
| `PTR TO F64`      |      +8 bayt |
| `PTR TO F80`      |     +10 bayt |
| `PTR TO STRUCT X` | +`SIZEOF(X)` |

Bu çok güçlü olur.

---

# Dizi örneğinde fark çok açık

Bugünkü 18.09 sistemi:

```basic
DIM a(100) AS I32

p = VARPTR(a)

q = p + 4
```

`a(1)` adresine ulaşır.

Senin eski tipli sisteminde:

```basic
DIM a(100) AS I32

p = VARPTR(a)

q = p + 1
```

aynı yere ulaşır:

```text
p + 1 × SIZEOF(I32)
= p + 4
```

F64 dizisinde ise:

```basic
DIM a(100) AS F64

p = VARPTR(a)
q = p + 1
```

otomatik:

```text
p + 8
```

olur.

Bu gerçekten daha okunabilir.

---

## 6502 düşüncesiyle de çelişmek zorunda değil

Burada önceki konuşmamızı düzelterek genişletiyorum.

6502 tarzı **ham adres hesabı**:

```basic
DIM p AS PTR

p + 1
```

1 bayt.

Yüksek seviyeli **tipli adres hesabı**:

```basic
DIM p AS PTR TO I32

p + 1
```

4 bayt.

Ve x64 arka uç bunu çok doğal biçimde üretebilir. x86/x64 adres hesaplamasında temel adres + indis × ölçek + yer değiştirme modeli zaten doğal bir donanım kavramıdır; ölçek değerleri 1, 2, 4 ve 8 olabilir. ([Félix Cloutier][1])

Örneğin:

```basic
DIM p AS PTR TO I32

q = p + i
```

arka uç kavramsal olarak:

```text
base + i × 4
```

hesaplar.

I64/F64 için:

```text
base + i × 8
```

Bu x64'e son derece uygun.

F80 gibi 10 baytlık tip ise doğrudan x64 SIB ölçeğine sığmaz, çünkü donanımsal ölçek 1/2/4/8'dir. Derleyici:

```text
i × 10
base + sonuç
```

üretir. Sorun değil.

## Sonuç

**18.09 uXBasic'te şu anda senin eski `p+1 = bir eleman` tasarımın uygulanmış görünmüyor. Mevcut sistem `p+1 = 1 bayt` şeklinde.** Raporda PTR türlerinin temel olarak çalıştığı, fakat birleşik `MemoryRef` köken/sahiplik bilgisinin henüz bulunmadığı da belirtiliyor. 

Ama eski tasarımını çöpe atmak yerine daha güçlü bir biçimde geri getirmek mümkün:

```text
PTR                 -> ham işaretçi, bayt aritmetiği
PTR TO T            -> tipli işaretçi, eleman aritmetiği

PTR + n             -> adres + n
PTR TO I32 + n      -> adres + n*4
PTR TO F64 + n      -> adres + n*8
PTR TO T + n        -> adres + n*SIZEOF(T)
```

**Bence bu, yalnız tipli davranışa geçmekten daha güçlü.** Hem 6502/emülatör/sistem programlama için ham bayt adreslemesini korur, hem de dizi, STRUCT, FFI ve bilimsel veri için senin eski `p+1` düşünceni geri getirir. Üstelik ileride tasarladığımız `MemoryRef` içine `elementSize` ve `elementStride` zaten koymayı düşünüyorduk. Yani iki fikir birbirine şaşırtıcı derecede iyi oturuyor.

[1]: https://www.felixcloutier.com/x86/vpscatterdd%3Avpscatterdq%3Avpscatterqd%3Avpscatterqq?utm_source=chatgpt.com "VPSCATTERDD/VPSCATTERDQ/VPSCATTERQD/VPSCATTERQQ — Scatter Packed Dword, PackedQword with Signed Dword, Signed Qword Indices"
