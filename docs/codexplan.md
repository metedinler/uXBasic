SENİN GÖREVİN: uXBasic test-onarım mühendisi gibi çalış. Rastgele büyük değişiklik yapma. Önce ortam araçlarını öğren, sonra test runner hatalarını temizle, sonra gerçek compiler hatalarını küçük yamalarla düzelt. Her adımı raporla. Token ve zaman tasarrufu için aynı işi tekrar tekrar yapma.

PROJE KÖKÜ:
UXBc_Clean\UXBc\uxb

ANA HEDEF:
uXBasic içindeki .bas, .uxb, .uxbh testlerini doğru sınıflandıran, her katmanda doğru çıktı dosyalarını kontrol eden, gerçek compiler hatası ile test-runner/harness hatasını ayıran verimli test-onarım döngüsü kur. Ben sonuçları zipleyip inceleteceğim; sen rapor üret, küçük yamalar yap, her yama sonrası hedefli test çalıştır.

ÖNEMLİ KURAL:

1. Önce araç envanteri çıkar.
2. Sonra test runner keşif/faz/negatif beklenti hatalarını düzelt.
3. Sonra compiler gerçek hatalarına geç.
4. Her patch küçük olsun.
5. Her patchten sonra sadece ilgili odak testlerini çalıştır.
6. Full test suite sadece tur sonunda çalışsın.
7. Her komutun çıktısını reports\copilot_round\ altına yaz.
8. Başarılı görünen testin gerçekten hangi katmana kadar başarılı olduğunu belirt.
9. Negatif testlerde AST’nin geçmesi bazen normaldir; her negatif test her katmanda fail beklemez.
10. .uxbh header dosyalarını standalone program gibi çalıştırma.

AŞAMA 0 — ARAÇ ENVANTERİ ÇIKAR

PowerShell 7 kullan. Önce şu klasörde olduğunu doğrula:

```powershell
pwd
eza -la
```

Sonra terminalde kullanılabilir araçları raporla:

```powershell
New-Item -ItemType Directory -Force reports\copilot_env | Out-Null

$cmds = @(
  "pwsh","powershell","cmd",
  "git","gh",
  "python","py","uv","ruff","pytest",
  "rg","fd","fzf","eza","bat","grep","findstr","Select-String",
  "jq","7z","tar",
  "fbc","gcc","g++","clang","clang++","make","cmake","ninja",
  "node","npm","deno",
  "ollama","codex","claude","openviking","mimo","grok"
)

$found = foreach($c in $cmds){
  $g = Get-Command $c -ErrorAction SilentlyContinue
  if($g){
    [PSCustomObject]@{
      name=$c
      source=$g.Source
      version=$null
    }
  }
}

$found | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 reports\copilot_env\tools_found.json
$found | Format-Table -Auto | Out-String | Set-Content -Encoding UTF8 reports\copilot_env\tools_found.txt

python --version 2>&1 | Tee-Object reports\copilot_env\python_version.txt
py -0p 2>&1 | Tee-Object reports\copilot_env\python_installations.txt
git --version 2>&1 | Tee-Object reports\copilot_env\git_version.txt
rg --version 2>&1 | Tee-Object reports\copilot_env\rg_version.txt
fd --version 2>&1 | Tee-Object reports\copilot_env\fd_version.txt
fbc -version 2>&1 | Tee-Object reports\copilot_env\fbc_version.txt
g++ --version 2>&1 | Tee-Object reports\copilot_env\gxx_version.txt
node --version 2>&1 | Tee-Object reports\copilot_env\node_version.txt
```

Eğer `rg`, `fd`, `eza`, `bat` varsa bunları kullan:

* Dosya aramak için `fd`
* İçerik aramak için `rg`
* Klasör görmek için `eza`
* Dosya okumak için `bat`
* JSON/CSV hızlı özet için Python

Araç envanterinden sonra `reports\copilot_env\ENV_OK.md` yaz. İçinde şu başlıklar olsun:

* PowerShell sürümü
* Python sürümü
* FreeBasic/fbc var mı
* MinGW g++ var mı
* rg/fd/eza/bat var mı
* Node var mı
* Hangi testleri hızlı koşabileceğin

