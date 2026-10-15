# uXBasic mimari haritası (yön bulma — sembol aramadan ÖNCE oku)

Güncelleme: 2026-09-27 (Claude 1). Satır numaraları kayar: adı `rutinler.tsv`'den ya da Grep ile doğrula.
Dil: FreeBASIC (`.fbs`, derleyici tek dosya olarak `compiler\wrappers\uxb_main_wrapper.bas` üzerinden `#include` ile birleşir).

## 1. Derleme hattı (bir program nereden geçer)
```
kaynak .uxb/.bas
 └─ preprocessor (src/preprocessor)         INCLUDE / #define
 └─ lexer   (src/parser/lexer)              anahtar sözcükler: lexer_keyword_table.fbs
 └─ parser  (src/parser/parser)             ParseProgram  parser_stmt_dispatch.fbs
      ├─ deyim ayrıştırma: parser_stmt_registry.fbs (atama/indeksli atama/ifade deyimi), parser_stmt_decl_*.fbs
      └─ ayrıştırma sonrası: NormalizeNamespaceVariables (parser_namespace_vars.fbs, S-162) → BuildTypeLayoutTable
 └─ semantik (src/semantic, src/type_binding)
      ├─ step3 kapısı: semantic_step3_gate.fbs (atama/tip/yazılabilirlik), tip çıkarımı: type_binding/type_infer_expr.fbs
      └─ görev/eşzamanlılık analizi (Model D): semantic_task_isolation.fbs (UXBTaskEnsureSyncAnalysis, senkron kümesi)
 ├─ MOTOR 1 — AST yorumlayıcısı (`uxb run`)        src/runtime/memory_exec.fbs  ExecRunStmt / ExecEvalNode
 └─ MIR (src/semantic/mir*.fbs)  MIRBuildModuleFromAST  mir_tail.fbs
      ├─ indirgeme: mir_lower_stmt.fbs (MIRLowerTopLevelStmt), mir_lower_stmt_core_split.fbs (DIM/RETURN/TRY), mir_lower_expr.fbs
      ├─ geçişler (sırayla): mir_sync_pass.fbs (otomatik kilit) → mir_exc_pass.fbs (istisna, S-160)
      ├─ MOTOR 2 — MIR yorumlayıcısı (`uxb run --interpreter-backend MIR`)
      │     köprü semantic_to_canonical_mir_bridge.fbs → src/interpreter/mir/mir_interp.fbs (+ _dispatch, _task, _call)
      ├─ MOTOR 3 — native x64 (`uxb bld`, varsayılan)  src/codegen/x64/mir_x64_*.fbs  MIRX64EmitModule (mir_x64_codegen.fbs)
      │     çalışma zamanı DLL: native/uxb_runtime/*.cpp (build_runtime_dll.ps1 → bin/uxb_runtime.dll)
      ├─ JS: src/codegen/js (UXBJsEmitFromMIR)     WASM/WAT: src/codegen/wasm
 └─ MOTOR 4 — legacy AST-x64 (`uxb bld --x64-mode AST`)  src/codegen/x64/code_generator.fbs  GenerateX64Code
      Desteklemediğini AÇIK TANI ile reddeder ("legacy AST-x64: ... desteklenmiyor"), sessiz yanlış sonuç yok.
```

## 2. Motor farkları (hata ararken buna bak)
- **AST yorumlayıcı:** değişkenler düz tablo `es.vars` (exec_state_value_utils.fbs `ExecFindVar`), her çağrıda anlık
  görüntü + geri yükleme (exec_call_dispatch_helpers.fbs `ExecInvokeRoutineByIndexOffset`). BYREF = yuva takma adı
  (`ExecVar.refIdxPlus1`, S-167).
- **MIR yorumlayıcı:** MIR ada dayalıdır; değişkenler kalıcı adresli hücreler (`st.vars(i)->`), kapsam derinliği ile.
  BYREF = `aliasOf` hücresi. Rutin yerelleri girişte `MIR_LOCAL_DECL` ile kurulur (S-168).
- **Native x64:** yuva çözümü `MIRX64FindGlobalSlot` (mir_x64_context.fbs) — rutin parametresi/yereli globali gölgeler.
  Görevler/kilitler/RND: native/uxb_runtime/uxb_runtime_task_v2.cpp, uxb_runtime_sync.cpp.
- Aynı programın motorlar arası farkı = hata. Karşılaştırma: `tools\claude\uxb_run3.ps1`.

