# uXBasic Mini Release Checklist (Sira 13)

Bu checklist, CI ciktilari ile birebir senkron olacak sekilde release/ci_outputs.map dosyasini esas alir.

## 1. CI Kapi Kontrolu
- Workflow: .github/workflows/win64-ci.yml
- Job: build-and-test-win64
- Sonuc: basarili (green)
- Artifact: uxbasic-win-build-artifacts

## 2. Cikti Senkronu (CI -> Release)
- release/ci_outputs.map icindeki her kaynak dosya var olmalidir.
- Beklenen kaynaklar:
  - src/main_32.exe
  - src/main_64.exe
  - tests/run_manifest.exe

## 3. Lokal Kapilar
- build.bat src\main.bas
- build.bat tests\run_manifest.bas
- tests\run_manifest.exe
- build_matrix.bat src\main.bas

## 4. Paketleme
- Komut: tools\release_mini.bat vX.Y.Z-mini
- Uretilen klasor: dist\vX.Y.Z-mini
- Uretilen zip: dist\uxbasic-vX.Y.Z-mini-win32-win64.zip

## 5. Son Kontrol
- dist\vX.Y.Z-mini\SHA256SUMS.txt olustu mu
- Dist icindeki dosya adlari map ile uyumlu mu
- BUILD_INFO.txt olustu mu

## 6. Opsiyonel Yayin
- Komut: tools\release_mini.bat vX.Y.Z-mini --publish
- Not: Bu adim local git tag olusturur, origin'e push eder ve GitHub release acar.

## 7. FFI-CONV-3 Kapanis Izi (2026-04-17)
- Native lane raporu guncel ve PASS/PASS olmali: `reports/ffi_conv3_native_lanes_report.md`
- Beklenen satirlar:
  - `| native_cleanup | PASS | PASS | native lane verified |`
  - `| native_symptr_patch | PASS | PASS | native lane verified (cmd fallback) |`
- Tek komut dogrulama task'i: `validate_ffi_conv3_native_lanes_ps`
- Matrix senkronu: `reports/uxbasic_operasyonel_eksiklik_matrisi.md` icinde `FFI-CONV-3` satiri `OK/OK/OK/OK/OK` olmali.
