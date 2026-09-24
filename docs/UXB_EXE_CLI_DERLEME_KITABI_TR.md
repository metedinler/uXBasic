# uxb.exe ile `.uxb` ve `.bas` Derleme Kitabı

Bu belge, daha önce hiç komut satırı kullanmamış bir kişinin de bir yapay zekâ
ajanının da aynı adımları hatasız tekrarlayabilmesi için yazılmıştır.

## 1. Önce üç kavram

- **Kaynak dosya:** Sizin yazdığınız `program.uxb` veya `program.bas`.
- **Derleyici:** Kaynağı okuyan `uxb.exe`.
- **Çıktı:** Yorumlayıcı sonucu, `.asm`, `.exe`, `.js`, `.wat` veya `.wasm`.

Bir dosyaya çift tıklamakla komut satırından derlemek aynı şey değildir. Komut
satırında önce `uxb.exe` yolunu, sonra yapılacak işi, sonra kaynak dosyayı
yazarsınız:

```text
uxb.exe İŞ KAYNAK SEÇENEKLER
```

Örnek:

```powershell
.\bin\uxb.exe run .\ornekler\merhaba.uxb
```

Burada `run` işin adıdır; `merhaba.uxb` kaynak dosyadır.

## 2. Terminali doğru klasörde açma

PowerShell açın. uXBasic klasörüne geçin:

```powershell
cd "C:\uXBasic\uxb"
```

Sizde klasör başka yerdeyse tırnak içindeki yolu değiştirin. Yolun içinde boşluk
varsa tırnakları silmeyin.

Derleyicinin gerçekten bulunduğunu kontrol edin:

```powershell
Test-Path .\bin\uxb.exe
```

`True` görmelisiniz. Ardından:

```powershell
.\bin\uxb.exe --version
.\bin\uxb.exe --help
```

PowerShell’de aynı klasördeki programı çalıştırmak için baştaki `.\` gereklidir.
CMD kullanıyorsanız eşdeğer komut `bin\uxb.exe --help` biçimindedir.

## 3. İlk kaynak dosya

`merhaba.uxb` adlı UTF-8 metin dosyası oluşturun:

```basic
PRINT "Merhaba uXBasic"
```

`.bas` uzantısı da kabul edilir. İçerik uXBasic sözdizimi olmalıdır; uzantının
`.bas` olması kodu otomatik olarak başka bir BASIC lehçesine dönüştürmez.

## 4. En güvenli öğrenme sırası

Her yeni programda aşağıdaki sırayı kullanın.

### Adım 1 — Yalnız sözdizimini kontrol et

```powershell
.\bin\uxb.exe par .\merhaba.uxb
```

Bu aşama yazım yapısını kontrol eder. Programı çalıştırmaz ve EXE üretmez.

### Adım 2 — Türleri ve anlamı kontrol et

```powershell
.\bin\uxb.exe sem .\merhaba.uxb
```

Değişken türü, parametre sayısı ve geçersiz çağrı gibi hatalar burada bulunur.

### Adım 3 — Yorumlayıcıda çalıştır

AST yorumlayıcı:

```powershell
.\bin\uxb.exe run .\merhaba.uxb --interpreter-backend AST
```

MIR yorumlayıcı:

```powershell
.\bin\uxb.exe run .\merhaba.uxb --interpreter-backend MIR
```

İkisinin program çıktısı aynı olmalıdır. Bu komutlar Windows EXE üretmeden
programı çalıştırır.

### Adım 4 — Gerçek Windows EXE üret

Çıktı klasörünü oluşturun:

```powershell
New-Item -ItemType Directory -Force .\build | Out-Null
```

Ardından:

```powershell
.\bin\uxb.exe bld .\merhaba.uxb --build-x64 --build-x64-out .\build\merhaba.exe
```

Üretildiğini kontrol edin ve çalıştırın:

```powershell
Test-Path .\build\merhaba.exe
.\build\merhaba.exe
Write-Host "Çıkış kodu: $LASTEXITCODE"
```

`Test-Path` sonucu `True` değilse derleme tamamlanmamıştır; terminaldeki ilk
hata satırından başlayarak sorunu düzeltin.

## 5. `.bas` için aynı komutlar

```powershell
.\bin\uxb.exe par .\program.bas
.\bin\uxb.exe sem .\program.bas
.\bin\uxb.exe run .\program.bas --interpreter-backend AST
.\bin\uxb.exe bld .\program.bas --build-x64 --build-x64-out .\build\program.exe
```

Uzantı dışında işlem aynıdır.

## 6. Tek seferde kopyalanabilir reçeteler

### Sadece çalıştır

```powershell
$uxb = ".\bin\uxb.exe"
$src = ".\program.uxb"
& $uxb par $src
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $uxb sem $src
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& $uxb run $src --interpreter-backend AST
exit $LASTEXITCODE
```

### EXE derle ve yalnız başarılıysa çalıştır

```powershell
$uxb = ".\bin\uxb.exe"
$src = ".\program.uxb"
$exe = ".\build\program.exe"
New-Item -ItemType Directory -Force (Split-Path $exe) | Out-Null
& $uxb bld $src --build-x64 --build-x64-out $exe
if ($LASTEXITCODE -ne 0) {
    Write-Error "Derleme başarısız. EXE çalıştırılmadı."
    exit $LASTEXITCODE
}
& $exe
exit $LASTEXITCODE
```

### CMD/BAT reçetesi

```bat
@echo off
setlocal
cd /d "%~dp0"
if not exist build mkdir build
bin\uxb.exe bld program.uxb --build-x64 --build-x64-out build\program.exe
if errorlevel 1 exit /b %errorlevel%
build\program.exe
exit /b %errorlevel%
```

## 7. AST ve MIR ne zaman seçilir?

- `AST`: Kaynak yapısına en yakın yürütme yolu; hata ayıklamak ve dil davranışını
  görmek için iyi başlangıçtır.
- `MIR`: Derleyicinin orta seviye gösterimi; optimizasyon ve native backend ile
  uyumu sınamak için kullanılır.
- Native x64 üretmeden önce aynı programı ikisinde de çalıştırmak faydalı bir
  çapraz kontroldür.

```powershell
.\bin\uxb.exe int .\program.uxb --interpreter-backend AST
.\bin\uxb.exe int .\program.uxb --interpreter-backend MIR
```

## 8. Yalnız NASM assembly üretmek

```powershell
.\bin\uxb.exe x64 .\program.uxb `
  --emit-x64-nasm `
  --emit-x64-nasm-out .\build\program.asm
