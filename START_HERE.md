# uXBasic Baslangic Rehberi

Bu dosya bilgisayari cok iyi bilmeyen ama uXBasic'i denemek isteyen kisi icin yazildi.

## 1. Gerekli programlar

Windows uzerinde sunlar gereklidir:

1. FreeBASIC
2. NASM
3. MinGW veya CodeBlocks MinGW toolchain
4. Git

Bu proje en rahat Windows 10/11 uzerinde denenir.

## 2. Hangi dosyayi acacagim

Ilk once sunlari ac:

1. [README.md](README.md)
2. [PCK5.md](PCK5.md)
3. [tests/basicCodeTests/42_uxb_native_console_codegen_smoke.bas](tests/basicCodeTests/42_uxb_native_console_codegen_smoke.bas)

## 3. Ilk program nasil yazilir

Asagidaki gibi bir `.bas` dosyasi yazabilirsin:

```basic
PRINT "Merhaba uXBasic"
PRINT 123
```

veya:

```basic
DEFINT A-Z
x = 10
PRINT x
```

## 4. Compiler nasil derlenir

PowerShell ac:

```powershell
& 'C:\Program Files (x86)\FreeBASIC\fbc.exe' -b 'src\main.bas' -x 'build\uxbasic.exe'
```

Bu komut compiler'i olusturur.

## 5. Yazdigim `.bas` dosyasini nasil calistiracagim

### Yorumlayici ile

```powershell
.\build\uxbasic.exe .\ornek.bas --execmem
```

### Native x64 exe olarak

```powershell
.\build\uxbasic.exe .\ornek.bas --build-x64
```

Bu durumda sonuc genelde su klasore yazilir:

```text
dist\x64build\program.exe
```

## 6. Hazir denenecek ornekler

### Guvenli ilk denemeler

- [42_uxb_native_console_codegen_smoke.bas](tests/basicCodeTests/42_uxb_native_console_codegen_smoke.bas)
- [43_uxb_native_flow_math_codegen_smoke.bas](tests/basicCodeTests/43_uxb_native_flow_math_codegen_smoke.bas)

### Windows API denemeleri

- [31_uxb_windows_kernel_sleep_tick.bas](tests/basicCodeTests/31_uxb_windows_kernel_sleep_tick.bas)
- [32_uxb_windows_user32_metrics.bas](tests/basicCodeTests/32_uxb_windows_user32_metrics.bas)

Not:

- Bu Windows API ornekleri bugun icin parse ve native build lane'de ilerliyor.
- Ama tum DLL cagrilarinin gercek runtime etkisi henuz tamamlanmadi.

## 7. Grafik arayuz su an calisiyor mu

Durumu acikca soyleyelim:

- GUI tarafinda syntax ve API deneme dosyalari var.
- Native x64 compiler tarafinda DLL/API emit boslugu buyuk oranda kapatildi.
- Ama gercek Win32 GUI runtime davranisi henuz tamamlanmis degil.

Yani:

- Konsol programlari: daha saglam
- GUI / ileri Windows API: gelisim asamasinda

## 8. Sonuclari nerede gorecegim

Test JSON ve build ciktilari burada:

- [tests/basicCodeTests/out](tests/basicCodeTests/out)

Toplu rapor burada:

- [tests/basicCodeTests/RESULTS.md](tests/basicCodeTests/RESULTS.md)

## 9. Ogrenmek icin sirali yol

1. `PRINT`, `IF`, `FOR`, `DIM`
2. `STRING`, `LEN`, `MID`, `ABS`, `FIX`
3. dizi ve `TYPE`
4. `IMPORT`, `INLINE`, `CALL(DLL)`
5. native x64 build