AŞAMA 1 — MEVCUT DURUMU BOZMADAN SNAPSHOT AL

```powershell
New-Item -ItemType Directory -Force reports\copilot_round | Out-Null

git status --short | Tee-Object reports\copilot_round\git_status_before.txt
git diff --stat | Tee-Object reports\copilot_round\git_diff_stat_before.txt

eza -la | Tee-Object reports\copilot_round\root_listing.txt
fd -e bas -e uxb -e uxbh . tests examples | Sort-Object | Set-Content -Encoding UTF8 reports\copilot_round\source_test_files.txt
```

Eğer git repo değilse sorun etme; rapora “git yok veya repo değil” yaz.

AŞAMA 2 — TEST RUNNER’I DÜZELT: ÖNCE SAHTE FAIL SAYISINI AZALT

Önce test runner dosyalarını bul:

```powershell
rg -n "run_all_source_tests|discover|PASS_NEGATIVE|Negatif test hata vermeliydi|negative|uxbh|harness|enum_tests|differential_report" .
```

Bulduğun runner dosyalarını raporla:
`reports\copilot_round\runner_files.md`

DÜZELTME 2.1 — .uxbh DOSYALARINI STANDALONE TESTTEN ÇIKAR

Kural:

* `.uxbh` dosyası header/include dosyasıdır.
* Tek başına ast/sem/int programı gibi çalıştırılmayacak.
* Sadece onu include eden `.uxb` veya `.bas` testleri üzerinden test edilecek.
* Runner sonuçlarında SKIP_HEADER olarak yazılabilir ama FAIL sayılmayacak.

Uygula:

* Test keşif filtresinde `.uxbh` dosyalarını default çalıştırma listesinden çıkar.
* Eğer özel `--include-headers` bayrağı yoksa `.uxbh` test edilmesin.
* Rapor CSV’ye `SKIP_HEADER` durumu ekle.

DÜZELTME 2.2 — `tests\enum_tests` DUPLICATE ÇALIŞMASINI KES

Kural:

* `tests\enum_tests` ana testlerin kopyasıysa default full suite içinde tekrar koşulmayacak.
* Ayrı istenirse `--include-enum-tests` bayrağı ile koşulacak.
* Default `--paths tests,examples --mode full` içinde enum_tests hariç olmalı.

Uygula:

* Runner keşfinde `tests\enum_tests\` dışlansın.
* Rapor CSV’ye `SKIP_DUP_ENUM` yazılabilir ama FAIL sayılmasın.

DÜZELTME 2.3 — HARNESS DOSYALARINI NORMAL KAYNAK GİBİ KOŞMA

Kural:
Aşağıdaki dosyalar default kaynak testi değildir:

* Yolunda `harness` geçenler
* Dosya adında `manual_probe`
* Dosya adında `common_harness`
* Dosya adında `probe` olup özel harness gerektirenler
* İçeriğinde “harness gibi görünüyor” tespiti yapılanlar

Bunlar için:

* `SKIP_HARNESS` üret.
* FAIL sayma.
* Ayrı harness runner varsa oraya yönlendir.

DÜZELTME 2.4 — NEGATİF TESTLERDE FAZ BİLGİSİ EKLE

Mevcut hata:
Runner `negative=True` görünce ast/sem/int hepsinde fail bekliyor. Bu yanlış.

Yeni kural:
Her negatif testin beklenen fazı olmalı:

* syntax / lexer / parser negatifleri: AST dahil erken fail beklenir.
* semantic negatifleri: AST geçebilir, SEM fail beklenir.
* runtime negatifleri: AST ve SEM geçebilir, INT fail beklenir.
* target negatifleri: AST/SEM/INT geçebilir; sadece JS/WASM/X64 hedefinde fail beklenir.
* preprocessor negatifleri: preprocess/lexer aşamasında fail beklenir.

Dosya adından geçici sınıflandırma yap:

* `bad_syntax`, `missing_end`, `bad_string`, `bad_operator`: expected_phase = ast
* `unknown_symbol`, `type_mismatch`, `bad_assign_type`, `slot_range`, `unknown_event`, `biginit_unknown_kind`, `function_not_lvalue`: expected_phase = sem
* `native_only_on_js`, `call_dll_js_target`, `native_dll_on_js`: expected_phase = js_or_wasm_target
* `include_cycle`, `unknown_directive`, `assert_fail`, `import_wrong_form`: expected_phase = preprocessor
* `memory_bounds`, `poke_bad_addr`, `print_file_without_open`: expected_phase = runtime_or_sem, test içeriğine göre karar ver

Runner sonucu böyle sınıflansın:

* expected_phase=sem ve AST geçerse: FAIL değil, `PASS_EXPECTED_AST_OK`
* expected_phase=sem ve SEM hata verirse: `PASS_NEGATIVE`
* expected_phase=target ve AST/SEM/INT geçerse: FAIL değil, `PASS_EXPECTED_HOST_OK`
* expected_phase=target için JS/WASM/X64 hedefi ayrıca çalıştırılmalı.
* Gerçekten hata vermesi gereken fazda geçerse: `FAIL_NEGATIVE_ESCAPED`

CSV’ye şu kolonları ekle:

* source
* mode
* status
* returncode
* negative
* expected_phase
* actual_phase
* classification
* log
* artifact_dir
* reason

AŞAMA 3 — DERİN ANALİZ ARACINI RUNNER RAPORUNA UYUMLU YAP

Mevcut sorun:
`run_uxb_derin_analiz` `reports\differential_report.json` arıyor ama `run_all_source_tests` başka rapor formatı üretiyor. Bu yüzden 3970 çalışmayı “Runner raporu yok” sayıyor.

Düzelt:

* `run_uxb_derin_analiz` hem eski `differential_report.json` hem de yeni runner CSV/JSON formatını okuyabilsin.
* Eğer differential_report yoksa:

  * `build\source_tests\summary.csv`
  * `build\source_tests\summary.json`
  * ilgili run klasörlerindeki `run.log`
    dosyalarını okusun.
* “RAPOR_YOK” sadece gerçekten hiçbir log yoksa yazılsın.

Çıktılar:

* `reports\uxbrarp\UXBc_calismalari_derin_analiz_raporu.md`
* `reports\uxbrarp\test_ozeti.csv`
* `reports\uxbrarp\hata_siniflama.csv`
* `reports\uxbrarp\runner_format_detected.txt`

AŞAMA 4 — CLOSE-GATE DİZİN YAZMA HATASINI DÜZELT

Hata:
Backend close-gate aşamalarında `close_gates` klasörüne CSV/JSON yazılırken parent dizin oluşturulmadığı için x64/js/wat/browser adımları düşüyor.

Ara:

```powershell
rg -n "close_gates|Open .* For Output|ADIM25|ADIM26|ADIM27|cannot write file|coverage_gate|backend_route_close" src compiler
```

Kontrol edilecek muhtemel dosyalar:

* `src\main_program_entry.fbs`
* `src\semantic\ast_mir_coverage_gate_adim25.fbs`
* `src\codegen\js\js_mir_opcode_coverage_adim26.fbs`
* `src\cli\cli_backend_route_close_adim27.fbs`

Düzeltme ilkesi:

* Her dosya yazmadan önce parent directory oluştur.
* Tekrarlı kod yazma; mümkünse ortak `EnsureParentDir(filePath)` veya mevcut helper varsa onu kullan.
* Windows path separator ve `/` karışımını destekle.
* Dizin varsa hata verme.
* Hata mesajına tam dosya yolunu yaz.

Odak test:

```powershell
.\run_adim36_full_surface_tests.bat
```

Ama full suite uzun sürerse önce sadece backend/close gate testlerini koş:

* x64 backend
* js backend
* wat backend
* browser artifact testleri

Sonuçları:
`reports\copilot_round\close_gate_fix_result.md`

AŞAMA 5 — INCLUDE / PREPROCESSOR GÖRÜNÜRLÜĞÜNÜ DÜZELT

Hatalı pozitifler:

* `tests\adim36_full_surface\positive\13_include_header_math.uxb`
* `tests\adim36_full_surface\positive\14_include_nested.uxb`
* `tests\adim36_full_surface\positive\62_plain_include_visibility.uxb`

Beklenen:

* Include edilen `.uxbh` içindeki CONST/FUNCTION/TYPE/DECLARE sembolleri ana dosyada semantik aşamada görünmeli.
* Nested include çalışmalı.
* Plain `INCLUDE "file.uxbh"` ile preprocessor include aynı cycle detection ve symbol visibility yolunu kullanmalı.

Ara:

```powershell
rg -n "INCLUDE|include_stack|cycle|HEADER_CONST|NESTED_VALUE|plain INCLUDE|uxbh|preprocess" src compiler tests
```

Düzeltme ilkesi:

* `%%INCLUDE` ve plain `INCLUDE` iki ayrı gerçeklik yaratmasın.
* Include edilen dosyalar preprocess sonrası ana kaynak içine veya semantic include symbol table’a deterministik şekilde eklensin.
* Cycle detection dosya canonical path ile yapılsın.
* Include path current source directory + project root + tests include directory mantığını desteklesin.
* Plain include cycle negatif testi hata vermeli:

  * `tests\adim36_full_surface\negative\95_include_cycle_a.uxb`

Odak test komutları:

```powershell
python .\tools\control\adim36_full_surface_runner_FIXED.py --only 13,14,62,68,95
```

Eğer bu runner bayrağı yoksa runner’a `--only` veya `--filter` desteği ekle. Yoksa geçici olarak şu dosyaları tek tek çalıştıran mini runner yaz:
`tools\control\run_focus_include_tests.py`

Çıktılar:

* `reports\copilot_round\include_focus_results.csv`
* `reports\copilot_round\include_diagnostics.md`

AŞAMA 6 — EVENT / SLOT / TRIGGER CASE-NORMALIZATION DÜZELT

Hatalı pozitif:

* `tests\adim36_full_surface\positive\23_on_off_trigger_slot.bas`
* `tests\adim32b_strict\positive\04_event_slot_strict_pos.bas`
* `tests\adim30_10step\positive\03_event_pipe_memory.bas`

Beklenen:

* `ON EVENT OnTick ...`
* `OFF EVENT OnTick`
* `TRIGGER EVENT OnTick`
  aynı canonical event adına bağlanmalı.
* `OnTick`, `ONTICK`, `ontick` aynı kabul edilmeli.
* Ama bilinmeyen event gerçekten hata vermeli:

  * `unknown_event_trigger`
  * `event_slot_unknown_neg`
* Slot range negatifleri semantik aşamada fail vermeli.

Ara:

```powershell
rg -n "ON EVENT|OFF EVENT|TRIGGER EVENT|slot|event|task_trigger|canonical|lower|ucase|lcase" src compiler native tests
```

Düzeltme ilkesi:

* Event adı kayıt ve lookup aşamasında aynı normalize fonksiyondan geçsin.
* Orijinal casing diagnostikte korunabilir ama lookup canonical olsun.
* Unknown event gerçek semantik hata versin.
* Range kontrolü semantik aşamada yapılsın.

Odak test:

```powershell
python .\tools\control\run_focus_event_tests.py
```

Eğer yoksa oluştur. Test listesi:

* `tests\adim36_full_surface\positive\22_event_thread_pipe_slot.bas`
* `tests\adim36_full_surface\positive\23_on_off_trigger_slot.bas`
* `tests\adim36_full_surface\negative\96_slot_range_neg.bas`
* `tests\adim36_full_surface\negative\97_unknown_event_trigger.bas`
* `tests\adim32b_strict\positive\04_event_slot_strict_pos.bas`
* `tests\adim32b_strict\negative\05_event_slot_unknown_neg.bas`
* `tests\adim32b_strict\negative\06_event_slot_range_neg.bas`

AŞAMA 7 — MIR INTERPRETER LABEL VE FLOW HATALARINI DÜZELT

Hatalı pozitifler:

* `04_branch_if_select`
* `05_loops_for_while_do`
* `adim11_if_branch`
* `01_core_flow`
* `48_bit_ops`
* matrix flow testleri

Hata tipi:

* `Return code 13`
* Muhtemelen MIR interpreter label not found / branch target mapping / jump table hatası.

Ara:

```powershell
rg -n "MIR label not found|label|goto|branch|jump|select|while|for|exitif|MIR_INTERPRETER|interp_mir|loop" src compiler reports build
```

Düzeltme ilkesi:

* MIR üretiminde label id oluşturma ve interpreter lookup aynı tabloyu kullanmalı.
* Label define edilmeden jump target üretme.
* SELECT/CASE, IF/ELSE, WHILE, DO, FOR, EXITIF için label map doğrulaması ekle.
* MIR verify aşamasında missing label erken yakalansın.
* Interpreter crash yerine diagnostic versin.

Odak test dosyaları:

* `tests\adim36_full_surface\positive\04_branch_if_select.bas`
* `tests\adim36_full_surface\positive\05_loops_for_while_do.bas`
* `tests\adim11\positive\adim11_if_branch.bas`
* `tests\adim30_10step\positive\01_core_flow.bas`
* `tests\basicCodeTests\21_matrix_flow_if_select_exitif__dup1.bas`

Çıktı:

* MIR JSON
* MIR verify raporu
* interpreter stdout/stderr
* label table dump

Rapor:
`reports\copilot_round\mir_label_fix.md`

AŞAMA 8 — ARRAY INDEX LVALUE / STORE HATALARINI DÜZELT

Hatalı pozitifler:

* `tests\adim36_full_surface\positive\06_arrays_basic.bas`
* `tests\adim36_full_surface\positive\57_array_index_lvalue.bas`
* `tests\adim36_full_surface\positive\64_array_index_lvalue_adim42.bas`
* `tests\adim36_full_surface\positive\73_adim44_array_lvalue.bas`

Hata tipi:

* AST ve SEM geçiyor, INT düşüyor.
* Muhtemel hata: `array index cannot be written`
* Array element assignment read-only expression gibi işleniyor.

Ara:

```powershell
rg -n "array index cannot be written|lvalue|array.*store|STORE|LOAD|index|DIM|REDIM|array element" src compiler tests
```

Düzeltme ilkesi:

* `a(i) = value` assignment left-hand side olarak kabul edilmeli.
* Parser AST’de array access node read/write bağlamını ayırmalı.
* Semantic lvalue kontrolü array element için geçerli saymalı.
* MIR lower array store opcode üretmeli.
* Interpreter array store opcode’u uygulamalı.
* Function call result lvalue olmasın; şu negatifler semantik aşamada fail vermeye devam etmeli:

  * `115_call_expr_function_not_lvalue.bas`
  * `118_adim44_function_call_not_lvalue.bas`

Odak test:

* 06, 57, 64, 73 pozitif array testleri
* 115 ve 118 negatif lvalue testleri

Rapor:
`reports\copilot_round\array_lvalue_fix.md`

AŞAMA 9 — UNKNOWN LABEL SEMANTIC HATASINI DÜZELT

Hatalı negatif:

* `tests\adim11\negative\adim11_unknown_label.bas`

Beklenen:

* GOTO/GOSUB/label kullanan kaynakta bilinmeyen label varsa semantic veya MIR verify aşamasında hata vermeli.
* AST geçebilir, ama SEM veya MIR verify fail olmalı.

Ara:

```powershell
rg -n "GOTO|GOSUB|LABEL|unknown label|label table|symbol.*label" src compiler tests
```

Düzeltme ilkesi:

* Label declarations topla.
* GOTO/GOSUB target referanslarını topla.
* Semantic sonunda unresolved label varsa hata ver.
* MIR verify de ikinci güvenlik ağı olarak unresolved label yakalasın.

Odak test:

* `tests\adim11\negative\adim11_unknown_label.bas`
* pozitif branch/goto varsa onları da çalıştır.

Rapor:
`reports\copilot_round\unknown_label_fix.md`

AŞAMA 10 — STRUCT / POINTER / IMPORT TYPE HATASINI DÜZELT

Hatalı pozitif:

* `tests\adim36_full_surface\positive\49_struct_pointer_import_mix.uxb`

Hata:

* `TYPE_OBJECT` → `TYPE_I32` explicit cast istiyor olabilir.
* Pointer/int/struct field adresleme karışmış.

Ara:

```powershell
rg -n "TYPE_OBJECT|TYPE_I32|PTR|POINTER|VARPTR|STRPTR|SADD|BYVAL|BYREF|IMPORT|struct|TYPE " src compiler tests
```

Düzeltme ilkesi:

* Pointer tipi, object tipi ve numeric I32 birbirine kör cast edilmemeli.
* VARPTR/SADD/STRPTR sonucu pointer/integer ABI tipleri net olmalı.
* CALL DLL/API BYVAL/BYREF için ABI type lowering doğru olmalı.
* Pozitif testte beklenen davranış neyse test içeriğine bakarak düzelt.

Rapor:
`reports\copilot_round\struct_pointer_import_fix.md`

AŞAMA 11 — SURFACE TEST MATRİSİ OLUŞTUR

uXBasic yüzeyini şu gruplar halinde test eden bir envanter çıkar. Yeni test yazmadan önce mevcut testleri bu gruplara bağla.

Gruplar:

1. Preprocessor:

* `%%DEFINE`, `%%IF`, `%%IFN`, `%%ELIF`, `%%ELSE`, `%%ENDIF`
* `%%FOR`, `%%FOREACH`, `%%INCLUDE`, plain `INCLUDE`
* alias, set/eval, raw js gate, asset manifest

2. Include/import/module:

* `.uxbh`
* nested include
* include cycle
* `IMPORT(C,"file.c")`
* `IMPORT(CPP,"file.cpp")`
* `IMPORT(ASM,"file.asm")`
* `MODULE`, `NAMESPACE`, `USING`, `ALIAS`

3. Değişken/veri tipi:

* `I8/I16/I32/I64`
* `U8/U16/U32/U64`
* `F32/F64/F80`
* `STRING`
* `PTR`
* `BIGI/BIGINT/BIGF/BIGD/BALL`
* TYPE/record
* class/object

4. Operatörler:

* aritmetik `+ - * / \ MOD`
* karşılaştırma `== <> != < <= > >=`
* atama `=`
* mantıksal `AND OR NOT XOR`
* bit ops `SHL SHR ROL ROR BAND BOR BXOR`
* öncelik/parantez
* unary/binary ayrımı

5. Kontrol akışı:

* IF/ELSEIF/ELSE/END IF
* SELECT/CASE
* FOR/NEXT
* WHILE/WEND
* DO/LOOP
* EXITIF
* GOTO/GOSUB/label
* recursion

6. Fonksiyon/sub/metot:

* FUNCTION/END FUNCTION
* SUB/END SUB
* RETURN
* parametreler
* BYVAL/BYREF
* nested call
* method chain
* recursion

7. OOP:

* CLASS/END CLASS
* FIELD
* METHOD
* CONSTRUCTOR/DESTRUCTOR
* INTERFACE
* VIRTUAL/OVERRIDE
* THIS/ME
* MAGIC method

8. Koleksiyonlar:

* ARRAY/DIM/REDIM
* LIST
* DICT/MAP
* SET
* array lvalue store/load

9. Dosya/string:

* OPEN/CLOSE
* PRINT #, INPUT #
* GET/PUT/SEEK
* string builtinleri: LEFT/MID/RIGHT/LEN/TRIM/UCASE/LCASE/INSTR vb.

10. Bellek:

* PEEK/POKE
* VARPTR
* STRPTR/SADD
* SIZEOF/OFFSETOF
* pointer dereference varsa

11. Runtime/event/thread:

* TASK
* SLOT
* TRIGGER
* ON/OFF EVENT
* THREAD
* PIPE
* shell/exec varsa

12. FFI/DLL/API:

* DECLARE LIB ALIAS
* CALL DLL
* CALL API
* WINAPI örnekleri
* BYVAL/BYREF ABI
* native-only target guard

13. Browser/JS/WASM:

* JS output
* WAT output
* WASM host import
* raw js gate
* canvas/webgpu yüzeyleri
* native dll fail-close

14. Backend:

* AST JSON
* SEM diagnostics
* MIR JSON
* MIR verify
* AST interpreter
* MIR interpreter
* x64 backend
* JS backend
* WAT backend

Bunlar için şu raporu üret:
`reports\copilot_round\surface_matrix.md`

Kolonlar:

* Grup
* Komut/fonksiyon/operator/tip
* Mevcut test dosyası
* AST sonucu
* SEM sonucu
* MIR sonucu
* INT sonucu
* Backend sonucu
* Eksik test var mı
* Gerçek başarı mı, yüzey başarı mı

AŞAMA 12 — HER TUR SONU RAPOR PAKETLE

Her tur sonunda şu komutları çalıştır:

```powershell
New-Item -ItemType Directory -Force reports\copilot_round\final | Out-Null

