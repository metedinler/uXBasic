# 14. Bellek ve işaretçiler

Çoğu programda bellek yönetimini derleyici üstlenir. Sistem programlamada ise **belleğe doğrudan** erişmek gerekir: aygıt sürücüsü, dosya biçimi çözümleme, emülatör, DLL ile konuşma.
uXBasic bunu **açık ve denetimli** biçimde sunar.

## 14.1 İki bellek: `VIRTUAL` ve `NATIVE`

| | `VIRTUAL` | `NATIVE` |
|---|---|---|
| Nedir? | Derleyicinin ayırdığı, **sınırları denetlenen** sanal bellek (varsayılan RAM boyutu ayarlanabilir) | Sürecin **gerçek** adres alanı |
| Adres nasıl yazılır? | Düz sayı: `POKEB 100, 65` | `PTR` değerleri: `VARPTR(x)`, `SADD(s)`, DLL'den dönen adres |
| Sınır dışı erişim | Açık hata: `POKEB out of range` | Çökme riski |
| WASM / JS | **Doğrudan** doğrusal belleğe iner (hedef tasarım) | JS/WASM'da yoktur: derleme hatası |
| Ne için? | Emülatör, ara bellek, güvenli deneme | Aygıt, işletim sistemi, DLL |

`AUTO` kararı (mod yazılmayan `PEEK`/`POKE` için): **`PTR` kaynaklı adres → `NATIVE`**, düz sayısal adres → `VIRTUAL`. `EXTERNAL` üçüncü bir bellek türü değildir;
adresin **dış kaynaktan** (DLL, işletim sistemi) geldiğini belirten **köken bilgisidir** ve bellek her zaman `NATIVE` sayılır.

Sanal belleğin boyutu `--virtual RAM[,DISK]` ile ya da programda `VIRTUAL boyut` deyimiyle ayarlanır (RAM 64K ile 2G arası olmalıdır; aksi hâlde açık hata verilir).
**Varsayılan sanal RAM 1 MiB'tır** (1 048 576 bayt; son geçerli adres 1 048 575). Sınır AST, MIR, x64, JS ve WASM'da son geçerli adres (1 048 575) ve ilk geçersiz adres (1 048 576) denenerek doğrulanmıştır. `VIRTUAL boyut` deyimi AST, MIR ve x64'te çalışır; JS'te yürütme anında `UXB host binding missing: VIRTUAL_INIT` ile durur (G-JS-7).
Sınır aşılınca dört motor da durur ama **ileti ve çıkış kodu farklıdır** (Ek F): bu, ortak tanı kodu hedefinin (Bölüm 12.4) henüz kapanmadığını gösterir.

### Bellek sınıfını açıkça yazmak: `VIRTUAL` ve `NATIVE` ön ekleri

`AUTO` kuralına bırakmak istemediğinizde sınıfı kendiniz yazarsınız. `PEEK*` için ön ek parantez içinde ilk argümandır (`PEEKD(VIRTUAL, 100)`); `POKE*`, `MEMFILL*` ve `MEMCOPY*` için deyimin ilk argümanıdır
(`POKED VIRTUAL, 100, 12345`). Genişlik harfi (`B`, `W`, `D`, `Q`) ön ekten bağımsızdır; dört genişlikteki `MEMFILL*` ve `MEMCOPY*` aynı ortak söz dizimini kabul eder.

