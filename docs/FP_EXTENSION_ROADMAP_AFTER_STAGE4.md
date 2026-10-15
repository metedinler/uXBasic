# Stage-4 Sonrası Floating Point Genişletme Roadmap'i

Bu belge Stage-4 workspace temizliğinden sonra uygulanacak floating point planını sabitler.

## Ana karar

F80 kaldırılmayacak. Mevcut F80 iskeleti korunacak; ancak F80 aritmetiği doğrudan x87 inline backend'e yüklenmeyecek. Önce external floating runtime mimarisi kurulacak.

Önerilen tip yüzeyi:

```text
F32        native
F64        native
F80        fixed-high, external/native hybrid
F128       external fixed-high
BIGF       external arbitrary precision binary floating point
BIGD       external arbitrary precision decimal floating point
BALL       external interval/ball arithmetic, ileri aşama
```

## Syntax kararı

Temel kullanım:

```basic
DIM A AS F80
DIM B AS F80
DIM C AS F80

A = 1.25
B = 2.50
C = A + B
PRINT C
```

Uzun yüksek hassasiyetli literal için `{...}` ham numeric literal kabul edilir:

```basic
DIM X AS BIGF(256)
X = {3.1415926535897932384626433832795028841971}
```

`"..."` stringtir; sayı değildir. Ancak explicit conversion/constructor istenirse kullanılabilir:

```basic
X = BIGF("3.1415")
```

Bu zorunlu ana syntax olmayacaktır.

## FP-1: External FP Policy Katmanı

Yeni merkez dosyalar:

```text
src/semantic/extfp_type_policy.fbs
src/runtime/extfp_runtime_registry.fbs
src/codegen/x64/x64_extfp_call_emit.fbs
```

Amaç:

```text
UXBIsExternalFloatType(typeName)
UXBExternalFloatStorageBytes(typeName)
UXBExternalFloatRuntimeFamily(typeName)
UXBPromoteNumericTypes(leftType, rightType)
```

Bu katman önce sadece F80 için aktif edilir.

## FP-2: F80 External Runtime Proof

F80 için FreeBASIC DLL veya doğrudan linklenen runtime fonksiyonları denenir.

Fonksiyon ailesi:

```text
uxb_f80_size()
uxb_f80_from_str(src, out)
uxb_f80_to_str(value, buffer, buffer_len)
uxb_f80_add(a, b, out)
uxb_f80_sub(a, b, out)
uxb_f80_mul(a, b, out)
uxb_f80_div(a, b, out)
uxb_f80_cmp(a, b)
```

Altın ABI kuralı:

```text
F80/F128 değerleri register ile return edilmez.
Her işlem pointer üzerinden yapılır.
```

## FP-3: F80 Codegen Entegrasyonu

Şu örnek resmi smoke test yapılır:

```basic
DIM A AS F80
DIM B AS F80
DIM C AS F80
A = 1.25
B = 2.50
C = A + B
PRINT C
```

Beklenen lowering:

```text
A = 1.25     -> uxb_f80_from_str/raw literal conversion veya native tword copy
B = 2.50     -> aynı
C = A + B    -> uxb_f80_add(&A, &B, &C)
PRINT C      -> uxb_f80_to_str(&C, buffer)
```

## FP-4: F128 Fixed Runtime

F128 için native x87/SSE beklenmez. External runtime aile kullanılır.

```text
DIM Q AS F128
Q = {1.0000000000000000000000000000000001}
PRINT Q
```

F128 storage başlangıçta 16 byte slot olarak kabul edilir. Platform/compiler farkları runtime self-test ile raporlanır.

## FP-5: BIGF / BIGD / Promotion Matrix

BIGF ve BIGD handle/object tipi olarak düşünülür.

```basic
DIM X AS BIGF(256)
DIM Y AS BIGD(80)
```

Karışık aritmetik kuralları:

```text
BIGF op integer -> BIGF
BIGD op integer -> BIGD
F128 op integer -> F128
F80  op integer -> F80
F64  op integer -> F64

BIGF op F64/F80/F128 -> BIGF
BIGD op binary-float -> explicit cast önerilir
BIGF op BIGD -> explicit cast zorunlu
```

Bu aşamada `TO_BIGF()`, `TO_BIGD()`, `TO_F128()` gibi açık dönüşüm fonksiyonları tasarlanır.

## BALL ileri aşama

BALL/interval arithmetic şimdilik FP-5 sonrasına bırakılır. Önce F80, F128, BIGF, BIGD hattı oturtulur.