```

Bu komut `.asm` üretir. `.exe` istiyorsanız `bld --build-x64` reçetesini
kullanın.

## 9. JavaScript, WAT ve WASM

JavaScript:

```powershell
.\bin\uxb.exe jsw .\program.uxb --emit-js --js-out .\build\program.js
```

WAT:

```powershell
.\bin\uxb.exe wat .\program.uxb --emit-wat --wat-out .\build\program.wat
```

WASM:

```powershell
.\bin\uxb.exe wat .\program.uxb --emit-wat --emit-wasm `
  --wat-out .\build\program.wat `
  --wasm-out .\build\program.wasm
```

WASM dönüşümü için dağıtımdaki `tools\wabt\bin\wat2wasm.exe` veya PATH üzerinde
uyumlu `wat2wasm` gerekebilir.

## 10. Hata raporlarını dosyaya yazma

```powershell
.\bin\uxb.exe sem .\program.uxb `
  --semantic-json-out .\build\semantic.json `
  --symbol-table-json-out .\build\symbols.json `
  --type-table-json-out .\build\types.json
```

AST ve MIR incelemesi:

```powershell
.\bin\uxb.exe ast .\program.uxb --dump-ast --ast-json-out .\build\ast.json
.\bin\uxb.exe mir .\program.uxb --dump-mir --mir-full-json-out .\build\mir.json
```

Yapay zekâ ajanları terminal metnini tahmin etmek yerine bu JSON dosyalarını
okuyabilir.

## 11. Çıkış kodu nasıl okunur?

Her komuttan hemen sonra:

```powershell
$LASTEXITCODE
```

- `0`: Komut başarılı.
- `0` dışı: Hata veya başarısız doğrulama.

Bir betik, hata aldıktan sonra sonraki adıma körlemesine geçmemelidir:

```powershell
& .\bin\uxb.exe sem .\program.uxb
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
```

## 12. En sık yapılan hatalar

### “uxb.exe tanınmıyor”

Yanlış:

```powershell
uxb.exe --help
```

Doğru, eğer `uxb` klasöründeyseniz:

```powershell
.\bin\uxb.exe --help
```

Ya da tam yol:

