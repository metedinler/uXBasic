# uXBasic Dil Tanımı

_Üretim: 2026-09-28 23:20 — giriş bölümü (00_giris.md) henüz yazılmadı._

## İçindekiler

A. Ek A — Uygunluk tablosu
B. Ek B — Mete'nin kararını bekleyen konular
C. Ek C — Uyum hataları
D. Ek D — Kütüphane imza kataloğu
E. Ek E — Kapsam denetimi


---

# Ek A — Uygunluk tablosu

Her öğe: karar durumu ve motorlardaki GERÇEK çalıştırma sonucu (örnek dosyasının `sonuc.json` kaydından; kayıt yoksa bölüm yazarının beyanı). ✓ geçti · ≠ farklı çıktı · ✗ hata · · denenmedi.

Toplam **0** öğe; üç motorda da geçen **0**, en az bir motorda sorunlu ya da denenmemiş **0**.

| Bölüm | Öğe | Tür | Karar | Motorlar | Örnek | Sorun |
|---|---|---|---|---|---|---|

# Ek B — Mete'nin kararını bekleyen konular

ÖNERİ: kaynak sırasına göre önerilen kanon (onaylanınca KARARLI olur). KARAR GEREKİYOR: seçenekler bölümde.


## KARAR GEREKİYOR (0)


## ÖNERİ (0)


# Ek C — Uyum hataları

SORUN_TAKIP numaralarına göre etkilenen öğe sayısı:


Bölüm yazarlarının bulduğu, SORUN_TAKIP'e henüz işlenmemiş bulgular (0):


# Ek D — Kütüphane imza kataloğu

`tools/kitap/yuzey_tara.py` ile `libsx/` kaynağından otomatik çıkarılır. **Testte**: tam adı (`namespace.Ad`) `tests/` ya da `examples/` altındaki bir programda geçiyor.


