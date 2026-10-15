# 2. Derleyiciyi FreeBASIC ile derleme ve komut satırı (CLI)

Bu bölüm iki şeyi anlatır: **(a)** uXBasic derleyicisinin kendisini FreeBASIC ile nasıl derleyeceğinizi, **(b)** derleyiciyi
komut satırından nasıl kullanacağınızı.

## 2.1 Gereken araçlar

| Araç | Ne için? | Nerede? | Zorunlu mu? |
|---|---|---|---|
| **FreeBASIC 1.10.1 (win64)** | uXBasic derleyicisini derler | `tools/FreeBASIC-1.10.1-win64/fbc64.exe` (projede hazır gelir) | Derleyiciyi derlemek için **evet** |
| **PowerShell 7** | Derleme ve test betikleri | Sistem | Betikleri kullanacaksanız evet |
| **MSYS2 UCRT64 (g++, libuv, oneTBB)** | `uxb_runtime.dll` (çalışma zamanı) derlemesi | `C:\msys64\ucrt64\bin` | Yalnız çalışma zamanını yeniden derlemek için |
| **NASM** | x64 hedefinde assembly → nesne dosyası | PATH'te `nasm`; derleyici `C:\Program Files\CodeBlocks\MinGW\bin\nasm.exe` varsa onu seçer. Başka bir NASM için `UXB_ASM` değişkenine **tam yol** verin (2.9, G-CLI-12) | `uxb bld` ile EXE üretmek için **evet** |
| **Bağlayıcı (MinGW `gcc`)** | Nesne dosyasını çalışma zamanı kitaplığıyla EXE'ye bağlar | PATH'te `gcc` (varsa CodeBlocks MinGW klasörü); başka biri için `UXB_LINK` değişkenine tam yol | `uxb bld` için evet |
| **Node.js** | JS ve WASM çıktısını çalıştırmak/sınamak | `node` | Yalnız JS/WASM denemesi için |
| **wabt (wat2wasm)** | WAT metnini WASM ikilisine çevirir | `tools/wabt/bin/wat2wasm.exe` | WASM üretimi için evet |

## 2.2 Proje dizini

| Klasör | İçeriği |
|---|---|
| `src/` | Derleyicinin FreeBASIC kaynağı (`main.bas` giriş noktası; `lexer`, `parser`, `semantic`, `mir`, `codegen`, `interpreter`, `cli`, `preprocessor`, `surface` …) |
| `compiler/` | Derleme betikleri (`scripts/build_uxb_main_64.ps1`) ve sarmalayıcı (`wrappers/uxb_main_wrapper.bas`) |
| `native/uxb_runtime/` | C++ çalışma zamanı (`uxb_runtime.dll`): görevler, eşzamanlılık, SHELL |
| `include/modules/` | Standart kütüphane başlıkları (`*.uxmh`) |
| `libsx/` | Kütüphane kaynakları (örn. `uxsdl3`, `uxraylib`) |
| `runtime_ext/` | Kütüphane adaptörleri (DLL tarafı) |
| `bin/` | Derlenmiş araçlar: `uxb.exe`, çalışma zamanı DLL'leri |
| `tests/` | Model test paketleri (`run_all_model_tests.ps1`) |
| `tools/` | FreeBASIC, wabt, kitap/üretici araçları |
| `docs/tasarim/` | Tasarım kararları (bu kılavuzun dayanağı) |
| `docs/kitaplar/` | Doğrulanmış örnekler ve kitap araçları |
| `docs/uxbasic_5_cilt/` | Kaynak odaklı 5 ciltlik kitaplık (ayrıntılı derleyici/FFI konuları) |
| `build/` | Her çalıştırmanın çıktı klasörleri (tarih-saat adlı) |
| `ai_koordinasyon/` | Geliştirme defterleri: durum, sorun takibi, karar günlüğü |

## 2.3 Derleyiciyi derleme

### 2.3.1 Tek komutla

Proje kökünde (`uxb/`):

```
.\build_64.ps1 -Force
```

`-Force`, kaynak değişmemiş olsa bile yeniden derlemeyi zorlar; `-Force` yokken `bin\uxb.exe` kaynak dosyalarından yeniyse betik `COMPILER_UP_TO_DATE` yazıp derlemeden çıkar. Bu betik `compiler/scripts/build_uxb_main_64.ps1` dosyasını çağırır.
Betiğin davranışı (aşağıdaki adımlar, çıktı dosyaları, `-Debug`, `-Release -Debug` çakışması, `UXB_BUILD_X86`) gerçek ağaca dokunmadan, FreeBASIC'e bağlanan yalıtılmış bir kopya kökte küçük bir `main.bas` ile sınanmıştır.
Yaptığı işler:

