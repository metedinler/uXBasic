# uXBasic Build / Run / Wrapper / Hook Kullanım Kılavuzu

Bu belge, ana klasörde bulunan batch dosyalarının nasıl çalıştığını ve `compiler/wrappers` ile `compiler/hooks` klasörlerinin ne işe yaradığını açıklar.

## 1. Klasör Yerleşimi

Bu batch dosyaları genellikle **uXBasic ana çalışma klasörünün bir üst kökünden** çalışacak şekilde yazılmıştır. Yani aynı klasörde şu yapı beklenir:

```text
ana_klasor/
  build_64.bat
  build_compiler_64.bat
  install_vscode_extension_local.bat
  run_uxb_ast.bat
  run_uxb_mir.bat
  run_prompt0_baseline.bat
  uxb/
    src/
    compiler/
      wrappers/
      hooks/
      scripts/
    tools/
    vscode-extension/
    tests/
```

Batch dosyaları `uxb\...` yollarını aradığı için, bu dosyalar yanlışlıkla doğrudan `uxb/` klasörünün içine konursa yollar bozulabilir.

## 2. Build Dosyaları

### 2.1 `build_64.bat`

Görevi: FreeBASIC ile uXBasic ana wrapper dosyasını 64-bit exe olarak derler.

Varsayılan hedef:

```text
uxb\compiler\wrappers\uxb_main_wrapper.bas
```

Ürettiği dosyalar:

```text
uxb\compiler\wrappers\uxb_main_wrapper_64.exe
uxb\build\uxb_main_64.exe
```

Çalışma mantığı:

1. Bulunduğu klasörü `ROOT` kabul eder.
2. FreeBASIC yolu olarak önce şunu arar:

```text
tools\FreeBASIC-1.10.1-win64\fbc.exe
```

3. MSYS2 / MinGW yollarını PATH’e eklemeye çalışır.
4. Parametre verilmezse `uxb_main_wrapper.bas` dosyasını derler.
5. Parametre verilirse verilen `.bas` dosyasını derler.
6. Derleme başarılıysa exe’yi ayrıca `uxb\build\uxb_main_64.exe` olarak kopyalar.

Kullanım:

```bat
build_64.bat
```

Özel hedef derlemek için:

```bat
build_64.bat uxb\compiler\wrappers\uxb_main_wrapper.bas
```

Dikkat:

- `fbc.exe` bulunamazsa derleme başlamaz.
- `uxb\compiler\wrappers` ve `uxb\build` klasörleri yoksa oluşturulur.
- Bu dosya doğrudan compiler üretme işini yapar.

### 2.2 `build_compiler_64.bat`

Görevi: Compiler exe zaten varsa yeniden derlemeyi atlar; yoksa compiler scriptini çağırır.

Kontrol ettiği dosya:

```text
uxb\compiler\wrappers\uxb_main_wrapper_64.exe
```

Varsayılan davranış:

```text
UXB_FORCE_REBUILD=0 ise ve exe varsa derleme yapılmaz.
```

Derlemeyi zorlamak için:

```bat
set UXB_FORCE_REBUILD=1
build_compiler_64.bat
```

İçeride çağırdığı script:

```text
uxb\compiler\scripts\build_uxb_main_64.bat
```

Bu script de sonunda `build_64.bat` dosyasını çağırır.

## 3. Çalıştırma Dosyaları

### 3.1 `run_uxb_ast.bat`

Görevi: Bir `.bas` / `.uxb` dosyasını uXBasic compiler exe ile çalıştırır ve AST interpreter hattını kullanır.

Kullandığı exe:

```text
uxb\compiler\wrappers\uxb_main_wrapper_64.exe
```

Ana komut:

```bat
uxb\compiler\wrappers\uxb_main_wrapper_64.exe "kaynak.bas" --execmem --interpreter-backend AST --console-mode direct
```

Kullanım:

```bat
run_uxb_ast.bat uxb\tests\basicCodeTests\42_uxb_native_console_codegen_smoke.bas
```

