# uXBasic STRUCT / UNION / C ABI yaması

Yama tarihi: 2026-07-28

Bu paket son `uxb(28.07_4).zip` kaynak ağacı üzerine doğrudan açılacak biçimde hazırlanmıştır. Yalnız değişen ve yeni dosyaları içerir.

## 1. Eklenen dil yüzeyi

```basic
STRUCT Vec2 ABI C
    x AS F32
    y AS F32
END STRUCT

UNION NumberBits ABI C
    asU64 AS U64
    asF64 AS F64
END UNION

STRUCT PackedHeader ABI C PACK 1
    tag AS U8
    value AS U32
END STRUCT

STRUCT AlignedValue ABI C ALIGN 16
    value AS F64
END STRUCT
```

`STRUCT` ve `UNION`, yeni ve paralel bir AST sistemi kurmaz. İkisi de mevcut `TYPE_STMT` ve alan erişim yollarını kullanır. Kayıt sözleşmesi AST `op` metadata alanında saklanır:

```text
STRUCT;ABI=C;PACK=0;ALIGN=0
UNION;ABI=C;PACK=0;ALIGN=0
```

Bu sayede mevcut AST interpreter, MIR, x64 alan adresleme, `SIZEOF` ve `OFFSETOF` yolları korunur.

### Layout davranışı

- `STRUCT`: Alanlar doğal hizalama ile sırayla yerleştirilir.
- `UNION`: Bütün alanların offset değeri `0` olur; boyut en büyük alanın boyutudur.
- `PACK n`: Alan hizalamasını en fazla `n` bayt yapar.
- `ALIGN n`: Kayıt toplam hizalamasını en az `n` bayt yapar.
- Geçerli değerler: `1, 2, 4, 8, 16, 32, 64`.
- Mevcut `TYPE ... END TYPE` davranışı korunur; varsayılan ABI `UX` olur.

## 2. MIR ve JSON değişiklikleri

Aynı CLI seçeneği kullanılmaya devam eder:

```powershell
.\bin\uxb.exe .\program.uxb `
  --mir-full-json-out .\reports\program.mir.json
```

`module.record_types` alanı şunları verir:

- kayıt adı ve türü: `type`, `struct`, `union`, `class`
- ABI: `ux` veya `c`
- byte boyutu ve hizalama
- `PACK` ve açık `ALIGN`
- alan adı, tipi, offset, boyut ve hizalama
- sabit dizi boyutları ve stride
- `ffi_by_value` ve `ffi_by_reference` bilgisi

MIR tip köprüsü artık kullanıcı tiplerini sabit `8/8` varsayımıyla değil, semantic layout tablosundaki gerçek boyut ve hizalamayla taşır.

## 3. uxcapi.dll / uxcabi.dll

Kanonik DLL adı değişmemiştir:

```text
uxcapi.dll
```

Build betiği ayrıca kullanıcıların beklediği adla aynı binary'nin uyumluluk kopyasını üretir:

```text
uxcabi.dll
```

Wrapper ve manifest kanonik olarak `uxcapi.dll` kullanır. Aynı işlemde iki adı ayrı DLL gibi yüklemeyin.

API sürümü:

```text
uxcapi_version() = 200
```

### Eklenen aggregate API

```text
uxcapi_type_struct_new
uxcapi_type_union_new
uxcapi_type_add_field
uxcapi_type_add_struct_field
uxcapi_type_add_array_field
uxcapi_type_add_struct_array_field
uxcapi_type_set_expected_layout
uxcapi_type_finalize
uxcapi_type_size
uxcapi_type_alignment
uxcapi_call_set_return_struct
uxcapi_call_arg_struct
uxcapi_args_add_struct
uxcapi_result_struct_size
uxcapi_result_struct_copy
```

Doğal C ABI layout kullanan structlar libffi descriptor'ı üzerinden:

- fonksiyona by-value parametre,
- fonksiyondan struct dönüş,
- iç içe struct,
- sabit boyutlu scalar veya struct dizisi alanı

olarak taşınabilir.

### UNION politikası

Çekirdekte union gerçek ortak offsetli kayıt tipidir. FFI tarafında:

- pointer/BYREF aktarımı doğrudan desteklenir,
- ortak bellek `uxcapi.Memory*` API'leriyle okunup yazılabilir,
- union-by-value parametre veya dönüş için otomatik üretilen küçük C adaptörü kullanılır.

Libffi'nin union sınıflandırmasını tahmin ederek yanlış ABI üretmek yerine bu yol bilinçli olarak fail-close tutulmuştur.

### Packed struct politikası

`PACK 1/2/4...` ile oluşturulmuş kaydın uXBasic layout'u ile libffi doğal layout'u farklıysa `TypeFinalize` başarısız olur ve açıklayıcı hata verir. Böyle bir tip:

- pointer ile aktarılır veya
- generator tarafından C adaptörüne düzleştirilir.

## 4. uXBasic wrapper örneği

```basic
INCLUDE "include/modules/uxcapi.uxmh"

DIM vecType AS U64
DIM memory AS U64
DIM callHandle AS U64
DIM ok AS I32