1. `tools/FreeBASIC-1.10.1-win64/fbc64.exe`'nin varlığını denetler.
2. `PATH`'e FreeBASIC'in `bin\win64`, `bin\win32`, `C:\msys64\ucrt64\bin` ve `tools\wabt\bin` klasörlerini ekler.
3. Giriş kaynağı olarak `compiler/wrappers/uxb_main_wrapper.bas` dosyasını (varsa) yoksa `src/main.bas` dosyasını seçer.
4. `fbc64` ile derler (aşağıdaki komut).
5. Eski `bin/uxb.exe`'yi `bin/uxb.exe.pre_library_patch.bak` olarak yedekler, sonra çıkan dosyayı `bin/uxb.exe` olarak yerleştirir;
   `bin/uxb_x64.exe`, kökteki `uxb.exe` ve `compiler/wrappers/uxb_main_wrapper_64.exe` kopyalarını yazar, `build/compiler/compiler_hosts.json` özetini bırakır.
   Çalışan bir `uxb.exe` üzerine yazılamayacağı için eski görüntüyü yan tarafa (`uxb.exe.replaced_<zaman>`) alır.
6. Günlüğü `reports/libraries/logs/compiler_x64_fbc.log` dosyasına yazar.

Seçenekler: `-Release` (varsayılan, en iyilemeli), `-Debug` (hata ayıklama bilgili), `-Force`. Birlikte `-Release -Debug` verilemez (`-Release ve -Debug birlikte kullanilamaz.` hatası).

> **Dikkat:** `build_64.ps1` her zaman `bin\uxb.exe` dosyasının yerine yenisini koyar. Çalışan derleyiciyi korumak istiyorsanız 2.3.3'teki elle komutla **yeni bir adla** derleyin.

### 2.3.2 Elle `fbc` komutuyla

Betiğin arkasındaki asıl komut (kayıt: `compiler/scripts/build_uxb_main_64.ps1`):

```
fbc64.exe -v -lang fb -gen gas64 -w all -exx -mt -O 2 -strip -x bin\uxb.exe compiler\wrappers\uxb_main_wrapper.bas
```

Hata ayıklama sürümü için `-O 2 -strip` yerine `-g` yazılır:

```
fbc64.exe -v -lang fb -gen gas64 -w all -exx -mt -g -x bin\uxb_hata_ayikla.exe compiler\wrappers\uxb_main_wrapper.bas
```

| `fbc` bayrağı | Anlamı |
|---|---|
| `-v` | Ayrıntılı çıktı (hangi araç hangi sırayla çalıştı) |
| `-lang fb` | FreeBASIC'in kendi dil kipi |
| `-gen gas64` | x64 için GNU assembler üretimi (32 bit için `-gen gas`) |
| `-w all` | Bütün uyarıları aç |
| `-exx` | Genişletilmiş çalışma zamanı denetimi (dizi sınırı, boş işaretçi) |
| `-mt` | Çok iş parçacıklı çalışma zamanı kitaplığı |
| `-O 2` | Orta düzey eniyileme |
| `-strip` | Sembol bilgisini ayıkla (daha küçük dosya) |
| `-g` | Hata ayıklama bilgisi ekle (`-O 2 -strip` ile birlikte kullanılmaz) |
| `-x <dosya>` | Çıktı dosyasının adı |

> **Önemli kural:** Derleme çıktısı mimari denetiminden geçer. Betik, üretilen dosyanın gerçekten x64 olduğunu PE başlığından
> okur; farklıysa `Compiler host mimarisi yanlis` hatasıyla durur (kapalı başarısızlık).

### 2.3.3 Başka bir adla derleme (eski sürümü bozmadan)

Bir değişikliği denerken çalışan `bin/uxb.exe` dosyasını ezmeyin; yeni bir adla derleyin ve eski sürümle yan yana karşılaştırın:

```
tools\FreeBASIC-1.10.1-win64\fbc64.exe -lang fb -gen gas64 -w all -exx -mt -O 2 -strip -x bin\uxb_deneme.exe compiler\wrappers\uxb_main_wrapper.bas
```

### 2.3.4 32 bit derleyici eşliği (isteğe bağlı)

Varsayılan olarak yalnızca x64 derleyici üretilir. 32 bit eşlik dosyası (`bin\uxb_x86.exe`) için ortam değişkeni verilir, ama **kökteki `build_64.ps1` ile değil**:
o betik alttaki betiğe her zaman `-SkipX86` geçirir ve değişkeni yok sayar, uyarı da vermez (✖ G-CLI-15). Alttaki betiği doğrudan çağırın:

```
$env:UXB_BUILD_X86 = '1'; .\compiler\scripts\build_uxb_main_64.ps1 -Force
```

