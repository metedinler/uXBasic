# Raptor/Copilot Hasar Tespit ve Kurtarma Notu

## Kısa karar

Bu çalışma ağacı temiz değil. Üzerinde doğrudan ezme, merge veya push yapılmamalı.

Görünen tabloya göre Raptor/Copilot:

1. Adım 36 hata raporunu okumuş.
2. `49_STRUCT_POINTER_IMPORT_MIX` ve `SIZEOF/OFFSETOF` hattına odaklanmış.
3. `src/type_binding/type_check_call.fbs` içinde küçük bir dönüş tipi düzeltmesi yapmış.
4. Sadece bu dosyayı commit etmeye çalışmış.
5. Push denemesi başarısız olmuş; sebep kod hatası değil, repoya/branch geçmişine büyük dosyaların girmiş olması.
6. Daha sonra ikinci bir dalda `lexer_preprocess.fbs` ve `backend_native_surface_scan.fbs` dosyalarını commit etmeye çalışmış; bu da aynı büyük dosya geçmişi yüzünden push aşamasında sorunlu.

## Tehlikeli görünen alanlar

Git durumunda çok fazla değişiklik görünüyor:

- çok sayıda `M` değiştirilmiş dosya,
- çok sayıda `D` silinmiş görünen dosya,
- yüzlerce `??` izlenmeyen dosya/klasör,
- büyük arşivler, PDB dosyaları, runtime dependency klasörleri,
- `_retired`, `dist`, `reports`, eski zipler, test çıktıları.

Bu tablo normal bir tek dosyalık düzeltme tablosu değil; çalışma alanı kirlenmiş.

## Ezilirse ne olur?

### Güvenli sayılabilecek ezmeler

Bunlar çalışma çıktısıdır; kaybı genelde ana kaynak kodu bozmaz:

- `reports/control/current/`
- `reports/control/history/`
- `dist/`
- `dist/loglar/`
- test run çıktıları
- geçici `tmp*` dosyaları
- `current.zip`, `control.zip` gibi rapor arşivleri

Ama rapor geçmişini saklamak istiyorsan önce yedekle.

### Tehlikeli ezmeler

Bunlar doğrudan derleyici mimarisini etkiler:

- `uxb/src/**`
- `uxb/main.bas`
- `uxb/compiler/scripts/*.ps1`
- `uxb/compiler/wrappers/*.exe`
- `uxb/build/*.exe`
- `runtime_ext/**`
- `tests/**`

Bu alanlar rastgele ezilirse Adım 45/50 ilerlemesi geri alınabilir veya karışabilir.

## En güvenli kurtarma yolu

### 1. Hiçbir şeyi silmeden önce tam yedek al

PowerShell:

```powershell
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$root = "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean"
$backup = "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean_BACKUP_BEFORE_RESCUE_$stamp"
Copy-Item $root $backup -Recurse -Force
Write-Host "Yedek alindi: $backup"
```

### 2. Git durumunu dosyaya dök

```powershell
cd C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean
git status --porcelain > RAPTOR_git_status_before_rescue.txt
git log --oneline -20 > RAPTOR_git_log_before_rescue.txt
```

### 3. Çalışma alanındaki değişiklikleri patch olarak sakla

```powershell
git diff > RAPTOR_worktree_diff_before_rescue.patch
git diff --stat > RAPTOR_worktree_diff_before_rescue.stat.txt
```

### 4. Büyük dosyaları repodan uzak tutacak `.gitignore` ekle

Öneri:

```gitignore
# Generated/runtime output
**/dist/
**/reports/control/current/
**/reports/control/history/
**/build/*.exe
**/compiler/wrappers/*.exe

# Heavy dependencies
**/runtime_ext/deps/
**/*.pdb
**/*.zip
**/*.rar
**/*.7z

# Temporary logs
**/*.log
**/*.hata.log
**/tmp*
```

### 5. Temiz kaynak üzerinden devam et

Eğer hedef artık Adım 50 ise, en doğru yol:

- kirli klasörü ana çalışma yeri yapma,
- temiz `src(31.05_2).zip` veya daha yeni güvenilir kaynak paketinden ayrı klasöre aç,
- sadece kesin gerekli yamaları tek tek uygula,
- `reports`, `dist`, `_retired`, büyük DLL/PDB/zip/rar dosyalarını kaynak repoya sokma.

## Raptor/Copilot için net hüküm

Raptor tek başına bütün dosyaları commit etmemiş görünüyor; ilk commit sadece 1 dosya değiştirmiş. Ancak çalışma ağacı zaten çok kirli olduğu için branch push sırasında 24 bin civarı obje ve 660 MB paket göndermeye çalışmış. Bu, yanlış klasör/yanlış repo kökü/önceden izlenmiş büyük dosya geçmişi sorununa işaret eder.

Bu nedenle: Raptor'un yaptığı küçük düzeltme asıl felaket değil; asıl risk, kirli çalışma ağacının veya yanlış branch geçmişinin temiz kaynakların üstüne yazılmasıdır.