## uxaimath  (uxaimath; 46 fonksiyon/sub, 1 sabit, testte çağrılan 45)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxaimath.Version` | `()` | I32 |  |
| `uxaimath.Backend` | `()` | STRING | ✓ |
| `uxaimath.Seed` | `(seed AS U64)` |  | ✓ |
| `uxaimath.Sigmoid` | `(x AS F64)` | F64 | ✓ |
| `uxaimath.ReLU` | `(x AS F64)` | F64 | ✓ |
| `uxaimath.LeakyReLU` | `(x AS F64, alpha AS F64)` | F64 | ✓ |
| `uxaimath.ELU` | `(x AS F64, alpha AS F64)` | F64 | ✓ |
| `uxaimath.GELU` | `(x AS F64)` | F64 | ✓ |
| `uxaimath.Swish` | `(x AS F64)` | F64 | ✓ |
| `uxaimath.Softplus` | `(x AS F64)` | F64 | ✓ |
| `uxaimath.ApplySigmoidPtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.ApplyTanhPtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.ApplyReLUPtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.ApplyLeakyReLUPtr` | `(dataPtr AS U64, n AS I64, alpha AS F64)` |  | ✓ |
| `uxaimath.ApplyELUPtr` | `(dataPtr AS U64, n AS I64, alpha AS F64)` |  | ✓ |
| `uxaimath.ApplyGELUPtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.ApplySwishPtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.SoftmaxPtr` | `(inputPtr AS U64, outputPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.SoftmaxInPlacePtr` | `(dataPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.TensorSigmoid` | `(t AS U64)` |  | ✓ |
| `uxaimath.TensorTanh` | `(t AS U64)` |  | ✓ |
| `uxaimath.TensorReLU` | `(t AS U64)` |  | ✓ |
| `uxaimath.TensorLeakyReLU` | `(t AS U64, alpha AS F64)` |  | ✓ |
| `uxaimath.TensorGELU` | `(t AS U64)` |  | ✓ |
| `uxaimath.TensorSoftmax` | `(src AS U64, dst AS U64)` |  | ✓ |
| `uxaimath.MSE` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64)` | F64 | ✓ |
| `uxaimath.MAE` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64)` | F64 | ✓ |
| `uxaimath.Huber` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64, delta AS F64)` | F64 | ✓ |
| `uxaimath.BinaryCrossEntropy` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64)` | F64 | ✓ |
| `uxaimath.CategoricalCrossEntropy` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64)` | F64 | ✓ |
| `uxaimath.MSEGrad` | `(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.BCEGrad` | `(yTruePtr AS U64, yPredPtr AS U64, outPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.FillZeros` | `(dataPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.FillOnes` | `(dataPtr AS U64, n AS I64)` |  | ✓ |
| `uxaimath.FillUniform` | `(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64)` |  | ✓ |
| `uxaimath.FillNormal` | `(dataPtr AS U64, n AS I64, mean AS F64, stddev AS F64)` |  | ✓ |
| `uxaimath.XavierUniform` | `(dataPtr AS U64, n AS I64, fanIn AS I64, fanOut AS I64)` |  | ✓ |
| `uxaimath.HeUniform` | `(dataPtr AS U64, n AS I64, fanIn AS I64)` |  | ✓ |
| `uxaimath.ClipValue` | `(dataPtr AS U64, n AS I64, lo AS F64, hi AS F64)` |  | ✓ |
| `uxaimath.ClipNorm` | `(dataPtr AS U64, n AS I64, maxNorm AS F64)` |  | ✓ |
| `uxaimath.SGDUpdate` | `(paramPtr AS U64, gradPtr AS U64, n AS I64, lr AS F64)` |  | ✓ |
| `uxaimath.MomentumUpdate` | `(paramPtr AS U64, gradPtr AS U64, velocityPtr AS U64, n AS I64, lr AS F64, momentum AS F64)` |  | ✓ |
| `uxaimath.DenseForward` | `(inputPtr AS U64, weightPtr AS U64, biasPtr AS U64, outputPtr AS U64, inN AS I64, outN AS I64)` |  | ✓ |
| `uxaimath.DenseBatchForward` | `(xPtr AS U64, weightPtr AS U64, biasPtr AS U64, yPtr AS U64, batch AS I64, inN AS I64, outN AS I64)` |  | ✓ |
| `uxaimath.ArgMax` | `(dataPtr AS U64, n AS I64)` | I64 | ✓ |
| `uxaimath.BinaryAccuracy` | `(yTruePtr AS U64, yPredPtr AS U64, n AS I64, threshold AS F64)` | F64 | ✓ |

## uxarchive  (uxarchive; 8 fonksiyon/sub, 0 sabit, testte çağrılan 6)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxarchive.Version` | `()` | STRING |  |
| `uxarchive.EntryCount` | `(path AS STRING)` | I64 | ✓ |
| `uxarchive.ExtractAll` | `(path AS STRING, destination AS STRING)` | I64 | ✓ |
| `uxarchive.ErrorText` | `()` | STRING | ✓ |
| `uxarchive.Version` | `()` | STRING |  |
| `uxarchive.EntryCount` | `(path AS STRING)` | I64 | ✓ |
| `uxarchive.ExtractAll` | `(path AS STRING, destination AS STRING)` | I64 | ✓ |
| `uxarchive.ErrorText` | `()` | STRING | ✓ |

## uxcapi  (uxcapi; 108 fonksiyon/sub, 17 sabit, testte çağrılan 101)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxcapi.Version` | `()` | I32 | ✓ |
| `uxcapi.LastError` | `()` | STRING | ✓ |
| `uxcapi.Shutdown` | `()` |  | ✓ |
| `uxcapi.SymbolAddress` | `(dllName AS STRING, symbolName AS STRING)` | U64 | ✓ |
| `uxcapi.TypeStructNew` | `()` | U64 | ✓ |
| `uxcapi.TypeUnionNew` | `(sizeBytes AS U64, alignmentBytes AS U32)` | U64 |  |
| `uxcapi.TypeAddField` | `(typeHandle AS U64, fieldKind AS I32)` | I32 | ✓ |
| `uxcapi.TypeAddStructField` | `(typeHandle AS U64, fieldTypeHandle AS U64)` | I32 |  |
| `uxcapi.TypeAddArrayField` | `(typeHandle AS U64, elementKind AS I32, elementCount AS U64)` | I32 |  |
| `uxcapi.TypeAddStructArrayField` | `(typeHandle AS U64, fieldTypeHandle AS U64, elementCount AS U64)` | I32 |  |
| `uxcapi.TypeSetExpectedLayout` | `(typeHandle AS U64, sizeBytes AS U64, alignmentBytes AS U32)` | I32 | ✓ |
| `uxcapi.TypeFinalize` | `(typeHandle AS U64)` | I32 | ✓ |
| `uxcapi.TypeKind` | `(typeHandle AS U64)` | I32 |  |
| `uxcapi.TypeSize` | `(typeHandle AS U64)` | U64 | ✓ |
| `uxcapi.TypeAlignment` | `(typeHandle AS U64)` | U32 | ✓ |
| `uxcapi.TypeFree` | `(typeHandle AS U64)` |  | ✓ |
| `uxcapi.CallNew` | `(dllName AS STRING, symbolName AS STRING, returnKind AS I32, isVariadic AS I32, fixedArgumentCount AS I32)` | U64 | ✓ |
| `uxcapi.CallFree` | `(callHandle AS U64)` |  | ✓ |
| `uxcapi.CallClearArguments` | `(callHandle AS U64)` | I32 | ✓ |
| `uxcapi.CallSetReturnStruct` | `(callHandle AS U64, typeHandle AS U64)` | I32 | ✓ |
| `uxcapi.ArgI8` | `(callHandle AS U64, value AS I32)` | I32 | ✓ |
| `uxcapi.ArgU8` | `(callHandle AS U64, value AS U32)` | I32 | ✓ |
| `uxcapi.ArgI16` | `(callHandle AS U64, value AS I32)` | I32 | ✓ |
| `uxcapi.ArgU16` | `(callHandle AS U64, value AS U32)` | I32 | ✓ |
| `uxcapi.ArgI32` | `(callHandle AS U64, value AS I32)` | I32 | ✓ |
| `uxcapi.ArgU32` | `(callHandle AS U64, value AS U32)` | I32 | ✓ |
| `uxcapi.ArgI64` | `(callHandle AS U64, value AS I64)` | I32 | ✓ |
| `uxcapi.ArgU64` | `(callHandle AS U64, value AS U64)` | I32 | ✓ |
| `uxcapi.ArgF32` | `(callHandle AS U64, value AS F64)` | I32 | ✓ |
| `uxcapi.ArgF64` | `(callHandle AS U64, value AS F64)` | I32 | ✓ |
| `uxcapi.ArgStruct` | `(callHandle AS U64, typeHandle AS U64, dataPointer AS U64, byteCount AS U64)` | I32 | ✓ |
| `uxcapi.ArgPtr` | `(callHandle AS U64, value AS U64)` | I32 | ✓ |
| `uxcapi.ArgString` | `(callHandle AS U64, value AS STRING)` | I32 | ✓ |
| `uxcapi.ArgWString` | `(callHandle AS U64, utf8Value AS STRING)` | I32 | ✓ |
| `uxcapi.ArgLongDouble` | `(callHandle AS U64, value AS F64)` | I32 | ✓ |
| `uxcapi.CallAppendArgs` | `(callHandle AS U64, argsHandle AS U64)` | I32 | ✓ |
| `uxcapi.Invoke` | `(callHandle AS U64)` | I32 | ✓ |
| `uxcapi.ResultI32` | `(callHandle AS U64)` | I32 | ✓ |
| `uxcapi.ResultU32` | `(callHandle AS U64)` | U32 | ✓ |
| `uxcapi.ResultI64` | `(callHandle AS U64)` | I64 | ✓ |
| `uxcapi.ResultU64` | `(callHandle AS U64)` | U64 | ✓ |
| `uxcapi.ResultF64` | `(callHandle AS U64)` | F64 | ✓ |
| `uxcapi.ResultPtr` | `(callHandle AS U64)` | U64 | ✓ |
| `uxcapi.ResultString` | `(callHandle AS U64)` | STRING | ✓ |
| `uxcapi.ResultStructSize` | `(callHandle AS U64)` | U64 |  |
| `uxcapi.ResultStructCopy` | `(callHandle AS U64, targetPointer AS U64, targetCapacity AS U64)` | I32 | ✓ |
| `uxcapi.CallError` | `(callHandle AS U64)` | STRING | ✓ |
| `uxcapi.ArgsNew` | `()` | U64 | ✓ |
| `uxcapi.ArgsFree` | `(argsHandle AS U64)` |  | ✓ |
| `uxcapi.ArgsClear` | `(argsHandle AS U64)` | I32 | ✓ |
| `uxcapi.ArgsAddI8` | `(argsHandle AS U64, value AS I32)` | I32 | ✓ |
| `uxcapi.ArgsAddU8` | `(argsHandle AS U64, value AS U32)` | I32 | ✓ |
| `uxcapi.ArgsAddI16` | `(argsHandle AS U64, value AS I32)` | I32 | ✓ |
| `uxcapi.ArgsAddU16` | `(argsHandle AS U64, value AS U32)` | I32 | ✓ |
| `uxcapi.ArgsAddI32` | `(argsHandle AS U64, value AS I32)` | I32 | ✓ |
| `uxcapi.ArgsAddU32` | `(argsHandle AS U64, value AS U32)` | I32 | ✓ |
| `uxcapi.ArgsAddI64` | `(argsHandle AS U64, value AS I64)` | I32 | ✓ |
| `uxcapi.ArgsAddU64` | `(argsHandle AS U64, value AS U64)` | I32 | ✓ |
| `uxcapi.ArgsAddF32` | `(argsHandle AS U64, value AS F64)` | I32 | ✓ |
| `uxcapi.ArgsAddF64` | `(argsHandle AS U64, value AS F64)` | I32 | ✓ |
| `uxcapi.ArgsAddPtr` | `(argsHandle AS U64, value AS U64)` | I32 | ✓ |
| `uxcapi.ArgsAddString` | `(argsHandle AS U64, value AS STRING)` | I32 | ✓ |
| `uxcapi.ArgsAddWString` | `(argsHandle AS U64, value AS STRING)` | I32 | ✓ |
| `uxcapi.ArgsAddLongDouble` | `(argsHandle AS U64, value AS F64)` | I32 | ✓ |
| `uxcapi.ArgsAddStruct` | `(argsHandle AS U64, typeHandle AS U64, dataPointer AS U64, byteCount AS U64)` | I32 |  |
| `uxcapi.MemoryAlloc` | `(byteCount AS U64)` | U64 | ✓ |
| `uxcapi.MemoryCalloc` | `(itemCount AS U64, itemSize AS U64)` | U64 | ✓ |
| `uxcapi.MemoryRealloc` | `(memory AS U64, byteCount AS U64)` | U64 | ✓ |
| `uxcapi.MemoryFree` | `(memory AS U64)` |  | ✓ |
| `uxcapi.MemoryZero` | `(memory AS U64, byteCount AS U64)` | I32 | ✓ |
| `uxcapi.MemoryCopy` | `(target AS U64, source AS U64, byteCount AS U64)` | I32 | ✓ |
| `uxcapi.MemoryWriteI8` | `(memory AS U64, offset AS U64, value AS I32)` | I32 | ✓ |
| `uxcapi.MemoryWriteU8` | `(memory AS U64, offset AS U64, value AS U32)` | I32 | ✓ |
| `uxcapi.MemoryWriteI16` | `(memory AS U64, offset AS U64, value AS I32)` | I32 | ✓ |
| `uxcapi.MemoryWriteU16` | `(memory AS U64, offset AS U64, value AS U32)` | I32 | ✓ |
| `uxcapi.MemoryWriteI32` | `(memory AS U64, offset AS U64, value AS I32)` | I32 | ✓ |
| `uxcapi.MemoryWriteU32` | `(memory AS U64, offset AS U64, value AS U32)` | I32 | ✓ |
| `uxcapi.MemoryWriteI64` | `(memory AS U64, offset AS U64, value AS I64)` | I32 | ✓ |
| `uxcapi.MemoryWriteU64` | `(memory AS U64, offset AS U64, value AS U64)` | I32 | ✓ |
| `uxcapi.MemoryWriteF32` | `(memory AS U64, offset AS U64, value AS F64)` | I32 | ✓ |
| `uxcapi.MemoryWriteF64` | `(memory AS U64, offset AS U64, value AS F64)` | I32 | ✓ |
| `uxcapi.MemoryWritePtr` | `(memory AS U64, offset AS U64, value AS U64)` | I32 | ✓ |
| `uxcapi.MemoryWriteString` | `(memory AS U64, offset AS U64, value AS STRING, capacity AS U64)` | I32 | ✓ |
| `uxcapi.MemoryReadI8` | `(memory AS U64, offset AS U64)` | I32 | ✓ |
| `uxcapi.MemoryReadU8` | `(memory AS U64, offset AS U64)` | U32 | ✓ |
| `uxcapi.MemoryReadI16` | `(memory AS U64, offset AS U64)` | I32 | ✓ |
| `uxcapi.MemoryReadU16` | `(memory AS U64, offset AS U64)` | U32 | ✓ |
| `uxcapi.MemoryReadI32` | `(memory AS U64, offset AS U64)` | I32 | ✓ |
| `uxcapi.MemoryReadU32` | `(memory AS U64, offset AS U64)` | U32 | ✓ |
| `uxcapi.MemoryReadI64` | `(memory AS U64, offset AS U64)` | I64 | ✓ |
| `uxcapi.MemoryReadU64` | `(memory AS U64, offset AS U64)` | U64 | ✓ |
| `uxcapi.MemoryReadF32` | `(memory AS U64, offset AS U64)` | F64 | ✓ |
| `uxcapi.MemoryReadF64` | `(memory AS U64, offset AS U64)` | F64 | ✓ |
| `uxcapi.MemoryReadPtr` | `(memory AS U64, offset AS U64)` | U64 | ✓ |
| `uxcapi.MemoryReadString` | `(memory AS U64, offset AS U64)` | STRING | ✓ |
| `uxcapi.CallbackNew` | `(returnKind AS I32, defaultU64 AS U64, defaultF64 AS F64)` | U64 | ✓ |
| `uxcapi.CallbackAddArg` | `(callbackHandle AS U64, argumentKind AS I32)` | I32 | ✓ |
| `uxcapi.CallbackBuild` | `(callbackHandle AS U64)` | I32 | ✓ |
| `uxcapi.CallbackPointer` | `(callbackHandle AS U64)` | U64 | ✓ |
| `uxcapi.CallbackFree` | `(callbackHandle AS U64)` |  | ✓ |
| `uxcapi.CallbackPending` | `(callbackHandle AS U64)` | U64 | ✓ |
| `uxcapi.CallbackNext` | `(callbackHandle AS U64)` | U64 | ✓ |
| `uxcapi.EventFree` | `(eventHandle AS U64)` |  | ✓ |
| `uxcapi.EventArgCount` | `(eventHandle AS U64)` | I32 | ✓ |
| `uxcapi.EventArgKind` | `(eventHandle AS U64, index0 AS I32)` | I32 | ✓ |
| `uxcapi.EventArgU64` | `(eventHandle AS U64, index0 AS I32)` | U64 | ✓ |
| `uxcapi.EventArgF64` | `(eventHandle AS U64, index0 AS I32)` | F64 | ✓ |
| `uxcapi.EventArgString` | `(eventHandle AS U64, index0 AS I32)` | STRING | ✓ |

## uxclazz  (uxclazz_support; 5 fonksiyon/sub, 0 sabit, testte çağrılan 0)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxclazz_support.HashCombine` | `(seed AS U64, value AS U64)` | U64 |  |
| `uxclazz_support.HashI64` | `(value AS I64)` | U64 |  |
| `uxclazz_support.HashString` | `(value AS STRING)` | U64 |  |
| `uxclazz_support.EscapeJson` | `(value AS STRING)` | STRING |  |
| `uxclazz_support.BoolJson` | `(value AS BOOLEAN)` | STRING |  |

## uxclz  (uxclz; 43 fonksiyon/sub, 18 sabit, testte çağrılan 13)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxclz.Version` | `()` | U32 | ✓ |
| `uxclz.LastError` | `()` | STRING |  |
| `uxclz.ResetRegistry` | `()` | I32 | ✓ |
| `uxclz.TypeRegister` | `(name AS STRING, baseType AS U32, flags AS U32)` | U32 | ✓ |
| `uxclz.TypeAddInterface` | `(typeId AS U32, interfaceId AS U32)` | I32 |  |
| `uxclz.TypeName` | `(typeId AS U32)` | STRING | ✓ |
| `uxclz.TypeIsA` | `(typeId AS U32, expectedType AS U32)` | I32 | ✓ |
| `uxclz.TypeHasInterface` | `(typeId AS U32, interfaceId AS U32)` | I32 |  |
| `uxclz.TypeMetadataJson` | `(typeId AS U32)` | STRING |  |
| `uxclz.RegistryMetadataJson` | `()` | STRING |  |
| `uxclz.MethodRegister` | `(typeId AS U32, methodId AS U32, name AS STRING, functionPointer AS U64)` | I32 |  |
| `uxclz.ObjectWrap` | `(typeId AS U32, payload AS U64, destructorPointer AS U64)` | U64 |  |
| `uxclz.ObjectRetain` | `(handle AS U64)` | I32 |  |
| `uxclz.ObjectRelease` | `(handle AS U64)` | I32 |  |
| `uxclz.ObjectIsValid` | `(handle AS U64)` | I32 |  |
| `uxclz.ObjectType` | `(handle AS U64)` | U32 |  |
| `uxclz.ObjectPayload` | `(handle AS U64)` | U64 |  |
| `uxclz.ObjectQueryInterface` | `(handle AS U64, interfaceId AS U32)` | U64 |  |
| `uxclz.ArgsNew` | `()` | U64 | ✓ |
| `uxclz.ArgsFree` | `(argsHandle AS U64)` |  | ✓ |
| `uxclz.ArgsClear` | `(argsHandle AS U64)` |  |  |
| `uxclz.ArgsCount` | `(argsHandle AS U64)` | U32 | ✓ |
| `uxclz.ArgsPushI64` | `(argsHandle AS U64, value AS I64)` | I32 | ✓ |
| `uxclz.ArgsPushU64` | `(argsHandle AS U64, value AS U64)` | I32 |  |
| `uxclz.ArgsPushF64` | `(argsHandle AS U64, value AS F64)` | I32 |  |
| `uxclz.ArgsPushPtr` | `(argsHandle AS U64, value AS U64)` | I32 |  |
| `uxclz.ArgsPushBool` | `(argsHandle AS U64, value AS BOOLEAN)` | I32 |  |
| `uxclz.ArgsPushString` | `(argsHandle AS U64, value AS STRING)` | I32 | ✓ |
| `uxclz.ArgsPushHandle` | `(argsHandle AS U64, value AS U64)` | I32 |  |
| `uxclz.ResultNew` | `()` | U64 | ✓ |
| `uxclz.ResultFree` | `(resultHandle AS U64)` |  | ✓ |
| `uxclz.ResultClear` | `(resultHandle AS U64)` |  |  |
| `uxclz.ResultKind` | `(resultHandle AS U64)` | U32 | ✓ |
| `uxclz.ResultI64` | `(resultHandle AS U64)` | I64 |  |
| `uxclz.ResultU64` | `(resultHandle AS U64)` | U64 |  |
| `uxclz.ResultF64` | `(resultHandle AS U64)` | F64 |  |
| `uxclz.ResultPtr` | `(resultHandle AS U64)` | U64 |  |
| `uxclz.ResultBool` | `(resultHandle AS U64)` | BOOLEAN |  |
| `uxclz.ResultString` | `(resultHandle AS U64)` | STRING |  |
| `uxclz.ResultHandle` | `(resultHandle AS U64)` | U64 |  |
| `uxclz.InvokeArgs` | `(objectHandle AS U64, methodId AS U32, argsHandle AS U64, resultHandle AS U64)` | I32 |  |
| `uxclz.MultimethodRegister` | `(methodId AS U32, leftType AS U32, rightType AS U32, name AS STRING, functionPointer AS U64)` | I32 |  |
| `uxclz.MultimethodInvokeArgs` | `(methodId AS U32, leftHandle AS U64, rightHandle AS U64, argsHandle AS U64, resultHandle AS U64)` | I32 |  |

## uxcollections  (uxcollections; 210 fonksiyon/sub, 1 sabit, testte çağrılan 29)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxcollections.Version` | `()` | I32 | ✓ |
| `uxcollections.ListNew` | `()` | U64 | ✓ |
| `uxcollections.ListFree` | `(h AS U64)` |  | ✓ |
| `uxcollections.ListCount` | `(h AS U64)` | I64 | ✓ |
| `uxcollections.ListClear` | `(h AS U64)` |  |  |
| `uxcollections.ListPushI64` | `(h AS U64, x AS I64)` |  | ✓ |
| `uxcollections.ListPushF64` | `(h AS U64, x AS F64)` |  | ✓ |
| `uxcollections.ListPushStr` | `(h AS U64, s AS STRING)` |  |  |
| `uxcollections.ListRemoveAt` | `(h AS U64, idx AS I64)` | I32 |  |
| `uxcollections.ListGetI64` | `(h AS U64, idx AS I64)` | I64 | ✓ |
| `uxcollections.ListGetF64` | `(h AS U64, idx AS I64)` | F64 | ✓ |
| `uxcollections.ListGetStr` | `(h AS U64, idx AS I64)` | STRING |  |
| `uxcollections.ListSetI64` | `(h AS U64, idx AS I64, x AS I64)` | I32 |  |
| `uxcollections.ListSetF64` | `(h AS U64, idx AS I64, x AS F64)` | I32 |  |
| `uxcollections.ListSetStr` | `(h AS U64, idx AS I64, s AS STRING)` | I32 |  |
| `uxcollections.ListGetKind` | `(h AS U64, idx AS I64)` | I32 |  |
| `uxcollections.ListSort` | `(h AS U64)` |  |  |
| `uxcollections.ListSortAlpha` | `(h AS U64)` |  |  |
| `uxcollections.ListReverse` | `(h AS U64)` |  |  |
| `uxcollections.ListSum` | `(h AS U64)` | F64 |  |
| `uxcollections.ListAverage` | `(h AS U64)` | F64 |  |
| `uxcollections.ListMin` | `(h AS U64)` | F64 |  |
| `uxcollections.ListMax` | `(h AS U64)` | F64 |  |
| `uxcollections.ListRange` | `(h AS U64)` | F64 |  |
| `uxcollections.ListMedian` | `(h AS U64)` | F64 |  |
| `uxcollections.ListPercentile` | `(h AS U64, p AS F64)` | F64 |  |
| `uxcollections.ListVariance` | `(h AS U64)` | F64 |  |
| `uxcollections.ListStdDev` | `(h AS U64)` | F64 |  |
| `uxcollections.ListStdErr` | `(h AS U64)` | F64 |  |
| `uxcollections.ListMode` | `(h AS U64)` | F64 |  |
| `uxcollections.ListJoin` | `(h AS U64, sep AS STRING)` | STRING |  |
| `uxcollections.ListSplitToList` | `(text AS STRING, sep AS STRING)` | U64 |  |
| `uxcollections.ListToUpper` | `(h AS U64)` | U64 |  |
| `uxcollections.ListToLower` | `(h AS U64)` | U64 |  |
| `uxcollections.ListCapitalize` | `(h AS U64)` | U64 |  |
| `uxcollections.ListTrim` | `(h AS U64)` | U64 |  |
| `uxcollections.ListFilterByPrefix` | `(h AS U64, prefix AS STRING)` | U64 |  |
| `uxcollections.ListFilterBySuffix` | `(h AS U64, suffix AS STRING)` | U64 |  |
| `uxcollections.ListFilterContains` | `(h AS U64, needle AS STRING)` | U64 |  |
| `uxcollections.ListIndexOfI64` | `(h AS U64, x AS I64)` | I64 |  |
| `uxcollections.ListIndexOfF64` | `(h AS U64, x AS F64)` | I64 |  |
| `uxcollections.ListIndexOfStr` | `(h AS U64, s AS STRING)` | I64 |  |
| `uxcollections.ListContainsI64` | `(h AS U64, x AS I64)` | I32 |  |
| `uxcollections.ListContainsF64` | `(h AS U64, x AS F64)` | I32 |  |
| `uxcollections.ListContainsStr` | `(h AS U64, s AS STRING)` | I32 |  |
| `uxcollections.ListCountValueI64` | `(h AS U64, x AS I64)` | I64 |  |
| `uxcollections.ListCountValueF64` | `(h AS U64, x AS F64)` | I64 |  |
| `uxcollections.ListCountValueStr` | `(h AS U64, s AS STRING)` | I64 |  |
| `uxcollections.ListSlice` | `(h AS U64, startIdx AS I64, endIdx AS I64)` | U64 |  |
| `uxcollections.ListExtend` | `(dstH AS U64, srcH AS U64)` |  |  |
| `uxcollections.ListInsertAtI64` | `(h AS U64, idx AS I64, x AS I64)` | I32 |  |
| `uxcollections.ListInsertAtF64` | `(h AS U64, idx AS I64, x AS F64)` | I32 |  |
| `uxcollections.ListInsertAtStr` | `(h AS U64, idx AS I64, s AS STRING)` | I32 |  |
| `uxcollections.ListUnique` | `(h AS U64)` | U64 |  |
| `uxcollections.ListClone` | `(h AS U64)` | U64 |  |
| `uxcollections.StackNew` | `()` | U64 | ✓ |
| `uxcollections.StackFree` | `(h AS U64)` |  | ✓ |
| `uxcollections.StackCount` | `(h AS U64)` | I64 |  |
| `uxcollections.StackPushI64` | `(h AS U64, x AS I64)` |  |  |
| `uxcollections.StackPushF64` | `(h AS U64, x AS F64)` |  | ✓ |
| `uxcollections.StackPushStr` | `(h AS U64, s AS STRING)` |  |  |
| `uxcollections.StackPopI64` | `(h AS U64)` | I64 |  |
| `uxcollections.StackPopF64` | `(h AS U64)` | F64 | ✓ |
| `uxcollections.StackPopStr` | `(h AS U64)` | STRING |  |
| `uxcollections.StackPeekKind` | `(h AS U64)` | I32 |  |
| `uxcollections.StackPeekI64` | `(h AS U64)` | I64 |  |
| `uxcollections.StackPeekF64` | `(h AS U64)` | F64 |  |
| `uxcollections.StackPeekStr` | `(h AS U64)` | STRING |  |
| `uxcollections.StackIsEmpty` | `(h AS U64)` | I32 |  |
| `uxcollections.StackClear` | `(h AS U64)` |  |  |
| `uxcollections.StackClone` | `(h AS U64)` | U64 |  |
| `uxcollections.StackContainsI64` | `(h AS U64, x AS I64)` | I32 |  |
| `uxcollections.StackContainsF64` | `(h AS U64, x AS F64)` | I32 |  |
| `uxcollections.StackContainsStr` | `(h AS U64, s AS STRING)` | I32 |  |
| `uxcollections.StackToList` | `(h AS U64)` | U64 |  |
| `uxcollections.StackPushRange` | `(h AS U64, listH AS U64)` |  |  |
| `uxcollections.QueueNew` | `()` | U64 | ✓ |
| `uxcollections.QueueFree` | `(h AS U64)` |  | ✓ |
| `uxcollections.QueueCount` | `(h AS U64)` | I64 |  |
| `uxcollections.QueuePushI64` | `(h AS U64, x AS I64)` |  |  |
| `uxcollections.QueuePushF64` | `(h AS U64, x AS F64)` |  | ✓ |
| `uxcollections.QueuePushStr` | `(h AS U64, s AS STRING)` |  |  |
| `uxcollections.QueuePopI64` | `(h AS U64)` | I64 |  |
| `uxcollections.QueuePopF64` | `(h AS U64)` | F64 | ✓ |
| `uxcollections.QueuePopStr` | `(h AS U64)` | STRING |  |
| `uxcollections.QueuePeekKind` | `(h AS U64)` | I32 |  |
| `uxcollections.QueuePeekI64` | `(h AS U64)` | I64 |  |
| `uxcollections.QueuePeekF64` | `(h AS U64)` | F64 |  |
| `uxcollections.QueuePeekStr` | `(h AS U64)` | STRING |  |
| `uxcollections.QueueIsEmpty` | `(h AS U64)` | I32 |  |
| `uxcollections.QueueClear` | `(h AS U64)` |  |  |
| `uxcollections.QueueClone` | `(h AS U64)` | U64 |  |
| `uxcollections.QueueContainsI64` | `(h AS U64, x AS I64)` | I32 |  |
| `uxcollections.QueueContainsF64` | `(h AS U64, x AS F64)` | I32 |  |
| `uxcollections.QueueContainsStr` | `(h AS U64, s AS STRING)` | I32 |  |
| `uxcollections.QueueToList` | `(h AS U64)` | U64 |  |
| `uxcollections.QueuePushRange` | `(h AS U64, listH AS U64)` |  |  |
| `uxcollections.DequeNew` | `()` | U64 |  |
| `uxcollections.DequeFree` | `(h AS U64)` |  |  |
| `uxcollections.DequeCount` | `(h AS U64)` | I64 |  |
| `uxcollections.DequePushFrontI64` | `(h AS U64, x AS I64)` |  |  |
| `uxcollections.DequePushBackI64` | `(h AS U64, x AS I64)` |  |  |
| `uxcollections.DequePushFrontF64` | `(h AS U64, x AS F64)` |  |  |
| `uxcollections.DequePushBackF64` | `(h AS U64, x AS F64)` |  |  |
| `uxcollections.DequePushFrontStr` | `(h AS U64, s AS STRING)` |  |  |
| `uxcollections.DequePushBackStr` | `(h AS U64, s AS STRING)` |  |  |
| `uxcollections.DequePopFrontI64` | `(h AS U64)` | I64 |  |
| `uxcollections.DequePopBackI64` | `(h AS U64)` | I64 |  |
| `uxcollections.DequePopFrontF64` | `(h AS U64)` | F64 |  |
| `uxcollections.DequePopBackF64` | `(h AS U64)` | F64 |  |
| `uxcollections.DequePopFrontStr` | `(h AS U64)` | STRING |  |
| `uxcollections.DequePopBackStr` | `(h AS U64)` | STRING |  |
| `uxcollections.DequePeekFrontKind` | `(h AS U64)` | I32 |  |
| `uxcollections.DequePeekBackKind` | `(h AS U64)` | I32 |  |
| `uxcollections.DequePeekFrontI64` | `(h AS U64)` | I64 |  |
| `uxcollections.DequePeekFrontF64` | `(h AS U64)` | F64 |  |
| `uxcollections.DequePeekFrontStr` | `(h AS U64)` | STRING |  |
| `uxcollections.DequePeekBackI64` | `(h AS U64)` | I64 |  |
| `uxcollections.DequePeekBackF64` | `(h AS U64)` | F64 |  |
| `uxcollections.DequePeekBackStr` | `(h AS U64)` | STRING |  |
| `uxcollections.DequeIsEmpty` | `(h AS U64)` | I32 |  |
| `uxcollections.DequeClear` | `(h AS U64)` |  |  |
| `uxcollections.DequeClone` | `(h AS U64)` | U64 |  |
| `uxcollections.DequeContainsI64` | `(h AS U64, x AS I64)` | I32 |  |
| `uxcollections.DequeContainsF64` | `(h AS U64, x AS F64)` | I32 |  |
| `uxcollections.DequeContainsStr` | `(h AS U64, s AS STRING)` | I32 |  |
| `uxcollections.DequeToList` | `(h AS U64)` | U64 |  |
| `uxcollections.DequePushRangeFront` | `(h AS U64, listH AS U64)` |  |  |
| `uxcollections.DequePushRangeBack` | `(h AS U64, listH AS U64)` |  |  |
| `uxcollections.DequeRotate` | `(h AS U64, n AS I64)` |  |  |
| `uxcollections.DictNew` | `()` | U64 | ✓ |
| `uxcollections.DictFree` | `(h AS U64)` |  | ✓ |
| `uxcollections.DictCount` | `(h AS U64)` | I64 |  |
| `uxcollections.DictSetI64` | `(h AS U64, key AS STRING, x AS I64)` |  |  |
| `uxcollections.DictSetF64` | `(h AS U64, key AS STRING, x AS F64)` |  | ✓ |
| `uxcollections.DictSetStr` | `(h AS U64, key AS STRING, s AS STRING)` |  |  |
| `uxcollections.DictHas` | `(h AS U64, key AS STRING)` | I32 | ✓ |
| `uxcollections.DictRemove` | `(h AS U64, key AS STRING)` | I32 |  |
| `uxcollections.DictGetI64` | `(h AS U64, key AS STRING)` | I64 |  |
| `uxcollections.DictGetF64` | `(h AS U64, key AS STRING)` | F64 | ✓ |
| `uxcollections.DictGetStr` | `(h AS U64, key AS STRING)` | STRING |  |
| `uxcollections.DictGetKind` | `(h AS U64, key AS STRING)` | I32 |  |
| `uxcollections.DictKeyAt` | `(h AS U64, idx AS I64)` | STRING |  |
| `uxcollections.DictKeysAsList` | `(h AS U64)` | U64 |  |
| `uxcollections.DictValuesAsList` | `(h AS U64)` | U64 |  |
| `uxcollections.DictGetOrDefaultI64` | `(h AS U64, key AS STRING, defVal AS I64)` | I64 |  |
| `uxcollections.DictGetOrDefaultF64` | `(h AS U64, key AS STRING, defVal AS F64)` | F64 |  |
| `uxcollections.DictGetOrDefaultStr` | `(h AS U64, key AS STRING, defVal AS STRING)` | STRING |  |
| `uxcollections.DictSetDefaultI64` | `(h AS U64, key AS STRING, defVal AS I64)` | I64 |  |
| `uxcollections.DictSetDefaultF64` | `(h AS U64, key AS STRING, defVal AS F64)` | F64 |  |
| `uxcollections.DictSetDefaultStr` | `(h AS U64, key AS STRING, defVal AS STRING)` | STRING |  |
| `uxcollections.DictPopI64` | `(h AS U64, key AS STRING)` | I64 |  |
| `uxcollections.DictPopF64` | `(h AS U64, key AS STRING)` | F64 |  |
| `uxcollections.DictPopStr` | `(h AS U64, key AS STRING)` | STRING |  |
| `uxcollections.DictFirstKey` | `(h AS U64)` | STRING |  |
| `uxcollections.DictLastKey` | `(h AS U64)` | STRING |  |
| `uxcollections.DictPopFirst` | `(h AS U64)` | I32 |  |
| `uxcollections.DictPopLast` | `(h AS U64)` | I32 |  |
| `uxcollections.DictIsEmpty` | `(h AS U64)` | I32 |  |
| `uxcollections.DictContainsValueI64` | `(h AS U64, x AS I64)` | I32 |  |
| `uxcollections.DictContainsValueF64` | `(h AS U64, x AS F64)` | I32 |  |
| `uxcollections.DictContainsValueStr` | `(h AS U64, s AS STRING)` | I32 |  |
| `uxcollections.DictClone` | `(h AS U64)` | U64 |  |
| `uxcollections.DictUpdate` | `(dstH AS U64, srcH AS U64)` |  |  |
| `uxcollections.DictMerge` | `(aH AS U64, bH AS U64)` | U64 |  |
| `uxcollections.DictInvert` | `(h AS U64)` | U64 |  |
| `uxcollections.DictEquals` | `(aH AS U64, bH AS U64)` | I32 |  |
| `uxcollections.SetNew` | `()` | U64 | ✓ |
| `uxcollections.SetFree` | `(h AS U64)` |  | ✓ |
| `uxcollections.SetCount` | `(h AS U64)` | I64 |  |
| `uxcollections.SetAdd` | `(h AS U64, key AS STRING)` |  | ✓ |
| `uxcollections.SetContains` | `(h AS U64, key AS STRING)` | I32 | ✓ |
| `uxcollections.SetRemove` | `(h AS U64, key AS STRING)` | I32 |  |
| `uxcollections.SetKeyAt` | `(h AS U64, idx AS I64)` | STRING |  |
| `uxcollections.SetUnion` | `(aH AS U64, bH AS U64)` | U64 |  |
| `uxcollections.SetIntersect` | `(aH AS U64, bH AS U64)` | U64 |  |
| `uxcollections.SetDifference` | `(aH AS U64, bH AS U64)` | U64 |  |
| `uxcollections.SetSymmetricDifference` | `(aH AS U64, bH AS U64)` | U64 |  |
| `uxcollections.SetIsSupersetOf` | `(aH AS U64, bH AS U64)` | I32 |  |
| `uxcollections.SetIsSubsetOf` | `(aH AS U64, bH AS U64)` | I32 |  |
| `uxcollections.SetIsDisjoint` | `(aH AS U64, bH AS U64)` | I32 |  |
| `uxcollections.SetEquals` | `(aH AS U64, bH AS U64)` | I32 |  |
| `uxcollections.SetIsEmpty` | `(h AS U64)` | I32 |  |
| `uxcollections.SetToList` | `(h AS U64)` | U64 |  |
| `uxcollections.SetClone` | `(h AS U64)` | U64 |  |
| `uxcollections.SetAddRange` | `(h AS U64, listH AS U64)` |  |  |
| `uxcollections.SetRemoveRange` | `(h AS U64, listH AS U64)` |  |  |
| `uxcollections.SetPop` | `(h AS U64)` | STRING |  |
| `uxcollections.TreeNew` | `()` | U64 | ✓ |
| `uxcollections.TreeFree` | `(h AS U64)` |  | ✓ |
| `uxcollections.TreeCount` | `(h AS U64)` | I64 |  |
| `uxcollections.TreeHeight` | `(h AS U64)` | I64 |  |
| `uxcollections.TreeSetI64` | `(h AS U64, key AS STRING, x AS I64)` |  |  |
| `uxcollections.TreeSetF64` | `(h AS U64, key AS STRING, x AS F64)` |  | ✓ |
| `uxcollections.TreeSetStr` | `(h AS U64, key AS STRING, s AS STRING)` |  |  |
| `uxcollections.TreeHas` | `(h AS U64, key AS STRING)` | I32 |  |
| `uxcollections.TreeGetI64` | `(h AS U64, key AS STRING)` | I64 |  |
| `uxcollections.TreeGetF64` | `(h AS U64, key AS STRING)` | F64 | ✓ |
| `uxcollections.TreeGetStr` | `(h AS U64, key AS STRING)` | STRING |  |
| `uxcollections.TreeGetKind` | `(h AS U64, key AS STRING)` | I32 |  |
| `uxcollections.TreeRemove` | `(h AS U64, key AS STRING)` | I32 |  |
| `uxcollections.NodeNewStr` | `(s AS STRING)` | U64 |  |
| `uxcollections.NodeFree` | `(h AS U64)` |  |  |
| `uxcollections.NodeAppendChildStr` | `(h AS U64, s AS STRING)` | U64 |  |
| `uxcollections.NodeChildCount` | `(h AS U64)` | I64 |  |
| `uxcollections.NodeDepth` | `(h AS U64)` | I64 |  |
| `uxcollections.NodeMaxHeight` | `(h AS U64)` | I64 |  |
| `uxcollections.NodeGetStr` | `(h AS U64)` | STRING |  |
| `uxcollections.GraphBackendAvailable` | `()` | I32 |  |
| `uxcollections.DataframeBackendAvailable` | `()` | I32 |  |

## uxcompress  (uxcompress; 20 fonksiyon/sub, 0 sabit, testte çağrılan 18)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxcompress.Version` | `()` | STRING |  |
| `uxcompress.Compress` | `(sourcePtr AS U64, sourceSize AS U64, level AS I32)` | U64 | ✓ |
| `uxcompress.CompressText` | `(sourceText AS STRING, level AS I32)` | U64 | ✓ |
| `uxcompress.Decompress` | `(sourcePtr AS U64, sourceSize AS U64, expectedSize AS U64)` | U64 | ✓ |
| `uxcompress.BlobData` | `(blob AS U64)` | U64 | ✓ |
| `uxcompress.BlobSize` | `(blob AS U64)` | U64 | ✓ |
| `uxcompress.BlobFree` | `(blob AS U64)` |  | ✓ |
| `uxcompress.CompressFile` | `(sourcePath AS STRING, targetPath AS STRING, level AS I32)` | I32 | ✓ |
| `uxcompress.DecompressFile` | `(sourcePath AS STRING, targetPath AS STRING)` | I32 | ✓ |
| `uxcompress.ErrorText` | `()` | STRING | ✓ |
| `uxcompress.Version` | `()` | STRING |  |
| `uxcompress.Compress` | `(sourcePtr AS U64, sourceSize AS U64, level AS I32)` | U64 | ✓ |
| `uxcompress.CompressText` | `(sourceText AS STRING, level AS I32)` | U64 | ✓ |
| `uxcompress.Decompress` | `(sourcePtr AS U64, sourceSize AS U64, expectedSize AS U64)` | U64 | ✓ |
| `uxcompress.BlobData` | `(blob AS U64)` | U64 | ✓ |
| `uxcompress.BlobSize` | `(blob AS U64)` | U64 | ✓ |
| `uxcompress.BlobFree` | `(blob AS U64)` |  | ✓ |
| `uxcompress.CompressFile` | `(sourcePath AS STRING, targetPath AS STRING, level AS I32)` | I32 | ✓ |
| `uxcompress.DecompressFile` | `(sourcePath AS STRING, targetPath AS STRING)` | I32 | ✓ |
| `uxcompress.ErrorText` | `()` | STRING | ✓ |

## uxconfig  (uxconfig; 16 fonksiyon/sub, 1 sabit, testte çağrılan 14)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxconfig.Version` | `()` | STRING |  |
| `uxconfig.Open` | `(path AS STRING)` | U64 | ✓ |
| `uxconfig.Close` | `(handle AS U64)` |  | ✓ |
| `uxconfig.GetString` | `(handle AS U64,section AS STRING,key AS STRING,defaultValue AS STRING)` | STRING | ✓ |
| `uxconfig.GetI64` | `(handle AS U64,section AS STRING,key AS STRING,defaultValue AS I64)` | I64 | ✓ |
| `uxconfig.GetF64` | `(handle AS U64,section AS STRING,key AS STRING,defaultValue AS F64)` | F64 |  |
| `uxconfig.GetBoolean` | `(handle AS U64,section AS STRING,key AS STRING,defaultValue AS I32)` | I32 | ✓ |
| `uxconfig.SetString` | `(handle AS U64,section AS STRING,key AS STRING,value AS STRING)` | I32 | ✓ |
| `uxconfig.SetI64` | `(handle AS U64,section AS STRING,key AS STRING,value AS I64)` | I32 | ✓ |
| `uxconfig.SetF64` | `(handle AS U64,section AS STRING,key AS STRING,value AS F64)` | I32 | ✓ |
| `uxconfig.SetBoolean` | `(handle AS U64,section AS STRING,key AS STRING,value AS I32)` | I32 | ✓ |
| `uxconfig.DeleteKey` | `(handle AS U64,section AS STRING,key AS STRING)` | I32 | ✓ |
| `uxconfig.DeleteSection` | `(handle AS U64,section AS STRING)` | I32 | ✓ |
| `uxconfig.HasKey` | `(handle AS U64,section AS STRING,key AS STRING)` | I32 | ✓ |
| `uxconfig.Path` | `(handle AS U64)` | STRING | ✓ |
| `uxconfig.ErrorText` | `()` | STRING | ✓ |

## uxcrypto  (uxcrypto; 26 fonksiyon/sub, 0 sabit, testte çağrılan 24)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxcrypto.Version` | `()` | STRING |  |
| `uxcrypto.Initialize` | `()` | I32 | ✓ |
| `uxcrypto.RandomBlob` | `(size AS U64)` | U64 | ✓ |
| `uxcrypto.BlobData` | `(blob AS U64)` | U64 | ✓ |
| `uxcrypto.BlobSize` | `(blob AS U64)` | U64 | ✓ |
| `uxcrypto.BlobFree` | `(blob AS U64)` |  | ✓ |
| `uxcrypto.Sha256Hex` | `(dataPtr AS U64, size AS U64)` | STRING | ✓ |
| `uxcrypto.Sha256Text` | `(text AS STRING)` | STRING | ✓ |
| `uxcrypto.PasswordHash` | `(password AS STRING)` | STRING | ✓ |
| `uxcrypto.PasswordVerify` | `(encodedHash AS STRING, password AS STRING)` | I32 | ✓ |
| `uxcrypto.SecretboxEncrypt` | `(messagePtr AS U64, messageSize AS U64, keyPtr AS U64, keySize AS U64)` | U64 | ✓ |
| `uxcrypto.SecretboxDecrypt` | `(encryptedPtr AS U64, encryptedSize AS U64, keyPtr AS U64, keySize AS U64)` | U64 | ✓ |
| `uxcrypto.ErrorText` | `()` | STRING | ✓ |
| `uxcrypto.Version` | `()` | STRING |  |
| `uxcrypto.Initialize` | `()` | I32 | ✓ |
| `uxcrypto.RandomBlob` | `(size AS U64)` | U64 | ✓ |
| `uxcrypto.BlobData` | `(blob AS U64)` | U64 | ✓ |
| `uxcrypto.BlobSize` | `(blob AS U64)` | U64 | ✓ |
| `uxcrypto.BlobFree` | `(blob AS U64)` |  | ✓ |
| `uxcrypto.Sha256Hex` | `(dataPtr AS U64, size AS U64)` | STRING | ✓ |
| `uxcrypto.Sha256Text` | `(text AS STRING)` | STRING | ✓ |
| `uxcrypto.PasswordHash` | `(password AS STRING)` | STRING | ✓ |
| `uxcrypto.PasswordVerify` | `(encodedHash AS STRING, password AS STRING)` | I32 | ✓ |
| `uxcrypto.SecretboxEncrypt` | `(messagePtr AS U64, messageSize AS U64, keyPtr AS U64, keySize AS U64)` | U64 | ✓ |
| `uxcrypto.SecretboxDecrypt` | `(encryptedPtr AS U64, encryptedSize AS U64, keyPtr AS U64, keySize AS U64)` | U64 | ✓ |
| `uxcrypto.ErrorText` | `()` | STRING | ✓ |

## uxdataframe  (uxdataframe; 31 fonksiyon/sub, 1 sabit, testte çağrılan 31)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxdataframe.RuntimeVersion` | `()` | I32 | ✓ |
| `uxdataframe.DuckDBAvailable` | `()` | I32 | ✓ |
| `uxdataframe.DuckDBVersion` | `()` | STRING | ✓ |
| `uxdataframe.LastError` | `(df AS U64)` | STRING | ✓ |
| `uxdataframe.OpenMemory` | `()` | U64 | ✓ |
| `uxdataframe.OpenDatabase` | `(path AS STRING)` | U64 | ✓ |
| `uxdataframe.Free` | `(df AS U64)` |  | ✓ |
| `uxdataframe.LoadCSV` | `(path AS STRING, header AS I32)` | U64 | ✓ |
| `uxdataframe.LoadParquet` | `(path AS STRING)` | U64 | ✓ |
| `uxdataframe.Exec` | `(df AS U64, sql AS STRING)` | I32 | ✓ |
| `uxdataframe.Query` | `(df AS U64, sql AS STRING)` | U64 | ✓ |
| `uxdataframe.RowCount` | `(df AS U64)` | I64 | ✓ |
| `uxdataframe.ColCount` | `(df AS U64)` | I32 | ✓ |
| `uxdataframe.ColName` | `(df AS U64, col AS I32)` | STRING | ✓ |
| `uxdataframe.GetF64` | `(df AS U64, row AS I64, col AS I32)` | F64 | ✓ |
| `uxdataframe.GetText` | `(df AS U64, row AS I64, col AS I32)` | STRING | ✓ |
| `uxdataframe.Head` | `(df AS U64, n AS I64)` | U64 | ✓ |
| `uxdataframe.SelectCols` | `(df AS U64, columns AS STRING)` | U64 | ✓ |
| `uxdataframe.Filter` | `(df AS U64, whereSql AS STRING)` | U64 | ✓ |
| `uxdataframe.OrderBy` | `(df AS U64, orderSql AS STRING)` | U64 | ✓ |
| `uxdataframe.Describe` | `(df AS U64)` | U64 | ✓ |
| `uxdataframe.GroupMean` | `(df AS U64, groupCol AS STRING, valueCol AS STRING)` | U64 | ✓ |
| `uxdataframe.JoinInner` | `(leftDf AS U64, rightDf AS U64, leftKey AS STRING, rightKey AS STRING)` | U64 | ✓ |
| `uxdataframe.ToCSV` | `(df AS U64, path AS STRING)` | I32 | ✓ |
| `uxdataframe.ToParquet` | `(df AS U64, path AS STRING)` | I32 | ✓ |
| `uxdataframe.ToF64Matrix` | `(df AS U64)` | U64 | ✓ |
| `uxdataframe.MatrixFree` | `(m AS U64)` |  | ✓ |
| `uxdataframe.MatrixRows` | `(m AS U64)` | I64 | ✓ |
| `uxdataframe.MatrixCols` | `(m AS U64)` | I32 | ✓ |
| `uxdataframe.MatrixDataPtr` | `(m AS U64)` | U64 | ✓ |
| `uxdataframe.MatrixGet` | `(m AS U64, row AS I64, col AS I32)` | F64 | ✓ |

## uxdataset  (uxdataset; 34 fonksiyon/sub, 5 sabit, testte çağrılan 32)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxdataset.Version` | `()` | I32 |  |
| `uxdataset.Backend` | `()` | STRING | ✓ |
| `uxdataset.Create` | `(rows AS I32, inputDim AS I32, targetDim AS I32)` | U64 | ✓ |
| `uxdataset.Free` | `(ds AS U64)` |  | ✓ |
| `uxdataset.Clone` | `(ds AS U64)` | U64 | ✓ |
| `uxdataset.LoadCSV` | `(path AS STRING, inputDim AS I32, targetDim AS I32, hasHeader AS I32)` | U64 |  |
| `uxdataset.SaveCSV` | `(ds AS U64, path AS STRING)` | I32 | ✓ |
| `uxdataset.RowCount` | `(ds AS U64)` | I32 | ✓ |
| `uxdataset.InputDim` | `(ds AS U64)` | I32 | ✓ |
| `uxdataset.TargetDim` | `(ds AS U64)` | I32 | ✓ |
| `uxdataset.XPtr` | `(ds AS U64)` | U64 | ✓ |
| `uxdataset.YPtr` | `(ds AS U64)` | U64 | ✓ |
| `uxdataset.GetX` | `(ds AS U64, row AS I32, col AS I32)` | F64 | ✓ |
| `uxdataset.SetX` | `(ds AS U64, row AS I32, col AS I32, value AS F64)` |  | ✓ |
| `uxdataset.GetY` | `(ds AS U64, row AS I32, col AS I32)` | F64 | ✓ |
| `uxdataset.SetY` | `(ds AS U64, row AS I32, col AS I32, value AS F64)` |  | ✓ |
| `uxdataset.Shuffle` | `(ds AS U64, seed AS U64)` |  | ✓ |
| `uxdataset.SplitTrain` | `(ds AS U64, trainRatio AS F64, seed AS U64)` | U64 | ✓ |
| `uxdataset.SplitTest` | `(ds AS U64, trainRatio AS F64, seed AS U64)` | U64 | ✓ |
| `uxdataset.ScalerFitStandard` | `(ds AS U64)` | U64 | ✓ |
| `uxdataset.ScalerFitMinMax` | `(ds AS U64)` | U64 | ✓ |
| `uxdataset.ScalerFree` | `(sc AS U64)` |  | ✓ |
| `uxdataset.ScalerTransform` | `(sc AS U64, ds AS U64)` |  | ✓ |
| `uxdataset.ScalerInverseTransform` | `(sc AS U64, ds AS U64)` |  | ✓ |
| `uxdataset.FillMissingMean` | `(ds AS U64)` |  | ✓ |
| `uxdataset.BatchCreate` | `(ds AS U64, batchSize AS I32, shuffle AS I32, seed AS U64)` | U64 | ✓ |
| `uxdataset.BatchFree` | `(loader AS U64)` |  | ✓ |
| `uxdataset.BatchReset` | `(loader AS U64)` |  | ✓ |
| `uxdataset.BatchNext` | `(loader AS U64)` | I32 | ✓ |
| `uxdataset.BatchRows` | `(loader AS U64)` | I32 | ✓ |
| `uxdataset.BatchXPtr` | `(loader AS U64)` | U64 | ✓ |
| `uxdataset.BatchYPtr` | `(loader AS U64)` | U64 | ✓ |
| `uxdataset.BatchGetX` | `(loader AS U64, row AS I32, col AS I32)` | F64 | ✓ |
| `uxdataset.BatchGetY` | `(loader AS U64, row AS I32, col AS I32)` | F64 | ✓ |

## uxdatetime  (uxdatetime; 12 fonksiyon/sub, 1 sabit, testte çağrılan 11)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxdatetime.Version` | `()` | STRING |  |
| `uxdatetime.UnixMillisecondsUtc` | `()` | I64 | ✓ |
| `uxdatetime.FileTimeUtc` | `()` | U64 | ✓ |
| `uxdatetime.MonotonicTicks` | `()` | I64 | ✓ |
| `uxdatetime.MonotonicFrequency` | `()` | I64 | ✓ |
| `uxdatetime.FormatUtc` | `(unixMilliseconds AS I64)` | STRING | ✓ |
| `uxdatetime.FormatLocal` | `(unixMilliseconds AS I64)` | STRING | ✓ |
| `uxdatetime.ParseUtc` | `(iso8601 AS STRING)` | I64 | ✓ |
| `uxdatetime.AddMilliseconds` | `(unixMilliseconds AS I64,delta AS I64)` | I64 | ✓ |
| `uxdatetime.DifferenceMilliseconds` | `(laterMilliseconds AS I64,earlierMilliseconds AS I64)` | I64 | ✓ |
| `uxdatetime.SleepMilliseconds` | `(milliseconds AS U32)` |  | ✓ |
| `uxdatetime.ErrorText` | `()` | STRING | ✓ |

## uxfs  (uxfs; 23 fonksiyon/sub, 1 sabit, testte çağrılan 22)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxfs.Version` | `()` | STRING |  |
| `uxfs.Exists` | `(path AS STRING)` | I32 | ✓ |
| `uxfs.FileExists` | `(path AS STRING)` | I32 | ✓ |
| `uxfs.DirectoryExists` | `(path AS STRING)` | I32 | ✓ |
| `uxfs.CreateDirectory` | `(path AS STRING)` | I32 | ✓ |
| `uxfs.CreateDirectories` | `(path AS STRING)` | I32 | ✓ |
| `uxfs.DeleteFile` | `(path AS STRING)` | I32 | ✓ |
| `uxfs.RemoveDirectory` | `(path AS STRING)` | I32 | ✓ |
| `uxfs.CopyFile` | `(source AS STRING,target AS STRING,overwrite AS I32)` | I32 | ✓ |
| `uxfs.Move` | `(source AS STRING,target AS STRING,overwrite AS I32)` | I32 | ✓ |
| `uxfs.FileSize` | `(path AS STRING)` | I64 | ✓ |
| `uxfs.GetAttributes` | `(path AS STRING)` | U32 | ✓ |
| `uxfs.SetAttributes` | `(path AS STRING,attributes AS U32)` | I32 | ✓ |
| `uxfs.ReadAllText` | `(path AS STRING)` | STRING | ✓ |
| `uxfs.WriteAllText` | `(path AS STRING,text AS STRING)` | I32 | ✓ |
| `uxfs.AppendText` | `(path AS STRING,text AS STRING)` | I32 | ✓ |
| `uxfs.EnumOpen` | `(pattern AS STRING)` | U64 | ✓ |
| `uxfs.EnumNext` | `(handle AS U64)` | I32 | ✓ |
| `uxfs.EnumName` | `(handle AS U64)` | STRING | ✓ |
| `uxfs.EnumIsDirectory` | `(handle AS U64)` | I32 | ✓ |
| `uxfs.EnumSize` | `(handle AS U64)` | U64 | ✓ |
| `uxfs.EnumClose` | `(handle AS U64)` |  | ✓ |
| `uxfs.ErrorText` | `()` | STRING | ✓ |

## uxgraph  (uxgraph; 30 fonksiyon/sub, 1 sabit, testte çağrılan 30)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxgraph.Create` | `(vertices AS I32, directed AS I32)` | U64 | ✓ |
| `uxgraph.Free` | `(g AS U64)` |  | ✓ |
| `uxgraph.AddVertex` | `(g AS U64)` | I32 | ✓ |
| `uxgraph.AddVertices` | `(g AS U64, count AS I32)` | I32 | ✓ |
| `uxgraph.AddEdge` | `(g AS U64, fromV AS I32, toV AS I32)` | I32 | ✓ |
| `uxgraph.VCount` | `(g AS U64)` | I32 | ✓ |
| `uxgraph.ECount` | `(g AS U64)` | I32 | ✓ |
| `uxgraph.IsDirected` | `(g AS U64)` | I32 | ✓ |
| `uxgraph.HasEdge` | `(g AS U64, fromV AS I32, toV AS I32)` | I32 | ✓ |
| `uxgraph.Degree` | `(g AS U64, v AS I32)` | I32 | ✓ |
| `uxgraph.InDegree` | `(g AS U64, v AS I32)` | I32 | ✓ |
| `uxgraph.OutDegree` | `(g AS U64, v AS I32)` | I32 | ✓ |
| `uxgraph.Density` | `(g AS U64)` | F64 | ✓ |
| `uxgraph.SelfLoops` | `(g AS U64)` | I32 | ✓ |
| `uxgraph.Components` | `(g AS U64)` | I32 | ✓ |
| `uxgraph.IsConnected` | `(g AS U64)` | I32 | ✓ |
| `uxgraph.ShortestDistance` | `(g AS U64, source AS I32, target AS I32)` | I32 | ✓ |
| `uxgraph.PathExists` | `(g AS U64, source AS I32, target AS I32)` | I32 | ✓ |
| `uxgraph.TriangleCount` | `(g AS U64)` | I32 | ✓ |
| `uxgraph.Transitivity` | `(g AS U64)` | F64 | ✓ |
| `uxgraph.DegreeVector` | `(g AS U64, mode AS I32)` | U64 | ✓ |
| `uxgraph.BFSDistances` | `(g AS U64, source AS I32)` | U64 | ✓ |
| `uxgraph.VecCount` | `(v AS U64)` | I32 | ✓ |
| `uxgraph.VecGet` | `(v AS U64, index AS I32)` | F64 | ✓ |
| `uxgraph.VecFree` | `(v AS U64)` |  | ✓ |
| `uxgraph.WriteEdgeListCSV` | `(g AS U64, path AS STRING)` | I32 | ✓ |
| `uxgraph.ReadEdgeListCSV` | `(path AS STRING, directed AS I32)` | U64 | ✓ |
| `uxgraph.MakePath` | `(vertices AS I32, directed AS I32)` | U64 | ✓ |
| `uxgraph.MakeCycle` | `(vertices AS I32, directed AS I32)` | U64 | ✓ |
| `uxgraph.MakeComplete` | `(vertices AS I32, directed AS I32)` | U64 | ✓ |

## uxgsl  (uxgsl; 236 fonksiyon/sub, 2 sabit, testte çağrılan 50)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxgsl.ApiVersion` | `()` | I32 | ✓ |
| `uxgsl.Available` | `()` | I32 | ✓ |
| `uxgsl.GslVersion` | `()` | STRING | ✓ |
| `uxgsl.SelfTest` | `()` | I32 | ✓ |
| `uxgsl.LastStatus` | `()` | I32 | ✓ |
| `uxgsl.LastGslStatus` | `()` | I32 |  |
| `uxgsl.LastError` | `()` | STRING | ✓ |
| `uxgsl.StatusText` | `(status AS I32)` | STRING |  |
| `uxgsl.BesselJ0` | `(x AS F64)` | F64 | ✓ |
| `uxgsl.BesselJ1` | `(x AS F64)` | F64 |  |
| `uxgsl.BesselY0` | `(x AS F64)` | F64 |  |
| `uxgsl.Gamma` | `(x AS F64)` | F64 | ✓ |
| `uxgsl.LnGamma` | `(x AS F64)` | F64 |  |
| `uxgsl.Erf` | `(x AS F64)` | F64 | ✓ |
| `uxgsl.GaussianPdf` | `(x AS F64, sigma AS F64)` | F64 | ✓ |
| `uxgsl.RngCreate` | `(seed AS U64)` | U64 | ✓ |
| `uxgsl.RngFree` | `(handle AS U64)` |  | ✓ |
| `uxgsl.RngUniform` | `(handle AS U64)` | F64 | ✓ |
| `uxgsl.RngGaussian` | `(handle AS U64, sigma AS F64)` | F64 |  |
| `uxgsl.VectorCreate` | `(count AS I32)` | U64 | ✓ |
| `uxgsl.VectorFree` | `(handle AS U64)` |  | ✓ |
| `uxgsl.VectorSize` | `(handle AS U64)` | I32 | ✓ |
| `uxgsl.VectorSet` | `(handle AS U64, index AS I32, value AS F64)` | I32 | ✓ |
| `uxgsl.VectorGet` | `(handle AS U64, index AS I32)` | F64 | ✓ |
| `uxgsl.VectorMean` | `(handle AS U64)` | F64 | ✓ |
| `uxgsl.VectorStandardDeviation` | `(handle AS U64)` | F64 |  |
| `uxgsl.VectorVariance` | `(handle AS U64)` | F64 | ✓ |
| `uxgsl.MatrixCreate` | `(rows AS I32, columns AS I32)` | U64 | ✓ |
| `uxgsl.MatrixFree` | `(handle AS U64)` |  | ✓ |
| `uxgsl.MatrixRows` | `(handle AS U64)` | I32 | ✓ |
| `uxgsl.MatrixColumns` | `(handle AS U64)` | I32 | ✓ |
| `uxgsl.MatrixSet` | `(handle AS U64, row AS I32, column AS I32, value AS F64)` | I32 | ✓ |
| `uxgsl.MatrixGet` | `(handle AS U64, row AS I32, column AS I32)` | F64 | ✓ |
| `uxgsl.MatrixSetZero` | `(handle AS U64)` | I32 |  |
| `uxgsl.MatrixSetIdentity` | `(handle AS U64)` | I32 | ✓ |
| `uxgsl.MatrixMultiply` | `(leftHandle AS U64, rightHandle AS U64, outputHandle AS U64)` | I32 | ✓ |
| `uxgsl.IntegrationWorkspaceCreate` | `(limit AS I32)` | U64 | ✓ |
| `uxgsl.IntegrationWorkspaceFree` | `(handle AS U64)` |  | ✓ |
| `uxgsl.IntegrateQag` | `(callbackAddress AS PTR, userData AS PTR, lower AS F64, upper AS F64, absoluteTolerance AS F64, relativeTolerance AS F64, limit AS I32, key AS I32, workspaceHandle AS U64)` | F64 | ✓ |
| `uxgsl.LastEstimatedError` | `()` | F64 | ✓ |
| `uxgsl.RootBisectionCreate` | `()` | U64 | ✓ |
| `uxgsl.RootBisectionFree` | `(handle AS U64)` |  | ✓ |
| `uxgsl.RootBisectionSet` | `(handle AS U64, callbackAddress AS PTR, userData AS PTR, lower AS F64, upper AS F64)` | I32 | ✓ |
| `uxgsl.RootBisectionIterate` | `(handle AS U64)` | I32 | ✓ |
| `uxgsl.RootBisectionRoot` | `(handle AS U64)` | F64 | ✓ |
| `uxgsl.RootBisectionLower` | `(handle AS U64)` | F64 |  |
| `uxgsl.RootBisectionUpper` | `(handle AS U64)` | F64 |  |
| `uxgsl.RootBisectionIntervalConverged` | `(handle AS U64, absoluteTolerance AS F64, relativeTolerance AS F64)` | I32 | ✓ |
| `uxgsl.ComplexCreate` | `(real AS F64, imaginary AS F64)` | U64 | ✓ |
| `uxgsl.ComplexFree` | `(handle AS U64)` |  | ✓ |
| `uxgsl.ComplexReal` | `(handle AS U64)` | F64 | ✓ |
| `uxgsl.ComplexImaginary` | `(handle AS U64)` | F64 | ✓ |
| `uxgsl.ComplexAbs` | `(handle AS U64)` | F64 |  |
| `uxgsl.ComplexAdd` | `(leftHandle AS U64, rightHandle AS U64, outputHandle AS U64)` | I32 | ✓ |
| `uxgsl.ComplexMultiply` | `(leftHandle AS U64, rightHandle AS U64, outputHandle AS U64)` | I32 | ✓ |
| `uxgsl.GslSymbol` | `(symbolName AS STRING)` | U64 |  |
| `uxgsl.CblasSymbol` | `(symbolName AS STRING)` | U64 | ✓ |
| `uxgsl.GslCallNew` | `(symbolName AS STRING, returnKind AS I32, isVariadic AS I32, fixedArgumentCount AS I32)` | U64 | ✓ |
| `uxgsl.CblasCallNew` | `(symbolName AS STRING, returnKind AS I32, isVariadic AS I32, fixedArgumentCount AS I32)` | U64 |  |
| `uxgsl.SfAiryZeroAi` | `(arg0 AS U32)` | F64 | ✓ |
| `uxgsl.SfAiryZeroAiDeriv` | `(arg0 AS U32)` | F64 |  |
| `uxgsl.SfAiryZeroBi` | `(arg0 AS U32)` | F64 |  |
| `uxgsl.SfAiryZeroBiDeriv` | `(arg0 AS U32)` | F64 |  |
| `uxgsl.SfBesselI0` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselI0Scaled_Gslsf_bessel_UpperI0_scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselI1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselI1Scaled_Gslsf_bessel_UpperI1_scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselIn` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselInScaled` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselInu` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselInuScaled` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselJ1_Gslsf_bessel_UpperJ1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselJn` | `(arg0 AS I32, arg1 AS F64)` | F64 | ✓ |
| `uxgsl.SfBesselJnu` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselK0` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselK0Scaled_Gslsf_bessel_UpperK0_scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselK1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselK1Scaled_Gslsf_bessel_UpperK1_scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselKn` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselKnScaled` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselKnu` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselKnuScaled` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselY0_Gslsf_bessel_UpperY0` | `(arg0 AS F64)` | F64 | ✓ |
| `uxgsl.SfBesselY1_Gslsf_bessel_UpperY1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselYn` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselYnu` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselI0Scaled_Gslsf_bessel_i0_scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselI1Scaled_Gslsf_bessel_i1_scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselI2Scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselIlScaled` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselJ0` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselJ1_Gslsf_bessel_j1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselJ2` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselJl` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselK0Scaled_Gslsf_bessel_k0_scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselK1Scaled_Gslsf_bessel_k1_scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselK2Scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselKlScaled` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselLnKnu` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselY0_Gslsf_bessel_y0` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselY1_Gslsf_bessel_y1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselY2` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBesselYl` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBesselZeroJ0` | `(arg0 AS U32)` | F64 |  |
| `uxgsl.SfBesselZeroJ1` | `(arg0 AS U32)` | F64 |  |
| `uxgsl.SfBesselZeroJnu` | `(arg0 AS F64, arg1 AS U32)` | F64 |  |
| `uxgsl.SfHydrogenicR` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64, arg3 AS F64)` | F64 |  |
| `uxgsl.SfCoupling6j` | `(arg0 AS I32, arg1 AS I32, arg2 AS I32, arg3 AS I32, arg4 AS I32, arg5 AS I32)` | F64 |  |
| `uxgsl.SfCoupling6jINCORRECT` | `(arg0 AS I32, arg1 AS I32, arg2 AS I32, arg3 AS I32, arg4 AS I32, arg5 AS I32)` | F64 |  |
| `uxgsl.SfCoupling9j` | `(arg0 AS I32, arg1 AS I32, arg2 AS I32, arg3 AS I32, arg4 AS I32, arg5 AS I32, arg6 AS I32, arg7 AS I32, arg8 AS I32)` | F64 |  |
| `uxgsl.SfCouplingRacahW` | `(arg0 AS I32, arg1 AS I32, arg2 AS I32, arg3 AS I32, arg4 AS I32, arg5 AS I32)` | F64 |  |
| `uxgsl.SfDebye2` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfDebye3` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfDebye4` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfDebye5` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfDebye6` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfErf` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfErfQ` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfErfZ` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfHazard` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfLogErfc` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExpMult` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfExpm1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExprel` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExprel2` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExprelN` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfChi` | `(arg0 AS F64)` | F64 | ✓ |
| `uxgsl.SfCi` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfShi` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfSi` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfAtanint` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExpint3` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExpintE1Scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExpintE2` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExpintE2Scaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExpintEi` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExpintEiScaled` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfExpintEn` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfExpintEnScaled` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfFermiDirac0` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfFermiDirac1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfFermiDirac2` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfFermiDirac3half` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfFermiDiracHalf` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfFermiDiracInc0` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfFermiDiracInt` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfFermiDiracMhalf` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfBeta` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfBetaInc` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64)` | F64 |  |
| `uxgsl.SfChoose` | `(arg0 AS U32, arg1 AS U32)` | F64 |  |
| `uxgsl.SfDoublefact` | `(arg0 AS U32)` | F64 |  |
| `uxgsl.SfFact` | `(arg0 AS U32)` | F64 |  |
| `uxgsl.SfGamma` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfGammaInc` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfGammaIncP` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfGammaIncQ` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfGammainv` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfGammastar` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfLnbeta` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfLnchoose` | `(arg0 AS U32, arg1 AS U32)` | F64 |  |
| `uxgsl.SfLndoublefact` | `(arg0 AS U32)` | F64 |  |
| `uxgsl.SfLnfact` | `(arg0 AS U32)` | F64 |  |
| `uxgsl.SfLnpoch` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfPoch` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfPochrel` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfTaylorcoeff` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfGegenpoly2` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfGegenpoly3` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfGegenpolyN` | `(arg0 AS I32, arg1 AS F64, arg2 AS F64)` | F64 |  |
| `uxgsl.SfHermite` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfHermiteDeriv` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  |
| `uxgsl.SfHermiteFunc` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfHermiteFuncDer` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  |
| `uxgsl.SfHermiteFuncFast` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfHermiteFuncZero` | `(arg0 AS I32, arg1 AS I32)` | F64 |  |
| `uxgsl.SfHermitePhys` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfHermitePhysDer` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  |
| `uxgsl.SfHermitePhysZero` | `(arg0 AS I32, arg1 AS I32)` | F64 |  |
| `uxgsl.SfHermiteProbDer` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  |
| `uxgsl.SfHermiteProbDeriv` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  |
| `uxgsl.SfHermiteProbZero` | `(arg0 AS I32, arg1 AS I32)` | F64 |  |
| `uxgsl.SfHermiteZero` | `(arg0 AS I32, arg1 AS I32)` | F64 |  |
| `uxgsl.SfHyperg1F1` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64)` | F64 |  |
| `uxgsl.SfHyperg1F1Int` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  |
| `uxgsl.SfHyperg2F0` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64)` | F64 |  |
| `uxgsl.SfHyperg2F1` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64, arg3 AS F64)` | F64 |  |
| `uxgsl.SfHyperg2F1Conj` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64, arg3 AS F64)` | F64 |  |
| `uxgsl.SfHyperg2F1ConjRenorm` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64, arg3 AS F64)` | F64 |  |
| `uxgsl.SfHyperg2F1Renorm` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64, arg3 AS F64)` | F64 |  |
| `uxgsl.SfHypergU` | `(arg0 AS F64, arg1 AS F64, arg2 AS F64)` | F64 |  |
| `uxgsl.SfHypergUInt` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  |
| `uxgsl.SfLaguerre2` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfLaguerre3` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfLaguerreN` | `(arg0 AS I32, arg1 AS F64, arg2 AS F64)` | F64 |  |
| `uxgsl.SfLambertWm1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfConicalP0` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfConicalP1` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfConicalPCylReg` | `(arg0 AS I32, arg1 AS F64, arg2 AS F64)` | F64 |  |
| `uxgsl.SfConicalPHalf` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfConicalPMhalf` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfConicalPSphReg` | `(arg0 AS I32, arg1 AS F64, arg2 AS F64)` | F64 |  |
| `uxgsl.SfLegendreH3d` | `(arg0 AS I32, arg1 AS F64, arg2 AS F64)` | F64 |  |
| `uxgsl.SfLegendreH3d0` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfLegendreH3d1` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfLegendreP1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfLegendreP2` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfLegendreP3` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfLegendrePlm` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  |
| `uxgsl.SfLegendreQ0` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfLegendreQ1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfLegendreQl` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfLegendreSphPlm` | `(arg0 AS I32, arg1 AS I32, arg2 AS F64)` | F64 |  |
| `uxgsl.SfLog1plusx` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfLog1plusxMx` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfLogAbs` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfPsi` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfPsi1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfPsi1Int` | `(arg0 AS I32)` | F64 |  |
| `uxgsl.SfPsi1piy` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfPsiN` | `(arg0 AS I32, arg1 AS F64)` | F64 |  |
| `uxgsl.SfCosPi` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfSynchrotron2` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfTransport3` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfTransport4` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfTransport5` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfCos` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfHypot` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfLncosh` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfLnsinh` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfSinc` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfEta` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfEtaInt` | `(arg0 AS I32)` | F64 |  |
| `uxgsl.SfHzeta` | `(arg0 AS F64, arg1 AS F64)` | F64 |  |
| `uxgsl.SfZeta` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfZetam1` | `(arg0 AS F64)` | F64 |  |
| `uxgsl.SfZetam1Int` | `(arg0 AS I32)` | F64 |  |

