# uxstats runtime

`uxstats.dll`, standart C `math.h` tabanlı küçük bir istatistik runtime DLL'idir.
Ağır dış bağımlılık yoktur. MSYS2 UCRT64 GCC ile derlenir.

Kurulum:

```bat
winget install MSYS2.MSYS2
```

MSYS2 UCRT64 shell içinde:

```bash
pacman -Syu
pacman -S mingw-w64-ucrt-x86_64-gcc
```

Build:

```bat
uxb\runtime_ext\uxstats\build_uxstats_dll.bat
```
