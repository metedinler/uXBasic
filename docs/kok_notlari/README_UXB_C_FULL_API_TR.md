# uXBasic Tam C API Standart Kütüphane Sistemi

Bu paket `uxb(25.07).zip` kaynak düzenine göre hazırlanmıştır. Compiler çekirdeğini,
lexer/parser/MIR/x64 kod üretimini ve mevcut kütüphaneleri değiştirmez.

## Önceki dar sarmalayıcı yaklaşımından farkı

Bu sistem yalnız `Open`, `Close`, `Get`, `Set` gibi seçilmiş bir alt API üretmez.
Seçilen C kütüphanesinin kurulu sürümündeki **bütün public C function
declaration'ları** taranır ve her biri için uXBasic fonksiyonu üretilir.
Komut sayısı yalnız üretim tarafında azaltılır: kullanıcı tek build komutu
çalıştırır; kütüphanenin fonksiyonları azaltılmaz veya tek bir genel komut
arkasına saklanmaz.

İki katman vardır:

```text
Vendor DLL ve public header
        │
        ├─ Clang AST: bütün public fonksiyonlar, enumlar ve basit sabitler
        ├─ PE export tablosu: DLL'in gerçekten dışa verdiği semboller
        │
        ▼
Generated raw uXBasic module
        │
        ▼
uxcapi.dll + libffi
        │
        ▼
Vendor fonksiyonunun gerçek çağrısı
```

uXBasic tarafındaki adlar C adlarını korur:

```uxbasic
INCLUDE "include/modules/uxsqlite.uxmh"

dbPtr = uxcapi.MemoryAlloc(8)
rc = sqlite3.sqlite3_open("veri.db", dbPtr)
db = uxcapi.MemoryReadPtr(dbPtr, 0)
```

`sqlite3_open`, `curl_easy_init`, `pcre2_compile_8`, `ZSTD_compress`,
`archive_read_new`, `sodium_init`, `json_object_new_object` gibi adlar
basitleştirilmez veya başka tek komut altında gizlenmez.

## Tam kapsamın teknik tanımı

"Tam API" şu kapsamdadır:

1. Kurulu sürümün public header dosyalarında ilan edilen C fonksiyonları.
2. Vendor DLL'in gerçek export ettiği fonksiyonlar.
3. Public header içindeki `static inline` fonksiyonlar; bunlar otomatik shim
   DLL'e çevrilir.
4. Struct/union değer döndüren veya struct/union değer parametresi alan
   fonksiyonlar; otomatik C shim ile pointer tabanlı güvenli sınıra çevrilir.
5. Enum sabitleri.
6. Basit sayısal ve metinsel object-like makrolar.
7. Variadic fonksiyonlar; son parametre olarak `uxcapi.Args` nesnesi alır.
8. Callback parametreleri; ham function pointer olarak kullanılır.
9. On veya daha fazla parametreli fonksiyonlar; `uxcapi` argüman frame'i
   sayesinde ABI10 sınırına takılmaz.

Private/internal semboller standart API sayılmaz. Deneysel veya
`STATIC_LINKING_ONLY` yüzeyleri varsayılan standarda katılmaz; bunlar sürüm
garantisi taşımadığı için ayrı `experimental` profilinde üretilebilir.



## Struct/union değerlerinin kullanımı

Bazı C fonksiyonları pointer değil, doğrudan struct değeri döndürür. Örneğin
json-c iterator fonksiyonları ve Zstandard `ZSTD_bounds` fonksiyonları bu
gruptadır. uXBasic bu değerleri kaybetmez:

- Dönüş için gerekli bellek otomatik ayrılır.
- Fonksiyon `U64` struct pointer'ı döndürür.
- `UXBSizeOf_<tip>()`, `UXBAlloc_<tip>()` ve
  `UXBOffsetOf_<tip>_<alan>()` yardımcıları üretilir.
- Basit alanlar için otomatik `UXBGet_...` ve `UXBSet_...` fonksiyonları
  üretilir.
- Ayrılan bellek `UXBStructFree()` ile serbest bırakılır.

Struct değeri parametresi alan bir C fonksiyonunda uXBasic tarafı struct
pointer'ını verir; üretilen shim değeri doğru C türünde dereference eder.
Bu nedenle bu fonksiyonlar API'den atılmaz.

## Neden vendor DLL doğrudan CALL(DLL) ile çağrılmıyor?