## uxhttp  (uxhttp; 30 fonksiyon/sub, 0 sabit, testte çağrılan 28)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxhttp.Version` | `()` | STRING |  |
| `uxhttp.Open` | `()` | U64 | ✓ |
| `uxhttp.Close` | `(h AS U64)` |  | ✓ |
| `uxhttp.SetUrl` | `(h AS U64, url AS STRING)` | I32 | ✓ |
| `uxhttp.SetMethod` | `(h AS U64, methodName AS STRING)` | I32 | ✓ |
| `uxhttp.AddHeader` | `(h AS U64, header AS STRING)` | I32 | ✓ |
| `uxhttp.SetBody` | `(h AS U64, body AS STRING)` | I32 | ✓ |
| `uxhttp.SetTimeout` | `(h AS U64, timeoutMs AS I64)` | I32 | ✓ |
| `uxhttp.FollowRedirects` | `(h AS U64, enabled AS I32)` | I32 | ✓ |
| `uxhttp.Perform` | `(h AS U64)` | I32 | ✓ |
| `uxhttp.Status` | `(h AS U64)` | I64 | ✓ |
| `uxhttp.ResponseText` | `(h AS U64)` | STRING | ✓ |
| `uxhttp.ResponseSize` | `(h AS U64)` | U64 | ✓ |
| `uxhttp.SaveResponse` | `(h AS U64, path AS STRING)` | I32 | ✓ |
| `uxhttp.ErrorText` | `(h AS U64)` | STRING | ✓ |
| `uxhttp.Version` | `()` | STRING |  |
| `uxhttp.Open` | `()` | U64 | ✓ |
| `uxhttp.Close` | `(h AS U64)` |  | ✓ |
| `uxhttp.SetUrl` | `(h AS U64, url AS STRING)` | I32 | ✓ |
| `uxhttp.SetMethod` | `(h AS U64, methodName AS STRING)` | I32 | ✓ |
| `uxhttp.AddHeader` | `(h AS U64, header AS STRING)` | I32 | ✓ |
| `uxhttp.SetBody` | `(h AS U64, body AS STRING)` | I32 | ✓ |
| `uxhttp.SetTimeout` | `(h AS U64, timeoutMs AS I64)` | I32 | ✓ |
| `uxhttp.FollowRedirects` | `(h AS U64, enabled AS I32)` | I32 | ✓ |
| `uxhttp.Perform` | `(h AS U64)` | I32 | ✓ |
| `uxhttp.Status` | `(h AS U64)` | I64 | ✓ |
| `uxhttp.ResponseText` | `(h AS U64)` | STRING | ✓ |
| `uxhttp.ResponseSize` | `(h AS U64)` | U64 | ✓ |
| `uxhttp.SaveResponse` | `(h AS U64, path AS STRING)` | I32 | ✓ |
| `uxhttp.ErrorText` | `(h AS U64)` | STRING | ✓ |

## uxjson  (uxjson; 32 fonksiyon/sub, 0 sabit, testte çağrılan 28)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxjson.Version` | `()` | STRING |  |
| `uxjson.Parse` | `(text AS STRING)` | U64 | ✓ |
| `uxjson.Free` | `(doc AS U64)` |  | ✓ |
| `uxjson.Root` | `(doc AS U64)` | U64 | ✓ |
| `uxjson.PointerGet` | `(doc AS U64, pointer AS STRING)` | U64 | ✓ |
| `uxjson.ObjectGet` | `(value AS U64, key AS STRING)` | U64 | ✓ |
| `uxjson.ArrayGet` | `(value AS U64, index0 AS U64)` | U64 | ✓ |
| `uxjson.ArraySize` | `(value AS U64)` | U64 | ✓ |
| `uxjson.ValueType` | `(value AS U64)` | I32 | ✓ |
| `uxjson.GetString` | `(value AS U64)` | STRING | ✓ |
| `uxjson.GetI64` | `(value AS U64)` | I64 | ✓ |
| `uxjson.GetU64` | `(value AS U64)` | U64 | ✓ |
| `uxjson.GetF64` | `(value AS U64)` | F64 |  |
| `uxjson.GetBoolean` | `(value AS U64)` | I32 | ✓ |
| `uxjson.Write` | `(doc AS U64, pretty AS I32)` | STRING | ✓ |
| `uxjson.ErrorText` | `()` | STRING | ✓ |
| `uxjson.Version` | `()` | STRING |  |
| `uxjson.Parse` | `(text AS STRING)` | U64 | ✓ |
| `uxjson.Free` | `(doc AS U64)` |  | ✓ |
| `uxjson.Root` | `(doc AS U64)` | U64 | ✓ |
| `uxjson.PointerGet` | `(doc AS U64, pointer AS STRING)` | U64 | ✓ |
| `uxjson.ObjectGet` | `(value AS U64, key AS STRING)` | U64 | ✓ |
| `uxjson.ArrayGet` | `(value AS U64, index0 AS U64)` | U64 | ✓ |
| `uxjson.ArraySize` | `(value AS U64)` | U64 | ✓ |
| `uxjson.ValueType` | `(value AS U64)` | I32 | ✓ |
| `uxjson.GetString` | `(value AS U64)` | STRING | ✓ |
| `uxjson.GetI64` | `(value AS U64)` | I64 | ✓ |
| `uxjson.GetU64` | `(value AS U64)` | U64 | ✓ |
| `uxjson.GetF64` | `(value AS U64)` | F64 |  |
| `uxjson.GetBoolean` | `(value AS U64)` | I32 | ✓ |
| `uxjson.Write` | `(doc AS U64, pretty AS I32)` | STRING | ✓ |
| `uxjson.ErrorText` | `()` | STRING | ✓ |

## uxjsruntime  (namespace yok; 25 fonksiyon/sub, 0 sabit, testte çağrılan 25)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `JsRuntimeApiVersion` | `()` | I32 | ✓ |
| `JsContractVersion` | `()` | I32 | ✓ |
| `JsQuickJsVersion` | `()` | STRING | ✓ |
| `JsEvalScriptFlag` | `()` | I32 | ✓ |
| `JsEvalModuleFlag` | `()` | I32 | ✓ |
| `JsEvalDrainJobsFlag` | `()` | I32 | ✓ |
| `JsRuntimeCreate` | `()` | I32 | ✓ |
| `JsRuntimeFree` | `(runtimeHandle AS I32)` | I32 | ✓ |
| `JsRuntimeMemoryLimitMb` | `(runtimeHandle AS I32, megabytes AS I32)` | I32 | ✓ |
| `JsRuntimeStackLimitKb` | `(runtimeHandle AS I32, kilobytes AS I32)` | I32 | ✓ |
| `JsRuntimeTimeLimitMs` | `(runtimeHandle AS I32, milliseconds AS I32)` | I32 | ✓ |
| `JsRuntimeCollectGarbage` | `(runtimeHandle AS I32)` | I32 | ✓ |
| `JsContextCreate` | `(runtimeHandle AS I32)` | I32 | ✓ |
| `JsContextFree` | `(contextHandle AS I32)` | I32 | ✓ |
| `JsInstallNativeHost` | `(contextHandle AS I32)` | I32 | ✓ |
| `JsBootstrapUxb` | `(contextHandle AS I32, corePath AS STRING, providerPath AS STRING)` | I32 | ✓ |
| `JsEval` | `(contextHandle AS I32, sourceText AS STRING, filename AS STRING, flags AS I32)` | I32 | ✓ |
| `JsEvalFile` | `(contextHandle AS I32, pathValue AS STRING, flags AS I32)` | I32 | ✓ |
| `JsPumpJobs` | `(runtimeHandle AS I32, maxJobs AS I32)` | I32 | ✓ |
| `JsCall` | `(contextHandle AS I32, functionName AS STRING, argumentsJson AS STRING)` | I32 | ✓ |
| `JsCallAwait` | `(contextHandle AS I32, functionName AS STRING, argumentsJson AS STRING, maxJobs AS I32)` | I32 | ✓ |
| `JsResultJson` | `(contextHandle AS I32, resultHandle AS I32)` | STRING | ✓ |
| `JsResultFree` | `(contextHandle AS I32, resultHandle AS I32)` | I32 | ✓ |
| `JsLastError` | `(contextHandle AS I32)` | STRING | ✓ |
| `JsClearError` | `(contextHandle AS I32)` | I32 | ✓ |

## uxllama  (uxllama; 17 fonksiyon/sub, 4 sabit, testte çağrılan 17)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxllama.Create` | `()` | U64 | ✓ |
| `uxllama.Free` | `(h AS U64)` |  | ✓ |
| `uxllama.SetCliPath` | `(h AS U64, path AS STRING)` | I32 | ✓ |
| `uxllama.SetModelPath` | `(h AS U64, path AS STRING)` | I32 | ✓ |
| `uxllama.SetThreads` | `(h AS U64, n AS I32)` | I32 | ✓ |
| `uxllama.SetContext` | `(h AS U64, n AS I32)` | I32 | ✓ |
| `uxllama.SetPredict` | `(h AS U64, n AS I32)` | I32 | ✓ |
| `uxllama.SetTemperature` | `(h AS U64, t AS F64)` | I32 | ✓ |
| `uxllama.SetTopP` | `(h AS U64, p AS F64)` | I32 | ✓ |
| `uxllama.SetTopK` | `(h AS U64, k AS I32)` | I32 | ✓ |
| `uxllama.SetSeed` | `(h AS U64, seed AS I32)` | I32 | ✓ |
| `uxllama.LowMemoryProfile` | `(h AS U64, profile AS I32)` | I32 | ✓ |
| `uxllama.ModelExists` | `(h AS U64)` | I32 | ✓ |
| `uxllama.Prompt` | `(h AS U64, prompt AS STRING, outBuf AS U64, outBytes AS I32)` | I32 | ✓ |
| `uxllama.PromptFile` | `(h AS U64, promptFile AS STRING, outBuf AS U64, outBytes AS I32)` | I32 | ✓ |
| `uxllama.LastError` | `(h AS U64, outBuf AS U64, outBytes AS I32)` | I32 | ✓ |
| `uxllama.LastCommand` | `(h AS U64, outBuf AS U64, outBytes AS I32)` | I32 | ✓ |

## uxllamax  (uxllamax; 18 fonksiyon/sub, 4 sabit, testte çağrılan 18)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxllamax.Version` | `()` | I32 | ✓ |
| `uxllamax.Create` | `()` | U64 | ✓ |
| `uxllamax.Free` | `(h AS U64)` |  | ✓ |
| `uxllamax.SetCliPath` | `(h AS U64, path AS STRING)` | I32 | ✓ |
| `uxllamax.SetModelPath` | `(h AS U64, path AS STRING)` | I32 | ✓ |
| `uxllamax.SetThreads` | `(h AS U64, value AS I32)` | I32 | ✓ |
| `uxllamax.SetContext` | `(h AS U64, value AS I32)` | I32 | ✓ |
| `uxllamax.SetPredict` | `(h AS U64, value AS I32)` | I32 | ✓ |
| `uxllamax.SetTemperature` | `(h AS U64, value AS F64)` | I32 | ✓ |
| `uxllamax.SetTopP` | `(h AS U64, value AS F64)` | I32 | ✓ |
| `uxllamax.SetTopK` | `(h AS U64, value AS I32)` | I32 | ✓ |
| `uxllamax.SetSeed` | `(h AS U64, value AS I32)` | I32 | ✓ |
| `uxllamax.LowMemoryProfile` | `(h AS U64, profile AS I32)` | I32 | ✓ |
| `uxllamax.ModelExists` | `(h AS U64)` | I32 | ✓ |
| `uxllamax.Prompt` | `(h AS U64, promptText AS STRING, outBuffer AS U64, outBytes AS I32)` | I32 | ✓ |
| `uxllamax.PromptFile` | `(h AS U64, promptPath AS STRING, outBuffer AS U64, outBytes AS I32)` | I32 | ✓ |
| `uxllamax.LastError` | `(h AS U64, outBuffer AS U64, outBytes AS I32)` | I32 | ✓ |
| `uxllamax.LastCommand` | `(h AS U64, outBuffer AS U64, outBytes AS I32)` | I32 | ✓ |