```powershell
& "C:\uXBasic\uxb\bin\uxb.exe" --help
```

### “Kaynak dosya bulunamadı”

```powershell
Test-Path .\program.uxb
Resolve-Path .\program.uxb
```

Yanlış klasördeyseniz `cd` ile doğru klasöre geçin veya tam yol kullanın.

### Yolun içinde boşluk var

PowerShell’de çağrı operatörü ve tırnak kullanın:

```powershell
& "C:\Program Files\uXBasic\uxb.exe" run "C:\Benim Projem\oyun.uxb"
```

### EXE oluştu ama DLL bulunamadı

Dağıtım klasör yapısını bozmayın. `uxb_runtime.dll` ve dağıtımdaki gerekli
runtime DLL’leri `uxb.exe`/üretilen programın beklediği `bin` veya runtime
klasöründe bulunmalıdır. Rastgele DLL indirmeyin; aynı dağıtım paketindeki
dosyaları kullanın.

### EXE yerine yalnız `.asm` oluştu

`--emit-x64-nasm` yalnız assembly üretir. EXE için:

```powershell
.\bin\uxb.exe bld .\program.uxb --build-x64 --build-x64-out .\build\program.exe
```

### Eski çıktı çalışıyor

Her derlemeden önce çıktı zamanını ve hash’ini kontrol edebilirsiniz:

```powershell
Get-Item .\build\program.exe | Select-Object Length,LastWriteTime
Get-FileHash .\build\program.exe -Algorithm SHA256
```

## 13. Derleyicinin kendisini `build.bat` ile derlemek

Dağıtılan kaynak ağacının `uxb` klasöründe:

```powershell
cd "C:\uXBasic\uxb"
.\build.bat
```

PowerShell bir BAT dosyasını bu biçimde çalıştırabilir. CMD’de:

```bat
cd /d C:\uXBasic\uxb
build.bat
```

Birden fazla build BAT dosyası varsa önce adlarını görün:

```powershell
Get-ChildItem . -Filter "*build*.bat"
```

Sonra yalnız istediğiniz dosyayı çalıştırın. Derleme başarı ölçütleri:

```powershell
$LASTEXITCODE
Test-Path .\bin\uxb.exe
Get-Item .\bin\uxb.exe | Select-Object Length,LastWriteTime
```

`$LASTEXITCODE` sıfır ve `uxb.exe` yeni tarihli olmalıdır. BAT içinde kullanılan
FreeBASIC derleyicisi (`fbc.exe`/`fbc64.exe`) bulunamazsa PATH’i veya betikteki
yolu düzeltmeden devam etmeyin.

## 14. Yapay zekâ ajanı için deterministik işlem sözleşmesi

Bir ajan aşağıdaki sırayı izlemelidir:

1. `uxb.exe`, kaynak ve çıktı yollarını mutlak yola çevir.
2. Kaynağın varlığını ve uzantısının `.uxb`/`.bas` olduğunu kontrol et.
3. `par`, sonra `sem` çalıştır; ilk sıfır dışı çıkış kodunda dur.
4. Davranış testi gerekiyorsa AST ve MIR yorumlayıcı sonuçlarını ayrı kaydet.
5. Native çıktı istenmişse açık bir `--build-x64-out` yolu ver.
6. Çıkış kodu sıfır olsa bile beklenen dosyanın varlığını, boyutunu ve zamanını
   doğrula.
7. Hata günlüğünü ve komutu rapora yaz; kullanıcı kaynaklarını silme.
8. Aynı ada sahip eski EXE’yi yeni derleme sanmamak için SHA-256 kaydet.

Önerilen komut:

```powershell
& $uxb bld $source --build-x64 --build-x64-out $output `
  --artifact-report-json-out $artifactReport `
  --semantic-diagnostics-json-out $semanticReport
```

## 15. Bir dakikalık özet

```powershell
cd "C:\uXBasic\uxb"
.\bin\uxb.exe par .\program.uxb
.\bin\uxb.exe sem .\program.uxb
.\bin\uxb.exe run .\program.uxb --interpreter-backend AST
New-Item -ItemType Directory -Force .\build | Out-Null
.\bin\uxb.exe bld .\program.uxb --build-x64 --build-x64-out .\build\program.exe
.\build\program.exe
```

Bu altı komutun anlamını biliyorsanız temel uXBasic CLI kullanımını biliyorsunuz.
