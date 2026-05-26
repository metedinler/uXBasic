# UXBc (uXBasiC) — Mimari Analiz, Güçlü/Zayıf Yanlar ve Tamamlanma Yol Haritası

**Tarih:** 2026-05-25  
**Git Deposu:** https://github.com/metedinler/uXBasic.git  
**Kanonik Kaynak:** `UXBc/uxb/src`  
**Dil:** FreeBASIC (`.fbs` = FreeBASIC kaynak; `.bas` = ana giriş noktası)

---

## 1. Genel Bakış

UXBc, uXBasiC sözdizimini hedefleyen çok aşamalı bir derleyicidir. Çıktı olarak NASM x64 assembly üretir; aynı zamanda hem AST üzerinde hem MIR üzerinde çalışan iki ayrı yorumlayıcı (interpreter) içerir. Yüksek hassasiyetli kayan nokta için harici DLL tabanlı bir genişletme hattı (F80/F128/BIGF/BIGD/BALL) ve Windows DLL çağrısı için güvenli bir FFI katmanı mevcuttur.

---

## 2. Mimari Katman Haritası

```
┌─────────────────────────────────────────────────────────┐
│                    Kaynak Giriş (.bas/.uxb)              │
└────────────────────────┬────────────────────────────────┘
                         │
┌────────────────────────▼────────────────────────────────┐
│  FRONTEND                                                │
│  ┌─────────────┐   ┌──────────────┐   ┌──────────────┐  │
│  │   Lexer     │──▶│    Token     │──▶│    Parser    │  │
│  │lexer_core   │   │token_kinds   │   │parser_stmt_* │  │
│  │lexer_keyword│   │              │   │parser_expr   │  │
│  │lexer_preproc│   │  197 keyword │   │              │  │
│  └─────────────┘   └──────────────┘   └──────┬───────┘  │
└──────────────────────────────────────────────┼──────────┘
                                               │ AST
┌──────────────────────────────────────────────▼──────────┐
│  MIDDLE-END                                              │
│  ┌─────────────────────┐   ┌─────────────────────────┐   │
│  │  Semantic Pass      │   │  AST Contract Layer     │   │
│  │  semantic_pass.fbs  │──▶│  ast_contract.fbs       │   │
│  │  type_binding.fbs   │   │  (gezinme API'si)       │   │
│  └──────────┬──────────┘   └─────────────────────────┘   │
│             │ HIR                                         │
│  ┌──────────▼──────────┐   ┌─────────────────────────┐   │
│  │  HIR                │   │  Layout / Type Table    │   │
│  │  hir.fbs            │──▶│  layout/layout_*.fbs    │   │
│  └──────────┬──────────┘   └─────────────────────────┘   │
│             │ MIR                                         │
│  ┌──────────▼──────────────────────────────────────────┐  │
│  │  MIR Model (mir_model.fbs)                          │  │
│  │  MIRModule → MIRFunction → MIRBasicBlock            │  │
│  │  → MIRIRInstruction (opcode + operands + result)    │  │
│  │  ┌───────────┐ ┌─────────────┐ ┌──────────────┐   │  │
│  │  │MIR Lower  │ │MIR Verifier │ │MIR JSON Export│  │  │
│  │  │mir_lower* │ │mir_verifier │ │mir_full_export│  │  │
│  │  └───────────┘ └─────────────┘ └──────────────┘   │  │
│  └─────────────────────────────────────────────────────┘  │
└───────────────────────┬─────────────────────────────────┘
                        │
        ┌───────────────┼──────────────────┐
        │               │                  │
┌───────▼──────┐ ┌──────▼──────┐  ┌───────▼────────────┐
│ AST          │ │ MIR         │  │ MIR x64 Backend    │
│ Interpreter  │ │ Interpreter │  │ (Native NASM üretim)│
│ memory_exec  │ │ mir_evaluat │  │ mir_x64_codegen    │
│ runtime/exec │ │ or.fbs      │  │ mir_x64_arrays     │
│              │ │             │  │ mir_x64_builtins   │
│ ÇALIŞIYOR    │ │ ÇALIŞIYOR   │  │ mir_x64_fp64       │
│ (ana hat)    │ │ (orta olgun)│  │ EXPERIMENTAL       │
└──────────────┘ └─────────────┘  └───────────────────-┘
                                          │
                              ┌───────────▼───────────────┐
                              │  External FP Runtime      │
                              │  fp80 / fp128 / bigfp DLL │
                              │  (MSYS2/GCC gerektirir)   │
                              └───────────────────────────┘
```

