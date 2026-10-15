# UXClazz, uxbdll ve uxclz.dll

## Çekirdeği genişletmeden uXBasic OOP üretim sistemi

**Yama sürümü:** 2026-07-29 / 1.0  
**Hedef kaynak:** `uxb(29.07_1)` kaynak gerçekliği  
**Temel karar:** uXBasic `CLASS` sistemi korunur; yeni nesne türleri ve DLL ürün hattı compiler çekirdeğinin dışında kurulur.

---

## 1. Amaç

Bu yama aynı amaca hizmet eden fakat birbirinin yerine geçmek zorunda olmayan üç ayrı sistem getirir:

1. **UXClazz kaynak üreticisi**  
   `CLAZZ VALUE`, `CLAZZ DATA`, `CLAZZ ENTITY`, `CLAZZ COMPONENT`, `CLAZZ ACTOR` ve `CLAZZ NATIVE` gibi üst düzey bildirimleri normal uXBasic `CLASS`, `PROPERTY`, `METHOD` ve `MAGIC` koduna dönüştürür.

2. **uxbdll ürün aracı**  
   uXBasic x64 hattının ürettiği `program.asm`, `program.obj` ve `program_link_args.rsp` dosyalarını kullanarak aynı native kodu Windows x64 DLL olarak bağlar. Compiler parserı, semantic katmanı, MIR veya code generator değiştirilmez.

3. **uxclz.dll C++ runtime’ı**  
   C/C++ tabanlı bağımsız nesne kayıt sistemi sağlar. Generation handle, referans sayımı, interface/capability sorgusu, metadata, method registry ve multiple dispatch içerir. uXBasic’in kendi nesne sistemini değiştirmez; plugin ve dinamik nesne kullanımında ikinci bir seçenek sunar.

Bu ayrım bilinçlidir:

```text
uXBasic CLASS/vtable
    = ana ve tip güvenli nesne modeli

UXClazz
    = kaynak seviyesinde yeni OOP özellikleri

uxbdll
    = uXBasic native kodunu DLL ürünü yapan araç

uxclz.dll
    = bağımsız dinamik registry/handle/multiple-dispatch runtime'ı
```

---

## 2. Neden compiler çekirdeğine yeni DLL modu eklenmedi?

Bugünkü x64 hattı zaten DLL üretiminin zor kısmını yapmaktadır:

- Win64 NASM üretir.
- `nasm -f win64` ile COFF OBJ üretilebilir.
- Bütün top-level rutinler `global` semboldür.
- Sınıf metotları, constructor ve destructorlar global sembol olarak üretilir.
- Windows x64 integer ve floating-point çağrı ABI’si uygulanır.
- Sınıf layoutu, vtable, constructor ve destructor native koda indirilir.
- `program_link_args.rsp` bütün OBJ ve import library bağımlılıklarını toplar.

Eksik olan yalnız son bağlama biçimidir. Mevcut EXE linki kabaca şöyledir:

```bat
"%UXB_LINK_CMD%" @program_link_args.rsp -o program.exe
```

DLL için gereken biçim:

```bat
"%UXB_LINK_CMD%" -shared @program_link_args.rsp module.def ^
  -Wl,--out-implib,libmodule.dll.a ^
  -Wl,--enable-auto-import ^
  -o module.dll
```

Bu nedenle compiler içine yeni keyword, AST node, MIR opcode veya CLI rotası eklemek yerine bağımsız `uxbdll.py` kullanılmıştır. Bu yaklaşım çekirdek dondurulsa bile çalışır.

---

## 3. Yama dosya ağacı

```text
tools/
  uxbdll/
    uxbdll.py
    uxbdll.schema.json
  uxclazz/
    uxclazz.py
  tests/
    verify_uxclazz_uxbdll_patch.py

runtime_ext/
  uxclz/
    include/uxclz.h
    src/uxclz.cpp
    tests/uxclz_smoke.cpp
    build_uxclz.bat
    build_posix.sh

libsx/
  uxclz/uxclz.bas
  uxclazz/uxclazz_support.bas

include/modules/
  uxclz.uxmh
  uxclazz.uxmh

examples/
  uxbdll/
    uxoop_module.uxb
    uxoop_module.uxdll.json
    uxoop_module_smoke.uxb
  uxclazz/
    fish_sample.uxclz
```

Yama mevcut compiler dosyalarını değiştirmez. Bütün değişiklikler yeni dosyalardır.

