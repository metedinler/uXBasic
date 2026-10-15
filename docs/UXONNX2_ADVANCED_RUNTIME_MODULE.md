# UXONNX2 Advanced Runtime Module

Amaç: uXBasic içinde hazır ONNX modellerini daha esnek ve güvenli çalıştırmak.

## Temel farklar

- Multi-input / multi-output run builder.
- F32, F64, I64, I32, STRING tensor handle desteği.
- Model input/output name, dtype, rank, dim sorgusu.
- CPU, DirectML, CUDA provider seçimi; provider sembolü yoksa açık hata/fallback.
- `LoadLibrary/GetProcAddress` ile dinamik yükleme; MSVC import-lib zorunluluğu azaltılır.
- Güvenli handle magic sistemi.
- Dış bağımlılık registry dosyaları.

## Kurulum

```bat
uxb\runtime_ext\uxonnx2\fetch_uxonnx2_deps.bat
uxb\compiler\scripts\run_uxonnx2_smoke.bat
```

## uXBasic kullanım

```basic
INCLUDE "libs/uxonnx2/uxonnx2.bas"

ok = uxonnx2.Init("uxb\\dist\\runtime_ext\\deps\\uxonnx2")
s = uxonnx2.SessionCreateAdvanced("model.onnx", uxonnx2.PROVIDER_CPU, 1, 0, uxonnx2.GRAPH_EXTENDED)

x = uxonnx2.TensorCreate2D(uxonnx2.DTYPE_F32, 1, 4)
uxonnx2.TensorSetF64(x, 0, 1.0)

r = uxonnx2.RunCreate(s)
uxonnx2.RunAddInput(r, uxonnx2.InputName(s,0), x)
uxonnx2.RunAddOutput(r, uxonnx2.OutputName(s,0))
res = uxonnx2.RunExecute(r)
out = uxonnx2.ResultTensor(res, 0)
PRINT uxonnx2.TensorGetF64(out, 0)
```

## Dürüst sınır

String tensor yolu C API üzerinden eklendi; modelden modele string shape ve tokenizer gereksinimi değişebilir. GPU provider için doğru ONNX Runtime paketi ve üretici GPU runtime'ları gerekir.