Alias layer ile:

```bat
run_uxb_ast.bat --alias-layer uxb\tests\basicCodeTests\42_uxb_native_console_codegen_smoke.bas
```

Alias layer ne yapar?

- `uxb\tools\uxb_alias_overlay_preprocessor.py` çalışır.
- Kaynağı geçici olarak `uxb\_work\alias\...` altına dönüştürür.
- Compiler bu dönüştürülmüş kaynağı çalıştırır.

### 3.2 `run_uxb_mir.bat`

Görevi: Bir `.bas` / `.uxb` dosyasını MIR interpreter hattı ile çalıştırır.

Ana komut:

```bat
uxb\compiler\wrappers\uxb_main_wrapper_64.exe "kaynak.bas" --execmem --interpreter-backend MIR --mir-verify --console-mode direct
```

Kullanım:

```bat
run_uxb_mir.bat uxb\tests\basicCodeTests\42_uxb_native_console_codegen_smoke.bas
```

Alias layer ile:

```bat
run_uxb_mir.bat --alias-layer uxb\tests\basicCodeTests\42_uxb_native_console_codegen_smoke.bas
```

AST ile MIR farkı:

- AST interpreter doğrudan AST ağacını çalıştırır.
- MIR interpreter, semantic/MIR hattından gelen daha düşük seviyeli komutları çalıştırır.
- Release testlerinde ikisinin çıktısı karşılaştırılmalıdır.

## 4. Baseline ve VSCode Dosyaları

### 4.1 `run_prompt0_baseline.bat`

Görevi: Python tabanlı baseline runner’ı çalıştırır.

Çalıştırdığı araç:

```text
uxb\tools\uxbc_baseline_runner.py
```

Kullanım:

```bat
run_prompt0_baseline.bat
```

Eski çıktı yolları:

```text
uxb\dist\baseline\baseline_status.md
uxb\dist\baseline\baseline_status.json
uxb\dist\baseline\baseline_checks.csv
```

Not: Güncel politika gereği Python araçları kendi raporlarını `reports\current` altında üretmeli, eski `dist` izleri varsa Python araçlarına ait legacy rapor yolu olarak değerlendirilmelidir.

### 4.2 `install_vscode_extension_local.bat`

Görevi: `uxb\vscode-extension` klasörünü yerel VSCode extension klasörüne kopyalar.

Kaynak:

```text
uxb\vscode-extension
```

Hedef:

```text
%USERPROFILE%\.vscode\extensions\uxbasic-local.uxbasic-vscode-tools-0.1.0
```

Kullanım:

```bat
install_vscode_extension_local.bat
```

Dikkat:

- Hedef klasör varsa önce silinir.
- Sonra `robocopy` ile extension kopyalanır.
- VSCode içinde “Developer: Reload Window” çalıştırmak gerekebilir.

## 5. `compiler/wrappers` Klasörü Ne İşe Yarar?

`compiler/wrappers` klasörü, asıl kaynak kodu değiştirmeden derleyiciyi farklı katmanlardan derlemeye yarayan **sarmalayıcı / overlay** klasörüdür.

En önemli dosya:

```text
compiler\wrappers\uxb_main_wrapper.bas
```

İçeriği çok basittir:

```freebasic
#include once "../hooks/uxb_global_noop_hook.fbs"
#include once "../../src/main.bas"
```

Yani gerçek compiler burada yazılı değildir. Bu dosya sadece:

1. Hook sistemini hazırlar.
2. Asıl compiler girişini `src/main.bas` üzerinden include eder.

Diğer wrapper dosyaları:

```text
uxb_ast_bundle_wrapper.fbs       AST/parser katmanını sarmalar.
uxb_hir_bundle_wrapper.fbs       HIR katmanını sarmalar.
uxb_mir_bundle_wrapper.fbs       MIR katmanını sarmalar.
uxb_runtime_bundle_wrapper.fbs   Runtime katmanını sarmalar.
uxb_codegen_bundle_wrapper.fbs   Codegen katmanını sarmalar.
uxb_frontend_bundle_wrapper.fbs  Frontend/HIR/MIR/interop bileşenlerini birleştirir.
```