---

# Kısım A — UXClazz kaynak üreticisi

## 4. UXClazz ne yapar?

UXClazz yeni bir compiler değildir. Bir kaynak üreticisidir:

```text
sample.uxclz
    ↓ python tools/uxclazz/uxclazz.py
sample_generated.uxb
    ↓ uxb.exe
AST / MIR / x64
```

Compiler yalnız üretilen normal uXBasic kodunu görür.

## 5. Desteklenen ilk yüzey

```basic
CLAZZ DATA FishSample
    DERIVE EQ, HASH, CLONE, TOSTRING, JSON
    DECORATOR Validated
    Code AS STRING
    Length AS F64
    Weight AS F64
    Alive AS BOOLEAN
END CLAZZ
```

İlk sürüm şu başlıkları tanır:

```text
CLAZZ VALUE Name
CLAZZ DATA Name
CLAZZ ENTITY Name
CLAZZ COMPONENT Name
CLAZZ ACTOR Name
CLAZZ NATIVE Name
CLAZZ DATA Child EXTENDS Base
```

Sınıf içinde:

```text
IMPLEMENTS IOne, ITwo
USES TraitA, TraitB
DERIVE EQ, HASH, CLONE, TOSTRING, JSON
DECORATOR Validated
READONLY Id AS U64
Name AS STRING
```

## 6. Profil davranışları

### VALUE

Değer eşitliği, hash, clone ve string dönüşümü gibi davranışların üretilmesi için kullanılır. Değer nesnesinin bütün alanlarının constructor üzerinden verilmesi beklenir.

### DATA

Veri taşıma ve serileştirme amacı taşır. `DERIVE JSON` ile `ToJson()` üretilir.

### ENTITY

Kimlik ve sürüm taşıyan domain nesnesidir. Kaynakta bulunmuyorsa generator otomatik olarak şunları ekler:

```basic
READONLY Id AS U64
Version AS U64
```

### COMPONENT

`USES` bildirimlerini gerçek çoklu kalıtıma çevirmek yerine composition alanlarına ve erişim metotlarına indirger. Mevcut compiler `MIXIN` yüzeyine birden fazla trait göndermek yerine güvenli bileşim kullanılır.

### ACTOR

İlk sürümde metadata profili olarak üretilir. Mailbox, `EVENT/SLOT/TRIGGER/PIPE` weaving ikinci aşamada generator şablonlarıyla eklenebilir. Compiler değişikliği gerektirmez.

### NATIVE

Native peer niyetini metadata içinde taşır. Native C/C++ handle alanları ve wrapper metotları manifest tabanlı sonraki generator aşamasında üretilebilir.

## 7. DERIVE davranışları

### EQ

Şuna benzer tip güvenli bir metot üretir:

```basic
VIRTUAL METHOD Equals(other AS FishSample) AS BOOLEAN
    RETURN THIS.Code == other.Code AND THIS.Length == other.Length
END METHOD
```

### HASH

Özel MAGIC fallback sistemini kullanır:

```basic
MAGIC HASH() AS U64
    ...
END MAGIC
```

Hash yardımcıları `uxclazz_support` namespace’inde saf uXBasic olarak bulunur.

### CLONE

```basic
MAGIC CLONE() AS FishSample
    RETURN NEW FishSample(...)
END MAGIC
```

### TOSTRING

```basic
MAGIC TOSTRING() AS STRING
    RETURN "FishSample(Code=" + THIS.Code + ...
END MAGIC
```

### JSON

JSON metni oluşturur. String kaçışları `uxclazz_support.EscapeJson()` üzerinden yapılır.

## 8. Generator komutları

Proje kökünde:

```powershell
python .\tools\uxclazz\uxclazz.py `
  .\examples\uxclazz\fish_sample.uxclz `
  -o .\build\uxclazz\fish_sample_generated.uxb `
  --manifest .\build\uxclazz\fish_sample.metadata.json
```

Yalnız sözdizimi kontrolü:

```powershell
python .\tools\uxclazz\uxclazz.py `
  .\examples\uxclazz\fish_sample.uxclz `
  -o .\build\unused.uxb `
  --check
```

## 9. Bilinen UXClazz ilk sürüm sınırları

