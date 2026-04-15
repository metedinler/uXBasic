# uXBasic DLL Scope + Codegen Master Plani

Tarih: 2026-04-15
Amac: uXBasic'te ilk resmi DLL olarak istatistik sistemini hazirlarken, genel DLL altyapisini da baska DLL'leri calistirabilecek cekirdek seviyeye getirmek.

Bu plan, ozellikle su eksenlere odaklanir:

1. CALL(DLL, ...) cekirdegi
2. NAMESPACE / MODULE / MAIN / USING / ALIAS ile FFI birlikte calisma
3. Strongly-typed marshalling
4. HIR/MIR/codegen izleme ve kapanis
5. uXStat DLL'in minimum cekirdek kurulumu (istatistik fonksiyon sayisi degil, altyapi)
6. stdcall/cdecl cift protokol uyumlulugu

## 1) Calisma Dizini Uyumlama

Bu repo icin uyarlanmis hedef klasorler:

- Compiler cekirdegi:
  - src/parser
  - src/semantic
  - src/runtime
  - src/build
- Dokuman ve izleme:
  - reports/uxbasic_operasyonel_eksiklik_matrisi.md
  - spec/IR_RUNTIME_MASTER_PLAN.md
  - planyap/
- uXStat DLL bootstrap (yeni):
  - extras/uxstat/include
  - extras/uxstat/src
  - extras/uxstat/tests
  - extras/uxstat/bas

Not: Harici proje agaci yerine mevcut repo icinde extras/uxstat ile ilerlenir. Sonraki asamada ayrik repo cikarmak istenirse tasima kolay olur.

## 2) Kod Gerceklik Durumu (Ozet)

Halihazirda kodda olanlar:

- CALL(DLL, ...) parser + semantic + runtime policy fail-fast var.
- NAMESPACE/MODULE/MAIN/USING/ALIAS parser+semantic fail-fast var.
- CLASS/OOP mvp (METHOD/ctor/dtor/extends/interface) aktif.

Acil kapanacaklar:

- FFI scope entegrasyon testleri (namespace/module/alias icinden CALL(DLL)).
- Strongly-typed marshalling kontrati (STRING/PTR/NUM).
- stdcall/cdecl secimi ve cagri kontratinin acik protokolle izlenmesi.
- Codegen lane'inde win64 ABI adimlari.

## 3) Fazlar

### Faz A - FFI Scope Cekirdegi (2 sprint)

Hedef:

- CALL(DLL) wrapper cagrilari namespace/module/alias zincirinde deterministik calissin.

Is paketleri:

1. Parser-semantic dogrulama genisletme:
   - USING/ALIAS ile cagrilan wrapper fonksiyonun CALL(DLL) resolve zinciri.
2. Runtime call-dispatch kontrati:
   - alias hedefi ile signature token uyum denetimi.
3. Test paketi:
   - tests/run_call_dll_scope_exec_ast.bas
   - tests/run_call_dll_alias_exec_ast.bas

Kapanis kriteri:

- Matris Bolum 12 satirlari (NAMESPACE+MODULE+MAIN ile DLL cagrisi ve USING/ALIAS ile isim cozumleme) T=OK.

### Faz B - Strongly-Typed Marshalling (2 sprint)

Hedef:

- DLL cagrilarinda tip gecisi net ve testli olsun.

Tip kontratlari (MVP):

- PTR
- I32/I64
- F32/F64
- STR/STRING (null-terminated gecis kurali)
- BYREF target kontrolu
- CALLCONV (stdcall/cdecl)

Is paketleri:

1. Signature token parser tablosu sertlestirme.
2. Runtime marshalling katmani (argument conversion/adreslenebilirlik).
3. Negatif testler:
   - yanlis arity
   - yanlis signature token
   - byref non-addressable
   - policy deny
4. Calling convention testleri:
  - stdcall deklarasyonu ile DLL cagrisi
  - cdecl deklarasyonu ile DLL cagrisi
  - x64 lane: ayni ABI altinda protokol metadata korunumu
  - x86 lane: caller/callee stack temizleme farki (ayrik test paketi)

Kapanis kriteri:

- Matris Bolum 12 "Strongly-typed marshalling" satiri D/P/S/R/T = OK.

### Faz C - uXStat DLL Bootstrap (3 sprint)

Hedef:

- uXBasic'in ilk resmi DLL'i: uXStat (cekirdek veri yapisi + minimal API).

Kapsam:

- Veri yapilari:
  - StatVector
  - StatFactor
  - StatDataFrame
- C ABI:
  - alloc/free
  - vec_create/destroy/set/get
  - stat_mean/stat_std/stat_var
  - load_csv/save_csv (MVP)

Repo yerlesimi:

- extras/uxstat/include/uxstat_core.h
- extras/uxstat/include/uxstat.h
- extras/uxstat/src/uxstat_memory.cpp
- extras/uxstat/src/uxstat_vector.cpp
- extras/uxstat/src/uxstat_basic.cpp
- extras/uxstat/src/uxstat_csv.cpp
- extras/uxstat/src/uxstat_uxbasic.cpp
- extras/uxstat/CMakeLists.txt
- extras/uxstat/bas/uxstat.bas
- extras/uxstat/tests/

Not:

- Ilk hedef, 131 istatistik fonksiyon degil; DLL cekirdeginin guvenli calismasi.

Kapanis kriteri:

- uXBasic tarafinda CALL(DLL, ...) ile uxb_stat_mean ve uxb_vec_* fonksiyonlari PASS.

### Faz D - Codegen Lane Plani (3 sprint)

Hedef:

- MIR/codegen yolunu DLL agir senaryolara hazirlamak.

Is paketleri:

1. HIR->MIR kural listesi (CALL, BRANCH, LOAD/STORE).
2. MIR dispatch parity testi (interpreter vs compile yolu).
3. Win64 ABI kurallari:
   - shadow space
   - 16-byte stack alignment
   - arg register kurallari
  - calling convention metadata'sinin emitter yoluna tasinmasi
4. CALL [register] ve arg gecisi emitter adimi.

Kapanis kriteri:

- Matris Bolum 13 satirlarinda CG-3 hucreleri PLAN->KISMEN/OK gecisi.

## 4) Word Dokumani Konularinin Uygulanma Sekli

Baglamdaki "Istatistik Veri Yapisi Tasarimi" ve diger plan metinlerinden su ilkeler alinir:

- DataFrame column-store yaklasimi
- Missing data stratejisi (bitmask/sentinel)
- C ABI ile uXBasic bridge
- Cagri guvenligi ve policy odagi

Bu asamada hedef:

- istatistik komut adlarini dil cekirdegine gommek degil,
- CALL(DLL)+scope+alias altyapisini guclendirip istatistik DLL'i bu altyapi uzerinden calistirmak.

## 5) Matris Izleme Kurali

Tek kanonik izleme:

- reports/uxbasic_operasyonel_eksiklik_matrisi.md

Bu plana ait lane etiketleri:

- FFI-SCOPE-1
- FFI-SCOPE-2
- FFI-CONV-1 / FFI-CONV-2 / FFI-CONV-3
- UXSTAT-0
- CG-1 / CG-2 / CG-3 / CG-QA

Her sprint sonunda:

1. ilgili satirlarin D/P/S/R/T hucreleri guncellenir,
2. test komutlari ve kanit notlari Not kolonuna yazilir,
3. yapilanlar.md'ye sadece kapanan is append edilir.

## 6) Ilk Sprint Gorev Listesi (Baslat)

1. tests/run_call_dll_scope_exec_ast.bas ekle.
2. tests/run_call_dll_alias_exec_ast.bas ekle.
3. CALL(DLL) scope+alias semantik guardlarini runtime dispatch ile esle.
4. Matris Bolum 12 iki satiri KISMEN->OK cekmek icin test-gate kaniti bagla.
5. extras/uxstat/include ve extras/uxstat/src icin bos iskelet dosyalari ac.

### 6.1) Ilk Faz Tamamlananlar (2026-04-15)

Tamamlanan adim (FFI-CONV-1):

1. Lexer/Parser tarafinda `CDECL` ve `STDCALL` token kabul ve semantik dogrulama eklendi.
2. Runtime CALL(DLL) yolunda opsiyonel calling-convention ayrisma ve audit alanina `conv=` bilgisi eklendi.
3. Iki yeni test eklendi ve PASS aldi:
  - tests/run_call_dll_scope_exec_ast.bas
  - tests/run_call_dll_alias_exec_ast.bas

Not:

- Bu adim, protokol secim metadata'sini acmistir.
- Gercek dis cagrinin ABI seviyesinde yurutulmesi (x64 emitter/x86 stack cleanup) FFI-CONV-2 ve FFI-CONV-3 lane'lerinde kapanacaktir.

### 6.2) FFI-CONV-2 Bootstrap (2026-04-15)

Tamamlanan adim:

1. CALL(DLL) allowlist satirinda opsiyonel calling convention kolonu destegi eklendi:
  - `dll|symbol|signature|calling_convention|sha256|signer`
2. Win64 lane'de (`x86_64`), policy eslestirmesinde `CDECL` ve `STDCALL` uyumlu kabul edilir hale getirildi.
3. Audit kaydina aktif ABI bilgisi (`abi=WIN64-MSABI`) eklendi.
4. Kanit testi:
  - tests/run_call_exec.bas (conv-compat + ABI audit assertion)

Acik kalanlar (FFI-CONV-2 kapanisi icin zorunlu):

1. Gercek dis DLL cagrisi emitter yolunda shadow space ayrimi.
2. 16-byte stack alignment zorlamasi.
3. CALL [register] / arg register mapping codegen adimlari.

### 6.3) FFI-CONV-2 Kapanis (2026-04-15)

Tamamlanan adimlar:

1. Yeni x64 backend modulu eklendi:
  - `src/codegen/x64/ffi_call_backend.fbs`
2. CALL(DLL) AST dugumlerinden Win64 plan cikisi uretiliyor:
  - `line,dll,symbol,signature,convention,arg_count,stack_args,reserve_bytes,abi,stack_align,shadow_space`
3. NASM stub cikisi uretiliyor:
  - `call qword [rel __uxb_ffi_symptr_N]`
  - RCX/RDX/R8/R9 register arg yukleme
  - `[rsp+32+]` stack arg slot yazimi
  - reserve formulu: `40 + stackArg*8 + odd pad`
4. CLI interop akisina entegre edildi:
  - `src/main.bas` icinde `FfiX64BackendEmitArtifacts(ps, "dist\\interop", ...)`
5. Kanit testleri:
  - `tests/run_ffi_x64_call_backend.bas` (dedicated)
  - `tests/run_call_exec.bas` (regresyon)
  - smoke: `tests/tmp_ffi_conv2_codegen_smoke.uxb` + `--interop` -> `dist/interop/ffi_call_x64_plan.csv`

Kapsam siniri (durust not):

1. Stub icindeki `__uxb_ffi_symptr_N` cozumlemesi (gercek adres baglama/loader) FFI-CORE/CG lane'inde ayrik kapanis kalemidir.
2. FFI-CONV-2 bu turda Win64 stack/shadow/alignment ve call-shape kapanisi olarak tamamlandi.

## 7) Risk ve Koruma

Riskler:

- FFI marshalling'de sessiz tip bozulmasi.
- Calling convention uyumsuzlugunda stack corruption riski.
- Scope/alias zincirinde yanlis isim cozumleme.
- Codegen lane erken karmasiklik.

Koruma:

- Her adimda negatif test zorunlu.
- Policy fail-fast kodlari korunacak (9201..9215).
- Interpreter parity gecmeden codegen hucreleri OK'a cekilmeyecek.

## 8) Python Kutuphaneleri (Elestirel Karar)

Kisa cevap:

- Bu planin ana ekseni icin Python zorunlu degil.
- Plan disi degil ama bir sonraki faza alinmasi daha dogru.

Neden:

1. Ilk kritik hedef, genel DLL altyapisinin guvenli calismasi (CALL(DLL)+scope+alias+marshalling).
2. Python entegrasyonu CPython runtime bagimliligi, GIL, packaging ve surum uyumlulugu gibi yeni riskler getirir.
3. uXStat ilk DLL hedefi C ABI ile zaten acilabilir; Python bridge'i bunu tamamlayici ikinci dal olmali.

Oncelik karari:

1. Simdi: C/C++ DLL cekirdegi + stdcall/cdecl + Win64 ABI kapanisi.
2. Sonra: Python bridge (ctypes veya CPython embedding) deneme lane'i.

Python lane acilacaksa minimum kapsam:

- FFI-PY-1: ctypes tabanli adapter (harici script seviyesinde)
- FFI-PY-2: CPython embedding (Py_Initialize, GIL, hata kozuleri)
- FFI-PY-3: dagitim/paketleme ve surum sabitleme