Bunlar üretim compiler’ının ana mantığı değildir; daha çok geçiş, izleme, küçük katman testleri ve eski overlay düzeni için vardır.

## 6. `compiler/hooks` Klasörü Ne İşe Yarar?

`compiler/hooks` klasörü, derleyici katmanlarına ileride izleme / trace / debug eklemek için konmuş no-op hook makrolarını taşır.

Örnek:

```freebasic
#macro UXB_AST_HOOK_STAGE(MSG)
    UXB_HOOK_TRACE("AST:" & MSG)
#endmacro
```

Ama global hook ayarı şu an kapalıdır:

```freebasic
Const UXB_HOOK_ENABLED As Integer = 0
Const UXB_HOOK_TRACE_ENABLED As Integer = 0
```

Bu nedenle hooklar normal çalışmada iş yapmaz. Ama şunlar için faydalıdır:

- AST aşaması başladı/bitti gibi iz noktaları koymak.
- MIR/codegen/runtime katmanlarını ileride izlemek.
- Asıl `src/` kodunu bozmadan debug/tracing bağlamak.

Kısa karar:

```text
compiler/hooks = izleme noktaları için no-op makro sistemi
compiler/wrappers = src/main.bas ve bazı katmanları dışarıdan include eden sarmalayıcı sistem
```

## 7. Önerilen Günlük Kullanım Sırası

### İlk kurulum / ilk build

```bat
build_64.bat
```

veya:

```bat
build_compiler_64.bat
```

### Compiler exe varsa hızlı test

```bat
run_uxb_ast.bat uxb\tests\basicCodeTests\42_uxb_native_console_codegen_smoke.bas
run_uxb_mir.bat uxb\tests\basicCodeTests\42_uxb_native_console_codegen_smoke.bas
```

### VSCode extension kurmak

```bat
install_vscode_extension_local.bat
```

### Baseline denetimi

```bat
run_prompt0_baseline.bat
```

## 8. Hangi Dosya Ne Zaman Kullanılır?

| Dosya | Ne zaman kullanılır? | Ana çıktı |
|---|---|---|
| `build_64.bat` | Compiler exe’yi doğrudan derlemek için | `uxb_main_wrapper_64.exe` |
| `build_compiler_64.bat` | Exe yoksa derlemek, varsa geçmek için | var olan veya yeni compiler exe |
| `run_uxb_ast.bat` | AST interpreter testleri için | terminal çıktısı + compiler JSON/logları |
| `run_uxb_mir.bat` | MIR interpreter testleri için | terminal çıktısı + compiler JSON/logları |
| `run_prompt0_baseline.bat` | Python baseline kontrolü için | baseline JSON/MD/CSV raporları |
| `install_vscode_extension_local.bat` | Yerel VSCode eklentisini kurmak için | VSCode extension klasörü |

## 9. Dikkat Edilecek Noktalar

1. `build_64.bat` FreeBASIC’i `tools\FreeBASIC-1.10.1-win64\fbc.exe` altında arıyor.
2. `run_uxb_ast.bat` ve `run_uxb_mir.bat`, compiler exe’nin önceden derlenmiş olmasını bekliyor.
3. Wrapper klasöründeki exe eski kalmış olabilir; büyük yamalardan sonra `UXB_FORCE_REBUILD=1` ile yeniden derleme yapılmalıdır.
4. Hooklar şu an aktif tracing yapmaz; no-op durumdadır.
5. `compiler/wrappers` aktif kaynak kodun yerine geçmez; asıl kaynak `src/` klasörüdür.
6. Eski `dist` çıktıları Python araçlarının legacy raporları olabilir; compiler’ın yeni resmi çıktıları `build/<run_id>/<dosya_tipi>/` düzeninde olmalıdır.
