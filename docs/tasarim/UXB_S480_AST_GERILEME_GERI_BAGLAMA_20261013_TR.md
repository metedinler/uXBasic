# UXB S-480 AST gerileme geri bağlama ve çalışma zamanı sınırları

**Tarih:** 2026-10-13  
**Sahip:** Codex  
**Durum:** Uygulandı ve odak testleriyle doğrulandı

## Amaç

2026-10-13 tarihli kılavuz ölçümünde, `S-479` derleme onarımı sonrasında AST
yorumlayıcısının eski çalışma zamanı davranışlarından ayrıldığı görüldü. Sorun
tek bir belirti değildi: dizi çözümleme, sayısal dönüşüm, döngü kontrolü,
değişken kapasitesi ve DLL tutamaçlarının FFI'ye geri verilmesi farklı kod
yollarında bozulmuştu. Bu belge, kaynakta yapılan dar düzelteleri ve gerçek
çalıştırma kanıtını kaydeder.

## Uygulanan düzeltmeler

### A-C: dizi erişimi ve sayısal dönüşüm

- `ExecTryResolveArrayAccess` başarısızlıkta çıktı indislerini `-1` ile
  başlatır; tek boyutlu ve çok boyutlu erişimi aynı doğrulama kapısından geçirir.
- Çok boyutlu erişim `ExecResolveFlatArrayIndex` ile düzleştirilir; boş veya
  geçersiz indeks başarı gibi taşınmaz.
- AST `I32(FLOAT)` dönüşümü yuvarlama yerine sıfıra doğru keser.

Kaynak: `src/runtime/exec/exec_state_value_utils.fbs`.

### D: `CONTINUE`

`ExecConsumeLoopExit`, eşleşen döngü için `CONTINUE:<kind>` isteğini tüketir,
gövdenin kalanını atlar ve döngünün artırım/son koşulu adımına devam eder.
Eşleşmeyen çıkış isteği açık hata olarak kalır.

Kaynak: `src/runtime/exec/exec_ffi_runtime.fbs`.

### E: değişken kapasitesi

AST çalışma zamanı sıradan değişken yuvalarını 256'dan 1024'e çıkarır. Kapasite
aşıldığında negatif indisle dizi erişimi veya ham FreeBASIC çalışma zamanı
hatası oluşmaz; `variable storage capacity exceeded (max 1024)` tanısı verilir.
Slot tablolarının 256 elemanlı ayrı sınırı değiştirilmemiştir.

Kaynaklar: `src/runtime/exec/exec_types.fbs`,
`src/runtime/exec/exec_state_value_utils.fbs`, `src/runtime/memory_exec.fbs`.

### F: DLL tutamaçlarının geri geçirilmesi

AST FFI marshalling yolu `U64_PTR` ve `I64_VALUE` iç temsillerini `PTR`, `I64`,
`U64` ve `U32` parametrelerinde kabul eder. Bu, DLL'den dönen opak tutamacın
aynı DLL ailesine geri verilmesini sağlar; geçersiz tipler yine açık tanıyla
reddedilir.

Kaynak: `src/runtime/exec/exec_ffi_runtime.fbs`.

## Kanıt

- `tests/diagnostics/run_s480_ast_regression_tests.ps1`: **8/8 PASS**
  (çok boyutlu AST/MIR/MIR-x64/JS ve `I32` kesme AST/MIR/MIR-x64/JS).
- `tests/array_params/run_array_param_tests.ps1`: **63/63 PASS**.
- `tests/compiler_consolidation/continue_loops.uxb`: AST ve MIR gerçek
  yürütmede aynı çıktı ile geçti.
- 257 `DIM` içeren program: başarıyla çalıştı ve `257` yazdı.
- 1025 `DIM` içeren program: ham runtime çökmesi olmadan kapasite tanısıyla
  reddedildi.
- `uxcollections.ListNew` sonucunu `ListPushI64` içine geri veren PTR testi:
  AST'de çalıştı; yalnız mevcut FFI allowlist kapsamı dışı olduğu için rapor
  amaçlı uyarı verdi.
- `build_64.ps1 -Force`: başarılı.

## Kapsam ve açık sınır

Bu belge tam 1688/1837 vakalık külliyatın yeniden ölçüldüğünü iddia etmez.
Kılavuzdaki eski S-480 tablosu tarihsel ölçüm snapshot'ı olarak korunur;
güncel kapanış kanıtı yukarıdaki odak testleridir. WASM F32/F64 parity'si ve
S-481 sonrası tasarım hedefleri ayrı halkalardır.

