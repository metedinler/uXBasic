# UXB S-503: F32 saklama siniri ve dizi paritysi

## Karar

Bir deger `F32` degiskenine DIM baslangici, normal atama veya F32 dizi
elemani saklamasi ile girdiginde tek duyarlikta yuvarlanir. Yazdirma da scalar
F32 ile ayni yedi anlamli hane kuralini kullanir.

## Kok neden

AST DIM baslangicinda declared-type uygulamasi atama yolu kadar erken
calismiyordu. Interpreter heap F32 hucreleri ham byte yaziyor, JS dizi yolu
F32 metadata'sini kaybediyor ve canonical MIR array load/store kayitlarinda
element metadata'si eksik kaliyordu.

## Uygulama

- `runtime/exec/memory_exec.fbs`: DIM baslangic degeri declared type sinirindan
  geciriliyor.
- `interpreter/common/interp_heap.fbs`: F32 heap okuma/yazmasi F32 olarak
  uygulanmis degeri tasiyor.
- `codegen/js/js_stmt_emit.fbs`: F32 array load/store `Math.fround` ile
  sinirlaniyor.
- `semantic/mir_lower_expr.fbs` ve statement lowering dosyalari: indexed
  load/store metadata'si element turu ile damgalaniyor.
- `codegen/x64/mir_x64_arrays.fbs`, `mir_x64_context.fbs` ve
  `mir_x64_fp64.fbs`: MIR-x64 F32 indexed-load sonucu fiziksel olarak 8-byte
  XMM yuvasinda tutulurken mantiksal F32 turu korunuyor. `isFloatWide` bayragi
  okuma/yazma genisligini ayiriyor.

## Kanit

Fixture: `tests/diagnostics/s503_f32_storage.uxb`

`run_s503_f32_storage_tests.ps1` sonucu: **5/5 PASS**

| Yuzey | Sonuc |
|---|---|
| AST | PASS |
| Canonical MIR | PASS |
| MIR-x64 | PASS |
| AST-x64 | PASS |
| JS | PASS |