Bazı fonksiyonlar doğrudan çağrılabilir; fakat tüm API için şu engeller vardır:

- `CALL(DLL)` interpreter sözleşmesi en fazla 10 runtime argüman taşır.
- `curl_easy_setopt`, `sqlite3_mprintf` gibi variadic fonksiyonlar vardır.
- `float`, 8/16 bit sayılar, function pointer ve callback tipleri vardır.
- Birçok API `T **out`, raw buffer, opaque handle ve callback kullanır.
- Public header içinde DLL'de export edilmeyen `static inline` işlevler vardır.

`uxcapi.dll`, mevcut compileri değiştirmeden libffi ile sınırsız argüman frame'i,
variadic çağrı, pointer/buffer yönetimi ve callback pointer üretimi sağlar.
Üretilen her uXBasic fonksiyon yine kendi C adıyla görünür.

## Güvenli paket kaynağı

Varsayılan sağlayıcı MSYS2 UCRT64 resmi deposudur. Paketler rastgele DLL
sitelerinden indirilmez. `pacman` paket bağımlılıklarını, sürüm bilgisini,
checksum ve paket veritabanını yönetir.

Kurulan ana paketler:

```text
mingw-w64-ucrt-x86_64-gcc
mingw-w64-ucrt-x86_64-clang
mingw-w64-ucrt-x86_64-libffi
mingw-w64-ucrt-x86_64-pkgconf
mingw-w64-ucrt-x86_64-sqlite3
mingw-w64-ucrt-x86_64-curl-winssl
mingw-w64-ucrt-x86_64-json-c
mingw-w64-ucrt-x86_64-pcre2
mingw-w64-ucrt-x86_64-zstd
mingw-w64-ucrt-x86_64-libarchive
mingw-w64-ucrt-x86_64-libsodium
```

`curl-winssl` Windows Schannel ve Windows sertifika deposunu kullanır.

## Üretilen standart modüller

| uXBasic include | Namespace | Vendor |
|---|---|---|
| `uxsqlite.uxmh` | `sqlite3` | SQLite |
| `uxhttp.uxmh` | `curl` | libcurl |
| `uxjson.uxmh` | `jsonc` | json-c |
| `uxregex.uxmh` | `pcre2` | PCRE2 8-bit DLL'nin bütün public fonksiyonları |
| `uxcompress.uxmh` | `zstd` | Zstandard + ZDICT |
| `uxarchive.uxmh` | `archive` | libarchive |
| `uxcrypto.uxmh` | `sodium` | libsodium |

`uxjson` adı korunur; tam API sağlayıcısı olarak resmi MSYS2 paketli `json-c`
kullanılır. yyjson daha sonra ikinci sağlayıcı olarak eklenebilir; bu pakette
rastgele kaynak indirme yapılmaz.

## Kurulum ve üretim

ZIP'i uXBasic köküne açtıktan sonra tek komut yeterlidir:

```powershell
.\BUILD_UXB_C_FULL_API.bat
```

Hiç parametre verilmezse betik otomatik olarak bağımlılıkları kurar, temiz build
yapar ve testleri çalıştırır. MSYS2 çok eskiyse önce UCRT64 terminalinde
`pacman -Syu` çalıştırılmalıdır; build betiği tüm MSYS2 sistemini kendiliğinden
güncellemez. Gelişmiş seçim gerektiğinde aşağıdaki parametreler kullanılır.

Yalnız belirli modüller:

```powershell
.\BUILD_UXB_C_FULL_API.bat `
  -Modules uxsqlite,uxjson,uxregex `
  -InstallDeps `
  -RunTests