### 2.1 Dosya Katmanı Özeti

| Katman | Dizin | Dosya Sayısı | Durum |
|---|---|---:|---|
| Lexer / Token / Parser | `uxb/src/parser/` | ~20 | Olgun |
| Semantic / Type / Layout / HIR | `uxb/src/semantic/` | ~25 | Orta-İyi |
| MIR Model + Lowering + JSON | `uxb/src/semantic/mir*.fbs` | ~15 | İyi |
| AST Interpreter (runtime) | `uxb/src/runtime/` | ~18 | İyi |
| x64 AST Codegen | `uxb/src/codegen/x64/code_generator.fbs` | 1 | Kullanılabilir |
| MIR x64 Backend | `uxb/src/codegen/x64/mir_x64_*.fbs` | ~12 | Experimental |
| x86 Backend | `uxb/src/codegen/x86/` | 2 | Tamamlanmamış |
| FFI (x86/x64) | `uxb/src/codegen/x64/ffi_call_backend.fbs` | 2 | Orta |
| External FP Runtime | `uxb/runtime_ext/` | 12 | Kaynak var, derleme gerekli |
| Build / Interop Manifest | `uxb/src/build/` | 5 | Var |
| VSCode Extension | `uxb/vscode-extension/` | 5 | Yardımcı düzey |
| Araçlar / Audit | `uxb/tools/` | 12 | Çalışıyor |
| Test Paketi | `uxb/tests/` | 310 | Zengin |

---

## 3. Güçlü Yanlar

### 3.1 Net Çok Aşamalı Pipeline Ayrımı
Lexer → Token → AST → Semantic → HIR → MIR → Codegen/Interpreter şeklindeki katman ayrımı yapısal olarak doğrudur. Her aşama kendi `.fbs` dosyalarında izole edilmiş, include zincirleri `main.bas` tarafından yönetilmektedir.

### 3.2 Çift Yorumlayıcı (AST + MIR)
Aynı kaynaktan hem AST üzerinde hem MIR üzerinde yürütme yapılabilmesi, geliştirme sırasında doğruluk referansı olarak kullanılabilir. Yeni bir backend eklendiğinde AST interpreter ile karşılaştırma yapılabilir.

### 3.3 Zengin JSON Çıktı Hattı
`--ast-json-out`, `--hir-json-out`, `--mir-full-json-out`, `--mir-verify-json-out`, `--keyword-layer-matrix-json-out` gibi 15+ CLI seçeneği, tooling ve test otomasyonu için güçlü bir gözlemlenebilirlik altyapısı sağlar.

### 3.4 AST Contract Katmanı
`ast_contract.fbs`, AST'a doğrudan alan erişimi yerine `UXBAstChildAt`, `UXBAstFirstChildByRoleCI` gibi tek tip API ile erişimi zorunlu kılar. Bu, semantic/MIR/codegen katmanlarının AST okuma davranışının zamanla ayrışmasını önler.

### 3.5 "Sessiz Eksik Bırakma Yasak" Politikası
`mir_x64_capability.fbs` içindeki kural açıktır: desteklenmeyen her opcode ya açık diagnostic üretir ya da hata koduyla durur; sessiz skip yoktur. Bu, hatalı "çalışıyor" izlenimini engeller.

### 3.6 FFI Güvenlik Katmanı
`ffi_signer.fbs` içinde DLL yol doğrulaması (mutlak path reddi, segment sayısı sınırı, geçersiz karakter kontrolü), allowlist politikası, signer hash doğrulaması mevcuttur. OWASP güvenlik prensiplerine uygun bir yaklaşımdır.

### 3.7 Geniş Keyword Yüzeyi (197 Keyword)
`lexer_keyword_table.fbs`'dan otomatik çıkarılan 197 keyword, standart BASIC'in ötesinde OOP, FFI, yüksek hassasiyetli FP, koleksiyonlar ve olay sistemi kapsar.

