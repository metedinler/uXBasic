# Adim2 Toolchain Doctor

- overall_ok: `True`
- linker_priority: `gcc_or_g++`

## Checks

| name | ok | path | note |
|---|---|---|---|
| fbc | True | C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\tools\FreeBASIC-1.10.1-win64\fbc.exe | FreeBASIC compiler |
| nasm | True | C:\Program Files\CodeBlocks\MinGW\bin\nasm.exe | NASM assembler |
| msys2_gcc | True | C:\msys64\ucrt64\bin\gcc.exe | MSYS2 UCRT64 gcc |
| msys2_g++ | True | C:\msys64\ucrt64\bin\g++.exe | MSYS2 UCRT64 g++ |
| msys2_pacman | True | C:\msys64\usr\bin\pacman.exe | MSYS2 pacman |
| libquadmath | True | C:/msys64/ucrt64 | quadmath runtime/library |
| mpfr | True | C:/msys64/ucrt64 | mpfr runtime/library |
| gmp | True | C:/msys64/ucrt64 | gmp runtime/library |
| linker | True | C:\msys64\ucrt64\bin\gcc.exe | priority=gcc_or_g++ |

## ExtFP Runtime Gate

- strict_status: `FAIL`
- diagnostics_status: `EXPECTED_DIAGNOSTIC`

| dll | ok | path |
|---|---|---|
| uxb_fp80.dll | False | C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\dist\runtime_ext\uxb_fp80.dll |
| uxb_fp128.dll | False | C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\dist\runtime_ext\uxb_fp128.dll |
| uxb_bigfp.dll | False | C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\dist\runtime_ext\uxb_bigfp.dll |