## uxlog  (uxlog; 13 fonksiyon/sub, 1 sabit, testte çağrılan 11)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxlog.Version` | `()` | STRING |  |
| `uxlog.Open` | `(path AS STRING,minLevel AS I32,rotateBytes AS U64)` | U64 | ✓ |
| `uxlog.Write` | `(handle AS U64,level AS I32,message AS STRING)` | I32 | ✓ |
| `uxlog.Trace` | `(handle AS U64,message AS STRING)` | I32 |  |
| `uxlog.Debug` | `(handle AS U64,message AS STRING)` | I32 | ✓ |
| `uxlog.Info` | `(handle AS U64,message AS STRING)` | I32 | ✓ |
| `uxlog.Warning` | `(handle AS U64,message AS STRING)` | I32 | ✓ |
| `uxlog.Error` | `(handle AS U64,message AS STRING)` | I32 | ✓ |
| `uxlog.Fatal` | `(handle AS U64,message AS STRING)` | I32 | ✓ |
| `uxlog.SetLevel` | `(handle AS U64,level AS I32)` | I32 | ✓ |
| `uxlog.Flush` | `(handle AS U64)` |  | ✓ |
| `uxlog.Close` | `(handle AS U64)` |  | ✓ |
| `uxlog.LastError` | `()` | STRING | ✓ |

## uxlogic  (uxlogic; 19 fonksiyon/sub, 0 sabit, testte çağrılan 13)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxlogic.Version` | `()` | I32 | ✓ |
| `uxlogic.LastError` | `()` | STRING |  |
| `uxlogic.LastText` | `()` | STRING | ✓ |
| `uxlogic.LuaLoad` | `(dllPath AS STRING)` | I32 | ✓ |
| `uxlogic.LuaNew` | `()` | U64 | ✓ |
| `uxlogic.LuaClose` | `(state AS U64)` |  | ✓ |
| `uxlogic.LuaDoString` | `(state AS U64, code AS STRING)` | I32 |  |
| `uxlogic.LuaDoFile` | `(state AS U64, path AS STRING)` | I32 | ✓ |
| `uxlogic.LuaGetNumber` | `(state AS U64, name AS STRING)` | F64 | ✓ |
| `uxlogic.LuaGetString` | `(state AS U64, name AS STRING)` | STRING | ✓ |
| `uxlogic.LuaSetNumber` | `(state AS U64, name AS STRING, value AS F64)` |  | ✓ |
| `uxlogic.PrologQuery` | `(scriptPath AS STRING, goal AS STRING)` | I32 | ✓ |
| `uxlogic.PrologQueryWith` | `(swiplPath AS STRING, scriptPath AS STRING, goal AS STRING)` | I32 |  |
| `uxlogic.Triangle` | `(x AS F64, a AS F64, b AS F64, c AS F64)` | F64 | ✓ |
| `uxlogic.Trapezoid` | `(x AS F64, a AS F64, b AS F64, c AS F64, d AS F64)` | F64 |  |
| `uxlogic.FuzzyAnd` | `(a AS F64, b AS F64)` | F64 | ✓ |
| `uxlogic.FuzzyOr` | `(a AS F64, b AS F64)` | F64 |  |
| `uxlogic.FuzzyNot` | `(value AS F64)` | F64 |  |
| `uxlogic.Weighted` | `(value1 AS F64, weight1 AS F64, value2 AS F64, weight2 AS F64)` | F64 | ✓ |

## uxmath  (namespace yok; 42 fonksiyon/sub, 0 sabit, testte çağrılan 42)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `UXMATH_Version` | `()` | I32 | ✓ |
| `UXMATH_VecCreate` | `(capacity AS I32)` | U64 | ✓ |
| `UXMATH_VecFree` | `(h AS U64)` | I32 | ✓ |
| `UXMATH_VecPush` | `(h AS U64, value AS F64)` | I32 | ✓ |
| `UXMATH_VecSet` | `(h AS U64, index AS I32, value AS F64)` | I32 | ✓ |
| `UXMATH_VecGet` | `(h AS U64, index AS I32)` | F64 | ✓ |
| `UXMATH_VecCount` | `(h AS U64)` | I32 | ✓ |
| `UXMATH_VecClear` | `(h AS U64)` | I32 | ✓ |
| `UXMATH_VecDataPtr` | `(h AS U64)` | U64 | ✓ |
| `UXMATH_PolyEval` | `(coeffs AS U64, x AS F64)` | F64 | ✓ |
| `UXMATH_PolyDerivativeEval` | `(coeffs AS U64, x AS F64)` | F64 | ✓ |
| `UXMATH_PolyIntegralEval` | `(coeffs AS U64, a AS F64, b AS F64)` | F64 | ✓ |
| `UXMATH_PolyDerivativeCoeff` | `(coeffs AS U64, outCoeffs AS U64)` | I32 | ✓ |
| `UXMATH_PolyIntegralCoeff` | `(coeffs AS U64, outCoeffs AS U64, c0 AS F64)` | I32 | ✓ |
| `UXMATH_PolyBisection` | `(coeffs AS U64, a AS F64, b AS F64, maxIter AS I32, tolerance AS F64)` | F64 | ✓ |
| `UXMATH_PolyNewton` | `(coeffs AS U64, x0 AS F64, maxIter AS I32, tolerance AS F64)` | F64 | ✓ |
| `UXMATH_NumericDerivativePoly` | `(coeffs AS U64, x AS F64, h AS F64)` | F64 | ✓ |
| `UXMATH_IntegratePolySimpson` | `(coeffs AS U64, a AS F64, b AS F64, intervals AS I32)` | F64 | ✓ |
| `UXMATH_ODE_RK4_Logistic` | `(y0 AS F64, rate AS F64, capacity AS F64, t0 AS F64, t1 AS F64, steps AS I32)` | F64 | ✓ |
| `UXMATH_ODE_Euler_Logistic` | `(y0 AS F64, rate AS F64, capacity AS F64, t0 AS F64, t1 AS F64, steps AS I32)` | F64 | ✓ |
| `UXMATH_Sigmoid` | `(x AS F64)` | F64 | ✓ |
| `UXMATH_DSigmoidFromOutput` | `(y AS F64)` | F64 | ✓ |
| `UXMATH_ReLU` | `(x AS F64)` | F64 | ✓ |
| `UXMATH_DReLU` | `(x AS F64)` | F64 | ✓ |
| `UXMATH_Tanh` | `(x AS F64)` | F64 | ✓ |
| `UXMATH_DTanhFromOutput` | `(y AS F64)` | F64 | ✓ |
| `UXMATH_VecSoftmax` | `(src AS U64, dst AS U64)` | I32 | ✓ |
| `UXMATH_MatCreate` | `(rows AS I32, cols AS I32)` | U64 | ✓ |
| `UXMATH_MatFree` | `(matrix AS U64)` | I32 | ✓ |
| `UXMATH_MatRows` | `(matrix AS U64)` | I32 | ✓ |
| `UXMATH_MatCols` | `(matrix AS U64)` | I32 | ✓ |
| `UXMATH_MatSet` | `(matrix AS U64, row AS I32, col AS I32, value AS F64)` | I32 | ✓ |
| `UXMATH_MatGet` | `(matrix AS U64, row AS I32, col AS I32)` | F64 | ✓ |
| `UXMATH_MatFill` | `(matrix AS U64, value AS F64)` | I32 | ✓ |
| `UXMATH_MatRandomUniform` | `(matrix AS U64, lo AS F64, hi AS F64, seed AS U32)` | I32 | ✓ |
| `UXMATH_MatAdd` | `(a AS U64, b AS U64, output AS U64)` | I32 | ✓ |
| `UXMATH_MatSub` | `(a AS U64, b AS U64, output AS U64)` | I32 | ✓ |
| `UXMATH_MatMul` | `(a AS U64, b AS U64, output AS U64)` | I32 | ✓ |
| `UXMATH_MatTranspose` | `(a AS U64, output AS U64)` | I32 | ✓ |
| `UXMATH_MatApplySigmoid` | `(a AS U64, output AS U64)` | I32 | ✓ |
| `UXMATH_MatApplyReLU` | `(a AS U64, output AS U64)` | I32 | ✓ |
| `UXMATH_MatVecMul` | `(matrix AS U64, vector AS U64, output AS U64)` | I32 | ✓ |

## uxmathcore  (namespace yok; 51 fonksiyon/sub, 0 sabit, testte çağrılan 51)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `UXMC_TYPE_I8` | `()` | I32 | ✓ |
| `UXMC_TYPE_U8` | `()` | I32 | ✓ |
| `UXMC_TYPE_I16` | `()` | I32 | ✓ |
| `UXMC_TYPE_U16` | `()` | I32 | ✓ |
| `UXMC_TYPE_I32` | `()` | I32 | ✓ |
| `UXMC_TYPE_U32` | `()` | I32 | ✓ |
| `UXMC_TYPE_I64` | `()` | I32 | ✓ |
| `UXMC_TYPE_U64` | `()` | I32 | ✓ |
| `UXMC_TYPE_F32` | `()` | I32 | ✓ |
| `UXMC_TYPE_F64` | `()` | I32 | ✓ |
| `UXMC_Version` | `()` | I32 | ✓ |
| `UXMC_TypeSize` | `(typeId AS I32)` | I32 | ✓ |
| `UXMC_BufferCreate` | `(typeId AS I32, count AS I32)` | U64 | ✓ |
| `UXMC_BufferCreateCapacity` | `(typeId AS I32, count AS I32, capacity AS I32)` | U64 | ✓ |
| `UXMC_BufferFree` | `(h AS U64)` | I32 | ✓ |
| `UXMC_BufferType` | `(h AS U64)` | I32 | ✓ |
| `UXMC_BufferCount` | `(h AS U64)` | I32 | ✓ |
| `UXMC_BufferCapacity` | `(h AS U64)` | I32 | ✓ |
| `UXMC_BufferElemSize` | `(h AS U64)` | I32 | ✓ |
| `UXMC_BufferByteSize` | `(h AS U64)` | I64 | ✓ |
| `UXMC_BufferDataPtr` | `(h AS U64)` | U64 | ✓ |
| `UXMC_BufferClear` | `(h AS U64)` | I32 | ✓ |
| `UXMC_BufferResize` | `(h AS U64, count AS I32)` | I32 | ✓ |
| `UXMC_BufferReserve` | `(h AS U64, capacity AS I32)` | I32 | ✓ |
| `UXMC_BufferFillZero` | `(h AS U64)` | I32 | ✓ |
| `UXMC_BufferClone` | `(h AS U64)` | U64 | ✓ |
| `UXMC_BufferSlice` | `(h AS U64, startIndex AS I32, count AS I32)` | U64 | ✓ |
| `UXMC_BufferAppend` | `(dst AS U64, src AS U64)` | I32 | ✓ |
| `UXMC_BufferCast` | `(src AS U64, dstType AS I32)` | U64 | ✓ |
| `UXMC_GetF64` | `(h AS U64, index AS I32)` | F64 | ✓ |
| `UXMC_SetF64` | `(h AS U64, index AS I32, value AS F64)` | I32 | ✓ |
| `UXMC_PushF64` | `(h AS U64, value AS F64)` | I32 | ✓ |
| `UXMC_FillF64` | `(h AS U64, value AS F64)` | I32 | ✓ |
| `UXMC_SetI64` | `(h AS U64, index AS I32, value AS I64)` | I32 | ✓ |
| `UXMC_PushI64` | `(h AS U64, value AS I64)` | I32 | ✓ |
| `UXMC_SetU64` | `(h AS U64, index AS I32, value AS U64)` | I32 | ✓ |
| `UXMC_PushU64` | `(h AS U64, value AS U64)` | I32 | ✓ |
| `UXMC_SetByte` | `(h AS U64, index AS I32, value AS I32)` | I32 | ✓ |
| `UXMC_PushByte` | `(h AS U64, value AS I32)` | I32 | ✓ |
| `UXMC_VecAddF64` | `(a AS U64, b AS U64, outv AS U64)` | I32 | ✓ |
| `UXMC_VecSubF64` | `(a AS U64, b AS U64, outv AS U64)` | I32 | ✓ |
| `UXMC_VecMulF64` | `(a AS U64, b AS U64, outv AS U64)` | I32 | ✓ |
| `UXMC_VecDivF64` | `(a AS U64, b AS U64, outv AS U64)` | I32 | ✓ |
| `UXMC_VecScaleF64` | `(a AS U64, scalar AS F64, outv AS U64)` | I32 | ✓ |
| `UXMC_VecAxpyF64` | `(alpha AS F64, x AS U64, y AS U64, outv AS U64)` | I32 | ✓ |
| `UXMC_VecDotF64` | `(a AS U64, b AS U64)` | F64 | ✓ |
| `UXMC_VecL1NormF64` | `(a AS U64)` | F64 | ✓ |
| `UXMC_VecL2NormF64` | `(a AS U64)` | F64 | ✓ |
| `UXMC_VecNormalizeL2F64` | `(a AS U64, outv AS U64)` | I32 | ✓ |
| `UXMC_VecMinF64` | `(a AS U64)` | F64 | ✓ |
| `UXMC_VecMaxF64` | `(a AS U64)` | F64 | ✓ |

## uxmatrix  (uxmatrix; 34 fonksiyon/sub, 1 sabit, testte çağrılan 33)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxmatrix.RuntimeVersion` | `()` | I32 |  |
| `uxmatrix.Create` | `(rows AS I32, cols AS I32)` | U64 | ✓ |
| `uxmatrix.Free` | `(m AS U64)` |  | ✓ |
| `uxmatrix.Rows` | `(m AS U64)` | I32 | ✓ |
| `uxmatrix.Cols` | `(m AS U64)` | I32 | ✓ |
| `uxmatrix.Size` | `(m AS U64)` | I32 | ✓ |
| `uxmatrix.DataPtr` | `(m AS U64)` | U64 | ✓ |
| `uxmatrix.Set` | `(m AS U64, r AS I32, c AS I32, v AS F64)` | I32 | ✓ |
| `uxmatrix.Get` | `(m AS U64, r AS I32, c AS I32)` | F64 | ✓ |
| `uxmatrix.Fill` | `(m AS U64, v AS F64)` | I32 | ✓ |
| `uxmatrix.Zero` | `(m AS U64)` | I32 | ✓ |
| `uxmatrix.Eye` | `(m AS U64)` | I32 | ✓ |
| `uxmatrix.Clone` | `(m AS U64)` | U64 | ✓ |
| `uxmatrix.Transpose` | `(a AS U64)` | U64 | ✓ |
| `uxmatrix.Add` | `(a AS U64, b AS U64)` | U64 | ✓ |
| `uxmatrix.Sub` | `(a AS U64, b AS U64)` | U64 | ✓ |
| `uxmatrix.Scale` | `(a AS U64, s AS F64)` | U64 | ✓ |
| `uxmatrix.Mul` | `(a AS U64, b AS U64)` | U64 | ✓ |
| `uxmatrix.MatVec` | `(a AS U64, x AS U64)` | U64 | ✓ |
| `uxmatrix.Dot` | `(a AS U64, b AS U64)` | F64 | ✓ |
| `uxmatrix.NormL1` | `(a AS U64)` | F64 | ✓ |
| `uxmatrix.NormL2` | `(a AS U64)` | F64 | ✓ |
| `uxmatrix.NormFro` | `(a AS U64)` | F64 | ✓ |
| `uxmatrix.Trace` | `(a AS U64)` | F64 | ✓ |
| `uxmatrix.PrintMatrix` | `(a AS U64)` | I32 | ✓ |
| `uxmatrix.Det` | `(a AS U64)` | F64 | ✓ |
| `uxmatrix.Solve` | `(a AS U64, b AS U64)` | U64 | ✓ |
| `uxmatrix.Inverse` | `(a AS U64)` | U64 | ✓ |
| `uxmatrix.Cholesky` | `(a AS U64)` | U64 | ✓ |
| `uxmatrix.QR` | `(a AS U64, qOutPtr AS U64, rOutPtr AS U64)` | I32 | ✓ |
| `uxmatrix.SVD` | `(a AS U64, uOutPtr AS U64, sOutPtr AS U64, vtOutPtr AS U64)` | I32 | ✓ |
| `uxmatrix.EigenSymmetric` | `(a AS U64, valuesOutPtr AS U64, vectorsOutPtr AS U64)` | I32 | ✓ |
| `uxmatrix.RankSVD` | `(a AS U64, tol AS F64)` | I32 | ✓ |
| `uxmatrix.Cond2` | `(a AS U64)` | F64 | ✓ |

## uxnn  (uxnn; 33 fonksiyon/sub, 11 sabit, testte çağrılan 32)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxnn.Version` | `()` | I32 |  |
| `uxnn.Backend` | `()` | STRING | ✓ |
| `uxnn.Seed` | `(seed AS U64)` |  | ✓ |
| `uxnn.NeuronCreate` | `(inputCount AS I32, activation AS I32)` | U64 | ✓ |
| `uxnn.NeuronFree` | `(n AS U64)` |  | ✓ |
| `uxnn.NeuronSetWeight` | `(n AS U64, index AS I32, value AS F64)` |  | ✓ |
| `uxnn.NeuronGetWeight` | `(n AS U64, index AS I32)` | F64 | ✓ |
| `uxnn.NeuronSetBias` | `(n AS U64, value AS F64)` |  | ✓ |
| `uxnn.NeuronGetBias` | `(n AS U64)` | F64 | ✓ |
| `uxnn.NeuronForwardPtr` | `(n AS U64, inputPtr AS U64)` | F64 | ✓ |
| `uxnn.DenseLayerCreate` | `(inputDim AS I32, outputDim AS I32, activation AS I32)` | U64 | ✓ |
| `uxnn.ActivationLayerCreate` | `(size AS I32, activation AS I32)` | U64 | ✓ |
| `uxnn.LayerFree` | `(layer AS U64)` |  | ✓ |
| `uxnn.LayerInputDim` | `(layer AS U64)` | I32 | ✓ |
| `uxnn.LayerOutputDim` | `(layer AS U64)` | I32 | ✓ |
| `uxnn.LayerSetWeight` | `(layer AS U64, outIndex AS I32, inIndex AS I32, value AS F64)` |  | ✓ |
| `uxnn.LayerGetWeight` | `(layer AS U64, outIndex AS I32, inIndex AS I32)` | F64 | ✓ |
| `uxnn.LayerSetBias` | `(layer AS U64, outIndex AS I32, value AS F64)` |  | ✓ |
| `uxnn.LayerGetBias` | `(layer AS U64, outIndex AS I32)` | F64 | ✓ |
| `uxnn.LayerInit` | `(layer AS U64, initKind AS I32, scale AS F64)` |  | ✓ |
| `uxnn.LayerForwardPtr` | `(layer AS U64, inputPtr AS U64, outputPtr AS U64)` |  | ✓ |
| `uxnn.NetworkCreate` | `()` | U64 | ✓ |
| `uxnn.NetworkFree` | `(net AS U64)` |  | ✓ |
| `uxnn.NetworkAddLayer` | `(net AS U64, layer AS U64)` | I32 | ✓ |
| `uxnn.NetworkLayerCount` | `(net AS U64)` | I32 | ✓ |
| `uxnn.NetworkInputDim` | `(net AS U64)` | I32 | ✓ |
| `uxnn.NetworkOutputDim` | `(net AS U64)` | I32 | ✓ |
| `uxnn.NetworkForwardPtr` | `(net AS U64, inputPtr AS U64, outputPtr AS U64)` |  | ✓ |
| `uxnn.NetworkPredictArgmaxPtr` | `(net AS U64, inputPtr AS U64)` | I32 | ✓ |
| `uxnn.NetworkMSEPtr` | `(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, inputDim AS I32, outputDim AS I32)` | F64 | ✓ |
| `uxnn.NetworkTrainMSESGDPtr` | `(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, inputDim AS I32, outputDim AS I32, epochs AS I32, lr AS F64)` | F64 | ✓ |
| `uxnn.NetworkForwardTensor` | `(net AS U64, inputTensor AS U64, outputTensor AS U64)` |  | ✓ |
| `uxnn.NetworkPredictArgmaxTensor` | `(net AS U64, inputTensor AS U64)` | I32 | ✓ |

## uxnn2  (uxnn2; 23 fonksiyon/sub, 14 sabit, testte çağrılan 20)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxnn2.Version` | `()` | I32 |  |
| `uxnn2.Backend` | `()` | STRING | ✓ |
| `uxnn2.Seed` | `(seed AS U64)` |  | ✓ |
| `uxnn2.NetworkCreate` | `(inputDim AS I32)` | U64 | ✓ |
| `uxnn2.NetworkFree` | `(net AS U64)` |  | ✓ |
| `uxnn2.AddDense` | `(net AS U64, outputDim AS I32, activation AS I32)` | I32 | ✓ |
| `uxnn2.LayerCount` | `(net AS U64)` | I32 | ✓ |
| `uxnn2.InputDim` | `(net AS U64)` | I32 |  |
| `uxnn2.OutputDim` | `(net AS U64)` | I32 | ✓ |
| `uxnn2.Init` | `(net AS U64, initKind AS I32, scale AS F64)` |  | ✓ |
| `uxnn2.SetOptimizer` | `(net AS U64, optKind AS I32, learningRate AS F64)` |  |  |
| `uxnn2.SetOptimizerParams` | `(net AS U64, beta1 AS F64, beta2 AS F64, epsilon AS F64, weightDecay AS F64)` |  | ✓ |
| `uxnn2.ForwardPtr` | `(net AS U64, inputPtr AS U64, outputPtr AS U64)` |  | ✓ |
| `uxnn2.LossMSEPtr` | `(net AS U64, inputPtr AS U64, targetPtr AS U64)` | F64 | ✓ |
| `uxnn2.TrainSampleMSEPtr` | `(net AS U64, inputPtr AS U64, targetPtr AS U64)` | F64 | ✓ |
| `uxnn2.TrainArrayMSEPtr` | `(net AS U64, xPtr AS U64, yPtr AS U64, sampleCount AS I32, epochs AS I32, shuffle AS I32)` | F64 | ✓ |
| `uxnn2.PredictArgmaxPtr` | `(net AS U64, inputPtr AS U64)` | I32 | ✓ |
| `uxnn2.GetWeight` | `(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32)` | F64 | ✓ |
| `uxnn2.SetWeight` | `(net AS U64, layerIndex AS I32, outIndex AS I32, inIndex AS I32, value AS F64)` |  | ✓ |
| `uxnn2.GetBias` | `(net AS U64, layerIndex AS I32, outIndex AS I32)` | F64 | ✓ |
| `uxnn2.SetBias` | `(net AS U64, layerIndex AS I32, outIndex AS I32, value AS F64)` |  | ✓ |
| `uxnn2.Save` | `(net AS U64, path AS STRING)` | I32 | ✓ |
| `uxnn2.Load` | `(path AS STRING)` | U64 | ✓ |

## uxnn3  (uxnn3; 33 fonksiyon/sub, 8 sabit, testte çağrılan 29)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxnn3.Version` | `()` | I32 |  |
| `uxnn3.LastError` | `()` | STRING | ✓ |
| `uxnn3.DatasetCreate` | `(rows AS I32, inputDim AS I32, outputDim AS I32)` | U64 | ✓ |
| `uxnn3.DatasetFree` | `(ds AS U64)` |  | ✓ |
| `uxnn3.LoadCSV` | `(path AS STRING, inputDim AS I32, outputDim AS I32, hasHeader AS I32)` | U64 |  |
| `uxnn3.SaveCSV` | `(ds AS U64, path AS STRING, includeHeader AS I32)` | I32 | ✓ |
| `uxnn3.Rows` | `(ds AS U64)` | I32 | ✓ |
| `uxnn3.InputDim` | `(ds AS U64)` | I32 |  |
| `uxnn3.OutputDim` | `(ds AS U64)` | I32 |  |
| `uxnn3.XGet` | `(ds AS U64, row AS I32, col AS I32)` | F64 | ✓ |
| `uxnn3.YGet` | `(ds AS U64, row AS I32, col AS I32)` | F64 | ✓ |
| `uxnn3.XSet` | `(ds AS U64, row AS I32, col AS I32, v AS F64)` | I32 | ✓ |
| `uxnn3.YSet` | `(ds AS U64, row AS I32, col AS I32, v AS F64)` | I32 | ✓ |
| `uxnn3.XPtr` | `(ds AS U64)` | U64 | ✓ |
| `uxnn3.YPtr` | `(ds AS U64)` | U64 | ✓ |
| `uxnn3.Shuffle` | `(ds AS U64, seed AS U32)` | I32 | ✓ |
| `uxnn3.SplitTrain` | `(ds AS U64, ratio AS F64, seed AS U32)` | U64 | ✓ |
| `uxnn3.SplitTest` | `(ds AS U64, ratio AS F64, seed AS U32)` | U64 | ✓ |
| `uxnn3.Standardize` | `(ds AS U64)` | I32 | ✓ |
| `uxnn3.MinMax` | `(ds AS U64, a AS F64, b AS F64)` | I32 | ✓ |
| `uxnn3.ModelCreate` | `(inputDim AS I32)` | U64 | ✓ |
| `uxnn3.ModelFree` | `(model AS U64)` |  | ✓ |
| `uxnn3.AddDense` | `(model AS U64, outputDim AS I32, activation AS I32)` | I32 | ✓ |
| `uxnn3.Init` | `(model AS U64, seed AS U32, scale AS F64)` | I32 | ✓ |
| `uxnn3.SetOptimizer` | `(model AS U64, opt AS I32, lr AS F64, momentum AS F64)` | I32 | ✓ |
| `uxnn3.LayerCount` | `(model AS U64)` | I32 | ✓ |
| `uxnn3.ModelOutputDim` | `(model AS U64)` | I32 | ✓ |
| `uxnn3.PredictArgMax` | `(model AS U64, ds AS U64, row AS I32)` | I32 | ✓ |
| `uxnn3.TrainDataset` | `(model AS U64, ds AS U64, epochs AS I32, batchSize AS I32, shuffle AS I32, seed AS U32)` | F64 | ✓ |
| `uxnn3.EvalMSE` | `(model AS U64, ds AS U64)` | F64 | ✓ |
| `uxnn3.EvalBinaryAccuracy` | `(model AS U64, ds AS U64, threshold AS F64)` | F64 | ✓ |
| `uxnn3.Save` | `(model AS U64, path AS STRING)` | I32 | ✓ |
| `uxnn3.Load` | `(path AS STRING)` | U64 | ✓ |

## uxonnx  (uxonnx; 21 fonksiyon/sub, 1 sabit, testte çağrılan 20)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxonnx.Init` | `(runtimeDir AS STRING)` | I32 | ✓ |
| `uxonnx.Version` | `()` | STRING | ✓ |
| `uxonnx.LastError` | `(session AS U64)` | STRING | ✓ |
| `uxonnx.SessionCreate` | `(modelPath AS STRING, intraThreads AS I32)` | U64 | ✓ |
| `uxonnx.SessionFree` | `(session AS U64)` |  | ✓ |
| `uxonnx.InputCount` | `(session AS U64)` | I64 | ✓ |
| `uxonnx.OutputCount` | `(session AS U64)` | I64 | ✓ |
| `uxonnx.InputName` | `(session AS U64, index AS I64)` | STRING | ✓ |
| `uxonnx.OutputName` | `(session AS U64, index AS I64)` | STRING | ✓ |
| `uxonnx.TensorCreate1D` | `(n AS I64)` | U64 | ✓ |
| `uxonnx.TensorCreate2D` | `(r AS I64, c AS I64)` | U64 | ✓ |
| `uxonnx.TensorCreate3D` | `(a AS I64, b AS I64, c AS I64)` | U64 | ✓ |
| `uxonnx.TensorCreate4D` | `(a AS I64, b AS I64, c AS I64, d AS I64)` | U64 | ✓ |
| `uxonnx.TensorFree` | `(t AS U64)` |  | ✓ |
| `uxonnx.TensorCount` | `(t AS U64)` | I64 | ✓ |
| `uxonnx.TensorRank` | `(t AS U64)` | I64 |  |
| `uxonnx.TensorDim` | `(t AS U64, axis AS I64)` | I64 | ✓ |
| `uxonnx.TensorDataPtr` | `(t AS U64)` | U64 | ✓ |
| `uxonnx.TensorSet` | `(t AS U64, idx AS I64, value AS F64)` |  | ✓ |
| `uxonnx.TensorGet` | `(t AS U64, idx AS I64)` | F64 | ✓ |
| `uxonnx.Run1` | `(session AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING)` | U64 | ✓ |

## uxonnx2  (uxonnx2; 42 fonksiyon/sub, 14 sabit, testte çağrılan 40)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxonnx2.Init` | `(runtimeDir AS STRING)` | I32 | ✓ |
| `uxonnx2.Version` | `()` | STRING | ✓ |
| `uxonnx2.LastError` | `()` | STRING | ✓ |
| `uxonnx2.ProviderAvailable` | `(provider AS I32)` | I32 | ✓ |
| `uxonnx2.SessionCreate` | `(modelPath AS STRING)` | U64 | ✓ |
| `uxonnx2.SessionCreateAdvanced` | `(modelPath AS STRING, provider AS I32, intraThreads AS I32, interThreads AS I32, graphOpt AS I32)` | U64 | ✓ |
| `uxonnx2.SessionFree` | `(s AS U64)` |  | ✓ |
| `uxonnx2.InputCount` | `(s AS U64)` | I64 | ✓ |
| `uxonnx2.OutputCount` | `(s AS U64)` | I64 | ✓ |
| `uxonnx2.InputName` | `(s AS U64, idx AS I64)` | STRING | ✓ |
| `uxonnx2.OutputName` | `(s AS U64, idx AS I64)` | STRING | ✓ |
| `uxonnx2.InputDType` | `(s AS U64, idx AS I64)` | I32 | ✓ |
| `uxonnx2.OutputDType` | `(s AS U64, idx AS I64)` | I32 | ✓ |
| `uxonnx2.InputRank` | `(s AS U64, idx AS I64)` | I64 | ✓ |
| `uxonnx2.OutputRank` | `(s AS U64, idx AS I64)` | I64 | ✓ |
| `uxonnx2.InputDim` | `(s AS U64, idx AS I64, axis AS I64)` | I64 |  |
| `uxonnx2.OutputDim` | `(s AS U64, idx AS I64, axis AS I64)` | I64 |  |
| `uxonnx2.TensorCreate1D` | `(dtype AS I32, n AS I64)` | U64 | ✓ |
| `uxonnx2.TensorCreate2D` | `(dtype AS I32, r AS I64, c AS I64)` | U64 | ✓ |
| `uxonnx2.TensorCreate3D` | `(dtype AS I32, a AS I64, b AS I64, c AS I64)` | U64 | ✓ |
| `uxonnx2.TensorCreate4D` | `(dtype AS I32, a AS I64, b AS I64, c AS I64, d AS I64)` | U64 | ✓ |
| `uxonnx2.TensorFree` | `(t AS U64)` |  | ✓ |
| `uxonnx2.TensorDType` | `(t AS U64)` | I32 | ✓ |
| `uxonnx2.TensorRank` | `(t AS U64)` | I64 | ✓ |
| `uxonnx2.TensorDim` | `(t AS U64, axis AS I64)` | I64 | ✓ |
| `uxonnx2.TensorCount` | `(t AS U64)` | I64 | ✓ |
| `uxonnx2.TensorDataPtr` | `(t AS U64)` | U64 | ✓ |
| `uxonnx2.TensorSetF64` | `(t AS U64, idx AS I64, value AS F64)` |  | ✓ |
| `uxonnx2.TensorGetF64` | `(t AS U64, idx AS I64)` | F64 | ✓ |
| `uxonnx2.TensorSetI64` | `(t AS U64, idx AS I64, value AS I64)` |  | ✓ |
| `uxonnx2.TensorGetI64` | `(t AS U64, idx AS I64)` | I64 | ✓ |
| `uxonnx2.TensorSetString` | `(t AS U64, idx AS I64, value AS STRING)` |  | ✓ |
| `uxonnx2.TensorGetString` | `(t AS U64, idx AS I64)` | STRING | ✓ |
| `uxonnx2.RunCreate` | `(s AS U64)` | U64 | ✓ |
| `uxonnx2.RunFree` | `(r AS U64)` |  | ✓ |
| `uxonnx2.RunAddInput` | `(r AS U64, name AS STRING, t AS U64)` | I32 | ✓ |
| `uxonnx2.RunAddOutput` | `(r AS U64, name AS STRING)` | I32 | ✓ |
| `uxonnx2.RunExecute` | `(r AS U64)` | U64 | ✓ |
| `uxonnx2.ResultFree` | `(res AS U64)` |  | ✓ |
| `uxonnx2.ResultCount` | `(res AS U64)` | I64 | ✓ |
| `uxonnx2.ResultTensor` | `(res AS U64, idx AS I64)` | U64 | ✓ |
| `uxonnx2.Run1` | `(s AS U64, inputName AS STRING, inputTensor AS U64, outputName AS STRING)` | U64 | ✓ |