### 3.8 MIR Model Tasarımı
`MIRModule → MIRFunction → MIRBasicBlock → MIRIRInstruction` yapısı SSA ağırlıklı olmasa da CFG (control flow graph) ve vtable desteğiyle gerçek bir IR modeline yaklaşmaktadır.

### 3.9 Dış FP Runtime Mimarisi
F80/F128/BIGF/BIGD/BALL için "kayıt ve dispatch" tabanlı politika (`extfp_type_policy.fbs`) ile her tipin farklı DLL ailesine yönlendirilmesi temiz bir genişletilebilirlik örüntüsüdür.

### 3.10 Python Audit Araçları
`uxb_keyword_layer_matrix.py`, `uxb_mir_x64_surface_audit.py`, `uxbc_baseline_runner.py` gibi araçlar keyword → katman → MIR x64 yüzey kapsamını ölçerek eksikleri sayısal olarak raporlar.

---

## 4. Zayıf Yanlar ve Riskler

### 4.1 FreeBASIC Üzerinde FreeBASIC Derleyicisi (Bootstrap Bağımlılığı)
Derleyici FreeBASIC ile yazılmış olup derlenmesi için dışarıdan `fbc` toolchain gerekir. Baseline testleri bu toolchain'i bulamadığı için 5/8 check `TOOLCHAIN_OR_FILE_MISSING` ile kapanmaktadır. Kaynak düzgün olsa da çalıştırılabilir üretilememektedir.

### 4.2 `.fbs` Uzantısının Yanlış Kullanımı
`.fbs` FlatBuffers schema standardıdır; burada FreeBASIC kaynak dosyası olarak kullanılmaktadır. Bu durum araç zincirlerini ve editör desteğini olumsuz etkiler, GitHub'da yanlış dil tespitine yol açar.

### 4.3 Dosya Çoğaltma Krizinin İzleri
Konsolidasyon raporuna göre orijinal zipte 118 dosya kök dizinde ve `uxb/src` altında çift mevcuttu; 10 tanesi farklı içerikle. Temizlenmiş pakette bu sorun giderilmiş ancak kök dizindeki bazı eski `.fbs`/`.bas` dosyaları hâlâ bulunuyor (`main.bas` kök vs. `uxb/src/main.bas`).

### 4.4 MIR x64 Backend'in Büyük Kısmı Diagnostic-Only
`mir_x64_capability.fbs` incelendiğinde `REDIM`, `CALL_USER`, `CALL_DLL`, `CALL_API`, `IMPORT`, `INLINE`, `TRY/CATCH/FINALLY/THROW`, `ASSERT`, `EVENT`, `THREAD`, `PIPE/SLOT/TRIGGER`, `CLASS_DECL`, `METHOD_DECL`, `CTOR/DTOR`, `DELETE`, `ALLOC`, `FREE` opcode'larının `DiagnosticOnly = 1` döndürdüğü görülür. OOP, FFI ve exception handling gerçek native kod üretememektedir.

### 4.5 String Tabanlı Opcode Dispatch (Performans Riski)
MIR instruction opcode'ları string olarak saklanmakta (`opcode As String`) ve `Select Case UCase(Trim(opcodeText))` ile işlenmektedir. Bu yaklaşım geliştirme kolaylığı sağlar ancak büyük programlarda interpreter ve lowering performansını ciddi biçimde düşürür.

### 4.6 x86 Backend Tamamlanmamış
`uxb/src/codegen/x86/code_generator.fbs` ve `ffi_call_backend.fbs` dosyaları mevcut; ancak x86 backend ana pipeline'a tam entegre değil, experimental modda.

### 4.7 Bağlayıcı (Linker) Entegrasyonu Yok
MIR x64 backend NASM assembly çıktısı üretir, ancak NASM ile derleme + linker çağrısı otomatikleştirilmemiştir. Gerçek çalıştırılabilir üretmek için kullanıcının bağımsız adımlar atması gerekir.

### 4.8 BIGF/BIGD/BALL Runtime Sadece Kaynak Düzeyinde
`uxb_bigfp_mpfr.c`, `uxb_fp128_quad.c`, `uxb_fp80_fb.bas` dosyaları mevcuttur; ancak bunların derlenmesi MSYS2/UCRT64, GCC, MPFR ve GMP kütüphanelerini gerektirir. Hazır DLL paketi bulunmamaktadır.

