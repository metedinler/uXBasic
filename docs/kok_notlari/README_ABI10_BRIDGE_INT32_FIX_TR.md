# UXB ABI10 Bridge Int32 Fix — 2026-07-05

Bu yama ABI10 smoke zincirinde semantic/type katmanları geçildikten sonra görülen şu runtime hatasını hedefler:

```text
FFI x64 invoke report-only: exec: ABI10 invoke failed: invalid argument kind
ASSERT(1002) ASSERT failed
```

Kök neden: `uxffi_invoke10` C ABI tarafında `const int *arg_kinds` bekler. FreeBASIC köprüsünde `argKinds` dizisi `Integer` olarak tutuluyordu. x64 FreeBASIC tarafında `Integer` platform/native genişliğine bağlı davranabildiğinden C tarafı arg-kind dizisini 32-bit `int[]` olarak okurken yanlış hizalanmış değer görebilir. Bunun sonucu ikinci/sonraki arg-kind alanları `0`/VOID gibi algılanır ve `uxffi.c` "invalid argument kind" döndürür.

Değiştirilen dosya:

```text
src/runtime/exec/exec_ffi_bridge10.fbs
```

Yapılan değişiklik:

- `uxffi_invoke10` function-pointer imzasında C `int` karşılıkları `Long` yapıldı.
- `argKinds` dizisi `Long(0 To 9)` yapıldı.
- `ExecFfiBridge10Kind` çıkışı `Long` yapıldı.
- `returnKind`, `argCount`, `errorCapacity` gibi C `int` alanları `Long` ile hizalandı.

Önceki düzeltmeler korunur; semantic/type/runner dosyalarına dokunulmaz.
