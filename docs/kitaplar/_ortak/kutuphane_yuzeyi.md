# uXBasic kütüphane yüzeyi (libsx) — kaynaktan otomatik tarama

`tools/kitap/yuzey_tara.py` üretir. **Testte** = fonksiyonun tam adı (`namespace.Ad`) `tests/` ya da `examples/` altındaki bir programda geçiyor.

Toplam: **46 kütüphane, 2422 fonksiyon/sub, 539 sabit**; testte çağrılan: **1682**

| Kütüphane | Namespace | Fonksiyon | Sub | Sabit | Testte çağrılan |
|---|---|---|---|---|---|
| uxaimath | uxaimath | 16 | 30 | 1 | 45/46 |
| uxarchive | uxarchive | 8 | 0 | 0 | 6/8 |
| uxcapi | uxcapi | 101 | 7 | 17 | 101/108 |
| uxclazz | uxclazz_support | 5 | 0 | 0 | 0/5 |
| uxclz | uxclz | 39 | 4 | 18 | 13/43 |
| uxcollections | uxcollections | 164 | 46 | 1 | 29/210 |
| uxcompress | uxcompress | 18 | 2 | 0 | 18/20 |
| uxconfig | uxconfig | 15 | 1 | 1 | 14/16 |
| uxcrypto | uxcrypto | 24 | 2 | 0 | 24/26 |
| uxdataframe | uxdataframe | 29 | 2 | 1 | 31/31 |
| uxdataset | uxdataset | 24 | 10 | 5 | 32/34 |
| uxdatetime | uxdatetime | 11 | 1 | 1 | 11/12 |
| uxfs | uxfs | 22 | 1 | 1 | 22/23 |
| uxgraph | uxgraph | 28 | 2 | 1 | 30/30 |
| uxgsl | uxgsl | 230 | 6 | 2 | 50/236 |
| uxhttp | uxhttp | 28 | 2 | 0 | 28/30 |
| uxjson | uxjson | 30 | 2 | 0 | 28/32 |
| uxjsruntime |  | 25 | 0 | 0 | 25/25 |
| uxllama | uxllama | 16 | 1 | 4 | 17/17 |
| uxllamax | uxllamax | 17 | 1 | 4 | 18/18 |
| uxlog | uxlog | 11 | 2 | 1 | 11/13 |
| uxlogic | uxlogic | 17 | 2 | 0 | 13/19 |
| uxmath |  | 42 | 0 | 0 | 42/42 |
| uxmathcore |  | 51 | 0 | 0 | 51/51 |
| uxmatrix | uxmatrix | 33 | 1 | 1 | 33/34 |
| uxnn | uxnn | 21 | 12 | 11 | 32/33 |
| uxnn2 | uxnn2 | 15 | 8 | 14 | 20/23 |
| uxnn3 | uxnn3 | 31 | 2 | 8 | 29/33 |
| uxonnx | uxonnx | 18 | 3 | 1 | 20/21 |
| uxonnx2 | uxonnx2 | 35 | 7 | 14 | 40/42 |
| uxpath | uxpath | 14 | 0 | 1 | 13/14 |
| uxprocess | uxprocess | 11 | 1 | 1 | 11/12 |
| uxpython |  | 20 | 0 | 0 | 20/20 |
| uxraylib | uxraylib | 155 | 195 | 10 | 205/350 |
| uxraylib_s100 | uxraylib | 48 | 52 | 10 | 31/100 |
| uxraylib_s60 | uxraylib | 31 | 29 | 10 | 31/60 |
| uxregex | uxregex | 18 | 2 | 0 | 18/20 |
| uxscalar_module | uxscalar_module | 3 | 0 | 1 | 3/3 |
| uxsdl3 | uxsdl3 | 311 | 23 | 387 | 323/334 |
| uxsqlite | uxsqlite | 36 | 4 | 6 | 38/40 |
| uxstats |  | 83 | 0 | 0 | 69/83 |
| uxsystem | uxsystem | 25 | 0 | 1 | 24/25 |
| uxtensor | uxtensor | 31 | 7 | 4 | 37/38 |
| uxterminal | uxterminal | 7 | 10 | 0 | 2/17 |
| uxuuid | uxuuid | 9 | 0 | 1 | 8/9 |
| uxwasmrt |  | 16 | 0 | 0 | 16/16 |