- `DECORATOR` girdileri metadata içine kaydedilir; henüz metot gövdesi weaving yapılmaz.
- `USES`, bileşen alanı ve getter/setter üretir; trait metotlarını otomatik kopyalamaz.
- Generic specialization ilk sürümde yoktur.
- Actor mailbox üretimi ilk sürümde yoktur.
- Generated uXBasic kodu bu Linux doğrulama ortamında `uxb.exe` ile derlenememiştir; Windows üzerindeki gerçek compiler testleri aşağıdaki üretim kapılarında verilmiştir.
- Generator bilinçli olarak küçük ve açık tutulmuştur. Yeni yüzeyler compiler çekirdeğine değil bu araca eklenmelidir.

---

# Kısım B — uxbdll: uXBasic kodundan DLL

## 10. Temel çalışma biçimi

`uxbdll.py`, uXBasic x64 build klasöründe şu dosyaları bekler:

```text
program.asm
program_link_args.rsp
build_program.bat
interop/toolchain.env.bat
```

Normal uXBasic x64 build hattı bu dosyaları üretir.

Araç:

1. `program.asm` içindeki bütün `global` sembolleri okur.
2. Manifestte belirtilen internal exportların gerçekten bulunduğunu doğrular.
3. `.def` dosyası üretir.
4. `build_dll.bat` üretir.
5. Tip güvenli `CALL(DLL)` wrapperı üretir.
6. `.uxmh` forwarding header üretir.
7. İşlem raporu üretir.

## 11. Neden export manifesti gereklidir?

uXBasic x64 ASM içinde çok sayıda global sembol bulunabilir:

- Top-level rutinler
- Sınıf metotları
- Constructorlar
- Destructorlar
- Property getter/setterlar
- Callback stubları

Bunların tamamını DLL dışına açmak güvenli değildir. Manifest yalnız kararlı C ABI köprü rutinlerini açar.

Örnek:

```json
{
  "public": "uxoop_counter_add",
  "internal": "UXOOP_COUNTER_ADD",
  "return": "I32",
  "args": [
    {"name": "counter", "type": "PTR"},
    {"name": "delta", "type": "I32"}
  ]
}
```

Üretilen `.def` satırı:

```def
uxoop_counter_add=UXOOP_COUNTER_ADD
```

Böylece compilerın internal sembolü büyük harfli kalabilir; public DLL API adı sabit ve okunabilir olur.

## 12. Neden ham sınıf metotları export edilmez?

Şunları doğrudan export etmek teknik olarak mümkündür:

```text
COUNTER_CTOR
COUNTER_ADD
COUNTER_DTOR
```

Ancak dış kullanıcı o zaman:

- `THIS` receiver register düzenini,
- Sınıf object layoutunu,
- Vtable adresini,
- Base layoutunu,
- String ve array runtime sözleşmesini,
- Constructor/destructor zincirini

bilmek zorunda kalır.

Kararlı yöntem, sınıfı DLL içinde tutan top-level ABI köprüleridir:

```basic
FUNCTION UXOOP_COUNTER_CREATE(startValue AS I32) AS Counter
    DIM result AS Counter
    result = NEW Counter(startValue)
    RETURN result
END FUNCTION

FUNCTION UXOOP_COUNTER_ADD(counter AS Counter, delta AS I32) AS I32
    RETURN counter.Add(delta)
END FUNCTION

SUB UXOOP_COUNTER_RELEASE(counter AS Counter)
    DELETE counter
END SUB
```

Dış wrapper bunları şu biçimde görür:

```text
create → PTR
add    → PTR,I32 → I32
release→ PTR → VOID
```

Nesne DLL içinde oluşturulur ve aynı DLL içinde bırakılır.

## 13. Önemli heap ve yaşam döngüsü kuralı

**Bir nesneyi oluşturan DLL, o nesneyi serbest bırakmalıdır.**

Yanlış:

```text
DLL: NEW Counter
EXE: ham free(pointer)
```

Doğru:

```text
DLL: uxoop_counter_create
DLL: uxoop_counter_release → DELETE Counter
```

Böylece derived/base destructor zinciri korunur.

## 14. Manifest alanları

