# build_64 pathfix notu

## Hata

Derleme su hatayla durdu:

```text
uxb\compiler\wrappers\uxb_main_wrapper.bas() error 23: File not found, uxb\compiler\wrappers\uxb_main_wrapper.bas
ERROR: FreeBASIC build failed. RC=1
```

## Sebep

Mevcut kaynak paketinde eski yol yoktur:

```text
uxb\compiler\wrappers\uxb_main_wrapper.bas
```

Yeni kaynak agacinda ana giris dosyasi sudur:

```text
src\main.bas
```

Bu nedenle eski `build_64.bat`, artik var olmayan wrapper yolunu derlemeye calismaktadir.

## Duzeltme

Bu paket proje kokune acilmalidir:

```text
UXBc_Clean\UXBc\uxb\
```

Sonra calistirin:

```bat
python tools\build\diagnose_build64_paths.py
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
```

PowerShell alternatifi:

```powershell
.\build_64.ps1 2>&1 | Tee-Object -FilePath .\build_64_error.log
```

## Paket ne yapar?

1. `build_64.bat` artik once `src\main.bas` dosyasini arar.
2. `src\main.bas` varsa `pushd src` yaparak `main.bas` derler.
3. Eski scriptler icin uyumluluk wrapper'i da eklenir:

```text
uxb\compiler\wrappers\uxb_main_wrapper.bas
```

Bu wrapper sadece `src\main.bas` dosyasini include eder.

## Beklenen sonraki hata

Bu yama yalnizca giris dosyasi/yol hatasini cozer. Sonraki derlemede kaynak kod icindeki FreeBASIC tip, include, duplicate symbol veya syntax hatalari ortaya cikabilir. O hatalar normaldir; siradaki yamalar onlara gore ilerleyecektir.