## uxpath  (uxpath; 14 fonksiyon/sub, 1 sabit, testte çağrılan 13)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxpath.Version` | `()` | STRING |  |
| `uxpath.Join` | `(a AS STRING,b AS STRING)` | STRING | ✓ |
| `uxpath.Combine3` | `(a AS STRING,b AS STRING,c AS STRING)` | STRING | ✓ |
| `uxpath.Full` | `(path AS STRING)` | STRING | ✓ |
| `uxpath.Normalize` | `(path AS STRING)` | STRING | ✓ |
| `uxpath.IsAbsolute` | `(path AS STRING)` | I32 | ✓ |
| `uxpath.FileName` | `(path AS STRING)` | STRING | ✓ |
| `uxpath.DirectoryName` | `(path AS STRING)` | STRING | ✓ |
| `uxpath.Extension` | `(path AS STRING)` | STRING | ✓ |
| `uxpath.Stem` | `(path AS STRING)` | STRING | ✓ |
| `uxpath.ChangeExtension` | `(path AS STRING,ext AS STRING)` | STRING | ✓ |
| `uxpath.HasExtension` | `(path AS STRING,ext AS STRING)` | I32 | ✓ |
| `uxpath.IsInside` | `(rootPath AS STRING,childPath AS STRING)` | I32 | ✓ |
| `uxpath.ErrorText` | `()` | STRING | ✓ |

## uxprocess  (uxprocess; 12 fonksiyon/sub, 1 sabit, testte çağrılan 11)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxprocess.Version` | `()` | STRING |  |
| `uxprocess.Start` | `(command AS STRING,cwd AS STRING,hidden AS I32)` | U64 | ✓ |
| `uxprocess.Wait` | `(handle AS U64,timeoutMs AS U32)` | I32 | ✓ |
| `uxprocess.IsRunning` | `(handle AS U64)` | I32 | ✓ |
| `uxprocess.ExitCode` | `(handle AS U64)` | I32 | ✓ |
| `uxprocess.ProcessId` | `(handle AS U64)` | U32 | ✓ |
| `uxprocess.Kill` | `(handle AS U64,exitCode AS U32)` | I32 | ✓ |
| `uxprocess.Close` | `(handle AS U64)` |  | ✓ |
| `uxprocess.ShellOpen` | `(target AS STRING,parameters AS STRING,cwd AS STRING,showCommand AS I32)` | I32 | ✓ |
| `uxprocess.RunWait` | `(command AS STRING,cwd AS STRING,hidden AS I32,timeoutMs AS U32)` | I32 | ✓ |
| `uxprocess.CurrentProcessId` | `()` | U32 | ✓ |
| `uxprocess.ErrorText` | `()` | STRING | ✓ |

## uxpython  (namespace yok; 20 fonksiyon/sub, 0 sabit, testte çağrılan 20)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `PythonVersion` | `()` | I32 | ✓ |
| `PythonFlagIsolated` | `()` | I32 | ✓ |
| `PythonFlagIgnoreEnvironment` | `()` | I32 | ✓ |
| `PythonFlagNoSite` | `()` | I32 | ✓ |
| `PythonOpen` | `(pythonHome AS STRING, venvPath AS STRING, modulePath AS STRING, flags AS I32)` | U64 | ✓ |
| `PythonClose` | `(session AS U64)` | I32 | ✓ |
| `PythonReady` | `(session AS U64)` | I32 | ✓ |
| `PythonAddPath` | `(session AS U64, pathValue AS STRING)` | I32 | ✓ |
| `PythonError` | `(session AS U64)` | STRING | ✓ |
| `PythonRuntimeVersion` | `(session AS U64)` | STRING | ✓ |
| `PythonImport` | `(session AS U64, moduleName AS STRING)` | U64 | ✓ |
| `PythonGet` | `(session AS U64, objectHandle AS U64, attributeName AS STRING)` | U64 | ✓ |
| `PythonCall` | `(session AS U64, callableHandle AS U64, argsJson AS STRING, kwargsJson AS STRING)` | U64 | ✓ |
| `PythonCallModule` | `(session AS U64, moduleName AS STRING, functionName AS STRING, argsJson AS STRING, kwargsJson AS STRING)` | U64 | ✓ |
| `PythonInt` | `(session AS U64, objectHandle AS U64)` | I64 | ✓ |
| `PythonFloat` | `(session AS U64, objectHandle AS U64)` | F64 | ✓ |
| `PythonString` | `(session AS U64, objectHandle AS U64)` | STRING | ✓ |
| `PythonJson` | `(session AS U64, objectHandle AS U64)` | STRING | ✓ |
| `PythonRelease` | `(session AS U64, objectHandle AS U64)` | I32 | ✓ |
| `PythonShutdown` | `()` | I32 | ✓ |