| Alan | Görev |
|---|---|
| `name` | DLL ürün adı ve varsayılan namespace |
| `project_root` | Diğer yolların çözüleceği proje kökü |
| `build_dir` | uXBasic x64 artifact klasörü |
| `output_dir` | DLL ve import library hedefi |
| `dll_name` | Üretilecek DLL adı |
| `namespace` | Üretilen wrapper namespace’i |
| `wrapper_bas` | Üretilen wrapper `.bas` yolu |
| `wrapper_uxmh` | Public forwarding header yolu |
| `build_program` | Önce `build_program.bat` çalıştırılsın mı |
| `runtime_dependencies` | Çıktı klasörüne aranarak kopyalanacak DLL’ler |
| `linker_flags` | Ek MinGW linker seçenekleri |
| `exports` | Public/internal sembol ve ABI imzaları |

Desteklenen temel ABI türleri:

```text
VOID
I8 U8 I16 U16 I32 U32 I64 U64
F32 F64
PTR STRPTR WSTRPTR
BOOLEAN
```

## 15. uxbdll kullanımı

Önce normal x64 build artifactını üretin. İncelenen 29.07 CLI rotasına göre örnek komut:

```powershell
.\bin\uxb.exe bld `
  .\examples\uxbdll\uxoop_module.uxb `
  --x64-mode=MIR `
  --build-x64-out .\build\uxoop_module_x64
```

`--build-x64-out` değeri `.exe` ile bitmezse compiler bunu build klasörü kabul eder ve şu artifactları üretir:

```text
build/uxoop_module_x64/program.asm
build/uxoop_module_x64/obj/program.obj
build/uxoop_module_x64/program_link_args.rsp
build/uxoop_module_x64/build_program.bat
build/uxoop_module_x64/interop/toolchain.env.bat
```

Bu ilk komut mevcut pipeline gereği `program.exe` de bağlayabilir. `uxbdll`, aynı OBJ/RSP kümesini daha sonra DLL olarak yeniden bağlar.

Ardından:

```powershell
python .\tools\uxbdll\uxbdll.py `
  --manifest .\examples\uxbdll\uxoop_module.uxdll.json `
  --force
```

Bu komut yalnız ürün dosyalarını hazırlar. Windows üzerinde doğrudan build ve export audit:

```powershell
python .\tools\uxbdll\uxbdll.py `
  --manifest .\examples\uxbdll\uxoop_module.uxdll.json `
  --force `
  --run
```

`--run` şunları yapar:

1. `build_program.bat`
2. `gcc -shared`
3. DLL ve import library üretimi
4. `objdump` export doğrulaması

Yalnız önceden üretilmiş DLL export kontrolü:

```powershell
python .\tools\uxbdll\uxbdll.py `
  --manifest .\examples\uxbdll\uxoop_module.uxdll.json `
  --verify-only
```

## 16. Üretilen dosyalar

Örnek modül için:

```text
build/uxoop_module_x64/uxoop_module.def
build/uxoop_module_x64/build_dll.bat
build/uxoop_module_x64/uxbdll_report.json
libsx/uxoop_module/uxoop_module.bas
include/modules/uxoop_module.uxmh
dist/libraries/bin/uxoop_module.dll
dist/libraries/bin/libuxoop_module.dll.a
```

## 17. DLL modül başlangıç ve kapanışı

Windows `DllMain` içinde karmaşık uXBasic runtime işlemi yapılmamalıdır. Loader lock nedeniyle DLL yükleme, thread başlatma ve başka DLL çözme tehlikeli olabilir.

Bunun yerine explicit export kullanılır:

```basic
FUNCTION UXOOP_MODULE_INIT() AS I32
    RETURN 1
END FUNCTION

FUNCTION UXOOP_MODULE_SHUTDOWN() AS I32
    RETURN 1
END FUNCTION
```

Wrapper kullanıcısı:

```basic
ASSERT uxoop_module.uxoop_module_init() == 1
...
ASSERT uxoop_module.uxoop_module_shutdown() == 1
```

şeklinde çağırır.

FFI resolver veya native task runtime kullanan modüllerde gerçek başlangıç kodu bu rutinlerin içine veya sonraki bootstrap üreticisine konmalıdır.

## 18. Cross-DLL inheritance sınırı

DLL içindeki sınıflar kendi aralarında gerçek `EXTENDS/VIRTUAL/OVERRIDE` kullanabilir.

Fakat başka bir DLL’de bulunan sınıftan kaynak seviyesinde doğrudan kalıtım güvenli değildir:

```basic
CLASS Local EXTENDS ExternalDllClass
```

Compiler external sınıfın:

- boyutunu,
- field offsetlerini,
- vtable slotlarını,
- base chainini,
- access metadata’sını