{{ORNEK:19_bellek/sinif_oneki|baslik=VIRTUAL ön eki: dört motorda ve WASM'da}}

`NATIVE` ön eki gerçek süreç belleğini seçer; adres `VARPTR`, `SADD` ya da DLL'den gelir. Ön ek yazılmazsa `AUTO` kuralı çalışır: `PTR` tipli değişken ya da `VARPTR(x)` sonucu `NATIVE`, düz sayı `VIRTUAL` sayılır.

{{ORNEK:19_bellek/sinif_oneki_native|baslik=NATIVE ön eki ve AUTO kuralı}}

## 14.2 Okuma ve yazma: `PEEK*` / `POKE*`

Son harf **genişliği** söyler:

| Son ek | Genişlik | Okuma | Yazma |
|---|---|---|---|
| `B` | 1 bayt (`U8`) | `PEEKB(adres)` | `POKEB adres, değer` |
| `W` | 2 bayt (`U16`) | `PEEKW(adres)` | `POKEW adres, değer` |
| `D` | 4 bayt (`U32`) | `PEEKD(adres)` | `POKED adres, değer` |
| `Q` | 8 bayt (`U64`) | `PEEKQ(adres)` | `POKEQ adres, değer` |
| `S` | Metin | `PEEKS(adres, uzunluk)` | `POKES adres, metin` |
| *(yok)* | 4 bayt (`PEEKD` ile aynı genişlik) | `PEEK(adres)` | `POKE adres, değer` |

{{ORNEK:19_bellek/peek_poke|baslik=PEEK, POKE, MEMFILL, MEMCOPY}}

## 14.3 Blok işlemleri: `MEMCOPY*` / `MEMFILL*`

`MEMCOPYB/W/D/Q hedef, kaynak, adet` bellek bölgesini kopyalar; `MEMFILLB/W/D/Q hedef, değer, adet` bölgeyi bir değerle doldurur. Adet, seçilen genişlikte **eleman sayısıdır**
(`MEMCOPYD ..., 3` üç `U32` = 12 bayt).

## 14.4 İşaretçi: `PTR`

| İşlem | Yazım | Not |
|---|---|---|
| Değişkenin adresi | `p = VARPTR(x)` | `@x` çalışmaz (G-ISLEC-2) |
| Metnin bellekteki baytı | `p = SADD(s)` | |
| İşaretçi + sayı | `p + 4` | **Bayt** ilerler (`PTR TO T` gelince elemanlı olacak) |
| İşaretçi − işaretçi | `p2 - p1` | Bayt farkı (`I64`) |
| İşaretçi + işaretçi | — | **Hata** |
| Dizi elemanının adresi | `p = VARPTR(a(3))` | `VARPTR(a) + (3 - alt sınır) * eleman adımı`; alt sınır sıfır değilse de geçerlidir (AST, MIR, x64) |
| Boyut | `SIZEOF(I32)`, `OFFSETOF(Tip, "alan")` | Tip adı alır (değişken adı değil) |
| Dizinin toplam veri baytı | `SIZEOF(a)` | Eleman sayısı × eleman adımı; dizi tanımlayıcısının boyutu değil. `MEMCOPYB hedef, kaynak, SIZEOF(a)` böyle yazılır |

Ham işaretçi aritmetiği **bayt temellidir**: `I32` dizisinde sonraki eleman `p + 4`'tür. Programcı eleman boyutunu açıkça yazar: `p + i * SIZEOF(I32)`.

{{ORNEK:19_bellek/varptr_dizi_elemani|baslik=Dizi elemanının adresi, SIZEOF(dizi), F80 adımı ve skaler VARPTR}}

**`F80` boyutu:** veri boyutu **10** bayt, dizideki depolama adımı **16** bayttır (`SIZEOF(F80)` = 10, 4 elemanlı `F80` dizisinde `SIZEOF` = 64; AST, MIR, x64, JS ve WASM'da aynı). 20.09 tarihli ilk tasarım adımı da 10 öneriyordu; **23.09 sonrası son karar** "veri 10, adım 16"dır ve bu kılavuz onu izler.
**Skaler `VARPTR`:** her değişkenin tek ve sabit gerçek depolama alanı vardır; `VARPTR(x)` bir yardımcı alanın değil o alanın adresidir (`F64` 12,5 değeri `PEEKQ` ile `4029000000000000` okunur).

{{ORNEK:23_tasarim/ptr_bayt_aritmetigi|baslik=PTR bayt aritmetiği}}

{{ORNEK:19_bellek/varptr|baslik=VARPTR, PTR, PEEKQ, POKEQ}}

{{ORNEK:19_bellek/inc_dec_sizeof|baslik=INC, DEC ve SIZEOF}}

**◇ HEDEF (S-113):** Tipli işaretçi `PTR TO T`; `p + 1` bu durumda bir **eleman** ilerler. Ham `PTR` ve tipli işaretçi **birlikte** yaşar: ham `PTR` bayt aritmetiğini (6502, emülatör, sistem programlama) korur, tipli işaretçi dizi, `STRUCT`, FFI ve bilimsel veri için eleman aritmetiği sağlar.

| İşaretçi | `p + 1` ilerletir |
|---|---|
| `PTR` | 1 bayt |
| `PTR TO BYTE` | 1 bayt |
| `PTR TO I16` | 2 bayt |
| `PTR TO I32`, `PTR TO F32` | 4 bayt |
| `PTR TO I64`, `PTR TO F64` | 8 bayt |
| `PTR TO F80` | 16 bayt (veri 10, adım 16) |
| `PTR TO STRUCT X` | X'in hizalanmış adımı |

Genel kural `adres + n × adım(T)`'dir; her zaman `SIZEOF(T)` değildir (hizalama adımı büyütebilir). `VARPTR(x)` uzun vadede tipli işaretçi döndürebilir; ham işaretçi gereken yerde `PTR(p)` ya da `CASTPTR` ile **açık dönüşüm** yazılır. Derleyicide dizi adreslemesi bugün de `elementStride` ile tipli çalışır; eksik olan işaretçi **tipinin** kendisidir.
`ADDR(taban, indeks, ölçek, kayıklık)` adlı genel etkin adres işlevi de düşünülmüştür (`taban + indeks * ölçek + kayıklık`; hedef bağımsız bir `MIR_ADDR` düğümüne iner, x64 etkin adres hesabına, WASM düz aritmetiğe çevirir); henüz yoktur (G-HEDEF-1).
`INDIRECT(p)` gibi ek bir anahtar sözcük **bilerek önerilmemiştir**: `PTR(PEEKQ(p))` zaten aynı işi yapar ve yeni sözcük dili şişirir. Sanal belleğin ilk 256 baytını "sıfır sayfası" yapmak da dile zorunlu kılınmaz; isteyen `CONST ZP = 0` yazar.

> **✖ SESSİZ (G-TIP-7):** `DIM p AS PTR TO I32` yazımı **hata vermez**, ama `PTR TO I32` ham `PTR` gibi davranır: `p + 1` bir bayt ilerler (iki işaretçinin farkı `1` çıkar, tasarımda `4` olmalıdır). Tipli işaretçi gelene dek `PTR TO` yazmayın; eleman adımını kendiniz yazın: `p + i * SIZEOF(I32)`.

## 14.5 6502 tarzı adresleme: dolaylı erişim

Eski 8 bitlik işlemcilerin adresleme düşüncesi uXBasic'te yeni işleç gerektirmeden kurulur. Bir adres belleğe yazılır, sonra o adres **okunup** tabloya indeksle erişilir:

| 6502 | uXBasic |
|---|---|
| `LDA $4400` (doğrudan) | `PEEKB(4400)` |
| `LDA $4400,X` (taban + X) | `PEEKB(4400 + x)` |
| `LDA ($20),Y` (dolaylı + Y) | `PEEKB(PEEKQ(20) + y)` |
| `LDA ($20,X)` (indeks + dolaylı) | `PEEKB(PEEKQ(20 + x))` |

> Dikkat: `PEEKQ(p) + y` ile `PEEKQ(p + y)` **farklıdır**: birincisi "işaretçiyi oku, sonra indeksle"; ikincisi "indeksle, sonra işaretçiyi oku".

**Tüm 6502 adresleme modları ve uXBasic karşılıkları.** `CONST ZP = 0`; `x` (= 2) ve `y` (= 3) birer `I32`. 6502 işaretçisi 16 bittir, bu yüzden işaretçi `PEEKW` ile okunur (yukarıdaki tablo 64 bitlik genellemeyi, `PEEKQ`'yu gösterir). Adresler onluk yazılmıştır:

| 6502 modu | Örnek | uXBasic | Ölçülen değer |
|---|---|---|---|
| Örtük, biriktirici | `INX`, `ASL A` | Bellek erişimi yok: `x = x + 1`, `a = a SHL 1` | — |
| Hemen (immediate) | `LDA #$44` | `a = 68` | — |
| Sıfır sayfası | `LDA $44` | `PEEKB(ZP + 68)` | `11` |
| Sıfır sayfası,X | `LDA $44,X` | `PEEKB(ZP + ((68 + x) AND 255))` | `22` |
| Sıfır sayfası,Y | `LDX $44,Y` | `PEEKB(ZP + ((68 + y) AND 255))` | `33` |
| Mutlak | `LDA $4400` | `PEEKB(17408)` | `44` |
| Mutlak,X | `LDA $4400,X` | `PEEKB(17408 + x)` | `55` |
| Mutlak,Y | `LDA $4400,Y` | `PEEKB(17408 + y)` | `66` |
| Dolaylı | `JMP ($0030)` | `PEEKW(ZP + 48)` (hedef adresi okur) | `17408` |
| İndeksli dolaylı | `LDA ($20,X)` | `PEEKB(PEEKW(ZP + ((32 + x) AND 255)))` | `77` |
| Dolaylı indeksli | `LDA ($20),Y` | `PEEKB(PEEKW(ZP + 32) + y)` | `66` |
| Göreli | `BNE etiket` | `IF z = 0 THEN GOTO etiket` | — (dallanmadır, bellek modu değil) |

On bellek değerinin hepsi AST, MIR, MIR-x64, eski AST-x64, JS ve WASM'da bu sayılarla **birebir aynı** çıkar (`20261014_0253`). **Sıfır sayfası sarması** 6502'ye özgü bir ayrıntıdır: `($20,X)` için `x = 240` iken adres sıfır sayfasının dışına taşmaz, başa sarar (`(32 + 240) AND 255 = 16`); ölçülen değer `88`. Bu davranışı dil dayatmaz, yukarıdaki gibi `AND 255` ile kendiniz yazarsınız. Hex yazımı: `&H4400` ifade içinde altı yolda çalışır, ama tek başına JS ve WASM'da bozuktur (G-JS-1, G-WASM-24) ve `0x4400` sessizce yanlıştır (G-DIL-18); bu yüzden tabloda adresler onluk yazıldı. `ADDR(taban, indeks, ölçek, kayıklık)` hâlâ ◇ HEDEF'tir (G-HEDEF-1); bugün tanımsız işlev olarak AST'de `unsupported call ADDR`, **WASM'da sessizce `0`** verir (G-WASM-23).

{{ORNEK:52_kv_bellek/dolayli_adresleme|baslik=(adres),Y modelinin genel hâli}}

{{ORNEK:52_kv_bellek/mini_islemci|baslik=Üst düzey: sanal bellekte çalışan mini işlemci}}

### Yuvalanmış yapıların yerleşimi (`spec/NESTED_MEMORY_LAYOUT_SPEC.md`)

10 Nisan tarihli "Proposed" belge, iç içe `TYPE` ve dizi için deterministik yerleşim, `SIZEOF`, `OFFSETOF(yol)`, hizalama ve dolgu ile `adres = VARPTR(kök) + OFFSETOF(yol)` formülünü ister. Büyük bölümü **uygulanmıştır** (`20261014_0253`, altı yolda aynı; WASM'da yalnız `PRINT` metin kapısı dışında): `TYPE Vec2` (iki `F32`) ve `TYPE Entity` (`pos AS Vec2`, `hp AS I32`) için `SIZEOF(Vec2)` = `8`, `SIZEOF(Entity)` = `12`, `OFFSETOF(Entity, "hp")` = `8`, `OFFSETOF(Entity, "pos.y")` = `4` (yuvalanmış yol metin içinde); `U8` ile `I64` alanlı kayıt `16` bayt, `I64` ofseti `8` (dolgu); kendini değerle içeren `TYPE` açık hatayla reddedilir; `STRING` alanı 8 baytlık başvurudur (`STRING` + `I32` kaydı `16`).
**Eksik:** kayıt dizisinin adresinden eleman alanına yazmak (`POKED VARPTR(e) + 3 * SIZEOF(Entity) + OFFSETOF(Entity, "hp"), 77`) motorlara göre değişir: x64 `77` (doğru), AST `NATIVE POKED out of range`, MIR `VARPTR requires a native-scalar-type`, eski AST-x64 sessizce `0` (✖ FARK, G-VERI-17). Tamsayı dizisinde aynı yazım dört yerel yolda doğrudur.

## 14.6 `MemoryRef`: bellek başvurusu

Derleyicinin içinde bir **dizi işaretçisinin** erişimi bir **bellek başvurusu** (`MemoryRef`) olarak izlenir. Başvuru şunları taşır: bellek sınıfı, köken, taban adres, ofset, uzunluk, eleman boyutu ve adımı, okunur/yazılır bayrakları, sahip, kuşak (generation), ömür ve paylaşım kipi.
Bu bilgi sayesinde bir dizinin sınırını aşan erişim ve `REDIM` sonrası eski işaretçi **çalışma sırasında açıkça** reddedilir. Aşağıdaki tablo `memoryref_model` paketindeki beş durumu ve ek denemeleri gösterir (`DIM a(3) AS I32`, `p = VARPTR(a)`):

| Durum | AST (çıkış 5) / MIR (çıkış 13) | x64 (çıkış 1) | JS, WASM |
|---|---|---|---|
| `PEEKD(p + 12)` (son eleman) | çalışır | çalışır | ◌ derleme reddi (`NATIVE_ONLY_UNSUPPORTED_ON_JS`) |
| `PEEKD(p + 16)`, `POKED p + 16, 9` (bir eleman sonrası) | `MemoryRef: 4-byte access at offset 16 runs past the end of array A (16 bytes)` | `memory read out of range or invalid address` (yazmada `memory write …`) | ◌ |
| `MEMFILLD p, 7, 5` (taşan doldurma) | `MemoryRef: 20-byte access at offset 0 runs past the end of array A (16 bytes)`; **hiçbir bayt yazılmadan** reddedilir | `memory fill out of range or invalid address` | ◌ |
| `REDIM a(99)` sonrası eski `p` | `MemoryRef: stale pointer -- array A was released (REDIM/ERASE) after this address was taken` | genel `memory read out of range …` iletisi (nedeni söylemez) | ◌ |
| `REDIM` sonrası `p = VARPTR(a)` | çalışır | çalışır | ◌ |

İleti `ERASE` der, ama `ERASE` deyimi yoktur (aşağıya bakın). x64'ün iletisi bu üç hatayı (taşma, eski işaretçi, doldurma) ayırt etmez.

> **Güvence yalnız dizi işaretçileri içindir.** Tasarım belgeleri `MemoryRef`'in serbest bırakılmış nesneyi ve görevler arası paylaşılan bölgeyi de yakalamasını öngörür (◇ HEDEF); bugün **nesneler için böyle bir güvence yoktur**: `DELETE`'ten sonra alan okuma/yazma/metot çağırma MIR'de sessizce eski nesneyle çalışır, JS `undefined` verir (G-NESNE-20), ikinci bir değişken üzerinden eski nesneye erişim dört motorda da hata vermez (G-NESNE-22). Görevler arası paylaşım için Bölüm 15'teki yalıtım kuralları geçerlidir.

> **`ERASE` yoktur (G-DIL-11):** Tasarım belgeleri `REDIM`/`ERASE` sonrası eski işaretçinin bellek başvurusu kaydıyla yakalanmasını öngörür; `ERASE dizi` deyimi bugün "unknown symbol: erase" ile reddedilir. Diziyi küçültmek için `REDIM` kullanın.

## 14.7 JS ve WASM'da bellek

| Erişim | x64 | JS | WASM |
|---|---|---|---|
| `VIRTUAL` `PEEKB/W/D`, `POKEB/W/D`, `MEMFILL`, `MEMCOPY` | ✔ | ✔ (`peek_poke` örneği geçti) | ✔ (`peek_poke` örneği geçti: doğrusal belleğe iner) |
| `VIRTUAL` `PEEKQ`/`POKEQ` (64 bit) | ✔ | ✖ SESSİZ: çalışır ama son basamaklar bozulur (`0123456789ABCDEF` yazılır, `0123456789ABCDF0` okunur; G-JS-4) | ◌ Derleme hatası: `8-byte (Q) access is not supported (linear-memory helpers are i32-only)` (G-WASM-14) |
| `VIRTUAL boyut` deyimi | ✔ (AST, MIR, x64) | ✖ Yürütme anında `UXB host binding missing: VIRTUAL_INIT` (G-JS-7) | ◌ 1 MiB'ı aşan boyut derlemede açıkça reddedilir (`exceeds the 1 MiB linear-memory sandbox`) |
| `NATIVE` ön ekli `PEEK`/`POKE`/`MEMFILL`/`MEMCOPY` | ✔ | ◌ Derlemede açık ret: `NATIVE_ONLY_UNSUPPORTED_ON_JS` | ◌ Derleme hatası |
| `VARPTR(x)`, `SADD(s)` çağrısı | ✔ | ✖ **Derlemede reddedilmez**, yürütme anında `UXB host binding missing: VARPTR` / `SADD` ile durur (G-JS-10) | ◌ Derleme hatası |
| `PTR(sayı) + n` (yalnız sayı aritmetiği) | ✔ | ✔ (adres gibi kullanılmaz) | ◌ Derleme hatası: `WASM CAST target type is not supported by the i32 model: PTR` |
| `CALL(DLL, ...)` ile gelen adres | ✔ | ✖ | ✖ |
| Sınır dışı `VIRTUAL` yazma | Anlamlı ileti | Anlamlı ileti | Ham `RuntimeError: unreachable` tuzağı, ileti yok (G-WASM-13) |

WASM'da sanal bellek **1 MiB** ile sınırlıdır ve disk genişletmesi yoktur: bu bir hata değil **hedef kısıtıdır**. 64 bitlik (`Q`) erişim ise teknik olarak eklenebilir (WASM 64 bit yükleme ve saklama yapabilir); bugün eksiktir. Tasarım, WASM'da `VIRTUAL` belleği doğrudan doğrusal belleğe indirir (`i32.load`/`i32.store`; `MEMCOPY` için `memory.copy`, `MEMFILL` için `memory.fill` kullanılabilir), `NATIVE` belleği derleme hatası sayar ve dış kaynaklı adresi konak içe aktarmasına bırakır.

## 14.8 Benzerlerinden farkı

| İkili | Fark |
|---|---|
| `VIRTUAL` ve `NATIVE` | Sınırları denetlenen sanal bellek / gerçek adres alanı |
| `PEEKB` ve `PEEKD` | 1 bayt / 4 bayt okur |
| `POKE` ve `MEMFILL` | Tek değer yazar / bir bölgeyi doldurur |
| `MEMCOPY` ve `MEMFILL` | Bölgeden bölgeye kopyalar / sabit değerle doldurur |
| `VARPTR` ve `SADD` | Değişkenin adresi / metin baytlarının adresi |
| `PTR + 1` ve `PTR TO T + 1` | 1 bayt / 1 eleman (◇ HEDEF) |

## 14.9 Bellek ve işaretçilerle ilgili programlama kararları

* **Varsayılan olarak `VIRTUAL` bellek kullanın**; `NATIVE` yalnız gerçek adres gerektiğinde (DLL'den dönen adres, aygıt, işletim sistemi). `VIRTUAL`'da sınır dışı erişim açık hata verir, `NATIVE`'de çökme riski vardır.
* Önce sanal bellekte deneyin, sonra gerçek adrese geçin. Sanal belleğin boyutunu gereksinime göre ayarlayın (`VIRTUAL boyut` ya da `--virtual RAM[,DISK]`; RAM 64K ile 2G arası).
* **Erişim genişliğini her zaman açıkça yazın** (`PEEKB/W/D/Q`, `POKEB/W/D/Q`): son eksiz `PEEK`/`POKE` 4 bayt (`PEEKD` ile aynı) demektir ve okuyanı yanıltır.
* **`MEMCOPY*`/`MEMFILL*` adedi eleman sayısıdır**, bayt değil (`MEMCOPYD ..., 3` = 12 bayt). Genişlik ile adedi birlikte düşünün.
* İşaretçi aritmetiği bayt temellidir: sonraki elemana `p + i * SIZEOF(I32)` ile geçin. İşaretçi + işaretçi hatadır; fark `I64` bayttır.
* Değişkenin adresini `VARPTR(x)`, metnin baytlarının adresini `SADD(s)` ile alın; `@x` çalışmaz (G-ISLEC-2).
* Dolaylı adreslemede `PEEKQ(p) + y` ("işaretçiyi oku, sonra indeksle") ile `PEEKQ(p + y)` ("indeksle, sonra işaretçiyi oku") farkını gözetin.
* `REDIM` sonrası ya da nesne serbest bırakıldıktan sonra eski işaretçiyi **kullanmayın**; bellek başvuru modeli bunları reddeder (14.6).
* Bellek sınıfının okunur olmasını istiyorsanız **ön eki açıkça yazın** (`POKED VIRTUAL, 100, 5`, `MEMFILLD NATIVE, VARPTR(a), 7, 4`); `AUTO` kuralını ezberlemek zorunda kalmazsınız.
* Dizi elemanının adresini `VARPTR(a(i))` ile, dizinin toplam bayt sayısını `SIZEOF(a)` ile alın (`MEMCOPYB hedef, kaynak, SIZEOF(a)`). `F80` dizisinde adım 16'dır (`SIZEOF(F80)` 10'dur): elle adreslerken `p + i * 16` yazın.
* JS ve WASM hedefliyorsanız yalnız `VIRTUAL` belleği kullanın; `NATIVE` ön ekli işlemler derlemede, `VARPTR`/`SADD` ise **yürütme anında** reddedilir (G-JS-10). 64 bitlik `PEEKQ`/`POKEQ` JS'te sessizce yanlış sonuç verir, WASM'da derlenmez: 32 bitlik erişim kullanın.
* WASM hedefliyorsanız sanal belleği **1 MiB**'ın altında tutun; sınırı aşan erişim ham bir tuzakla durur ve ileti vermez (G-WASM-13), bu yüzden sınırı programda kendiniz denetleyin.
* Bir uXBasic işlevinin adresini C kütüphanesine geri çağrı olarak geçirmek (`CODEPTR`) yalnız x64'te çalışır (G-DIS-8); bu programı yerel x64 olarak derleyin.
