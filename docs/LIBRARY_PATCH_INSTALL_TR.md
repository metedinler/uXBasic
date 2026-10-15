# uXBasic Kütüphane Sistemi Yamasını Kurma

## Yedek

Yama yalnız değişen ve yeni dosyaları içerir. Yine de mevcut `uxb` klasörünü veya en azından aynı adlı dosyaları yedekleyin.

## Paket türleri

İki eşdeğer ZIP hazırlanır:

1. **Parent-root paket:** İçinde `uxb\...` yolları bulunur. `C:\...\UXBc` klasörüne açılır.
2. **Direct-root paket:** İçinde doğrudan `src\`, `runtime_ext\`, `libsx\` yolları bulunur. Mevcut `C:\...\UXBc\uxb` klasörüne açılır.

Her iki durumda “var olan dosyaların üzerine yaz” seçilir. İki paketi birden uygulamayın.

## Doğrulama ve üretim

Kurulumdan sonra:

```powershell
cd C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb
.\BUILD_UXB_LIBRARY_SYSTEM.ps1
```

Başarılı çalışmada temel sonuçlar:

```text
bin\uxb.exe                 x64
bin\uxffi.dll               x64
bin\uxmathcore.dll          x64
bin\uxmath.dll              x64
bin\uxstats.dll             x64
bin\uxstats2.dll            x64
dist\libraries\bin\*.dll
reports\libraries\sessions\<zaman>\session_result.json
```

## Statik kontrol

DLL üretmeden yalnız kaynak bütünlüğünü sınamak için:

```powershell
python tools\library_tools\uxb_library_source_gate.py --root .
python tools\library_tools\uxb_library_abi.py --root .
python tools\library_tools\uxb_library_layout_doctor.py --root .
```

## Eski ürünleri kaynak dışına taşıma

```powershell
.\compiler\scripts\organize_library_layout.ps1 -RemoveSourceProducts
```

Bu işlem silmez; ürünleri `_retired\library_source_products\<zaman>` altına taşır.
