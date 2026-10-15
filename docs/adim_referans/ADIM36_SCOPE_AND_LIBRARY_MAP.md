# ADIM36 — Kapsam ve Library Haritası

Bu paket geniş test yazar; runtime kütüphane DLL’lerini üretmez. Kütüphane testlerinde amaç önce parser/AST/semantic/MIR route’un varlığını görmek, sonra DLL doctor/build adımıyla gerçek native runtime desteğini doğrulamaktır.

## Kütüphane aileleri

| Aile | Test dosyaları | Beklenen ilk doğrulama |
|---|---|---|
| uxmath/uxmathcore | `33_science_math_dll_routes.bas` | DECLARE LIB ALIAS + CALL(DLL) parse/AST/MIR |
| uxstats/uxstats2 | `34_stats_dll_routes.bas` | route + native-only web diagnostic |
| uxmatrix/uxtensor | `35_matrix_dll_routes.bas`, `36_tensor_nn_routes.bas` | pointer parametreli DLL route |
| uxnn/uxnn2/uxnn3 | `36_tensor_nn_routes.bas` | NN forward route |
| uxonnx/uxonnx2 | `37_llama_onnx_routes.bas` | external model route |
| uxllama | `37_llama_onnx_routes.bas` | LLM route |
| bigfp/bigi | `26..30_big*.bas` | BIGINIT, BIGF/BIGD/BALL/BIGI/BIGINT canonical |

## Native-only kuralı

DLL/API, IMPORT(C/CPP/ASM), raw native memory gibi yüzeyler JS/WASM’da sessiz geçmeyecek. Negatif testler bunu kontrol eder.