git status --short | Tee-Object reports\copilot_round\final\git_status_after.txt
git diff --stat | Tee-Object reports\copilot_round\final\git_diff_stat_after.txt
git diff | Set-Content -Encoding UTF8 reports\copilot_round\final\patch.diff

.\run_all_source_tests.bat --paths tests,examples --mode full 2>&1 | Tee-Object reports\copilot_round\final\run_all_source_tests.log

.\run_adim36_full_surface_tests.bat 2>&1 | Tee-Object reports\copilot_round\final\run_adim36_full_surface_tests.log

.\run_uxb_derin_analiz.bat -r build\source_tests\runs -o reports\uxbrarp 2>&1 | Tee-Object reports\copilot_round\final\run_uxb_derin_analiz.log
```

Eğer full suite çok uzun sürerse önce odak testleri çalıştır, ama tur sonunda en az bir kez full suite çalıştır.

Sonra şu özet dosyasını yaz:
`reports\copilot_round\final\COPILOT_TUR_OZETI.md`

İçinde mutlaka olsun:

1. Hangi dosyalar değişti?
2. Hangi sorun düzeltildi?
3. Hangi testler önce fail sonra pass oldu?
4. Hangi testler hâlâ fail?
5. Hangi fail test-runner kaynaklı?
6. Hangi fail gerçek compiler hatası?
7. Yeni hata oluştu mu?
8. Bir sonraki patch önerisi ne?
9. Benim incelemem için hangi klasörleri zipleyeyim?

ZIPLENECEK KLASÖRLER:

* `reports\copilot_env`
* `reports\copilot_round`
* `reports\control\current`
* `reports\uxbrarp`
* `build\source_tests`
* değişen kaynak dosyaları
* değişen test dosyaları
* değişen runner scriptleri

SAKIN YAPMA:

* Dist klasörünü değiştirme.
* Büyük refactor yapma.
* Testleri susturup PASS gösterme.
* Gerçek compiler hatasını SKIP yapma.
* Her şeyi full suite ile tekrar tekrar koşma.
* Aynı aramayı 5 kere yapma.
* `.uxbh` dosyalarını program gibi çalıştırma.
* JS/WASM hedef negatiflerini AST/SEM/INT fail bekleyerek değerlendirme.
* Harness dosyasını normal kullanıcı programı gibi test etme.

ÖNCELİK SIRASI:

1. Araç envanteri
2. Runner filtreleri: `.uxbh`, `enum_tests`, harness skip
3. Negatif expected_phase düzeltmesi
4. Derin analiz rapor okuyucu düzeltmesi
5. close_gates dizin yazma fix
6. include visibility + include cycle fix
7. event/slot canonicalization fix
8. MIR label fix
9. array lvalue fix
10. unknown label fix
11. struct/pointer/import type fix
12. surface matrix raporu

ÇALIŞMA ŞEKLİ:
Her aşamada önce `rg/fd` ile ilgili kodu bul, sonra en küçük patchi uygula, sonra odak testi çalıştır, sonra rapor yaz. Bana yorum değil, kanıt dosyası üret.