compile time’da bilmez.

DLL sınırında kullanılacak desenler:

- Interface/proxy
- Composition/delegation
- Opaque handle
- `query_interface`
- Capability metadata

---

# Kısım C — uxclz.dll C++ runtime

## 19. Bu ikinci sistem neden ayrıca var?

uXBasic-native DLL yolu çoğu kullanımda tercih edilmelidir. Ancak bazı projeler:

- C++ plugin host,
- thread-safe merkezi registry,
- çalışma zamanında method registration,
- runtime type metadata,
- iki nesnenin gerçek tipine göre multiple dispatch,
- C/C++ native payload sahipliği

isteyebilir.

`uxclz.dll` bu gereksinimler için bağımsız seçenektir. uXBasic’in kendi `CLASS` sistemini iptal etmez.

## 20. Generation handle yapısı

Handle:

```text
üst 32 bit  = slot + 1
alt 32 bit  = generation
```

Slot bırakıldığında generation artırılır. Böylece eski handle yeniden kullanılan slota yanlışlıkla bağlanamaz.

Korunan durumlar:

- Stale handle
- Double release
- Yanlış type ID
- Referans sayımı taşması
- Registry reset sırasında canlı nesne bulunması

## 21. Type registry

Her tip şunları taşır:

```text
id
name
base type
flags
interfaces
method table
```

Flag örnekleri:

```text
TYPE_CLASS
TYPE_INTERFACE
TYPE_VALUE
TYPE_ENTITY
TYPE_COMPONENT
TYPE_ACTOR
TYPE_NATIVE
TYPE_ABSTRACT
```

## 22. Interface/capability

```text
uxclz_type_add_interface
uxclz_type_has_interface
uxclz_object_query_interface
```

`query_interface` aynı opaque handleı döndürür ve reference count artırır. Kullanıcı dönen handleı ayrıca `release` etmelidir.

## 23. Method registry

C/C++ callback sözleşmesi:

```cpp
int method(
    uxclz_handle self,
    void* payload,
    const uxclz_value* args,
    uint32_t argc,
    uxclz_value* result
);
```

Method ID, isim ve function pointer bir type üzerine kaydedilir. Invoke sırasında method önce gerçek tipte, bulunamazsa base chain üzerinde aranır.

Callback çalışırken registry mutexi tutulmaz. Nesne invoke süresince geçici olarak retain edilir.

## 24. Multiple dispatch

Kayıt anahtarı:

```text
method ID + left runtime type + right runtime type
```

Tam eşleşme yoksa base zincirleri en yakın eşleşme için taranır.

Bu sistem şu kullanımlar için uygundur:

```text
Collide(Ship, Asteroid)
Collide(Ship, PowerUp)
Render(Sprite, OpenGLContext)
Serialize(Entity, JsonArchive)
```

## 25. uxclz.dll derleme

Windows / MSYS2 UCRT64:

```powershell
Set-Location .\runtime_ext\uxclz
$env:UXB_CXX = "C:\msys64\ucrt64\bin\g++.exe"
.\build_uxclz.bat
```

Çıktılar:

```text
runtime_ext/uxclz/build/uxclz.dll
runtime_ext/uxclz/build/libuxclz.dll.a
runtime_ext/uxclz/build/uxclz_smoke.exe
```

Linux üzerinde yalnız kaynak doğrulaması için:

```bash
./runtime_ext/uxclz/build_posix.sh
```

Bu yol `.so` üretir; Windows dağıtım ürünü değildir.

## 26. uXBasic wrapper kullanımı

```basic
INCLUDE "include/modules/uxclz.uxmh"

MAIN
    DIM objectType AS U32
    DIM entityType AS U32

    ASSERT uxclz.Version() == uxclz.ABI_VERSION

    objectType = uxclz.TypeRegister("Object", 0, uxclz.TYPE_CLASS)
    entityType = uxclz.TypeRegister("FishEntity", objectType, uxclz.TYPE_CLASS OR uxclz.TYPE_ENTITY)

    PRINT uxclz.TypeName(entityType)
    PRINT uxclz.RegistryMetadataJson()
END MAIN
```

Method callback kaydı için function pointer gerekir. Callback uXBasic-native DLL içinde exported routine olarak yazılabilir ve `uxcapi.SymbolAddress()` veya uygun `CODEPTR` yolu ile alınabilir. Bu ileri seviye yol ayrıca ABI smoke testine tabi tutulmalıdır.