## 3. Yeni dil özelliği / düzeltme hangi dosyalara dokunur (kontrol listesi)
1. lexer anahtar sözcüğü (gerekirse) → parser deyimi → AST düğüm türü
2. semantik kapı + tip çıkarımı (+ Model D analizi görevleri etkiliyorsa)
3. AST yorumlayıcı: memory_exec.fbs / src/runtime/exec/*.fbs
4. MIR indirgeme + (gerekirse) mir_sync_pass / mir_exc_pass
5. MIR yorumlayıcı: src/interpreter/mir/*.fbs
6. native: mir_x64_*.fbs + (gerekirse) native/uxb_runtime/*.cpp → DLL yeniden derle
7. legacy: code_generator.fbs — destek ya da açık ret
8. test: tests/<paket>/ + expected/ (+ `_engines.txt`), tests/run_all_model_tests.ps1'e kayıt
9. kayıt: ai_koordinasyon/SORUN_TAKIP.md (S-xxx)

## 4. Kütüphane sarmalayıcıları
- uXBasic yüzü: `libsx/<kütüphane>/*.bas` (+ `include/modules/*.uxmh` ileten başlık)
- C adaptörü: `runtime_ext/<kütüphane>/*_adapter.c` (+ `.inc`) → `build_wrappers.bat` → DLL (`bin/` ve `dist/libraries/bin/`)
- Üreticiler: `tools/library_tools/gen_*.py` (üretilmiş dosyayı elle değil üreticiyle düzelt; elle düzeltme gerekiyorsa ikisini birden)
- Parametre adı uXBasic ayrılmış sözcüğü olamaz (SLOT, START, END, ...).

## 5. Testler
- Tüm paketler: `tests\run_all_model_tests.ps1` (≈1 saat) → `tools\claude\uxb_regression.ps1` ile koş.
- Paket koşucusu çoğunlukla `tests\task_model\run_task_model_tests.ps1 -TestRoot <paket>` (AST/MIR/x64/AST-x64).
- Beklenen: `expected/<ad>.txt`; hata metni `expected/<ad>.contains.txt` (`ALL=` ya da `MOTOR=`); motor süzgeci
  `expected/_engines.txt` ve teste özel `expected/<ad>.engines.txt`.

## 6. Derleyici ikilileri ve eşzamanlı çalışma
- `bin\uxb.exe` Codex'in ana derleyicisi — DOKUNMA. Claude kendi sürümünü `bin\uxb_claude1_<ad>.exe` olarak derler
  (`tools\claude\uxb_build.ps1 -Name claude1_<ad>`); aynı exe'yi aynı anda iki kez derleme.
- Git YOK: silme yerine taşı (`build\claude1_old_*` ya da `%TEMP%`).

## 7. Koordinasyon ve tasarım belgeleri
- `ai_koordinasyon/SORUN_TAKIP.md` (S-xxx kayıtları, durum: ACIK/YAPILDI/KARAR-BEKLIYOR), `KARAR_VE_GOREV_DEFTERI`, `DURUM`.
- Görev/eşzamanlılık tasarımı (Model D): `docs/tasarim/UXB_S146_GOREV_PAYLASIMLI_VERI_ONERISI_20260925_TR.md` (§10–§13).

## 8. Derin kod analizi: girdi/çıktı, çağrı ağı, tipler, karar tabloları (2026-10-06)
Konum: `uxb/tekdosyaklsoru/kod_analiz/` — sistemin TEK tek-dosya klasörü `uxb/tekdosyaklsoru` (2026-10-07; eski klasörler `UXBc/claude_arsiv/eski_belgeler`'de).
Orkestratör (tüm analiz/paketleme anahtarları tek harfli): `python UxbRAG/UXB_HYBRID_RAG_V4_YORUMLU_JSON/tools/Moduller/paketleyici31.py -h`; `-s <KB>` her çalıştırmada kullanıcıdan (0=tek dosya), `-K` kod analizi, `-F` yerel model eğitim verisi, `-Z` günlük zincir (`UXB_TEKDOSYA_KB` gerekir).
Modül başlığında: include ettiği/eden, **çağrıyla kullandığı modüller** ve **rutinlerini çağıran modüller** (sayılarıyla); makine okunur karşılığı `veri/iliski_modul_cagri.tsv`, `iliski_include.tsv`.
Önce `OZET.md`, sonra: `iliski_agi.md` (include döngüleri/katmanlar, en çok çağrılan/çağıran rutinler, en karmaşıklar),
`tablolar.txt` (SELECT CASE ve IF/ELSEIF karar tabloları), `moduller/<yol>.txt` (modül başına: tipler+alanlar, global/sabit,
her rutinin imza/girdi/çıktı/yerel/çağırdığı/çağrıldığı/global okuma-yazma/tablo), `UXB_KOD_ANALIZ_TEK_DOSYA.txt` (hepsi, bağımlılık sırasıyla),
`veri/*.jsonl|tsv` (makine okur: rutinler, tipler, globaller, tablolar, çağrı/include/tip/global/sabit/miras ilişkileri, DLL çağrıları).
Üretici: `UxbRAG/UXB_HYBRID_RAG_V4_YORUMLU_JSON/tools/Moduller/KodAnalizor.py` (kaynağa dokunmaz; `saglik.txt` ctags ve rutinler.tsv ile çapraz doğrulama sonucunu verir).
Sınırlar: satır tabanlı çözümleme; çağrılar ada göre (aşırı yüklemede adaylar); ByRef ile dolaylı yazma izlenmez; `[yorum]`/model amaçları taslaktır.
Tip/global/tablo "amaç" metinleri `ajan_paketi/ek_amac_onbellek.jsonl` önbelleğinden gelir (`uxb_harita_doldur.py --is ek`, ortak kota; 2026-10-07: 1296/1296 dolu).
Dış model zinciri (`UXB_ZINCIR`, `%USERPROFILE%\.uxb\api_anahtarlari.env`): gemini, gemini2, omniroute, groq, kimi, chatgpt, claude, sonra tarayıcı köprüsü `kopru_gemini/kopru_chatgpt/kopru_claude` (Opera eklentisi; API kotası/bakiyesi bitince devreye girer, sohbete sistem bağlamı bir kere gönderilir).
Dikkat: `uxb_map_system.py --out <başka klasör>` `reports/uxb_map_system/latest_summary.json` işaretçisini o klasöre kaydırır; ajan paketi/harita aracı son haritayı oradan okur — geçici çıktı için işaretçiyi sonra geri al ya da haritayı yeniden üret (`scripts/41_ajan_paketi_yenile.bat`).
Güvenlik analizi (`-G`): 2026-10-07'de gürültü giderildi (BASIC String'i "tampon" sayılmıyor, SQL yalnız tırnak içi gerçek SQL deyimi, sabit argümanlı Shell/Exec risk sayılmıyor); kalan bulgular dinamik komut çağrılarıdır.