32 bit derleme `fbc32.exe` ister (projede `tools\FreeBASIC-1.10.1-win64\` içinde hazırdır); `bin\uxb_x86.exe` ve `compiler\wrappers\uxb_main_wrapper_32.exe` yazılır.

## 2.4 Çalışma zamanı DLL'ini derleme (`uxb_runtime.dll`)

Görevler (`SPAWN`, `THREAD`, …), SHELL ve bazı çalışma zamanı işlevleri C++ ile yazılmış bu kütüphanededir.

```
.\native\uxb_runtime\build_runtime_dll.ps1 -Variant auto
```

| `-Variant` | Ne içerir? |
|---|---|
| `auto` | libuv ve oneTBB bulunduysa ikisini de kullanır (varsayılan) |
| `std` | Yalnızca standart C++ `std::thread` yedek yolu |
| `libuv` | libuv ile (olay döngüsü, iş kuyruğu) |
| `tbb` | oneTBB ile (görev grupları) |
| `full` | libuv + oneTBB zorunlu; eksikse hata verir |

Betiğin kullandığı derleme komutunun özü (g++, MSYS2 UCRT64):

```
g++ -std=gnu++17 -O2 -Wall -Wextra -Werror -DUXB_RT_BUILD_DLL -shared -I<kaynak> \
    [-DUXB_WITH_LIBUV] [-DUXB_WITH_TBB] uxb_runtime.cpp uxb_runtime_mir.cpp uxb_runtime_state.cpp \
    uxb_runtime_task.cpp uxb_runtime_task_v2.cpp uxb_runtime_sync.cpp uxb_runtime_shell.cpp \
    backends/*.cpp [libuv bayrakları] [tbb bayrakları] \
    -static-libgcc -static-libstdc++ -Wl,--enable-auto-import -Wl,--out-implib,libuxb_runtime.dll.a -o uxb_runtime.dll
```

Çıkan `uxb_runtime.dll`, `bin/`, `dist/runtime_ext/` ve `dist/libraries/bin/` klasörlerine kopyalanır; gerekli bağımlı DLL'ler
(`libwinpthread-1.dll`, varsa `libuv-1.dll`, `libtbb12.dll`, `libgcc_s_seh-1.dll`, `libstdc++-6.dll`) de aynı yerlere konur. **Bir uXBasic EXE'sinin yanında bu DLL bulunmalıdır;** `uxb bld` bunları EXE'nin klasörüne kendisi kopyalar (2.5).

**Yalıtılmış derleme.** Çalışan sürümleri bozmadan denemek için iki parametre vardır:

| Parametre | Anlamı |
|---|---|
| `-OutputDirectory <klasör>` | DLL'i ve dosyalarını `native\uxb_runtime\build\` yerine verilen klasöre yazar |
| `-SkipPublish` | `bin\`, `dist\` klasörlerine **hiçbir kopya yazmaz**; günlük ve `build_result.json` çıktı klasöründe kalır (`published: false`) |

```
.\native\uxb_runtime\build_runtime_dll.ps1 -Variant auto -OutputDirectory $env:TEMP\rt_deneme -SkipPublish
```

Bu kılavuz yazılırken `-Variant std` (44 sn) ve `-Variant auto` (29 sn) bu biçimde derlenmiştir: `std` yukarıdaki g++ komutunu `-DUXB_WITH_*` bayrakları **olmadan**, `auto` ise `-DUXB_WITH_LIBUV -DUXB_WITH_TBB` ile çalıştırır.
Çıktı klasöründeki `uxb_runtime_<varyant>_gxx.log` dosyasının `LIBUV=` ve `TBB=` satırları hangi kitaplıkların bulunup kullanıldığını gösterir.

Ortam değişkenleri: `UXB_GXX` / `CXX` (g++ yolu), `UXB_MINGW_ROOT`, `UXB_PKG_CONFIG` (libuv/oneTBB bayraklarını bulmak için).

## 2.5 EXE üretiminin iç yolu

`uxb bld` komutu şu zinciri çalıştırır (ayrıntıyı çalıştırma klasöründeki `json\backend\x64\exe_artifact_manifest.json` dosyasında görebilirsiniz):

```
program.uxb ─(MIR)→ program.asm ─(nasm -f win64)→ obj/program.obj ─(bağlayıcı)→ program.exe
```

* Birinci adım derleyicinin içindedir.
* İkinci adım (`build_program.bat`): `"%UXB_ASM_CMD%" -f win64 program.asm -o obj\program.obj`
* Üçüncü adım (`link_program.bat`): `"%UXB_LINK_CMD%" @program_link_args.rsp -o program.exe`. Bağlayıcı olarak **MinGW `gcc`** kullanılır (FreeBASIC değil); argüman dosyasında yalnız `obj/program.obj` ve çalışma zamanı kitaplığının içe aktarma dosyası `libuxb_runtime.dll.a` vardır.
* Dördüncü adım: aynı betik, çalışma zamanı DLL'lerini EXE'nin klasörüne **kendisi kopyalar** (önce `native\uxb_runtime\build\`, bulamazsa `bin\` altından). `uxb_runtime.dll` hiçbir yerde bulunamazsa üretilen betik `[x64-build] missing uxb_runtime.dll` yazıp durur.

`UXB_ASM_CMD` ve `UXB_LINK_CMD` **ayar değildir**, betiklerin içinde kurulan sonuç değişkenleridir: `interop\toolchain.env.bat` bunları `UXB_ASM`, `UXB_LINK` ve `*_PATH` değerlerinden hesaplar.
Dışarıdan vermenin etkisi yoktur; bozuk bir değerle bile `bld` başarıyla biter. Hangi NASM ve bağlayıcının kullanılacağını **2.9'daki** değişkenlerle belirleyin.

**`bld` çıktı klasörü** (EXE'nin yazıldığı klasör; en küçük program için de aynı dosyalar oluşur):

| Dosya | Ne işe yarar? |
|---|---|
| `k.exe` | Üretilen program |
| `uxb_runtime.dll`, `libwinpthread-1.dll`, `libuv-1.dll`, `libtbb12.dll`, `libgcc_s_seh-1.dll`, `libstdc++-6.dll` | Çalışma zamanı ve bağımlıları; program görev kullanmasa bile **hepsi** konur (toplam yaklaşık 6,8 MB). EXE'yi taşırken birlikte taşıyın |
| `program.asm`, `obj\program.obj` | Üretilen assembly ve nesne dosyası |
| `build_all.bat`, `build_program.bat`, `link_program.bat`, `program_link_args.rsp` | Zinciri yeniden çalıştıran betikler. Bu bilgisayarın mutlak yollarını gömer; başka makineye taşınmaz |
| `interop\` | `toolchain.env.bat` (araç zinciri), `build_import.bat`, `link_command.bat` … (içe aktarma bildirimi olmasa da oluşur) |
| `codegen_status_report.md`, `build_all.stdout.txt`, `build_all.stderr.txt` | Rapor ve araç çıktıları |

> **✖ EKSİK (G-ARAC-7, S-117): her çıktı klasörü kendi DLL setini taşır.** İki program aynı klasöre derlenince tek set paylaşılır (ölçüldü: `a.exe` ve `b.exe` → altı DLL); her ayrı klasör yaklaşık 6,5 MB'lık yeni bir set alır ve bunu kapatan ya da setleri tek yerden paylaşan bir seçenek yoktur (`uxb hlp`). FFI çağrısı (`CALL(DLL, …)`) içeren programlar ayrıca ortak bağımlıları kopyalar (`libopenblas.dll` tek başına 42 MB; S-117 ölçümü yaklaşık 53 MB). Yüzlerce programı ayrı klasörlere derleyen test koşuları bu yüzden `reports\` klasörünü 40 GB'a çıkardı (2026-10-14 ölçümü: 23 589 DLL kopyası = 36,5 GB, okunabilir kanıt 2 GB). **Ne yapmalı:** çok sayıda programı derlerken çıktıları tek klasöre yazın ve işiniz bitince kopyaları silin.

Araç zinciri hatası `uxb bld` çıkış kodu **14** ve `build_all.bat failed with exit code 1` iletisiyle bildirilir; ayrıntı `build_all.stdout.txt` ve `build_all.stderr.txt` dosyalarındadır.

## 2.6 Test paketleri

Bütün dil davranış paketlerini tek komutla çalıştırmak için:

```
.\tests\run_all_model_tests.ps1 -Uxb .\bin\uxb.exe
```

Yalnız bazı paketleri çalıştırmak için `-Only` (bilinmeyen paket adı **hata verir**, sessizce atlanmaz):

```
.\tests\run_all_model_tests.ps1 -Uxb .\bin\uxb.exe -Only task_model,iterators
```

| Parametre | Anlamı |
|---|---|
| `-Uxb` | Denenecek derleyici (varsayılan `.\bin\uxb.exe`) |
| `-Only` | Paket adları; bilinmeyen ad `Unknown test suite: …` ile durur (çıkış 1) |
| `-ReportPath` | Markdown özet raporu (varsayılan `.\test_results\model_suite_summary.md`); her koşuda **üzerine yazılır**, bu yüzden kendi denemeniz için ayrı bir ad verin. Yanında `<rapor>.progress.json` ilerleme dosyası da yazılır. **Yalnız göreli yol verin:** mutlak yolda rapor yazılamaz, betik yine de "Tum paketler temiz." yazıp çıkış 0 verir (✖ G-CLI-14) |
| `-KeepBuildFolders` | Varsayılan olarak her `uxb` çağrısı geçici bir `--out-root` altına yönlendirilir ve paket bitince silinir; `build\<zaman>` klasörlerini saklamak için bu anahtarı verin |

Betik, her paketin kendi koşucusunu (`run_*.ps1`) çalıştırıp `Toplam: N PASS: N FAIL: N` satırını okur ve paketi `GECTI`, `DUSTU`, `CALISMADI` (koşucu bu satırı üretmedi) ya da `KOSUCU-YOK` (koşucu dosyası yok) olarak işaretler.
Süre paketten pakete çok değişir: yalnız `cli_flags` (25 denetim) yaklaşık 70 saniye sürer.

| Paket | Neyi sınar? |
|---|---|
| `compiler_consolidation` | matris, dosya/metin, SELECT, DIM, DECLARE, PRINT, ondalık/PROPERTY ve Win64 ABI |
| `numeric_model` | U64/I64, dar tamsayılar, onaltılık sabitler |
| `library_type_contract` | `LIBTYPE`, yaşam döngüsü, `RATIONAL` değer aktarımı, sağlayıcı tanıları (MIR) |
| `abi_model` | `SIZEOF`, F80 ABI, `TYPE` alanları, `VARPTR(a(i))` |
| `memoryref_model`, `memory_model` | Bellek bölgesi/ömür denetimi, AUTO/NATIVE/VIRTUAL, işaretçi aritmetiği |
| `array_params`, `array_bounds` | Dizi parametreleri, `LBOUND`/`UBOUND` |
| `sadd_model` | `SADD`, `CODEPTR`, `LPTR` |
| `language_guards` | Ayrılmış adlar, bellek deyimleri kapısı |
| `oop_parity` | Sanal çağrı, `SUPER`, kalıtım, erişim, boş alıcı |
| `iterators` | `FOR EACH` / `DO EACH` |
| `typed_task`, `task_model`, `task_native`, `task_sync` | Tipli görevler, `SPAWN`/`TASK`/`TASKGROUP`, gerçek eşzamanlılık, otomatik senkron/`LOCK`/`MUTEX`/`ATOMIC` |
| `program_end`, `string_lifetime`, `routine_scope`, `exceptions_cross`, `const_scope`, `float_text` | `END` davranışı, metin ömrü, `BYREF`/kapsam, rutin sınırını geçen `THROW`, `CONST` kapsamı, ondalık metin |
| `uxgsl`, `uxraylib`, `uxsdl3` | Kütüphane duman testleri (dört motorda) |
| `wasm_model` | WASM/WAT davranışı (Node ile gerçek çalıştırma) |
| `cli_flags` | CLI fiil/bayrakları |

Bir paket çalışmazsa tabloda `CALISMADI` olarak görünür; paket düşerse betik çıkış kodu `1` verir.

## 2.7 Komut satırı: genel biçim

```
uxb <fiil> [kaynak.uxb] [seçenekler...]
```

* Kaynak uzantısı `.uxb`, `.bas` ya da `.uxm` olmalıdır; başka uzantı `Desteklenmeyen kaynak dosya uzantisi` hatasıyla reddedilir (çıkış kodu 2). **Var olmayan dosya da aynı iletiyle, ama boş uzantıyla bildirilir** (`Desteklenmeyen kaynak dosya uzantisi:  (.bas/.uxm/.uxb bekleniyor)`); bu iletiyi görünce önce yolu denetleyin (✖ G-CLI-11).
* Seçeneklerin değerleri bir sonraki argümandır: `--out-root klasör`. Bazı seçenekler `=` ile de verilir: `--wat2wasm=yol`.
* Bilinmeyen seçenek çıkış kodu **20** ile reddedilir (`Bilinmeyen CLI secenegi`). **Bilinmeyen ya da eksik fiil ise reddedilmez:** `uxb rnu k.uxb`, `uxb k.uxb` yalnız `INFO: uXBasic started` yazıp çıkış 0 verir ve hiçbir iş yapmaz (✖ G-CLI-32). Fiil adları büyük/küçük harf duyarsızdır.
* **Her ileti stdout'a yazılır:** `INFO`, `ERROR` ve tanılar dahil derleyicinin bütün çıktısı ile çalıştırılan programın çıktısı aynı akıştadır; stderr her zaman boştur (✖ G-CLI-20). `uxb run k.uxb > dosya.txt` hata iletisini de dosyaya alır; program çıktısını ayırmak için `--stdout-out`, iletileri kısmak için `--quiet` kullanın.

### 2.7.1 Üç harfli fiiller

uXBasic komut satırının her işi **üç harfli bir fiille** başlar. Fiil, derleme hattının hangi aşamasına kadar gidileceğini ya da
ne yapılacağını seçer.

| Fiil | Açılımı | Ne yapar? | Gözlenen çıktı | Durum |
|---|---|---|---|---|
| `lex` | *lexer* (sözcük çözümleyici) | Önişlemciyi çalıştırır, kaynağı belirteçlere böler | `tokens.json`, `preprocessed.uxb`, ön yüz raporları (21 dosya) | ✔ |
| `par` | *parse* (çözümle) | Yalnızca sözdizimini denetler | `lex` ile aynı 21 dosya (`ast.json` dahil) | ✔ |
| `ast` | *AST* (soyut sözdizimi ağacı) | AST üretir, AST sözleşmesini denetler | `lex` ile aynı 21 dosya (`ast.json` dahil) | ✔ |
| `sem` | *semantic* (anlam) | Tip bağlama, ad çözümü, yerleşim | + `symbols.json`, `types.json`, `layouts.json`, `enums.json`, `type_infer_report.csv` (34 dosya) | ✔ |
| `hir` | *HIR* (yüksek düzey ara temsil) | `sem` sonrası yüksek düzey aşama | `sem` ile aynı raporlar | ◐ |
| `mir` | *MIR* (orta düzey ara kod) | MIR üretir ve doğrular | `canonical_mir.json`, `semantic_mir.json`, `mir_verify_*.json` | ◐ `--semantic` gerekir (G-CLI-1) |
| `int` | *interpret* (yorumla) | AST yorumlayıcıyla çalıştırır | program çıktısı + `execution/ast_*` | ✔ |
| `run` | *run* (çalıştır) | Yorumlayıcıyla çalıştırır; `--interpreter-backend MIR` ile MIR yorumlayıcı, `BOTH` ile ikisini birlikte çalıştırıp karşılaştırır (ayrışma yalnız `--interpreter-compare-json-out` dosyasında görünür, ✖ G-CLI-26) | program çıktısı + `execution/` | ✔ |
| `x64` | *x64* | MIR'den NASM assembly üretir | `.asm` + backend raporları | ✔ |
| `bld` | *build* (derle) | Tam yerel derleme: assembly → nesne → EXE | `.exe`, `asm/x64_mir/output.asm` | ✔ |
| `jsw` | *JS web* | JavaScript (ve `--emit-browser` ile HTML) üretir | `.js`, `.html` | ◐ |
| `wat` | *WAT* | WebAssembly metni; `--emit-wasm` ile ikili | `.wat`, `.wasm` | ◐ |
| `chk` | *check* (denetle) | Toplu doğrulama (`validate-all`) | — | ✖ `tools\run_validate_all_gate.ps1` yok (G-CLI-3) |
| `fmt` | *format* | Biçim denetimi | `lex` ile aynı | ✖ özel çıktı gözlenmedi |
| `map` | *map* (harita) | Kaynak haritası | `lex` ile aynı | ✖ `--source-map-json-out` 0 bayt (G-CLI-2) |
| `doc` | *document* (belge) | Belge üretimi | `lex` ile aynı | ✖ `--doc-json-out` 0 bayt (G-CLI-2) |
| `rel` | *release* (yayın) | Yayın kapısı denetimi | `lex` ile aynı | ✖ `--release-json-out` 0 bayt (G-CLI-2) |
| `hlp` | *help* (yardım) | Yardım metnini yazar | 322 satır (311'i dolu) | ✔ (`--verbose` reddedilir: G-CLI-7) |
| `ver` | *version* (sürüm) | `uXBasic CLI Adim12` yazar | — | ✔ |

> **Hangi fiili seçmeli?** Programı çalıştırmak istiyorsan `run`; EXE istiyorsan `bld`; sözdizimini öğrenmek istiyorsan `lex`/`ast`;
> tipleri görmek istiyorsan `sem`; ara kodu görmek istiyorsan `mir --semantic`; assembly görmek istiyorsan `x64`;
> web için `jsw` ya da `wat`.

### 2.7.2 Sık kullanılan tarifler

Aşağıdaki tariflerin her biri `bin\uxb_kilavuz_20261014_0253.exe` ile (31 komut; `20261007` ile aynı çıkış kodları ve iletilerle) çalıştırılıp çıktı dosyasının oluştuğu doğrulanmıştır (`k.uxb` küçük bir örnek programdır).
**WAT/WASM tarifleri için `k.uxb` metin sabiti içermemelidir:** `PRINT "merhaba"` gibi bir satır `WAT string linear-memory lowering is not implemented` ile reddedilir (çıkış 23, ✖ G-WASM-8); `PRINT a` gibi yalnız sayı yazdıran bir program sorunsuz derlenir.

| İş | Komut |
|---|---|
| Çalıştır (AST) | `uxb run k.uxb` |
| Çalıştır (MIR) | `uxb run k.uxb --interpreter-backend MIR` |
| Sonsuz döngüyü sınırla | `uxb run k.uxb --max-steps 1000000` (aşılırsa AST'de çıkış kodu 5, `--interpreter-backend MIR` ile 13) |
| AST ve MIR yorumlayıcıyı karşılaştır | `uxb run k.uxb --interpreter-backend BOTH --interpreter-compare-json-out cmp.json` (sonuç `cmp.json` içindeki `status` ve `stdout_match` alanlarındadır; ayrışsa bile çıkış kodu 0 kalır: ✖ G-CLI-26) |
| EXE üret | `uxb bld k.uxb --build-x64 --build-x64-out cikti\k.exe` (EXE adının önünde klasör olmalı; yalın `k.exe` çıkış 14 verir: ✖ G-CLI-21) |
| Eski AST-x64 yolu | `uxb bld k.uxb --build-x64 --build-x64-out cikti\k.exe --x64-mode AST` |
| NASM assembly gör | `uxb x64 k.uxb --emit-x64-nasm --emit-x64-nasm-out k.asm` |
| JavaScript üret | `uxb jsw k.uxb --js-out k.js` ardından `node k.js` |
| Tarayıcı sayfası | `uxb jsw k.uxb --emit-browser --html-out k.html --js-out k.js` |
| WAT metni | `uxb wat k.uxb --emit-wat --wat-out k.wat` |
| WASM ikilisi | `uxb wat k.uxb --emit-wasm --wasm-out k.wasm --wat-out k.wat --wat2wasm=tools\wabt\bin\wat2wasm.exe` |
| Önişlemci sonucunu gör | `uxb lex k.uxb --preprocessed-out k_genisletilmis.uxb` |
| Belirteçleri gör | `uxb lex k.uxb --tokens-json-out tokenler.json` |
| AST'yi gör | `uxb ast k.uxb --ast-json-out ast.json` |
| Sembol ve tip **sayıları** (özet) | `uxb sem k.uxb --symbol-table-json-out s.json --type-table-json-out t.json` (yalnız sayaç yazar; ad ve tip listesi için sonraki tarife bakın, ✖ G-CLI-10) |
| Ad ve tip listesi | `uxb sem k.uxb --out-root klasör` ardından `klasör\<zaman>\logs\adim5_type_table.csv` (ad, tip, durum) ve `adim5_layout_report.csv` (boyut, hizalama) |
| Ara kodu (MIR) gör | `uxb mir k.uxb --semantic --canonical-mir-json-out mir.json` |
| MIR işlem kodları | `uxb mir k.uxb --semantic --mir-opcodes-json-out ops.json` |
| Yerleşik işlev tip kaydı | `uxb sem k.uxb --type-infer-report-csv-out tir.csv` |
| Aşama süreleri | `uxb run k.uxb --time-passes --layer-timing-json-out sure.json` |
| Hataları JSON al | `uxb run k.uxb --diag-format json` (art arda JSON nesneleri verir, tek belge değildir; `INFO` satırlarını da kapatır: ✖ G-CLI-18) |
| Sessiz çalıştır | `uxb run k.uxb --quiet` (yalnız program çıktısı ve hatalar) |
| Çıktıyı dosyaya yönlendir | `uxb run k.uxb --stdout-out cikti.txt` |
| Native görev işçisi sayısı | `uxb bld k.uxb --build-x64 --build-x64-out cikti\k.exe --task-workers 4` |
| Geçici çıktı klasörü | her komuta `--out-root %TEMP%\uxb_deneme` ekleyin |

### 2.7.3 Toplu komut (yanıt) dosyası `.uxcli`

Uzun bir komutu dosyaya yazıp çağırmak için tasarlanmıştır. Dosyada her satır bir argümandır; `#` ile başlayan bölüm yorumdur;
boşluk içeren değerler çift tırnak içine alınır; dosya içinde başka `@dosya` yazılabilir (en çok 8 derinlik).

```
# kargo merkezini AST yorumlayıcı ile çalıştırır
int
docs/uxbasic_5_cilt/examples/projects/kargo_merkezi/main.uxb
--execmem
--interpreter-backend
AST
```

Çağrı biçimi `uxb @komutlar.uxcli`'dir. Çözümleme kodu (`src/cli/cli_response_file.fbs`) yazılıdır; ancak bugünkü derleyicide bu çağrı
`Desteklenmeyen kaynak dosya uzantisi: .uxcli` hatasıyla reddedilmektedir: **✖ SINIR (G-CLI-8)**.

## 2.8 Seçenek listesi (kayıttan, eksiksiz)

Aşağıdaki tablolar derleyicinin kayıt defterindeki **bütün** seçenekleri gösterir. "Kısa kod" derleyicinin içindeki üç harfli takma addır.
*(denetlendi)* yazan satırlar bu kılavuz yazılırken çalıştırılarak sınanmıştır; *(etkisiz)* ve ✖ yazanlar Ek G'de açıklanır.

{{CLI_SECENEKLER}}

## 2.9 Ortam değişkenleri

| Değişken | Kim kullanır? | Ne işe yarar? |
|---|---|---|
| `UXB_TASK_WORKERS` | Native çalışma zamanı | Görev işçisi sayısı; derleme sırasında gömülen `--task-workers` değerinden **önce** gelir. Ölçüm: 8 görev × 300 ms bekleme, gömülü 4 işçiyle ≈ 0,75 sn, `UXB_TASK_WORKERS=1` ile ≈ 1,3 sn, `=8` ile ≈ 0,37 sn; `--task-workers 1` ile derlemek `=1` ile aynı süreyi verir |
| `UXB_ASM`, `UXB_LINK` | `uxb bld` | NASM ve bağlayıcı **programı** (varsayılan `nasm`, `gcc`). Başka bir araç için **tam yol** verin (`UXB_ASM=C:\araclar\nasm\nasm.exe`); bozuk ad ya da yol `build_all.bat failed with exit code 1` ile çıkış 14 verir |
| `UXB_CC`, `UXB_CXX` | `uxb bld` | C ve C++ derleyici adı (varsayılan `gcc`, `g++`); `toolchain.env.bat` içine yazılır, `ffi_resolver.c` ve içe aktarma adımlarında kullanılır |
| `UXB_ASM_PATH`, `UXB_LINK_PATH`, `UXB_CC_PATH`, `UXB_CXX_PATH` | `uxb bld` | Bu araçların klasörü. ✖ Araç adı varsayılan (`nasm`/`gcc`/`g++`) ve `C:\Program Files\CodeBlocks\MinGW\bin` varsa verdiğiniz klasör **sessizce yok sayılır** (G-CLI-12) |
| `UXB_TARGET_ARCH` | `uxb bld` | Betiğe yazılır, ama EXE her zaman x64'tür (✖ G-CLI-13) |
| `UXB_ASM_CMD`, `UXB_LINK_CMD`, `UXB_CC_CMD`, `UXB_CXX_CMD` | üretilen `interop\toolchain.env.bat` | **Sonuç** değişkenleri: betik bunları yukarıdaki değerlerden kendisi kurar. **Dışarıdan vermeyin**: üzerine yazılır, bozuk bir değerle bile derleme başarılı olur (✖ G-CLI-12) |
| `UXB_GXX`, `CXX` | `build_runtime_dll.ps1` | g++ yolu |
| `UXB_MINGW_ROOT` | `build_runtime_dll.ps1` | MSYS2 UCRT64 kök klasörü |
| `UXB_PKG_CONFIG` | `build_runtime_dll.ps1` | libuv/oneTBB bayraklarını bulan araç |
| `UXB_BUILD_X86` | `compiler\scripts\build_uxb_main_64.ps1` | `1` ise 32 bit derleyici eşliği de üretilir. Kökteki `build_64.ps1` bu değişkeni **yok sayar** (✖ G-CLI-15) |

## 2.10 Komut satırında bilinen sınırlar

Aşağıdaki kayıtların tamamı bu kılavuz yazılırken **çalıştırılarak** bulunmuştur. "Sessiz" olanlar, derleyicinin ilkesine (hata sessiz geçmez) aykırı olduğu için düzeltme sırasında önceliklidir.

{{SINIRLAR:CLI}}

## 2.11 Derleme ve komut satırıyla ilgili programlama kararları

* **Derleyiciyi `.\build_64.ps1 -Force` ile derleyin; ama bu betik her zaman `bin\uxb.exe` dosyasının yerine yenisini koyar** (eskisini `.pre_library_patch.bak` olarak yedekler). Çalışan derleyiciyi korumak için değişiklik denerken 2.3.3'teki elle komutla yeni bir adla derleyin (`-x bin\uxb_deneme.exe`) ve eski sürümle yan yana karşılaştırın.
* Derleme betiğinin mimari denetimini **atlamayın**: üretilen dosya x64 değilse betik `Compiler host mimarisi yanlis` hatasıyla durur (kapalı başarısızlık).
* **`uxb_runtime.dll` ve bağımlı DLL'leri bir uXBasic EXE'sinin yanında bulunmalıdır;** `uxb bld` bunları kendisi kopyalar (2.5). Çalışma zamanı kaynağını değiştirince önce `build_runtime_dll.ps1 -OutputDirectory <geçici klasör> -SkipPublish` ile **yalıtılmış** derleyip deneyin; beğenirseniz `-SkipPublish` olmadan çalıştırın (DLL `bin\` ve `dist\` klasörlerine yayımlanır, her `bld` bunu EXE'nin yanına koyar).
* Değişiklikten sonra `tests\run_all_model_tests.ps1` ile **bütün paketleri** koşturun; yalnız ilgili paketler için `-Only` verin. Raporu kendi adınıza yazın (`-ReportPath .\test_results\denemem.md`, **göreli** yol) ki varsayılan rapor ezilmesin (G-CLI-14). `CALISMADI` görünen paket başarılı sayılmaz. Reddetme testinin geçmesi özelliğin çalıştığını kanıtlamaz: gerçek AST, MIR, x64, JS ve WASM yürütmesini ayrıca doğrulayın.
* **Fiili işe göre seçin** (2.7.1): çalıştırmak → `run`; EXE → `bld`; aşamaları incelemek → `lex`, `ast`, `sem`, `mir --semantic`, `x64`; web → `jsw` ya da `wat`.
* Her komuta **`--out-root` ile geçici klasör** verin (2.7.2); proje klasörü şişmez. Sonsuz döngü ihtimali olan denemede `--max-steps` verin ve betiklerde çıkış kodunu denetleyin.
* Hataları makineyle okumak için `--diag-format json` kullanın, ama nesneleri tek tek okuyun (art arda gelirler, G-CLI-18) ve `E.xxxx` koduna değil **çıkış koduna ve ileti metnine** dayanın (G-HATA-10); yalnız program çıktısı için `--quiet`, çıktıyı dosyaya almak için `--stdout-out` kullanın. `--diag-format` değerini kendiniz denetleyin (yalnız `text` ya da `json`; yanlış yazım sessizce metin kipine düşer, G-CLI-19).
* **Çalışmayan fiil ve seçeneklere dayanan betik yazmayın**: `chk`, `fmt`, `map`, `doc`, `rel` fiilleri (G-CLI-2, G-CLI-3), `.uxcli` yanıt dosyası (G-CLI-8) ve `--stop-after` (G-CLI-5) bugün çalışmaz ya da etkisizdir.
* Eski AST-x64 yolunu (`--x64-mode AST`) yalnız karşılaştırma ve geriye dönük uyumluluk için kullanın; görev gibi yeni özellikleri bugün açıkça reddeder (ara durum, korunan yol).
* Native görev işçisi sayısını `--task-workers N` ya da `UXB_TASK_WORKERS` ile ayarlayın (ortam değişkeni önceliklidir). NASM ve bağlayıcıyı `UXB_ASM` ve `UXB_LINK` değişkenlerine **tam yol** vererek belirtin; `UXB_ASM_CMD` ve `UXB_LINK_CMD` betiğin sonuç değişkenleridir, dışarıdan verilen değer üzerine yazılır (G-CLI-12).
