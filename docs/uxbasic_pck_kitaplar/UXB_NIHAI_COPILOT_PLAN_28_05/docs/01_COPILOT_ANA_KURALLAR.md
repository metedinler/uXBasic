# 01 — Copilot Ana Kurallar, Emirler ve Statüler

## Copilot'a ana emir

Bu proje uXBasic içindir. Yeni mimari icat etme. Var olan mimariyi kırmadan güçlendir.

## Mutlak yasaklar

```text
Dosya silme.
Klasör silme.
Eski dosyayı emekliye ayırmadan yok etme.
BROKEN'ı IMPLEMENTED yapma.
MISSING'i saklama.
Diagnostic-only sonucu başarı sayma.
Partial WAT/JS/WASM çıktısını PASS sayma.
Dış araç yoksa başarı deme; EXTERNAL_TOOL_MISSING raporla.
Eski çalışan route'u kırarak yeni route ekleme.
```

## Kullanılacak statüler

```text
IMPLEMENTED
NOT_APPLICABLE
COMPILE_TIME_ONLY
RUNTIME_CALL
NATIVE_ONLY
JS_ONLY
WASM_ONLY
WASM_UNSUPPORTED
BROWSER_ONLY
DIAGNOSTIC_ONLY
RESERVED
REMOVED
MISSING
BROKEN
```

Boş hücre yok. Her matrix hücresinde bu statülerden biri bulunacak.

## Hata sınıfları

```text
KOD_EKSIK
BAGLANTI_KOPUK
CLI_BAGLI_DEGIL
RAPOR_ESKI
GATE_GEVSEK
YANLIS_IMPLEMENTED
RUNTIME_SERVICE_EKSIK
BACKEND_EMIT_EKSIK
SOURCE_MAPPING_EKSIK
EXTERNAL_TOOL_MISSING
TEST_EKSIK
PARITY_FAIL
```

## Çalışma biçimi

Her adımda şu sıra zorunlu:

```text
1. Mevcut kodu tara.
2. Envanter/bağlantı raporu üret.
3. Yeni dosya eklenecekse önce include noktalarını belirle.
4. Mevcut route'u kırmadan bridge/gate ekle.
5. Pozitif test yaz.
6. Negatif test yaz.
7. Expected/actual CSV üret.
8. Gate JSON/MD üret.
9. Sonraki adıma geçmeden PASS/FAIL durumunu açık yaz.
```

## Kabul kuralı

Bir adım sadece şu dört çıktı varsa tamamdır:

```text
reports/control/current/<step>_gate.json
reports/control/current/<step>_gate.md
reports/control/current/<step>_expected_actual.csv
reports/control/current/<step>_error_classification.csv
```

## Kanonik klasörler

```text
src/
tools/control/
reports/control/current/
reports/control/history/<run_id>/
docs/matrix/
compiler/scripts/
tests/
_retired/
```
