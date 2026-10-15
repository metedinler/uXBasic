# uXBasic derleme rehberi

## En kısa yol

1. `uxb` klasörünü Dosya Gezgini ile aç.
2. Üstteki adres çubuğuna `cmd` yazıp Enter'a bas.
3. Açılan siyah pencereye şunu yaz:

```bat
build_64.bat
```

4. Sonunda `OK: x64 compiler=...\bin\uxb.exe` yazarsa derleme tamamdır.
5. Yeni derleyici şuradadır:

```text
bin\uxb.exe
```

## `build_64.bat` ne yapıyor?

`build_64.bat` küçük bir başlatıcıdır. Kendi bulunduğu klasörü bulur ve şu
PowerShell derleme betiğini çalıştırır:

```bat
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "compiler\scripts\build_uxb_main_64.ps1" -Root "."
```

PowerShell betiği de:

1. `tools\FreeBASIC-1.10.1-win64\fbc64.exe` derleyicisini bulur.
2. `compiler\wrappers\uxb_main_wrapper.bas` ana kaynağını derler.
3. Geçici x64 EXE üretir.
4. EXE'nin gerçekten 64 bit olduğunu kontrol eder.
5. Başarılı dosyayı `bin\uxb.exe` olarak yerleştirir.

## Baştan zorla derlemek

```bat
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "compiler\scripts\build_uxb_main_64.ps1" -Root "." -Force
```

## Hızlı, hata ayıklamalı derleme

```bat
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "compiler\scripts\build_uxb_main_64.ps1" -Root "." -Force -Debug
```

## Optimize edilmiş dağıtım derlemesi

```bat
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "compiler\scripts\build_uxb_main_64.ps1" -Root "." -Force -Release
```

## Tipli görev testleri

```bat
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "tests\typed_task_routines\run_typed_task_tests.ps1" -Uxb ".\bin\uxb.exe" -EmitMirX64
```

## FreeBASIC'in ürettiği C kaynağını klasör yapısıyla saklamak

```bat
ARCHIVE_FREEBASIC_C_SOURCES.bat
```

Çıktı şuna benzer bir klasöre gider:

```text
build\freebasic_c_sources\20260728_171500\compiler\wrappers\uxb_main_wrapper.c
```

Yanındaki `manifest.json`, kaynak yolu, C yolu, boyut ve SHA-256 özetini tutar.