## uxraylib  (uxraylib; 350 fonksiyon/sub, 10 sabit, testte çağrılan 205)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxraylib.AdapterVersion` | `()` | I32 | ✓ |
| `uxraylib.RaylibVersion` | `()` | STRING | ✓ |
| `uxraylib.RayguiVersion` | `()` | STRING | ✓ |
| `uxraylib.RectangleArea` | `(width AS F64, height AS F64)` | F64 | ✓ |
| `uxraylib.ColorRGBA` | `(r AS I32, g AS I32, b AS I32, a AS I32)` | U32 | ✓ |
| `uxraylib.InitWindow` | `(width AS I32, height AS I32, title AS STRING)` |  | ✓ |
| `uxraylib.WindowShouldClose` | `()` | I32 | ✓ |
| `uxraylib.WindowReady` | `()` | I32 |  |
| `uxraylib.SetTargetFPS` | `(fps AS I32)` |  | ✓ |
| `uxraylib.FrameTime` | `()` | F64 | ✓ |
| `uxraylib.KeyDown` | `(key AS I32)` | I32 | ✓ |
| `uxraylib.KeyPressed` | `(key AS I32)` | I32 |  |
| `uxraylib.BeginDrawing` | `()` |  | ✓ |
| `uxraylib.EndDrawing` | `()` |  | ✓ |
| `uxraylib.ClearBackground` | `(r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.DrawText` | `(text AS STRING, x AS I32, y AS I32, fontSize AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.DrawCircle` | `(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.DrawRectangle` | `(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.CircleCollision` | `(ax AS F64, ay AS F64, ar AS F64, bx AS F64, by AS F64, br AS F64)` | I32 | ✓ |
| `uxraylib.LoadTexture` | `(path AS STRING)` | I32 | ✓ |
| `uxraylib.TextureWidth` | `(handle AS I32)` | I32 |  |
| `uxraylib.TextureHeight` | `(handle AS I32)` | I32 |  |
| `uxraylib.UnloadTexture` | `(handle AS I32)` |  | ✓ |
| `uxraylib.LoadFont` | `(path AS STRING)` | I32 | ✓ |
| `uxraylib.DrawFont` | `(handle AS I32, text AS STRING, x AS F64, y AS F64, size AS F64, spacing AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.UnloadFont` | `(handle AS I32)` |  | ✓ |
| `uxraylib.SetCameraScroll` | `(x AS F64, y AS F64)` |  | ✓ |
| `uxraylib.DrawSprite` | `(handle AS I32, sourceX AS F64, sourceY AS F64, sourceWidth AS F64, sourceHeight AS F64, worldX AS F64, worldY AS F64, scale AS F64, rotation AS F64)` |  | ✓ |
| `uxraylib.RectCollision` | `(ax AS F64, ay AS F64, aw AS F64, ah AS F64, bx AS F64, by AS F64, bw AS F64, bh AS F64)` | I32 | ✓ |
| `uxraylib.SpriteFrame` | `(frame AS I32, frameCount AS I32)` | I32 | ✓ |
| `uxraylib.GuiButton` | `(x AS F64, y AS F64, width AS F64, height AS F64, text AS STRING)` | I32 | ✓ |
| `uxraylib.InitAudio` | `()` |  | ✓ |
| `uxraylib.AudioReady` | `()` | I32 | ✓ |
| `uxraylib.CloseAudio` | `()` |  | ✓ |
| `uxraylib.CloseWindow` | `()` |  | ✓ |
| `uxraylib.IsWindowFullscreen` | `()` | I32 |  |
| `uxraylib.IsWindowFocused` | `()` | I32 |  |
| `uxraylib.IsWindowResized` | `()` | I32 |  |
| `uxraylib.IsWindowMinimized` | `()` | I32 |  |
| `uxraylib.IsWindowMaximized` | `()` | I32 |  |
| `uxraylib.ToggleFullscreen` | `()` |  |  |
| `uxraylib.SetWindowTitle` | `(title AS STRING)` |  |  |
| `uxraylib.SetWindowSize` | `(width AS I32, height AS I32)` |  |  |
| `uxraylib.SetWindowPosition` | `(x AS I32, y AS I32)` |  |  |
| `uxraylib.SetWindowMinSize` | `(width AS I32, height AS I32)` |  |  |
| `uxraylib.GetScreenWidth` | `()` | I32 |  |
| `uxraylib.GetScreenHeight` | `()` | I32 |  |
| `uxraylib.GetFPS` | `()` | I32 |  |
| `uxraylib.GetTime` | `()` | F64 |  |
| `uxraylib.SetConfigFlags` | `(flags AS U32)` |  |  |
| `uxraylib.TakeScreenshot` | `(fileName AS STRING)` |  |  |
| `uxraylib.WaitTime` | `(seconds AS F64)` |  |  |
| `uxraylib.ShowCursor` | `()` |  |  |
| `uxraylib.HideCursor` | `()` |  |  |
| `uxraylib.IsCursorHidden` | `()` | I32 |  |
| `uxraylib.EnableCursor` | `()` |  |  |
| `uxraylib.DisableCursor` | `()` |  |  |
| `uxraylib.SetRandomSeed` | `(seed AS U32)` |  |  |
| `uxraylib.GetRandomValue` | `(minVal AS I32, maxVal AS I32)` | I32 |  |
| `uxraylib.KeyReleased` | `(key AS I32)` | I32 |  |
| `uxraylib.KeyUp` | `(key AS I32)` | I32 |  |
| `uxraylib.GetKeyPressed` | `()` | I32 |  |
| `uxraylib.GetCharPressed` | `()` | I32 |  |
| `uxraylib.SetExitKey` | `(key AS I32)` |  |  |
| `uxraylib.MouseButtonPressed` | `(button AS I32)` | I32 |  |
| `uxraylib.MouseButtonDown` | `(button AS I32)` | I32 |  |
| `uxraylib.MouseButtonReleased` | `(button AS I32)` | I32 |  |
| `uxraylib.MouseButtonUp` | `(button AS I32)` | I32 |  |
| `uxraylib.GetMouseX` | `()` | I32 |  |
| `uxraylib.GetMouseY` | `()` | I32 |  |
| `uxraylib.SetMousePosition` | `(x AS I32, y AS I32)` |  |  |
| `uxraylib.GetMouseWheelMove` | `()` | F64 |  |
| `uxraylib.DrawPixel` | `(x AS I32, y AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawLine` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, thick AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawCircleLines` | `(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawCircleGradient` | `(x AS F64, y AS F64, radius AS F64, color1 AS U32, color2 AS U32)` |  |  |
| `uxraylib.DrawEllipse` | `(x AS F64, y AS F64, radiusH AS F64, radiusV AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawEllipseLines` | `(x AS F64, y AS F64, radiusH AS F64, radiusV AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawRectangleLines` | `(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawRectangleRounded` | `(x AS F64, y AS F64, width AS F64, height AS F64, roundness AS F64, segments AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawRectangleGradientV` | `(x AS F64, y AS F64, width AS F64, height AS F64, color1 AS U32, color2 AS U32)` |  |  |
| `uxraylib.DrawRectangleGradientH` | `(x AS F64, y AS F64, width AS F64, height AS F64, color1 AS U32, color2 AS U32)` |  |  |
| `uxraylib.DrawTriangle` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawTriangleLines` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawPoly` | `(x AS F64, y AS F64, sides AS I32, radius AS F64, rotation AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawPolyLines` | `(x AS F64, y AS F64, sides AS I32, radius AS F64, rotation AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.CollisionCircleRec` | `(cx AS F64, cy AS F64, radius AS F64, rx AS F64, ry AS F64, rw AS F64, rh AS F64)` | I32 |  |
| `uxraylib.CollisionPointRec` | `(px AS F64, py AS F64, rx AS F64, ry AS F64, rw AS F64, rh AS F64)` | I32 |  |
| `uxraylib.CollisionPointCircle` | `(px AS F64, py AS F64, cx AS F64, cy AS F64, radius AS F64)` | I32 |  |
| `uxraylib.CollisionPointTriangle` | `(px AS F64, py AS F64, x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64)` | I32 |  |
| `uxraylib.MeasureText` | `(text AS STRING, fontSize AS I32)` | I32 |  |
| `uxraylib.DrawFPS` | `(x AS I32, y AS I32)` |  |  |
| `uxraylib.TextureValid` | `(handle AS I32)` | I32 |  |
| `uxraylib.DrawTexture` | `(handle AS I32, x AS F64, y AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawTextureEx` | `(handle AS I32, x AS F64, y AS F64, rotation AS F64, scale AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.LoadSound` | `(path AS STRING)` | I32 |  |
| `uxraylib.PlaySound` | `(handle AS I32)` |  |  |
| `uxraylib.StopSound` | `(handle AS I32)` |  |  |
| `uxraylib.PauseSound` | `(handle AS I32)` |  |  |
| `uxraylib.ResumeSound` | `(handle AS I32)` |  |  |
| `uxraylib.SoundPlaying` | `(handle AS I32)` | I32 |  |
| `uxraylib.SetSoundVolume` | `(handle AS I32, volume AS F64)` |  |  |
| `uxraylib.SetSoundPitch` | `(handle AS I32, pitch AS F64)` |  |  |
| `uxraylib.UnloadSound` | `(handle AS I32)` |  |  |
| `uxraylib.LoadMusicStream` | `(path AS STRING)` | I32 |  |
| `uxraylib.PlayMusicStream` | `(handle AS I32)` |  |  |
| `uxraylib.UpdateMusicStream` | `(handle AS I32)` |  |  |
| `uxraylib.StopMusicStream` | `(handle AS I32)` |  |  |
| `uxraylib.PauseMusicStream` | `(handle AS I32)` |  |  |
| `uxraylib.ResumeMusicStream` | `(handle AS I32)` |  |  |
| `uxraylib.MusicStreamPlaying` | `(handle AS I32)` | I32 |  |
| `uxraylib.SetMusicVolume` | `(handle AS I32, volume AS F64)` |  |  |
| `uxraylib.GetMusicTimePlayed` | `(handle AS I32)` | F64 |  |
| `uxraylib.GetMusicTimeLength` | `(handle AS I32)` | F64 |  |
| `uxraylib.UnloadMusicStream` | `(handle AS I32)` |  |  |
| `uxraylib.SetMasterVolume` | `(volume AS F64)` |  |  |
| `uxraylib.LoadRenderTexture` | `(width AS I32, height AS I32)` | I32 |  |
| `uxraylib.RenderTextureValid` | `(handle AS I32)` | I32 |  |
| `uxraylib.UnloadRenderTexture` | `(handle AS I32)` |  |  |
| `uxraylib.BeginTextureMode` | `(handle AS I32)` |  |  |
| `uxraylib.EndTextureMode` | `()` |  |  |
| `uxraylib.DrawRenderTexture` | `(handle AS I32, x AS F64, y AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.TextureSetFilter` | `(handle AS I32, filter AS I32)` |  |  |
| `uxraylib.TextureSetWrap` | `(handle AS I32, wrap AS I32)` |  |  |
| `uxraylib.TextureGenMipmaps` | `(handle AS I32)` |  |  |
| `uxraylib.DrawTextureRec` | `(handle AS I32, srcX AS F64, srcY AS F64, srcW AS F64, srcH AS F64, x AS F64, y AS F64, rgba AS U32)` |  |  |
| `uxraylib.DrawTexturePro` | `(handle AS I32, srcX AS F64, srcY AS F64, srcW AS F64, srcH AS F64, dstX AS F64, dstY AS F64, scale AS F64, rotation AS F64, rgba AS U32)` |  |  |
| `uxraylib.ColorFade` | `(rgba AS U32, alpha AS F64)` | U32 |  |
| `uxraylib.ColorAlpha` | `(rgba AS U32, alpha AS F64)` | U32 |  |
| `uxraylib.ColorBrightness` | `(rgba AS U32, factor AS F64)` | U32 |  |
| `uxraylib.ColorContrast` | `(rgba AS U32, contrast AS F64)` | U32 |  |
| `uxraylib.ColorLerp` | `(color1 AS U32, color2 AS U32, factor AS F64)` | U32 |  |
| `uxraylib.ColorIsEqual` | `(color1 AS U32, color2 AS U32)` | I32 |  |
| `uxraylib.GetColor` | `(hexValue AS U32)` | U32 |  |
| `uxraylib.FileExists` | `(fileName AS STRING)` | I32 |  |
| `uxraylib.DirectoryExists` | `(dirPath AS STRING)` | I32 |  |
| `uxraylib.GetFileExtension` | `(fileName AS STRING)` | STRING |  |
| `uxraylib.GetFileNameOnly` | `(filePath AS STRING)` | STRING |  |
| `uxraylib.GetWorkingDirectory` | `()` | STRING |  |
| `uxraylib.SetTextLineSpacing` | `(spacing AS I32)` |  |  |
| `uxraylib.BeginMode2D` | `(offsetX AS F64, offsetY AS F64, targetX AS F64, targetY AS F64, rotation AS F64, zoom AS F64)` |  |  |
| `uxraylib.EndMode2D` | `()` |  |  |
| `uxraylib.DrawRing` | `(x AS F64, y AS F64, innerRadius AS F64, outerRadius AS F64, startAngle AS F64, endAngle AS F64, segments AS I32, rgba AS U32)` |  |  |
| `uxraylib.DrawLineBezier` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, thick AS F64, rgba AS U32)` |  |  |
| `uxraylib.ImageGenColor` | `(width AS I32, height AS I32, rgba AS U32)` | I32 | ✓ |
| `uxraylib.ImageGenChecked` | `(width AS I32, height AS I32, checksX AS I32, checksY AS I32, color1 AS U32, color2 AS U32)` | I32 | ✓ |
| `uxraylib.ImageGenGradientLinear` | `(width AS I32, height AS I32, direction AS I32, startColor AS U32, endColor AS U32)` | I32 | ✓ |
| `uxraylib.ImageLoad` | `(path AS STRING)` | I32 | ✓ |
| `uxraylib.ImageCopy` | `(image AS I32)` | I32 | ✓ |
| `uxraylib.ImageUnload` | `(image AS I32)` |  | ✓ |
| `uxraylib.ImageValid` | `(image AS I32)` | I32 | ✓ |
| `uxraylib.ImageWidth` | `(image AS I32)` | I32 | ✓ |
| `uxraylib.ImageHeight` | `(image AS I32)` | I32 | ✓ |
| `uxraylib.ImagePixelFormat` | `(image AS I32)` | I32 | ✓ |
| `uxraylib.ImageGetColor` | `(image AS I32, x AS I32, y AS I32)` | U32 | ✓ |
| `uxraylib.ImageClearBackground` | `(image AS I32, rgba AS U32)` |  | ✓ |
| `uxraylib.ImageDrawPixel` | `(image AS I32, x AS I32, y AS I32, rgba AS U32)` |  | ✓ |
| `uxraylib.ImageDrawLine` | `(image AS I32, x1 AS I32, y1 AS I32, x2 AS I32, y2 AS I32, rgba AS U32)` |  |  |
| `uxraylib.ImageDrawCircle` | `(image AS I32, centerX AS I32, centerY AS I32, radius AS I32, rgba AS U32)` |  |  |
| `uxraylib.ImageDrawRectangle` | `(image AS I32, x AS I32, y AS I32, width AS I32, height AS I32, rgba AS U32)` |  | ✓ |
| `uxraylib.ImageResize` | `(image AS I32, width AS I32, height AS I32)` |  | ✓ |
| `uxraylib.ImageResizeNN` | `(image AS I32, width AS I32, height AS I32)` |  | ✓ |
| `uxraylib.ImageCrop` | `(image AS I32, x AS I32, y AS I32, width AS I32, height AS I32)` |  | ✓ |
| `uxraylib.ImageFlipVertical` | `(image AS I32)` |  | ✓ |
| `uxraylib.ImageFlipHorizontal` | `(image AS I32)` |  | ✓ |
| `uxraylib.ImageRotateCW` | `(image AS I32)` |  | ✓ |
| `uxraylib.ImageRotateCCW` | `(image AS I32)` |  | ✓ |
| `uxraylib.ImageColorInvert` | `(image AS I32)` |  | ✓ |
| `uxraylib.ImageColorGrayscale` | `(image AS I32)` |  | ✓ |
| `uxraylib.ImageColorContrast` | `(image AS I32, contrast AS F64)` |  |  |
| `uxraylib.ImageColorBrightness` | `(image AS I32, brightness AS I32)` |  | ✓ |
| `uxraylib.ImageColorTint` | `(image AS I32, rgba AS U32)` |  | ✓ |
| `uxraylib.ImageConvertFormat` | `(image AS I32, newFormat AS I32)` |  | ✓ |
| `uxraylib.ImageExport` | `(image AS I32, path AS STRING)` | I32 | ✓ |
| `uxraylib.GuiLabel` | `(x AS F64, y AS F64, width AS F64, height AS F64, text AS STRING)` |  |  |
| `uxraylib.CheckCollisionSpheres` | `(c1x AS F64, c1y AS F64, c1z AS F64, r1 AS F64, c2x AS F64, c2y AS F64, c2z AS F64, r2 AS F64)` | I32 | ✓ |
| `uxraylib.CheckCollisionBoxesSlots` | `(min1 AS I32, max1 AS I32, min2 AS I32, max2 AS I32)` | I32 | ✓ |
| `uxraylib.CheckCollisionBoxSphereSlots` | `(minSlot AS I32, maxSlot AS I32, cx AS F64, cy AS F64, cz AS F64, radius AS F64)` | I32 | ✓ |
| `uxraylib.RayCollisionSphereSlots` | `(posSlot AS I32, dirSlot AS I32, cx AS F64, cy AS F64, cz AS F64, radius AS F64)` | I32 | ✓ |
| `uxraylib.RayCollisionBoxSlots` | `(posSlot AS I32, dirSlot AS I32, minSlot AS I32, maxSlot AS I32)` | I32 | ✓ |
| `uxraylib.RayCollisionTriangleSlots` | `(posSlot AS I32, dirSlot AS I32, p1 AS I32, p2 AS I32, p3 AS I32)` | I32 | ✓ |
| `uxraylib.RayCollisionQuadSlots` | `(posSlot AS I32, dirSlot AS I32, p1 AS I32, p2 AS I32, p3 AS I32, p4 AS I32)` | I32 | ✓ |
| `uxraylib.RayHit` | `()` | I32 | ✓ |
| `uxraylib.RayDistance` | `()` | F64 | ✓ |
| `uxraylib.RayPoint` | `(component AS I32)` | F64 | ✓ |
| `uxraylib.RayNormal` | `(component AS I32)` | F64 | ✓ |
| `uxraylib.CameraCreate` | `(posSlot AS I32, targetSlot AS I32, upSlot AS I32, fovy AS F64, projection AS I32)` | I32 | ✓ |
| `uxraylib.CameraRelease` | `(handle AS I32)` |  | ✓ |
| `uxraylib.CameraValid` | `(handle AS I32)` | I32 | ✓ |
| `uxraylib.CameraGet` | `(handle AS I32, part AS I32, component AS I32)` | F64 | ✓ |
| `uxraylib.CameraSet` | `(handle AS I32, part AS I32, x AS F64, y AS F64, z AS F64)` |  |  |
| `uxraylib.CameraUpdatePro` | `(handle AS I32, moveForward AS F64, moveRight AS F64, moveUp AS F64, yaw AS F64, pitch AS F64, roll AS F64, zoom AS F64)` |  | ✓ |
| `uxraylib.CameraMatrix` | `(handle AS I32)` | I32 | ✓ |
| `uxraylib.WorldToScreen` | `(handle AS I32, px AS F64, py AS F64, pz AS F64, width AS I32, height AS I32)` |  | ✓ |
| `uxraylib.ScreenToWorldRay` | `(handle AS I32, sx AS F64, sy AS F64, width AS I32, height AS I32)` |  | ✓ |
| `uxraylib.Clamp` | `(value AS F64, minValue AS F64, maxValue AS F64)` | F64 | ✓ |
| `uxraylib.Lerp` | `(begin AS F64, finish AS F64, amount AS F64)` | F64 | ✓ |
| `uxraylib.Normalize` | `(value AS F64, begin AS F64, finish AS F64)` | F64 | ✓ |
| `uxraylib.Remap` | `(value AS F64, inputStart AS F64, inputEnd AS F64, outputStart AS F64, outputEnd AS F64)` | F64 | ✓ |
| `uxraylib.Wrap` | `(value AS F64, minValue AS F64, maxValue AS F64)` | F64 | ✓ |
| `uxraylib.FloatEquals` | `(x AS F64, y AS F64)` | I32 | ✓ |
| `uxraylib.Vector2Zero` | `()` |  | ✓ |
| `uxraylib.Vector2One` | `()` |  | ✓ |
| `uxraylib.Vector2Add` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ |
| `uxraylib.Vector2AddValue` | `(vx AS F64, vy AS F64, addend AS F64)` |  | ✓ |
| `uxraylib.Vector2Subtract` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ |
| `uxraylib.Vector2SubtractValue` | `(vx AS F64, vy AS F64, amount AS F64)` |  | ✓ |
| `uxraylib.Vector2Length` | `(vx AS F64, vy AS F64)` | F64 | ✓ |
| `uxraylib.Vector2LengthSqr` | `(vx AS F64, vy AS F64)` | F64 | ✓ |
| `uxraylib.Vector2DotProduct` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` | F64 | ✓ |
| `uxraylib.Vector2Distance` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` | F64 | ✓ |
| `uxraylib.Vector2DistanceSqr` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` | F64 |  |
| `uxraylib.Vector2Angle` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` | F64 | ✓ |
| `uxraylib.Vector2LineAngle` | `(beginx AS F64, beginy AS F64, finishx AS F64, finishy AS F64)` | F64 | ✓ |
| `uxraylib.Vector2Scale` | `(vx AS F64, vy AS F64, scale AS F64)` |  | ✓ |
| `uxraylib.Vector2Multiply` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ |
| `uxraylib.Vector2Negate` | `(vx AS F64, vy AS F64)` |  | ✓ |
| `uxraylib.Vector2Divide` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ |
| `uxraylib.Vector2Normalize` | `(vx AS F64, vy AS F64)` |  | ✓ |
| `uxraylib.Vector2Transform` | `(vx AS F64, vy AS F64, matrix AS I32)` |  | ✓ |
| `uxraylib.Vector2Lerp` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64, amount AS F64)` |  | ✓ |
| `uxraylib.Vector2Reflect` | `(vx AS F64, vy AS F64, normalx AS F64, normaly AS F64)` |  | ✓ |
| `uxraylib.Vector2Min` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ |
| `uxraylib.Vector2Max` | `(v1x AS F64, v1y AS F64, v2x AS F64, v2y AS F64)` |  | ✓ |
| `uxraylib.Vector2Rotate` | `(vx AS F64, vy AS F64, angle AS F64)` |  | ✓ |
| `uxraylib.Vector2MoveTowards` | `(vx AS F64, vy AS F64, targetx AS F64, targety AS F64, maxDistance AS F64)` |  | ✓ |
| `uxraylib.Vector2Invert` | `(vx AS F64, vy AS F64)` |  | ✓ |
| `uxraylib.Vector2Clamp` | `(vx AS F64, vy AS F64, minValuex AS F64, minValuey AS F64, maxValuex AS F64, maxValuey AS F64)` |  | ✓ |
| `uxraylib.Vector2ClampValue` | `(vx AS F64, vy AS F64, minValue AS F64, maxValue AS F64)` |  | ✓ |
| `uxraylib.Vector2Equals` | `(px AS F64, py AS F64, qx AS F64, qy AS F64)` | I32 | ✓ |
| `uxraylib.Vector2Refract` | `(vx AS F64, vy AS F64, nx AS F64, ny AS F64, r AS F64)` |  |  |
| `uxraylib.Vector3Zero` | `()` |  | ✓ |
| `uxraylib.Vector3One` | `()` |  | ✓ |
| `uxraylib.Vector3Add` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ |
| `uxraylib.Vector3AddValue` | `(vx AS F64, vy AS F64, vz AS F64, addend AS F64)` |  | ✓ |
| `uxraylib.Vector3Subtract` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ |
| `uxraylib.Vector3SubtractValue` | `(vx AS F64, vy AS F64, vz AS F64, amount AS F64)` |  | ✓ |
| `uxraylib.Vector3Scale` | `(vx AS F64, vy AS F64, vz AS F64, scalar AS F64)` |  | ✓ |
| `uxraylib.Vector3Multiply` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ |
| `uxraylib.Vector3CrossProduct` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ |
| `uxraylib.Vector3Perpendicular` | `(vx AS F64, vy AS F64, vz AS F64)` |  | ✓ |
| `uxraylib.Vector3Length` | `(vx AS F64, vy AS F64, vz AS F64)` | F64 | ✓ |
| `uxraylib.Vector3LengthSqr` | `(vx AS F64, vy AS F64, vz AS F64)` | F64 | ✓ |
| `uxraylib.Vector3DotProduct` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` | F64 | ✓ |
| `uxraylib.Vector3Distance` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` | F64 | ✓ |
| `uxraylib.Vector3DistanceSqr` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` | F64 |  |
| `uxraylib.Vector3Angle` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` | F64 | ✓ |
| `uxraylib.Vector3Negate` | `(vx AS F64, vy AS F64, vz AS F64)` |  | ✓ |
| `uxraylib.Vector3Divide` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ |
| `uxraylib.Vector3Normalize` | `(vx AS F64, vy AS F64, vz AS F64)` |  | ✓ |
| `uxraylib.Vector3Project` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ |
| `uxraylib.Vector3Reject` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ |
| `uxraylib.Vector3Transform` | `(vx AS F64, vy AS F64, vz AS F64, matrix AS I32)` |  | ✓ |
| `uxraylib.Vector3RotateByQuaternion` | `(vx AS F64, vy AS F64, vz AS F64, qx AS F64, qy AS F64, qz AS F64, qw AS F64)` |  | ✓ |
| `uxraylib.Vector3RotateByAxisAngle` | `(vx AS F64, vy AS F64, vz AS F64, axisx AS F64, axisy AS F64, axisz AS F64, angle AS F64)` |  | ✓ |
| `uxraylib.Vector3MoveTowards` | `(vx AS F64, vy AS F64, vz AS F64, targetx AS F64, targety AS F64, targetz AS F64, maxDistance AS F64)` |  | ✓ |
| `uxraylib.Vector3Lerp` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64, amount AS F64)` |  | ✓ |
| `uxraylib.Vector3Reflect` | `(vx AS F64, vy AS F64, vz AS F64, normalx AS F64, normaly AS F64, normalz AS F64)` |  | ✓ |
| `uxraylib.Vector3Min` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ |
| `uxraylib.Vector3Max` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ |
| `uxraylib.Vector3Unproject` | `(sourcex AS F64, sourcey AS F64, sourcez AS F64, projection AS I32, view AS I32)` |  | ✓ |
| `uxraylib.Vector3Invert` | `(vx AS F64, vy AS F64, vz AS F64)` |  | ✓ |
| `uxraylib.Vector3Clamp` | `(vx AS F64, vy AS F64, vz AS F64, minValuex AS F64, minValuey AS F64, minValuez AS F64, maxValuex AS F64, maxValuey AS F64, maxValuez AS F64)` |  | ✓ |
| `uxraylib.Vector3ClampValue` | `(vx AS F64, vy AS F64, vz AS F64, minValue AS F64, maxValue AS F64)` |  | ✓ |
| `uxraylib.Vector3Equals` | `(px AS F64, py AS F64, pz AS F64, qx AS F64, qy AS F64, qz AS F64)` | I32 | ✓ |
| `uxraylib.Vector3Refract` | `(vx AS F64, vy AS F64, vz AS F64, nx AS F64, ny AS F64, nz AS F64, r AS F64)` |  | ✓ |
| `uxraylib.Vector4Zero` | `()` |  |  |
| `uxraylib.Vector4One` | `()` |  |  |
| `uxraylib.Vector4Add` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  | ✓ |
| `uxraylib.Vector4AddValue` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64, addend AS F64)` |  |  |
| `uxraylib.Vector4Subtract` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  |  |
| `uxraylib.Vector4SubtractValue` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64, addend AS F64)` |  |  |
| `uxraylib.Vector4Length` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64)` | F64 | ✓ |
| `uxraylib.Vector4LengthSqr` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64)` | F64 |  |
| `uxraylib.Vector4DotProduct` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` | F64 | ✓ |
| `uxraylib.Vector4Distance` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` | F64 |  |
| `uxraylib.Vector4DistanceSqr` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` | F64 |  |
| `uxraylib.Vector4Scale` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64, scale AS F64)` |  | ✓ |
| `uxraylib.Vector4Multiply` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  |  |
| `uxraylib.Vector4Negate` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64)` |  |  |
| `uxraylib.Vector4Divide` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  |  |
| `uxraylib.Vector4Normalize` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64)` |  | ✓ |
| `uxraylib.Vector4Min` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  |  |
| `uxraylib.Vector4Max` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64)` |  |  |
| `uxraylib.Vector4Lerp` | `(v1x AS F64, v1y AS F64, v1z AS F64, v1w AS F64, v2x AS F64, v2y AS F64, v2z AS F64, v2w AS F64, amount AS F64)` |  | ✓ |
| `uxraylib.Vector4MoveTowards` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64, targetx AS F64, targety AS F64, targetz AS F64, targetw AS F64, maxDistance AS F64)` |  |  |
| `uxraylib.Vector4Invert` | `(vx AS F64, vy AS F64, vz AS F64, vw AS F64)` |  |  |
| `uxraylib.Vector4Equals` | `(px AS F64, py AS F64, pz AS F64, pw AS F64, qx AS F64, qy AS F64, qz AS F64, qw AS F64)` | I32 |  |
| `uxraylib.MatrixDeterminant` | `(matrix AS I32)` | F64 | ✓ |
| `uxraylib.MatrixTrace` | `(matrix AS I32)` | F64 | ✓ |
| `uxraylib.MatrixTranspose` | `(matrix AS I32)` | I32 | ✓ |
| `uxraylib.MatrixInvert` | `(matrix AS I32)` | I32 | ✓ |
| `uxraylib.MatrixIdentity` | `()` | I32 | ✓ |
| `uxraylib.MatrixAdd` | `(leftEdge AS I32, rightEdge AS I32)` | I32 | ✓ |
| `uxraylib.MatrixSubtract` | `(leftEdge AS I32, rightEdge AS I32)` | I32 | ✓ |
| `uxraylib.MatrixMultiply` | `(leftEdge AS I32, rightEdge AS I32)` | I32 | ✓ |
| `uxraylib.MatrixTranslate` | `(x AS F64, y AS F64, z AS F64)` | I32 | ✓ |
| `uxraylib.MatrixRotate` | `(axisx AS F64, axisy AS F64, axisz AS F64, angle AS F64)` | I32 | ✓ |
| `uxraylib.MatrixRotateX` | `(angle AS F64)` | I32 | ✓ |
| `uxraylib.MatrixRotateY` | `(angle AS F64)` | I32 | ✓ |
| `uxraylib.MatrixRotateZ` | `(angle AS F64)` | I32 | ✓ |
| `uxraylib.MatrixRotateXYZ` | `(anglex AS F64, angley AS F64, anglez AS F64)` | I32 | ✓ |
| `uxraylib.MatrixRotateZYX` | `(anglex AS F64, angley AS F64, anglez AS F64)` | I32 | ✓ |
| `uxraylib.MatrixScale` | `(x AS F64, y AS F64, z AS F64)` | I32 | ✓ |
| `uxraylib.MatrixFrustum` | `(leftEdge AS F64, rightEdge AS F64, bottomEdge AS F64, topEdge AS F64, nearPlane AS F64, farPlane AS F64)` | I32 | ✓ |
| `uxraylib.MatrixPerspective` | `(fovY AS F64, aspect AS F64, nearPlane AS F64, farPlane AS F64)` | I32 | ✓ |
| `uxraylib.MatrixOrtho` | `(leftEdge AS F64, rightEdge AS F64, bottomEdge AS F64, topEdge AS F64, nearPlane AS F64, farPlane AS F64)` | I32 | ✓ |
| `uxraylib.MatrixLookAt` | `(eyex AS F64, eyey AS F64, eyez AS F64, targetx AS F64, targety AS F64, targetz AS F64, upx AS F64, upy AS F64, upz AS F64)` | I32 | ✓ |
| `uxraylib.QuaternionAdd` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64)` |  | ✓ |
| `uxraylib.QuaternionAddValue` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64, addend AS F64)` |  |  |
| `uxraylib.QuaternionSubtract` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64)` |  |  |
| `uxraylib.QuaternionSubtractValue` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64, amount AS F64)` |  |  |
| `uxraylib.QuaternionIdentity` | `()` |  | ✓ |
| `uxraylib.QuaternionLength` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` | F64 | ✓ |
| `uxraylib.QuaternionNormalize` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` |  | ✓ |
| `uxraylib.QuaternionInvert` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` |  | ✓ |
| `uxraylib.QuaternionMultiply` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64)` |  | ✓ |
| `uxraylib.QuaternionScale` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64, factor AS F64)` |  | ✓ |
| `uxraylib.QuaternionDivide` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64)` |  |  |
| `uxraylib.QuaternionLerp` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64, amount AS F64)` |  |  |
| `uxraylib.QuaternionNlerp` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64, amount AS F64)` |  | ✓ |
| `uxraylib.QuaternionSlerp` | `(q1x AS F64, q1y AS F64, q1z AS F64, q1w AS F64, q2x AS F64, q2y AS F64, q2z AS F64, q2w AS F64, amount AS F64)` |  | ✓ |
| `uxraylib.QuaternionFromVector3ToVector3` | `(fromVecx AS F64, fromVecy AS F64, fromVecz AS F64, toVecx AS F64, toVecy AS F64, toVecz AS F64)` |  | ✓ |
| `uxraylib.QuaternionFromMatrix` | `(matrix AS I32)` |  |  |
| `uxraylib.QuaternionToMatrix` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` | I32 | ✓ |
| `uxraylib.QuaternionFromAxisAngle` | `(axisx AS F64, axisy AS F64, axisz AS F64, angle AS F64)` |  | ✓ |
| `uxraylib.QuaternionFromEuler` | `(pitch AS F64, yaw AS F64, roll AS F64)` |  | ✓ |
| `uxraylib.QuaternionToEuler` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` |  | ✓ |
| `uxraylib.QuaternionTransform` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64, matrix AS I32)` |  | ✓ |
| `uxraylib.QuaternionEquals` | `(px AS F64, py AS F64, pz AS F64, pw AS F64, qx AS F64, qy AS F64, qz AS F64, qw AS F64)` | I32 |  |
| `uxraylib.ResGet` | `(reg AS I32, component AS I32)` | F64 | ✓ |
| `uxraylib.ResX` | `()` | F64 | ✓ |
| `uxraylib.ResY` | `()` | F64 | ✓ |
| `uxraylib.ResZ` | `()` | F64 | ✓ |
| `uxraylib.ResW` | `()` | F64 | ✓ |
| `uxraylib.VectorSlotSet` | `(slotIndex AS I32, x AS F64, y AS F64, z AS F64, w AS F64)` |  | ✓ |
| `uxraylib.MathLastError` | `()` | I32 | ✓ |
| `uxraylib.MathClearError` | `()` |  | ✓ |
| `uxraylib.MatrixRelease` | `(handle AS I32)` |  | ✓ |
| `uxraylib.MatrixLiveCount` | `()` | I32 | ✓ |
| `uxraylib.MatrixCopy` | `(handle AS I32)` | I32 | ✓ |
| `uxraylib.MatrixElement` | `(handle AS I32, index AS I32)` | F64 | ✓ |
| `uxraylib.MatrixSetElement` | `(handle AS I32, index AS I32, value AS F64)` | I32 | ✓ |
| `uxraylib.MatrixAt` | `(handle AS I32, row AS I32, col AS I32)` | F64 | ✓ |
| `uxraylib.Vector3OrthoNormalize` | `(v1x AS F64, v1y AS F64, v1z AS F64, v2x AS F64, v2y AS F64, v2z AS F64)` |  | ✓ |
| `uxraylib.QuaternionToAxisAngle` | `(qx AS F64, qy AS F64, qz AS F64, qw AS F64)` | F64 | ✓ |
| `uxraylib.MatrixDecompose` | `(handle AS I32)` |  | ✓ |
| `uxraylib.Vector3CubicHermiteSlots` | `(v1Slot AS I32, tangent1Slot AS I32, v2Slot AS I32, tangent2Slot AS I32, amount AS F64)` |  | ✓ |
| `uxraylib.Vector3BarycenterSlots` | `(pSlot AS I32, aSlot AS I32, bSlot AS I32, cSlot AS I32)` |  | ✓ |
| `uxraylib.QuaternionCubicHermiteSplineSlots` | `(q1Slot AS I32, outTangent1Slot AS I32, q2Slot AS I32, inTangent2Slot AS I32, t AS F64)` |  |  |

## uxraylib_s100  (uxraylib; 100 fonksiyon/sub, 10 sabit, testte çağrılan 31)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxraylib.AdapterVersion` | `()` | I32 | ✓ |
| `uxraylib.RaylibVersion` | `()` | STRING | ✓ |
| `uxraylib.RayguiVersion` | `()` | STRING | ✓ |
| `uxraylib.RectangleArea` | `(width AS F64, height AS F64)` | F64 | ✓ |
| `uxraylib.ColorRGBA` | `(r AS I32, g AS I32, b AS I32, a AS I32)` | U32 | ✓ |
| `uxraylib.InitWindow` | `(width AS I32, height AS I32, title AS STRING)` |  | ✓ |
| `uxraylib.WindowShouldClose` | `()` | I32 | ✓ |
| `uxraylib.WindowReady` | `()` | I32 |  |
| `uxraylib.SetTargetFPS` | `(fps AS I32)` |  | ✓ |
| `uxraylib.FrameTime` | `()` | F64 | ✓ |
| `uxraylib.KeyDown` | `(key AS I32)` | I32 | ✓ |
| `uxraylib.KeyPressed` | `(key AS I32)` | I32 |  |
| `uxraylib.BeginDrawing` | `()` |  | ✓ |
| `uxraylib.EndDrawing` | `()` |  | ✓ |
| `uxraylib.ClearBackground` | `(r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.DrawText` | `(text AS STRING, x AS I32, y AS I32, fontSize AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.DrawCircle` | `(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.DrawRectangle` | `(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.CircleCollision` | `(ax AS F64, ay AS F64, ar AS F64, bx AS F64, by AS F64, br AS F64)` | I32 | ✓ |
| `uxraylib.LoadTexture` | `(path AS STRING)` | I32 | ✓ |
| `uxraylib.TextureWidth` | `(handle AS I32)` | I32 |  |
| `uxraylib.TextureHeight` | `(handle AS I32)` | I32 |  |
| `uxraylib.UnloadTexture` | `(handle AS I32)` |  | ✓ |
| `uxraylib.LoadFont` | `(path AS STRING)` | I32 | ✓ |
| `uxraylib.DrawFont` | `(handle AS I32, text AS STRING, x AS F64, y AS F64, size AS F64, spacing AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.UnloadFont` | `(handle AS I32)` |  | ✓ |
| `uxraylib.SetCameraScroll` | `(x AS F64, y AS F64)` |  | ✓ |
| `uxraylib.DrawSprite` | `(handle AS I32, sourceX AS F64, sourceY AS F64, sourceWidth AS F64, sourceHeight AS F64, worldX AS F64, worldY AS F64, scale AS F64, rotation AS F64)` |  | ✓ |
| `uxraylib.RectCollision` | `(ax AS F64, ay AS F64, aw AS F64, ah AS F64, bx AS F64, by AS F64, bw AS F64, bh AS F64)` | I32 | ✓ |
| `uxraylib.SpriteFrame` | `(frame AS I32, frameCount AS I32)` | I32 | ✓ |
| `uxraylib.GuiButton` | `(x AS F64, y AS F64, width AS F64, height AS F64, text AS STRING)` | I32 | ✓ |
| `uxraylib.InitAudio` | `()` |  | ✓ |
| `uxraylib.AudioReady` | `()` | I32 | ✓ |
| `uxraylib.CloseAudio` | `()` |  | ✓ |
| `uxraylib.CloseWindow` | `()` |  | ✓ |
| `uxraylib.IsWindowFullscreen` | `()` | I32 |  |
| `uxraylib.IsWindowFocused` | `()` | I32 |  |
| `uxraylib.IsWindowResized` | `()` | I32 |  |
| `uxraylib.IsWindowMinimized` | `()` | I32 |  |
| `uxraylib.IsWindowMaximized` | `()` | I32 |  |
| `uxraylib.ToggleFullscreen` | `()` |  |  |
| `uxraylib.SetWindowTitle` | `(title AS STRING)` |  |  |
| `uxraylib.SetWindowSize` | `(width AS I32, height AS I32)` |  |  |
| `uxraylib.SetWindowPosition` | `(x AS I32, y AS I32)` |  |  |
| `uxraylib.SetWindowMinSize` | `(width AS I32, height AS I32)` |  |  |
| `uxraylib.GetScreenWidth` | `()` | I32 |  |
| `uxraylib.GetScreenHeight` | `()` | I32 |  |
| `uxraylib.GetFPS` | `()` | I32 |  |
| `uxraylib.GetTime` | `()` | F64 |  |
| `uxraylib.SetConfigFlags` | `(flags AS U32)` |  |  |
| `uxraylib.TakeScreenshot` | `(fileName AS STRING)` |  |  |
| `uxraylib.WaitTime` | `(seconds AS F64)` |  |  |
| `uxraylib.ShowCursor` | `()` |  |  |
| `uxraylib.HideCursor` | `()` |  |  |
| `uxraylib.IsCursorHidden` | `()` | I32 |  |
| `uxraylib.EnableCursor` | `()` |  |  |
| `uxraylib.DisableCursor` | `()` |  |  |
| `uxraylib.SetRandomSeed` | `(seed AS U32)` |  |  |
| `uxraylib.GetRandomValue` | `(minVal AS I32, maxVal AS I32)` | I32 |  |
| `uxraylib.KeyReleased` | `(key AS I32)` | I32 |  |
| `uxraylib.KeyUp` | `(key AS I32)` | I32 |  |
| `uxraylib.GetKeyPressed` | `()` | I32 |  |
| `uxraylib.GetCharPressed` | `()` | I32 |  |
| `uxraylib.SetExitKey` | `(key AS I32)` |  |  |
| `uxraylib.MouseButtonPressed` | `(button AS I32)` | I32 |  |
| `uxraylib.MouseButtonDown` | `(button AS I32)` | I32 |  |
| `uxraylib.MouseButtonReleased` | `(button AS I32)` | I32 |  |
| `uxraylib.MouseButtonUp` | `(button AS I32)` | I32 |  |
| `uxraylib.GetMouseX` | `()` | I32 |  |
| `uxraylib.GetMouseY` | `()` | I32 |  |
| `uxraylib.SetMousePosition` | `(x AS I32, y AS I32)` |  |  |
| `uxraylib.GetMouseWheelMove` | `()` | F64 |  |
| `uxraylib.DrawPixel` | `(x AS I32, y AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawLine` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, thick AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawCircleLines` | `(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawCircleGradient` | `(x AS F64, y AS F64, radius AS F64, color1 AS U32, color2 AS U32)` |  |  |
| `uxraylib.DrawEllipse` | `(x AS F64, y AS F64, radiusH AS F64, radiusV AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawEllipseLines` | `(x AS F64, y AS F64, radiusH AS F64, radiusV AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawRectangleLines` | `(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawRectangleRounded` | `(x AS F64, y AS F64, width AS F64, height AS F64, roundness AS F64, segments AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawRectangleGradientV` | `(x AS F64, y AS F64, width AS F64, height AS F64, color1 AS U32, color2 AS U32)` |  |  |
| `uxraylib.DrawRectangleGradientH` | `(x AS F64, y AS F64, width AS F64, height AS F64, color1 AS U32, color2 AS U32)` |  |  |
| `uxraylib.DrawTriangle` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawTriangleLines` | `(x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawPoly` | `(x AS F64, y AS F64, sides AS I32, radius AS F64, rotation AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawPolyLines` | `(x AS F64, y AS F64, sides AS I32, radius AS F64, rotation AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.CollisionCircleRec` | `(cx AS F64, cy AS F64, radius AS F64, rx AS F64, ry AS F64, rw AS F64, rh AS F64)` | I32 |  |
| `uxraylib.CollisionPointRec` | `(px AS F64, py AS F64, rx AS F64, ry AS F64, rw AS F64, rh AS F64)` | I32 |  |
| `uxraylib.CollisionPointCircle` | `(px AS F64, py AS F64, cx AS F64, cy AS F64, radius AS F64)` | I32 |  |
| `uxraylib.CollisionPointTriangle` | `(px AS F64, py AS F64, x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64, x3 AS F64, y3 AS F64)` | I32 |  |
| `uxraylib.MeasureText` | `(text AS STRING, fontSize AS I32)` | I32 |  |
| `uxraylib.DrawFPS` | `(x AS I32, y AS I32)` |  |  |
| `uxraylib.TextureValid` | `(handle AS I32)` | I32 |  |
| `uxraylib.DrawTexture` | `(handle AS I32, x AS F64, y AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.DrawTextureEx` | `(handle AS I32, x AS F64, y AS F64, rotation AS F64, scale AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  |  |
| `uxraylib.LoadSound` | `(path AS STRING)` | I32 |  |
| `uxraylib.PlaySound` | `(handle AS I32)` |  |  |
| `uxraylib.StopSound` | `(handle AS I32)` |  |  |
| `uxraylib.PauseSound` | `(handle AS I32)` |  |  |
| `uxraylib.ResumeSound` | `(handle AS I32)` |  |  |

## uxraylib_s60  (uxraylib; 60 fonksiyon/sub, 10 sabit, testte çağrılan 31)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxraylib.AdapterVersion` | `()` | I32 | ✓ |
| `uxraylib.RaylibVersion` | `()` | STRING | ✓ |
| `uxraylib.RayguiVersion` | `()` | STRING | ✓ |
| `uxraylib.RectangleArea` | `(width AS F64, height AS F64)` | F64 | ✓ |
| `uxraylib.ColorRGBA` | `(r AS I32, g AS I32, b AS I32, a AS I32)` | U32 | ✓ |
| `uxraylib.InitWindow` | `(width AS I32, height AS I32, title AS STRING)` |  | ✓ |
| `uxraylib.WindowShouldClose` | `()` | I32 | ✓ |
| `uxraylib.WindowReady` | `()` | I32 |  |
| `uxraylib.SetTargetFPS` | `(fps AS I32)` |  | ✓ |
| `uxraylib.FrameTime` | `()` | F64 | ✓ |
| `uxraylib.KeyDown` | `(key AS I32)` | I32 | ✓ |
| `uxraylib.KeyPressed` | `(key AS I32)` | I32 |  |
| `uxraylib.BeginDrawing` | `()` |  | ✓ |
| `uxraylib.EndDrawing` | `()` |  | ✓ |
| `uxraylib.ClearBackground` | `(r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.DrawText` | `(text AS STRING, x AS I32, y AS I32, fontSize AS I32, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.DrawCircle` | `(x AS F64, y AS F64, radius AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.DrawRectangle` | `(x AS F64, y AS F64, width AS F64, height AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.CircleCollision` | `(ax AS F64, ay AS F64, ar AS F64, bx AS F64, by AS F64, br AS F64)` | I32 | ✓ |
| `uxraylib.LoadTexture` | `(path AS STRING)` | I32 | ✓ |
| `uxraylib.TextureWidth` | `(handle AS I32)` | I32 |  |
| `uxraylib.TextureHeight` | `(handle AS I32)` | I32 |  |
| `uxraylib.UnloadTexture` | `(handle AS I32)` |  | ✓ |
| `uxraylib.LoadFont` | `(path AS STRING)` | I32 | ✓ |
| `uxraylib.DrawFont` | `(handle AS I32, text AS STRING, x AS F64, y AS F64, size AS F64, spacing AS F64, r AS I32, g AS I32, b AS I32, a AS I32)` |  | ✓ |
| `uxraylib.UnloadFont` | `(handle AS I32)` |  | ✓ |
| `uxraylib.SetCameraScroll` | `(x AS F64, y AS F64)` |  | ✓ |
| `uxraylib.DrawSprite` | `(handle AS I32, sourceX AS F64, sourceY AS F64, sourceWidth AS F64, sourceHeight AS F64, worldX AS F64, worldY AS F64, scale AS F64, rotation AS F64)` |  | ✓ |
| `uxraylib.RectCollision` | `(ax AS F64, ay AS F64, aw AS F64, ah AS F64, bx AS F64, by AS F64, bw AS F64, bh AS F64)` | I32 | ✓ |
| `uxraylib.SpriteFrame` | `(frame AS I32, frameCount AS I32)` | I32 | ✓ |
| `uxraylib.GuiButton` | `(x AS F64, y AS F64, width AS F64, height AS F64, text AS STRING)` | I32 | ✓ |
| `uxraylib.InitAudio` | `()` |  | ✓ |
| `uxraylib.AudioReady` | `()` | I32 | ✓ |
| `uxraylib.CloseAudio` | `()` |  | ✓ |
| `uxraylib.CloseWindow` | `()` |  | ✓ |
| `uxraylib.IsWindowFullscreen` | `()` | I32 |  |
| `uxraylib.IsWindowFocused` | `()` | I32 |  |
| `uxraylib.IsWindowResized` | `()` | I32 |  |
| `uxraylib.IsWindowMinimized` | `()` | I32 |  |
| `uxraylib.IsWindowMaximized` | `()` | I32 |  |
| `uxraylib.ToggleFullscreen` | `()` |  |  |
| `uxraylib.SetWindowTitle` | `(title AS STRING)` |  |  |
| `uxraylib.SetWindowSize` | `(width AS I32, height AS I32)` |  |  |
| `uxraylib.SetWindowPosition` | `(x AS I32, y AS I32)` |  |  |
| `uxraylib.SetWindowMinSize` | `(width AS I32, height AS I32)` |  |  |
| `uxraylib.GetScreenWidth` | `()` | I32 |  |
| `uxraylib.GetScreenHeight` | `()` | I32 |  |
| `uxraylib.GetFPS` | `()` | I32 |  |
| `uxraylib.GetTime` | `()` | F64 |  |
| `uxraylib.SetConfigFlags` | `(flags AS U32)` |  |  |
| `uxraylib.TakeScreenshot` | `(fileName AS STRING)` |  |  |
| `uxraylib.WaitTime` | `(seconds AS F64)` |  |  |
| `uxraylib.ShowCursor` | `()` |  |  |
| `uxraylib.HideCursor` | `()` |  |  |
| `uxraylib.IsCursorHidden` | `()` | I32 |  |
| `uxraylib.EnableCursor` | `()` |  |  |
| `uxraylib.DisableCursor` | `()` |  |  |
| `uxraylib.SetRandomSeed` | `(seed AS U32)` |  |  |
| `uxraylib.GetRandomValue` | `(minVal AS I32, maxVal AS I32)` | I32 |  |
| `uxraylib.KeyReleased` | `(key AS I32)` | I32 |  |

## uxregex  (uxregex; 20 fonksiyon/sub, 0 sabit, testte çağrılan 18)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxregex.Version` | `()` | STRING |  |
| `uxregex.Compile` | `(pattern AS STRING, options AS U32)` | U64 | ✓ |
| `uxregex.Free` | `(regex AS U64)` |  | ✓ |
| `uxregex.Match` | `(regex AS U64, subject AS STRING, startOffset AS U64, options AS U32)` | I32 | ✓ |
| `uxregex.IsMatch` | `(regex AS U64, subject AS STRING)` | I32 | ✓ |
| `uxregex.GroupCount` | `(regex AS U64)` | I32 | ✓ |
| `uxregex.GroupStart` | `(regex AS U64, group AS I32)` | I64 | ✓ |
| `uxregex.GroupEnd` | `(regex AS U64, group AS I32)` | I64 | ✓ |
| `uxregex.GroupText` | `(regex AS U64, subject AS STRING, group AS I32)` | STRING | ✓ |
| `uxregex.ErrorText` | `(regex AS U64)` | STRING | ✓ |
| `uxregex.Version` | `()` | STRING |  |
| `uxregex.Compile` | `(pattern AS STRING, options AS U32)` | U64 | ✓ |
| `uxregex.Free` | `(regex AS U64)` |  | ✓ |
| `uxregex.Match` | `(regex AS U64, subject AS STRING, startOffset AS U64, options AS U32)` | I32 | ✓ |
| `uxregex.IsMatch` | `(regex AS U64, subject AS STRING)` | I32 | ✓ |
| `uxregex.GroupCount` | `(regex AS U64)` | I32 | ✓ |
| `uxregex.GroupStart` | `(regex AS U64, group AS I32)` | I64 | ✓ |
| `uxregex.GroupEnd` | `(regex AS U64, group AS I32)` | I64 | ✓ |
| `uxregex.GroupText` | `(regex AS U64, subject AS STRING, group AS I32)` | STRING | ✓ |
| `uxregex.ErrorText` | `(regex AS U64)` | STRING | ✓ |

## uxscalar_module  (uxscalar_module; 3 fonksiyon/sub, 1 sabit, testte çağrılan 3)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxscalar_module.uxscalar_init` | `()` | I32 | ✓ |
| `uxscalar_module.uxscalar_add` | `(leftValue AS I32, rightValue AS I32)` | I32 | ✓ |
| `uxscalar_module.uxscalar_shutdown` | `()` | I32 | ✓ |

## uxsdl3  (uxsdl3; 334 fonksiyon/sub, 387 sabit, testte çağrılan 323)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxsdl3.AdapterVersion` | `()` | I32 | ✓ |
| `uxsdl3.RuntimeVersion` | `()` | I32 | ✓ |
| `uxsdl3.Revision` | `()` | STRING | ✓ |
| `uxsdl3.Init` | `(flags AS U32)` | I32 | ✓ |
| `uxsdl3.Quit` | `()` |  | ✓ |
| `uxsdl3.LastError` | `()` | STRING | ✓ |
| `uxsdl3.CreateWindow` | `(title AS STRING, w AS I32, h AS I32, flags AS U64)` | I64 | ✓ |
| `uxsdl3.DestroyWindow` | `(handle AS I64)` |  | ✓ |
| `uxsdl3.SetWindowTitle` | `(handle AS I64, title AS STRING)` | I32 | ✓ |
| `uxsdl3.SetWindowSize` | `(handle AS I64, w AS I32, h AS I32)` | I32 | ✓ |
| `uxsdl3.GetWindowWidth` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.GetWindowHeight` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.ShowWindow` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.HideWindow` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.CreateRenderer` | `(windowHandle AS I64, name AS STRING)` | I64 | ✓ |
| `uxsdl3.DestroyRenderer` | `(handle AS I64)` |  | ✓ |
| `uxsdl3.SetRenderDrawColor` | `(handle AS I64, r AS I32, g AS I32, b AS I32, a AS I32)` | I32 | ✓ |
| `uxsdl3.RenderClear` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.RenderPresent` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.RenderFillRect` | `(handle AS I64, x AS F64, y AS F64, w AS F64, h AS F64)` | I32 | ✓ |
| `uxsdl3.RenderRect` | `(handle AS I64, x AS F64, y AS F64, w AS F64, h AS F64)` | I32 | ✓ |
| `uxsdl3.RenderLine` | `(handle AS I64, x1 AS F64, y1 AS F64, x2 AS F64, y2 AS F64)` | I32 | ✓ |
| `uxsdl3.RenderPoint` | `(handle AS I64, x AS F64, y AS F64)` | I32 | ✓ |
| `uxsdl3.PumpEvents` | `()` |  | ✓ |
| `uxsdl3.ShouldQuit` | `()` | I32 | ✓ |
| `uxsdl3.KeyDown` | `(scancode AS I32)` | I32 | ✓ |
| `uxsdl3.GetMouseX` | `()` | I32 | ✓ |
| `uxsdl3.GetMouseY` | `()` | I32 | ✓ |
| `uxsdl3.MouseButtonDown` | `(button AS I32)` | I32 | ✓ |
| `uxsdl3.GetTicks` | `()` | I64 | ✓ |
| `uxsdl3.Delay` | `(ms AS I32)` |  | ✓ |
| `uxsdl3.LoadTexture` | `(rendererHandle AS I64, bmpPath AS STRING)` | I64 | ✓ |
| `uxsdl3.DestroyTexture` | `(handle AS I64)` |  | ✓ |
| `uxsdl3.GetTextureWidth` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.GetTextureHeight` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.RenderTexture` | `(rendererHandle AS I64, textureHandle AS I64, x AS F64, y AS F64, w AS F64, h AS F64)` | I32 | ✓ |
| `uxsdl3.WindowResized` | `()` | I32 | ✓ |
| `uxsdl3.GetMouseWheelY` | `()` | F64 | ✓ |
| `uxsdl3.LoadSound` | `(wavPath AS STRING)` | I32 | ✓ |
| `uxsdl3.PlaySound` | `(handle AS I32)` |  | ✓ |
| `uxsdl3.StopSound` | `(handle AS I32)` |  | ✓ |
| `uxsdl3.UnloadSound` | `(handle AS I32)` |  | ✓ |
| `uxsdl3.SetClipboardText` | `(txt AS STRING)` | I32 | ✓ |
| `uxsdl3.GetClipboardText` | `()` | STRING | ✓ |
| `uxsdl3.HasClipboardText` | `()` | I32 | ✓ |
| `uxsdl3.StartTextInput` | `(winHandle AS I64)` | I32 | ✓ |
| `uxsdl3.StopTextInput` | `(winHandle AS I64)` | I32 | ✓ |
| `uxsdl3.TextInputActive` | `(winHandle AS I64)` | I32 | ✓ |
| `uxsdl3.SetTextInputArea` | `(winHandle AS I64, x AS I32, y AS I32, w AS I32, h AS I32, cursor AS I32)` | I32 | ✓ |
| `uxsdl3.TakeTextInput` | `()` | STRING | ✓ |
| `uxsdl3.PushTextInput` | `(txt AS STRING)` | I32 | ✓ |
| `uxsdl3.GetScancodeName` | `(scancode AS I32)` | STRING | ✓ |
| `uxsdl3.GetModState` | `()` | I32 | ✓ |
| `uxsdl3.JoystickCount` | `()` | I32 | ✓ |
| `uxsdl3.JoystickIdAt` | `(idx AS I32)` | I32 | ✓ |
| `uxsdl3.OpenJoystick` | `(instanceId AS I32)` | I32 | ✓ |
| `uxsdl3.CloseJoystick` | `(handle AS I32)` |  | ✓ |
| `uxsdl3.JoystickConnected` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickName` | `(handle AS I32)` | STRING | ✓ |
| `uxsdl3.JoystickNumAxes` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickNumButtons` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickNumHats` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickAxis` | `(handle AS I32, axis AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickButton` | `(handle AS I32, button AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickHat` | `(handle AS I32, hat AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadCount` | `()` | I32 | ✓ |
| `uxsdl3.GamepadIdAt` | `(idx AS I32)` | I32 | ✓ |
| `uxsdl3.IsGamepad` | `(instanceId AS I32)` | I32 | ✓ |
| `uxsdl3.OpenGamepad` | `(instanceId AS I32)` | I32 | ✓ |
| `uxsdl3.CloseGamepad` | `(handle AS I32)` |  | ✓ |
| `uxsdl3.GamepadConnected` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadInstanceId` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadName` | `(handle AS I32)` | STRING | ✓ |
| `uxsdl3.GamepadVendor` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadProduct` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadButton` | `(handle AS I32, button AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadAxis` | `(handle AS I32, axis AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadAxisNorm` | `(handle AS I32, axis AS I32)` | F64 | ✓ |
| `uxsdl3.GamepadRumble` | `(handle AS I32, low AS I32, high AS I32, ms AS I32)` | I32 | ✓ |
| `uxsdl3.AttachVirtualJoystick` | `(axes AS I32, buttons AS I32, hats AS I32)` | I32 | ✓ |
| `uxsdl3.AttachVirtualGamepad` | `()` | I32 | ✓ |
| `uxsdl3.DetachVirtual` | `(instanceId AS I32)` | I32 | ✓ |
| `uxsdl3.SetVirtualJoystickAxis` | `(handle AS I32, axis AS I32, value AS I32)` | I32 | ✓ |
| `uxsdl3.SetVirtualJoystickButton` | `(handle AS I32, button AS I32, down AS I32)` | I32 | ✓ |
| `uxsdl3.SetVirtualJoystickHat` | `(handle AS I32, hat AS I32, value AS I32)` | I32 | ✓ |
| `uxsdl3.SetVirtualGamepadAxis` | `(handle AS I32, axis AS I32, value AS I32)` | I32 | ✓ |
| `uxsdl3.SetVirtualGamepadButton` | `(handle AS I32, button AS I32, down AS I32)` | I32 | ✓ |
| `uxsdl3.ClearQuit` | `()` |  | ✓ |
| `uxsdl3.WindowEvents` | `()` | I32 | ✓ |
| `uxsdl3.GetMouseWheelX` | `()` | F64 | ✓ |
| `uxsdl3.KeyPressed` | `(scancode AS I32)` | I32 | ✓ |
| `uxsdl3.KeyReleased` | `(scancode AS I32)` | I32 | ✓ |
| `uxsdl3.LastKey` | `()` | I32 | ✓ |
| `uxsdl3.MouseButtonPressed` | `(button AS I32)` | I32 | ✓ |
| `uxsdl3.MouseButtonReleased` | `(button AS I32)` | I32 | ✓ |
| `uxsdl3.MouseRelX` | `()` | F64 | ✓ |
| `uxsdl3.MouseRelY` | `()` | F64 | ✓ |
| `uxsdl3.TakeDeviceEvents` | `(which AS I32)` | I32 | ✓ |
| `uxsdl3.DropCount` | `()` | I32 | ✓ |
| `uxsdl3.TakeDrop` | `()` | STRING | ✓ |
| `uxsdl3.PushDrop` | `(text AS STRING)` | I32 | ✓ |
| `uxsdl3.PushQuit` | `()` | I32 | ✓ |
| `uxsdl3.PushKey` | `(scancode AS I32, down AS I32)` | I32 | ✓ |
| `uxsdl3.PushMouseButton` | `(button AS I32, down AS I32, x AS F64, y AS F64)` | I32 | ✓ |
| `uxsdl3.PushMouseMotion` | `(x AS F64, y AS F64, xrel AS F64, yrel AS F64)` | I32 | ✓ |
| `uxsdl3.PushMouseWheel` | `(x AS F64, y AS F64)` | I32 | ✓ |
| `uxsdl3.FlushEvents` | `()` |  | ✓ |
| `uxsdl3.CreateTone` | `(freqHz AS I32, ms AS I32, volume AS F64)` | I32 | ✓ |
| `uxsdl3.PauseSound` | `(handle AS I32)` |  | ✓ |
| `uxsdl3.ResumeSound` | `(handle AS I32)` |  | ✓ |
| `uxsdl3.SaveSoundWAV` | `(handle AS I32, path AS STRING)` | I32 | ✓ |
| `uxsdl3.IsSoundPlaying` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.IsSoundPaused` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.SetSoundLoop` | `(handle AS I32, looping AS I32)` |  | ✓ |
| `uxsdl3.GetSoundLoop` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.SetSoundVolume` | `(handle AS I32, volume AS F64)` |  | ✓ |
| `uxsdl3.GetSoundVolume` | `(handle AS I32)` | F64 | ✓ |
| `uxsdl3.SetMasterVolume` | `(volume AS F64)` |  | ✓ |
| `uxsdl3.GetMasterVolume` | `()` | F64 | ✓ |
| `uxsdl3.SoundLengthMs` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.SoundRemainingMs` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.SoundFrequency` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.SoundChannels` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.AudioDeviceCount` | `(recording AS I32)` | I32 | ✓ |
| `uxsdl3.AudioDeviceName` | `(recording AS I32, index AS I32)` | STRING | ✓ |
| `uxsdl3.AudioDriverCount` | `()` | I32 | ✓ |
| `uxsdl3.AudioDriverName` | `(index AS I32)` | STRING | ✓ |
| `uxsdl3.CurrentAudioDriver` | `()` | STRING | ✓ |
| `uxsdl3.InitSubSystem` | `(flags AS U32)` | I32 | ✓ |
| `uxsdl3.QuitSubSystem` | `(flags AS U32)` |  | ✓ |
| `uxsdl3.WasInit` | `(flags AS U32)` | I32 | ✓ |
| `uxsdl3.ClearError` | `()` |  | ✓ |
| `uxsdl3.GetPlatform` | `()` | STRING | ✓ |
| `uxsdl3.SetAppMetadata` | `(name AS STRING, version AS STRING, identifier AS STRING)` | I32 | ✓ |
| `uxsdl3.GetAppMetadata` | `(which AS I32)` | STRING | ✓ |
| `uxsdl3.SetHint` | `(name AS STRING, value AS STRING)` | I32 | ✓ |
| `uxsdl3.GetHint` | `(name AS STRING)` | STRING | ✓ |
| `uxsdl3.DisplayCount` | `()` | I32 | ✓ |
| `uxsdl3.DisplayIdAt` | `(index AS I32)` | I32 | ✓ |
| `uxsdl3.PrimaryDisplay` | `()` | I32 | ✓ |
| `uxsdl3.DisplayName` | `(displayId AS I32)` | STRING | ✓ |
| `uxsdl3.DisplayBounds` | `(displayId AS I32, which AS I32)` | I32 | ✓ |
| `uxsdl3.DisplayUsableBounds` | `(displayId AS I32, which AS I32)` | I32 | ✓ |
| `uxsdl3.DisplayMode` | `(displayId AS I32, which AS I32)` | I32 | ✓ |
| `uxsdl3.DisplayContentScale` | `(displayId AS I32)` | F64 | ✓ |
| `uxsdl3.DisplayOrientation` | `(displayId AS I32)` | I32 | ✓ |
| `uxsdl3.VideoDriverCount` | `()` | I32 | ✓ |
| `uxsdl3.VideoDriverName` | `(index AS I32)` | STRING | ✓ |
| `uxsdl3.CurrentVideoDriver` | `()` | STRING | ✓ |
| `uxsdl3.ScreensaverEnabled` | `()` | I32 | ✓ |
| `uxsdl3.SetScreensaver` | `(enabled AS I32)` | I32 | ✓ |
| `uxsdl3.SystemTheme` | `()` | I32 | ✓ |
| `uxsdl3.GetWindowTitle` | `(handle AS I64)` | STRING | ✓ |
| `uxsdl3.GetWindowPixelSize` | `(handle AS I64, which AS I32)` | I32 |  |
| `uxsdl3.SetWindowPosition` | `(handle AS I64, x AS I32, y AS I32)` | I32 | ✓ |
| `uxsdl3.GetWindowPosition` | `(handle AS I64, which AS I32)` | I32 | ✓ |
| `uxsdl3.SetWindowMinSize` | `(handle AS I64, w AS I32, h AS I32)` | I32 | ✓ |
| `uxsdl3.SetWindowMaxSize` | `(handle AS I64, w AS I32, h AS I32)` | I32 | ✓ |
| `uxsdl3.GetWindowMinSize` | `(handle AS I64, which AS I32)` | I32 | ✓ |
| `uxsdl3.GetWindowMaxSize` | `(handle AS I64, which AS I32)` | I32 | ✓ |
| `uxsdl3.SetWindowFullscreen` | `(handle AS I64, fullscreen AS I32)` | I32 | ✓ |
| `uxsdl3.GetWindowFlags` | `(handle AS I64)` | I64 | ✓ |
| `uxsdl3.SetWindowBordered` | `(handle AS I64, bordered AS I32)` | I32 | ✓ |
| `uxsdl3.SetWindowResizable` | `(handle AS I64, resizable AS I32)` | I32 | ✓ |
| `uxsdl3.SetWindowAlwaysOnTop` | `(handle AS I64, onTop AS I32)` | I32 | ✓ |
| `uxsdl3.SetWindowFocusable` | `(handle AS I64, focusable AS I32)` | I32 | ✓ |
| `uxsdl3.MinimizeWindow` | `(handle AS I64)` | I32 |  |
| `uxsdl3.MaximizeWindow` | `(handle AS I64)` | I32 |  |
| `uxsdl3.RestoreWindow` | `(handle AS I64)` | I32 |  |
| `uxsdl3.RaiseWindow` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.SyncWindow` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.SetWindowOpacity` | `(handle AS I64, opacity AS F64)` | I32 |  |
| `uxsdl3.GetWindowOpacity` | `(handle AS I64)` | F64 | ✓ |
| `uxsdl3.WindowId` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.WindowFromId` | `(id AS I32)` | I64 | ✓ |
| `uxsdl3.WindowDisplay` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.WindowDisplayScale` | `(handle AS I64)` | F64 | ✓ |
| `uxsdl3.WindowPixelDensity` | `(handle AS I64)` | F64 | ✓ |
| `uxsdl3.SetWindowMouseGrab` | `(handle AS I64, grabbed AS I32)` | I32 | ✓ |
| `uxsdl3.GetWindowMouseGrab` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.SetWindowKeyboardGrab` | `(handle AS I64, grabbed AS I32)` | I32 | ✓ |
| `uxsdl3.GetWindowKeyboardGrab` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.SetWindowRelativeMouse` | `(handle AS I64, enabled AS I32)` | I32 | ✓ |
| `uxsdl3.GetWindowRelativeMouse` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.SetWindowIconBMP` | `(handle AS I64, bmpPath AS STRING)` | I32 | ✓ |
| `uxsdl3.FlashWindow` | `(handle AS I64, operation AS I32)` | I32 | ✓ |
| `uxsdl3.ShowCursor` | `()` | I32 | ✓ |
| `uxsdl3.HideCursor` | `()` | I32 | ✓ |
| `uxsdl3.CursorVisible` | `()` | I32 | ✓ |
| `uxsdl3.SetSystemCursor` | `(id AS I32)` | I32 | ✓ |
| `uxsdl3.WarpMouseInWindow` | `(handle AS I64, x AS F64, y AS F64)` | I32 | ✓ |
| `uxsdl3.WarpMouseGlobal` | `(x AS F64, y AS F64)` | I32 |  |
| `uxsdl3.CaptureMouse` | `(enabled AS I32)` | I32 |  |
| `uxsdl3.GlobalMouse` | `(which AS I32)` | I32 | ✓ |
| `uxsdl3.HasMouse` | `()` | I32 |  |
| `uxsdl3.HasKeyboard` | `()` | I32 |  |
| `uxsdl3.MouseCount` | `()` | I32 | ✓ |
| `uxsdl3.KeyboardCount` | `()` | I32 | ✓ |
| `uxsdl3.ScancodeFromName` | `(name AS STRING)` | I32 | ✓ |
| `uxsdl3.KeyFromScancode` | `(scancode AS I32)` | I32 | ✓ |
| `uxsdl3.ScancodeFromKey` | `(keycode AS I32)` | I32 | ✓ |
| `uxsdl3.KeyName` | `(keycode AS I32)` | STRING | ✓ |
| `uxsdl3.HasScreenKeyboard` | `()` | I32 | ✓ |
| `uxsdl3.SetModState` | `(mods AS I32)` |  | ✓ |
| `uxsdl3.RendererName` | `(handle AS I64)` | STRING | ✓ |
| `uxsdl3.RenderOutputSize` | `(handle AS I64, which AS I32)` | I32 |  |
| `uxsdl3.GetRenderDrawColor` | `(handle AS I64, which AS I32)` | I32 | ✓ |
| `uxsdl3.SetRenderDrawBlendMode` | `(handle AS I64, mode AS I32)` | I32 | ✓ |
| `uxsdl3.GetRenderDrawBlendMode` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.SetRenderViewport` | `(handle AS I64, x AS I32, y AS I32, w AS I32, h AS I32)` | I32 | ✓ |
| `uxsdl3.ResetRenderViewport` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.GetRenderViewport` | `(handle AS I64, which AS I32)` | I32 | ✓ |
| `uxsdl3.SetRenderClipRect` | `(handle AS I64, x AS I32, y AS I32, w AS I32, h AS I32)` | I32 | ✓ |
| `uxsdl3.DisableRenderClip` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.RenderClipEnabled` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.GetRenderClipRect` | `(handle AS I64, which AS I32)` | I32 | ✓ |
| `uxsdl3.SetRenderScale` | `(handle AS I64, sx AS F64, sy AS F64)` | I32 | ✓ |
| `uxsdl3.GetRenderScale` | `(handle AS I64, which AS I32)` | F64 | ✓ |
| `uxsdl3.SetRenderLogicalPresentation` | `(handle AS I64, w AS I32, h AS I32, mode AS I32)` | I32 | ✓ |
| `uxsdl3.GetRenderLogicalSize` | `(handle AS I64, which AS I32)` | I32 | ✓ |
| `uxsdl3.GetRenderLogicalMode` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.SetRenderVSync` | `(handle AS I64, vsync AS I32)` | I32 | ✓ |
| `uxsdl3.GetRenderVSync` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.RenderCoordsFromWindow` | `(handle AS I64, wx AS F64, wy AS F64, which AS I32)` | F64 | ✓ |
| `uxsdl3.RenderCoordsToWindow` | `(handle AS I64, x AS F64, y AS F64, which AS I32)` | F64 | ✓ |
| `uxsdl3.RenderReadPixel` | `(handle AS I64, x AS I32, y AS I32)` | U32 | ✓ |
| `uxsdl3.RenderSaveBMP` | `(handle AS I64, path AS STRING)` | I32 | ✓ |
| `uxsdl3.RenderDebugText` | `(handle AS I64, x AS F64, y AS F64, text AS STRING)` | I32 | ✓ |
| `uxsdl3.SetRenderTarget` | `(handle AS I64, texture AS I64)` | I32 | ✓ |
| `uxsdl3.CreateTexture` | `(rendererHandle AS I64, w AS I32, h AS I32, access AS I32)` | I64 | ✓ |
| `uxsdl3.TextureFill` | `(handle AS I64, rgba AS U32)` | I32 | ✓ |
| `uxsdl3.TextureSetPixel` | `(handle AS I64, x AS I32, y AS I32, rgba AS U32)` | I32 | ✓ |
| `uxsdl3.TextureSetColorMod` | `(handle AS I64, r AS I32, g AS I32, b AS I32)` | I32 | ✓ |
| `uxsdl3.TextureGetColorMod` | `(handle AS I64, which AS I32)` | I32 | ✓ |
| `uxsdl3.TextureSetAlphaMod` | `(handle AS I64, a AS I32)` | I32 | ✓ |
| `uxsdl3.TextureGetAlphaMod` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.TextureSetBlendMode` | `(handle AS I64, mode AS I32)` | I32 | ✓ |
| `uxsdl3.TextureGetBlendMode` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.TextureSetScaleMode` | `(handle AS I64, mode AS I32)` | I32 | ✓ |
| `uxsdl3.TextureGetScaleMode` | `(handle AS I64)` | I32 | ✓ |
| `uxsdl3.RenderTextureRect` | `(rendererHandle AS I64, textureHandle AS I64, sx AS F64, sy AS F64, sw AS F64, sh AS F64, dx AS F64, dy AS F64, dw AS F64, dh AS F64)` | I32 | ✓ |
| `uxsdl3.RenderTextureRotated` | `(rendererHandle AS I64, textureHandle AS I64, dx AS F64, dy AS F64, dw AS F64, dh AS F64, angle AS F64, cx AS F64, cy AS F64, flipAndCenter AS I32)` | I32 | ✓ |
| `uxsdl3.RenderTextureFrame` | `(rendererHandle AS I64, textureHandle AS I64, frameW AS I32, frameH AS I32, frameIndex AS I32, dx AS F64, dy AS F64, dw AS F64, dh AS F64)` | I32 | ✓ |
| `uxsdl3.GetTicksNS` | `()` | I64 | ✓ |
| `uxsdl3.PerfCounter` | `()` | I64 | ✓ |
| `uxsdl3.PerfFrequency` | `()` | I64 | ✓ |
| `uxsdl3.DelayNS` | `(ns AS I64)` |  | ✓ |
| `uxsdl3.DelayPreciseNS` | `(ns AS I64)` |  | ✓ |
| `uxsdl3.CurrentTimeNS` | `()` | I64 | ✓ |
| `uxsdl3.DatePart` | `(ns AS I64, localTime AS I32, which AS I32)` | I32 | ✓ |
| `uxsdl3.DaysInMonth` | `(year AS I32, month AS I32)` | I32 | ✓ |
| `uxsdl3.DayOfYear` | `(year AS I32, month AS I32, day AS I32)` | I32 | ✓ |
| `uxsdl3.BasePath` | `()` | STRING | ✓ |
| `uxsdl3.PrefPath` | `(org AS STRING, app AS STRING)` | STRING | ✓ |
| `uxsdl3.CurrentDirectory` | `()` | STRING | ✓ |
| `uxsdl3.CreateDirectory` | `(path AS STRING)` | I32 | ✓ |
| `uxsdl3.PathType` | `(path AS STRING)` | I32 | ✓ |
| `uxsdl3.PathSize` | `(path AS STRING)` | I64 | ✓ |
| `uxsdl3.PathModifyTime` | `(path AS STRING)` | I64 | ✓ |
| `uxsdl3.RemovePath` | `(path AS STRING)` | I32 | ✓ |
| `uxsdl3.RenamePath` | `(oldPath AS STRING, newPath AS STRING)` | I32 | ✓ |
| `uxsdl3.CopyFile` | `(oldPath AS STRING, newPath AS STRING)` | I32 | ✓ |
| `uxsdl3.ListDirectory` | `(path AS STRING, pattern AS STRING)` | I32 | ✓ |
| `uxsdl3.ListItem` | `(index AS I32)` | STRING | ✓ |
| `uxsdl3.CPUCount` | `()` | I32 | ✓ |
| `uxsdl3.SystemRAMMB` | `()` | I32 | ✓ |
| `uxsdl3.CPUCacheLineSize` | `()` | I32 | ✓ |
| `uxsdl3.CPUFeature` | `(which AS I32)` | I32 | ✓ |
| `uxsdl3.IsTablet` | `()` | I32 | ✓ |
| `uxsdl3.IsTV` | `()` | I32 | ✓ |
| `uxsdl3.PowerState` | `()` | I32 | ✓ |
| `uxsdl3.PowerSeconds` | `()` | I32 | ✓ |
| `uxsdl3.PowerPercent` | `()` | I32 | ✓ |
| `uxsdl3.LocaleCount` | `()` | I32 | ✓ |
| `uxsdl3.LocaleLanguage` | `(index AS I32)` | STRING | ✓ |
| `uxsdl3.LocaleCountry` | `(index AS I32)` | STRING | ✓ |
| `uxsdl3.TouchDeviceCount` | `()` | I32 | ✓ |
| `uxsdl3.TouchDeviceIdAt` | `(index AS I32)` | I64 | ✓ |
| `uxsdl3.TouchDeviceName` | `(id AS I64)` | STRING | ✓ |
| `uxsdl3.TouchDeviceType` | `(id AS I64)` | I32 | ✓ |
| `uxsdl3.TouchFingerCount` | `(id AS I64)` | I32 | ✓ |
| `uxsdl3.TouchFinger` | `(id AS I64, index AS I32, which AS I32)` | F64 | ✓ |
| `uxsdl3.JoystickNameForId` | `(instanceId AS I32)` | STRING | ✓ |
| `uxsdl3.GamepadNameForId` | `(instanceId AS I32)` | STRING | ✓ |
| `uxsdl3.JoystickVendorForId` | `(instanceId AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickProductForId` | `(instanceId AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickTypeForId` | `(instanceId AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickInstanceId` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickVendor` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickProduct` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickType` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickGuid` | `(handle AS I32)` | STRING | ✓ |
| `uxsdl3.JoystickPlayerIndex` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickSetPlayerIndex` | `(handle AS I32, index AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickRumble` | `(handle AS I32, low AS I32, high AS I32, ms AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickNumBalls` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickBall` | `(handle AS I32, ballIndex AS I32, which AS I32)` | I32 |  |
| `uxsdl3.JoystickPowerState` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.JoystickPowerPercent` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadType` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadTypeName` | `(kind AS I32)` | STRING | ✓ |
| `uxsdl3.GamepadPlayerIndex` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadSetPlayerIndex` | `(handle AS I32, index AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadSetLED` | `(handle AS I32, r AS I32, g AS I32, b AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadPowerState` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadPowerPercent` | `(handle AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadRumbleTriggers` | `(handle AS I32, left AS I32, right AS I32, ms AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadHasSensor` | `(handle AS I32, kind AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadSetSensorEnabled` | `(handle AS I32, kind AS I32, enabled AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadSensorEnabled` | `(handle AS I32, kind AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadSensor` | `(handle AS I32, kind AS I32, index AS I32)` | F64 | ✓ |
| `uxsdl3.GamepadMapping` | `(handle AS I32)` | STRING | ✓ |
| `uxsdl3.AddGamepadMapping` | `(mapping AS STRING)` | I32 | ✓ |
| `uxsdl3.GamepadButtonName` | `(button AS I32)` | STRING | ✓ |
| `uxsdl3.GamepadAxisName` | `(axis AS I32)` | STRING | ✓ |
| `uxsdl3.GamepadButtonFromName` | `(name AS STRING)` | I32 | ✓ |
| `uxsdl3.GamepadAxisFromName` | `(name AS STRING)` | I32 | ✓ |
| `uxsdl3.GamepadButtonLabel` | `(handle AS I32, button AS I32)` | I32 | ✓ |
| `uxsdl3.GamepadAxisDeadZone` | `(handle AS I32, axis AS I32, deadZone AS F64)` | F64 | ✓ |
| `uxsdl3.PackRGBA` | `(r AS I32, g AS I32, b AS I32, a AS I32)` | U32 | ✓ |
| `uxsdl3.UnpackR` | `(rgba AS U32)` | I32 | ✓ |
| `uxsdl3.UnpackG` | `(rgba AS U32)` | I32 | ✓ |
| `uxsdl3.UnpackB` | `(rgba AS U32)` | I32 | ✓ |
| `uxsdl3.UnpackA` | `(rgba AS U32)` | I32 | ✓ |
| `uxsdl3.HasWindowFlag` | `(winHandle AS I64, flag AS I64)` | I32 | ✓ |
| `uxsdl3.GetDisplayWidth` | `(displayId AS I32)` | I32 | ✓ |
| `uxsdl3.GetDisplayHeight` | `(displayId AS I32)` | I32 | ✓ |
| `uxsdl3.GetWindowX` | `(winHandle AS I64)` | I32 | ✓ |
| `uxsdl3.GetWindowY` | `(winHandle AS I64)` | I32 | ✓ |
| `uxsdl3.GetWindowPixelWidth` | `(winHandle AS I64)` | I32 | ✓ |
| `uxsdl3.GetWindowPixelHeight` | `(winHandle AS I64)` | I32 | ✓ |
| `uxsdl3.RenderOutputWidth` | `(rendererHandle AS I64)` | I32 | ✓ |
| `uxsdl3.RenderOutputHeight` | `(rendererHandle AS I64)` | I32 | ✓ |
| `uxsdl3.SetRenderDrawColorRGBA` | `(rendererHandle AS I64, rgba AS U32)` | I32 | ✓ |

## uxsqlite  (uxsqlite; 40 fonksiyon/sub, 6 sabit, testte çağrılan 38)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxsqlite.Version` | `()` | STRING |  |
| `uxsqlite.Open` | `(path AS STRING)` | U64 | ✓ |
| `uxsqlite.OpenMemory` | `()` | U64 | ✓ |
| `uxsqlite.Close` | `(db AS U64)` |  | ✓ |
| `uxsqlite.Exec` | `(db AS U64, sql AS STRING)` | I32 | ✓ |
| `uxsqlite.Prepare` | `(db AS U64, sql AS STRING)` | U64 | ✓ |
| `uxsqlite.Finalize` | `(stmt AS U64)` |  | ✓ |
| `uxsqlite.BindI64` | `(stmt AS U64, index1 AS I32, value AS I64)` | I32 | ✓ |
| `uxsqlite.BindF64` | `(stmt AS U64, index1 AS I32, value AS F64)` | I32 | ✓ |
| `uxsqlite.BindText` | `(stmt AS U64, index1 AS I32, value AS STRING)` | I32 | ✓ |
| `uxsqlite.Step` | `(stmt AS U64)` | I32 | ✓ |
| `uxsqlite.Reset` | `(stmt AS U64)` | I32 | ✓ |
| `uxsqlite.ColumnCount` | `(stmt AS U64)` | I32 | ✓ |
| `uxsqlite.ColumnType` | `(stmt AS U64, column0 AS I32)` | I32 | ✓ |
| `uxsqlite.ColumnI64` | `(stmt AS U64, column0 AS I32)` | I64 | ✓ |
| `uxsqlite.ColumnF64` | `(stmt AS U64, column0 AS I32)` | F64 | ✓ |
| `uxsqlite.ColumnText` | `(stmt AS U64, column0 AS I32)` | STRING | ✓ |
| `uxsqlite.LastInsertRowId` | `(db AS U64)` | I64 | ✓ |
| `uxsqlite.Changes` | `(db AS U64)` | I32 | ✓ |
| `uxsqlite.ErrorText` | `(db AS U64)` | STRING | ✓ |
| `uxsqlite.Version` | `()` | STRING |  |
| `uxsqlite.Open` | `(path AS STRING)` | U64 | ✓ |
| `uxsqlite.OpenMemory` | `()` | U64 | ✓ |
| `uxsqlite.Close` | `(db AS U64)` |  | ✓ |
| `uxsqlite.Exec` | `(db AS U64, sql AS STRING)` | I32 | ✓ |
| `uxsqlite.Prepare` | `(db AS U64, sql AS STRING)` | U64 | ✓ |
| `uxsqlite.Finalize` | `(stmt AS U64)` |  | ✓ |
| `uxsqlite.BindI64` | `(stmt AS U64, index1 AS I32, value AS I64)` | I32 | ✓ |
| `uxsqlite.BindF64` | `(stmt AS U64, index1 AS I32, value AS F64)` | I32 | ✓ |
| `uxsqlite.BindText` | `(stmt AS U64, index1 AS I32, value AS STRING)` | I32 | ✓ |
| `uxsqlite.Step` | `(stmt AS U64)` | I32 | ✓ |
| `uxsqlite.Reset` | `(stmt AS U64)` | I32 | ✓ |
| `uxsqlite.ColumnCount` | `(stmt AS U64)` | I32 | ✓ |
| `uxsqlite.ColumnType` | `(stmt AS U64, column0 AS I32)` | I32 | ✓ |
| `uxsqlite.ColumnI64` | `(stmt AS U64, column0 AS I32)` | I64 | ✓ |
| `uxsqlite.ColumnF64` | `(stmt AS U64, column0 AS I32)` | F64 | ✓ |
| `uxsqlite.ColumnText` | `(stmt AS U64, column0 AS I32)` | STRING | ✓ |
| `uxsqlite.LastInsertRowId` | `(db AS U64)` | I64 | ✓ |
| `uxsqlite.Changes` | `(db AS U64)` | I32 | ✓ |
| `uxsqlite.ErrorText` | `(db AS U64)` | STRING | ✓ |

## uxstats  (namespace yok; 83 fonksiyon/sub, 0 sabit, testte çağrılan 69)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `UXSTATS_Version` | `()` | I32 | ✓ |
| `UXSTATS_VecCreate` | `(capacity AS I32)` | U64 | ✓ |
| `UXSTATS_VecFree` | `(h AS U64)` | I32 | ✓ |
| `UXSTATS_VecClear` | `(h AS U64)` | I32 |  |
| `UXSTATS_VecCount` | `(h AS U64)` | I32 | ✓ |
| `UXSTATS_VecCapacity` | `(h AS U64)` | I32 |  |
| `UXSTATS_VecPush` | `(h AS U64, value AS F64)` | I32 | ✓ |
| `UXSTATS_VecSet` | `(h AS U64, index AS I32, value AS F64)` | I32 |  |
| `UXSTATS_VecGet` | `(h AS U64, index AS I32)` | F64 |  |
| `UXSTATS_Sum` | `(h AS U64)` | F64 |  |
| `UXSTATS_Mean` | `(h AS U64)` | F64 | ✓ |
| `UXSTATS_Min` | `(h AS U64)` | F64 |  |
| `UXSTATS_Max` | `(h AS U64)` | F64 |  |
| `UXSTATS_Range` | `(h AS U64)` | F64 |  |
| `UXSTATS_VariancePop` | `(h AS U64)` | F64 |  |
| `UXSTATS_VarianceSamp` | `(h AS U64)` | F64 |  |
| `UXSTATS_StdDevPop` | `(h AS U64)` | F64 |  |
| `UXSTATS_StdDevSamp` | `(h AS U64)` | F64 | ✓ |
| `UXSTATS_Median` | `(h AS U64)` | F64 | ✓ |
| `UXSTATS_Percentile` | `(h AS U64, p AS F64)` | F64 | ✓ |
| `UXSTATS_CovarianceSamp` | `(x AS U64, y AS U64)` | F64 |  |
| `UXSTATS_Correlation` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS_RegressionSlope` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS_RegressionIntercept` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS_RegressionR2` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS_RawMeanF64` | `(dataPtr AS U64, count AS I32)` | F64 |  |
| `UXSTATS_RawStdDevSampF64` | `(dataPtr AS U64, count AS I32)` | F64 |  |
| `UXSTATS2_Version` | `()` | I32 | ✓ |
| `UXSTATS2_VecCreate` | `(capacity AS I32)` | U64 | ✓ |
| `UXSTATS2_VecFree` | `(h AS U64)` | I32 | ✓ |
| `UXSTATS2_VecPush` | `(h AS U64, value AS F64)` | I32 | ✓ |
| `UXSTATS2_VecSet` | `(h AS U64, index AS I32, value AS F64)` | I32 | ✓ |
| `UXSTATS2_VecGet` | `(h AS U64, index AS I32)` | F64 | ✓ |
| `UXSTATS2_VecCount` | `(h AS U64)` | I32 | ✓ |
| `UXSTATS2_NormalCDF` | `(z AS F64)` | F64 | ✓ |
| `UXSTATS2_NormalP2` | `(z AS F64)` | F64 | ✓ |
| `UXSTATS2_TP2` | `(t AS F64, df AS F64)` | F64 | ✓ |
| `UXSTATS2_ChiSquareP` | `(stat AS F64, df AS F64)` | F64 | ✓ |
| `UXSTATS2_FP` | `(stat AS F64, df1 AS F64, df2 AS F64)` | F64 | ✓ |
| `UXSTATS2_OneSampleTStat` | `(x AS U64, mu0 AS F64)` | F64 | ✓ |
| `UXSTATS2_OneSampleTP` | `(x AS U64, mu0 AS F64)` | F64 | ✓ |
| `UXSTATS2_WelchTStat` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_WelchTP` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_PooledTStat` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_PooledTP` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_PairedTStat` | `(before AS U64, after AS U64)` | F64 | ✓ |
| `UXSTATS2_PairedTP` | `(before AS U64, after AS U64)` | F64 | ✓ |
| `UXSTATS2_OneSampleZStat` | `(x AS U64, mu0 AS F64, sigma AS F64)` | F64 | ✓ |
| `UXSTATS2_OneSampleZP` | `(x AS U64, mu0 AS F64, sigma AS F64)` | F64 | ✓ |
| `UXSTATS2_TwoSampleZStat` | `(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64)` | F64 | ✓ |
| `UXSTATS2_TwoSampleZP` | `(x AS U64, y AS U64, sigmaX AS F64, sigmaY AS F64)` | F64 | ✓ |
| `UXSTATS2_OnePropZStat` | `(successes AS I32, n AS I32, p0 AS F64)` | F64 | ✓ |
| `UXSTATS2_OnePropZP` | `(successes AS I32, n AS I32, p0 AS F64)` | F64 | ✓ |
| `UXSTATS2_TwoPropZStat` | `(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32)` | F64 | ✓ |
| `UXSTATS2_TwoPropZP` | `(s1 AS I32, n1 AS I32, s2 AS I32, n2 AS I32)` | F64 | ✓ |
| `UXSTATS2_FVarianceStat` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_FVarianceP` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_ChiSquareGOFStat` | `(obs AS U64, expected AS U64)` | F64 | ✓ |
| `UXSTATS2_ChiSquareGOFP` | `(obs AS U64, expected AS U64)` | F64 | ✓ |
| `UXSTATS2_ChiSquare2x2Stat` | `(a AS F64, b AS F64, c AS F64, d AS F64)` | F64 | ✓ |
| `UXSTATS2_ChiSquare2x2P` | `(a AS F64, b AS F64, c AS F64, d AS F64)` | F64 | ✓ |
| `UXSTATS2_AnovaOneWayF` | `(values AS U64, groups AS U64)` | F64 | ✓ |
| `UXSTATS2_AnovaOneWayP` | `(values AS U64, groups AS U64)` | F64 | ✓ |
| `UXSTATS2_PosthocBonferroniTP` | `(values AS U64, groups AS U64, g1 AS F64, g2 AS F64, comparisons AS I32)` | F64 | ✓ |
| `UXSTATS2_PosthocTukeyQ` | `(values AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ |
| `UXSTATS2_PosthocScheffeF` | `(values AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ |
| `UXSTATS2_CovarianceSamp` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_Correlation` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_RegressionSlope` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_RegressionIntercept` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_RegressionR2` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_RegressionF` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_RegressionFP` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_VIFPair` | `(x AS U64, y AS U64)` | F64 | ✓ |
| `UXSTATS2_DurbinWatson` | `(resid AS U64)` | F64 | ✓ |
| `UXSTATS2_BreuschGodfreyLM` | `(resid AS U64, lags AS I32)` | F64 | ✓ |
| `UXSTATS2_BreuschGodfreyP` | `(resid AS U64, lags AS I32)` | F64 | ✓ |
| `UXSTATS2_ADFStat` | `(y AS U64)` | F64 | ✓ |
| `UXSTATS2_ADFP` | `(y AS U64)` | F64 | ✓ |
| `UXSTATS2_AncovaBinaryF` | `(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ |
| `UXSTATS2_AncovaBinaryP` | `(y AS U64, covar AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ |
| `UXSTATS2_HotellingT2_2D` | `(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ |
| `UXSTATS2_HotellingP_2D` | `(x1 AS U64, x2 AS U64, groups AS U64, g1 AS F64, g2 AS F64)` | F64 | ✓ |

## uxsystem  (uxsystem; 25 fonksiyon/sub, 1 sabit, testte çağrılan 24)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxsystem.Version` | `()` | STRING |  |
| `uxsystem.ComputerName` | `()` | STRING | ✓ |
| `uxsystem.UserName` | `()` | STRING | ✓ |
| `uxsystem.WindowsDirectory` | `()` | STRING | ✓ |
| `uxsystem.SystemDirectory` | `()` | STRING | ✓ |
| `uxsystem.TempDirectory` | `()` | STRING | ✓ |
| `uxsystem.CurrentDirectory` | `()` | STRING | ✓ |
| `uxsystem.SetCurrentDirectory` | `(path AS STRING)` | I32 | ✓ |
| `uxsystem.ExecutablePath` | `()` | STRING | ✓ |
| `uxsystem.EnvironmentGet` | `(name AS STRING)` | STRING | ✓ |
| `uxsystem.EnvironmentSet` | `(name AS STRING,value AS STRING)` | I32 | ✓ |
| `uxsystem.EnvironmentDelete` | `(name AS STRING)` | I32 | ✓ |
| `uxsystem.CpuCount` | `()` | I32 | ✓ |
| `uxsystem.Architecture` | `()` | I32 | ✓ |
| `uxsystem.MemoryTotal` | `()` | U64 | ✓ |
| `uxsystem.MemoryAvailable` | `()` | U64 | ✓ |
| `uxsystem.MemoryLoadPercent` | `()` | I32 | ✓ |
| `uxsystem.Is64Bit` | `()` | I32 | ✓ |
| `uxsystem.IsAdministrator` | `()` | I32 | ✓ |
| `uxsystem.ProcessId` | `()` | U32 | ✓ |
| `uxsystem.ThreadId` | `()` | U32 | ✓ |
| `uxsystem.TickCountMs` | `()` | U64 | ✓ |
| `uxsystem.ScreenWidth` | `()` | I32 | ✓ |
| `uxsystem.ScreenHeight` | `()` | I32 | ✓ |
| `uxsystem.ErrorText` | `()` | STRING | ✓ |

## uxtensor  (uxtensor; 38 fonksiyon/sub, 4 sabit, testte çağrılan 37)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxtensor.Version` | `()` | I32 |  |
| `uxtensor.Backend` | `()` | STRING | ✓ |
| `uxtensor.Create1D` | `(n AS I64)` | U64 | ✓ |
| `uxtensor.Create2D` | `(rows AS I64, cols AS I64)` | U64 | ✓ |
| `uxtensor.Create3D` | `(a AS I64, b AS I64, c AS I64)` | U64 | ✓ |
| `uxtensor.Create4D` | `(a AS I64, b AS I64, c AS I64, d AS I64)` | U64 | ✓ |
| `uxtensor.Free` | `(t AS U64)` |  | ✓ |
| `uxtensor.Clone` | `(t AS U64)` | U64 | ✓ |
| `uxtensor.SliceAxis0` | `(t AS U64, start AS I64, count AS I64)` | U64 | ✓ |
| `uxtensor.DType` | `(t AS U64)` | I32 | ✓ |
| `uxtensor.NDim` | `(t AS U64)` | I32 | ✓ |
| `uxtensor.Dim` | `(t AS U64, axis AS I32)` | I64 | ✓ |
| `uxtensor.Stride` | `(t AS U64, axis AS I32)` | I64 | ✓ |
| `uxtensor.Size` | `(t AS U64)` | I64 | ✓ |
| `uxtensor.ElemSize` | `(t AS U64)` | I64 | ✓ |
| `uxtensor.DataPtr` | `(t AS U64)` | U64 | ✓ |
| `uxtensor.Fill` | `(t AS U64, value AS F64)` |  | ✓ |
| `uxtensor.Zero` | `(t AS U64)` |  | ✓ |
| `uxtensor.GetFlat` | `(t AS U64, index AS I64)` | F64 | ✓ |
| `uxtensor.SetFlat` | `(t AS U64, index AS I64, value AS F64)` |  | ✓ |
| `uxtensor.Get2D` | `(t AS U64, r AS I64, c AS I64)` | F64 | ✓ |
| `uxtensor.Set2D` | `(t AS U64, r AS I64, c AS I64, value AS F64)` |  | ✓ |
| `uxtensor.Get3D` | `(t AS U64, a AS I64, b AS I64, c AS I64)` | F64 | ✓ |
| `uxtensor.Set3D` | `(t AS U64, a AS I64, b AS I64, c AS I64, value AS F64)` |  | ✓ |
| `uxtensor.Get4D` | `(t AS U64, a AS I64, b AS I64, c AS I64, d AS I64)` | F64 | ✓ |
| `uxtensor.Set4D` | `(t AS U64, a AS I64, b AS I64, c AS I64, d AS I64, value AS F64)` |  | ✓ |
| `uxtensor.Add` | `(a AS U64, b AS U64)` | U64 | ✓ |
| `uxtensor.Subtract` | `(a AS U64, b AS U64)` | U64 | ✓ |
| `uxtensor.Multiply` | `(a AS U64, b AS U64)` | U64 | ✓ |
| `uxtensor.Divide` | `(a AS U64, b AS U64)` | U64 | ✓ |
| `uxtensor.Scale` | `(a AS U64, scalar AS F64)` | U64 | ✓ |
| `uxtensor.Sum` | `(a AS U64)` | F64 | ✓ |
| `uxtensor.Mean` | `(a AS U64)` | F64 | ✓ |
| `uxtensor.Dot` | `(a AS U64, b AS U64)` | F64 | ✓ |
| `uxtensor.Norm2` | `(a AS U64)` | F64 | ✓ |
| `uxtensor.MatMul` | `(a AS U64, b AS U64)` | U64 | ✓ |
| `uxtensor.MatVec` | `(a AS U64, x AS U64)` | U64 | ✓ |
| `uxtensor.Transpose2D` | `(a AS U64)` | U64 | ✓ |

## uxterminal  (uxterminal; 17 fonksiyon/sub, 0 sabit, testte çağrılan 2)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxterminal.Version` | `()` | I32 | ✓ |
| `uxterminal.EnableAnsi` | `()` | I32 |  |
| `uxterminal.Clear` | `()` |  |  |
| `uxterminal.HideCursor` | `()` |  |  |
| `uxterminal.ShowCursor` | `()` |  |  |
| `uxterminal.SetScroll` | `(x AS I32, y AS I32)` |  |  |
| `uxterminal.DrawText` | `(x AS I32, y AS I32, fg AS I32, bg AS I32, text AS STRING)` |  |  |
| `uxterminal.DrawSprite` | `(x AS I32, y AS I32, fg AS I32, bg AS I32, sprite AS STRING)` |  |  |
| `uxterminal.RectCollision` | `(ax AS I32, ay AS I32, aw AS I32, ah AS I32, bx AS I32, by AS I32, bw AS I32, bh AS I32)` | I32 | ✓ |
| `uxterminal.GetWidth` | `()` | I32 |  |
| `uxterminal.GetHeight` | `()` | I32 |  |
| `uxterminal.KeyHit` | `()` | I32 |  |
| `uxterminal.GetKey` | `()` | I32 |  |
| `uxterminal.DrawCell` | `(x AS I32, y AS I32, fg AS I32, bg AS I32, ch AS I32)` |  |  |
| `uxterminal.DrawHLine` | `(x AS I32, y AS I32, length AS I32, ch AS I32, fg AS I32, bg AS I32)` |  |  |
| `uxterminal.DrawVLine` | `(x AS I32, y AS I32, length AS I32, ch AS I32, fg AS I32, bg AS I32)` |  |  |
| `uxterminal.DrawBox` | `(x AS I32, y AS I32, w AS I32, h AS I32, fg AS I32, bg AS I32)` |  |  |

## uxuuid  (uxuuid; 9 fonksiyon/sub, 1 sabit, testte çağrılan 8)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `uxuuid.Version` | `()` | STRING |  |
| `uxuuid.NewUuid` | `()` | STRING | ✓ |
| `uxuuid.Nil` | `()` | STRING | ✓ |
| `uxuuid.IsValid` | `(uuid AS STRING)` | I32 | ✓ |
| `uxuuid.Normalize` | `(uuid AS STRING)` | STRING | ✓ |
| `uxuuid.Equal` | `(a AS STRING,b AS STRING)` | I32 | ✓ |
| `uxuuid.IsNil` | `(uuid AS STRING)` | I32 | ✓ |
| `uxuuid.WithoutBraces` | `(uuid AS STRING)` | STRING | ✓ |
| `uxuuid.ErrorText` | `()` | STRING | ✓ |

## uxwasmrt  (namespace yok; 16 fonksiyon/sub, 0 sabit, testte çağrılan 16)

| Ad | Parametreler | Dönüş | Testte |
|---|---|---|---|
| `WasmRuntimeApiVersion` | `()` | I32 | ✓ |
| `WasmProvider` | `()` | STRING | ✓ |
| `WasmRuntimeAvailable` | `()` | I32 | ✓ |
| `WasmRuntimePath` | `()` | STRING | ✓ |
| `WasmValidateFile` | `(pathValue AS STRING)` | I32 | ✓ |
| `WasmOpenFile` | `(pathValue AS STRING)` | I32 | ✓ |
| `WasmClose` | `(sessionHandle AS I32)` | I32 | ✓ |
| `WasmHasExport` | `(sessionHandle AS I32, exportName AS STRING)` | I32 | ✓ |
| `WasmCallI32_0` | `(sessionHandle AS I32, exportName AS STRING)` | I32 | ✓ |
| `WasmCallI32_1` | `(sessionHandle AS I32, exportName AS STRING, a0 AS I32)` | I32 | ✓ |
| `WasmCallI32_2` | `(sessionHandle AS I32, exportName AS STRING, a0 AS I32, a1 AS I32)` | I32 | ✓ |
| `WasmCallI32_3` | `(sessionHandle AS I32, exportName AS STRING, a0 AS I32, a1 AS I32, a2 AS I32)` | I32 | ✓ |
| `WasmCallI32_4` | `(sessionHandle AS I32, exportName AS STRING, a0 AS I32, a1 AS I32, a2 AS I32, a3 AS I32)` | I32 | ✓ |
| `WasmLastOk` | `(sessionHandle AS I32)` | I32 | ✓ |
| `WasmLastErrorCode` | `(sessionHandle AS I32)` | I32 | ✓ |
| `WasmLastError` | `(sessionHandle AS I32)` | STRING | ✓ |

# Ek E — Kapsam denetimi

Lexer anahtar sözcükleri, yerleşik ad adayları ve kütüphanelerden belgede HİÇ geçmeyenler. Boş değilse belge eksiktir.

- Anahtar sözcük (241): `ABI`, `ABS`, `ABSTRACT`, `ALIAS`, `ALIGN`, `AND`, `ANDALSO`, `ARRAY`, `AS`, `ASC`, `ASSERT`, `ATN`, `BALL`, `BIGD`, `BIGF`, `BOOLEAN`, `BYREF`, `BYVAL`, `CALL`, `CASE`, `CATCH`, `CDBL`, `CDECL`, `CHR`, `CIMP`, `CINT`, `CLASS`, `CLNG`, `CLOSE`, `CLS`, `CODEPTR`, `CODEVAR`, `COLOR`, `CONST`, `CONSTRUCTOR`, `COS`, `CSNG`, `DEC`, `DECLARE`, `DECORATOR`, `DEFBYT`, `DEFDBL`, `DEFEXT`, `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFSTR`, `DELETE`, `DESTRUCTOR`, `DICT`, `DIM`, `DO`, `EACH`, `ELSE`, `ELSEIF`, `END`, `ENUM`, `EOF`, `EOL`, `EQA`, `EQV`, `ERRPATH`, `ERRVAR`, `EVENT`, `EXIT`, `EXP`, `F128`, `F32`, `F64`, `F80`, `FALSE`, `FINAL`, `FINALLY`, `FIX`, `FOR`, `FRIEND`, `FUNCTION`, `GET`, `GETKEY`, `GOSUB`, `GOTO`, `I16`, `I32`, `I64`, `I8`, `IDA`, `IDB`, `IF`, `IFF`, `IMMUTABLE`, `IMP`, `IMPLEMENTS`, `IMPORT`, `IN`, `INC`, `INCLUDE`, `INKEY`, `INLINE`, `INPUT`, `INT`, `INTERFACE`, `IS`, `KEYWORD`, `LCASE`, `LEN`, `LIBTYPE`, `LIST`, `LOCATE`, `LOF`, `LOG`, `LOOP`, `LPTR`, `LTRIM`, `MAGIC`, `MAIN`, `MEMCOPYB`, `MEMCOPYD`, `MEMCOPYQ`, `MEMCOPYW`, `MEMFILLB`, `MEMFILLD`, `MEMFILLQ`, `MEMFILLW`, `METHOD`, `MID`, `MIXIN`, `MOD`, `MODULE`, `MUTABLE`, `NAMESPACE`, `NAND`, `NATIVE`, `NCIMP`, `NEW`, `NEXT`, `NIMP`, `NOR`, `NOT`, `NOTA`, `NOTB`, `NXOR`, `OBJECT`, `OFF`, `OFFSETOF`, `ON`, `ONE`, `OP`, `OPEN`, `OPERATOR`, `OR`, `ORELSE`, `OUTPATH`, `OUTVAR`, `OVERRIDE`, `PACK`, `PARALEL`, `PEEK`, `PEEKB`, `PEEKD`, `PEEKQ`, `PEEKS`, `PEEKW`, `PIPE`, `POKE`, `POKEB`, `POKED`, `POKEQ`, `POKES`, `POKEW`, `PRINT`, `PRIVATE`, `PROPERTY`, `PROTECTED`, `PTR`, `PUBLIC`, `PUT`, `RANDOMIZE`, `READONLY`, `REDIM`, `RESTRICTED`, `RETURN`, `RND`, `ROL`, `ROR`, `RTRIM`, `RUNPATH`, `SADD`, `SEALED`, `SEEK`, `SELECT`, `SET`, `SETNEWOFFSET`, `SETSTRINGSIZE`, `SGN`, `SHELL`, `SHL`, `SHR`, `SIN`, `SIZEOF`, `SLOT`, `SPACE`, `SPAWN`, `SQR`, `SQRT`, `STATIC`, `STDCALL`, `STEP`, `STR`, `STRING`, `STRPTR`, `STRUCT`, `SUB`, `TAN`, `TASK`, `TASKGROUP`, `THEN`, `THREAD`, `THROW`, `TIMEOUT`, `TIMER`, `TO`, `TRIGGER`, `TRUE`, `TRY`, `TYPE`, `U16`, `U32`, `U64`, `U8`, `UCASE`, `UNION`, `UNTIL`, `USING`, `VAL`, `VARPTR`, `VIRTUAL`, `WEND`, `WHILE`, `XNOR`, `XOR`, `ZERO`
- Yerleşik ad (167): `ADD`, `ANY`, `API`, `APPEND`, `ATOMIC`, `AUDIO`, `BAND`, `BIGDECIMAL`, `BIGFLOAT`, `BIGI`, `BIGINIT`, `BIGINT`, `BIGINTEGER`, `BIN`, `BINARY`, `BITAND`, `BITNOT`, `BITOR`, `BITXOR`, `BLOCK`, `BNOT`, `BODY`, `BOOL`, `BOR`, `BREAK`, `BROWSER`, `BXOR`, `BYTE`, `CANCELLED`, `CANVAS`, `CASE_BLOCK`, `CASE_ELSE`, `CASE_IS_VALUE`, `COMMENT`, `CONSOLE`, `CONTINUE`, `CURL`, `DAY`, `DBL`, `DBLE`, `DIAGNOSTIC_ONLY`, `DICTCLEAR`, `DICTGET`, `DICTHAS`, `DICTLEN`, `DICTSET`, `DIM_BOUNDS`, `DIRECT`, `DIV`, `DLL`, `DONE`, `DOUBLE`, `DO_UNTIL`, `DO_WHILE`, `ENUM_BASE_TYPE`, `ERROR`, `EXT`, `EXTENDED`, `EXTFP`, `FETCH`, `FFI`, `FILE`, `FLOAT`, `FLOAT128`, `HOST`, `HTTP`, `IDENT`, `IDENTIFIER`, `IMPLEMENTED`, `INIT`, `INPUTF`, `INSTANCEOF`, `INSTR`, `INTEGER`, `JSON`, `LBOUND`, `LCASE$`, `LEFT`, `LEFT$`, `LIBRARY`, `LISTADD`, `LISTCLEAR`, `LISTGET`, `LISTLEN`, `LISTREMOVE`, `LISTSET`, `LLAMA`, `LONG`, `LONGINT`, `LOOP_UNTIL`, `LOOP_WHILE`, `LUA`, `MATH`, `ME`, `MEMCOPY`, `MEMORY`, `MID$`, `MIN`, `MIR`, `MISSING`, `MS`, `MUL`, `MUTEX`, `NASM`, `NOWAIT`, `NS`, `NULL`, `NUMBER`, `OS`, `OUT`, `OUTPUT`, `PENDING`, `POINTER`, `POST`, `POW`, `PRESERVE`, `PROGRAM`, `PROLOG`, `QUAD`, `RAND`, `RANDOM`, `REGEX`, `RETURN_TYPE`, `RIGHT`, `RIGHT$`, `RUNNING`, `RUNTIME_CALL`, `SBYTE`, `SETADD`, `SETCLEAR`, `SETHAS`, `SETLEN`, `SETREMOVE`, `SHELL_OPTION`, `SHORT`, `SINGLE`, `SNG`, `SNGLE`, `SQLITE`, `SUPER`, `SYSTEM`, `THIS`, `TOSTRING`, `TRIM`, `TRIM$`, `TYPE_`, `TYPE_FIELD`, `UBOUND`, `UBYTE`, `UCASE$`, `UINT`, `UINTEGER`, `ULONG`, `ULONGINT`, `UNARY`, `US`, `USHORT`, `VALUE`, `VAR`, `VARIANT`, `VOID`, `WARN`, `WEBGPU`, `WSTRING`, `WSTRPTR`, `YEAR`, `ZSTRING`
- Kütüphane (46): `uxaimath`, `uxarchive`, `uxcapi`, `uxclazz`, `uxclz`, `uxcollections`, `uxcompress`, `uxconfig`, `uxcrypto`, `uxdataframe`, `uxdataset`, `uxdatetime`, `uxfs`, `uxgraph`, `uxgsl`, `uxhttp`, `uxjson`, `uxjsruntime`, `uxllama`, `uxllamax`, `uxlog`, `uxlogic`, `uxmath`, `uxmathcore`, `uxmatrix`, `uxnn`, `uxnn2`, `uxnn3`, `uxonnx`, `uxonnx2`, `uxpath`, `uxprocess`, `uxpython`, `uxraylib`, `uxraylib_s100`, `uxraylib_s60`, `uxregex`, `uxscalar_module`, `uxsdl3`, `uxsqlite`, `uxstats`, `uxsystem`, `uxtensor`, `uxterminal`, `uxuuid`, `uxwasmrt`