## uxaimath

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxaimath.Version` | `()` | I32 |  | `libsx/uxaimath/uxaimath.bas:10` |
| `uxaimath.Backend` | `()` | STRING | ✓ | `libsx/uxaimath/uxaimath.bas:14` |
| `uxaimath.Seed` | `(seed AS U64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:18` |
| `uxaimath.Sigmoid` | `(x AS F64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:23` |
| `uxaimath.ReLU` | `(x AS F64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:27` |
| `uxaimath.LeakyReLU` | `(x AS F64, alpha AS F64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:31` |
| `uxaimath.ELU` | `(x AS F64, alpha AS F64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:35` |
| `uxaimath.GELU` | `(x AS F64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:39` |
| `uxaimath.Swish` | `(x AS F64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:43` |
| `uxaimath.Softplus` | `(x AS F64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:47` |
| `uxaimath.ApplySigmoidPtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:52` |
| `uxaimath.ApplyTanhPtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:56` |
| `uxaimath.ApplyReLUPtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:60` |
| `uxaimath.ApplyLeakyReLUPtr` | `(dataPtr AS U64, n AS I64, alpha AS F64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:64` |
| `uxaimath.ApplyELUPtr` | `(dataPtr AS U64, n AS I64, alpha AS F64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:68` |
| `uxaimath.ApplyGELUPtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:72` |
| `uxaimath.ApplySwishPtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:76` |
| `uxaimath.SoftmaxPtr` | `(inputPtr AS U64, outputPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:80` |
| `uxaimath.SoftmaxInPlacePtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:84` |
| `uxaimath.TensorSigmoid` | `(t AS U64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:89` |
| `uxaimath.TensorTanh` | `(t AS U64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:93` |
| `uxaimath.TensorReLU` | `(t AS U64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:97` |
| `uxaimath.TensorLeakyReLU` | `(t AS U64, alpha AS F64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:101` |
| `uxaimath.TensorGELU` | `(t AS U64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:105` |
| `uxaimath.TensorSoftmax` | `(src AS U64, dst AS U64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:109` |
| `uxaimath.MSE` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:114` |
| `uxaimath.MAE` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:118` |
| `uxaimath.Huber` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64, delta AS F64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:122` |
| `uxaimath.BinaryCrossEntropy` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:126` |
| `uxaimath.CategoricalCrossEntropy` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:130` |
| `uxaimath.MSEGrad` | `(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:134` |
| `uxaimath.BCEGrad` | `(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:138` |
| `uxaimath.FillZeros` | `(dataPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:143` |
| `uxaimath.FillOnes` | `(dataPtr AS U64, n AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:147` |
| `uxaimath.FillUniform` | `(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:151` |
| `uxaimath.FillNormal` | `(dataPtr AS U64, n AS I64, mean AS F64, stddev AS F64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:155` |
| `uxaimath.XavierUniform` | `(dataPtr AS U64, n AS I64, fanIn AS I64, fanOut AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:159` |
| `uxaimath.HeUniform` | `(dataPtr AS U64, n AS I64, fanIn AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:163` |
| `uxaimath.ClipValue` | `(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:168` |
| `uxaimath.ClipNorm` | `(dataPtr AS U64, n AS I64, maxNorm AS F64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:172` |
| `uxaimath.SGDUpdate` | `(paramPtr AS U64, gradPtr AS U64, n AS I64, lr AS F64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:176` |
| `uxaimath.MomentumUpdate` | `(paramPtr AS U64, gradPtr AS U64, velocityPtr AS U64, n AS I64, lr AS F64, momentum AS F64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:180` |
| `uxaimath.DenseForward` | `(inputPtr AS U64, weightPtr AS U64, biasPtr AS U64, outputPtr AS U64, inN AS I64, outN AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:185` |
| `uxaimath.DenseBatchForward` | `(xPtr AS U64, weightPtr AS U64, biasPtr AS U64, yPtr AS U64, batch AS I64, inN AS I64, outN AS I64)` |  | ✓ | `libsx/uxaimath/uxaimath.bas:189` |
| `uxaimath.ArgMax` | `(dataPtr AS U64, n AS I64)` | I64 | ✓ | `libsx/uxaimath/uxaimath.bas:194` |
| `uxaimath.BinaryAccuracy` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64, threshold AS F64)` | F64 | ✓ | `libsx/uxaimath/uxaimath.bas:198` |

## uxarchive

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxarchive.Version` | `()` | STRING |  | `libsx/uxarchive/uxarchive.bas:3` |
| `uxarchive.EntryCount` | `(path AS STRING)` | I64 | ✓ | `libsx/uxarchive/uxarchive.bas:7` |
| `uxarchive.ExtractAll` | `(path AS STRING, destination AS STRING)` | I64 | ✓ | `libsx/uxarchive/uxarchive.bas:11` |
| `uxarchive.ErrorText` | `()` | STRING | ✓ | `libsx/uxarchive/uxarchive.bas:15` |
| `uxarchive.Version` | `()` | STRING |  | `libsx/uxarchive/uxarchive_easy.bas:3` |
| `uxarchive.EntryCount` | `(path AS STRING)` | I64 | ✓ | `libsx/uxarchive/uxarchive_easy.bas:7` |
| `uxarchive.ExtractAll` | `(path AS STRING, destination AS STRING)` | I64 | ✓ | `libsx/uxarchive/uxarchive_easy.bas:11` |
| `uxarchive.ErrorText` | `()` | STRING | ✓ | `libsx/uxarchive/uxarchive_easy.bas:15` |

## uxcapi

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxcapi.Version` | `()` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:26` |
| `uxcapi.LastError` | `()` | STRING | ✓ | `libsx/uxcapi/uxcapi.bas:30` |
| `uxcapi.Shutdown` | `()` |  | ✓ | `libsx/uxcapi/uxcapi.bas:34` |
| `uxcapi.SymbolAddress` | `(dllName AS STRING, symbolName AS STRING)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:38` |
| `uxcapi.TypeStructNew` | `()` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:42` |
| `uxcapi.TypeUnionNew` | `(sizeBytes AS U64, alignmentBytes AS U32)` | U64 |  | `libsx/uxcapi/uxcapi.bas:46` |
| `uxcapi.TypeAddField` | `(typeHandle AS U64, fieldKind AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:50` |
| `uxcapi.TypeAddStructField` | `(typeHandle AS U64, fieldTypeHandle AS U64)` | I32 |  | `libsx/uxcapi/uxcapi.bas:54` |
| `uxcapi.TypeAddArrayField` | `(typeHandle AS U64, elementKind AS I32, elementCount AS U64)` | I32 |  | `libsx/uxcapi/uxcapi.bas:58` |
| `uxcapi.TypeAddStructArrayField` | `(typeHandle AS U64, fieldTypeHandle AS U64, elementCount AS U64)` | I32 |  | `libsx/uxcapi/uxcapi.bas:62` |
| `uxcapi.TypeSetExpectedLayout` | `(typeHandle AS U64, sizeBytes AS U64, alignmentBytes AS U32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:66` |
| `uxcapi.TypeFinalize` | `(typeHandle AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:70` |
| `uxcapi.TypeKind` | `(typeHandle AS U64)` | I32 |  | `libsx/uxcapi/uxcapi.bas:74` |
| `uxcapi.TypeSize` | `(typeHandle AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:78` |
| `uxcapi.TypeAlignment` | `(typeHandle AS U64)` | U32 | ✓ | `libsx/uxcapi/uxcapi.bas:82` |
| `uxcapi.TypeFree` | `(typeHandle AS U64)` |  | ✓ | `libsx/uxcapi/uxcapi.bas:86` |
| `uxcapi.CallNew` | `(dllName AS STRING, symbolName AS STRING, returnKind AS I32, isVariadic AS I32, fixedArgumentCount AS I32)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:90` |
| `uxcapi.CallFree` | `(callHandle AS U64)` |  | ✓ | `libsx/uxcapi/uxcapi.bas:94` |
| `uxcapi.CallClearArguments` | `(callHandle AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:98` |
| `uxcapi.CallSetReturnStruct` | `(callHandle AS U64, typeHandle AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:102` |
| `uxcapi.ArgI8` | `(callHandle AS U64, value AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:106` |
| `uxcapi.ArgU8` | `(callHandle AS U64, value AS U32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:109` |
| `uxcapi.ArgI16` | `(callHandle AS U64, value AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:112` |
| `uxcapi.ArgU16` | `(callHandle AS U64, value AS U32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:115` |
| `uxcapi.ArgI32` | `(callHandle AS U64, value AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:118` |
| `uxcapi.ArgU32` | `(callHandle AS U64, value AS U32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:121` |
| `uxcapi.ArgI64` | `(callHandle AS U64, value AS I64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:124` |
| `uxcapi.ArgU64` | `(callHandle AS U64, value AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:127` |
| `uxcapi.ArgF32` | `(callHandle AS U64, value AS F64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:130` |
| `uxcapi.ArgF64` | `(callHandle AS U64, value AS F64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:133` |
| `uxcapi.ArgStruct` | `(callHandle AS U64, typeHandle AS U64, dataPointer AS U64, byteCount AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:136` |
| `uxcapi.ArgPtr` | `(callHandle AS U64, value AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:140` |
| `uxcapi.ArgString` | `(callHandle AS U64, value AS STRING)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:143` |
| `uxcapi.ArgWString` | `(callHandle AS U64, utf8Value AS STRING)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:146` |
| `uxcapi.ArgLongDouble` | `(callHandle AS U64, value AS F64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:149` |
| `uxcapi.CallAppendArgs` | `(callHandle AS U64, argsHandle AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:153` |
| `uxcapi.Invoke` | `(callHandle AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:157` |
| `uxcapi.ResultI32` | `(callHandle AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:161` |
| `uxcapi.ResultU32` | `(callHandle AS U64)` | U32 | ✓ | `libsx/uxcapi/uxcapi.bas:164` |
| `uxcapi.ResultI64` | `(callHandle AS U64)` | I64 | ✓ | `libsx/uxcapi/uxcapi.bas:167` |
| `uxcapi.ResultU64` | `(callHandle AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:170` |
| `uxcapi.ResultF64` | `(callHandle AS U64)` | F64 | ✓ | `libsx/uxcapi/uxcapi.bas:173` |
| `uxcapi.ResultPtr` | `(callHandle AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:176` |
| `uxcapi.ResultString` | `(callHandle AS U64)` | STRING | ✓ | `libsx/uxcapi/uxcapi.bas:179` |
| `uxcapi.ResultStructSize` | `(callHandle AS U64)` | U64 |  | `libsx/uxcapi/uxcapi.bas:182` |
| `uxcapi.ResultStructCopy` | `(callHandle AS U64, targetPointer AS U64, targetCapacity AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:186` |
| `uxcapi.CallError` | `(callHandle AS U64)` | STRING | ✓ | `libsx/uxcapi/uxcapi.bas:190` |
| `uxcapi.ArgsNew` | `()` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:194` |
| `uxcapi.ArgsFree` | `(argsHandle AS U64)` |  | ✓ | `libsx/uxcapi/uxcapi.bas:197` |
| `uxcapi.ArgsClear` | `(argsHandle AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:200` |
| `uxcapi.ArgsAddI8` | `(argsHandle AS U64, value AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:203` |
| `uxcapi.ArgsAddU8` | `(argsHandle AS U64, value AS U32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:206` |
| `uxcapi.ArgsAddI16` | `(argsHandle AS U64, value AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:209` |
| `uxcapi.ArgsAddU16` | `(argsHandle AS U64, value AS U32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:212` |
| `uxcapi.ArgsAddI32` | `(argsHandle AS U64, value AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:215` |
| `uxcapi.ArgsAddU32` | `(argsHandle AS U64, value AS U32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:218` |
| `uxcapi.ArgsAddI64` | `(argsHandle AS U64, value AS I64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:221` |
| `uxcapi.ArgsAddU64` | `(argsHandle AS U64, value AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:224` |
| `uxcapi.ArgsAddF32` | `(argsHandle AS U64, value AS F64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:227` |
| `uxcapi.ArgsAddF64` | `(argsHandle AS U64, value AS F64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:230` |
| `uxcapi.ArgsAddPtr` | `(argsHandle AS U64, value AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:233` |
| `uxcapi.ArgsAddString` | `(argsHandle AS U64, value AS STRING)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:236` |
| `uxcapi.ArgsAddWString` | `(argsHandle AS U64, value AS STRING)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:239` |
| `uxcapi.ArgsAddLongDouble` | `(argsHandle AS U64, value AS F64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:242` |
| `uxcapi.ArgsAddStruct` | `(argsHandle AS U64, typeHandle AS U64, dataPointer AS U64, byteCount AS U64)` | I32 |  | `libsx/uxcapi/uxcapi.bas:246` |
| `uxcapi.MemoryAlloc` | `(byteCount AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:250` |
| `uxcapi.MemoryCalloc` | `(itemCount AS U64, itemSize AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:253` |
| `uxcapi.MemoryRealloc` | `(memory AS U64, byteCount AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:256` |
| `uxcapi.MemoryFree` | `(memory AS U64)` |  | ✓ | `libsx/uxcapi/uxcapi.bas:259` |
| `uxcapi.MemoryZero` | `(memory AS U64, byteCount AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:262` |
| `uxcapi.MemoryCopy` | `(target AS U64, source AS U64, byteCount AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:265` |
| `uxcapi.MemoryWriteI8` | `(memory AS U64, offset AS U64, value AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:269` |
| `uxcapi.MemoryWriteU8` | `(memory AS U64, offset AS U64, value AS U32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:272` |
| `uxcapi.MemoryWriteI16` | `(memory AS U64, offset AS U64, value AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:275` |
| `uxcapi.MemoryWriteU16` | `(memory AS U64, offset AS U64, value AS U32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:278` |
| `uxcapi.MemoryWriteI32` | `(memory AS U64, offset AS U64, value AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:281` |
| `uxcapi.MemoryWriteU32` | `(memory AS U64, offset AS U64, value AS U32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:284` |
| `uxcapi.MemoryWriteI64` | `(memory AS U64, offset AS U64, value AS I64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:287` |
| `uxcapi.MemoryWriteU64` | `(memory AS U64, offset AS U64, value AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:290` |
| `uxcapi.MemoryWriteF32` | `(memory AS U64, offset AS U64, value AS F64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:293` |
| `uxcapi.MemoryWriteF64` | `(memory AS U64, offset AS U64, value AS F64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:296` |
| `uxcapi.MemoryWritePtr` | `(memory AS U64, offset AS U64, value AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:299` |
| `uxcapi.MemoryWriteString` | `(memory AS U64, offset AS U64, value AS STRING, capacity AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:302` |
| `uxcapi.MemoryReadI8` | `(memory AS U64, offset AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:306` |
| `uxcapi.MemoryReadU8` | `(memory AS U64, offset AS U64)` | U32 | ✓ | `libsx/uxcapi/uxcapi.bas:309` |
| `uxcapi.MemoryReadI16` | `(memory AS U64, offset AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:312` |
| `uxcapi.MemoryReadU16` | `(memory AS U64, offset AS U64)` | U32 | ✓ | `libsx/uxcapi/uxcapi.bas:315` |
| `uxcapi.MemoryReadI32` | `(memory AS U64, offset AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:318` |
| `uxcapi.MemoryReadU32` | `(memory AS U64, offset AS U64)` | U32 | ✓ | `libsx/uxcapi/uxcapi.bas:321` |
| `uxcapi.MemoryReadI64` | `(memory AS U64, offset AS U64)` | I64 | ✓ | `libsx/uxcapi/uxcapi.bas:324` |
| `uxcapi.MemoryReadU64` | `(memory AS U64, offset AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:327` |
| `uxcapi.MemoryReadF32` | `(memory AS U64, offset AS U64)` | F64 | ✓ | `libsx/uxcapi/uxcapi.bas:330` |
| `uxcapi.MemoryReadF64` | `(memory AS U64, offset AS U64)` | F64 | ✓ | `libsx/uxcapi/uxcapi.bas:333` |
| `uxcapi.MemoryReadPtr` | `(memory AS U64, offset AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:336` |
| `uxcapi.MemoryReadString` | `(memory AS U64, offset AS U64)` | STRING | ✓ | `libsx/uxcapi/uxcapi.bas:339` |
| `uxcapi.CallbackNew` | `(returnKind AS I32, defaultU64 AS U64, defaultF64 AS F64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:343` |
| `uxcapi.CallbackAddArg` | `(callbackHandle AS U64, argumentKind AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:346` |
| `uxcapi.CallbackBuild` | `(callbackHandle AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:349` |
| `uxcapi.CallbackPointer` | `(callbackHandle AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:352` |
| `uxcapi.CallbackFree` | `(callbackHandle AS U64)` |  | ✓ | `libsx/uxcapi/uxcapi.bas:355` |
| `uxcapi.CallbackPending` | `(callbackHandle AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:358` |
| `uxcapi.CallbackNext` | `(callbackHandle AS U64)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:361` |
| `uxcapi.EventFree` | `(eventHandle AS U64)` |  | ✓ | `libsx/uxcapi/uxcapi.bas:365` |
| `uxcapi.EventArgCount` | `(eventHandle AS U64)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:368` |
| `uxcapi.EventArgKind` | `(eventHandle AS U64, index0 AS I32)` | I32 | ✓ | `libsx/uxcapi/uxcapi.bas:371` |
| `uxcapi.EventArgU64` | `(eventHandle AS U64, index0 AS I32)` | U64 | ✓ | `libsx/uxcapi/uxcapi.bas:374` |
| `uxcapi.EventArgF64` | `(eventHandle AS U64, index0 AS I32)` | F64 | ✓ | `libsx/uxcapi/uxcapi.bas:377` |
| `uxcapi.EventArgString` | `(eventHandle AS U64, index0 AS I32)` | STRING | ✓ | `libsx/uxcapi/uxcapi.bas:380` |

## uxclazz

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxclazz_support.HashCombine` | `(seed AS U64, value AS U64)` | U64 |  | `libsx/uxclazz/uxclazz_support.bas:5` |
| `uxclazz_support.HashI64` | `(value AS I64)` | U64 |  | `libsx/uxclazz/uxclazz_support.bas:9` |
| `uxclazz_support.HashString` | `(value AS STRING)` | U64 |  | `libsx/uxclazz/uxclazz_support.bas:13` |
| `uxclazz_support.EscapeJson` | `(value AS STRING)` | STRING |  | `libsx/uxclazz/uxclazz_support.bas:23` |
| `uxclazz_support.BoolJson` | `(value AS BOOLEAN)` | STRING |  | `libsx/uxclazz/uxclazz_support.bas:47` |

## uxclz

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxclz.Version` | `()` | U32 | ✓ | `libsx/uxclz/uxclz.bas:27` |
| `uxclz.LastError` | `()` | STRING |  | `libsx/uxclz/uxclz.bas:31` |
| `uxclz.ResetRegistry` | `()` | I32 | ✓ | `libsx/uxclz/uxclz.bas:35` |
| `uxclz.TypeRegister` | `(name AS STRING, baseType AS U32, flags AS U32)` | U32 | ✓ | `libsx/uxclz/uxclz.bas:39` |
| `uxclz.TypeAddInterface` | `(typeId AS U32, interfaceId AS U32)` | I32 |  | `libsx/uxclz/uxclz.bas:43` |
| `uxclz.TypeName` | `(typeId AS U32)` | STRING | ✓ | `libsx/uxclz/uxclz.bas:47` |
| `uxclz.TypeIsA` | `(typeId AS U32, expectedType AS U32)` | I32 | ✓ | `libsx/uxclz/uxclz.bas:51` |
| `uxclz.TypeHasInterface` | `(typeId AS U32, interfaceId AS U32)` | I32 |  | `libsx/uxclz/uxclz.bas:55` |
| `uxclz.TypeMetadataJson` | `(typeId AS U32)` | STRING |  | `libsx/uxclz/uxclz.bas:59` |
| `uxclz.RegistryMetadataJson` | `()` | STRING |  | `libsx/uxclz/uxclz.bas:63` |
| `uxclz.MethodRegister` | `(typeId AS U32, methodId AS U32, name AS STRING, functionPointer AS U64)` | I32 |  | `libsx/uxclz/uxclz.bas:67` |
| `uxclz.ObjectWrap` | `(typeId AS U32, payload AS U64, destructorPointer AS U64)` | U64 |  | `libsx/uxclz/uxclz.bas:71` |
| `uxclz.ObjectRetain` | `(handle AS U64)` | I32 |  | `libsx/uxclz/uxclz.bas:75` |
| `uxclz.ObjectRelease` | `(handle AS U64)` | I32 |  | `libsx/uxclz/uxclz.bas:79` |
| `uxclz.ObjectIsValid` | `(handle AS U64)` | I32 |  | `libsx/uxclz/uxclz.bas:83` |
| `uxclz.ObjectType` | `(handle AS U64)` | U32 |  | `libsx/uxclz/uxclz.bas:87` |
| `uxclz.ObjectPayload` | `(handle AS U64)` | U64 |  | `libsx/uxclz/uxclz.bas:91` |
| `uxclz.ObjectQueryInterface` | `(handle AS U64, interfaceId AS U32)` | U64 |  | `libsx/uxclz/uxclz.bas:95` |
| `uxclz.ArgsNew` | `()` | U64 | ✓ | `libsx/uxclz/uxclz.bas:99` |
| `uxclz.ArgsFree` | `(argsHandle AS U64)` |  | ✓ | `libsx/uxclz/uxclz.bas:103` |
| `uxclz.ArgsClear` | `(argsHandle AS U64)` |  |  | `libsx/uxclz/uxclz.bas:107` |
| `uxclz.ArgsCount` | `(argsHandle AS U64)` | U32 | ✓ | `libsx/uxclz/uxclz.bas:111` |
| `uxclz.ArgsPushI64` | `(argsHandle AS U64, value AS I64)` | I32 | ✓ | `libsx/uxclz/uxclz.bas:115` |
| `uxclz.ArgsPushU64` | `(argsHandle AS U64, value AS U64)` | I32 |  | `libsx/uxclz/uxclz.bas:119` |
| `uxclz.ArgsPushF64` | `(argsHandle AS U64, value AS F64)` | I32 |  | `libsx/uxclz/uxclz.bas:123` |
| `uxclz.ArgsPushPtr` | `(argsHandle AS U64, value AS U64)` | I32 |  | `libsx/uxclz/uxclz.bas:127` |
| `uxclz.ArgsPushBool` | `(argsHandle AS U64, value AS BOOLEAN)` | I32 |  | `libsx/uxclz/uxclz.bas:131` |
| `uxclz.ArgsPushString` | `(argsHandle AS U64, value AS STRING)` | I32 | ✓ | `libsx/uxclz/uxclz.bas:138` |
| `uxclz.ArgsPushHandle` | `(argsHandle AS U64, value AS U64)` | I32 |  | `libsx/uxclz/uxclz.bas:142` |
| `uxclz.ResultNew` | `()` | U64 | ✓ | `libsx/uxclz/uxclz.bas:146` |
| `uxclz.ResultFree` | `(resultHandle AS U64)` |  | ✓ | `libsx/uxclz/uxclz.bas:150` |
| `uxclz.ResultClear` | `(resultHandle AS U64)` |  |  | `libsx/uxclz/uxclz.bas:154` |
| `uxclz.ResultKind` | `(resultHandle AS U64)` | U32 | ✓ | `libsx/uxclz/uxclz.bas:158` |
| `uxclz.ResultI64` | `(resultHandle AS U64)` | I64 |  | `libsx/uxclz/uxclz.bas:162` |
| `uxclz.ResultU64` | `(resultHandle AS U64)` | U64 |  | `libsx/uxclz/uxclz.bas:166` |
| `uxclz.ResultF64` | `(resultHandle AS U64)` | F64 |  | `libsx/uxclz/uxclz.bas:170` |
| `uxclz.ResultPtr` | `(resultHandle AS U64)` | U64 |  | `libsx/uxclz/uxclz.bas:174` |
| `uxclz.ResultBool` | `(resultHandle AS U64)` | BOOLEAN |  | `libsx/uxclz/uxclz.bas:178` |
| `uxclz.ResultString` | `(resultHandle AS U64)` | STRING |  | `libsx/uxclz/uxclz.bas:182` |
| `uxclz.ResultHandle` | `(resultHandle AS U64)` | U64 |  | `libsx/uxclz/uxclz.bas:186` |
| `uxclz.InvokeArgs` | `(objectHandle AS U64, methodId AS U32, argsHandle AS U64, resultHandle AS U64)` | I32 |  | `libsx/uxclz/uxclz.bas:190` |
| `uxclz.MultimethodRegister` | `(methodId AS U32, leftType AS U32, rightType AS U32, name AS STRING, functionPointer AS U64)` | I32 |  | `libsx/uxclz/uxclz.bas:194` |
| `uxclz.MultimethodInvokeArgs` | `(methodId AS U32, leftHandle AS U64, rightHandle AS U64, argsHandle AS U64, resultHandle AS U64)` | I32 |  | `libsx/uxclz/uxclz.bas:198` |

## uxcollections

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxcollections.Version` | `()` | I32 | ✓ | `libsx/uxcollections/uxcollections.bas:8` |
| `uxcollections.ListNew` | `()` | U64 | ✓ | `libsx/uxcollections/uxcollections.bas:13` |
| `uxcollections.ListFree` | `(h AS U64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:16` |
| `uxcollections.ListCount` | `(h AS U64)` | I64 | ✓ | `libsx/uxcollections/uxcollections.bas:19` |
| `uxcollections.ListClear` | `(h AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:22` |
| `uxcollections.ListPushI64` | `(h AS U64, x AS I64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:25` |
| `uxcollections.ListPushF64` | `(h AS U64, x AS F64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:28` |
| `uxcollections.ListPushStr` | `(h AS U64, s AS STRING)` |  |  | `libsx/uxcollections/uxcollections.bas:31` |
| `uxcollections.ListRemoveAt` | `(h AS U64, idx AS I64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:34` |
| `uxcollections.ListGetI64` | `(h AS U64, idx AS I64)` | I64 | ✓ | `libsx/uxcollections/uxcollections.bas:37` |
| `uxcollections.ListGetF64` | `(h AS U64, idx AS I64)` | F64 | ✓ | `libsx/uxcollections/uxcollections.bas:40` |
| `uxcollections.ListGetStr` | `(h AS U64, idx AS I64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:43` |
| `uxcollections.ListSetI64` | `(h AS U64, idx AS I64, x AS I64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:46` |
| `uxcollections.ListSetF64` | `(h AS U64, idx AS I64, x AS F64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:49` |
| `uxcollections.ListSetStr` | `(h AS U64, idx AS I64, s AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:52` |
| `uxcollections.ListGetKind` | `(h AS U64, idx AS I64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:56` |
| `uxcollections.ListSort` | `(h AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:61` |
| `uxcollections.ListSortAlpha` | `(h AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:64` |
| `uxcollections.ListReverse` | `(h AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:67` |
| `uxcollections.ListSum` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:72` |
| `uxcollections.ListAverage` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:75` |
| `uxcollections.ListMin` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:78` |
| `uxcollections.ListMax` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:81` |
| `uxcollections.ListRange` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:84` |
| `uxcollections.ListMedian` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:87` |
| `uxcollections.ListPercentile` | `(h AS U64, p AS F64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:90` |
| `uxcollections.ListVariance` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:93` |
| `uxcollections.ListStdDev` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:96` |
| `uxcollections.ListStdErr` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:99` |
| `uxcollections.ListMode` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:102` |
| `uxcollections.ListJoin` | `(h AS U64, sep AS STRING)` | STRING |  | `libsx/uxcollections/uxcollections.bas:107` |
| `uxcollections.ListSplitToList` | `(text AS STRING, sep AS STRING)` | U64 |  | `libsx/uxcollections/uxcollections.bas:110` |
| `uxcollections.ListToUpper` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:113` |
| `uxcollections.ListToLower` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:116` |
| `uxcollections.ListCapitalize` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:119` |
| `uxcollections.ListTrim` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:122` |
| `uxcollections.ListFilterByPrefix` | `(h AS U64, prefix AS STRING)` | U64 |  | `libsx/uxcollections/uxcollections.bas:125` |
| `uxcollections.ListFilterBySuffix` | `(h AS U64, suffix AS STRING)` | U64 |  | `libsx/uxcollections/uxcollections.bas:128` |
| `uxcollections.ListFilterContains` | `(h AS U64, needle AS STRING)` | U64 |  | `libsx/uxcollections/uxcollections.bas:131` |
| `uxcollections.ListIndexOfI64` | `(h AS U64, x AS I64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:136` |
| `uxcollections.ListIndexOfF64` | `(h AS U64, x AS F64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:139` |
| `uxcollections.ListIndexOfStr` | `(h AS U64, s AS STRING)` | I64 |  | `libsx/uxcollections/uxcollections.bas:142` |
| `uxcollections.ListContainsI64` | `(h AS U64, x AS I64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:145` |
| `uxcollections.ListContainsF64` | `(h AS U64, x AS F64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:148` |
| `uxcollections.ListContainsStr` | `(h AS U64, s AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:151` |
| `uxcollections.ListCountValueI64` | `(h AS U64, x AS I64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:154` |
| `uxcollections.ListCountValueF64` | `(h AS U64, x AS F64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:157` |
| `uxcollections.ListCountValueStr` | `(h AS U64, s AS STRING)` | I64 |  | `libsx/uxcollections/uxcollections.bas:160` |
| `uxcollections.ListSlice` | `(h AS U64, startIdx AS I64, endIdx AS I64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:163` |
| `uxcollections.ListExtend` | `(dstH AS U64, srcH AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:166` |
| `uxcollections.ListInsertAtI64` | `(h AS U64, idx AS I64, x AS I64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:169` |
| `uxcollections.ListInsertAtF64` | `(h AS U64, idx AS I64, x AS F64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:172` |
| `uxcollections.ListInsertAtStr` | `(h AS U64, idx AS I64, s AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:175` |
| `uxcollections.ListUnique` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:178` |
| `uxcollections.ListClone` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:181` |
| `uxcollections.StackNew` | `()` | U64 | ✓ | `libsx/uxcollections/uxcollections.bas:186` |
| `uxcollections.StackFree` | `(h AS U64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:189` |
| `uxcollections.StackCount` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:192` |
| `uxcollections.StackPushI64` | `(h AS U64, x AS I64)` |  |  | `libsx/uxcollections/uxcollections.bas:195` |
| `uxcollections.StackPushF64` | `(h AS U64, x AS F64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:198` |
| `uxcollections.StackPushStr` | `(h AS U64, s AS STRING)` |  |  | `libsx/uxcollections/uxcollections.bas:201` |
| `uxcollections.StackPopI64` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:204` |
| `uxcollections.StackPopF64` | `(h AS U64)` | F64 | ✓ | `libsx/uxcollections/uxcollections.bas:207` |
| `uxcollections.StackPopStr` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:210` |
| `uxcollections.StackPeekKind` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:213` |
| `uxcollections.StackPeekI64` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:216` |
| `uxcollections.StackPeekF64` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:219` |
| `uxcollections.StackPeekStr` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:222` |
| `uxcollections.StackIsEmpty` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:225` |
| `uxcollections.StackClear` | `(h AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:228` |
| `uxcollections.StackClone` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:231` |
| `uxcollections.StackContainsI64` | `(h AS U64, x AS I64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:234` |
| `uxcollections.StackContainsF64` | `(h AS U64, x AS F64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:237` |
| `uxcollections.StackContainsStr` | `(h AS U64, s AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:240` |
| `uxcollections.StackToList` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:243` |
| `uxcollections.StackPushRange` | `(h AS U64, listH AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:246` |
| `uxcollections.QueueNew` | `()` | U64 | ✓ | `libsx/uxcollections/uxcollections.bas:251` |
| `uxcollections.QueueFree` | `(h AS U64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:254` |
| `uxcollections.QueueCount` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:257` |
| `uxcollections.QueuePushI64` | `(h AS U64, x AS I64)` |  |  | `libsx/uxcollections/uxcollections.bas:260` |
| `uxcollections.QueuePushF64` | `(h AS U64, x AS F64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:263` |
| `uxcollections.QueuePushStr` | `(h AS U64, s AS STRING)` |  |  | `libsx/uxcollections/uxcollections.bas:266` |
| `uxcollections.QueuePopI64` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:269` |
| `uxcollections.QueuePopF64` | `(h AS U64)` | F64 | ✓ | `libsx/uxcollections/uxcollections.bas:272` |
| `uxcollections.QueuePopStr` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:275` |
| `uxcollections.QueuePeekKind` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:278` |
| `uxcollections.QueuePeekI64` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:281` |
| `uxcollections.QueuePeekF64` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:284` |
| `uxcollections.QueuePeekStr` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:287` |
| `uxcollections.QueueIsEmpty` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:290` |
| `uxcollections.QueueClear` | `(h AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:293` |
| `uxcollections.QueueClone` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:296` |
| `uxcollections.QueueContainsI64` | `(h AS U64, x AS I64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:299` |
| `uxcollections.QueueContainsF64` | `(h AS U64, x AS F64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:302` |
| `uxcollections.QueueContainsStr` | `(h AS U64, s AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:305` |
| `uxcollections.QueueToList` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:308` |
| `uxcollections.QueuePushRange` | `(h AS U64, listH AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:311` |
| `uxcollections.DequeNew` | `()` | U64 |  | `libsx/uxcollections/uxcollections.bas:316` |
| `uxcollections.DequeFree` | `(h AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:319` |
| `uxcollections.DequeCount` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:322` |
| `uxcollections.DequePushFrontI64` | `(h AS U64, x AS I64)` |  |  | `libsx/uxcollections/uxcollections.bas:325` |
| `uxcollections.DequePushBackI64` | `(h AS U64, x AS I64)` |  |  | `libsx/uxcollections/uxcollections.bas:328` |
| `uxcollections.DequePushFrontF64` | `(h AS U64, x AS F64)` |  |  | `libsx/uxcollections/uxcollections.bas:331` |
| `uxcollections.DequePushBackF64` | `(h AS U64, x AS F64)` |  |  | `libsx/uxcollections/uxcollections.bas:334` |
| `uxcollections.DequePushFrontStr` | `(h AS U64, s AS STRING)` |  |  | `libsx/uxcollections/uxcollections.bas:337` |
| `uxcollections.DequePushBackStr` | `(h AS U64, s AS STRING)` |  |  | `libsx/uxcollections/uxcollections.bas:340` |
| `uxcollections.DequePopFrontI64` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:343` |
| `uxcollections.DequePopBackI64` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:346` |
| `uxcollections.DequePopFrontF64` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:349` |
| `uxcollections.DequePopBackF64` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:352` |
| `uxcollections.DequePopFrontStr` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:355` |
| `uxcollections.DequePopBackStr` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:358` |
| `uxcollections.DequePeekFrontKind` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:361` |
| `uxcollections.DequePeekBackKind` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:364` |
| `uxcollections.DequePeekFrontI64` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:367` |
| `uxcollections.DequePeekFrontF64` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:370` |
| `uxcollections.DequePeekFrontStr` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:373` |
| `uxcollections.DequePeekBackI64` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:376` |
| `uxcollections.DequePeekBackF64` | `(h AS U64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:379` |
| `uxcollections.DequePeekBackStr` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:382` |
| `uxcollections.DequeIsEmpty` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:385` |
| `uxcollections.DequeClear` | `(h AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:388` |
| `uxcollections.DequeClone` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:391` |
| `uxcollections.DequeContainsI64` | `(h AS U64, x AS I64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:394` |
| `uxcollections.DequeContainsF64` | `(h AS U64, x AS F64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:397` |
| `uxcollections.DequeContainsStr` | `(h AS U64, s AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:400` |
| `uxcollections.DequeToList` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:403` |
| `uxcollections.DequePushRangeFront` | `(h AS U64, listH AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:406` |
| `uxcollections.DequePushRangeBack` | `(h AS U64, listH AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:409` |
| `uxcollections.DequeRotate` | `(h AS U64, n AS I64)` |  |  | `libsx/uxcollections/uxcollections.bas:412` |
| `uxcollections.DictNew` | `()` | U64 | ✓ | `libsx/uxcollections/uxcollections.bas:417` |
| `uxcollections.DictFree` | `(h AS U64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:420` |
| `uxcollections.DictCount` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:423` |
| `uxcollections.DictSetI64` | `(h AS U64, key AS STRING, x AS I64)` |  |  | `libsx/uxcollections/uxcollections.bas:426` |
| `uxcollections.DictSetF64` | `(h AS U64, key AS STRING, x AS F64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:429` |
| `uxcollections.DictSetStr` | `(h AS U64, key AS STRING, s AS STRING)` |  |  | `libsx/uxcollections/uxcollections.bas:432` |
| `uxcollections.DictHas` | `(h AS U64, key AS STRING)` | I32 | ✓ | `libsx/uxcollections/uxcollections.bas:435` |
| `uxcollections.DictRemove` | `(h AS U64, key AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:438` |
| `uxcollections.DictGetI64` | `(h AS U64, key AS STRING)` | I64 |  | `libsx/uxcollections/uxcollections.bas:441` |
| `uxcollections.DictGetF64` | `(h AS U64, key AS STRING)` | F64 | ✓ | `libsx/uxcollections/uxcollections.bas:444` |
| `uxcollections.DictGetStr` | `(h AS U64, key AS STRING)` | STRING |  | `libsx/uxcollections/uxcollections.bas:447` |
| `uxcollections.DictGetKind` | `(h AS U64, key AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:450` |
| `uxcollections.DictKeyAt` | `(h AS U64, idx AS I64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:454` |
| `uxcollections.DictKeysAsList` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:457` |
| `uxcollections.DictValuesAsList` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:460` |
| `uxcollections.DictGetOrDefaultI64` | `(h AS U64, key AS STRING, defVal AS I64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:463` |
| `uxcollections.DictGetOrDefaultF64` | `(h AS U64, key AS STRING, defVal AS F64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:466` |
| `uxcollections.DictGetOrDefaultStr` | `(h AS U64, key AS STRING, defVal AS STRING)` | STRING |  | `libsx/uxcollections/uxcollections.bas:469` |
| `uxcollections.DictSetDefaultI64` | `(h AS U64, key AS STRING, defVal AS I64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:472` |
| `uxcollections.DictSetDefaultF64` | `(h AS U64, key AS STRING, defVal AS F64)` | F64 |  | `libsx/uxcollections/uxcollections.bas:475` |
| `uxcollections.DictSetDefaultStr` | `(h AS U64, key AS STRING, defVal AS STRING)` | STRING |  | `libsx/uxcollections/uxcollections.bas:478` |
| `uxcollections.DictPopI64` | `(h AS U64, key AS STRING)` | I64 |  | `libsx/uxcollections/uxcollections.bas:481` |
| `uxcollections.DictPopF64` | `(h AS U64, key AS STRING)` | F64 |  | `libsx/uxcollections/uxcollections.bas:484` |
| `uxcollections.DictPopStr` | `(h AS U64, key AS STRING)` | STRING |  | `libsx/uxcollections/uxcollections.bas:487` |
| `uxcollections.DictFirstKey` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:490` |
| `uxcollections.DictLastKey` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:493` |
| `uxcollections.DictPopFirst` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:496` |
| `uxcollections.DictPopLast` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:499` |
| `uxcollections.DictIsEmpty` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:502` |
| `uxcollections.DictContainsValueI64` | `(h AS U64, x AS I64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:505` |
| `uxcollections.DictContainsValueF64` | `(h AS U64, x AS F64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:508` |
| `uxcollections.DictContainsValueStr` | `(h AS U64, s AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:511` |
| `uxcollections.DictClone` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:514` |
| `uxcollections.DictUpdate` | `(dstH AS U64, srcH AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:517` |
| `uxcollections.DictMerge` | `(aH AS U64, bH AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:520` |
| `uxcollections.DictInvert` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:523` |
| `uxcollections.DictEquals` | `(aH AS U64, bH AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:526` |
| `uxcollections.SetNew` | `()` | U64 | ✓ | `libsx/uxcollections/uxcollections.bas:531` |
| `uxcollections.SetFree` | `(h AS U64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:534` |
| `uxcollections.SetCount` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:537` |
| `uxcollections.SetAdd` | `(h AS U64, key AS STRING)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:540` |
| `uxcollections.SetContains` | `(h AS U64, key AS STRING)` | I32 | ✓ | `libsx/uxcollections/uxcollections.bas:543` |
| `uxcollections.SetRemove` | `(h AS U64, key AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:546` |
| `uxcollections.SetKeyAt` | `(h AS U64, idx AS I64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:549` |
| `uxcollections.SetUnion` | `(aH AS U64, bH AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:552` |
| `uxcollections.SetIntersect` | `(aH AS U64, bH AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:555` |
| `uxcollections.SetDifference` | `(aH AS U64, bH AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:558` |
| `uxcollections.SetSymmetricDifference` | `(aH AS U64, bH AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:561` |
| `uxcollections.SetIsSupersetOf` | `(aH AS U64, bH AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:564` |
| `uxcollections.SetIsSubsetOf` | `(aH AS U64, bH AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:567` |
| `uxcollections.SetIsDisjoint` | `(aH AS U64, bH AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:570` |
| `uxcollections.SetEquals` | `(aH AS U64, bH AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:573` |
| `uxcollections.SetIsEmpty` | `(h AS U64)` | I32 |  | `libsx/uxcollections/uxcollections.bas:576` |
| `uxcollections.SetToList` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:579` |
| `uxcollections.SetClone` | `(h AS U64)` | U64 |  | `libsx/uxcollections/uxcollections.bas:582` |
| `uxcollections.SetAddRange` | `(h AS U64, listH AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:585` |
| `uxcollections.SetRemoveRange` | `(h AS U64, listH AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:588` |
| `uxcollections.SetPop` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:591` |
| `uxcollections.TreeNew` | `()` | U64 | ✓ | `libsx/uxcollections/uxcollections.bas:596` |
| `uxcollections.TreeFree` | `(h AS U64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:599` |
| `uxcollections.TreeCount` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:602` |
| `uxcollections.TreeHeight` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:605` |
| `uxcollections.TreeSetI64` | `(h AS U64, key AS STRING, x AS I64)` |  |  | `libsx/uxcollections/uxcollections.bas:608` |
| `uxcollections.TreeSetF64` | `(h AS U64, key AS STRING, x AS F64)` |  | ✓ | `libsx/uxcollections/uxcollections.bas:611` |
| `uxcollections.TreeSetStr` | `(h AS U64, key AS STRING, s AS STRING)` |  |  | `libsx/uxcollections/uxcollections.bas:614` |
| `uxcollections.TreeHas` | `(h AS U64, key AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:617` |
| `uxcollections.TreeGetI64` | `(h AS U64, key AS STRING)` | I64 |  | `libsx/uxcollections/uxcollections.bas:620` |
| `uxcollections.TreeGetF64` | `(h AS U64, key AS STRING)` | F64 | ✓ | `libsx/uxcollections/uxcollections.bas:623` |
| `uxcollections.TreeGetStr` | `(h AS U64, key AS STRING)` | STRING |  | `libsx/uxcollections/uxcollections.bas:626` |
| `uxcollections.TreeGetKind` | `(h AS U64, key AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:629` |
| `uxcollections.TreeRemove` | `(h AS U64, key AS STRING)` | I32 |  | `libsx/uxcollections/uxcollections.bas:632` |
| `uxcollections.NodeNewStr` | `(s AS STRING)` | U64 |  | `libsx/uxcollections/uxcollections.bas:637` |
| `uxcollections.NodeFree` | `(h AS U64)` |  |  | `libsx/uxcollections/uxcollections.bas:640` |
| `uxcollections.NodeAppendChildStr` | `(h AS U64, s AS STRING)` | U64 |  | `libsx/uxcollections/uxcollections.bas:643` |
| `uxcollections.NodeChildCount` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:646` |
| `uxcollections.NodeDepth` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:649` |
| `uxcollections.NodeMaxHeight` | `(h AS U64)` | I64 |  | `libsx/uxcollections/uxcollections.bas:652` |
| `uxcollections.NodeGetStr` | `(h AS U64)` | STRING |  | `libsx/uxcollections/uxcollections.bas:655` |
| `uxcollections.GraphBackendAvailable` | `()` | I32 |  | `libsx/uxcollections/uxcollections.bas:660` |
| `uxcollections.DataframeBackendAvailable` | `()` | I32 |  | `libsx/uxcollections/uxcollections.bas:663` |

## uxcompress

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxcompress.Version` | `()` | STRING |  | `libsx/uxcompress/uxcompress.bas:3` |
| `uxcompress.Compress` | `(sourcePtr AS U64, sourceSize AS U64, level AS I32)` | U64 | ✓ | `libsx/uxcompress/uxcompress.bas:7` |
| `uxcompress.CompressText` | `(sourceText AS STRING, level AS I32)` | U64 | ✓ | `libsx/uxcompress/uxcompress.bas:11` |
| `uxcompress.Decompress` | `(sourcePtr AS U64, sourceSize AS U64, expectedSize AS U64)` | U64 | ✓ | `libsx/uxcompress/uxcompress.bas:15` |
| `uxcompress.BlobData` | `(blob AS U64)` | U64 | ✓ | `libsx/uxcompress/uxcompress.bas:19` |
| `uxcompress.BlobSize` | `(blob AS U64)` | U64 | ✓ | `libsx/uxcompress/uxcompress.bas:23` |
| `uxcompress.BlobFree` | `(blob AS U64)` |  | ✓ | `libsx/uxcompress/uxcompress.bas:27` |
| `uxcompress.CompressFile` | `(sourcePath AS STRING, targetPath AS STRING, level AS I32)` | I32 | ✓ | `libsx/uxcompress/uxcompress.bas:31` |
| `uxcompress.DecompressFile` | `(sourcePath AS STRING, targetPath AS STRING)` | I32 | ✓ | `libsx/uxcompress/uxcompress.bas:35` |
| `uxcompress.ErrorText` | `()` | STRING | ✓ | `libsx/uxcompress/uxcompress.bas:39` |
| `uxcompress.Version` | `()` | STRING |  | `libsx/uxcompress/uxcompress_easy.bas:3` |
| `uxcompress.Compress` | `(sourcePtr AS U64, sourceSize AS U64, level AS I32)` | U64 | ✓ | `libsx/uxcompress/uxcompress_easy.bas:7` |
| `uxcompress.CompressText` | `(sourceText AS STRING, level AS I32)` | U64 | ✓ | `libsx/uxcompress/uxcompress_easy.bas:11` |
| `uxcompress.Decompress` | `(sourcePtr AS U64, sourceSize AS U64, expectedSize AS U64)` | U64 | ✓ | `libsx/uxcompress/uxcompress_easy.bas:15` |
| `uxcompress.BlobData` | `(blob AS U64)` | U64 | ✓ | `libsx/uxcompress/uxcompress_easy.bas:19` |
| `uxcompress.BlobSize` | `(blob AS U64)` | U64 | ✓ | `libsx/uxcompress/uxcompress_easy.bas:23` |
| `uxcompress.BlobFree` | `(blob AS U64)` |  | ✓ | `libsx/uxcompress/uxcompress_easy.bas:27` |
| `uxcompress.CompressFile` | `(sourcePath AS STRING, targetPath AS STRING, level AS I32)` | I32 | ✓ | `libsx/uxcompress/uxcompress_easy.bas:31` |
| `uxcompress.DecompressFile` | `(sourcePath AS STRING, targetPath AS STRING)` | I32 | ✓ | `libsx/uxcompress/uxcompress_easy.bas:35` |
| `uxcompress.ErrorText` | `()` | STRING | ✓ | `libsx/uxcompress/uxcompress_easy.bas:39` |

## uxconfig

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxconfig.Version` | `()` | STRING |  | `libsx/uxconfig/uxconfig.bas:6` |
| `uxconfig.Open` | `(path AS STRING)` | U64 | ✓ | `libsx/uxconfig/uxconfig.bas:10` |
| `uxconfig.Close` | `(handle AS U64)` |  | ✓ | `libsx/uxconfig/uxconfig.bas:14` |
| `uxconfig.GetString` | `(handle AS U64,section AS STRING,key AS STRING,defaultValue AS STRING)` | STRING | ✓ | `libsx/uxconfig/uxconfig.bas:18` |
| `uxconfig.GetI64` | `(handle AS U64,section AS STRING,key AS STRING,defaultValue AS I64)` | I64 | ✓ | `libsx/uxconfig/uxconfig.bas:22` |
| `uxconfig.GetF64` | `(handle AS U64,section AS STRING,key AS STRING,defaultValue AS F64)` | F64 |  | `libsx/uxconfig/uxconfig.bas:26` |
| `uxconfig.GetBoolean` | `(handle AS U64,section AS STRING,key AS STRING,defaultValue AS I32)` | I32 | ✓ | `libsx/uxconfig/uxconfig.bas:30` |
| `uxconfig.SetString` | `(handle AS U64,section AS STRING,key AS STRING,value AS STRING)` | I32 | ✓ | `libsx/uxconfig/uxconfig.bas:34` |
| `uxconfig.SetI64` | `(handle AS U64,section AS STRING,key AS STRING,value AS I64)` | I32 | ✓ | `libsx/uxconfig/uxconfig.bas:38` |
| `uxconfig.SetF64` | `(handle AS U64,section AS STRING,key AS STRING,value AS F64)` | I32 | ✓ | `libsx/uxconfig/uxconfig.bas:42` |
| `uxconfig.SetBoolean` | `(handle AS U64,section AS STRING,key AS STRING,value AS I32)` | I32 | ✓ | `libsx/uxconfig/uxconfig.bas:46` |
| `uxconfig.DeleteKey` | `(handle AS U64,section AS STRING,key AS STRING)` | I32 | ✓ | `libsx/uxconfig/uxconfig.bas:50` |
| `uxconfig.DeleteSection` | `(handle AS U64,section AS STRING)` | I32 | ✓ | `libsx/uxconfig/uxconfig.bas:54` |
| `uxconfig.HasKey` | `(handle AS U64,section AS STRING,key AS STRING)` | I32 | ✓ | `libsx/uxconfig/uxconfig.bas:58` |
| `uxconfig.Path` | `(handle AS U64)` | STRING | ✓ | `libsx/uxconfig/uxconfig.bas:62` |
| `uxconfig.ErrorText` | `()` | STRING | ✓ | `libsx/uxconfig/uxconfig.bas:66` |

## uxcrypto

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxcrypto.Version` | `()` | STRING |  | `libsx/uxcrypto/uxcrypto.bas:3` |
| `uxcrypto.Initialize` | `()` | I32 | ✓ | `libsx/uxcrypto/uxcrypto.bas:7` |
| `uxcrypto.RandomBlob` | `(size AS U64)` | U64 | ✓ | `libsx/uxcrypto/uxcrypto.bas:11` |
| `uxcrypto.BlobData` | `(blob AS U64)` | U64 | ✓ | `libsx/uxcrypto/uxcrypto.bas:15` |
| `uxcrypto.BlobSize` | `(blob AS U64)` | U64 | ✓ | `libsx/uxcrypto/uxcrypto.bas:19` |
| `uxcrypto.BlobFree` | `(blob AS U64)` |  | ✓ | `libsx/uxcrypto/uxcrypto.bas:23` |
| `uxcrypto.Sha256Hex` | `(dataPtr AS U64, size AS U64)` | STRING | ✓ | `libsx/uxcrypto/uxcrypto.bas:27` |
| `uxcrypto.Sha256Text` | `(text AS STRING)` | STRING | ✓ | `libsx/uxcrypto/uxcrypto.bas:31` |
| `uxcrypto.PasswordHash` | `(password AS STRING)` | STRING | ✓ | `libsx/uxcrypto/uxcrypto.bas:35` |
| `uxcrypto.PasswordVerify` | `(encodedHash AS STRING, password AS STRING)` | I32 | ✓ | `libsx/uxcrypto/uxcrypto.bas:39` |
| `uxcrypto.SecretboxEncrypt` | `(messagePtr AS U64, messageSize AS U64, keyPtr AS U64, keySize AS U64)` | U64 | ✓ | `libsx/uxcrypto/uxcrypto.bas:43` |
| `uxcrypto.SecretboxDecrypt` | `(encryptedPtr AS U64, encryptedSize AS U64, keyPtr AS U64, keySize AS U64)` | U64 | ✓ | `libsx/uxcrypto/uxcrypto.bas:47` |
| `uxcrypto.ErrorText` | `()` | STRING | ✓ | `libsx/uxcrypto/uxcrypto.bas:51` |
| `uxcrypto.Version` | `()` | STRING |  | `libsx/uxcrypto/uxcrypto_easy.bas:3` |
| `uxcrypto.Initialize` | `()` | I32 | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:7` |
| `uxcrypto.RandomBlob` | `(size AS U64)` | U64 | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:11` |
| `uxcrypto.BlobData` | `(blob AS U64)` | U64 | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:15` |
| `uxcrypto.BlobSize` | `(blob AS U64)` | U64 | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:19` |
| `uxcrypto.BlobFree` | `(blob AS U64)` |  | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:23` |
| `uxcrypto.Sha256Hex` | `(dataPtr AS U64, size AS U64)` | STRING | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:27` |
| `uxcrypto.Sha256Text` | `(text AS STRING)` | STRING | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:31` |
| `uxcrypto.PasswordHash` | `(password AS STRING)` | STRING | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:35` |
| `uxcrypto.PasswordVerify` | `(encodedHash AS STRING, password AS STRING)` | I32 | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:39` |
| `uxcrypto.SecretboxEncrypt` | `(messagePtr AS U64, messageSize AS U64, keyPtr AS U64, keySize AS U64)` | U64 | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:43` |
| `uxcrypto.SecretboxDecrypt` | `(encryptedPtr AS U64, encryptedSize AS U64, keyPtr AS U64, keySize AS U64)` | U64 | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:47` |
| `uxcrypto.ErrorText` | `()` | STRING | ✓ | `libsx/uxcrypto/uxcrypto_easy.bas:51` |

## uxdataframe

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxdataframe.RuntimeVersion` | `()` | I32 | ✓ | `libsx/uxdataframe/uxdataframe.bas:8` |
| `uxdataframe.DuckDBAvailable` | `()` | I32 | ✓ | `libsx/uxdataframe/uxdataframe.bas:12` |
| `uxdataframe.DuckDBVersion` | `()` | STRING | ✓ | `libsx/uxdataframe/uxdataframe.bas:16` |
| `uxdataframe.LastError` | `(df AS U64)` | STRING | ✓ | `libsx/uxdataframe/uxdataframe.bas:20` |
| `uxdataframe.OpenMemory` | `()` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:24` |
| `uxdataframe.OpenDatabase` | `(path AS STRING)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:28` |
| `uxdataframe.Free` | `(df AS U64)` |  | ✓ | `libsx/uxdataframe/uxdataframe.bas:32` |
| `uxdataframe.LoadCSV` | `(path AS STRING, header AS I32)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:36` |
| `uxdataframe.LoadParquet` | `(path AS STRING)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:40` |
| `uxdataframe.Exec` | `(df AS U64, sql AS STRING)` | I32 | ✓ | `libsx/uxdataframe/uxdataframe.bas:44` |
| `uxdataframe.Query` | `(df AS U64, sql AS STRING)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:48` |
| `uxdataframe.RowCount` | `(df AS U64)` | I64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:52` |
| `uxdataframe.ColCount` | `(df AS U64)` | I32 | ✓ | `libsx/uxdataframe/uxdataframe.bas:56` |
| `uxdataframe.ColName` | `(df AS U64, col AS I32)` | STRING | ✓ | `libsx/uxdataframe/uxdataframe.bas:60` |
| `uxdataframe.GetF64` | `(df AS U64, row AS I64, col AS I32)` | F64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:64` |
| `uxdataframe.GetText` | `(df AS U64, row AS I64, col AS I32)` | STRING | ✓ | `libsx/uxdataframe/uxdataframe.bas:68` |
| `uxdataframe.Head` | `(df AS U64, n AS I64)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:72` |
| `uxdataframe.SelectCols` | `(df AS U64, columns AS STRING)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:76` |
| `uxdataframe.Filter` | `(df AS U64, whereSql AS STRING)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:80` |
| `uxdataframe.OrderBy` | `(df AS U64, orderSql AS STRING)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:84` |
| `uxdataframe.Describe` | `(df AS U64)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:88` |
| `uxdataframe.GroupMean` | `(df AS U64, groupCol AS STRING, valueCol AS STRING)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:92` |
| `uxdataframe.JoinInner` | `(leftDf AS U64, rightDf AS U64, leftKey AS STRING, rightKey AS STRING)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:96` |
| `uxdataframe.ToCSV` | `(df AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxdataframe/uxdataframe.bas:100` |
| `uxdataframe.ToParquet` | `(df AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxdataframe/uxdataframe.bas:104` |
| `uxdataframe.ToF64Matrix` | `(df AS U64)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:108` |
| `uxdataframe.MatrixFree` | `(m AS U64)` |  | ✓ | `libsx/uxdataframe/uxdataframe.bas:112` |
| `uxdataframe.MatrixRows` | `(m AS U64)` | I64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:116` |
| `uxdataframe.MatrixCols` | `(m AS U64)` | I32 | ✓ | `libsx/uxdataframe/uxdataframe.bas:120` |
| `uxdataframe.MatrixDataPtr` | `(m AS U64)` | U64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:124` |
| `uxdataframe.MatrixGet` | `(m AS U64, row AS I64, col AS I32)` | F64 | ✓ | `libsx/uxdataframe/uxdataframe.bas:128` |

## uxdataset

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxdataset.Version` | `()` | I32 |  | `libsx/uxdataset/uxdataset.bas:20` |
| `uxdataset.Backend` | `()` | STRING | ✓ | `libsx/uxdataset/uxdataset.bas:24` |
| `uxdataset.Create` | `(rows AS I32, inputDim AS I32, targetDim AS I32)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:28` |
| `uxdataset.Free` | `(ds AS U64)` |  | ✓ | `libsx/uxdataset/uxdataset.bas:32` |
| `uxdataset.Clone` | `(ds AS U64)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:36` |
| `uxdataset.LoadCSV` | `(path AS STRING, inputDim AS I32, targetDim AS I32, hasHeader AS I32)` | U64 |  | `libsx/uxdataset/uxdataset.bas:40` |
| `uxdataset.SaveCSV` | `(ds AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxdataset/uxdataset.bas:44` |
| `uxdataset.RowCount` | `(ds AS U64)` | I32 | ✓ | `libsx/uxdataset/uxdataset.bas:48` |
| `uxdataset.InputDim` | `(ds AS U64)` | I32 | ✓ | `libsx/uxdataset/uxdataset.bas:52` |
| `uxdataset.TargetDim` | `(ds AS U64)` | I32 | ✓ | `libsx/uxdataset/uxdataset.bas:56` |
| `uxdataset.XPtr` | `(ds AS U64)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:60` |
| `uxdataset.YPtr` | `(ds AS U64)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:64` |
| `uxdataset.GetX` | `(ds AS U64, row AS I32, col AS I32)` | F64 | ✓ | `libsx/uxdataset/uxdataset.bas:68` |
| `uxdataset.SetX` | `(ds AS U64, row AS I32, col AS I32, value AS F64)` |  | ✓ | `libsx/uxdataset/uxdataset.bas:72` |
| `uxdataset.GetY` | `(ds AS U64, row AS I32, col AS I32)` | F64 | ✓ | `libsx/uxdataset/uxdataset.bas:76` |
| `uxdataset.SetY` | `(ds AS U64, row AS I32, col AS I32, value AS F64)` |  | ✓ | `libsx/uxdataset/uxdataset.bas:80` |
| `uxdataset.Shuffle` | `(ds AS U64, seed AS U64)` |  | ✓ | `libsx/uxdataset/uxdataset.bas:84` |
| `uxdataset.SplitTrain` | `(ds AS U64, trainRatio AS F64, seed AS U64)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:88` |
| `uxdataset.SplitTest` | `(ds AS U64, trainRatio AS F64, seed AS U64)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:92` |
| `uxdataset.ScalerFitStandard` | `(ds AS U64)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:96` |
| `uxdataset.ScalerFitMinMax` | `(ds AS U64)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:100` |
| `uxdataset.ScalerFree` | `(sc AS U64)` |  | ✓ | `libsx/uxdataset/uxdataset.bas:104` |
| `uxdataset.ScalerTransform` | `(sc AS U64, ds AS U64)` |  | ✓ | `libsx/uxdataset/uxdataset.bas:108` |
| `uxdataset.ScalerInverseTransform` | `(sc AS U64, ds AS U64)` |  | ✓ | `libsx/uxdataset/uxdataset.bas:112` |
| `uxdataset.FillMissingMean` | `(ds AS U64)` |  | ✓ | `libsx/uxdataset/uxdataset.bas:116` |
| `uxdataset.BatchCreate` | `(ds AS U64, batchSize AS I32, shuffle AS I32, seed AS U64)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:120` |
| `uxdataset.BatchFree` | `(loader AS U64)` |  | ✓ | `libsx/uxdataset/uxdataset.bas:124` |
| `uxdataset.BatchReset` | `(loader AS U64)` |  | ✓ | `libsx/uxdataset/uxdataset.bas:128` |
| `uxdataset.BatchNext` | `(loader AS U64)` | I32 | ✓ | `libsx/uxdataset/uxdataset.bas:132` |
| `uxdataset.BatchRows` | `(loader AS U64)` | I32 | ✓ | `libsx/uxdataset/uxdataset.bas:136` |
| `uxdataset.BatchXPtr` | `(loader AS U64)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:140` |
| `uxdataset.BatchYPtr` | `(loader AS U64)` | U64 | ✓ | `libsx/uxdataset/uxdataset.bas:144` |
| `uxdataset.BatchGetX` | `(loader AS U64, row AS I32, col AS I32)` | F64 | ✓ | `libsx/uxdataset/uxdataset.bas:148` |
| `uxdataset.BatchGetY` | `(loader AS U64, row AS I32, col AS I32)` | F64 | ✓ | `libsx/uxdataset/uxdataset.bas:152` |

## uxdatetime

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxdatetime.Version` | `()` | STRING |  | `libsx/uxdatetime/uxdatetime.bas:6` |
| `uxdatetime.UnixMillisecondsUtc` | `()` | I64 | ✓ | `libsx/uxdatetime/uxdatetime.bas:10` |
| `uxdatetime.FileTimeUtc` | `()` | U64 | ✓ | `libsx/uxdatetime/uxdatetime.bas:14` |
| `uxdatetime.MonotonicTicks` | `()` | I64 | ✓ | `libsx/uxdatetime/uxdatetime.bas:18` |
| `uxdatetime.MonotonicFrequency` | `()` | I64 | ✓ | `libsx/uxdatetime/uxdatetime.bas:22` |
| `uxdatetime.FormatUtc` | `(unixMilliseconds AS I64)` | STRING | ✓ | `libsx/uxdatetime/uxdatetime.bas:26` |
| `uxdatetime.FormatLocal` | `(unixMilliseconds AS I64)` | STRING | ✓ | `libsx/uxdatetime/uxdatetime.bas:30` |
| `uxdatetime.ParseUtc` | `(iso8601 AS STRING)` | I64 | ✓ | `libsx/uxdatetime/uxdatetime.bas:34` |
| `uxdatetime.AddMilliseconds` | `(unixMilliseconds AS I64,delta AS I64)` | I64 | ✓ | `libsx/uxdatetime/uxdatetime.bas:38` |
| `uxdatetime.DifferenceMilliseconds` | `(laterMilliseconds AS I64,earlierMilliseconds AS I64)` | I64 | ✓ | `libsx/uxdatetime/uxdatetime.bas:42` |
| `uxdatetime.SleepMilliseconds` | `(milliseconds AS U32)` |  | ✓ | `libsx/uxdatetime/uxdatetime.bas:46` |
| `uxdatetime.ErrorText` | `()` | STRING | ✓ | `libsx/uxdatetime/uxdatetime.bas:50` |

## uxfs

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxfs.Version` | `()` | STRING |  | `libsx/uxfs/uxfs.bas:6` |
| `uxfs.Exists` | `(path AS STRING)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:10` |
| `uxfs.FileExists` | `(path AS STRING)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:14` |
| `uxfs.DirectoryExists` | `(path AS STRING)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:18` |
| `uxfs.CreateDirectory` | `(path AS STRING)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:22` |
| `uxfs.CreateDirectories` | `(path AS STRING)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:26` |
| `uxfs.DeleteFile` | `(path AS STRING)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:30` |
| `uxfs.RemoveDirectory` | `(path AS STRING)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:34` |
| `uxfs.CopyFile` | `(source AS STRING,target AS STRING,overwrite AS I32)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:38` |
| `uxfs.Move` | `(source AS STRING,target AS STRING,overwrite AS I32)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:42` |
| `uxfs.FileSize` | `(path AS STRING)` | I64 | ✓ | `libsx/uxfs/uxfs.bas:46` |
| `uxfs.GetAttributes` | `(path AS STRING)` | U32 | ✓ | `libsx/uxfs/uxfs.bas:50` |
| `uxfs.SetAttributes` | `(path AS STRING,attributes AS U32)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:54` |
| `uxfs.ReadAllText` | `(path AS STRING)` | STRING | ✓ | `libsx/uxfs/uxfs.bas:58` |
| `uxfs.WriteAllText` | `(path AS STRING,text AS STRING)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:62` |
| `uxfs.AppendText` | `(path AS STRING,text AS STRING)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:66` |
| `uxfs.EnumOpen` | `(pattern AS STRING)` | U64 | ✓ | `libsx/uxfs/uxfs.bas:70` |
| `uxfs.EnumNext` | `(handle AS U64)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:74` |
| `uxfs.EnumName` | `(handle AS U64)` | STRING | ✓ | `libsx/uxfs/uxfs.bas:78` |
| `uxfs.EnumIsDirectory` | `(handle AS U64)` | I32 | ✓ | `libsx/uxfs/uxfs.bas:82` |
| `uxfs.EnumSize` | `(handle AS U64)` | U64 | ✓ | `libsx/uxfs/uxfs.bas:86` |
| `uxfs.EnumClose` | `(handle AS U64)` |  | ✓ | `libsx/uxfs/uxfs.bas:90` |
| `uxfs.ErrorText` | `()` | STRING | ✓ | `libsx/uxfs/uxfs.bas:94` |

## uxgraph

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxgraph.Create` | `(vertices AS I32, directed AS I32)` | U64 | ✓ | `libsx/uxgraph/uxgraph.bas:9` |
| `uxgraph.Free` | `(g AS U64)` |  | ✓ | `libsx/uxgraph/uxgraph.bas:13` |
| `uxgraph.AddVertex` | `(g AS U64)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:17` |
| `uxgraph.AddVertices` | `(g AS U64, count AS I32)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:21` |
| `uxgraph.AddEdge` | `(g AS U64, fromV AS I32, toV AS I32)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:25` |
| `uxgraph.VCount` | `(g AS U64)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:29` |
| `uxgraph.ECount` | `(g AS U64)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:33` |
| `uxgraph.IsDirected` | `(g AS U64)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:37` |
| `uxgraph.HasEdge` | `(g AS U64, fromV AS I32, toV AS I32)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:41` |
| `uxgraph.Degree` | `(g AS U64, v AS I32)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:45` |
| `uxgraph.InDegree` | `(g AS U64, v AS I32)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:49` |
| `uxgraph.OutDegree` | `(g AS U64, v AS I32)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:53` |
| `uxgraph.Density` | `(g AS U64)` | F64 | ✓ | `libsx/uxgraph/uxgraph.bas:57` |
| `uxgraph.SelfLoops` | `(g AS U64)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:61` |
| `uxgraph.Components` | `(g AS U64)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:65` |
| `uxgraph.IsConnected` | `(g AS U64)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:69` |
| `uxgraph.ShortestDistance` | `(g AS U64, source AS I32, target AS I32)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:73` |
| `uxgraph.PathExists` | `(g AS U64, source AS I32, target AS I32)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:77` |
| `uxgraph.TriangleCount` | `(g AS U64)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:81` |
| `uxgraph.Transitivity` | `(g AS U64)` | F64 | ✓ | `libsx/uxgraph/uxgraph.bas:85` |
| `uxgraph.DegreeVector` | `(g AS U64, mode AS I32)` | U64 | ✓ | `libsx/uxgraph/uxgraph.bas:89` |
| `uxgraph.BFSDistances` | `(g AS U64, source AS I32)` | U64 | ✓ | `libsx/uxgraph/uxgraph.bas:94` |
| `uxgraph.VecCount` | `(v AS U64)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:98` |
| `uxgraph.VecGet` | `(v AS U64, index AS I32)` | F64 | ✓ | `libsx/uxgraph/uxgraph.bas:102` |
| `uxgraph.VecFree` | `(v AS U64)` |  | ✓ | `libsx/uxgraph/uxgraph.bas:106` |
| `uxgraph.WriteEdgeListCSV` | `(g AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxgraph/uxgraph.bas:110` |
| `uxgraph.ReadEdgeListCSV` | `(path AS STRING, directed AS I32)` | U64 | ✓ | `libsx/uxgraph/uxgraph.bas:114` |
| `uxgraph.MakePath` | `(vertices AS I32, directed AS I32)` | U64 | ✓ | `libsx/uxgraph/uxgraph.bas:118` |
| `uxgraph.MakeCycle` | `(vertices AS I32, directed AS I32)` | U64 | ✓ | `libsx/uxgraph/uxgraph.bas:122` |
| `uxgraph.MakeComplete` | `(vertices AS I32, directed AS I32)` | U64 | ✓ | `libsx/uxgraph/uxgraph.bas:126` |

## uxgsl

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxgsl.ApiVersion` | `()` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:15` |
| `uxgsl.Available` | `()` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:19` |
| `uxgsl.GslVersion` | `()` | STRING | ✓ | `libsx/uxgsl/uxgsl.bas:23` |
| `uxgsl.SelfTest` | `()` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:27` |
| `uxgsl.LastStatus` | `()` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:31` |
| `uxgsl.LastGslStatus` | `()` | I32 |  | `libsx/uxgsl/uxgsl.bas:35` |
| `uxgsl.LastError` | `()` | STRING | ✓ | `libsx/uxgsl/uxgsl.bas:39` |
| `uxgsl.StatusText` | `(status AS I32)` | STRING |  | `libsx/uxgsl/uxgsl.bas:43` |
| `uxgsl.BesselJ0` | `(x AS F64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:47` |
| `uxgsl.BesselJ1` | `(x AS F64)` | F64 |  | `libsx/uxgsl/uxgsl.bas:51` |
| `uxgsl.BesselY0` | `(x AS F64)` | F64 |  | `libsx/uxgsl/uxgsl.bas:55` |
| `uxgsl.Gamma` | `(x AS F64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:59` |
| `uxgsl.LnGamma` | `(x AS F64)` | F64 |  | `libsx/uxgsl/uxgsl.bas:63` |
| `uxgsl.Erf` | `(x AS F64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:67` |
| `uxgsl.GaussianPdf` | `(x AS F64, sigma AS F64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:71` |
| `uxgsl.RngCreate` | `(seed AS U64)` | U64 | ✓ | `libsx/uxgsl/uxgsl.bas:75` |
| `uxgsl.RngFree` | `(handle AS U64)` |  | ✓ | `libsx/uxgsl/uxgsl.bas:79` |
| `uxgsl.RngUniform` | `(handle AS U64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:83` |
| `uxgsl.RngGaussian` | `(handle AS U64, sigma AS F64)` | F64 |  | `libsx/uxgsl/uxgsl.bas:87` |
| `uxgsl.VectorCreate` | `(count AS I32)` | U64 | ✓ | `libsx/uxgsl/uxgsl.bas:91` |
| `uxgsl.VectorFree` | `(handle AS U64)` |  | ✓ | `libsx/uxgsl/uxgsl.bas:95` |
| `uxgsl.VectorSize` | `(handle AS U64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:99` |
| `uxgsl.VectorSet` | `(handle AS U64, index AS I32, value AS F64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:103` |
| `uxgsl.VectorGet` | `(handle AS U64, index AS I32)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:107` |
| `uxgsl.VectorMean` | `(handle AS U64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:111` |
| `uxgsl.VectorStandardDeviation` | `(handle AS U64)` | F64 |  | `libsx/uxgsl/uxgsl.bas:115` |
| `uxgsl.VectorVariance` | `(handle AS U64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:119` |
| `uxgsl.MatrixCreate` | `(rows AS I32, columns AS I32)` | U64 | ✓ | `libsx/uxgsl/uxgsl.bas:125` |
| `uxgsl.MatrixFree` | `(handle AS U64)` |  | ✓ | `libsx/uxgsl/uxgsl.bas:129` |
| `uxgsl.MatrixRows` | `(handle AS U64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:133` |
| `uxgsl.MatrixColumns` | `(handle AS U64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:137` |
| `uxgsl.MatrixSet` | `(handle AS U64, row AS I32, column AS I32, value AS F64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:141` |
| `uxgsl.MatrixGet` | `(handle AS U64, row AS I32, column AS I32)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:145` |
| `uxgsl.MatrixSetZero` | `(handle AS U64)` | I32 |  | `libsx/uxgsl/uxgsl.bas:149` |
| `uxgsl.MatrixSetIdentity` | `(handle AS U64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:153` |
| `uxgsl.MatrixMultiply` | `(leftHandle AS U64, rightHandle AS U64, outputHandle AS U64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:157` |
| `uxgsl.IntegrationWorkspaceCreate` | `(limit AS I32)` | U64 | ✓ | `libsx/uxgsl/uxgsl.bas:164` |
| `uxgsl.IntegrationWorkspaceFree` | `(handle AS U64)` |  | ✓ | `libsx/uxgsl/uxgsl.bas:168` |
| `uxgsl.IntegrateQag` | `(callbackAddress AS PTR, userData AS PTR, lower AS F64, upper AS F64, absoluteTolerance AS F64, relativeTolerance AS F64, limit AS I32, key AS I32, workspaceHandle AS U64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:172` |
| `uxgsl.LastEstimatedError` | `()` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:176` |
| `uxgsl.RootBisectionCreate` | `()` | U64 | ✓ | `libsx/uxgsl/uxgsl.bas:182` |
| `uxgsl.RootBisectionFree` | `(handle AS U64)` |  | ✓ | `libsx/uxgsl/uxgsl.bas:186` |
| `uxgsl.RootBisectionSet` | `(handle AS U64, callbackAddress AS PTR, userData AS PTR, lower AS F64, upper AS F64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:190` |
| `uxgsl.RootBisectionIterate` | `(handle AS U64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:194` |
| `uxgsl.RootBisectionRoot` | `(handle AS U64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:198` |
| `uxgsl.RootBisectionLower` | `(handle AS U64)` | F64 |  | `libsx/uxgsl/uxgsl.bas:202` |
| `uxgsl.RootBisectionUpper` | `(handle AS U64)` | F64 |  | `libsx/uxgsl/uxgsl.bas:206` |
| `uxgsl.RootBisectionIntervalConverged` | `(handle AS U64, absoluteTolerance AS F64, relativeTolerance AS F64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:210` |
| `uxgsl.ComplexCreate` | `(real AS F64, imaginary AS F64)` | U64 | ✓ | `libsx/uxgsl/uxgsl.bas:216` |
| `uxgsl.ComplexFree` | `(handle AS U64)` |  | ✓ | `libsx/uxgsl/uxgsl.bas:220` |
| `uxgsl.ComplexReal` | `(handle AS U64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:224` |
| `uxgsl.ComplexImaginary` | `(handle AS U64)` | F64 | ✓ | `libsx/uxgsl/uxgsl.bas:228` |
| `uxgsl.ComplexAbs` | `(handle AS U64)` | F64 |  | `libsx/uxgsl/uxgsl.bas:232` |
| `uxgsl.ComplexAdd` | `(leftHandle AS U64, rightHandle AS U64, outputHandle AS U64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:236` |
| `uxgsl.ComplexMultiply` | `(leftHandle AS U64, rightHandle AS U64, outputHandle AS U64)` | I32 | ✓ | `libsx/uxgsl/uxgsl.bas:240` |
| `uxgsl.GslSymbol` | `(symbolName AS STRING)` | U64 |  | `libsx/uxgsl/uxgsl.bas:248` |
| `uxgsl.CblasSymbol` | `(symbolName AS STRING)` | U64 | ✓ | `libsx/uxgsl/uxgsl.bas:252` |
| `uxgsl.GslCallNew` | `(symbolName AS STRING, returnKind AS I32, isVariadic AS I32, fixedArgumentCount AS I32)` | U64 | ✓ | `libsx/uxgsl/uxgsl.bas:256` |
| `uxgsl.CblasCallNew` | `(symbolName AS STRING, returnKind AS I32, isVariadic AS I32, fixedArgumentCount AS I32)` | U64 |  | `libsx/uxgsl/uxgsl.bas:260` |
| `uxgsl.SfAiryZeroAi` | `(arg0 AS U32)` | F64 | ✓ | `libsx/uxgsl/generated/modules/gsl_sf_airy.bas:5` |
| `uxgsl.SfAiryZeroAiDeriv` | `(arg0 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_airy.bas:9` |
| `uxgsl.SfAiryZeroBi` | `(arg0 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_airy.bas:13` |
| `uxgsl.SfAiryZeroBiDeriv` | `(arg0 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_airy.bas:17` |
| `uxgsl.SfBesselI0` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:5` |
| `uxgsl.SfBesselI0Scaled_Gslsf_bessel_UpperI0_scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:9` |
| `uxgsl.SfBesselI1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:13` |
| `uxgsl.SfBesselI1Scaled_Gslsf_bessel_UpperI1_scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:17` |
| `uxgsl.SfBesselIn` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:21` |
| `uxgsl.SfBesselInScaled` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:25` |
| `uxgsl.SfBesselInu` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:29` |
| `uxgsl.SfBesselInuScaled` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:33` |
| `uxgsl.SfBesselJ1_Gslsf_bessel_UpperJ1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:37` |
| `uxgsl.SfBesselJn` | `(arg0 AS I32, arg1 AS F64)` | F64 | ✓ | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:41` |
| `uxgsl.SfBesselJnu` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:45` |
| `uxgsl.SfBesselK0` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:49` |
| `uxgsl.SfBesselK0Scaled_Gslsf_bessel_UpperK0_scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:53` |
| `uxgsl.SfBesselK1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:57` |
| `uxgsl.SfBesselK1Scaled_Gslsf_bessel_UpperK1_scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:61` |
| `uxgsl.SfBesselKn` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:65` |
| `uxgsl.SfBesselKnScaled` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:69` |
| `uxgsl.SfBesselKnu` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:73` |
| `uxgsl.SfBesselKnuScaled` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:77` |
| `uxgsl.SfBesselY0_Gslsf_bessel_UpperY0` | `(arg0 AS F64)` | F64 | ✓ | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:81` |
| `uxgsl.SfBesselY1_Gslsf_bessel_UpperY1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:85` |
| `uxgsl.SfBesselYn` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:89` |
| `uxgsl.SfBesselYnu` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:93` |
| `uxgsl.SfBesselI0Scaled_Gslsf_bessel_i0_scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:97` |
| `uxgsl.SfBesselI1Scaled_Gslsf_bessel_i1_scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:101` |
| `uxgsl.SfBesselI2Scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:105` |
| `uxgsl.SfBesselIlScaled` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:109` |
| `uxgsl.SfBesselJ0` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:113` |
| `uxgsl.SfBesselJ1_Gslsf_bessel_j1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:117` |
| `uxgsl.SfBesselJ2` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:121` |
| `uxgsl.SfBesselJl` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:125` |
| `uxgsl.SfBesselK0Scaled_Gslsf_bessel_k0_scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:129` |
| `uxgsl.SfBesselK1Scaled_Gslsf_bessel_k1_scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:133` |
| `uxgsl.SfBesselK2Scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:137` |
| `uxgsl.SfBesselKlScaled` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:141` |
| `uxgsl.SfBesselLnKnu` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:145` |
| `uxgsl.SfBesselY0_Gslsf_bessel_y0` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:149` |
| `uxgsl.SfBesselY1_Gslsf_bessel_y1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:153` |
| `uxgsl.SfBesselY2` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:157` |
| `uxgsl.SfBesselYl` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:161` |
| `uxgsl.SfBesselZeroJ0` | `(arg0 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:165` |
| `uxgsl.SfBesselZeroJ1` | `(arg0 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:169` |
| `uxgsl.SfBesselZeroJnu` | `(arg0 AS F64, arg1 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_bessel.bas:173` |
| `uxgsl.SfHydrogenicR` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64, arg3 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_coulomb.bas:5` |
| `uxgsl.SfCoupling6j` | `(arg0 AS I32, arg1 AS I32, arg2 AS I32, arg3 AS I32, arg4 AS I32, arg5 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_coupling.bas:5` |
| `uxgsl.SfCoupling6jINCORRECT` | `(arg0 AS I32, arg1 AS I32, arg2 AS I32, arg3 AS I32, arg4 AS I32, arg5 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_coupling.bas:9` |
| `uxgsl.SfCoupling9j` | `(arg0 AS I32, arg1 AS I32, arg2 AS I32, arg3 AS I32, arg4 AS I32, arg5 AS I32, arg6 AS I32, arg7 AS I32, arg8 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_coupling.bas:13` |
| `uxgsl.SfCouplingRacahW` | `(arg0 AS I32, arg1 AS I32, arg2 AS I32, arg3 AS I32, arg4 AS I32, arg5 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_coupling.bas:17` |
| `uxgsl.SfDebye2` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_debye.bas:5` |
| `uxgsl.SfDebye3` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_debye.bas:9` |
| `uxgsl.SfDebye4` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_debye.bas:13` |
| `uxgsl.SfDebye5` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_debye.bas:17` |
| `uxgsl.SfDebye6` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_debye.bas:21` |
| `uxgsl.SfErf` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_erf.bas:5` |
| `uxgsl.SfErfQ` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_erf.bas:9` |
| `uxgsl.SfErfZ` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_erf.bas:13` |
| `uxgsl.SfHazard` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_erf.bas:17` |
| `uxgsl.SfLogErfc` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_erf.bas:21` |
| `uxgsl.SfExpMult` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_exp.bas:5` |
| `uxgsl.SfExpm1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_exp.bas:9` |
| `uxgsl.SfExprel` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_exp.bas:13` |
| `uxgsl.SfExprel2` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_exp.bas:17` |
| `uxgsl.SfExprelN` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_exp.bas:21` |
| `uxgsl.SfChi` | `(arg0 AS F64)` | F64 | ✓ | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:5` |
| `uxgsl.SfCi` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:9` |
| `uxgsl.SfShi` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:13` |
| `uxgsl.SfSi` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:17` |
| `uxgsl.SfAtanint` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:21` |
| `uxgsl.SfExpint3` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:25` |
| `uxgsl.SfExpintE1Scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:29` |
| `uxgsl.SfExpintE2` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:33` |
| `uxgsl.SfExpintE2Scaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:37` |
| `uxgsl.SfExpintEi` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:41` |
| `uxgsl.SfExpintEiScaled` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:45` |
| `uxgsl.SfExpintEn` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:49` |
| `uxgsl.SfExpintEnScaled` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_expint.bas:53` |
| `uxgsl.SfFermiDirac0` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_fermi_dirac.bas:5` |
| `uxgsl.SfFermiDirac1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_fermi_dirac.bas:9` |
| `uxgsl.SfFermiDirac2` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_fermi_dirac.bas:13` |
| `uxgsl.SfFermiDirac3half` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_fermi_dirac.bas:17` |
| `uxgsl.SfFermiDiracHalf` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_fermi_dirac.bas:21` |
| `uxgsl.SfFermiDiracInc0` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_fermi_dirac.bas:25` |
| `uxgsl.SfFermiDiracInt` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_fermi_dirac.bas:29` |
| `uxgsl.SfFermiDiracMhalf` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_fermi_dirac.bas:33` |
| `uxgsl.SfBeta` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:5` |
| `uxgsl.SfBetaInc` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:9` |
| `uxgsl.SfChoose` | `(arg0 AS U32, arg1 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:13` |
| `uxgsl.SfDoublefact` | `(arg0 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:17` |
| `uxgsl.SfFact` | `(arg0 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:21` |
| `uxgsl.SfGamma` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:25` |
| `uxgsl.SfGammaInc` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:29` |
| `uxgsl.SfGammaIncP` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:33` |
| `uxgsl.SfGammaIncQ` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:37` |
| `uxgsl.SfGammainv` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:41` |
| `uxgsl.SfGammastar` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:45` |
| `uxgsl.SfLnbeta` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:49` |
| `uxgsl.SfLnchoose` | `(arg0 AS U32, arg1 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:53` |
| `uxgsl.SfLndoublefact` | `(arg0 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:57` |
| `uxgsl.SfLnfact` | `(arg0 AS U32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:61` |
| `uxgsl.SfLnpoch` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:65` |
| `uxgsl.SfPoch` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:69` |
| `uxgsl.SfPochrel` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:73` |
| `uxgsl.SfTaylorcoeff` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gamma.bas:77` |
| `uxgsl.SfGegenpoly2` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gegenbauer.bas:5` |
| `uxgsl.SfGegenpoly3` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gegenbauer.bas:9` |
| `uxgsl.SfGegenpolyN` | `(arg0 AS I32, arg1 AS F64, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_gegenbauer.bas:13` |
| `uxgsl.SfHermite` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:5` |
| `uxgsl.SfHermiteDeriv` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:9` |
| `uxgsl.SfHermiteFunc` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:13` |
| `uxgsl.SfHermiteFuncDer` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:17` |
| `uxgsl.SfHermiteFuncFast` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:21` |
| `uxgsl.SfHermiteFuncZero` | `(arg0 AS I32, arg1 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:25` |
| `uxgsl.SfHermitePhys` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:29` |
| `uxgsl.SfHermitePhysDer` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:33` |
| `uxgsl.SfHermitePhysZero` | `(arg0 AS I32, arg1 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:37` |
| `uxgsl.SfHermiteProbDer` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:41` |
| `uxgsl.SfHermiteProbDeriv` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:45` |
| `uxgsl.SfHermiteProbZero` | `(arg0 AS I32, arg1 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:49` |
| `uxgsl.SfHermiteZero` | `(arg0 AS I32, arg1 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hermite.bas:53` |
| `uxgsl.SfHyperg1F1` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hyperg.bas:5` |
| `uxgsl.SfHyperg1F1Int` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hyperg.bas:9` |
| `uxgsl.SfHyperg2F0` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hyperg.bas:13` |
| `uxgsl.SfHyperg2F1` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64, arg3 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hyperg.bas:17` |
| `uxgsl.SfHyperg2F1Conj` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64, arg3 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hyperg.bas:21` |
| `uxgsl.SfHyperg2F1ConjRenorm` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64, arg3 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hyperg.bas:25` |
| `uxgsl.SfHyperg2F1Renorm` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64, arg3 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hyperg.bas:29` |
| `uxgsl.SfHypergU` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hyperg.bas:33` |
| `uxgsl.SfHypergUInt` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_hyperg.bas:37` |
| `uxgsl.SfLaguerre2` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_laguerre.bas:5` |
| `uxgsl.SfLaguerre3` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_laguerre.bas:9` |
| `uxgsl.SfLaguerreN` | `(arg0 AS I32, arg1 AS F64, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_laguerre.bas:13` |
| `uxgsl.SfLambertWm1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_lambert.bas:5` |
| `uxgsl.SfConicalP0` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:5` |
| `uxgsl.SfConicalP1` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:9` |
| `uxgsl.SfConicalPCylReg` | `(arg0 AS I32, arg1 AS F64, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:13` |
| `uxgsl.SfConicalPHalf` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:17` |
| `uxgsl.SfConicalPMhalf` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:21` |
| `uxgsl.SfConicalPSphReg` | `(arg0 AS I32, arg1 AS F64, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:25` |
| `uxgsl.SfLegendreH3d` | `(arg0 AS I32, arg1 AS F64, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:29` |
| `uxgsl.SfLegendreH3d0` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:33` |
| `uxgsl.SfLegendreH3d1` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:37` |
| `uxgsl.SfLegendreP1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:41` |
| `uxgsl.SfLegendreP2` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:45` |
| `uxgsl.SfLegendreP3` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:49` |
| `uxgsl.SfLegendrePlm` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:53` |
| `uxgsl.SfLegendreQ0` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:57` |
| `uxgsl.SfLegendreQ1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:61` |
| `uxgsl.SfLegendreQl` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:65` |
| `uxgsl.SfLegendreSphPlm` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_legendre.bas:69` |
| `uxgsl.SfLog1plusx` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_log.bas:5` |
| `uxgsl.SfLog1plusxMx` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_log.bas:9` |
| `uxgsl.SfLogAbs` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_log.bas:13` |
| `uxgsl.SfPsi` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_psi.bas:5` |
| `uxgsl.SfPsi1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_psi.bas:9` |
| `uxgsl.SfPsi1Int` | `(arg0 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_psi.bas:13` |
| `uxgsl.SfPsi1piy` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_psi.bas:17` |
| `uxgsl.SfPsiN` | `(arg0 AS I32, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_psi.bas:21` |
| `uxgsl.SfCosPi` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_sincos_pi.bas:5` |
| `uxgsl.SfSynchrotron2` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_synchrotron.bas:5` |
| `uxgsl.SfTransport3` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_transport.bas:5` |
| `uxgsl.SfTransport4` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_transport.bas:9` |
| `uxgsl.SfTransport5` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_transport.bas:13` |
| `uxgsl.SfCos` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_trig.bas:5` |
| `uxgsl.SfHypot` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_trig.bas:9` |
| `uxgsl.SfLncosh` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_trig.bas:13` |
| `uxgsl.SfLnsinh` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_trig.bas:17` |
| `uxgsl.SfSinc` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_trig.bas:21` |
| `uxgsl.SfEta` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_zeta.bas:5` |
| `uxgsl.SfEtaInt` | `(arg0 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_zeta.bas:9` |
| `uxgsl.SfHzeta` | `(arg0 AS F64, arg1 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_zeta.bas:13` |
| `uxgsl.SfZeta` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_zeta.bas:17` |
| `uxgsl.SfZetam1` | `(arg0 AS F64)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_zeta.bas:21` |
| `uxgsl.SfZetam1Int` | `(arg0 AS I32)` | F64 |  | `libsx/uxgsl/generated/modules/gsl_sf_zeta.bas:25` |

## uxhttp

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxhttp.Version` | `()` | STRING |  | `libsx/uxhttp/uxhttp.bas:3` |
| `uxhttp.Open` | `()` | U64 | ✓ | `libsx/uxhttp/uxhttp.bas:7` |
| `uxhttp.Close` | `(h AS U64)` |  | ✓ | `libsx/uxhttp/uxhttp.bas:11` |
| `uxhttp.SetUrl` | `(h AS U64, url AS STRING)` | I32 | ✓ | `libsx/uxhttp/uxhttp.bas:15` |
| `uxhttp.SetMethod` | `(h AS U64, methodName AS STRING)` | I32 | ✓ | `libsx/uxhttp/uxhttp.bas:19` |
| `uxhttp.AddHeader` | `(h AS U64, header AS STRING)` | I32 | ✓ | `libsx/uxhttp/uxhttp.bas:23` |
| `uxhttp.SetBody` | `(h AS U64, body AS STRING)` | I32 | ✓ | `libsx/uxhttp/uxhttp.bas:27` |
| `uxhttp.SetTimeout` | `(h AS U64, timeoutMs AS I64)` | I32 | ✓ | `libsx/uxhttp/uxhttp.bas:31` |
| `uxhttp.FollowRedirects` | `(h AS U64, enabled AS I32)` | I32 | ✓ | `libsx/uxhttp/uxhttp.bas:35` |
| `uxhttp.Perform` | `(h AS U64)` | I32 | ✓ | `libsx/uxhttp/uxhttp.bas:39` |
| `uxhttp.Status` | `(h AS U64)` | I64 | ✓ | `libsx/uxhttp/uxhttp.bas:43` |
| `uxhttp.ResponseText` | `(h AS U64)` | STRING | ✓ | `libsx/uxhttp/uxhttp.bas:47` |
| `uxhttp.ResponseSize` | `(h AS U64)` | U64 | ✓ | `libsx/uxhttp/uxhttp.bas:51` |
| `uxhttp.SaveResponse` | `(h AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxhttp/uxhttp.bas:55` |
| `uxhttp.ErrorText` | `(h AS U64)` | STRING | ✓ | `libsx/uxhttp/uxhttp.bas:59` |
| `uxhttp.Version` | `()` | STRING |  | `libsx/uxhttp/uxhttp_easy.bas:3` |
| `uxhttp.Open` | `()` | U64 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:7` |
| `uxhttp.Close` | `(h AS U64)` |  | ✓ | `libsx/uxhttp/uxhttp_easy.bas:11` |
| `uxhttp.SetUrl` | `(h AS U64, url AS STRING)` | I32 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:15` |
| `uxhttp.SetMethod` | `(h AS U64, methodName AS STRING)` | I32 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:19` |
| `uxhttp.AddHeader` | `(h AS U64, header AS STRING)` | I32 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:23` |
| `uxhttp.SetBody` | `(h AS U64, body AS STRING)` | I32 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:27` |
| `uxhttp.SetTimeout` | `(h AS U64, timeoutMs AS I64)` | I32 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:31` |
| `uxhttp.FollowRedirects` | `(h AS U64, enabled AS I32)` | I32 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:35` |
| `uxhttp.Perform` | `(h AS U64)` | I32 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:39` |
| `uxhttp.Status` | `(h AS U64)` | I64 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:43` |
| `uxhttp.ResponseText` | `(h AS U64)` | STRING | ✓ | `libsx/uxhttp/uxhttp_easy.bas:47` |
| `uxhttp.ResponseSize` | `(h AS U64)` | U64 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:51` |
| `uxhttp.SaveResponse` | `(h AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxhttp/uxhttp_easy.bas:55` |
| `uxhttp.ErrorText` | `(h AS U64)` | STRING | ✓ | `libsx/uxhttp/uxhttp_easy.bas:59` |

## uxjson

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxjson.Version` | `()` | STRING |  | `libsx/uxjson/uxjson.bas:3` |
| `uxjson.Parse` | `(text AS STRING)` | U64 | ✓ | `libsx/uxjson/uxjson.bas:7` |
| `uxjson.Free` | `(doc AS U64)` |  | ✓ | `libsx/uxjson/uxjson.bas:11` |
| `uxjson.Root` | `(doc AS U64)` | U64 | ✓ | `libsx/uxjson/uxjson.bas:15` |
| `uxjson.PointerGet` | `(doc AS U64, pointer AS STRING)` | U64 | ✓ | `libsx/uxjson/uxjson.bas:19` |
| `uxjson.ObjectGet` | `(value AS U64, key AS STRING)` | U64 | ✓ | `libsx/uxjson/uxjson.bas:23` |
| `uxjson.ArrayGet` | `(value AS U64, index0 AS U64)` | U64 | ✓ | `libsx/uxjson/uxjson.bas:27` |
| `uxjson.ArraySize` | `(value AS U64)` | U64 | ✓ | `libsx/uxjson/uxjson.bas:31` |
| `uxjson.ValueType` | `(value AS U64)` | I32 | ✓ | `libsx/uxjson/uxjson.bas:35` |
| `uxjson.GetString` | `(value AS U64)` | STRING | ✓ | `libsx/uxjson/uxjson.bas:39` |
| `uxjson.GetI64` | `(value AS U64)` | I64 | ✓ | `libsx/uxjson/uxjson.bas:43` |
| `uxjson.GetU64` | `(value AS U64)` | U64 | ✓ | `libsx/uxjson/uxjson.bas:47` |
| `uxjson.GetF64` | `(value AS U64)` | F64 |  | `libsx/uxjson/uxjson.bas:51` |
| `uxjson.GetBoolean` | `(value AS U64)` | I32 | ✓ | `libsx/uxjson/uxjson.bas:55` |
| `uxjson.Write` | `(doc AS U64, pretty AS I32)` | STRING | ✓ | `libsx/uxjson/uxjson.bas:59` |
| `uxjson.ErrorText` | `()` | STRING | ✓ | `libsx/uxjson/uxjson.bas:63` |
| `uxjson.Version` | `()` | STRING |  | `libsx/uxjson/uxjson_easy.bas:3` |
| `uxjson.Parse` | `(text AS STRING)` | U64 | ✓ | `libsx/uxjson/uxjson_easy.bas:7` |
| `uxjson.Free` | `(doc AS U64)` |  | ✓ | `libsx/uxjson/uxjson_easy.bas:11` |
| `uxjson.Root` | `(doc AS U64)` | U64 | ✓ | `libsx/uxjson/uxjson_easy.bas:15` |
| `uxjson.PointerGet` | `(doc AS U64, pointer AS STRING)` | U64 | ✓ | `libsx/uxjson/uxjson_easy.bas:19` |
| `uxjson.ObjectGet` | `(value AS U64, key AS STRING)` | U64 | ✓ | `libsx/uxjson/uxjson_easy.bas:23` |
| `uxjson.ArrayGet` | `(value AS U64, index0 AS U64)` | U64 | ✓ | `libsx/uxjson/uxjson_easy.bas:27` |
| `uxjson.ArraySize` | `(value AS U64)` | U64 | ✓ | `libsx/uxjson/uxjson_easy.bas:31` |
| `uxjson.ValueType` | `(value AS U64)` | I32 | ✓ | `libsx/uxjson/uxjson_easy.bas:35` |
| `uxjson.GetString` | `(value AS U64)` | STRING | ✓ | `libsx/uxjson/uxjson_easy.bas:39` |
| `uxjson.GetI64` | `(value AS U64)` | I64 | ✓ | `libsx/uxjson/uxjson_easy.bas:43` |
| `uxjson.GetU64` | `(value AS U64)` | U64 | ✓ | `libsx/uxjson/uxjson_easy.bas:47` |
| `uxjson.GetF64` | `(value AS U64)` | F64 |  | `libsx/uxjson/uxjson_easy.bas:51` |
| `uxjson.GetBoolean` | `(value AS U64)` | I32 | ✓ | `libsx/uxjson/uxjson_easy.bas:55` |
| `uxjson.Write` | `(doc AS U64, pretty AS I32)` | STRING | ✓ | `libsx/uxjson/uxjson_easy.bas:59` |
| `uxjson.ErrorText` | `()` | STRING | ✓ | `libsx/uxjson/uxjson_easy.bas:63` |

## uxjsruntime

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `JsRuntimeApiVersion` | `()` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:1` |
| `JsContractVersion` | `()` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:5` |
| `JsQuickJsVersion` | `()` | STRING | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:9` |
| `JsEvalScriptFlag` | `()` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:13` |
| `JsEvalModuleFlag` | `()` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:17` |
| `JsEvalDrainJobsFlag` | `()` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:21` |
| `JsRuntimeCreate` | `()` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:25` |
| `JsRuntimeFree` | `(runtimeHandle AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:29` |
| `JsRuntimeMemoryLimitMb` | `(runtimeHandle AS I32, megabytes AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:33` |
| `JsRuntimeStackLimitKb` | `(runtimeHandle AS I32, kilobytes AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:37` |
| `JsRuntimeTimeLimitMs` | `(runtimeHandle AS I32, milliseconds AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:41` |
| `JsRuntimeCollectGarbage` | `(runtimeHandle AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:45` |
| `JsContextCreate` | `(runtimeHandle AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:49` |
| `JsContextFree` | `(contextHandle AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:53` |
| `JsInstallNativeHost` | `(contextHandle AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:57` |
| `JsBootstrapUxb` | `(contextHandle AS I32, corePath AS STRING, providerPath AS STRING)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:61` |
| `JsEval` | `(contextHandle AS I32, sourceText AS STRING, filename AS STRING, flags AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:65` |
| `JsEvalFile` | `(contextHandle AS I32, pathValue AS STRING, flags AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:69` |
| `JsPumpJobs` | `(runtimeHandle AS I32, maxJobs AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:73` |
| `JsCall` | `(contextHandle AS I32, functionName AS STRING, argumentsJson AS STRING)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:77` |
| `JsCallAwait` | `(contextHandle AS I32, functionName AS STRING, argumentsJson AS STRING, maxJobs AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:81` |
| `JsResultJson` | `(contextHandle AS I32, resultHandle AS I32)` | STRING | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:85` |
| `JsResultFree` | `(contextHandle AS I32, resultHandle AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:89` |
| `JsLastError` | `(contextHandle AS I32)` | STRING | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:93` |
| `JsClearError` | `(contextHandle AS I32)` | I32 | ✓ | `libsx/uxjsruntime/uxjsruntime.bas:97` |

## uxllama

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxllama.Create` | `()` | U64 | ✓ | `libsx/uxllama/uxllama.bas:11` |
| `uxllama.Free` | `(h AS U64)` |  | ✓ | `libsx/uxllama/uxllama.bas:15` |
| `uxllama.SetCliPath` | `(h AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:19` |
| `uxllama.SetModelPath` | `(h AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:23` |
| `uxllama.SetThreads` | `(h AS U64, n AS I32)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:27` |
| `uxllama.SetContext` | `(h AS U64, n AS I32)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:31` |
| `uxllama.SetPredict` | `(h AS U64, n AS I32)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:35` |
| `uxllama.SetTemperature` | `(h AS U64, t AS F64)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:39` |
| `uxllama.SetTopP` | `(h AS U64, p AS F64)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:43` |
| `uxllama.SetTopK` | `(h AS U64, k AS I32)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:47` |
| `uxllama.SetSeed` | `(h AS U64, seed AS I32)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:51` |
| `uxllama.LowMemoryProfile` | `(h AS U64, profile AS I32)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:55` |
| `uxllama.ModelExists` | `(h AS U64)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:59` |
| `uxllama.Prompt` | `(h AS U64, prompt AS STRING, outBuf AS U64, outBytes AS I32)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:63` |
| `uxllama.PromptFile` | `(h AS U64, promptFile AS STRING, outBuf AS U64, outBytes AS I32)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:67` |
| `uxllama.LastError` | `(h AS U64, outBuf AS U64, outBytes AS I32)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:71` |
| `uxllama.LastCommand` | `(h AS U64, outBuf AS U64, outBytes AS I32)` | I32 | ✓ | `libsx/uxllama/uxllama.bas:75` |

## uxllamax

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxllamax.Version` | `()` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:11` |
| `uxllamax.Create` | `()` | U64 | ✓ | `libsx/uxllamax/uxllamax.bas:15` |
| `uxllamax.Free` | `(h AS U64)` |  | ✓ | `libsx/uxllamax/uxllamax.bas:19` |
| `uxllamax.SetCliPath` | `(h AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:23` |
| `uxllamax.SetModelPath` | `(h AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:27` |
| `uxllamax.SetThreads` | `(h AS U64, value AS I32)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:31` |
| `uxllamax.SetContext` | `(h AS U64, value AS I32)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:35` |
| `uxllamax.SetPredict` | `(h AS U64, value AS I32)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:39` |
| `uxllamax.SetTemperature` | `(h AS U64, value AS F64)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:43` |
| `uxllamax.SetTopP` | `(h AS U64, value AS F64)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:47` |
| `uxllamax.SetTopK` | `(h AS U64, value AS I32)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:51` |
| `uxllamax.SetSeed` | `(h AS U64, value AS I32)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:55` |
| `uxllamax.LowMemoryProfile` | `(h AS U64, profile AS I32)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:59` |
| `uxllamax.ModelExists` | `(h AS U64)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:63` |
| `uxllamax.Prompt` | `(h AS U64, promptText AS STRING, outBuffer AS U64, outBytes AS I32)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:67` |
| `uxllamax.PromptFile` | `(h AS U64, promptPath AS STRING, outBuffer AS U64, outBytes AS I32)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:71` |
| `uxllamax.LastError` | `(h AS U64, outBuffer AS U64, outBytes AS I32)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:75` |
| `uxllamax.LastCommand` | `(h AS U64, outBuffer AS U64, outBytes AS I32)` | I32 | ✓ | `libsx/uxllamax/uxllamax.bas:79` |

## uxlog

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxlog.Version` | `()` | STRING |  | `libsx/uxlog/uxlog.bas:6` |
| `uxlog.Open` | `(path AS STRING,minLevel AS I32,rotateBytes AS U64)` | U64 | ✓ | `libsx/uxlog/uxlog.bas:10` |
| `uxlog.Write` | `(handle AS U64,level AS I32,message AS STRING)` | I32 | ✓ | `libsx/uxlog/uxlog.bas:14` |
| `uxlog.Trace` | `(handle AS U64,message AS STRING)` | I32 |  | `libsx/uxlog/uxlog.bas:18` |
| `uxlog.Debug` | `(handle AS U64,message AS STRING)` | I32 | ✓ | `libsx/uxlog/uxlog.bas:22` |
| `uxlog.Info` | `(handle AS U64,message AS STRING)` | I32 | ✓ | `libsx/uxlog/uxlog.bas:26` |
| `uxlog.Warning` | `(handle AS U64,message AS STRING)` | I32 | ✓ | `libsx/uxlog/uxlog.bas:30` |
| `uxlog.Error` | `(handle AS U64,message AS STRING)` | I32 | ✓ | `libsx/uxlog/uxlog.bas:34` |
| `uxlog.Fatal` | `(handle AS U64,message AS STRING)` | I32 | ✓ | `libsx/uxlog/uxlog.bas:38` |
| `uxlog.SetLevel` | `(handle AS U64,level AS I32)` | I32 | ✓ | `libsx/uxlog/uxlog.bas:42` |
| `uxlog.Flush` | `(handle AS U64)` |  | ✓ | `libsx/uxlog/uxlog.bas:46` |
| `uxlog.Close` | `(handle AS U64)` |  | ✓ | `libsx/uxlog/uxlog.bas:50` |
| `uxlog.LastError` | `()` | STRING | ✓ | `libsx/uxlog/uxlog.bas:54` |

## uxlogic

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxlogic.Version` | `()` | I32 | ✓ | `libsx/uxlogic/uxlogic.bas:2` |
| `uxlogic.LastError` | `()` | STRING |  | `libsx/uxlogic/uxlogic.bas:5` |
| `uxlogic.LastText` | `()` | STRING | ✓ | `libsx/uxlogic/uxlogic.bas:8` |
| `uxlogic.LuaLoad` | `(dllPath AS STRING)` | I32 | ✓ | `libsx/uxlogic/uxlogic.bas:11` |
| `uxlogic.LuaNew` | `()` | U64 | ✓ | `libsx/uxlogic/uxlogic.bas:14` |
| `uxlogic.LuaClose` | `(state AS U64)` |  | ✓ | `libsx/uxlogic/uxlogic.bas:17` |
| `uxlogic.LuaDoString` | `(state AS U64, code AS STRING)` | I32 |  | `libsx/uxlogic/uxlogic.bas:20` |
| `uxlogic.LuaDoFile` | `(state AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxlogic/uxlogic.bas:23` |
| `uxlogic.LuaGetNumber` | `(state AS U64, name AS STRING)` | F64 | ✓ | `libsx/uxlogic/uxlogic.bas:26` |
| `uxlogic.LuaGetString` | `(state AS U64, name AS STRING)` | STRING | ✓ | `libsx/uxlogic/uxlogic.bas:29` |
| `uxlogic.LuaSetNumber` | `(state AS U64, name AS STRING, value AS F64)` |  | ✓ | `libsx/uxlogic/uxlogic.bas:32` |
| `uxlogic.PrologQuery` | `(scriptPath AS STRING, goal AS STRING)` | I32 | ✓ | `libsx/uxlogic/uxlogic.bas:35` |
| `uxlogic.PrologQueryWith` | `(swiplPath AS STRING, scriptPath AS STRING, goal AS STRING)` | I32 |  | `libsx/uxlogic/uxlogic.bas:38` |
| `uxlogic.Triangle` | `(x AS F64, a AS F64, b AS F64, c AS F64)` | F64 | ✓ | `libsx/uxlogic/uxlogic.bas:41` |
| `uxlogic.Trapezoid` | `(x AS F64, a AS F64, b AS F64, c AS F64, d AS F64)` | F64 |  | `libsx/uxlogic/uxlogic.bas:44` |
| `uxlogic.FuzzyAnd` | `(a AS F64, b AS F64)` | F64 | ✓ | `libsx/uxlogic/uxlogic.bas:47` |
| `uxlogic.FuzzyOr` | `(a AS F64, b AS F64)` | F64 |  | `libsx/uxlogic/uxlogic.bas:50` |
| `uxlogic.FuzzyNot` | `(value AS F64)` | F64 |  | `libsx/uxlogic/uxlogic.bas:53` |
| `uxlogic.Weighted` | `(value1 AS F64, weight1 AS F64, value2 AS F64, weight2 AS F64)` | F64 | ✓ | `libsx/uxlogic/uxlogic.bas:56` |

## uxmath

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `UXMATH_Version` | `()` | I32 | ✓ | `libsx/uxmath/uxmath.bas:5` |
| `UXMATH_VecCreate` | `(capacity AS I32)` | U64 | ✓ | `libsx/uxmath/uxmath.bas:11` |
| `UXMATH_VecFree` | `(h AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:17` |
| `UXMATH_VecPush` | `(h AS U64, value AS F64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:22` |
| `UXMATH_VecSet` | `(h AS U64, index AS I32, value AS F64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:28` |
| `UXMATH_VecGet` | `(h AS U64, index AS I32)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:34` |
| `UXMATH_VecCount` | `(h AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:40` |
| `UXMATH_VecClear` | `(h AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:46` |
| `UXMATH_VecDataPtr` | `(h AS U64)` | U64 | ✓ | `libsx/uxmath/uxmath.bas:52` |
| `UXMATH_PolyEval` | `(coeffs AS U64, x AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:58` |
| `UXMATH_PolyDerivativeEval` | `(coeffs AS U64, x AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:62` |
| `UXMATH_PolyIntegralEval` | `(coeffs AS U64, a AS F64, b AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:66` |
| `UXMATH_PolyDerivativeCoeff` | `(coeffs AS U64, outCoeffs AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:70` |
| `UXMATH_PolyIntegralCoeff` | `(coeffs AS U64, outCoeffs AS U64, c0 AS F64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:74` |
| `UXMATH_PolyBisection` | `(coeffs AS U64, a AS F64, b AS F64, maxIter AS I32, tolerance AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:78` |
| `UXMATH_PolyNewton` | `(coeffs AS U64, x0 AS F64, maxIter AS I32, tolerance AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:82` |
| `UXMATH_NumericDerivativePoly` | `(coeffs AS U64, x AS F64, h AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:86` |
| `UXMATH_IntegratePolySimpson` | `(coeffs AS U64, a AS F64, b AS F64, intervals AS I32)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:90` |
| `UXMATH_ODE_RK4_Logistic` | `(y0 AS F64, rate AS F64, capacity AS F64, t0 AS F64, t1 AS F64, steps AS I32)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:94` |
| `UXMATH_ODE_Euler_Logistic` | `(y0 AS F64, rate AS F64, capacity AS F64, t0 AS F64, t1 AS F64, steps AS I32)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:98` |
| `UXMATH_Sigmoid` | `(x AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:102` |
| `UXMATH_DSigmoidFromOutput` | `(y AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:106` |
| `UXMATH_ReLU` | `(x AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:110` |
| `UXMATH_DReLU` | `(x AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:114` |
| `UXMATH_Tanh` | `(x AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:118` |
| `UXMATH_DTanhFromOutput` | `(y AS F64)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:122` |
| `UXMATH_VecSoftmax` | `(src AS U64, dst AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:126` |
| `UXMATH_MatCreate` | `(rows AS I32, cols AS I32)` | U64 | ✓ | `libsx/uxmath/uxmath.bas:130` |
| `UXMATH_MatFree` | `(matrix AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:134` |
| `UXMATH_MatRows` | `(matrix AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:139` |
| `UXMATH_MatCols` | `(matrix AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:143` |
| `UXMATH_MatSet` | `(matrix AS U64, row AS I32, col AS I32, value AS F64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:147` |
| `UXMATH_MatGet` | `(matrix AS U64, row AS I32, col AS I32)` | F64 | ✓ | `libsx/uxmath/uxmath.bas:151` |
| `UXMATH_MatFill` | `(matrix AS U64, value AS F64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:155` |
| `UXMATH_MatRandomUniform` | `(matrix AS U64, lo AS F64, hi AS F64, seed AS U32)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:159` |
| `UXMATH_MatAdd` | `(a AS U64, b AS U64, output AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:163` |
| `UXMATH_MatSub` | `(a AS U64, b AS U64, output AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:167` |
| `UXMATH_MatMul` | `(a AS U64, b AS U64, output AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:171` |
| `UXMATH_MatTranspose` | `(a AS U64, output AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:175` |
| `UXMATH_MatApplySigmoid` | `(a AS U64, output AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:179` |
| `UXMATH_MatApplyReLU` | `(a AS U64, output AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:183` |
| `UXMATH_MatVecMul` | `(matrix AS U64, vector AS U64, output AS U64)` | I32 | ✓ | `libsx/uxmath/uxmath.bas:187` |

## uxmathcore

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `UXMC_TYPE_I8` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:7` |
| `UXMC_TYPE_U8` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:10` |
| `UXMC_TYPE_I16` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:13` |
| `UXMC_TYPE_U16` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:16` |
| `UXMC_TYPE_I32` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:19` |
| `UXMC_TYPE_U32` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:22` |
| `UXMC_TYPE_I64` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:25` |
| `UXMC_TYPE_U64` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:28` |
| `UXMC_TYPE_F32` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:31` |
| `UXMC_TYPE_F64` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:34` |
| `UXMC_Version` | `()` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:38` |
| `UXMC_TypeSize` | `(typeId AS I32)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:44` |
| `UXMC_BufferCreate` | `(typeId AS I32, count AS I32)` | U64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:50` |
| `UXMC_BufferCreateCapacity` | `(typeId AS I32, count AS I32, capacity AS I32)` | U64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:56` |
| `UXMC_BufferFree` | `(h AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:62` |
| `UXMC_BufferType` | `(h AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:67` |
| `UXMC_BufferCount` | `(h AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:73` |
| `UXMC_BufferCapacity` | `(h AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:79` |
| `UXMC_BufferElemSize` | `(h AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:85` |
| `UXMC_BufferByteSize` | `(h AS U64)` | I64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:91` |
| `UXMC_BufferDataPtr` | `(h AS U64)` | U64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:97` |
| `UXMC_BufferClear` | `(h AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:103` |
| `UXMC_BufferResize` | `(h AS U64, count AS I32)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:109` |
| `UXMC_BufferReserve` | `(h AS U64, capacity AS I32)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:115` |
| `UXMC_BufferFillZero` | `(h AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:121` |
| `UXMC_BufferClone` | `(h AS U64)` | U64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:127` |
| `UXMC_BufferSlice` | `(h AS U64, startIndex AS I32, count AS I32)` | U64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:133` |
| `UXMC_BufferAppend` | `(dst AS U64, src AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:139` |
| `UXMC_BufferCast` | `(src AS U64, dstType AS I32)` | U64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:145` |
| `UXMC_GetF64` | `(h AS U64, index AS I32)` | F64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:151` |
| `UXMC_SetF64` | `(h AS U64, index AS I32, value AS F64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:158` |
| `UXMC_PushF64` | `(h AS U64, value AS F64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:164` |
| `UXMC_FillF64` | `(h AS U64, value AS F64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:170` |
| `UXMC_SetI64` | `(h AS U64, index AS I32, value AS I64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:176` |
| `UXMC_PushI64` | `(h AS U64, value AS I64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:182` |
| `UXMC_SetU64` | `(h AS U64, index AS I32, value AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:188` |
| `UXMC_PushU64` | `(h AS U64, value AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:194` |
| `UXMC_SetByte` | `(h AS U64, index AS I32, value AS I32)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:200` |
| `UXMC_PushByte` | `(h AS U64, value AS I32)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:206` |
| `UXMC_VecAddF64` | `(a AS U64, b AS U64, outv AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:213` |
| `UXMC_VecSubF64` | `(a AS U64, b AS U64, outv AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:219` |
| `UXMC_VecMulF64` | `(a AS U64, b AS U64, outv AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:225` |
| `UXMC_VecDivF64` | `(a AS U64, b AS U64, outv AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:231` |
| `UXMC_VecScaleF64` | `(a AS U64, scalar AS F64, outv AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:237` |
| `UXMC_VecAxpyF64` | `(alpha AS F64, x AS U64, y AS U64, outv AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:243` |
| `UXMC_VecDotF64` | `(a AS U64, b AS U64)` | F64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:249` |
| `UXMC_VecL1NormF64` | `(a AS U64)` | F64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:255` |
| `UXMC_VecL2NormF64` | `(a AS U64)` | F64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:261` |
| `UXMC_VecNormalizeL2F64` | `(a AS U64, outv AS U64)` | I32 | ✓ | `libsx/uxmathcore/uxmathcore.bas:267` |
| `UXMC_VecMinF64` | `(a AS U64)` | F64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:273` |
| `UXMC_VecMaxF64` | `(a AS U64)` | F64 | ✓ | `libsx/uxmathcore/uxmathcore.bas:279` |

## uxmatrix

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxmatrix.RuntimeVersion` | `()` | I32 |  | `libsx/uxmatrix/uxmatrix.bas:9` |
| `uxmatrix.Create` | `(rows AS I32, cols AS I32)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:13` |
| `uxmatrix.Free` | `(m AS U64)` |  | ✓ | `libsx/uxmatrix/uxmatrix.bas:17` |
| `uxmatrix.Rows` | `(m AS U64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:21` |
| `uxmatrix.Cols` | `(m AS U64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:25` |
| `uxmatrix.Size` | `(m AS U64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:29` |
| `uxmatrix.DataPtr` | `(m AS U64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:33` |
| `uxmatrix.Set` | `(m AS U64, r AS I32, c AS I32, v AS F64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:37` |
| `uxmatrix.Get` | `(m AS U64, r AS I32, c AS I32)` | F64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:41` |
| `uxmatrix.Fill` | `(m AS U64, v AS F64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:45` |
| `uxmatrix.Zero` | `(m AS U64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:49` |
| `uxmatrix.Eye` | `(m AS U64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:53` |
| `uxmatrix.Clone` | `(m AS U64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:57` |
| `uxmatrix.Transpose` | `(a AS U64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:61` |
| `uxmatrix.Add` | `(a AS U64, b AS U64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:65` |
| `uxmatrix.Sub` | `(a AS U64, b AS U64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:69` |
| `uxmatrix.Scale` | `(a AS U64, s AS F64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:73` |
| `uxmatrix.Mul` | `(a AS U64, b AS U64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:77` |
| `uxmatrix.MatVec` | `(a AS U64, x AS U64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:81` |
| `uxmatrix.Dot` | `(a AS U64, b AS U64)` | F64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:85` |
| `uxmatrix.NormL1` | `(a AS U64)` | F64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:89` |
| `uxmatrix.NormL2` | `(a AS U64)` | F64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:93` |
| `uxmatrix.NormFro` | `(a AS U64)` | F64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:97` |
| `uxmatrix.Trace` | `(a AS U64)` | F64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:101` |
| `uxmatrix.PrintMatrix` | `(a AS U64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:105` |
| `uxmatrix.Det` | `(a AS U64)` | F64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:109` |
| `uxmatrix.Solve` | `(a AS U64, b AS U64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:113` |
| `uxmatrix.Inverse` | `(a AS U64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:117` |
| `uxmatrix.Cholesky` | `(a AS U64)` | U64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:121` |
| `uxmatrix.QR` | `(a AS U64, qOutPtr AS U64, rOutPtr AS U64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:125` |
| `uxmatrix.SVD` | `(a AS U64, uOutPtr AS U64, sOutPtr AS U64, vtOutPtr AS U64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:130` |
| `uxmatrix.EigenSymmetric` | `(a AS U64, valuesOutPtr AS U64, vectorsOutPtr AS U64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:135` |
| `uxmatrix.RankSVD` | `(a AS U64, tol AS F64)` | I32 | ✓ | `libsx/uxmatrix/uxmatrix.bas:140` |
| `uxmatrix.Cond2` | `(a AS U64)` | F64 | ✓ | `libsx/uxmatrix/uxmatrix.bas:144` |

## uxnn

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxnn.Version` | `()` | I32 |  | `libsx/uxnn/uxnn.bas:24` |
| `uxnn.Backend` | `()` | STRING | ✓ | `libsx/uxnn/uxnn.bas:28` |
| `uxnn.Seed` | `(seed AS U64)` |  | ✓ | `libsx/uxnn/uxnn.bas:32` |
| `uxnn.NeuronCreate` | `(inputCount AS I32, activation AS I32)` | U64 | ✓ | `libsx/uxnn/uxnn.bas:37` |
| `uxnn.NeuronFree` | `(n AS U64)` |  | ✓ | `libsx/uxnn/uxnn.bas:41` |
| `uxnn.NeuronSetWeight` | `(n AS U64, index AS I32, value AS F64)` |  | ✓ | `libsx/uxnn/uxnn.bas:45` |
| `uxnn.NeuronGetWeight` | `(n AS U64, index AS I32)` | F64 | ✓ | `libsx/uxnn/uxnn.bas:49` |
| `uxnn.NeuronSetBias` | `(n AS U64, value AS F64)` |  | ✓ | `libsx/uxnn/uxnn.bas:53` |
| `uxnn.NeuronGetBias` | `(n AS U64)` | F64 | ✓ | `libsx/uxnn/uxnn.bas:57` |
| `uxnn.NeuronForwardPtr` | `(n AS U64, inputPtr AS U64)` | F64 | ✓ | `libsx/uxnn/uxnn.bas:61` |
| `uxnn.DenseLayerCreate` | `(inputDim AS I32, outputDim AS I32, activation AS I32)` | U64 | ✓ | `libsx/uxnn/uxnn.bas:66` |
| `uxnn.ActivationLayerCreate` | `(size AS I32, activation AS I32)` | U64 | ✓ | `libsx/uxnn/uxnn.bas:70` |
| `uxnn.LayerFree` | `(layer AS U64)` |  | ✓ | `libsx/uxnn/uxnn.bas:74` |
| `uxnn.LayerInputDim` | `(layer AS U64)` | I32 | ✓ | `libsx/uxnn/uxnn.bas:78` |
| `uxnn.LayerOutputDim` | `(layer AS U64)` | I32 | ✓ | `libsx/uxnn/uxnn.bas:82` |
| `uxnn.LayerSetWeight` | `(layer AS U64, outIndex AS I32, inIndex AS I32, value AS F64)` |  | ✓ | `libsx/uxnn/uxnn.bas:86` |
| `uxnn.LayerGetWeight` | `(layer AS U64, outIndex AS I32, inIndex AS I32)` | F64 | ✓ | `libsx/uxnn/uxnn.bas:90` |
| `uxnn.LayerSetBias` | `(layer AS U64, outIndex AS I32, value AS F64)` |  | ✓ | `libsx/uxnn/uxnn.bas:94` |
| `uxnn.LayerGetBias` | `(layer AS U64, outIndex AS I32)` | F64 | ✓ | `libsx/uxnn/uxnn.bas:98` |
| `uxnn.LayerInit` | `(layer AS U64, initKind AS I32, scale AS F64)` |  | ✓ | `libsx/uxnn/uxnn.bas:102` |
| `uxnn.LayerForwardPtr` | `(layer AS U64, inputPtr AS U64, outputPtr AS U64)` |  | ✓ | `libsx/uxnn/uxnn.bas:106` |
| `uxnn.NetworkCreate` | `()` | U64 | ✓ | `libsx/uxnn/uxnn.bas:111` |
| `uxnn.NetworkFree` | `(net AS U64)` |  | ✓ | `libsx/uxnn/uxnn.bas:115` |
| `uxnn.NetworkAddLayer` | `(net AS U64, layer AS U64)` | I32 | ✓ | `libsx/uxnn/uxnn.bas:119` |
| `uxnn.NetworkLayerCount` | `(net AS U64)` | I32 | ✓ | `libsx/uxnn/uxnn.bas:123` |
| `uxnn.NetworkInputDim` | `(net AS U64)` | I32 | ✓ | `libsx/uxnn/uxnn.bas:127` |
| `uxnn.NetworkOutputDim` | `(net AS U64)` | I32 | ✓ | `libsx/uxnn/uxnn.bas:131` |
| `uxnn.NetworkForwardPtr` | `(net AS U64, inputPtr AS U64, outputPtr AS U64)` |  | ✓ | `libsx/uxnn/uxnn.bas:135` |
| `uxnn.NetworkPredictArgmaxPtr` | `(net AS U64, inputPtr AS U64)` | I32 | ✓ | `libsx/uxnn/uxnn.bas:139` |
| `uxnn.NetworkMSEPtr` | `(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, inputDim AS I32, outputDim AS I32)` | F64 | ✓ | `libsx/uxnn/uxnn.bas:143` |
| `uxnn.NetworkTrainMSESGDPtr` | `(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, inputDim AS I32, outputDim AS I32, epochs AS I32, lr AS F64)` | F64 | ✓ | `libsx/uxnn/uxnn.bas:147` |
| `uxnn.NetworkForwardTensor` | `(net AS U64, inputTensor AS U64, outputTensor AS U64)` |  | ✓ | `libsx/uxnn/uxnn.bas:152` |
| `uxnn.NetworkPredictArgmaxTensor` | `(net AS U64, inputTensor AS U64)` | I32 | ✓ | `libsx/uxnn/uxnn.bas:156` |

## uxnn2

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxnn2.Version` | `()` | I32 |  | `libsx/uxnn2/uxnn2.bas:28` |
| `uxnn2.Backend` | `()` | STRING | ✓ | `libsx/uxnn2/uxnn2.bas:32` |
| `uxnn2.Seed` | `(seed AS U64)` |  | ✓ | `libsx/uxnn2/uxnn2.bas:36` |
| `uxnn2.NetworkCreate` | `(inputDim AS I32)` | U64 | ✓ | `libsx/uxnn2/uxnn2.bas:40` |
| `uxnn2.NetworkFree` | `(net AS U64)` |  | ✓ | `libsx/uxnn2/uxnn2.bas:44` |
| `uxnn2.AddDense` | `(net AS U64, outputDim AS I32, activation AS I32)` | I32 | ✓ | `libsx/uxnn2/uxnn2.bas:48` |
| `uxnn2.LayerCount` | `(net AS U64)` | I32 | ✓ | `libsx/uxnn2/uxnn2.bas:52` |
| `uxnn2.InputDim` | `(net AS U64)` | I32 |  | `libsx/uxnn2/uxnn2.bas:56` |
| `uxnn2.OutputDim` | `(net AS U64)` | I32 | ✓ | `libsx/uxnn2/uxnn2.bas:60` |
| `uxnn2.Init` | `(net AS U64, initKind AS I32, scale AS F64)` |  | ✓ | `libsx/uxnn2/uxnn2.bas:64` |
| `uxnn2.SetOptimizer` | `(net AS U64, optKind AS I32, learningRate AS F64)` |  |  | `libsx/uxnn2/uxnn2.bas:68` |
| `uxnn2.SetOptimizerParams` | `(net AS U64, beta1 AS F64, beta2 AS F64, epsilon AS F64, weightDecay AS F64)` |  | ✓ | `libsx/uxnn2/uxnn2.bas:72` |
| `uxnn2.ForwardPtr` | `(net AS U64, inputPtr AS U64, outputPtr AS U64)` |  | ✓ | `libsx/uxnn2/uxnn2.bas:76` |
| `uxnn2.LossMSEPtr` | `(net AS U64, inputPtr AS U64, targetPtr AS U64)` | F64 | ✓ | `libsx/uxnn2/uxnn2.bas:80` |
| `uxnn2.TrainSampleMSEPtr` | `(net AS U64, inputPtr AS U64, targetPtr AS U64)` | F64 | ✓ | `libsx/uxnn2/uxnn2.bas:84` |
| `uxnn2.TrainArrayMSEPtr` | `(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, epochs AS I32, shuffle AS I32)` | F64 | ✓ | `libsx/uxnn2/uxnn2.bas:88` |
| `uxnn2.PredictArgmaxPtr` | `(net AS U64, inputPtr AS U64)` | I32 | ✓ | `libsx/uxnn2/uxnn2.bas:92` |
| `uxnn2.GetWeight` | `(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32)` | F64 | ✓ | `libsx/uxnn2/uxnn2.bas:96` |
| `uxnn2.SetWeight` | `(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32, value AS F64)` |  | ✓ | `libsx/uxnn2/uxnn2.bas:100` |
| `uxnn2.GetBias` | `(net AS U64, layerIndex AS I32, outIndex AS I32)` | F64 | ✓ | `libsx/uxnn2/uxnn2.bas:104` |
| `uxnn2.SetBias` | `(net AS U64, layerIndex AS I32, outIndex AS I32, value AS F64)` |  | ✓ | `libsx/uxnn2/uxnn2.bas:108` |
| `uxnn2.Save` | `(net AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxnn2/uxnn2.bas:112` |
| `uxnn2.Load` | `(path AS STRING)` | U64 | ✓ | `libsx/uxnn2/uxnn2.bas:116` |

## uxnn3

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxnn3.Version` | `()` | I32 |  | `libsx/uxnn3/uxnn3.bas:17` |
| `uxnn3.LastError` | `()` | STRING | ✓ | `libsx/uxnn3/uxnn3.bas:21` |
| `uxnn3.DatasetCreate` | `(rows AS I32, inputDim AS I32, outputDim AS I32)` | U64 | ✓ | `libsx/uxnn3/uxnn3.bas:25` |
| `uxnn3.DatasetFree` | `(ds AS U64)` |  | ✓ | `libsx/uxnn3/uxnn3.bas:29` |
| `uxnn3.LoadCSV` | `(path AS STRING, inputDim AS I32, outputDim AS I32, hasHeader AS I32)` | U64 |  | `libsx/uxnn3/uxnn3.bas:33` |
| `uxnn3.SaveCSV` | `(ds AS U64, path AS STRING, includeHeader AS I32)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:37` |
| `uxnn3.Rows` | `(ds AS U64)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:41` |
| `uxnn3.InputDim` | `(ds AS U64)` | I32 |  | `libsx/uxnn3/uxnn3.bas:45` |
| `uxnn3.OutputDim` | `(ds AS U64)` | I32 |  | `libsx/uxnn3/uxnn3.bas:49` |
| `uxnn3.XGet` | `(ds AS U64, row AS I32, col AS I32)` | F64 | ✓ | `libsx/uxnn3/uxnn3.bas:53` |
| `uxnn3.YGet` | `(ds AS U64, row AS I32, col AS I32)` | F64 | ✓ | `libsx/uxnn3/uxnn3.bas:57` |
| `uxnn3.XSet` | `(ds AS U64, row AS I32, col AS I32, v AS F64)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:61` |
| `uxnn3.YSet` | `(ds AS U64, row AS I32, col AS I32, v AS F64)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:65` |
| `uxnn3.XPtr` | `(ds AS U64)` | U64 | ✓ | `libsx/uxnn3/uxnn3.bas:69` |
| `uxnn3.YPtr` | `(ds AS U64)` | U64 | ✓ | `libsx/uxnn3/uxnn3.bas:73` |
| `uxnn3.Shuffle` | `(ds AS U64, seed AS U32)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:77` |
| `uxnn3.SplitTrain` | `(ds AS U64, ratio AS F64, seed AS U32)` | U64 | ✓ | `libsx/uxnn3/uxnn3.bas:81` |
| `uxnn3.SplitTest` | `(ds AS U64, ratio AS F64, seed AS U32)` | U64 | ✓ | `libsx/uxnn3/uxnn3.bas:85` |
| `uxnn3.Standardize` | `(ds AS U64)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:89` |
| `uxnn3.MinMax` | `(ds AS U64, a AS F64, b AS F64)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:93` |
| `uxnn3.ModelCreate` | `(inputDim AS I32)` | U64 | ✓ | `libsx/uxnn3/uxnn3.bas:97` |
| `uxnn3.ModelFree` | `(model AS U64)` |  | ✓ | `libsx/uxnn3/uxnn3.bas:101` |
| `uxnn3.AddDense` | `(model AS U64, outputDim AS I32, activation AS I32)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:105` |
| `uxnn3.Init` | `(model AS U64, seed AS U32, scale AS F64)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:109` |
| `uxnn3.SetOptimizer` | `(model AS U64, opt AS I32, lr AS F64, momentum AS F64)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:113` |
| `uxnn3.LayerCount` | `(model AS U64)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:117` |
| `uxnn3.ModelOutputDim` | `(model AS U64)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:121` |
| `uxnn3.PredictArgMax` | `(model AS U64, ds AS U64, row AS I32)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:125` |
| `uxnn3.TrainDataset` | `(model AS U64, ds AS U64, epochs AS I32, batchSize AS I32, shuffle AS I32, seed AS U32)` | F64 | ✓ | `libsx/uxnn3/uxnn3.bas:129` |
| `uxnn3.EvalMSE` | `(model AS U64, ds AS U64)` | F64 | ✓ | `libsx/uxnn3/uxnn3.bas:133` |
| `uxnn3.EvalBinaryAccuracy` | `(model AS U64, ds AS U64, threshold AS F64)` | F64 | ✓ | `libsx/uxnn3/uxnn3.bas:137` |
| `uxnn3.Save` | `(model AS U64, path AS STRING)` | I32 | ✓ | `libsx/uxnn3/uxnn3.bas:141` |
| `uxnn3.Load` | `(path AS STRING)` | U64 | ✓ | `libsx/uxnn3/uxnn3.bas:145` |

## uxonnx

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxonnx.Init` | `(runtimeDir AS STRING)` | I32 | ✓ | `libsx/uxonnx/uxonnx.bas:8` |
| `uxonnx.Version` | `()` | STRING | ✓ | `libsx/uxonnx/uxonnx.bas:12` |
| `uxonnx.LastError` | `(session AS U64)` | STRING | ✓ | `libsx/uxonnx/uxonnx.bas:16` |
| `uxonnx.SessionCreate` | `(modelPath AS STRING, intraThreads AS I32)` | U64 | ✓ | `libsx/uxonnx/uxonnx.bas:20` |
| `uxonnx.SessionFree` | `(session AS U64)` |  | ✓ | `libsx/uxonnx/uxonnx.bas:24` |
| `uxonnx.InputCount` | `(session AS U64)` | I64 | ✓ | `libsx/uxonnx/uxonnx.bas:28` |
| `uxonnx.OutputCount` | `(session AS U64)` | I64 | ✓ | `libsx/uxonnx/uxonnx.bas:32` |
| `uxonnx.InputName` | `(session AS U64, index AS I64)` | STRING | ✓ | `libsx/uxonnx/uxonnx.bas:36` |
| `uxonnx.OutputName` | `(session AS U64, index AS I64)` | STRING | ✓ | `libsx/uxonnx/uxonnx.bas:40` |
| `uxonnx.TensorCreate1D` | `(n AS I64)` | U64 | ✓ | `libsx/uxonnx/uxonnx.bas:44` |
| `uxonnx.TensorCreate2D` | `(r AS I64, c AS I64)` | U64 | ✓ | `libsx/uxonnx/uxonnx.bas:48` |
| `uxonnx.TensorCreate3D` | `(a AS I64, b AS I64, c AS I64)` | U64 | ✓ | `libsx/uxonnx/uxonnx.bas:52` |
| `uxonnx.TensorCreate4D` | `(a AS I64, b AS I64, c AS I64, d AS I64)` | U64 | ✓ | `libsx/uxonnx/uxonnx.bas:56` |
| `uxonnx.TensorFree` | `(t AS U64)` |  | ✓ | `libsx/uxonnx/uxonnx.bas:60` |
| `uxonnx.TensorCount` | `(t AS U64)` | I64 | ✓ | `libsx/uxonnx/uxonnx.bas:64` |
| `uxonnx.TensorRank` | `(t AS U64)` | I64 |  | `libsx/uxonnx/uxonnx.bas:68` |
| `uxonnx.TensorDim` | `(t AS U64, axis AS I64)` | I64 | ✓ | `libsx/uxonnx/uxonnx.bas:72` |
| `uxonnx.TensorDataPtr` | `(t AS U64)` | U64 | ✓ | `libsx/uxonnx/uxonnx.bas:76` |
| `uxonnx.TensorSet` | `(t AS U64, idx AS I64, value AS F64)` |  | ✓ | `libsx/uxonnx/uxonnx.bas:80` |
| `uxonnx.TensorGet` | `(t AS U64, idx AS I64)` | F64 | ✓ | `libsx/uxonnx/uxonnx.bas:84` |
| `uxonnx.Run1` | `(session AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING)` | U64 | ✓ | `libsx/uxonnx/uxonnx.bas:88` |

## uxonnx2

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxonnx2.Init` | `(runtimeDir AS STRING)` | I32 | ✓ | `libsx/uxonnx2/uxonnx2.bas:24` |
| `uxonnx2.Version` | `()` | STRING | ✓ | `libsx/uxonnx2/uxonnx2.bas:28` |
| `uxonnx2.LastError` | `()` | STRING | ✓ | `libsx/uxonnx2/uxonnx2.bas:32` |
| `uxonnx2.ProviderAvailable` | `(provider AS I32)` | I32 | ✓ | `libsx/uxonnx2/uxonnx2.bas:36` |
| `uxonnx2.SessionCreate` | `(modelPath AS STRING)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:40` |
| `uxonnx2.SessionCreateAdvanced` | `(modelPath AS STRING, provider AS I32, intraThreads AS I32, interThreads AS I32, graphOpt AS I32)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:44` |
| `uxonnx2.SessionFree` | `(s AS U64)` |  | ✓ | `libsx/uxonnx2/uxonnx2.bas:48` |
| `uxonnx2.InputCount` | `(s AS U64)` | I64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:52` |
| `uxonnx2.OutputCount` | `(s AS U64)` | I64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:56` |
| `uxonnx2.InputName` | `(s AS U64, idx AS I64)` | STRING | ✓ | `libsx/uxonnx2/uxonnx2.bas:60` |
| `uxonnx2.OutputName` | `(s AS U64, idx AS I64)` | STRING | ✓ | `libsx/uxonnx2/uxonnx2.bas:64` |
| `uxonnx2.InputDType` | `(s AS U64, idx AS I64)` | I32 | ✓ | `libsx/uxonnx2/uxonnx2.bas:68` |
| `uxonnx2.OutputDType` | `(s AS U64, idx AS I64)` | I32 | ✓ | `libsx/uxonnx2/uxonnx2.bas:72` |
| `uxonnx2.InputRank` | `(s AS U64, idx AS I64)` | I64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:76` |
| `uxonnx2.OutputRank` | `(s AS U64, idx AS I64)` | I64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:80` |
| `uxonnx2.InputDim` | `(s AS U64, idx AS I64, axis AS I64)` | I64 |  | `libsx/uxonnx2/uxonnx2.bas:84` |
| `uxonnx2.OutputDim` | `(s AS U64, idx AS I64, axis AS I64)` | I64 |  | `libsx/uxonnx2/uxonnx2.bas:88` |
| `uxonnx2.TensorCreate1D` | `(dtype AS I32, n AS I64)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:92` |
| `uxonnx2.TensorCreate2D` | `(dtype AS I32, r AS I64, c AS I64)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:96` |
| `uxonnx2.TensorCreate3D` | `(dtype AS I32, a AS I64, b AS I64, c AS I64)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:100` |
| `uxonnx2.TensorCreate4D` | `(dtype AS I32, a AS I64, b AS I64, c AS I64, d AS I64)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:104` |
| `uxonnx2.TensorFree` | `(t AS U64)` |  | ✓ | `libsx/uxonnx2/uxonnx2.bas:108` |
| `uxonnx2.TensorDType` | `(t AS U64)` | I32 | ✓ | `libsx/uxonnx2/uxonnx2.bas:112` |
| `uxonnx2.TensorRank` | `(t AS U64)` | I64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:116` |
| `uxonnx2.TensorDim` | `(t AS U64, axis AS I64)` | I64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:120` |
| `uxonnx2.TensorCount` | `(t AS U64)` | I64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:124` |
| `uxonnx2.TensorDataPtr` | `(t AS U64)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:128` |
| `uxonnx2.TensorSetF64` | `(t AS U64, idx AS I64, value AS F64)` |  | ✓ | `libsx/uxonnx2/uxonnx2.bas:132` |
| `uxonnx2.TensorGetF64` | `(t AS U64, idx AS I64)` | F64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:136` |
| `uxonnx2.TensorSetI64` | `(t AS U64, idx AS I64, value AS I64)` |  | ✓ | `libsx/uxonnx2/uxonnx2.bas:140` |
| `uxonnx2.TensorGetI64` | `(t AS U64, idx AS I64)` | I64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:144` |
| `uxonnx2.TensorSetString` | `(t AS U64, idx AS I64, value AS STRING)` |  | ✓ | `libsx/uxonnx2/uxonnx2.bas:148` |
| `uxonnx2.TensorGetString` | `(t AS U64, idx AS I64)` | STRING | ✓ | `libsx/uxonnx2/uxonnx2.bas:152` |
| `uxonnx2.RunCreate` | `(s AS U64)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:156` |
| `uxonnx2.RunFree` | `(r AS U64)` |  | ✓ | `libsx/uxonnx2/uxonnx2.bas:160` |
| `uxonnx2.RunAddInput` | `(r AS U64, name AS STRING, t AS U64)` | I32 | ✓ | `libsx/uxonnx2/uxonnx2.bas:164` |
| `uxonnx2.RunAddOutput` | `(r AS U64, name AS STRING)` | I32 | ✓ | `libsx/uxonnx2/uxonnx2.bas:168` |
| `uxonnx2.RunExecute` | `(r AS U64)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:172` |
| `uxonnx2.ResultFree` | `(res AS U64)` |  | ✓ | `libsx/uxonnx2/uxonnx2.bas:176` |
| `uxonnx2.ResultCount` | `(res AS U64)` | I64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:180` |
| `uxonnx2.ResultTensor` | `(res AS U64, idx AS I64)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:184` |
| `uxonnx2.Run1` | `(s AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING)` | U64 | ✓ | `libsx/uxonnx2/uxonnx2.bas:188` |

## uxpath

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxpath.Version` | `()` | STRING |  | `libsx/uxpath/uxpath.bas:6` |
| `uxpath.Join` | `(a AS STRING,b AS STRING)` | STRING | ✓ | `libsx/uxpath/uxpath.bas:10` |
| `uxpath.Combine3` | `(a AS STRING,b AS STRING,c AS STRING)` | STRING | ✓ | `libsx/uxpath/uxpath.bas:14` |
| `uxpath.Full` | `(path AS STRING)` | STRING | ✓ | `libsx/uxpath/uxpath.bas:18` |
| `uxpath.Normalize` | `(path AS STRING)` | STRING | ✓ | `libsx/uxpath/uxpath.bas:22` |
| `uxpath.IsAbsolute` | `(path AS STRING)` | I32 | ✓ | `libsx/uxpath/uxpath.bas:26` |
| `uxpath.FileName` | `(path AS STRING)` | STRING | ✓ | `libsx/uxpath/uxpath.bas:30` |
| `uxpath.DirectoryName` | `(path AS STRING)` | STRING | ✓ | `libsx/uxpath/uxpath.bas:34` |
| `uxpath.Extension` | `(path AS STRING)` | STRING | ✓ | `libsx/uxpath/uxpath.bas:38` |
| `uxpath.Stem` | `(path AS STRING)` | STRING | ✓ | `libsx/uxpath/uxpath.bas:42` |
| `uxpath.ChangeExtension` | `(path AS STRING,ext AS STRING)` | STRING | ✓ | `libsx/uxpath/uxpath.bas:46` |
| `uxpath.HasExtension` | `(path AS STRING,ext AS STRING)` | I32 | ✓ | `libsx/uxpath/uxpath.bas:50` |
| `uxpath.IsInside` | `(rootPath AS STRING,childPath AS STRING)` | I32 | ✓ | `libsx/uxpath/uxpath.bas:54` |
| `uxpath.ErrorText` | `()` | STRING | ✓ | `libsx/uxpath/uxpath.bas:58` |

## uxprocess

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxprocess.Version` | `()` | STRING |  | `libsx/uxprocess/uxprocess.bas:6` |
| `uxprocess.Start` | `(command AS STRING,cwd AS STRING,hidden AS I32)` | U64 | ✓ | `libsx/uxprocess/uxprocess.bas:10` |
| `uxprocess.Wait` | `(handle AS U64,timeoutMs AS U32)` | I32 | ✓ | `libsx/uxprocess/uxprocess.bas:14` |
| `uxprocess.IsRunning` | `(handle AS U64)` | I32 | ✓ | `libsx/uxprocess/uxprocess.bas:18` |
| `uxprocess.ExitCode` | `(handle AS U64)` | I32 | ✓ | `libsx/uxprocess/uxprocess.bas:22` |
| `uxprocess.ProcessId` | `(handle AS U64)` | U32 | ✓ | `libsx/uxprocess/uxprocess.bas:26` |
| `uxprocess.Kill` | `(handle AS U64,exitCode AS U32)` | I32 | ✓ | `libsx/uxprocess/uxprocess.bas:30` |
| `uxprocess.Close` | `(handle AS U64)` |  | ✓ | `libsx/uxprocess/uxprocess.bas:34` |
| `uxprocess.ShellOpen` | `(target AS STRING,parameters AS STRING,cwd AS STRING,showCommand AS I32)` | I32 | ✓ | `libsx/uxprocess/uxprocess.bas:38` |
| `uxprocess.RunWait` | `(command AS STRING,cwd AS STRING,hidden AS I32,timeoutMs AS U32)` | I32 | ✓ | `libsx/uxprocess/uxprocess.bas:42` |
| `uxprocess.CurrentProcessId` | `()` | U32 | ✓ | `libsx/uxprocess/uxprocess.bas:46` |
| `uxprocess.ErrorText` | `()` | STRING | ✓ | `libsx/uxprocess/uxprocess.bas:50` |

## uxpython

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `PythonVersion` | `()` | I32 | ✓ | `libsx/uxpython/uxpython.bas:1` |
| `PythonFlagIsolated` | `()` | I32 | ✓ | `libsx/uxpython/uxpython.bas:5` |
| `PythonFlagIgnoreEnvironment` | `()` | I32 | ✓ | `libsx/uxpython/uxpython.bas:9` |
| `PythonFlagNoSite` | `()` | I32 | ✓ | `libsx/uxpython/uxpython.bas:13` |
| `PythonOpen` | `(pythonHome AS STRING, venvPath AS STRING, modulePath AS STRING, flags AS I32)` | U64 | ✓ | `libsx/uxpython/uxpython.bas:17` |
| `PythonClose` | `(session AS U64)` | I32 | ✓ | `libsx/uxpython/uxpython.bas:21` |
| `PythonReady` | `(session AS U64)` | I32 | ✓ | `libsx/uxpython/uxpython.bas:25` |
| `PythonAddPath` | `(session AS U64, pathValue AS STRING)` | I32 | ✓ | `libsx/uxpython/uxpython.bas:29` |
| `PythonError` | `(session AS U64)` | STRING | ✓ | `libsx/uxpython/uxpython.bas:33` |
| `PythonRuntimeVersion` | `(session AS U64)` | STRING | ✓ | `libsx/uxpython/uxpython.bas:37` |
| `PythonImport` | `(session AS U64, moduleName AS STRING)` | U64 | ✓ | `libsx/uxpython/uxpython.bas:41` |
| `PythonGet` | `(session AS U64, objectHandle AS U64, attributeName AS STRING)` | U64 | ✓ | `libsx/uxpython/uxpython.bas:45` |
| `PythonCall` | `(session AS U64, callableHandle AS U64, argsJson AS STRING, kwargsJson AS STRING)` | U64 | ✓ | `libsx/uxpython/uxpython.bas:49` |
| `PythonCallModule` | `(session AS U64, moduleName AS STRING, functionName AS STRING, argsJson AS STRING, kwargsJson AS STRING)` | U64 | ✓ | `libsx/uxpython/uxpython.bas:53` |
| `PythonInt` | `(session AS U64, objectHandle AS U64)` | I64 | ✓ | `libsx/uxpython/uxpython.bas:57` |
| `PythonFloat` | `(session AS U64, objectHandle AS U64)` | F64 | ✓ | `libsx/uxpython/uxpython.bas:61` |
| `PythonString` | `(session AS U64, objectHandle AS U64)` | STRING | ✓ | `libsx/uxpython/uxpython.bas:65` |
| `PythonJson` | `(session AS U64, objectHandle AS U64)` | STRING | ✓ | `libsx/uxpython/uxpython.bas:69` |
| `PythonRelease` | `(session AS U64, objectHandle AS U64)` | I32 | ✓ | `libsx/uxpython/uxpython.bas:73` |
| `PythonShutdown` | `()` | I32 | ✓ | `libsx/uxpython/uxpython.bas:77` |

## uxraylib

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxraylib.AdapterVersion` | `()` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:16` |
| `uxraylib.RaylibVersion` | `()` | STRING | ✓ | `libsx/uxraylib/uxraylib.bas:19` |
| `uxraylib.RayguiVersion` | `()` | STRING | ✓ | `libsx/uxraylib/uxraylib.bas:22` |
| `uxraylib.RectangleArea` | `(width AS F64, height AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib.bas:25` |
| `uxraylib.ColorRGBA` | `(r AS I32, g AS I32, b AS I32, a AS I32)` | U32 | ✓ | `libsx/uxraylib/uxraylib.bas:28` |
| `uxraylib.InitWindow` | `(width AS I32, height AS I32, title AS STRING)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:31` |
| `uxraylib.WindowShouldClose` | `()` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:34` |
| `uxraylib.WindowReady` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:37` |
| `uxraylib.SetTargetFPS` | `(fps AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:40` |
| `uxraylib.FrameTime` | `()` | F64 | ✓ | `libsx/uxraylib/uxraylib.bas:43` |
| `uxraylib.KeyDown` | `(key AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:46` |
| `uxraylib.KeyPressed` | `(key AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:49` |
| `uxraylib.BeginDrawing` | `()` |  | ✓ | `libsx/uxraylib/uxraylib.bas:52` |
| `uxraylib.EndDrawing` | `()` |  | ✓ | `libsx/uxraylib/uxraylib.bas:55` |
| `uxraylib.ClearBackground` | `(r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:58` |
| `uxraylib.DrawText` | `(text AS STRING, x AS I32, y AS I32, fontSize AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:61` |
| `uxraylib.DrawCircle` | `(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:64` |
| `uxraylib.DrawRectangle` | `(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:67` |
| `uxraylib.CircleCollision` | `(ax AS F64, ay AS F64, ar AS F64, bx AS F64, by AS F64, br AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:70` |
| `uxraylib.LoadTexture` | `(path AS STRING)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:73` |
| `uxraylib.TextureWidth` | `(handle AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:76` |
| `uxraylib.TextureHeight` | `(handle AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:79` |
| `uxraylib.UnloadTexture` | `(handle AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:82` |
| `uxraylib.LoadFont` | `(path AS STRING)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:85` |
| `uxraylib.DrawFont` | `(handle AS I32, text AS STRING, x AS F64, y AS F64, size AS F64, spacing AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:88` |
| `uxraylib.UnloadFont` | `(handle AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:91` |
| `uxraylib.SetCameraScroll` | `(x AS F64, y AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:94` |
| `uxraylib.DrawSprite` | `(handle AS I32, sourceX AS F64, sourceY AS F64, sourceWidth AS F64, sourceHeight AS F64, worldX AS F64, worldY AS F64, scale AS F64, rotation AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:97` |
| `uxraylib.RectCollision` | `(ax AS F64, ay AS F64, aw AS F64, ah AS F64, bx AS F64, by AS F64, bw AS F64, bh AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:100` |
| `uxraylib.SpriteFrame` | `(frame AS I32, frameCount AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:103` |
| `uxraylib.GuiButton` | `(x AS F64, y AS F64, width AS F64, height AS F64, text AS STRING)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:106` |
| `uxraylib.InitAudio` | `()` |  | ✓ | `libsx/uxraylib/uxraylib.bas:109` |
| `uxraylib.AudioReady` | `()` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:112` |
| `uxraylib.CloseAudio` | `()` |  | ✓ | `libsx/uxraylib/uxraylib.bas:115` |
| `uxraylib.CloseWindow` | `()` |  | ✓ | `libsx/uxraylib/uxraylib.bas:118` |
| `uxraylib.IsWindowFullscreen` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:123` |
| `uxraylib.IsWindowFocused` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:126` |
| `uxraylib.IsWindowResized` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:129` |
| `uxraylib.IsWindowMinimized` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:132` |
| `uxraylib.IsWindowMaximized` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:135` |
| `uxraylib.ToggleFullscreen` | `()` |  |  | `libsx/uxraylib/uxraylib.bas:138` |
| `uxraylib.SetWindowTitle` | `(title AS STRING)` |  |  | `libsx/uxraylib/uxraylib.bas:141` |
| `uxraylib.SetWindowSize` | `(width AS I32, height AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:144` |
| `uxraylib.SetWindowPosition` | `(x AS I32, y AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:147` |
| `uxraylib.SetWindowMinSize` | `(width AS I32, height AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:150` |
| `uxraylib.GetScreenWidth` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:153` |
| `uxraylib.GetScreenHeight` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:156` |
| `uxraylib.GetFPS` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:159` |
| `uxraylib.GetTime` | `()` | F64 |  | `libsx/uxraylib/uxraylib.bas:162` |
| `uxraylib.SetConfigFlags` | `(flags AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:165` |
| `uxraylib.TakeScreenshot` | `(fileName AS STRING)` |  |  | `libsx/uxraylib/uxraylib.bas:168` |
| `uxraylib.WaitTime` | `(seconds AS F64)` |  |  | `libsx/uxraylib/uxraylib.bas:171` |
| `uxraylib.ShowCursor` | `()` |  |  | `libsx/uxraylib/uxraylib.bas:176` |
| `uxraylib.HideCursor` | `()` |  |  | `libsx/uxraylib/uxraylib.bas:179` |
| `uxraylib.IsCursorHidden` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:182` |
| `uxraylib.EnableCursor` | `()` |  |  | `libsx/uxraylib/uxraylib.bas:185` |
| `uxraylib.DisableCursor` | `()` |  |  | `libsx/uxraylib/uxraylib.bas:188` |
| `uxraylib.SetRandomSeed` | `(seed AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:193` |
| `uxraylib.GetRandomValue` | `(minVal AS I32, maxVal AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:196` |
| `uxraylib.KeyReleased` | `(key AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:201` |
| `uxraylib.KeyUp` | `(key AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:204` |
| `uxraylib.GetKeyPressed` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:207` |
| `uxraylib.GetCharPressed` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:210` |
| `uxraylib.SetExitKey` | `(key AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:213` |
| `uxraylib.MouseButtonPressed` | `(button AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:218` |
| `uxraylib.MouseButtonDown` | `(button AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:221` |
| `uxraylib.MouseButtonReleased` | `(button AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:224` |
| `uxraylib.MouseButtonUp` | `(button AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:227` |
| `uxraylib.GetMouseX` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:230` |
| `uxraylib.GetMouseY` | `()` | I32 |  | `libsx/uxraylib/uxraylib.bas:233` |
| `uxraylib.SetMousePosition` | `(x AS I32, y AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:236` |
| `uxraylib.GetMouseWheelMove` | `()` | F64 |  | `libsx/uxraylib/uxraylib.bas:239` |
| `uxraylib.DrawPixel` | `(x AS I32, y AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:244` |
| `uxraylib.DrawLine` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, thick AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:247` |
| `uxraylib.DrawCircleLines` | `(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:250` |
| `uxraylib.DrawCircleGradient` | `(x AS F64, y AS F64, radius AS F64, color1 AS U32, color2 AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:254` |
| `uxraylib.DrawEllipse` | `(x AS F64, y AS F64, radiusH AS F64, radiusV AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:257` |
| `uxraylib.DrawEllipseLines` | `(x AS F64, y AS F64, radiusH AS F64, radiusV AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:260` |
| `uxraylib.DrawRectangleLines` | `(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:263` |
| `uxraylib.DrawRectangleRounded` | `(x AS F64, y AS F64, width AS F64, height AS F64, roundness AS F64, segments AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:266` |
| `uxraylib.DrawRectangleGradientV` | `(x AS F64, y AS F64, width AS F64, height AS F64, color1 AS U32, color2 AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:270` |
| `uxraylib.DrawRectangleGradientH` | `(x AS F64, y AS F64, width AS F64, height AS F64, color1 AS U32, color2 AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:273` |
| `uxraylib.DrawTriangle` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:276` |
| `uxraylib.DrawTriangleLines` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:279` |
| `uxraylib.DrawPoly` | `(x AS F64, y AS F64, sides AS I32, radius AS F64, rotation AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:282` |
| `uxraylib.DrawPolyLines` | `(x AS F64, y AS F64, sides AS I32, radius AS F64, rotation AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:285` |
| `uxraylib.CollisionCircleRec` | `(cx AS F64, cy AS F64, radius AS F64, rx AS F64, ry AS F64, rw AS F64, rh AS F64)` | I32 |  | `libsx/uxraylib/uxraylib.bas:290` |
| `uxraylib.CollisionPointRec` | `(px AS F64, py AS F64, rx AS F64, ry AS F64, rw AS F64, rh AS F64)` | I32 |  | `libsx/uxraylib/uxraylib.bas:293` |
| `uxraylib.CollisionPointCircle` | `(px AS F64, py AS F64, cx AS F64, cy AS F64, radius AS F64)` | I32 |  | `libsx/uxraylib/uxraylib.bas:296` |
| `uxraylib.CollisionPointTriangle` | `(px AS F64, py AS F64, x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64)` | I32 |  | `libsx/uxraylib/uxraylib.bas:299` |
| `uxraylib.MeasureText` | `(text AS STRING, fontSize AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:304` |
| `uxraylib.DrawFPS` | `(x AS I32, y AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:307` |
| `uxraylib.TextureValid` | `(handle AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:312` |
| `uxraylib.DrawTexture` | `(handle AS I32, x AS F64, y AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:315` |
| `uxraylib.DrawTextureEx` | `(handle AS I32, x AS F64, y AS F64, rotation AS F64, scale AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:318` |
| `uxraylib.LoadSound` | `(path AS STRING)` | I32 |  | `libsx/uxraylib/uxraylib.bas:323` |
| `uxraylib.PlaySound` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:326` |
| `uxraylib.StopSound` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:329` |
| `uxraylib.PauseSound` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:332` |
| `uxraylib.ResumeSound` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:335` |
| `uxraylib.SoundPlaying` | `(handle AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:338` |
| `uxraylib.SetSoundVolume` | `(handle AS I32, volume AS F64)` |  |  | `libsx/uxraylib/uxraylib.bas:341` |
| `uxraylib.SetSoundPitch` | `(handle AS I32, pitch AS F64)` |  |  | `libsx/uxraylib/uxraylib.bas:344` |
| `uxraylib.UnloadSound` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:347` |
| `uxraylib.LoadMusicStream` | `(path AS STRING)` | I32 |  | `libsx/uxraylib/uxraylib.bas:352` |
| `uxraylib.PlayMusicStream` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:355` |
| `uxraylib.UpdateMusicStream` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:358` |
| `uxraylib.StopMusicStream` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:361` |
| `uxraylib.PauseMusicStream` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:364` |
| `uxraylib.ResumeMusicStream` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:367` |
| `uxraylib.MusicStreamPlaying` | `(handle AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:370` |
| `uxraylib.SetMusicVolume` | `(handle AS I32, volume AS F64)` |  |  | `libsx/uxraylib/uxraylib.bas:373` |
| `uxraylib.GetMusicTimePlayed` | `(handle AS I32)` | F64 |  | `libsx/uxraylib/uxraylib.bas:376` |
| `uxraylib.GetMusicTimeLength` | `(handle AS I32)` | F64 |  | `libsx/uxraylib/uxraylib.bas:379` |
| `uxraylib.UnloadMusicStream` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:382` |
| `uxraylib.SetMasterVolume` | `(volume AS F64)` |  |  | `libsx/uxraylib/uxraylib.bas:385` |
| `uxraylib.LoadRenderTexture` | `(width AS I32, height AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:390` |
| `uxraylib.RenderTextureValid` | `(handle AS I32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:393` |
| `uxraylib.UnloadRenderTexture` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:396` |
| `uxraylib.BeginTextureMode` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:399` |
| `uxraylib.EndTextureMode` | `()` |  |  | `libsx/uxraylib/uxraylib.bas:402` |
| `uxraylib.DrawRenderTexture` | `(handle AS I32, x AS F64, y AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:405` |
| `uxraylib.TextureSetFilter` | `(handle AS I32, filter AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:410` |
| `uxraylib.TextureSetWrap` | `(handle AS I32, wrap AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:413` |
| `uxraylib.TextureGenMipmaps` | `(handle AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:416` |
| `uxraylib.DrawTextureRec` | `(handle AS I32, srcX AS F64, srcY AS F64, srcW AS F64, srcH AS F64, x AS F64, y AS F64, rgba AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:420` |
| `uxraylib.DrawTexturePro` | `(handle AS I32, srcX AS F64, srcY AS F64, srcW AS F64, srcH AS F64, dstX AS F64, dstY AS F64, scale AS F64, rotation AS F64, rgba AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:425` |
| `uxraylib.ColorFade` | `(rgba AS U32, alpha AS F64)` | U32 |  | `libsx/uxraylib/uxraylib.bas:430` |
| `uxraylib.ColorAlpha` | `(rgba AS U32, alpha AS F64)` | U32 |  | `libsx/uxraylib/uxraylib.bas:433` |
| `uxraylib.ColorBrightness` | `(rgba AS U32, factor AS F64)` | U32 |  | `libsx/uxraylib/uxraylib.bas:436` |
| `uxraylib.ColorContrast` | `(rgba AS U32, contrast AS F64)` | U32 |  | `libsx/uxraylib/uxraylib.bas:439` |
| `uxraylib.ColorLerp` | `(color1 AS U32, color2 AS U32, factor AS F64)` | U32 |  | `libsx/uxraylib/uxraylib.bas:442` |
| `uxraylib.ColorIsEqual` | `(color1 AS U32, color2 AS U32)` | I32 |  | `libsx/uxraylib/uxraylib.bas:445` |
| `uxraylib.GetColor` | `(hexValue AS U32)` | U32 |  | `libsx/uxraylib/uxraylib.bas:448` |
| `uxraylib.FileExists` | `(fileName AS STRING)` | I32 |  | `libsx/uxraylib/uxraylib.bas:453` |
| `uxraylib.DirectoryExists` | `(dirPath AS STRING)` | I32 |  | `libsx/uxraylib/uxraylib.bas:456` |
| `uxraylib.GetFileExtension` | `(fileName AS STRING)` | STRING |  | `libsx/uxraylib/uxraylib.bas:459` |
| `uxraylib.GetFileNameOnly` | `(filePath AS STRING)` | STRING |  | `libsx/uxraylib/uxraylib.bas:462` |
| `uxraylib.GetWorkingDirectory` | `()` | STRING |  | `libsx/uxraylib/uxraylib.bas:465` |
| `uxraylib.SetTextLineSpacing` | `(spacing AS I32)` |  |  | `libsx/uxraylib/uxraylib.bas:470` |
| `uxraylib.BeginMode2D` | `(offsetX AS F64, offsetY AS F64, targetX AS F64, targetY AS F64, rotation AS F64, zoom AS F64)` |  |  | `libsx/uxraylib/uxraylib.bas:475` |
| `uxraylib.EndMode2D` | `()` |  |  | `libsx/uxraylib/uxraylib.bas:478` |
| `uxraylib.DrawRing` | `(x AS F64, y AS F64, innerRadius AS F64, outerRadius AS F64, startAngle AS F64, endAngle AS F64, segments AS I32, rgba AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:484` |
| `uxraylib.DrawLineBezier` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, thick AS F64, rgba AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:487` |
| `uxraylib.ImageGenColor` | `(width AS I32, height AS I32, rgba AS U32)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:493` |
| `uxraylib.ImageGenChecked` | `(width AS I32, height AS I32, checksX AS I32, checksY AS I32, color1 AS U32, color2 AS U32)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:496` |
| `uxraylib.ImageGenGradientLinear` | `(width AS I32, height AS I32, direction AS I32, startColor AS U32, endColor AS U32)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:499` |
| `uxraylib.ImageLoad` | `(path AS STRING)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:502` |
| `uxraylib.ImageCopy` | `(image AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:505` |
| `uxraylib.ImageUnload` | `(image AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:508` |
| `uxraylib.ImageValid` | `(image AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:511` |
| `uxraylib.ImageWidth` | `(image AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:514` |
| `uxraylib.ImageHeight` | `(image AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:517` |
| `uxraylib.ImagePixelFormat` | `(image AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:520` |
| `uxraylib.ImageGetColor` | `(image AS I32, x AS I32, y AS I32)` | U32 | ✓ | `libsx/uxraylib/uxraylib.bas:523` |
| `uxraylib.ImageClearBackground` | `(image AS I32, rgba AS U32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:526` |
| `uxraylib.ImageDrawPixel` | `(image AS I32, x AS I32, y AS I32, rgba AS U32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:529` |
| `uxraylib.ImageDrawLine` | `(image AS I32, x1 AS I32, y1 AS I32, x2 AS I32, y2 AS I32, rgba AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:532` |
| `uxraylib.ImageDrawCircle` | `(image AS I32, centerX AS I32, centerY AS I32, radius AS I32, rgba AS U32)` |  |  | `libsx/uxraylib/uxraylib.bas:535` |
| `uxraylib.ImageDrawRectangle` | `(image AS I32, x AS I32, y AS I32, width AS I32, height AS I32, rgba AS U32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:538` |
| `uxraylib.ImageResize` | `(image AS I32, width AS I32, height AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:541` |
| `uxraylib.ImageResizeNN` | `(image AS I32, width AS I32, height AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:544` |
| `uxraylib.ImageCrop` | `(image AS I32, x AS I32, y AS I32, width AS I32, height AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:547` |
| `uxraylib.ImageFlipVertical` | `(image AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:550` |
| `uxraylib.ImageFlipHorizontal` | `(image AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:553` |
| `uxraylib.ImageRotateCW` | `(image AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:556` |
| `uxraylib.ImageRotateCCW` | `(image AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:559` |
| `uxraylib.ImageColorInvert` | `(image AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:562` |
| `uxraylib.ImageColorGrayscale` | `(image AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:565` |
| `uxraylib.ImageColorContrast` | `(image AS I32, contrast AS F64)` |  |  | `libsx/uxraylib/uxraylib.bas:568` |
| `uxraylib.ImageColorBrightness` | `(image AS I32, brightness AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:571` |
| `uxraylib.ImageColorTint` | `(image AS I32, rgba AS U32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:574` |
| `uxraylib.ImageConvertFormat` | `(image AS I32, newFormat AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib.bas:577` |
| `uxraylib.ImageExport` | `(image AS I32, path AS STRING)` | I32 | ✓ | `libsx/uxraylib/uxraylib.bas:580` |
| `uxraylib.GuiLabel` | `(x AS F64, y AS F64, width AS F64, height AS F64, text AS STRING)` |  |  | `libsx/uxraylib/uxraylib.bas:585` |
| `uxraylib.CheckCollisionSpheres` | `(c1x AS F64, c1y AS F64, c1z AS F64, r1 AS F64, c2x AS F64, c2y AS F64, c2z AS F64, r2 AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:8` |
| `uxraylib.CheckCollisionBoxesSlots` | `(min1 AS I32, max1 AS I32, min2 AS I32, max2 AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:11` |
| `uxraylib.CheckCollisionBoxSphereSlots` | `(minSlot AS I32, maxSlot AS I32, cx AS F64, cy AS F64, cz AS F64, radius AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:14` |
| `uxraylib.RayCollisionSphereSlots` | `(posSlot AS I32, dirSlot AS I32, cx AS F64, cy AS F64, cz AS F64, radius AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:17` |
| `uxraylib.RayCollisionBoxSlots` | `(posSlot AS I32, dirSlot AS I32, minSlot AS I32, maxSlot AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:20` |
| `uxraylib.RayCollisionTriangleSlots` | `(posSlot AS I32, dirSlot AS I32, p1 AS I32, p2 AS I32, p3 AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:23` |
| `uxraylib.RayCollisionQuadSlots` | `(posSlot AS I32, dirSlot AS I32, p1 AS I32, p2 AS I32, p3 AS I32, p4 AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:26` |
| `uxraylib.RayHit` | `()` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:29` |
| `uxraylib.RayDistance` | `()` | F64 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:32` |
| `uxraylib.RayPoint` | `(component AS I32)` | F64 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:36` |
| `uxraylib.RayNormal` | `(component AS I32)` | F64 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:39` |
| `uxraylib.CameraCreate` | `(posSlot AS I32, targetSlot AS I32, upSlot AS I32, fovy AS F64, projection AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:43` |
| `uxraylib.CameraRelease` | `(handle AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:46` |
| `uxraylib.CameraValid` | `(handle AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:49` |
| `uxraylib.CameraGet` | `(handle AS I32, part AS I32, component AS I32)` | F64 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:53` |
| `uxraylib.CameraSet` | `(handle AS I32, part AS I32, x AS F64, y AS F64, z AS F64)` |  |  | `libsx/uxraylib/uxraylib_3d_cpu.bas:56` |
| `uxraylib.CameraUpdatePro` | `(handle AS I32, moveForward AS F64, moveRight AS F64, moveUp AS F64, yaw AS F64, pitch AS F64, roll AS F64, zoom AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:60` |
| `uxraylib.CameraMatrix` | `(handle AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:64` |
| `uxraylib.WorldToScreen` | `(handle AS I32, px AS F64, py AS F64, pz AS F64, width AS I32, height AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:68` |
| `uxraylib.ScreenToWorldRay` | `(handle AS I32, sx AS F64, sy AS F64, width AS I32, height AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib_3d_cpu.bas:72` |
| `uxraylib.Clamp` | `(value AS F64, minValue AS F64, maxValue AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:6` |
| `uxraylib.Lerp` | `(begin AS F64, finish AS F64, amount AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:9` |
| `uxraylib.Normalize` | `(value AS F64, begin AS F64, finish AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:12` |
| `uxraylib.Remap` | `(value AS F64, inputStart AS F64, inputEnd AS F64, outputStart AS F64, outputEnd AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:15` |
| `uxraylib.Wrap` | `(value AS F64, minValue AS F64, maxValue AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:18` |
| `uxraylib.FloatEquals` | `(x AS F64, y AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:21` |
| `uxraylib.Vector2Zero` | `()` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:24` |
| `uxraylib.Vector2One` | `()` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:27` |
| `uxraylib.Vector2Add` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:30` |
| `uxraylib.Vector2AddValue` | `(vx AS F64, vy AS F64, addend AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:33` |
| `uxraylib.Vector2Subtract` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:36` |
| `uxraylib.Vector2SubtractValue` | `(vx AS F64, vy AS F64, amount AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:39` |
| `uxraylib.Vector2Length` | `(vx AS F64, vy AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:42` |
| `uxraylib.Vector2LengthSqr` | `(vx AS F64, vy AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:45` |
| `uxraylib.Vector2DotProduct` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:48` |
| `uxraylib.Vector2Distance` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:51` |
| `uxraylib.Vector2DistanceSqr` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` | F64 |  | `libsx/uxraylib/uxraylib_math.bas:54` |
| `uxraylib.Vector2Angle` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:57` |
| `uxraylib.Vector2LineAngle` | `(beginx AS F64, beginy AS F64, finishx AS F64, finishy AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:60` |
| `uxraylib.Vector2Scale` | `(vx AS F64, vy AS F64, scale AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:63` |
| `uxraylib.Vector2Multiply` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:66` |
| `uxraylib.Vector2Negate` | `(vx AS F64, vy AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:69` |
| `uxraylib.Vector2Divide` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:72` |
| `uxraylib.Vector2Normalize` | `(vx AS F64, vy AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:75` |
| `uxraylib.Vector2Transform` | `(vx AS F64, vy AS F64, matrix AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:78` |
| `uxraylib.Vector2Lerp` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64, amount AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:81` |
| `uxraylib.Vector2Reflect` | `(vx AS F64, vy AS F64, normalx AS F64, normaly AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:84` |
| `uxraylib.Vector2Min` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:87` |
| `uxraylib.Vector2Max` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:90` |
| `uxraylib.Vector2Rotate` | `(vx AS F64, vy AS F64, angle AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:93` |
| `uxraylib.Vector2MoveTowards` | `(vx AS F64, vy AS F64, targetx AS F64, targety AS F64, maxDistance AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:96` |
| `uxraylib.Vector2Invert` | `(vx AS F64, vy AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:99` |
| `uxraylib.Vector2Clamp` | `(vx AS F64, vy AS F64, minValuex AS F64, minValuey AS F64, maxValuex AS F64, maxValuey AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:102` |
| `uxraylib.Vector2ClampValue` | `(vx AS F64, vy AS F64, minValue AS F64, maxValue AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:105` |
| `uxraylib.Vector2Equals` | `(px AS F64, py AS F64, qx AS F64, qy AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:108` |
| `uxraylib.Vector2Refract` | `(vx AS F64, vy AS F64, nx AS F64, ny AS F64, r AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:111` |
| `uxraylib.Vector3Zero` | `()` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:114` |
| `uxraylib.Vector3One` | `()` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:117` |
| `uxraylib.Vector3Add` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:120` |
| `uxraylib.Vector3AddValue` | `(vx AS F64, vy AS F64, vz AS F64, addend AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:123` |
| `uxraylib.Vector3Subtract` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:126` |
| `uxraylib.Vector3SubtractValue` | `(vx AS F64, vy AS F64, vz AS F64, amount AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:129` |
| `uxraylib.Vector3Scale` | `(vx AS F64, vy AS F64, vz AS F64, scalar AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:132` |
| `uxraylib.Vector3Multiply` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:135` |
| `uxraylib.Vector3CrossProduct` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:138` |
| `uxraylib.Vector3Perpendicular` | `(vx AS F64, vy AS F64, vz AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:141` |
| `uxraylib.Vector3Length` | `(vx AS F64, vy AS F64, vz AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:144` |
| `uxraylib.Vector3LengthSqr` | `(vx AS F64, vy AS F64, vz AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:147` |
| `uxraylib.Vector3DotProduct` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:150` |
| `uxraylib.Vector3Distance` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:153` |
| `uxraylib.Vector3DistanceSqr` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` | F64 |  | `libsx/uxraylib/uxraylib_math.bas:156` |
| `uxraylib.Vector3Angle` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:159` |
| `uxraylib.Vector3Negate` | `(vx AS F64, vy AS F64, vz AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:162` |
| `uxraylib.Vector3Divide` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:165` |
| `uxraylib.Vector3Normalize` | `(vx AS F64, vy AS F64, vz AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:168` |
| `uxraylib.Vector3Project` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:171` |
| `uxraylib.Vector3Reject` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:174` |
| `uxraylib.Vector3Transform` | `(vx AS F64, vy AS F64, vz AS F64, matrix AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:177` |
| `uxraylib.Vector3RotateByQuaternion` | `(vx AS F64, vy AS F64, vz AS F64, qx AS F64, qy AS F64, qz AS F64, qw AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:180` |
| `uxraylib.Vector3RotateByAxisAngle` | `(vx AS F64, vy AS F64, vz AS F64, axisx AS F64, axisy AS F64, axisz AS F64, angle AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:183` |
| `uxraylib.Vector3MoveTowards` | `(vx AS F64, vy AS F64, vz AS F64, targetx AS F64, targety AS F64, targetz AS F64, maxDistance AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:186` |
| `uxraylib.Vector3Lerp` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64, amount AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:189` |
| `uxraylib.Vector3Reflect` | `(vx AS F64, vy AS F64, vz AS F64, normalx AS F64, normaly AS F64, normalz AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:192` |
| `uxraylib.Vector3Min` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:195` |
| `uxraylib.Vector3Max` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:198` |
| `uxraylib.Vector3Unproject` | `(sourcex AS F64, sourcey AS F64, sourcez AS F64, projection AS I32, view AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:201` |
| `uxraylib.Vector3Invert` | `(vx AS F64, vy AS F64, vz AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:204` |
| `uxraylib.Vector3Clamp` | `(vx AS F64, vy AS F64, vz AS F64, minValuex AS F64, minValuey AS F64, minValuez AS F64, maxValuex AS F64, maxValuey AS F64, maxValuez AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:207` |
| `uxraylib.Vector3ClampValue` | `(vx AS F64, vy AS F64, vz AS F64, minValue AS F64, maxValue AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:210` |
| `uxraylib.Vector3Equals` | `(px AS F64, py AS F64, pz AS F64, qx AS F64, qy AS F64, qz AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:213` |
| `uxraylib.Vector3Refract` | `(vx AS F64, vy AS F64, vz AS F64, nx AS F64, ny AS F64, nz AS F64, r AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:216` |
| `uxraylib.Vector4Zero` | `()` |  |  | `libsx/uxraylib/uxraylib_math.bas:219` |
| `uxraylib.Vector4One` | `()` |  |  | `libsx/uxraylib/uxraylib_math.bas:222` |
| `uxraylib.Vector4Add` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:225` |
| `uxraylib.Vector4AddValue` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64, addend AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:228` |
| `uxraylib.Vector4Subtract` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:231` |
| `uxraylib.Vector4SubtractValue` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64, addend AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:234` |
| `uxraylib.Vector4Length` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:237` |
| `uxraylib.Vector4LengthSqr` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64)` | F64 |  | `libsx/uxraylib/uxraylib_math.bas:240` |
| `uxraylib.Vector4DotProduct` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:243` |
| `uxraylib.Vector4Distance` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` | F64 |  | `libsx/uxraylib/uxraylib_math.bas:246` |
| `uxraylib.Vector4DistanceSqr` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` | F64 |  | `libsx/uxraylib/uxraylib_math.bas:249` |
| `uxraylib.Vector4Scale` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64, scale AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:252` |
| `uxraylib.Vector4Multiply` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:255` |
| `uxraylib.Vector4Negate` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:258` |
| `uxraylib.Vector4Divide` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:261` |
| `uxraylib.Vector4Normalize` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:264` |
| `uxraylib.Vector4Min` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:267` |
| `uxraylib.Vector4Max` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:270` |
| `uxraylib.Vector4Lerp` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64, amount AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:273` |
| `uxraylib.Vector4MoveTowards` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64, targetx AS F64, targety AS F64, targetz AS F64, targetw AS F64, maxDistance AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:276` |
| `uxraylib.Vector4Invert` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:279` |
| `uxraylib.Vector4Equals` | `(px AS F64, py AS F64, pz AS F64, pw AS F64, qx AS F64, qy AS F64, qz AS F64, qw AS F64)` | I32 |  | `libsx/uxraylib/uxraylib_math.bas:282` |
| `uxraylib.MatrixDeterminant` | `(matrix AS I32)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:285` |
| `uxraylib.MatrixTrace` | `(matrix AS I32)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:288` |
| `uxraylib.MatrixTranspose` | `(matrix AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:291` |
| `uxraylib.MatrixInvert` | `(matrix AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:294` |
| `uxraylib.MatrixIdentity` | `()` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:297` |
| `uxraylib.MatrixAdd` | `(leftEdge AS I32, rightEdge AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:300` |
| `uxraylib.MatrixSubtract` | `(leftEdge AS I32, rightEdge AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:303` |
| `uxraylib.MatrixMultiply` | `(leftEdge AS I32, rightEdge AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:306` |
| `uxraylib.MatrixTranslate` | `(x AS F64, y AS F64, z AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:309` |
| `uxraylib.MatrixRotate` | `(axisx AS F64, axisy AS F64, axisz AS F64, angle AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:312` |
| `uxraylib.MatrixRotateX` | `(angle AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:315` |
| `uxraylib.MatrixRotateY` | `(angle AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:318` |
| `uxraylib.MatrixRotateZ` | `(angle AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:321` |
| `uxraylib.MatrixRotateXYZ` | `(anglex AS F64, angley AS F64, anglez AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:324` |
| `uxraylib.MatrixRotateZYX` | `(anglex AS F64, angley AS F64, anglez AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:327` |
| `uxraylib.MatrixScale` | `(x AS F64, y AS F64, z AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:330` |
| `uxraylib.MatrixFrustum` | `(leftEdge AS F64, rightEdge AS F64, bottomEdge AS F64, topEdge AS F64, nearPlane AS F64, farPlane AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:333` |
| `uxraylib.MatrixPerspective` | `(fovY AS F64, aspect AS F64, nearPlane AS F64, farPlane AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:336` |
| `uxraylib.MatrixOrtho` | `(leftEdge AS F64, rightEdge AS F64, bottomEdge AS F64, topEdge AS F64, nearPlane AS F64, farPlane AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:339` |
| `uxraylib.MatrixLookAt` | `(eyex AS F64, eyey AS F64, eyez AS F64, targetx AS F64, targety AS F64, targetz AS F64, upx AS F64, upy AS F64, upz AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:342` |
| `uxraylib.QuaternionAdd` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:345` |
| `uxraylib.QuaternionAddValue` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64, addend AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:348` |
| `uxraylib.QuaternionSubtract` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:351` |
| `uxraylib.QuaternionSubtractValue` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64, amount AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:354` |
| `uxraylib.QuaternionIdentity` | `()` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:357` |
| `uxraylib.QuaternionLength` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math.bas:360` |
| `uxraylib.QuaternionNormalize` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:363` |
| `uxraylib.QuaternionInvert` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:366` |
| `uxraylib.QuaternionMultiply` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:369` |
| `uxraylib.QuaternionScale` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64, factor AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:372` |
| `uxraylib.QuaternionDivide` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:375` |
| `uxraylib.QuaternionLerp` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64, amount AS F64)` |  |  | `libsx/uxraylib/uxraylib_math.bas:378` |
| `uxraylib.QuaternionNlerp` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64, amount AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:381` |
| `uxraylib.QuaternionSlerp` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64, amount AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:384` |
| `uxraylib.QuaternionFromVector3ToVector3` | `(fromVecx AS F64, fromVecy AS F64, fromVecz AS F64, toVecx AS F64, toVecy AS F64, toVecz AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:387` |
| `uxraylib.QuaternionFromMatrix` | `(matrix AS I32)` |  |  | `libsx/uxraylib/uxraylib_math.bas:390` |
| `uxraylib.QuaternionToMatrix` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math.bas:393` |
| `uxraylib.QuaternionFromAxisAngle` | `(axisx AS F64, axisy AS F64, axisz AS F64, angle AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:396` |
| `uxraylib.QuaternionFromEuler` | `(pitch AS F64, yaw AS F64, roll AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:399` |
| `uxraylib.QuaternionToEuler` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:402` |
| `uxraylib.QuaternionTransform` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64, matrix AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib_math.bas:405` |
| `uxraylib.QuaternionEquals` | `(px AS F64, py AS F64, pz AS F64, pw AS F64, qx AS F64, qy AS F64, qz AS F64, qw AS F64)` | I32 |  | `libsx/uxraylib/uxraylib_math.bas:408` |
| `uxraylib.ResGet` | `(reg AS I32, component AS I32)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:12` |
| `uxraylib.ResX` | `()` | F64 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:15` |
| `uxraylib.ResY` | `()` | F64 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:18` |
| `uxraylib.ResZ` | `()` | F64 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:21` |
| `uxraylib.ResW` | `()` | F64 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:24` |
| `uxraylib.VectorSlotSet` | `(slotIndex AS I32, x AS F64, y AS F64, z AS F64, w AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:29` |
| `uxraylib.MathLastError` | `()` | I32 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:33` |
| `uxraylib.MathClearError` | `()` |  | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:36` |
| `uxraylib.MatrixRelease` | `(handle AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:40` |
| `uxraylib.MatrixLiveCount` | `()` | I32 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:43` |
| `uxraylib.MatrixCopy` | `(handle AS I32)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:46` |
| `uxraylib.MatrixElement` | `(handle AS I32, index AS I32)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:49` |
| `uxraylib.MatrixSetElement` | `(handle AS I32, index AS I32, value AS F64)` | I32 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:52` |
| `uxraylib.MatrixAt` | `(handle AS I32, row AS I32, col AS I32)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:56` |
| `uxraylib.Vector3OrthoNormalize` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:61` |
| `uxraylib.QuaternionToAxisAngle` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` | F64 | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:65` |
| `uxraylib.MatrixDecompose` | `(handle AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:69` |
| `uxraylib.Vector3CubicHermiteSlots` | `(v1Slot AS I32, tangent1Slot AS I32, v2Slot AS I32, tangent2Slot AS I32, amount AS F64)` |  | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:74` |
| `uxraylib.Vector3BarycenterSlots` | `(pSlot AS I32, aSlot AS I32, bSlot AS I32, cSlot AS I32)` |  | ✓ | `libsx/uxraylib/uxraylib_math_core.bas:77` |
| `uxraylib.QuaternionCubicHermiteSplineSlots` | `(q1Slot AS I32, outTangent1Slot AS I32, q2Slot AS I32, inTangent2Slot AS I32, t AS F64)` |  |  | `libsx/uxraylib/uxraylib_math_core.bas:80` |

## uxraylib_s100

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxraylib.AdapterVersion` | `()` | I32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:16` |
| `uxraylib.RaylibVersion` | `()` | STRING | ✓ | `libsx/uxraylib_s100/uxraylib.bas:19` |
| `uxraylib.RayguiVersion` | `()` | STRING | ✓ | `libsx/uxraylib_s100/uxraylib.bas:22` |
| `uxraylib.RectangleArea` | `(width AS F64, height AS F64)` | F64 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:25` |
| `uxraylib.ColorRGBA` | `(r AS I32, g AS I32, b AS I32, a AS I32)` | U32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:28` |
| `uxraylib.InitWindow` | `(width AS I32, height AS I32, title AS STRING)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:31` |
| `uxraylib.WindowShouldClose` | `()` | I32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:34` |
| `uxraylib.WindowReady` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:37` |
| `uxraylib.SetTargetFPS` | `(fps AS I32)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:40` |
| `uxraylib.FrameTime` | `()` | F64 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:43` |
| `uxraylib.KeyDown` | `(key AS I32)` | I32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:46` |
| `uxraylib.KeyPressed` | `(key AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:49` |
| `uxraylib.BeginDrawing` | `()` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:52` |
| `uxraylib.EndDrawing` | `()` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:55` |
| `uxraylib.ClearBackground` | `(r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:58` |
| `uxraylib.DrawText` | `(text AS STRING, x AS I32, y AS I32, fontSize AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:61` |
| `uxraylib.DrawCircle` | `(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:64` |
| `uxraylib.DrawRectangle` | `(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:67` |
| `uxraylib.CircleCollision` | `(ax AS F64, ay AS F64, ar AS F64, bx AS F64, by AS F64, br AS F64)` | I32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:70` |
| `uxraylib.LoadTexture` | `(path AS STRING)` | I32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:73` |
| `uxraylib.TextureWidth` | `(handle AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:76` |
| `uxraylib.TextureHeight` | `(handle AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:79` |
| `uxraylib.UnloadTexture` | `(handle AS I32)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:82` |
| `uxraylib.LoadFont` | `(path AS STRING)` | I32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:85` |
| `uxraylib.DrawFont` | `(handle AS I32, text AS STRING, x AS F64, y AS F64, size AS F64, spacing AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:88` |
| `uxraylib.UnloadFont` | `(handle AS I32)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:91` |
| `uxraylib.SetCameraScroll` | `(x AS F64, y AS F64)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:94` |
| `uxraylib.DrawSprite` | `(handle AS I32, sourceX AS F64, sourceY AS F64, sourceWidth AS F64, sourceHeight AS F64, worldX AS F64, worldY AS F64, scale AS F64, rotation AS F64)` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:97` |
| `uxraylib.RectCollision` | `(ax AS F64, ay AS F64, aw AS F64, ah AS F64, bx AS F64, by AS F64, bw AS F64, bh AS F64)` | I32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:100` |
| `uxraylib.SpriteFrame` | `(frame AS I32, frameCount AS I32)` | I32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:103` |
| `uxraylib.GuiButton` | `(x AS F64, y AS F64, width AS F64, height AS F64, text AS STRING)` | I32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:106` |
| `uxraylib.InitAudio` | `()` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:109` |
| `uxraylib.AudioReady` | `()` | I32 | ✓ | `libsx/uxraylib_s100/uxraylib.bas:112` |
| `uxraylib.CloseAudio` | `()` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:115` |
| `uxraylib.CloseWindow` | `()` |  | ✓ | `libsx/uxraylib_s100/uxraylib.bas:118` |
| `uxraylib.IsWindowFullscreen` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:123` |
| `uxraylib.IsWindowFocused` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:126` |
| `uxraylib.IsWindowResized` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:129` |
| `uxraylib.IsWindowMinimized` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:132` |
| `uxraylib.IsWindowMaximized` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:135` |
| `uxraylib.ToggleFullscreen` | `()` |  |  | `libsx/uxraylib_s100/uxraylib.bas:138` |
| `uxraylib.SetWindowTitle` | `(title AS STRING)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:141` |
| `uxraylib.SetWindowSize` | `(width AS I32, height AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:144` |
| `uxraylib.SetWindowPosition` | `(x AS I32, y AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:147` |
| `uxraylib.SetWindowMinSize` | `(width AS I32, height AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:150` |
| `uxraylib.GetScreenWidth` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:153` |
| `uxraylib.GetScreenHeight` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:156` |
| `uxraylib.GetFPS` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:159` |
| `uxraylib.GetTime` | `()` | F64 |  | `libsx/uxraylib_s100/uxraylib.bas:162` |
| `uxraylib.SetConfigFlags` | `(flags AS U32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:165` |
| `uxraylib.TakeScreenshot` | `(fileName AS STRING)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:168` |
| `uxraylib.WaitTime` | `(seconds AS F64)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:171` |
| `uxraylib.ShowCursor` | `()` |  |  | `libsx/uxraylib_s100/uxraylib.bas:176` |
| `uxraylib.HideCursor` | `()` |  |  | `libsx/uxraylib_s100/uxraylib.bas:179` |
| `uxraylib.IsCursorHidden` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:182` |
| `uxraylib.EnableCursor` | `()` |  |  | `libsx/uxraylib_s100/uxraylib.bas:185` |
| `uxraylib.DisableCursor` | `()` |  |  | `libsx/uxraylib_s100/uxraylib.bas:188` |
| `uxraylib.SetRandomSeed` | `(seed AS U32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:193` |
| `uxraylib.GetRandomValue` | `(minVal AS I32, maxVal AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:196` |
| `uxraylib.KeyReleased` | `(key AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:201` |
| `uxraylib.KeyUp` | `(key AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:204` |
| `uxraylib.GetKeyPressed` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:207` |
| `uxraylib.GetCharPressed` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:210` |
| `uxraylib.SetExitKey` | `(key AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:213` |
| `uxraylib.MouseButtonPressed` | `(button AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:218` |
| `uxraylib.MouseButtonDown` | `(button AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:221` |
| `uxraylib.MouseButtonReleased` | `(button AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:224` |
| `uxraylib.MouseButtonUp` | `(button AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:227` |
| `uxraylib.GetMouseX` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:230` |
| `uxraylib.GetMouseY` | `()` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:233` |
| `uxraylib.SetMousePosition` | `(x AS I32, y AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:236` |
| `uxraylib.GetMouseWheelMove` | `()` | F64 |  | `libsx/uxraylib_s100/uxraylib.bas:239` |
| `uxraylib.DrawPixel` | `(x AS I32, y AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:244` |
| `uxraylib.DrawLine` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, thick AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:247` |
| `uxraylib.DrawCircleLines` | `(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:250` |
| `uxraylib.DrawCircleGradient` | `(x AS F64, y AS F64, radius AS F64, color1 AS U32, color2 AS U32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:254` |
| `uxraylib.DrawEllipse` | `(x AS F64, y AS F64, radiusH AS F64, radiusV AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:257` |
| `uxraylib.DrawEllipseLines` | `(x AS F64, y AS F64, radiusH AS F64, radiusV AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:260` |
| `uxraylib.DrawRectangleLines` | `(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:263` |
| `uxraylib.DrawRectangleRounded` | `(x AS F64, y AS F64, width AS F64, height AS F64, roundness AS F64, segments AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:266` |
| `uxraylib.DrawRectangleGradientV` | `(x AS F64, y AS F64, width AS F64, height AS F64, color1 AS U32, color2 AS U32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:270` |
| `uxraylib.DrawRectangleGradientH` | `(x AS F64, y AS F64, width AS F64, height AS F64, color1 AS U32, color2 AS U32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:273` |
| `uxraylib.DrawTriangle` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:276` |
| `uxraylib.DrawTriangleLines` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:279` |
| `uxraylib.DrawPoly` | `(x AS F64, y AS F64, sides AS I32, radius AS F64, rotation AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:282` |
| `uxraylib.DrawPolyLines` | `(x AS F64, y AS F64, sides AS I32, radius AS F64, rotation AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:285` |
| `uxraylib.CollisionCircleRec` | `(cx AS F64, cy AS F64, radius AS F64, rx AS F64, ry AS F64, rw AS F64, rh AS F64)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:290` |
| `uxraylib.CollisionPointRec` | `(px AS F64, py AS F64, rx AS F64, ry AS F64, rw AS F64, rh AS F64)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:293` |
| `uxraylib.CollisionPointCircle` | `(px AS F64, py AS F64, cx AS F64, cy AS F64, radius AS F64)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:296` |
| `uxraylib.CollisionPointTriangle` | `(px AS F64, py AS F64, x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:299` |
| `uxraylib.MeasureText` | `(text AS STRING, fontSize AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:304` |
| `uxraylib.DrawFPS` | `(x AS I32, y AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:307` |
| `uxraylib.TextureValid` | `(handle AS I32)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:312` |
| `uxraylib.DrawTexture` | `(handle AS I32, x AS F64, y AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:315` |
| `uxraylib.DrawTextureEx` | `(handle AS I32, x AS F64, y AS F64, rotation AS F64, scale AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:318` |
| `uxraylib.LoadSound` | `(path AS STRING)` | I32 |  | `libsx/uxraylib_s100/uxraylib.bas:323` |
| `uxraylib.PlaySound` | `(handle AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:326` |
| `uxraylib.StopSound` | `(handle AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:329` |
| `uxraylib.PauseSound` | `(handle AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:332` |
| `uxraylib.ResumeSound` | `(handle AS I32)` |  |  | `libsx/uxraylib_s100/uxraylib.bas:335` |

## uxraylib_s60

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxraylib.AdapterVersion` | `()` | I32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:16` |
| `uxraylib.RaylibVersion` | `()` | STRING | ✓ | `libsx/uxraylib_s60/uxraylib.bas:19` |
| `uxraylib.RayguiVersion` | `()` | STRING | ✓ | `libsx/uxraylib_s60/uxraylib.bas:22` |
| `uxraylib.RectangleArea` | `(width AS F64, height AS F64)` | F64 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:25` |
| `uxraylib.ColorRGBA` | `(r AS I32, g AS I32, b AS I32, a AS I32)` | U32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:28` |
| `uxraylib.InitWindow` | `(width AS I32, height AS I32, title AS STRING)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:31` |
| `uxraylib.WindowShouldClose` | `()` | I32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:34` |
| `uxraylib.WindowReady` | `()` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:37` |
| `uxraylib.SetTargetFPS` | `(fps AS I32)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:40` |
| `uxraylib.FrameTime` | `()` | F64 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:43` |
| `uxraylib.KeyDown` | `(key AS I32)` | I32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:46` |
| `uxraylib.KeyPressed` | `(key AS I32)` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:49` |
| `uxraylib.BeginDrawing` | `()` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:52` |
| `uxraylib.EndDrawing` | `()` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:55` |
| `uxraylib.ClearBackground` | `(r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:58` |
| `uxraylib.DrawText` | `(text AS STRING, x AS I32, y AS I32, fontSize AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:61` |
| `uxraylib.DrawCircle` | `(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:64` |
| `uxraylib.DrawRectangle` | `(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:67` |
| `uxraylib.CircleCollision` | `(ax AS F64, ay AS F64, ar AS F64, bx AS F64, by AS F64, br AS F64)` | I32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:70` |
| `uxraylib.LoadTexture` | `(path AS STRING)` | I32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:73` |
| `uxraylib.TextureWidth` | `(handle AS I32)` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:76` |
| `uxraylib.TextureHeight` | `(handle AS I32)` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:79` |
| `uxraylib.UnloadTexture` | `(handle AS I32)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:82` |
| `uxraylib.LoadFont` | `(path AS STRING)` | I32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:85` |
| `uxraylib.DrawFont` | `(handle AS I32, text AS STRING, x AS F64, y AS F64, size AS F64, spacing AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:88` |
| `uxraylib.UnloadFont` | `(handle AS I32)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:91` |
| `uxraylib.SetCameraScroll` | `(x AS F64, y AS F64)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:94` |
| `uxraylib.DrawSprite` | `(handle AS I32, sourceX AS F64, sourceY AS F64, sourceWidth AS F64, sourceHeight AS F64, worldX AS F64, worldY AS F64, scale AS F64, rotation AS F64)` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:97` |
| `uxraylib.RectCollision` | `(ax AS F64, ay AS F64, aw AS F64, ah AS F64, bx AS F64, by AS F64, bw AS F64, bh AS F64)` | I32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:100` |
| `uxraylib.SpriteFrame` | `(frame AS I32, frameCount AS I32)` | I32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:103` |
| `uxraylib.GuiButton` | `(x AS F64, y AS F64, width AS F64, height AS F64, text AS STRING)` | I32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:106` |
| `uxraylib.InitAudio` | `()` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:109` |
| `uxraylib.AudioReady` | `()` | I32 | ✓ | `libsx/uxraylib_s60/uxraylib.bas:112` |
| `uxraylib.CloseAudio` | `()` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:115` |
| `uxraylib.CloseWindow` | `()` |  | ✓ | `libsx/uxraylib_s60/uxraylib.bas:118` |
| `uxraylib.IsWindowFullscreen` | `()` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:123` |
| `uxraylib.IsWindowFocused` | `()` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:126` |
| `uxraylib.IsWindowResized` | `()` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:129` |
| `uxraylib.IsWindowMinimized` | `()` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:132` |
| `uxraylib.IsWindowMaximized` | `()` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:135` |
| `uxraylib.ToggleFullscreen` | `()` |  |  | `libsx/uxraylib_s60/uxraylib.bas:138` |
| `uxraylib.SetWindowTitle` | `(title AS STRING)` |  |  | `libsx/uxraylib_s60/uxraylib.bas:141` |
| `uxraylib.SetWindowSize` | `(width AS I32, height AS I32)` |  |  | `libsx/uxraylib_s60/uxraylib.bas:144` |
| `uxraylib.SetWindowPosition` | `(x AS I32, y AS I32)` |  |  | `libsx/uxraylib_s60/uxraylib.bas:147` |
| `uxraylib.SetWindowMinSize` | `(width AS I32, height AS I32)` |  |  | `libsx/uxraylib_s60/uxraylib.bas:150` |
| `uxraylib.GetScreenWidth` | `()` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:153` |
| `uxraylib.GetScreenHeight` | `()` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:156` |
| `uxraylib.GetFPS` | `()` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:159` |
| `uxraylib.GetTime` | `()` | F64 |  | `libsx/uxraylib_s60/uxraylib.bas:162` |
| `uxraylib.SetConfigFlags` | `(flags AS U32)` |  |  | `libsx/uxraylib_s60/uxraylib.bas:165` |
| `uxraylib.TakeScreenshot` | `(fileName AS STRING)` |  |  | `libsx/uxraylib_s60/uxraylib.bas:168` |
| `uxraylib.WaitTime` | `(seconds AS F64)` |  |  | `libsx/uxraylib_s60/uxraylib.bas:171` |
| `uxraylib.ShowCursor` | `()` |  |  | `libsx/uxraylib_s60/uxraylib.bas:176` |
| `uxraylib.HideCursor` | `()` |  |  | `libsx/uxraylib_s60/uxraylib.bas:179` |
| `uxraylib.IsCursorHidden` | `()` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:182` |
| `uxraylib.EnableCursor` | `()` |  |  | `libsx/uxraylib_s60/uxraylib.bas:185` |
| `uxraylib.DisableCursor` | `()` |  |  | `libsx/uxraylib_s60/uxraylib.bas:188` |
| `uxraylib.SetRandomSeed` | `(seed AS U32)` |  |  | `libsx/uxraylib_s60/uxraylib.bas:193` |
| `uxraylib.GetRandomValue` | `(minVal AS I32, maxVal AS I32)` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:196` |
| `uxraylib.KeyReleased` | `(key AS I32)` | I32 |  | `libsx/uxraylib_s60/uxraylib.bas:201` |

## uxregex

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxregex.Version` | `()` | STRING |  | `libsx/uxregex/uxregex.bas:3` |
| `uxregex.Compile` | `(pattern AS STRING, options AS U32)` | U64 | ✓ | `libsx/uxregex/uxregex.bas:7` |
| `uxregex.Free` | `(regex AS U64)` |  | ✓ | `libsx/uxregex/uxregex.bas:11` |
| `uxregex.Match` | `(regex AS U64, subject AS STRING, startOffset AS U64, options AS U32)` | I32 | ✓ | `libsx/uxregex/uxregex.bas:15` |
| `uxregex.IsMatch` | `(regex AS U64, subject AS STRING)` | I32 | ✓ | `libsx/uxregex/uxregex.bas:19` |
| `uxregex.GroupCount` | `(regex AS U64)` | I32 | ✓ | `libsx/uxregex/uxregex.bas:23` |
| `uxregex.GroupStart` | `(regex AS U64, group AS I32)` | I64 | ✓ | `libsx/uxregex/uxregex.bas:27` |
| `uxregex.GroupEnd` | `(regex AS U64, group AS I32)` | I64 | ✓ | `libsx/uxregex/uxregex.bas:31` |
| `uxregex.GroupText` | `(regex AS U64, subject AS STRING, group AS I32)` | STRING | ✓ | `libsx/uxregex/uxregex.bas:35` |
| `uxregex.ErrorText` | `(regex AS U64)` | STRING | ✓ | `libsx/uxregex/uxregex.bas:39` |
| `uxregex.Version` | `()` | STRING |  | `libsx/uxregex/uxregex_easy.bas:3` |
| `uxregex.Compile` | `(pattern AS STRING, options AS U32)` | U64 | ✓ | `libsx/uxregex/uxregex_easy.bas:7` |
| `uxregex.Free` | `(regex AS U64)` |  | ✓ | `libsx/uxregex/uxregex_easy.bas:11` |
| `uxregex.Match` | `(regex AS U64, subject AS STRING, startOffset AS U64, options AS U32)` | I32 | ✓ | `libsx/uxregex/uxregex_easy.bas:15` |
| `uxregex.IsMatch` | `(regex AS U64, subject AS STRING)` | I32 | ✓ | `libsx/uxregex/uxregex_easy.bas:19` |
| `uxregex.GroupCount` | `(regex AS U64)` | I32 | ✓ | `libsx/uxregex/uxregex_easy.bas:23` |
| `uxregex.GroupStart` | `(regex AS U64, group AS I32)` | I64 | ✓ | `libsx/uxregex/uxregex_easy.bas:27` |
| `uxregex.GroupEnd` | `(regex AS U64, group AS I32)` | I64 | ✓ | `libsx/uxregex/uxregex_easy.bas:31` |
| `uxregex.GroupText` | `(regex AS U64, subject AS STRING, group AS I32)` | STRING | ✓ | `libsx/uxregex/uxregex_easy.bas:35` |
| `uxregex.ErrorText` | `(regex AS U64)` | STRING | ✓ | `libsx/uxregex/uxregex_easy.bas:39` |

## uxscalar_module

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxscalar_module.uxscalar_init` | `()` | I32 | ✓ | `libsx/uxscalar_module/uxscalar_module.bas:9` |
| `uxscalar_module.uxscalar_add` | `(leftValue AS I32, rightValue AS I32)` | I32 | ✓ | `libsx/uxscalar_module/uxscalar_module.bas:13` |
| `uxscalar_module.uxscalar_shutdown` | `()` | I32 | ✓ | `libsx/uxscalar_module/uxscalar_module.bas:17` |

## uxsdl3

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxsdl3.AdapterVersion` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:262` |
| `uxsdl3.RuntimeVersion` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:265` |
| `uxsdl3.Revision` | `()` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:268` |
| `uxsdl3.Init` | `(flags AS U32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:271` |
| `uxsdl3.Quit` | `()` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:274` |
| `uxsdl3.LastError` | `()` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:277` |
| `uxsdl3.CreateWindow` | `(title AS STRING, w AS I32, h AS I32, flags AS U64)` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:283` |
| `uxsdl3.DestroyWindow` | `(handle AS I64)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:286` |
| `uxsdl3.SetWindowTitle` | `(handle AS I64, title AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:289` |
| `uxsdl3.SetWindowSize` | `(handle AS I64, w AS I32, h AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:292` |
| `uxsdl3.GetWindowWidth` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:295` |
| `uxsdl3.GetWindowHeight` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:298` |
| `uxsdl3.ShowWindow` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:301` |
| `uxsdl3.HideWindow` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:304` |
| `uxsdl3.CreateRenderer` | `(windowHandle AS I64, name AS STRING)` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:309` |
| `uxsdl3.DestroyRenderer` | `(handle AS I64)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:312` |
| `uxsdl3.SetRenderDrawColor` | `(handle AS I64, r AS I32, g AS I32, b AS I32, a AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:315` |
| `uxsdl3.RenderClear` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:318` |
| `uxsdl3.RenderPresent` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:321` |
| `uxsdl3.RenderFillRect` | `(handle AS I64, x AS F64, y AS F64, w AS F64, h AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:324` |
| `uxsdl3.RenderRect` | `(handle AS I64, x AS F64, y AS F64, w AS F64, h AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:327` |
| `uxsdl3.RenderLine` | `(handle AS I64, x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:330` |
| `uxsdl3.RenderPoint` | `(handle AS I64, x AS F64, y AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:333` |
| `uxsdl3.PumpEvents` | `()` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:338` |
| `uxsdl3.ShouldQuit` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:341` |
| `uxsdl3.KeyDown` | `(scancode AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:344` |
| `uxsdl3.GetMouseX` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:347` |
| `uxsdl3.GetMouseY` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:350` |
| `uxsdl3.MouseButtonDown` | `(button AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:353` |
| `uxsdl3.GetTicks` | `()` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:358` |
| `uxsdl3.Delay` | `(ms AS I32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:361` |
| `uxsdl3.LoadTexture` | `(rendererHandle AS I64, bmpPath AS STRING)` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:366` |
| `uxsdl3.DestroyTexture` | `(handle AS I64)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:369` |
| `uxsdl3.GetTextureWidth` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:372` |
| `uxsdl3.GetTextureHeight` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:375` |
| `uxsdl3.RenderTexture` | `(rendererHandle AS I64, textureHandle AS I64, x AS F64, y AS F64, w AS F64, h AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:378` |
| `uxsdl3.WindowResized` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:383` |
| `uxsdl3.GetMouseWheelY` | `()` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:386` |
| `uxsdl3.LoadSound` | `(wavPath AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:393` |
| `uxsdl3.PlaySound` | `(handle AS I32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:396` |
| `uxsdl3.StopSound` | `(handle AS I32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:399` |
| `uxsdl3.UnloadSound` | `(handle AS I32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:402` |
| `uxsdl3.SetClipboardText` | `(txt AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:407` |
| `uxsdl3.GetClipboardText` | `()` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:410` |
| `uxsdl3.HasClipboardText` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:413` |
| `uxsdl3.StartTextInput` | `(winHandle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:418` |
| `uxsdl3.StopTextInput` | `(winHandle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:421` |
| `uxsdl3.TextInputActive` | `(winHandle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:424` |
| `uxsdl3.SetTextInputArea` | `(winHandle AS I64, x AS I32, y AS I32, w AS I32, h AS I32, cursor AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:428` |
| `uxsdl3.TakeTextInput` | `()` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:432` |
| `uxsdl3.PushTextInput` | `(txt AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:436` |
| `uxsdl3.GetScancodeName` | `(scancode AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:439` |
| `uxsdl3.GetModState` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:443` |
| `uxsdl3.JoystickCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:476` |
| `uxsdl3.JoystickIdAt` | `(idx AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:479` |
| `uxsdl3.OpenJoystick` | `(instanceId AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:482` |
| `uxsdl3.CloseJoystick` | `(handle AS I32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:485` |
| `uxsdl3.JoystickConnected` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:488` |
| `uxsdl3.JoystickName` | `(handle AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:491` |
| `uxsdl3.JoystickNumAxes` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:494` |
| `uxsdl3.JoystickNumButtons` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:497` |
| `uxsdl3.JoystickNumHats` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:500` |
| `uxsdl3.JoystickAxis` | `(handle AS I32, axis AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:504` |
| `uxsdl3.JoystickButton` | `(handle AS I32, button AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:507` |
| `uxsdl3.JoystickHat` | `(handle AS I32, hat AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:511` |
| `uxsdl3.GamepadCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:515` |
| `uxsdl3.GamepadIdAt` | `(idx AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:518` |
| `uxsdl3.IsGamepad` | `(instanceId AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:521` |
| `uxsdl3.OpenGamepad` | `(instanceId AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:524` |
| `uxsdl3.CloseGamepad` | `(handle AS I32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:527` |
| `uxsdl3.GamepadConnected` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:530` |
| `uxsdl3.GamepadInstanceId` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:533` |
| `uxsdl3.GamepadName` | `(handle AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:536` |
| `uxsdl3.GamepadVendor` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:539` |
| `uxsdl3.GamepadProduct` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:542` |
| `uxsdl3.GamepadButton` | `(handle AS I32, button AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:545` |
| `uxsdl3.GamepadAxis` | `(handle AS I32, axis AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:549` |
| `uxsdl3.GamepadAxisNorm` | `(handle AS I32, axis AS I32)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:553` |
| `uxsdl3.GamepadRumble` | `(handle AS I32, low AS I32, high AS I32, ms AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:557` |
| `uxsdl3.AttachVirtualJoystick` | `(axes AS I32, buttons AS I32, hats AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:563` |
| `uxsdl3.AttachVirtualGamepad` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:566` |
| `uxsdl3.DetachVirtual` | `(instanceId AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:569` |
| `uxsdl3.SetVirtualJoystickAxis` | `(handle AS I32, axis AS I32, value AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:572` |
| `uxsdl3.SetVirtualJoystickButton` | `(handle AS I32, button AS I32, down AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:575` |
| `uxsdl3.SetVirtualJoystickHat` | `(handle AS I32, hat AS I32, value AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:578` |
| `uxsdl3.SetVirtualGamepadAxis` | `(handle AS I32, axis AS I32, value AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:581` |
| `uxsdl3.SetVirtualGamepadButton` | `(handle AS I32, button AS I32, down AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:584` |
| `uxsdl3.ClearQuit` | `()` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:721` |
| `uxsdl3.WindowEvents` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:727` |
| `uxsdl3.GetMouseWheelX` | `()` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:730` |
| `uxsdl3.KeyPressed` | `(scancode AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:733` |
| `uxsdl3.KeyReleased` | `(scancode AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:736` |
| `uxsdl3.LastKey` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:739` |
| `uxsdl3.MouseButtonPressed` | `(button AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:742` |
| `uxsdl3.MouseButtonReleased` | `(button AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:745` |
| `uxsdl3.MouseRelX` | `()` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:748` |
| `uxsdl3.MouseRelY` | `()` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:751` |
| `uxsdl3.TakeDeviceEvents` | `(which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:756` |
| `uxsdl3.DropCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:760` |
| `uxsdl3.TakeDrop` | `()` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:763` |
| `uxsdl3.PushDrop` | `(text AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:767` |
| `uxsdl3.PushQuit` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:770` |
| `uxsdl3.PushKey` | `(scancode AS I32, down AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:773` |
| `uxsdl3.PushMouseButton` | `(button AS I32, down AS I32, x AS F64, y AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:776` |
| `uxsdl3.PushMouseMotion` | `(x AS F64, y AS F64, xrel AS F64, yrel AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:779` |
| `uxsdl3.PushMouseWheel` | `(x AS F64, y AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:782` |
| `uxsdl3.FlushEvents` | `()` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:785` |
| `uxsdl3.CreateTone` | `(freqHz AS I32, ms AS I32, volume AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:790` |
| `uxsdl3.PauseSound` | `(handle AS I32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:793` |
| `uxsdl3.ResumeSound` | `(handle AS I32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:796` |
| `uxsdl3.SaveSoundWAV` | `(handle AS I32, path AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:800` |
| `uxsdl3.IsSoundPlaying` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:803` |
| `uxsdl3.IsSoundPaused` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:806` |
| `uxsdl3.SetSoundLoop` | `(handle AS I32, looping AS I32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:809` |
| `uxsdl3.GetSoundLoop` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:812` |
| `uxsdl3.SetSoundVolume` | `(handle AS I32, volume AS F64)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:816` |
| `uxsdl3.GetSoundVolume` | `(handle AS I32)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:819` |
| `uxsdl3.SetMasterVolume` | `(volume AS F64)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:822` |
| `uxsdl3.GetMasterVolume` | `()` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:825` |
| `uxsdl3.SoundLengthMs` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:828` |
| `uxsdl3.SoundRemainingMs` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:831` |
| `uxsdl3.SoundFrequency` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:834` |
| `uxsdl3.SoundChannels` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:837` |
| `uxsdl3.AudioDeviceCount` | `(recording AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:840` |
| `uxsdl3.AudioDeviceName` | `(recording AS I32, index AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:843` |
| `uxsdl3.AudioDriverCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:846` |
| `uxsdl3.AudioDriverName` | `(index AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:849` |
| `uxsdl3.CurrentAudioDriver` | `()` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:852` |
| `uxsdl3.InitSubSystem` | `(flags AS U32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:855` |
| `uxsdl3.QuitSubSystem` | `(flags AS U32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:858` |
| `uxsdl3.WasInit` | `(flags AS U32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:861` |
| `uxsdl3.ClearError` | `()` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:864` |
| `uxsdl3.GetPlatform` | `()` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:867` |
| `uxsdl3.SetAppMetadata` | `(name AS STRING, version AS STRING, identifier AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:870` |
| `uxsdl3.GetAppMetadata` | `(which AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:874` |
| `uxsdl3.SetHint` | `(name AS STRING, value AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:877` |
| `uxsdl3.GetHint` | `(name AS STRING)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:880` |
| `uxsdl3.DisplayCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:883` |
| `uxsdl3.DisplayIdAt` | `(index AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:886` |
| `uxsdl3.PrimaryDisplay` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:889` |
| `uxsdl3.DisplayName` | `(displayId AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:892` |
| `uxsdl3.DisplayBounds` | `(displayId AS I32, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:896` |
| `uxsdl3.DisplayUsableBounds` | `(displayId AS I32, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:899` |
| `uxsdl3.DisplayMode` | `(displayId AS I32, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:903` |
| `uxsdl3.DisplayContentScale` | `(displayId AS I32)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:906` |
| `uxsdl3.DisplayOrientation` | `(displayId AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:909` |
| `uxsdl3.VideoDriverCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:912` |
| `uxsdl3.VideoDriverName` | `(index AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:915` |
| `uxsdl3.CurrentVideoDriver` | `()` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:918` |
| `uxsdl3.ScreensaverEnabled` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:921` |
| `uxsdl3.SetScreensaver` | `(enabled AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:924` |
| `uxsdl3.SystemTheme` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:927` |
| `uxsdl3.GetWindowTitle` | `(handle AS I64)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:930` |
| `uxsdl3.GetWindowPixelSize` | `(handle AS I64, which AS I32)` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:934` |
| `uxsdl3.SetWindowPosition` | `(handle AS I64, x AS I32, y AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:937` |
| `uxsdl3.GetWindowPosition` | `(handle AS I64, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:941` |
| `uxsdl3.SetWindowMinSize` | `(handle AS I64, w AS I32, h AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:944` |
| `uxsdl3.SetWindowMaxSize` | `(handle AS I64, w AS I32, h AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:947` |
| `uxsdl3.GetWindowMinSize` | `(handle AS I64, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:951` |
| `uxsdl3.GetWindowMaxSize` | `(handle AS I64, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:954` |
| `uxsdl3.SetWindowFullscreen` | `(handle AS I64, fullscreen AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:957` |
| `uxsdl3.GetWindowFlags` | `(handle AS I64)` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:960` |
| `uxsdl3.SetWindowBordered` | `(handle AS I64, bordered AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:963` |
| `uxsdl3.SetWindowResizable` | `(handle AS I64, resizable AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:966` |
| `uxsdl3.SetWindowAlwaysOnTop` | `(handle AS I64, onTop AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:969` |
| `uxsdl3.SetWindowFocusable` | `(handle AS I64, focusable AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:972` |
| `uxsdl3.MinimizeWindow` | `(handle AS I64)` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:975` |
| `uxsdl3.MaximizeWindow` | `(handle AS I64)` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:978` |
| `uxsdl3.RestoreWindow` | `(handle AS I64)` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:981` |
| `uxsdl3.RaiseWindow` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:984` |
| `uxsdl3.SyncWindow` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:988` |
| `uxsdl3.SetWindowOpacity` | `(handle AS I64, opacity AS F64)` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:991` |
| `uxsdl3.GetWindowOpacity` | `(handle AS I64)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:994` |
| `uxsdl3.WindowId` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:997` |
| `uxsdl3.WindowFromId` | `(id AS I32)` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1000` |
| `uxsdl3.WindowDisplay` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1003` |
| `uxsdl3.WindowDisplayScale` | `(handle AS I64)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1006` |
| `uxsdl3.WindowPixelDensity` | `(handle AS I64)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1009` |
| `uxsdl3.SetWindowMouseGrab` | `(handle AS I64, grabbed AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1012` |
| `uxsdl3.GetWindowMouseGrab` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1015` |
| `uxsdl3.SetWindowKeyboardGrab` | `(handle AS I64, grabbed AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1018` |
| `uxsdl3.GetWindowKeyboardGrab` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1021` |
| `uxsdl3.SetWindowRelativeMouse` | `(handle AS I64, enabled AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1024` |
| `uxsdl3.GetWindowRelativeMouse` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1027` |
| `uxsdl3.SetWindowIconBMP` | `(handle AS I64, bmpPath AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1030` |
| `uxsdl3.FlashWindow` | `(handle AS I64, operation AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1034` |
| `uxsdl3.ShowCursor` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1037` |
| `uxsdl3.HideCursor` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1040` |
| `uxsdl3.CursorVisible` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1043` |
| `uxsdl3.SetSystemCursor` | `(id AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1047` |
| `uxsdl3.WarpMouseInWindow` | `(handle AS I64, x AS F64, y AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1050` |
| `uxsdl3.WarpMouseGlobal` | `(x AS F64, y AS F64)` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:1053` |
| `uxsdl3.CaptureMouse` | `(enabled AS I32)` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:1056` |
| `uxsdl3.GlobalMouse` | `(which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1060` |
| `uxsdl3.HasMouse` | `()` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:1063` |
| `uxsdl3.HasKeyboard` | `()` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:1066` |
| `uxsdl3.MouseCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1069` |
| `uxsdl3.KeyboardCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1072` |
| `uxsdl3.ScancodeFromName` | `(name AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1075` |
| `uxsdl3.KeyFromScancode` | `(scancode AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1078` |
| `uxsdl3.ScancodeFromKey` | `(keycode AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1081` |
| `uxsdl3.KeyName` | `(keycode AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1084` |
| `uxsdl3.HasScreenKeyboard` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1087` |
| `uxsdl3.SetModState` | `(mods AS I32)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:1090` |
| `uxsdl3.RendererName` | `(handle AS I64)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1093` |
| `uxsdl3.RenderOutputSize` | `(handle AS I64, which AS I32)` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:1097` |
| `uxsdl3.GetRenderDrawColor` | `(handle AS I64, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1101` |
| `uxsdl3.SetRenderDrawBlendMode` | `(handle AS I64, mode AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1104` |
| `uxsdl3.GetRenderDrawBlendMode` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1108` |
| `uxsdl3.SetRenderViewport` | `(handle AS I64, x AS I32, y AS I32, w AS I32, h AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1111` |
| `uxsdl3.ResetRenderViewport` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1114` |
| `uxsdl3.GetRenderViewport` | `(handle AS I64, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1118` |
| `uxsdl3.SetRenderClipRect` | `(handle AS I64, x AS I32, y AS I32, w AS I32, h AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1121` |
| `uxsdl3.DisableRenderClip` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1124` |
| `uxsdl3.RenderClipEnabled` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1127` |
| `uxsdl3.GetRenderClipRect` | `(handle AS I64, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1131` |
| `uxsdl3.SetRenderScale` | `(handle AS I64, sx AS F64, sy AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1134` |
| `uxsdl3.GetRenderScale` | `(handle AS I64, which AS I32)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1138` |
| `uxsdl3.SetRenderLogicalPresentation` | `(handle AS I64, w AS I32, h AS I32, mode AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1142` |
| `uxsdl3.GetRenderLogicalSize` | `(handle AS I64, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1146` |
| `uxsdl3.GetRenderLogicalMode` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1149` |
| `uxsdl3.SetRenderVSync` | `(handle AS I64, vsync AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1152` |
| `uxsdl3.GetRenderVSync` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1156` |
| `uxsdl3.RenderCoordsFromWindow` | `(handle AS I64, wx AS F64, wy AS F64, which AS I32)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1160` |
| `uxsdl3.RenderCoordsToWindow` | `(handle AS I64, x AS F64, y AS F64, which AS I32)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1163` |
| `uxsdl3.RenderReadPixel` | `(handle AS I64, x AS I32, y AS I32)` | U32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1167` |
| `uxsdl3.RenderSaveBMP` | `(handle AS I64, path AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1171` |
| `uxsdl3.RenderDebugText` | `(handle AS I64, x AS F64, y AS F64, text AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1175` |
| `uxsdl3.SetRenderTarget` | `(handle AS I64, texture AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1179` |
| `uxsdl3.CreateTexture` | `(rendererHandle AS I64, w AS I32, h AS I32, access AS I32)` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1183` |
| `uxsdl3.TextureFill` | `(handle AS I64, rgba AS U32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1187` |
| `uxsdl3.TextureSetPixel` | `(handle AS I64, x AS I32, y AS I32, rgba AS U32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1191` |
| `uxsdl3.TextureSetColorMod` | `(handle AS I64, r AS I32, g AS I32, b AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1194` |
| `uxsdl3.TextureGetColorMod` | `(handle AS I64, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1198` |
| `uxsdl3.TextureSetAlphaMod` | `(handle AS I64, a AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1201` |
| `uxsdl3.TextureGetAlphaMod` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1204` |
| `uxsdl3.TextureSetBlendMode` | `(handle AS I64, mode AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1207` |
| `uxsdl3.TextureGetBlendMode` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1211` |
| `uxsdl3.TextureSetScaleMode` | `(handle AS I64, mode AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1214` |
| `uxsdl3.TextureGetScaleMode` | `(handle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1218` |
| `uxsdl3.RenderTextureRect` | `(rendererHandle AS I64, textureHandle AS I64, sx AS F64, sy AS F64, sw AS F64, sh AS F64, dx AS F64, dy AS F64, dw AS F64, dh AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1222` |
| `uxsdl3.RenderTextureRotated` | `(rendererHandle AS I64, textureHandle AS I64, dx AS F64, dy AS F64, dw AS F64, dh AS F64, angle AS F64, cx AS F64, cy AS F64, flipAndCenter AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1228` |
| `uxsdl3.RenderTextureFrame` | `(rendererHandle AS I64, textureHandle AS I64, frameW AS I32, frameH AS I32, frameIndex AS I32, dx AS F64, dy AS F64, dw AS F64, dh AS F64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1232` |
| `uxsdl3.GetTicksNS` | `()` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1235` |
| `uxsdl3.PerfCounter` | `()` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1238` |
| `uxsdl3.PerfFrequency` | `()` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1241` |
| `uxsdl3.DelayNS` | `(ns AS I64)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:1244` |
| `uxsdl3.DelayPreciseNS` | `(ns AS I64)` |  | ✓ | `libsx/uxsdl3/uxsdl3.bas:1247` |
| `uxsdl3.CurrentTimeNS` | `()` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1253` |
| `uxsdl3.DatePart` | `(ns AS I64, localTime AS I32, which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1256` |
| `uxsdl3.DaysInMonth` | `(year AS I32, month AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1260` |
| `uxsdl3.DayOfYear` | `(year AS I32, month AS I32, day AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1263` |
| `uxsdl3.BasePath` | `()` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1266` |
| `uxsdl3.PrefPath` | `(org AS STRING, app AS STRING)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1270` |
| `uxsdl3.CurrentDirectory` | `()` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1273` |
| `uxsdl3.CreateDirectory` | `(path AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1276` |
| `uxsdl3.PathType` | `(path AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1280` |
| `uxsdl3.PathSize` | `(path AS STRING)` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1283` |
| `uxsdl3.PathModifyTime` | `(path AS STRING)` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1287` |
| `uxsdl3.RemovePath` | `(path AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1291` |
| `uxsdl3.RenamePath` | `(oldPath AS STRING, newPath AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1294` |
| `uxsdl3.CopyFile` | `(oldPath AS STRING, newPath AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1297` |
| `uxsdl3.ListDirectory` | `(path AS STRING, pattern AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1303` |
| `uxsdl3.ListItem` | `(index AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1306` |
| `uxsdl3.CPUCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1309` |
| `uxsdl3.SystemRAMMB` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1312` |
| `uxsdl3.CPUCacheLineSize` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1315` |
| `uxsdl3.CPUFeature` | `(which AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1319` |
| `uxsdl3.IsTablet` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1322` |
| `uxsdl3.IsTV` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1325` |
| `uxsdl3.PowerState` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1329` |
| `uxsdl3.PowerSeconds` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1332` |
| `uxsdl3.PowerPercent` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1335` |
| `uxsdl3.LocaleCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1338` |
| `uxsdl3.LocaleLanguage` | `(index AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1341` |
| `uxsdl3.LocaleCountry` | `(index AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1344` |
| `uxsdl3.TouchDeviceCount` | `()` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1347` |
| `uxsdl3.TouchDeviceIdAt` | `(index AS I32)` | I64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1350` |
| `uxsdl3.TouchDeviceName` | `(id AS I64)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1353` |
| `uxsdl3.TouchDeviceType` | `(id AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1357` |
| `uxsdl3.TouchFingerCount` | `(id AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1360` |
| `uxsdl3.TouchFinger` | `(id AS I64, index AS I32, which AS I32)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1364` |
| `uxsdl3.JoystickNameForId` | `(instanceId AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1367` |
| `uxsdl3.GamepadNameForId` | `(instanceId AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1370` |
| `uxsdl3.JoystickVendorForId` | `(instanceId AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1373` |
| `uxsdl3.JoystickProductForId` | `(instanceId AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1376` |
| `uxsdl3.JoystickTypeForId` | `(instanceId AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1380` |
| `uxsdl3.JoystickInstanceId` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1383` |
| `uxsdl3.JoystickVendor` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1386` |
| `uxsdl3.JoystickProduct` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1389` |
| `uxsdl3.JoystickType` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1392` |
| `uxsdl3.JoystickGuid` | `(handle AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1396` |
| `uxsdl3.JoystickPlayerIndex` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1399` |
| `uxsdl3.JoystickSetPlayerIndex` | `(handle AS I32, index AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1402` |
| `uxsdl3.JoystickRumble` | `(handle AS I32, low AS I32, high AS I32, ms AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1405` |
| `uxsdl3.JoystickNumBalls` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1408` |
| `uxsdl3.JoystickBall` | `(handle AS I32, ballIndex AS I32, which AS I32)` | I32 |  | `libsx/uxsdl3/uxsdl3.bas:1412` |
| `uxsdl3.JoystickPowerState` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1416` |
| `uxsdl3.JoystickPowerPercent` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1419` |
| `uxsdl3.GamepadType` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1423` |
| `uxsdl3.GamepadTypeName` | `(kind AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1426` |
| `uxsdl3.GamepadPlayerIndex` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1429` |
| `uxsdl3.GamepadSetPlayerIndex` | `(handle AS I32, index AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1432` |
| `uxsdl3.GamepadSetLED` | `(handle AS I32, r AS I32, g AS I32, b AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1435` |
| `uxsdl3.GamepadPowerState` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1438` |
| `uxsdl3.GamepadPowerPercent` | `(handle AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1441` |
| `uxsdl3.GamepadRumbleTriggers` | `(handle AS I32, left AS I32, right AS I32, ms AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1444` |
| `uxsdl3.GamepadHasSensor` | `(handle AS I32, kind AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1448` |
| `uxsdl3.GamepadSetSensorEnabled` | `(handle AS I32, kind AS I32, enabled AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1451` |
| `uxsdl3.GamepadSensorEnabled` | `(handle AS I32, kind AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1454` |
| `uxsdl3.GamepadSensor` | `(handle AS I32, kind AS I32, index AS I32)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1458` |
| `uxsdl3.GamepadMapping` | `(handle AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1461` |
| `uxsdl3.AddGamepadMapping` | `(mapping AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1465` |
| `uxsdl3.GamepadButtonName` | `(button AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1468` |
| `uxsdl3.GamepadAxisName` | `(axis AS I32)` | STRING | ✓ | `libsx/uxsdl3/uxsdl3.bas:1471` |
| `uxsdl3.GamepadButtonFromName` | `(name AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1475` |
| `uxsdl3.GamepadAxisFromName` | `(name AS STRING)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1478` |
| `uxsdl3.GamepadButtonLabel` | `(handle AS I32, button AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1482` |
| `uxsdl3.GamepadAxisDeadZone` | `(handle AS I32, axis AS I32, deadZone AS F64)` | F64 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1487` |
| `uxsdl3.PackRGBA` | `(r AS I32, g AS I32, b AS I32, a AS I32)` | U32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1494` |
| `uxsdl3.UnpackR` | `(rgba AS U32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1502` |
| `uxsdl3.UnpackG` | `(rgba AS U32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1507` |
| `uxsdl3.UnpackB` | `(rgba AS U32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1512` |
| `uxsdl3.UnpackA` | `(rgba AS U32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1517` |
| `uxsdl3.HasWindowFlag` | `(winHandle AS I64, flag AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1523` |
| `uxsdl3.GetDisplayWidth` | `(displayId AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1527` |
| `uxsdl3.GetDisplayHeight` | `(displayId AS I32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1530` |
| `uxsdl3.GetWindowX` | `(winHandle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1533` |
| `uxsdl3.GetWindowY` | `(winHandle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1536` |
| `uxsdl3.GetWindowPixelWidth` | `(winHandle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1539` |
| `uxsdl3.GetWindowPixelHeight` | `(winHandle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1542` |
| `uxsdl3.RenderOutputWidth` | `(rendererHandle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1545` |
| `uxsdl3.RenderOutputHeight` | `(rendererHandle AS I64)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1548` |
| `uxsdl3.SetRenderDrawColorRGBA` | `(rendererHandle AS I64, rgba AS U32)` | I32 | ✓ | `libsx/uxsdl3/uxsdl3.bas:1552` |

## uxsqlite

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxsqlite.Version` | `()` | STRING |  | `libsx/uxsqlite/uxsqlite.bas:7` |
| `uxsqlite.Open` | `(path AS STRING)` | U64 | ✓ | `libsx/uxsqlite/uxsqlite.bas:11` |
| `uxsqlite.OpenMemory` | `()` | U64 | ✓ | `libsx/uxsqlite/uxsqlite.bas:15` |
| `uxsqlite.Close` | `(db AS U64)` |  | ✓ | `libsx/uxsqlite/uxsqlite.bas:19` |
| `uxsqlite.Exec` | `(db AS U64, sql AS STRING)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite.bas:23` |
| `uxsqlite.Prepare` | `(db AS U64, sql AS STRING)` | U64 | ✓ | `libsx/uxsqlite/uxsqlite.bas:27` |
| `uxsqlite.Finalize` | `(stmt AS U64)` |  | ✓ | `libsx/uxsqlite/uxsqlite.bas:31` |
| `uxsqlite.BindI64` | `(stmt AS U64, index1 AS I32, value AS I64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite.bas:35` |
| `uxsqlite.BindF64` | `(stmt AS U64, index1 AS I32, value AS F64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite.bas:39` |
| `uxsqlite.BindText` | `(stmt AS U64, index1 AS I32, value AS STRING)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite.bas:43` |
| `uxsqlite.Step` | `(stmt AS U64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite.bas:47` |
| `uxsqlite.Reset` | `(stmt AS U64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite.bas:51` |
| `uxsqlite.ColumnCount` | `(stmt AS U64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite.bas:55` |
| `uxsqlite.ColumnType` | `(stmt AS U64, column0 AS I32)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite.bas:59` |
| `uxsqlite.ColumnI64` | `(stmt AS U64, column0 AS I32)` | I64 | ✓ | `libsx/uxsqlite/uxsqlite.bas:63` |
| `uxsqlite.ColumnF64` | `(stmt AS U64, column0 AS I32)` | F64 | ✓ | `libsx/uxsqlite/uxsqlite.bas:67` |
| `uxsqlite.ColumnText` | `(stmt AS U64, column0 AS I32)` | STRING | ✓ | `libsx/uxsqlite/uxsqlite.bas:71` |
| `uxsqlite.LastInsertRowId` | `(db AS U64)` | I64 | ✓ | `libsx/uxsqlite/uxsqlite.bas:75` |
| `uxsqlite.Changes` | `(db AS U64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite.bas:79` |
| `uxsqlite.ErrorText` | `(db AS U64)` | STRING | ✓ | `libsx/uxsqlite/uxsqlite.bas:83` |
| `uxsqlite.Version` | `()` | STRING |  | `libsx/uxsqlite/uxsqlite_easy.bas:7` |
| `uxsqlite.Open` | `(path AS STRING)` | U64 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:11` |
| `uxsqlite.OpenMemory` | `()` | U64 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:15` |
| `uxsqlite.Close` | `(db AS U64)` |  | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:19` |
| `uxsqlite.Exec` | `(db AS U64, sql AS STRING)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:23` |
| `uxsqlite.Prepare` | `(db AS U64, sql AS STRING)` | U64 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:27` |
| `uxsqlite.Finalize` | `(stmt AS U64)` |  | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:31` |
| `uxsqlite.BindI64` | `(stmt AS U64, index1 AS I32, value AS I64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:35` |
| `uxsqlite.BindF64` | `(stmt AS U64, index1 AS I32, value AS F64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:39` |
| `uxsqlite.BindText` | `(stmt AS U64, index1 AS I32, value AS STRING)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:43` |
| `uxsqlite.Step` | `(stmt AS U64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:47` |
| `uxsqlite.Reset` | `(stmt AS U64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:51` |
| `uxsqlite.ColumnCount` | `(stmt AS U64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:55` |
| `uxsqlite.ColumnType` | `(stmt AS U64, column0 AS I32)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:59` |
| `uxsqlite.ColumnI64` | `(stmt AS U64, column0 AS I32)` | I64 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:63` |
| `uxsqlite.ColumnF64` | `(stmt AS U64, column0 AS I32)` | F64 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:67` |
| `uxsqlite.ColumnText` | `(stmt AS U64, column0 AS I32)` | STRING | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:71` |
| `uxsqlite.LastInsertRowId` | `(db AS U64)` | I64 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:75` |
| `uxsqlite.Changes` | `(db AS U64)` | I32 | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:79` |
| `uxsqlite.ErrorText` | `(db AS U64)` | STRING | ✓ | `libsx/uxsqlite/uxsqlite_easy.bas:83` |

## uxstats

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `UXSTATS_Version` | `()` | I32 | ✓ | `libsx/uxstats/uxstats.bas:15` |
| `UXSTATS_VecCreate` | `(capacity AS I32)` | U64 | ✓ | `libsx/uxstats/uxstats.bas:21` |
| `UXSTATS_VecFree` | `(h AS U64)` | I32 | ✓ | `libsx/uxstats/uxstats.bas:27` |
| `UXSTATS_VecClear` | `(h AS U64)` | I32 |  | `libsx/uxstats/uxstats.bas:32` |
| `UXSTATS_VecCount` | `(h AS U64)` | I32 | ✓ | `libsx/uxstats/uxstats.bas:37` |
| `UXSTATS_VecCapacity` | `(h AS U64)` | I32 |  | `libsx/uxstats/uxstats.bas:43` |
| `UXSTATS_VecPush` | `(h AS U64, value AS F64)` | I32 | ✓ | `libsx/uxstats/uxstats.bas:49` |
| `UXSTATS_VecSet` | `(h AS U64, index AS I32, value AS F64)` | I32 |  | `libsx/uxstats/uxstats.bas:55` |
| `UXSTATS_VecGet` | `(h AS U64, index AS I32)` | F64 |  | `libsx/uxstats/uxstats.bas:61` |
| `UXSTATS_Sum` | `(h AS U64)` | F64 |  | `libsx/uxstats/uxstats.bas:67` |
| `UXSTATS_Mean` | `(h AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats.bas:73` |
| `UXSTATS_Min` | `(h AS U64)` | F64 |  | `libsx/uxstats/uxstats.bas:79` |
| `UXSTATS_Max` | `(h AS U64)` | F64 |  | `libsx/uxstats/uxstats.bas:85` |
| `UXSTATS_Range` | `(h AS U64)` | F64 |  | `libsx/uxstats/uxstats.bas:91` |
| `UXSTATS_VariancePop` | `(h AS U64)` | F64 |  | `libsx/uxstats/uxstats.bas:97` |
| `UXSTATS_VarianceSamp` | `(h AS U64)` | F64 |  | `libsx/uxstats/uxstats.bas:103` |
| `UXSTATS_StdDevPop` | `(h AS U64)` | F64 |  | `libsx/uxstats/uxstats.bas:109` |
| `UXSTATS_StdDevSamp` | `(h AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats.bas:115` |
| `UXSTATS_Median` | `(h AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats.bas:121` |
| `UXSTATS_Percentile` | `(h AS U64, p AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats.bas:127` |
| `UXSTATS_CovarianceSamp` | `(x AS U64, y AS U64)` | F64 |  | `libsx/uxstats/uxstats.bas:133` |
| `UXSTATS_Correlation` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats.bas:139` |
| `UXSTATS_RegressionSlope` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats.bas:145` |
| `UXSTATS_RegressionIntercept` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats.bas:151` |
| `UXSTATS_RegressionR2` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats.bas:157` |
| `UXSTATS_RawMeanF64` | `(dataPtr AS U64, count AS I32)` | F64 |  | `libsx/uxstats/uxstats.bas:164` |
| `UXSTATS_RawStdDevSampF64` | `(dataPtr AS U64, count AS I32)` | F64 |  | `libsx/uxstats/uxstats.bas:170` |
| `UXSTATS2_Version` | `()` | I32 | ✓ | `libsx/uxstats/uxstats2.bas:15` |
| `UXSTATS2_VecCreate` | `(capacity AS I32)` | U64 | ✓ | `libsx/uxstats/uxstats2.bas:21` |
| `UXSTATS2_VecFree` | `(h AS U64)` | I32 | ✓ | `libsx/uxstats/uxstats2.bas:27` |
| `UXSTATS2_VecPush` | `(h AS U64, value AS F64)` | I32 | ✓ | `libsx/uxstats/uxstats2.bas:32` |
| `UXSTATS2_VecSet` | `(h AS U64, index AS I32, value AS F64)` | I32 | ✓ | `libsx/uxstats/uxstats2.bas:38` |
| `UXSTATS2_VecGet` | `(h AS U64, index AS I32)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:44` |
| `UXSTATS2_VecCount` | `(h AS U64)` | I32 | ✓ | `libsx/uxstats/uxstats2.bas:50` |
| `UXSTATS2_NormalCDF` | `(z AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:57` |
| `UXSTATS2_NormalP2` | `(z AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:63` |
| `UXSTATS2_TP2` | `(t AS F64, df AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:69` |
| `UXSTATS2_ChiSquareP` | `(stat AS F64, df AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:75` |
| `UXSTATS2_FP` | `(stat AS F64, df1 AS F64, df2 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:81` |
| `UXSTATS2_OneSampleTStat` | `(x AS U64, mu0 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:88` |
| `UXSTATS2_OneSampleTP` | `(x AS U64, mu0 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:94` |
| `UXSTATS2_WelchTStat` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:100` |
| `UXSTATS2_WelchTP` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:106` |
| `UXSTATS2_PooledTStat` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:112` |
| `UXSTATS2_PooledTP` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:118` |
| `UXSTATS2_PairedTStat` | `(before AS U64, after AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:124` |
| `UXSTATS2_PairedTP` | `(before AS U64, after AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:130` |
| `UXSTATS2_OneSampleZStat` | `(x AS U64, mu0 AS F64, sigma AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:137` |
| `UXSTATS2_OneSampleZP` | `(x AS U64, mu0 AS F64, sigma AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:143` |
| `UXSTATS2_TwoSampleZStat` | `(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:149` |
| `UXSTATS2_TwoSampleZP` | `(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:155` |
| `UXSTATS2_OnePropZStat` | `(successes AS I32, n AS I32, p0 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:161` |
| `UXSTATS2_OnePropZP` | `(successes AS I32, n AS I32, p0 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:167` |
| `UXSTATS2_TwoPropZStat` | `(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:173` |
| `UXSTATS2_TwoPropZP` | `(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:179` |
| `UXSTATS2_FVarianceStat` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:186` |
| `UXSTATS2_FVarianceP` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:192` |
| `UXSTATS2_ChiSquareGOFStat` | `(obs AS U64, expected AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:198` |
| `UXSTATS2_ChiSquareGOFP` | `(obs AS U64, expected AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:204` |
| `UXSTATS2_ChiSquare2x2Stat` | `(a AS F64, b AS F64, c AS F64, d AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:210` |
| `UXSTATS2_ChiSquare2x2P` | `(a AS F64, b AS F64, c AS F64, d AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:216` |
| `UXSTATS2_AnovaOneWayF` | `(values AS U64, groups AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:222` |
| `UXSTATS2_AnovaOneWayP` | `(values AS U64, groups AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:228` |
| `UXSTATS2_PosthocBonferroniTP` | `(values AS U64, groups AS U64, g1 AS F64, g2 AS F64, comparisons AS I32)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:234` |
| `UXSTATS2_PosthocTukeyQ` | `(values AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:240` |
| `UXSTATS2_PosthocScheffeF` | `(values AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:246` |
| `UXSTATS2_CovarianceSamp` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:253` |
| `UXSTATS2_Correlation` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:259` |
| `UXSTATS2_RegressionSlope` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:265` |
| `UXSTATS2_RegressionIntercept` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:271` |
| `UXSTATS2_RegressionR2` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:277` |
| `UXSTATS2_RegressionF` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:283` |
| `UXSTATS2_RegressionFP` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:289` |
| `UXSTATS2_VIFPair` | `(x AS U64, y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:295` |
| `UXSTATS2_DurbinWatson` | `(resid AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:301` |
| `UXSTATS2_BreuschGodfreyLM` | `(resid AS U64, lags AS I32)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:307` |
| `UXSTATS2_BreuschGodfreyP` | `(resid AS U64, lags AS I32)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:313` |
| `UXSTATS2_ADFStat` | `(y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:319` |
| `UXSTATS2_ADFP` | `(y AS U64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:325` |
| `UXSTATS2_AncovaBinaryF` | `(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:331` |
| `UXSTATS2_AncovaBinaryP` | `(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:337` |
| `UXSTATS2_HotellingT2_2D` | `(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:343` |
| `UXSTATS2_HotellingP_2D` | `(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ | `libsx/uxstats/uxstats2.bas:349` |

## uxsystem

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxsystem.Version` | `()` | STRING |  | `libsx/uxsystem/uxsystem.bas:6` |
| `uxsystem.ComputerName` | `()` | STRING | ✓ | `libsx/uxsystem/uxsystem.bas:10` |
| `uxsystem.UserName` | `()` | STRING | ✓ | `libsx/uxsystem/uxsystem.bas:14` |
| `uxsystem.WindowsDirectory` | `()` | STRING | ✓ | `libsx/uxsystem/uxsystem.bas:18` |
| `uxsystem.SystemDirectory` | `()` | STRING | ✓ | `libsx/uxsystem/uxsystem.bas:22` |
| `uxsystem.TempDirectory` | `()` | STRING | ✓ | `libsx/uxsystem/uxsystem.bas:26` |
| `uxsystem.CurrentDirectory` | `()` | STRING | ✓ | `libsx/uxsystem/uxsystem.bas:30` |
| `uxsystem.SetCurrentDirectory` | `(path AS STRING)` | I32 | ✓ | `libsx/uxsystem/uxsystem.bas:34` |
| `uxsystem.ExecutablePath` | `()` | STRING | ✓ | `libsx/uxsystem/uxsystem.bas:38` |
| `uxsystem.EnvironmentGet` | `(name AS STRING)` | STRING | ✓ | `libsx/uxsystem/uxsystem.bas:42` |
| `uxsystem.EnvironmentSet` | `(name AS STRING,value AS STRING)` | I32 | ✓ | `libsx/uxsystem/uxsystem.bas:46` |
| `uxsystem.EnvironmentDelete` | `(name AS STRING)` | I32 | ✓ | `libsx/uxsystem/uxsystem.bas:50` |
| `uxsystem.CpuCount` | `()` | I32 | ✓ | `libsx/uxsystem/uxsystem.bas:54` |
| `uxsystem.Architecture` | `()` | I32 | ✓ | `libsx/uxsystem/uxsystem.bas:58` |
| `uxsystem.MemoryTotal` | `()` | U64 | ✓ | `libsx/uxsystem/uxsystem.bas:62` |
| `uxsystem.MemoryAvailable` | `()` | U64 | ✓ | `libsx/uxsystem/uxsystem.bas:66` |
| `uxsystem.MemoryLoadPercent` | `()` | I32 | ✓ | `libsx/uxsystem/uxsystem.bas:70` |
| `uxsystem.Is64Bit` | `()` | I32 | ✓ | `libsx/uxsystem/uxsystem.bas:74` |
| `uxsystem.IsAdministrator` | `()` | I32 | ✓ | `libsx/uxsystem/uxsystem.bas:78` |
| `uxsystem.ProcessId` | `()` | U32 | ✓ | `libsx/uxsystem/uxsystem.bas:82` |
| `uxsystem.ThreadId` | `()` | U32 | ✓ | `libsx/uxsystem/uxsystem.bas:86` |
| `uxsystem.TickCountMs` | `()` | U64 | ✓ | `libsx/uxsystem/uxsystem.bas:90` |
| `uxsystem.ScreenWidth` | `()` | I32 | ✓ | `libsx/uxsystem/uxsystem.bas:94` |
| `uxsystem.ScreenHeight` | `()` | I32 | ✓ | `libsx/uxsystem/uxsystem.bas:98` |
| `uxsystem.ErrorText` | `()` | STRING | ✓ | `libsx/uxsystem/uxsystem.bas:102` |

## uxtensor

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxtensor.Version` | `()` | I32 |  | `libsx/uxtensor/uxtensor.bas:12` |
| `uxtensor.Backend` | `()` | STRING | ✓ | `libsx/uxtensor/uxtensor.bas:16` |
| `uxtensor.Create1D` | `(n AS I64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:20` |
| `uxtensor.Create2D` | `(rows AS I64, cols AS I64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:24` |
| `uxtensor.Create3D` | `(a AS I64, b AS I64, c AS I64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:28` |
| `uxtensor.Create4D` | `(a AS I64, b AS I64, c AS I64, d AS I64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:32` |
| `uxtensor.Free` | `(t AS U64)` |  | ✓ | `libsx/uxtensor/uxtensor.bas:36` |
| `uxtensor.Clone` | `(t AS U64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:40` |
| `uxtensor.SliceAxis0` | `(t AS U64, start AS I64, count AS I64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:44` |
| `uxtensor.DType` | `(t AS U64)` | I32 | ✓ | `libsx/uxtensor/uxtensor.bas:48` |
| `uxtensor.NDim` | `(t AS U64)` | I32 | ✓ | `libsx/uxtensor/uxtensor.bas:52` |
| `uxtensor.Dim` | `(t AS U64, axis AS I32)` | I64 | ✓ | `libsx/uxtensor/uxtensor.bas:56` |
| `uxtensor.Stride` | `(t AS U64, axis AS I32)` | I64 | ✓ | `libsx/uxtensor/uxtensor.bas:60` |
| `uxtensor.Size` | `(t AS U64)` | I64 | ✓ | `libsx/uxtensor/uxtensor.bas:64` |
| `uxtensor.ElemSize` | `(t AS U64)` | I64 | ✓ | `libsx/uxtensor/uxtensor.bas:68` |
| `uxtensor.DataPtr` | `(t AS U64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:72` |
| `uxtensor.Fill` | `(t AS U64, value AS F64)` |  | ✓ | `libsx/uxtensor/uxtensor.bas:76` |
| `uxtensor.Zero` | `(t AS U64)` |  | ✓ | `libsx/uxtensor/uxtensor.bas:80` |
| `uxtensor.GetFlat` | `(t AS U64, index AS I64)` | F64 | ✓ | `libsx/uxtensor/uxtensor.bas:84` |
| `uxtensor.SetFlat` | `(t AS U64, index AS I64, value AS F64)` |  | ✓ | `libsx/uxtensor/uxtensor.bas:88` |
| `uxtensor.Get2D` | `(t AS U64, r AS I64, c AS I64)` | F64 | ✓ | `libsx/uxtensor/uxtensor.bas:92` |
| `uxtensor.Set2D` | `(t AS U64, r AS I64, c AS I64, value AS F64)` |  | ✓ | `libsx/uxtensor/uxtensor.bas:96` |
| `uxtensor.Get3D` | `(t AS U64, a AS I64, b AS I64, c AS I64)` | F64 | ✓ | `libsx/uxtensor/uxtensor.bas:100` |
| `uxtensor.Set3D` | `(t AS U64, a AS I64, b AS I64, c AS I64, value AS F64)` |  | ✓ | `libsx/uxtensor/uxtensor.bas:104` |
| `uxtensor.Get4D` | `(t AS U64, a AS I64, b AS I64, c AS I64, d AS I64)` | F64 | ✓ | `libsx/uxtensor/uxtensor.bas:108` |
| `uxtensor.Set4D` | `(t AS U64, a AS I64, b AS I64, c AS I64, d AS I64, value AS F64)` |  | ✓ | `libsx/uxtensor/uxtensor.bas:112` |
| `uxtensor.Add` | `(a AS U64, b AS U64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:116` |
| `uxtensor.Subtract` | `(a AS U64, b AS U64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:120` |
| `uxtensor.Multiply` | `(a AS U64, b AS U64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:124` |
| `uxtensor.Divide` | `(a AS U64, b AS U64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:128` |
| `uxtensor.Scale` | `(a AS U64, scalar AS F64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:132` |
| `uxtensor.Sum` | `(a AS U64)` | F64 | ✓ | `libsx/uxtensor/uxtensor.bas:136` |
| `uxtensor.Mean` | `(a AS U64)` | F64 | ✓ | `libsx/uxtensor/uxtensor.bas:140` |
| `uxtensor.Dot` | `(a AS U64, b AS U64)` | F64 | ✓ | `libsx/uxtensor/uxtensor.bas:144` |
| `uxtensor.Norm2` | `(a AS U64)` | F64 | ✓ | `libsx/uxtensor/uxtensor.bas:148` |
| `uxtensor.MatMul` | `(a AS U64, b AS U64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:152` |
| `uxtensor.MatVec` | `(a AS U64, x AS U64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:156` |
| `uxtensor.Transpose2D` | `(a AS U64)` | U64 | ✓ | `libsx/uxtensor/uxtensor.bas:160` |

## uxterminal

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxterminal.Version` | `()` | I32 | ✓ | `libsx/uxterminal/uxterminal.bas:2` |
| `uxterminal.EnableAnsi` | `()` | I32 |  | `libsx/uxterminal/uxterminal.bas:5` |
| `uxterminal.Clear` | `()` |  |  | `libsx/uxterminal/uxterminal.bas:8` |
| `uxterminal.HideCursor` | `()` |  |  | `libsx/uxterminal/uxterminal.bas:11` |
| `uxterminal.ShowCursor` | `()` |  |  | `libsx/uxterminal/uxterminal.bas:14` |
| `uxterminal.SetScroll` | `(x AS I32, y AS I32)` |  |  | `libsx/uxterminal/uxterminal.bas:17` |
| `uxterminal.DrawText` | `(x AS I32, y AS I32, fg AS I32, bg AS I32, text AS STRING)` |  |  | `libsx/uxterminal/uxterminal.bas:20` |
| `uxterminal.DrawSprite` | `(x AS I32, y AS I32, fg AS I32, bg AS I32, sprite AS STRING)` |  |  | `libsx/uxterminal/uxterminal.bas:23` |
| `uxterminal.RectCollision` | `(ax AS I32, ay AS I32, aw AS I32, ah AS I32, bx AS I32, by AS I32, bw AS I32, bh AS I32)` | I32 | ✓ | `libsx/uxterminal/uxterminal.bas:26` |
| `uxterminal.GetWidth` | `()` | I32 |  | `libsx/uxterminal/uxterminal.bas:29` |
| `uxterminal.GetHeight` | `()` | I32 |  | `libsx/uxterminal/uxterminal.bas:32` |
| `uxterminal.KeyHit` | `()` | I32 |  | `libsx/uxterminal/uxterminal.bas:35` |
| `uxterminal.GetKey` | `()` | I32 |  | `libsx/uxterminal/uxterminal.bas:38` |
| `uxterminal.DrawCell` | `(x AS I32, y AS I32, fg AS I32, bg AS I32, ch AS I32)` |  |  | `libsx/uxterminal/uxterminal.bas:41` |
| `uxterminal.DrawHLine` | `(x AS I32, y AS I32, length AS I32, ch AS I32, fg AS I32, bg AS I32)` |  |  | `libsx/uxterminal/uxterminal.bas:44` |
| `uxterminal.DrawVLine` | `(x AS I32, y AS I32, length AS I32, ch AS I32, fg AS I32, bg AS I32)` |  |  | `libsx/uxterminal/uxterminal.bas:47` |
| `uxterminal.DrawBox` | `(x AS I32, y AS I32, w AS I32, h AS I32, fg AS I32, bg AS I32)` |  |  | `libsx/uxterminal/uxterminal.bas:50` |

## uxuuid

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `uxuuid.Version` | `()` | STRING |  | `libsx/uxuuid/uxuuid.bas:6` |
| `uxuuid.NewUuid` | `()` | STRING | ✓ | `libsx/uxuuid/uxuuid.bas:10` |
| `uxuuid.Nil` | `()` | STRING | ✓ | `libsx/uxuuid/uxuuid.bas:14` |
| `uxuuid.IsValid` | `(uuid AS STRING)` | I32 | ✓ | `libsx/uxuuid/uxuuid.bas:18` |
| `uxuuid.Normalize` | `(uuid AS STRING)` | STRING | ✓ | `libsx/uxuuid/uxuuid.bas:22` |
| `uxuuid.Equal` | `(a AS STRING,b AS STRING)` | I32 | ✓ | `libsx/uxuuid/uxuuid.bas:26` |
| `uxuuid.IsNil` | `(uuid AS STRING)` | I32 | ✓ | `libsx/uxuuid/uxuuid.bas:30` |
| `uxuuid.WithoutBraces` | `(uuid AS STRING)` | STRING | ✓ | `libsx/uxuuid/uxuuid.bas:34` |
| `uxuuid.ErrorText` | `()` | STRING | ✓ | `libsx/uxuuid/uxuuid.bas:38` |

## uxwasmrt

| Ad | Parametreler | Dönüş | Testte | Yer |
|---|---|---|---|---|
| `WasmRuntimeApiVersion` | `()` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:1` |
| `WasmProvider` | `()` | STRING | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:5` |
| `WasmRuntimeAvailable` | `()` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:9` |
| `WasmRuntimePath` | `()` | STRING | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:13` |
| `WasmValidateFile` | `(pathValue AS STRING)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:17` |
| `WasmOpenFile` | `(pathValue AS STRING)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:21` |
| `WasmClose` | `(sessionHandle AS I32)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:25` |
| `WasmHasExport` | `(sessionHandle AS I32, exportName AS STRING)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:29` |
| `WasmCallI32_0` | `(sessionHandle AS I32, exportName AS STRING)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:33` |
| `WasmCallI32_1` | `(sessionHandle AS I32, exportName AS STRING, a0 AS I32)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:37` |
| `WasmCallI32_2` | `(sessionHandle AS I32, exportName AS STRING, a0 AS I32, a1 AS I32)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:41` |
| `WasmCallI32_3` | `(sessionHandle AS I32, exportName AS STRING, a0 AS I32, a1 AS I32, a2 AS I32)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:45` |
| `WasmCallI32_4` | `(sessionHandle AS I32, exportName AS STRING, a0 AS I32, a1 AS I32, a2 AS I32, a3 AS I32)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:49` |
| `WasmLastOk` | `(sessionHandle AS I32)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:53` |
| `WasmLastErrorCode` | `(sessionHandle AS I32)` | I32 | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:57` |
| `WasmLastError` | `(sessionHandle AS I32)` | STRING | ✓ | `libsx/uxwasmrt/uxwasmrt.bas:61` |