### 4.9 İki Farklı AST Gezinme Modeli (Tarihsel Birikim)
AST düğümleri `left/right` (expression ağacı) ve `firstChild/nextSibling` (block/statement listesi) olmak üzere iki farklı edge modelini aynı anda taşımaktadır. AST contract katmanı bu riski azaltmış ama sıfırlamamıştır.

### 4.10 Test Otomasyonu Eksikliği
310 test dosyası mevcuttur; ancak bunların büyük kısmı manuel çalıştırılan `.bas` dosyasıdır. CI/CD entegrasyonu, otomatik geçti/kaldı kararı veren test koşucu, ve regresyon izleme altyapısı yoktur.

### 4.11 VSCode Extension Sadece Sözdizim Renklendirme Düzeyinde
`vscode-extension/src/extension.js` mevcuttur; `.ts` kaynak yoktur (yani TypeScript ile değil doğrudan JS ile yazılmış). Debugger Adapter Protocol, breakpoint desteği veya Language Server Protocol implementasyonu bulunmamaktadır.

### 4.12 Tür Sistemi Sınırlılıkları
Generics, lambda/closure, tip çıkarımı (type inference), union type ve nullable type desteklenmemektedir. OOP kalıtımı ve virtual dispatch modeli kodda var; ancak MIR x64 backend'e bağlı kısımlar diagnostic modundadır.

### 4.13 Optimizer Geçişi Yok
Lexer → AST → HIR → MIR → x64 pipeline'ında hiçbir optimizasyon geçişi bulunmamaktadır (constant folding, dead code elimination, inlining). Üretilen kod temel ve naif seviyededir.

---

## 5. Keyword Kapsam Durumu

`mir_x64_keyword_surface_audit.json` çıktısından elde edilen kategori özeti:

| Kategori | Keyword Sayısı | Durum |
|---|---:|---|
| `native_builtin_or_integer_op` | 39 | Gerçek native NASM üretimi var |
| `compiletime_no_emit_or_type` | 56 | Derleme zamanı, emit gerekmez |
| `native_storage_or_compiletime` | 13 | Depolama / derleme zamanı |
| `native_controlflow_or_call` | 24 | Akış kontrolü, gerçek emit var |
| `native_runtime_call` | 7 | Runtime çağrı, emit var |
| `native_memory_or_builtin` | 20 | Bellek/builtin, emit var |
| `external_fp_runtime` | 5 | Harici FP DLL gerektiriyor |
| `diagnostic_exception_pending` | 5 | Try/throw/catch: diagnostic only |
| `diagnostic_fileio_pending` | 7 | File I/O: diagnostic only |
| `diagnostic_native_pending` | 5 | Çeşitli: diagnostic only |
| `diagnostic_oop_pending` | 6 | OOP: diagnostic only |
| `diagnostic_concurrency_pending` | 10 | Thread/event/pipe: diagnostic only |
| **Toplam** | **197** | |

Native gerçek kod üreten keyword oranı yaklaşık **%77**'dir (39+13+24+7+20+56 = 159/197).  
Gerçek machine-code üreten (emit yapan) oran ise daha düşük: yaklaşık **%52** (103/197).

---

## 6. Eksik ve Tamamlanması Gerekenler

### Kritik Öncelik (Derleyici Çalışabilir Olması İçin)

| # | Eksik | Açıklama |
|---|---|---|
| K1 | FreeBASIC (fbc) toolchain bağımlılığı | Build pipeline otomasyonu veya pre-built binary dağıtımı gerekli |
| K2 | NASM + linker entegrasyonu | Üretilen `.asm` → `.exe` adımı otomatikleştirilmeli |
| K3 | Kök dizin kaynak kopyaları temizliği | `main.bas` ve diğer kök kopyalar `uxb/src` lehine kaldırılmalı |
| K4 | MIR x64: array indexed load/store | `LOAD_INDEXED` / `STORE_INDEXED` gerçek emit |
| K5 | MIR x64: float opcodes | `FADD/FSUB/FMUL/FDIV/FNEG` gerçek SSE emit |