## 27. uxclz.dll ne zaman kullanılmamalı?

Şu durumda doğrudan uXBasic `CLASS` veya typed DLL wrapper daha iyidir:

- Tipler compile time’da biliniyorsa
- Normal inheritance/vtable yeterliyse
- Mevcut `uxmatrix`, `uxonnx`, `uxgraph` wrapperları kullanılabiliyorsa
- Runtime method registry gerekmiyorsa
- Maximum performans isteniyorsa

Her çağrıyı generic invoke sistemine taşımak doğru değildir.

---

# Kısım D — Yöntem karşılaştırması

## 28. Karşılaştırma tablosu

| Yöntem | Tip güvenliği | Binary plugin | AST/MIR görünürlüğü | Dinamik dispatch | C++ gerekir mi? | En uygun alan |
|---|---:|---:|---:|---:|---:|---|
| Saf uXBasic CLASS | Yüksek | Hayır | Tam | Vtable/interface | Hayır | Ana uygulama |
| UXClazz generated CLASS | Yüksek | Kaynak halde hayır | Tam | Vtable/MAGIC | Hayır | Data/value/entity/trait |
| uXBasic OBJ statik link | Yüksek | Hayır | Kaynak testinde tam | Vtable | Hayır | Tek EXE modülleri |
| **uxbdll uXBasic DLL** | Typed bridge’de yüksek | **Evet** | DLL içinde native | Vtable + exported bridge | Hayır | Plugin/component/actor DLL |
| `uxclz.dll` | Registry sözleşmesine bağlı | Evet | Native runtime | Method + multiple dispatch | Evet | Dynamic plugin/runtime |
| `uxcapi.dll` | Runtime imzasına bağlı | DLL çağırır | Native | Sembol bazlı | Hazır DLL | Bilinmeyen DLL/callback |
| Özel C/C++ DLL | C ABI’ye bağlı | Evet | Native | Tasarıma bağlı | Evet | Yüksek performans/native peer |

## 29. Önerilen seçim kuralı

```text
Önce saf CLASS kullan.
    ↓
Yeni sınıf türü/derive/trait gerekiyorsa UXClazz kullan.
    ↓
Binary dağıtım/plugin gerekiyorsa aynı generated kodu uxbdll ile DLL yap.
    ↓
Runtime tip registry veya multiple dispatch gerekiyorsa uxclz.dll ekle.
    ↓
Bilinmeyen harici API veya callback gerekiyorsa uxcapi kullan.
    ↓
Yalnız zorunlu düşük seviye/performance işini özel C/C++ koduna bırak.
```

---

# Kısım E — Test ve doğrulama

## 30. Statik yama doğrulaması

Proje kökünde:

```powershell
python .\tools\tests\verify_uxclazz_uxbdll_patch.py
```

Kontrol edilenler:

- Bütün yeni dosyaların varlığı
- Python syntaxı
- UXClazz parse ve generated markerları
- UXClazz metadata üretimi
- Fake x64 artifact üzerinde uxbdll `.def` üretimi
- `CALL(DLL)` wrapper üretimi

## 31. C++ native smoke

Windows:

```powershell
.\runtime_ext\uxclz\build_uxclz.bat
```

Linux kaynak doğrulaması:

```bash
python3 tools/tests/verify_uxclazz_uxbdll_patch.py --native
```

Smoke testi:

- Type register
- Base type kontrolü
- Interface register/query
- Method callback
- Args/result taşıma
- Multiple dispatch
- Metadata JSON
- Retain/release
- Stale handle
- Double release

kontrollerini yapar. Beklenen çıktı:

```text
UXCLZ_SMOKE_PASS value=42
```

## 32. Windows üzerinde gerçek uXBasic DLL kanıt testleri

Sırayla:

### Test 1 — I32 ABI

```text
uXBasic DLL function → I32 + I32 → I32
```

Beklenen: `20 + 22 = 42`.

### Test 2 — F64 ABI

```text
F64 + F64 → F64
```

XMM register ve F64 dönüş doğrulanır.

### Test 3 — uXBasic class lifecycle

```text
create Counter
constructor
method
release
 destructor
```

### Test 4 — Virtual dispatch

```text
Animal receiver ← Dog object
Animal.Speak(handle) → Dog override → 42
```

