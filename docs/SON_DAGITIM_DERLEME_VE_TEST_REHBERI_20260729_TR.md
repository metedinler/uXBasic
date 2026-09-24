# uXBasic Son Dağıtım: Derleme ve Test Rehberi

Bu belge, komut satırına hiç alışık olmayan bir kullanıcı için hazırlanmıştır.
Komutları uXBasic klasöründe PowerShell açarak çalıştırın.

## 1. Derleyiciyi üretme

64 bit Windows derleyicisini üretmek için:

```powershell
.\build_64.bat
```

Bu BAT dosyası sırasıyla FreeBASIC araçlarını bulur, ana FreeBASIC sarmalayıcı
kaynağını derler, 64 bit `uxb.exe` üretir ve sonucu `bin\uxb.exe` konumuna
yerleştirir. Kaynaklar değişmediyse zaman kaybetmemek için
`COMPILER_UP_TO_DATE` yazar.

32 bit derleyici gerekiyorsa:

```powershell
.\build_32.bat
```

Mimarinin otomatik seçilmesini istiyorsanız:

```powershell
.\build.bat
```

Dağıtım düzenindeki release derlemesi için:

```powershell
.\build_release.bat
```

## 2. Bir `.uxb` veya `.bas` programını çalıştırma

AST yorumlayıcısı ile hemen çalıştırma:

```powershell
.\bin\uxb.exe int .\program.uxb --interpreter-backend AST
```

MIR yorumlayıcısı ile çalıştırma:

```powershell
.\bin\uxb.exe int .\program.uxb --interpreter-backend MIR
```

Native 64 bit EXE üretme:

```powershell
.\bin\uxb.exe bld .\program.uxb `
  --x64-mode MIR `
  --build-x64-out .\build\program_x64
```

Üretilen programı çalıştırma:

```powershell
.\build\program_x64\program.exe
```

Bir yol boşluk içeriyorsa çift tırnak kullanın:

```powershell
.\bin\uxb.exe int "C:\Benim Projem\program.bas" --interpreter-backend AST
```

Tüm CLI seçeneklerinin güncel açıklaması:

```powershell
.\bin\uxb.exe --help
```

Varsayılan ileti dili İngilizcedir. Türkçe için:

```powershell
.\bin\uxb.exe int .\program.uxb --message-lang tr
```

## 3. Ana doğrulamalar

Tipli EVENT/PIPE/THREAD/PARALEL testleri:

```powershell
.\tests\typed_task_routines\run_typed_task_tests.ps1 -Uxb .\bin\uxb.exe
```

STRUCT/UNION ve UXCAPI testi:

```powershell
.\tests\struct_union_uxcapi\run_struct_union_uxcapi_smoke.ps1 `
  -Uxb .\bin\uxb.exe
```

MIR Full JSON v2:

```powershell
.\tests\mir_full_json_v2\run_mir_full_json_v2_smoke.ps1 `
  -SkipBuild -Uxb .\bin\uxb.exe
```

Kütüphane kaynak, wrapper ve ABI denetimi:

```powershell
python .\tools\library_tools\uxb_library_source_gate.py --root .
python .\tools\library_tools\uxb_library_abi.py --root .
python .\tools\library_tools\uxb_ecosystem_doctor.py --root . --strict-source
```

UXClazz, `uxclz.dll` ve uxbdll testi:

```powershell
.\RUN_UXCLAZZ_UXBDLL_WINDOWS_TESTS.ps1 -Yes
```

VS Code eklentisi:

```powershell
Set-Location .\vscode-extension
npm ci
npm test
npx @vscode/vsce package --out ..\dist\vscode\uxbasic-workbench-0.3.0.vsix
Set-Location ..
```

## 4. PDSX dönüşümü

```powershell
.\tools\pdsx\uxbasic2pdsxS\run_uxbasic_to_pdsx.ps1 `
  -Source .\program.uxb `
  -Out .\build\program_pdsx
```

Araç önce gerçek `uxb.exe` ile AST JSON üretir, ardından pdsX `.prj` ve `.basx`
dosyalarını hazırlar. Ayrıntılı dönüşüm ve kapsam raporları çıktı klasöründeki
`reports` altında bulunur.

## 5. Sorun olduğunda

- `uxb.exe bulunamadı`: önce `.\build_64.bat` çalıştırın.
- DLL bulunamadı: programı dağıtımın `bin` klasöründen çalıştırın; gereken
  runtime DLL’leri aynı klasörde tutulur.
- Kaynak yolu bulunamadı: tam yolu çift tırnakla verin.
- Ayrıntılı compiler tanılama: `--trace` ve `--debug` seçeneklerini ekleyin.
- Makine tarafından okunabilir tanılama için `--all-diagnostics-json-out`
  seçeneğini kullanın.

Daha geniş CLI öğreticisi için `docs\UXB_EXE_CLI_DERLEME_KITABI_TR.md`,
kütüphane API tabloları için `docs\UXB_DLL_WRAPPER_API_ENVANTERI_20260729.md`
dosyasına bakın.