### Yüksek Öncelik (Kullanılabilir Çıktı İçin)

| # | Eksik | Açıklama |
|---|---|---|
| Y1 | BIGF/BIGD/BALL DLL build | MSYS2 kurulum belgesi var; pre-built DLL yoktur |
| Y2 | F80 uçtan uca smoke testi | `uxb_fp80_fb.bas` → DLL → codegen → çalışan binary |
| Y3 | FFI x64 native path tamamlanması | `CALL_DLL` MIR opcodeunun gerçek x64 emit alması |
| Y4 | OOP codegen: CTOR/DTOR/METHOD | Vtable mekanizması MIR modelinde var; x64 emiti yok |
| Y5 | File I/O MIR x64 emit | `OPEN/CLOSE/PRINT #/INPUT #` gerçek syscall veya CRT call |

### Orta Öncelik (Üretim Kalitesi İçin)

| # | Eksik | Açıklama |
|---|---|---|
| O1 | Opcode enum'a geçiş | `opcode As String` → integer enum, dispatch tablosu |
| O2 | Test koşucu otomasyonu | Tüm `.bas` testleri için geçti/kaldı kaydeden CI |
| O3 | Constant folding optimizer | Temel derleme zamanı değerlendirmesi |
| O4 | Exception handling MIR x64 | TRY/CATCH/FINALLY için SEH veya setjmp tabanlı lowering |
| O5 | Hata kurtarma (error recovery) | Parser'da panik mod sonrası senkronizasyon |

### Uzun Vadeli (Ekosistem İçin)

| # | Eksik | Açıklama |
|---|---|---|
| U1 | Language Server Protocol | VSCode'da hover, go-to-def, renaming |
| U2 | Debug Adapter Protocol | Breakpoint, watch, call stack |
| U3 | Modül / paket sistemi | `IMPORT "modül"` desteği |
| U4 | x86 backend tamamlanması | 32-bit hedef için tam pipeline |
| U5 | Tip çıkarımı (type inference) | Kısmi `AS` zorunluluğunu kaldırmak |
| U6 | Optimizer geçişleri | DCE, constant folding, inlining |
| U7 | Linux/macOS desteği | Şu an Windows-only |
| U8 | Generics/template | Tip parametreli yapılar |

---

## 7. Olgunluk Matrisi

| Bileşen | Tasarım | Kod Gerçekliği | Test Kapsamı | Üretim Hazırlığı |
|---|:---:|:---:|:---:|:---:|
| Lexer | ★★★★★ | ★★★★★ | ★★★★☆ | ★★★★☆ |
| Parser | ★★★★☆ | ★★★★☆ | ★★★★☆ | ★★★☆☆ |
| AST Contract | ★★★★★ | ★★★★☆ | ★★★☆☆ | ★★★☆☆ |
| Semantic / Type | ★★★★☆ | ★★★☆☆ | ★★★☆☆ | ★★★☆☆ |
| HIR | ★★★☆☆ | ★★★☆☆ | ★★☆☆☆ | ★★☆☆☆ |
| MIR Model | ★★★★☆ | ★★★★☆ | ★★★☆☆ | ★★★☆☆ |
| AST Interpreter | ★★★★☆ | ★★★★☆ | ★★★★☆ | ★★★★☆ |
| MIR Interpreter | ★★★☆☆ | ★★★☆☆ | ★★★☆☆ | ★★★☆☆ |
| x64 AST Codegen | ★★★☆☆ | ★★★☆☆ | ★★★☆☆ | ★★★☆☆ |
| MIR x64 Backend | ★★★☆☆ | ★★☆☆☆ | ★★☆☆☆ | ★☆☆☆☆ |
| FFI (x64) | ★★★☆☆ | ★★☆☆☆ | ★★☆☆☆ | ★★☆☆☆ |
| External FP | ★★★★☆ | ★★★☆☆ | ★★☆☆☆ | ★★☆☆☆ |
| OOP Codegen | ★★★☆☆ | ★★☆☆☆ | ★★☆☆☆ | ★☆☆☆☆ |
| VSCode Extension | ★★☆☆☆ | ★★☆☆☆ | ★☆☆☆☆ | ★☆☆☆☆ |
| Test Otomasyonu | ★★☆☆☆ | ★★☆☆☆ | — | ★☆☆☆☆ |

