# S-050 native x64 struct-array düzeltmesi

Tarih: 2026-09-14

## Kapsam

Native x64 MIR backend artık statik sınırlı `DIM dizi(...) AS TYPE` bildirimlerini ve `dizi(indeks).Alan` okuma/yazmalarını destekliyor. Struct eleman boyutu TypeLayout üzerinden DIM aşamasından x64 emitter'a taşınıyor; alan ofseti ve genişliği MIR operandlarına taşınıyor.

## Değişiklikler

- `MIR_ARRAY_FIELD_LOAD` ve `MIR_ARRAY_FIELD_STORE` için x64 emitter rotaları eklendi.
- x64 opcode capability/route kayıtları güncellendi.
- Struct array DIM için gerçek eleman boyutu kullanılıyor; primitive-only `unsupported array element type` yolu kaldırıldı.
- Alan erişimlerinde TypeLayout ofseti ve alan genişliği doğrulanıyor.
- Derleme sırasında ortaya çıkan ileri bildirim eksikliği (`ExecRunVirtualStmt`) giderildi.

## Doğrulama

Fixture: `tests/coordination_20260914_s050_struct_array.uxb`

Native x64 build: başarılı (`reports/coordination_20260914/s050_native_final6/probe/exe/x64_build/program.exe`)

Native çıktı:

```text
10
20
30
30
3
6
9
```

Interpreter/MIR çalıştırması aynı çıktıyı verdi ve başarıyla tamamlandı.