### Test 5 — AST/MIR/x64 host parity

Aynı `CALL(DLL)` smoke kaynağı:

```text
AST interpreter
MIR interpreter
doğrudan x64
MIR → x64
```

üzerinde aynı sonucu vermelidir.

## 33. Üretim gate listesi

Her uXBasic-native DLL için:

```text
PASS program.asm exists
PASS expected global symbols
PASS NASM win64 OBJ
PASS gcc -shared link
PASS PE32+ x64
PASS exact exports
PASS import audit
PASS ABI version
PASS explicit module init
PASS explicit module shutdown
PASS C host smoke
PASS AST CALL(DLL)
PASS MIR CALL(DLL)
PASS direct x64 CALL(DLL)
PASS MIR→x64 CALL(DLL)
PASS result parity
PASS constructor count
PASS destructor count
PASS double-release protection at public API
PASS invalid-handle protection where registry is used
```

---

# Kısım F — Güvenlik ve teknik sınırlamalar

## 34. String ABI

İlk uXBasic-native DLL kanıtında numeric ve pointer ABI öncelikli kullanılmalıdır. uXBasic `STRING` iç düzeni ile dış C `char*` sözleşmesi aynı varsayılmamalıdır.

Public DLL API’de:

- Girdi için `STRPTR`
- Çıktı için module-owned immutable `STRPTR`
- veya caller buffer + size

sözleşmeleri ayrı bridge rutinleriyle tasarlanmalıdır.

## 35. Exception sınırı

uXBasic veya C++ exceptionı DLL sınırından dışarı taşmamalıdır. Public bridge:

```text
success/failure code
last_error string
```

modeline dönüştürülmelidir.

## 36. Thread ve callback ömrü

DLL unload edilmeden önce:

- Actor/thread durdurulmalı
- Callbackler registryden çıkarılmalı
- Bütün nesne handleları bırakılmalı
- Interface query ile alınan ek referanslar release edilmeli

Aksi halde vtable/function pointer artık yüklenmemiş DLL adresini gösterebilir.

## 37. Hot swap

Hot swap için önce eski DLL’nin bütün canlı nesneleri ve callbackleri bitirilmelidir. Nesne vtable pointerını korurken DLL unload etmek güvenli değildir.

## 38. Browser ve WASM

`uxbdll` ve `uxclz.dll` native Windows sistemleridir. JS/WASM hedefinde:

- native çağrı fail-close olmalı,
- browser adapter ayrı üretilmeli,
- aynı public UXClazz sözleşmesinin JS implementasyonu kullanılmalıdır.

---

# 39. Son mimari

```text
                         .uxclz
                           │
                           ▼
                    tools/uxclazz
                           │
                           ▼
                generated normal .uxb
                           │
            ┌──────────────┴──────────────┐
            │                             │
            ▼                             ▼
      AST/MIR development              x64 codegen
                                          │
                                          ▼
                                      program.asm
                                          │ NASM
                                          ▼
                                      program.obj
                                          │
                                          ▼
                                    tools/uxbdll
                                          │
                            .def + wrapper + gcc -shared
                                          │
                                          ▼
                                  uXBasic-native DLL

Optional dynamic runtime:

uXBasic / C / C++ host
        │
        ▼
     uxclz.dll
        │
 type registry + generation handle + interfaces
 method registry + metadata + multiple dispatch
```

# 40. Son karar

Bu yama, iki bağımsız uygulama yolunu birlikte sunar:

### Yol 1 — uXBasic ağırlıklı

```text
UXClazz → normal CLASS → uXBasic x64 → uxbdll → uXBasic-native DLL
```

Bu yol, uXBasic’in kendi vtable, inheritance, MAGIC, property, constructor ve destructor sistemini korur. Varsayılan tercih budur.

### Yol 2 — C++ dinamik runtime

```text
uXBasic/C/C++ → uxclz.dll → registry/handle/interface/multiple dispatch
```

Bu yol, merkezi runtime tip sistemi ve dinamik plugin davranışı isteyenler içindir.

İki sistem aynı projede de kullanılabilir. Örneğin UXClazz-generated bir uXBasic plugin DLL’i, exported callbacklerini `uxclz.dll` registry’sine kaydedebilir. Böylece sınıfın gerçek uygulaması uXBasic’te kalırken dinamik keşif ve multiple dispatch C++ runtime tarafından yönetilir.