---

## 8. Önerilen Tamamlanma Sırası

```
ADIM 1 — Temel Derleme Zinciri (1-2 hafta)
  └─ K1: fbc kurulum/doğrulama scripti + CI
  └─ K2: NASM + linker entegrasyon katmanı
  └─ K3: Kök dizin temizliği, tek kaynak olarak uxb/src sabitleme

ADIM 2 — MIR x64 Çekirdek Tamamlama (2-3 hafta)
  └─ K4: LOAD_INDEXED / STORE_INDEXED array emit
  └─ K5: FADD/FSUB/FMUL/FDIV → SSE2 (xmm register) emit
  └─ Y3: CALL_DLL x64 stack frame + call sequence

ADIM 3 — External FP DLL (1-2 hafta)
  └─ Y1: MSYS2 automated build + pre-built DLL paket
  └─ Y2: F80 uçtan uca test (dim → aritmetik → print)

ADIM 4 — OOP Codegen (3-4 hafta)
  └─ Y4: CTOR/DTOR heap alloc + vtable write
  └─ Y4: METHOD dispatch via vtable pointer

ADIM 5 — Kalite ve Otomasyon (2 hafta)
  └─ O1: Opcode string → enum migration
  └─ O2: CI test runner (PowerShell/Python)
  └─ O3: Constant folding geçişi

ADIM 6 — Ekosistem (süregelen)
  └─ U1: LSP (Language Server)
  └─ U2: DAP (Debug Adapter)
  └─ U3: Modül sistemi
```

---

## 9. Baseline Test Durumu (2026-05-25)

| Check | Durum | Neden |
|---|---|---|
| `build_compiler_root` | TOOLCHAIN_OR_FILE_MISSING | fbc (FreeBASIC compiler) kurulu değil |
| `build_compiler_script` | TOOLCHAIN_OR_FILE_MISSING | fbc bulunamıyor |
| `stage4_audit` | **PASS** | Python audit aracı çalışıyor |
| `keyword_layer_matrix` | **PASS** | 197 keyword matrisi oluşturuldu |
| `mir_x64_surface_audit` | **PASS** | Keyword → MIR x64 yüzey haritası üretildi |
| `mir_x64_prompt3_smoke` | TOOLCHAIN_OR_FILE_MISSING | Derlenmiş binary yok |
| `mir_x64_completion_smoke` | TOOLCHAIN_OR_FILE_MISSING | Derlenmiş binary yok |
| `extfp_codegen_smoke` | TOOLCHAIN_OR_FILE_MISSING | FP DLL'ler derlenmemiş |

**Sonuç:** Kaynak kod ve mimari sağlamdır; toolchain eksikliği tüm çalışma zamanı testlerini bloke etmektedir.

---

## 10. Net Değerlendirme

**UXBc, ciddi ve çok katmanlı bir derleyici girişimidir.** Mimari tasarımı akademik derleyici yapısına yakın; lexer/parser/AST/HIR/MIR/codegen ayrımı tutarlıdır. AST contract, sessiz-eksik yasağı politikası ve JSON gözlemlenebilirlik altyapısı olgun mühendislik kararlarıdır.

Bununla birlikte proje şu an **"derlenebilir kaynak"** aşamasındadır; **"çalıştırılabilir binary"** aşamasına geçiş için en az ADIM 1 ve ADIM 2'nin tamamlanması gerekmektedir. MIR x64 backend experimental statüsünü korumakta, OOP ve FFI native codegen büyük ölçüde eksik kalmaktadır.

En önemli tek eylem önerisi: **FreeBASIC toolchain kurulumu ve NASM/linker entegrasyonunu otomatikleştiren bir CI/CD scripti** yazmak — bu adım olmadan diğer hiçbir geliştirme doğrulanamaz.

---

## 11. ADIM 3 Uygulama Kararı (2026-05-26)

Bu planın ADIM 3 hedefi için yeni Python araç çöplüğü üretmek yerine, mevcut çalışan altyapı korunarak aşağıdaki kararlar alınmıştır:

