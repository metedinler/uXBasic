# uXBasic compilefix2 notu

Bu paket, ust dizinden calistirilan `build_64.bat` sonrasi gorunen ilk FreeBASIC derleme hatalarini hedefler.

## Hedeflenen hatalar

- `On Error Resume Next` FreeBASIC tarafinda syntax hatasi veriyor.
- `UXBRuntimeServiceHandlerName` include/declare sirasindan dolayi katalog dosyasinda gorunmuyor.
- `UXBRuntimeJsonEscape` iki runtime dosyasinda ayni adla tanimli.
- `preprocess_engine.fbs` icinde `UXBPreprocessorIsBActive()` blogunun `End If` kapamasi eksik.
- Eski `find /I` kullanan batch dosyalari Git/Unix `find.exe` ile cakisip `find: '/I'` hatasi verebiliyor.

## Kurulum

Zip'i `UXBc_Clean\UXBc` ust dizinine veya `UXBc_Clean\UXBc\uxb` alt dizinine acabilirsiniz.

Sonra:

```bat
apply_compilefix2.bat
```

Ust dizinden devam ediyorsaniz:

```powershell
.\build_64_fixed.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
```

Alt `uxb` dizininden devam ediyorsaniz:

```powershell
.\build_64_fixed.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
```

## Not

Bu paket mevcut `build_64.bat` dosyasini silmez. Guvenli olarak `build_64_fixed.bat` olusturur. Isterseniz daha sonra bunu `build_64.bat` adiyla degistirebilirsiniz.
