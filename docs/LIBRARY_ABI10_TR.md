# UXB-C-ABI10 Sözleşmesi

## 1. Kanonik çağrı

```uxbasic
CALL(DLL, "kutuphane.dll", "sembol", DONUS, CDECL, "TIP1,TIP2,...", arg1, arg2, ...)
```

İzin verilen dönüş/parametre tokenları:

```text
VOID I32 U32 I64 U64 F64 PTR STRPTR
```

En fazla 10 runtime parametresi vardır. Mevcut kütüphanelerde gözlenen en yüksek gerçek sayı 8'dir; 10 kapasitesi yeni modüller ve test sözleşmesi için ayrılmıştır.

Örnek:

```uxbasic
r = CALL(DLL, "uxstats.dll", "uxstats_vec_push", I32, CDECL, "PTR,F64", h, deger)
```

Tek parametreli liste de string olarak yazılır:

```uxbasic
CALL(DLL, "uxstats.dll", "uxstats_vec_free", VOID, CDECL, "PTR", h)
```

Sıfır parametrede tip listesi yazılmaz:

```uxbasic
v = CALL(DLL, "uxstats.dll", "uxstats_version", I32, CDECL)
```

C metni döndüren fonksiyon:

```uxbasic
s = CALL(DLL, "ornek.dll", "ornek_version_text", STRPTR, CDECL)
```

`PTR`, opak nesne/handle adresidir. `STRPTR`, sıfırla sonlanan C metnidir; ikisi aynı anlamda kullanılmaz.

## 2. CALL(API)

`CALL(API,...)` genel JSON/HTTP/yapay zekâ servis yönlendiricisi değildir. İlk metin DLL adı, ikinci metin sembol ve üçüncü token dönüş imzasıdır. Nokta bulunmayan DLL adına `.dll` eklenir ve CDECL yolu kullanılır.

## 3. Wrapper denetimi

```powershell
python tools\library_tools\uxb_library_abi.py --root .
```

Denetçi:

- C header/source prototiplerini çıkarır;
- wrapper sembolünü gerçek prototiple eşleştirir;
- `const char*` dönüşünü `STRPTR`, diğer pointer dönüşlerini `PTR` kabul eder;
- dönüş tipini, parametre sayısını, sırasını ve türünü karşılaştırır;
- gerekli ABI token listesini üretir;
- 10 parametre sınırını zorlar.

`--fix` mevcut wrapperları kanonik biçime dönüştürür. Normal build sırasında otomatik düzeltme yapılmaz; uyuşmazlık build'i durdurur.

## 4. Interpreter köprüsü

`uxffi.dll`, libffi kullanarak 0–10 parametreli karışık Windows x64 çağrıyı ortak bir sözleşmeden yürütür. Export sözleşmesi:

```text
uxffi_version
uxffi_invoke10
uxffi_copy_string
uxffi_release_handle
uxffi_clear_handles
uxffi_shutdown
```

AST ve MIR interpreter aynı köprüyü kullanır. Bu, iki interpreterın farklı DLL çağrı kuralları üretmesini engeller.

## 5. Pointer tokenı

AST interpreterın eski değer modeli gerçek 64-bit adresi güvenli biçimde taşıyamadığı için `uxffi.dll`, native `PTR` dönüşlerini 31-bit etiketli handle tokenına çevirir. Sonraki `PTR` parametresinde token tekrar gerçek native pointera çözülür. `_free`, `_destroy` veya `_release` ile biten fonksiyonlar çağrıldığında tüketilen token temizlenir.

MIR interpreter da AST ile aynı token sözleşmesini kullanır; böylece aynı wrapper iki interpreterda aynı handle değerini taşır.

x64 derlenmiş program bu token sistemini kullanmaz; gerçek native pointerı doğrudan taşır.

## 6. STRPTR dönüşü

`STRPTR` dönüşünde köprü native pointerı etiketli token olarak kısa süre tutar. Interpreter `uxffi_copy_string` exportuyla metni kendi STRING değerine kopyalar ve token kaydını serbest bırakır. Böylece:

- 64-bit pointer 32-bit AST değer alanına zorla sığdırılmaz;
- DLL'in statik veya geçici C metni güvenli biçimde kopyalanır;
- wrapper `FUNCTION ... AS STRING` gerçekten STRING üretir.

## 7. I64/U64 sınırı

Parser, wrapper, MIR değer modeli ve native x64 ABI I64/U64 imzalarını kabul eder. Eski AST `ExecValue` yapısında ayrı 64-bit tamsayı alanı olmadığı için saf 64-bit sayısal dönüşün tamamının AST interpreter içinde korunması henüz garanti edilmez. Pointer dönüşleri tokenla, F64 yan kanalla ve STRPTR metin kopyasıyla güvenlidir. x64 kod üretiminde 64-bit RAX değeri korunur.

## 8. Microsoft x64 çağrı kuralı

x64 codegen:

- ilk dört konumu RCX/RDX/R8/R9 ve karşılık gelen XMM0–XMM3 alanlarına hazırlar;
- 32-byte shadow space ayırır;
- 5–10. argümanları stack'e sekizer baytlık slotlarla yazar;
- `CALL` öncesinde RSP'yi 16-byte hizalar;
- F64 argümanlarının ham 64-bit bit örüntüsünü korur.

ABI10 smoke testi 10 tamsayı parametresi, 8 karışık I32/F64 parametresi, PTR handle akışı ve STRPTR dönüşünü AST, MIR ve x64 hedeflerinde sınar.
