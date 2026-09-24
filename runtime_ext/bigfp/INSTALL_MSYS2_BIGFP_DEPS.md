# BIGF / BIGD / BALL runtime dependencies

The BIGF/BIGD/BALL runtime uses MSYS2 UCRT64 GCC with MPFR and GMP.

Install MSYS2, open the **UCRT64** shell, then run:

```bash
pacman -Syu
pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-mpfr mingw-w64-ucrt-x86_64-gmp
```

Expected compiler:

```text
C:\msys64\ucrt64\bin\gcc.exe
```

Build:

```bat
uxb\runtime_ext\bigfp\build_bigfp_dll.bat
```

Probe:

```bat
uxb\tests\fp_runtime\build_and_run_bigfp_runtime_probe.bat
```