```

Paketleri kurmadan, mevcut MSYS2 kurulumuyla yeniden üretim:

```powershell
.\BUILD_UXB_C_FULL_API.bat -Clean
```

Deneysel header yüzeylerini de denetlemek:

```powershell
.\BUILD_UXB_C_FULL_API.bat -Profile experimental
```

Bu profil yalnız inceleme içindir. Vendor DLL deneysel sembolü gerçekten export
etmiyorsa `unbound_function_count` sıfır olmaz ve build bilinçli olarak FAIL
verir; export edilmeyen işlev varmış gibi sahte standart kütüphane üretilmez.

## Çıktılar

```text
runtime_ext/uxcapi/uxcapi.dll            genel C ABI motoru
runtime_ext/c_full_generated/            inline shim C kaynakları
libsx/<modül>/<modül>.bas                 tam raw uXBasic API
include/modules/<modül>.uxmh             include başlığı
dist/libraries/bin/uxcapi.dll             birinci taraf DLL
dist/libraries/deps/*.dll                 vendor ve geçişli bağımlılıklar
reports/libraries/c_full/<zaman>/         kapsam ve test raporları
```

Her modül için `surface.json` raporu şunları yazar:

```text
header_function_count
generated_function_count
exported_function_count
inline_shim_count
variadic_function_count
unbound_function_count
```

Build, `unbound_function_count` sıfır değilse PASS vermez.

## Variadic fonksiyon kullanımı

`sqlite3_mprintf`, `curl_easy_setopt` ve benzeri variadic C fonksiyonlarında
son parametre bir `uxcapi.Args` handle'ıdır:

```uxbasic
DIM args AS U64
args = uxcapi.ArgsNew()
uxcapi.ArgsAddString(args, "deger")
result = sqlite3.sqlite3_mprintf("%s", args)
uxcapi.ArgsFree(args)
```

C variadic kuralları geçerlidir: `float` değeri `double`, 8/16 bit tamsayılar
`int` olarak terfi eder. Bu nedenle variadic listede küçük türler yerine
`ArgsAddI32`, `ArgsAddU32` veya `ArgsAddF64` kullanılmalıdır.

## Callback kullanımı

Callback parametresi alan bütün C fonksiyonları raw `PTR` argümanı alır.

Function pointer üç biçimde sağlanabilir:

1. C veya FreeBASIC callback DLL'indeki sembol:

```uxbasic
cb = uxcapi.SymbolAddress("benim_callback.dll", "satir_callback")
```

2. `uxcapi.Callback` gözlem kuyruğu:

```uxbasic
cb = uxcapi.CallbackNew(uxcapi.KIND_I32, 0, 0.0)
uxcapi.CallbackAddArg(cb, uxcapi.KIND_PTR)
uxcapi.CallbackAddArg(cb, uxcapi.KIND_STRPTR)
ASSERT uxcapi.CallbackBuild(cb) = 1
ptr = uxcapi.CallbackPointer(cb)
```

Bu callback çağrıları kuyruğa yazar ve önceden ayarlanmış sabit dönüş değerini
döndürür.

3. Senkron olarak argümana göre dönüş hesaplaması gereken callback:
C veya FreeBASIC callback DLL'i kullanılmalıdır. Compiler çekirdeğine yeni
callback anahtar sözcüğü eklenmez.

## Pointer ve out-parametre kullanımı

C API'leri pointer kullanımını saklamaz. Tam API için out-parametreler açıkça
bellek üzerinden kullanılır:

```uxbasic
DIM outDb AS U64
DIM db AS U64
DIM rc AS I32

outDb = uxcapi.MemoryAlloc(8)
rc = sqlite3.sqlite3_open("test.db", outDb)
db = uxcapi.MemoryReadPtr(outDb, 0)

' ... sqlite3 API ...

sqlite3.sqlite3_close(db)
uxcapi.MemoryFree(outDb)
```

Bu raw katmandır. Daha sonra ayrıca kolaylaştırıcı üst seviye modüller
eklenebilir; fakat raw fonksiyonların hiçbiri kaldırılmaz.

## Bilinçli sınırlar

- C preprocessor function-like makroları DLL fonksiyonu değildir. Bunlar
  `function_count` içine dahil edilmez. Altında gerçek bir C fonksiyonu varsa
  o fonksiyon kendi gerçek adıyla üretilir. Complex macro'lar raporda sayılır
  ama fonksiyon gibi gösterilmez.
- Private/internal semboller dahil edilmez.
- Vendor'un DLL build'inde export etmediği deneysel fonksiyonlar standarda
  alınmaz. `stable` profil gerçek dinamik DLL yüzeyidir.
- PCRE2 için kullanılan sağlayıcı `libpcre2-8.dll` olduğundan 16-bit ve 32-bit
  ayrı DLL yüzeyleri bu modüle karıştırılmaz.
- JS/WAT/WASM hedeflerinde Windows native DLL çağrıları fail-close kalır.
- Bu ortam Windows/MSYS2 olmadığı için burada gerçek PE32+ DLL build ve uXBasic
  AST/MIR koşusu yapılamadı. Python üretici statik olarak test edilmiştir;
  gerçek sonuç raporları Windows koşusunda oluşacaktır.