vecType = uxcapi.TypeStructNew()
ok = uxcapi.TypeAddField(vecType, uxcapi.KIND_F32)
ok = uxcapi.TypeAddField(vecType, uxcapi.KIND_F32)
ok = uxcapi.TypeSetExpectedLayout(vecType, 8, 4)
ok = uxcapi.TypeFinalize(vecType)

memory = uxcapi.MemoryCalloc(1, 8)
ok = uxcapi.MemoryWriteF32(memory, 0, 10.0)
ok = uxcapi.MemoryWriteF32(memory, 4, 20.0)

callHandle = uxcapi.CallNew("library.dll", "take_vec2", uxcapi.KIND_VOID, 0, 0)
ok = uxcapi.ArgStruct(callHandle, vecType, memory, 8)
ok = uxcapi.Invoke(callHandle)

uxcapi.CallFree(callHandle)
uxcapi.MemoryFree(memory)
uxcapi.TypeFree(vecType)
```

Struct döndüren fonksiyon için çağrı önce `KIND_VOID` ile oluşturulur, sonra gerçek dönüş descriptor'ı atanır:

```basic
callHandle = uxcapi.CallNew("library.dll", "make_vec2", uxcapi.KIND_VOID, 0, 0)
ok = uxcapi.CallSetReturnStruct(callHandle, vecType)
ok = uxcapi.Invoke(callHandle)
ok = uxcapi.ResultStructCopy(callHandle, memory, 8)
```

## 5. MIR JSON'dan descriptor wrapper üretimi

Yeni araç:

```text
tools/library_codegen/mir_record_binding_generator.py
```

Kullanım:

```powershell
python .\tools\library_codegen\mir_record_binding_generator.py `
  .\reports\program.mir.json `
  .\generated\program_records.bas `
  --namespace program_records
```

Araç:

- scalar struct alanlarını,
- iç içe struct alanlarını,
- sabit alan dizilerini,
- union boyut/hizalama metadata'sını

okuyup `uxcapi.Type*` descriptor builder fonksiyonları üretir.

## 6. Uygulama

Kaynak kökünde:

```powershell
Expand-Archive `
  -LiteralPath .\UXB_STRUCT_UNION_UXCABI_20260728_PATCH.zip `
  -DestinationPath . `
  -Force
```

Önce hızlı statik doğrulama:

```powershell
python .\tests\struct_union_uxcapi\verify_patch.py --root .
```

Libffi bağımlılığı daha önce kurulmadıysa bir kez:

```powershell
.\runtime_ext\uxcapi\fetch_uxcapi_deps_msys2.bat
```

Yalnız DLL build:

```powershell
.\runtime_ext\uxcapi\build_uxcapi_dll.bat
```

Compiler'ı yeniden build etmeden test:

```powershell
pwsh .\tests\struct_union_uxcapi\run_struct_union_uxcapi_smoke.ps1
```

Mevcut compiler yeni syntaxı tanımadığı için ilk uygulamada tam build gerekir. Uzun build yalnız açık anahtarla başlatılır:

```powershell
pwsh .\tests\struct_union_uxcapi\run_struct_union_uxcapi_smoke.ps1 -BuildCompiler
```

Yalnız parser/layout/MIR JSON kontrolü:

```powershell
pwsh .\tests\struct_union_uxcapi\run_struct_union_uxcapi_smoke.ps1 `
  -BuildCompiler `
  -SkipRuntimeSmoke
```

## 7. Smoke test kapsamı

- `STRUCT ABI C`
- `UNION ABI C`
- union alanlarının ortak offset `0` olması
- `PACK 1`
- `ALIGN 16`
- MIR JSON `record_types`
- libffi struct parametresi
- libffi struct dönüşü
- DLL export ve wrapper marker doğrulaması
- manifestte `uxcapi` API 200 kaydı

## 8. Bu pakette yapılmayanlar

- Union-by-value için ABI tahmini yapılmadı; C adaptörü gerekir.
- Packed struct by-value zorlanmadı; descriptor layout uyuşmazsa reddedilir.
- C bitfield doğrudan çekirdeğe eklenmedi; getter/setter adaptörü gerekir.
- Flexible array member doğrudan by-value desteklenmez.
- Mevcut callback kuyruğu asenkrondur. Bu paket senkron uXBasic callback dispatcher eklemez.
- Struct callback parametresi by-value yerine pointer olarak geçirilmelidir.
- `VARPTR(recordVariable)` yolunun AST ve MIR yorumlayıcılarında kesintisiz, bit-bit C kayıt belleği verdiği bu yamada varsayılmaz. Doğrudan dış çağrıda güvenilir yol `uxcapi.MemoryCalloc` + `SIZEOF/OFFSETOF` veya üretilen marshalling adaptörüdür.
- C→uXBasic yönü mevcut asenkron callback olay kuyruğuyla çalışır; callback sırasında hesaplanan değerin aynı C çağrısına senkron döndürülmesi bu paketin kapsamı değildir.

Bu sınırlar çekirdeğin ve DLL ABI'sinin yanlış veri üretmesini engellemek için bilinçlidir.
