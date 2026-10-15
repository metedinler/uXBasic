# Dış Kütüphane Örnekleri ve Kalite Kapısı

## 27.07.2026 doğrulama matrisi

- Native ve interpreter ABI10 pointer/string round-trip: AST, MIR ve x64 AST/MIR.
- QuickJS native smoke ve compiler-generated JavaScript E2E.
- Wasmtime native smoke, browser WebAssembly köprüsü, AST/MIR wrapper ve compiler-generated WASM E2E.
- FFI policy: report-only allow/deny kaydı; strict deny, hash uyuşmazlığı, imza uyuşmazlığı ve gerçek imzalı Windows DLL strict allow.
- AST sözleşmesi: 144 düğüm, sıfır blocker.

Kitaptaki çalıştırılabilir örnekler dağıtım paketinde `examples/` altında konu başına ayrı klasörlerde verilir.

Dış kütüphane örnekleri uzun REM açıklamalarıyla yazılır. Bunun nedeni satır sayısı doldurmak değildir. Dış kütüphane çağrısında yeni başlayan programcı yalnız fonksiyon adını değil, handle yaşam döngüsünü, pointer tehlikesini, dosya yolunu, DLL arama düzenini, AST/MIR/backend ayrımını ve temizlik adımını da görmelidir.

Her modül için beş örnek üretilir:

1. Kurulum, sürüm ve çalışma yolu denetimi.
2. Handle oluşturma, veri doldurma ve okuma.
3. Ölçüm, hesaplama veya analiz akışı.
4. Dosya, çıktı veya rapor üretimi.
5. Hata kontrolü, temizlik ve başka modülle birleşme.

Bu örnekler `docs_examples/external_libraries` altında ayrı `.uxb` dosyalarıdır. Amaçları, her modülü küçük bir proje gibi anlatmaktır. Örnekler çalışma ortamında DLL bulunmadığında runtime hatası verebilir; bu durumda syntax ve katman çıktısı yine belge için değerlidir, DLL tamamlandığında aynı örnekler gerçek çağrıya dönüşür.

| Modül | Örnek klasörü | Örnek sayısı |
|---|---|---:|
| `uxaimath` | `docs_examples/external_libraries/uxaimath` | 5 |
| `uxcollections` | `docs_examples/external_libraries/uxcollections` | 5 |
| `uxdataframe` | `docs_examples/external_libraries/uxdataframe` | 5 |
| `uxdataset` | `docs_examples/external_libraries/uxdataset` | 5 |
| `uxgraph` | `docs_examples/external_libraries/uxgraph` | 5 |
| `uxllama` | `docs_examples/external_libraries/uxllama` | 5 |
| `uxllamax_placeholder` | `docs_examples/external_libraries/uxllamax_placeholder` | 5 |
| `uxmath` | `docs_examples/external_libraries/uxmath` | 5 |
| `uxmathcore` | `docs_examples/external_libraries/uxmathcore` | 5 |
| `uxmatrix` | `docs_examples/external_libraries/uxmatrix` | 5 |
| `uxnn` | `docs_examples/external_libraries/uxnn` | 5 |
| `uxnn2` | `docs_examples/external_libraries/uxnn2` | 5 |
| `uxnn3` | `docs_examples/external_libraries/uxnn3` | 5 |
| `uxonnx` | `docs_examples/external_libraries/uxonnx` | 5 |
| `uxonnx2` | `docs_examples/external_libraries/uxonnx2` | 5 |
| `uxstats` | `docs_examples/external_libraries/uxstats` | 5 |
| `uxstats2` | `docs_examples/external_libraries/uxstats2` | 5 |
| `uxtensor` | `docs_examples/external_libraries/uxtensor` | 5 |