1. FreeBASIC çekirdek önceliklidir: semantic → type_binding → layout geçidi derleyici içinde gerçek kontrol noktası olarak çalıştırılır.
2. Python tarafında tekrar eden script açılmaz: mevcut audit araçları genişletilerek kullanılır.
3. MIR/x64/JS/WASM katmanlarına geçişten önce TYPE_UNKNOWN/TYPE_ERROR sızıntısı kapıda durdurulur.
4. TYPE/CLASS layout üretimi başarısızsa downstream aşamalara geçiş engellenir.

Bu karar kapsamında eklenen/bağlanan çekirdek dosyalar:

- `uxb/src/semantic/semantic_step3_gate.fbs`
- `uxb/src/semantic/type_binding.fbs` (user type kaydı ve çözümleme genişletmesi)
- `uxb/src/semantic/semantic_pass.fbs` (include zinciri)
- `uxb/src/semantic/semantic_pass_tail.fbs` (SemanticAnalyze içinde Step3 gate çağrısı)

Not: Bu değişiklikler mevcut çalışan semantic/MIR hattını bozmadan, sadece kapı kontrolünü sıkılaştıracak şekilde eklenmiştir.

---

## 12. 268 Yüzey Anahtar Envanteri

Plan kapsamındaki 268 surface anahtarının ayrıntılı listesi ve katman durumları tek dosyada tutulmaktadır:

- `uxb/docs/matrix/UXB_268_YUZEY_ANAHTAR_ENVANTERI.md`

Bu envanterde her öğe için aşağıdaki kolonlar verilmiştir:

- surface_name
- surface_group / surface_kind
- ast_node
- semantic_status / type_binding_status / layout_status
- mir_status
- js_transpiler_status / wasm_wat_status / browser_runtime_status
- final_decision

Ek not: lexer dosyalarındaki doğrudan `Case` literal birleşim sayısı ile matrix surface sayısı aynı kavram değildir. Derleyici katman planında referans sayı matrixteki 268 surface öğesidir.

---

## 13. ADIM 4 Uygulama Kararı (2026-05-26)

ADIM 4 hedefi icin sifirdan paralel bir MIR sistemi yazmak yerine, mevcut calisan `semantic/mir*` hatti korunarak kanonik `src/mir` katmani asagidaki sekilde baglanmistir:

1. FreeBASIC cekirdek once gelir: opcode registry ve verify no-unknown kapisi derleyici icine baglandi.
2. Mevcut MIR lowering bozulmaz: legacy opcode adlari Step4 registry tarafinda geriye donuk uyumlu kabul edilir.
3. Python yerine FreeBASIC verifier zinciri kullanilir.
4. Gate fail-closed calisir: `TYPE_UNKNOWN`, `TYPE_ERROR`, `LAYOUT_MISSING` token sizintisi verifier seviyesinde hata uretir.

Bu karar kapsaminda eklenen/baglanan dosyalar:

- `uxb/src/mir/mir_types.fbs`
- `uxb/src/mir/mir_error_codes.fbs`
- `uxb/src/mir/mir_opcode.fbs`
- `uxb/src/mir/mir_registry.fbs`
- `uxb/src/mir/verify/mir_verify.fbs`
- `uxb/src/mir/verify/mir_verify_types.fbs`
- `uxb/src/mir/verify/mir_verify_operands.fbs`
- `uxb/src/mir/verify/mir_verify_blocks.fbs`
- `uxb/src/mir/verify/mir_verify_control_flow.fbs`
- `uxb/src/mir/verify/mir_verify_calls.fbs`
- `uxb/src/mir/verify/mir_verify_memory.fbs`
- `uxb/src/mir/verify/mir_verify_target_support.fbs`
- `uxb/src/mir/verify/mir_verify_no_unknown.fbs`
- `uxb/src/mir/verify/mir_verify_json_report.fbs`
- `uxb/src/mir/mir_step4_bridge.fbs`
- `uxb/src/semantic/mir.fbs` (Step4 bridge include)
- `uxb/src/semantic/mir_verifier.fbs` (Step4 registry + canonical verifier hook)

Not: Bu adim x64 emitter / JS transpiler / WASM emitter yazimini genisletmez. Odak yalnizca AST -> MIR dogruluk kapisi, MIR verify ve matrix/gate raporlamasidir.
