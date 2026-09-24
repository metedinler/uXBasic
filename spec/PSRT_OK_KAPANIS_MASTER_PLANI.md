# PSRT-OK Kapanis Master Plani

Tarih: 2026-04-14
Kaynak matris: reports/uxbasic_operasyonel_eksiklik_matrisi.md

## 1) Kapsam Kurali

1. Bu planin kapsami, tum tablolarda D harici P/S/R/T kolonlarini tam OK seviyesine cekmektir.
2. D kolonu bu programda zorunlu kapanis kriteri degildir; D degisiklikleri yalnizca bilgi amaclidir.
3. R kolonu N/A olan satirlarda R muaf tutulur; P/S/T yine zorunlu OK'tur.
4. Kapanis kabulunde tek hakem: raporlanan matris + test/gate kaniti + yapilanlar.md kaydi.

## 2) Hard Blocker Kaydi (Acik ve Isimlendirilmis)

HB-01 (Kritik): FLOATING POINT derleyici kabiliyeti su an dokumante edilmis sekilde desteklenmiyor.
- Etki: `FLOATING POINT` komut satiri ve `F32/F64/F80` tip satiri P/S/R/T seviyesinde kapanamaz.
- Durum: Harici/cekirdek derleyici kabiliyeti bagimlisi.
- Kapanis kosulu: Derleyici seviyesinde float parse+semantic+runtime hattinin devreye alinmasi.

HB-02 (Kritik): VTable/Polymorphism ve Interface satirlari parser/semantic/runtime katmaninda taban implementasyon olmadan YOK durumunda.
- Etki: OOP tablolarinda P/S/R/T tam OK kapanisi bloke olur.
- Durum: Dil sozlesmesi + runtime dispatch tasarimi bagimlisi.
- Kapanis kosulu: VIRTUAL/OVERRIDE/INTERFACE sozlesmesi ve dispatch kaniti.

HB-03 (Yuksek): CALL(DLL, ...) satirinda gercek signer/hash extraction ve tam marshaling/ABI bridge acigi var.
- Etki: FFI satirlarinda P/S/R/T tam OK kapanisi gecikir.
- Durum: Guvenlik ve platform bagimli.
- Kapanis kosulu: ENFORCE modunda attestation zincirinin gercek dogrulamasi ve fail-closed davranis kaniti.

## 3) Paralel Lane Modeli (5 Ajan)

1. Lane-A Parser/Semantic (Agent-ParserSemantic)
2. Lane-B Runtime/Core (Agent-RuntimeCore)
3. Lane-C OOP Runtime (Agent-OOP)
4. Lane-D FFI+Preprocess+ProgramYapisi (Agent-InteropPreprocess)
5. Lane-E QA+Gate+Matriz (Agent-QAGate)

## 4) W1..W6 Dalga Plani

### W1 - Semantic Stabilizasyon ve Hizli Kapanislar

Paralel lane hedefleri:
1. Lane-A: `INPUT`, `IF/ELSEIF/ELSE/END IF`, `SELECT CASE` satirlarinda S=OK kapanisi.
2. Lane-A: `SUB/FUNCTION`, `CONST`, `END IF/END SELECT/END SUB/END FUNCTION` satirlarinda S=OK kapanisi.
3. Lane-D: `%%IFC`, `%%ENDCOMP`, `%%ERRORENDCOMP` satirlarinda S=OK kapanisi.
4. Lane-E: Her kapanis icin satir-bazli negatif test referansi ve gate baglantisi.

W1 kabul kriteri:
1. Yukaridaki satirlarda P/S/R/T acik hucre kalmaz.
2. Matris not kolonlari test referansi ile guncellenir.
3. Faz A gate PASS olmadan hucre gecisi yapilmaz.

W1 test+gate kaniti:
1. Komut: `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild`
2. Komut: `cmd /d /c build_64.bat tests\run_manifest.bas`
3. Kanit artefakti: `reports/gate_w1.log` + `yapilanlar.md` satir kaydi.

### W2 - Program Yapisi ve Preprocess Kalanlari

Paralel lane hedefleri:
1. Lane-D: `NAMESPACE`, `MODULE`, `MAIN`, `USING`, `ALIAS` satirlarinda P/S/T=OK.
2. Lane-D: `%%DESTOS`, `%%PLATFORM`, `%%NOZEROVARS`, `%%SECSTACK` satirlarinda P/S/T=OK.
3. Lane-D: `CALL(DLL, ...)` satirinda en az P/S=OK kapanisi, R/T icin guvenlik mvp genisletmesi.
4. Lane-E: Program yapisi ve preprocess icin dedicated kosucularin gate entegrasyonu.

W2 kabul kriteri:
1. Program yapisi tablosunda R=N/A satirlar disinda P/S/T acigi kalmaz.
2. Meta-komut tablosunda `%%DESTOS/%%PLATFORM/%%NOZEROVARS/%%SECSTACK` icin P/S/T=OK olur.
3. `CALL(DLL, ...)` satiri en azindan `KISMEN` degil, hedeflenen hucrelerde OK olur.

W2 test+gate kaniti:
1. Komut: `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild`
2. Komut: `cmd /d /c build_64.bat tests\run_percent_preprocess_exec.bas`
3. Komut: `cmd /d /c build_64.bat tests\run_percent_preprocess_control_failfast.bas`
4. Komut: `cmd /d /c build_64.bat tests\run_ffi_policy_enforce_exec_ast.bas`

### W3 - Runtime Tip Sistemi ve Operator Kapanisi

Paralel lane hedefleri:
1. Lane-B: Operator tablosunda `Carpma/Bolme/Tam bolme/Mod` R=OK.
2. Lane-B: Operator tablosunda `Atama (=, +=, -=, *=, /=, \\=, =+, =-)` R=OK.
3. Lane-B: Veri tipi tablosunda `I8..U64`, `BOOLEAN`, `STRING` satirlarinda S/R/T=OK.
4. Lane-B: `ARRAY` satirinda R/T=OK; `REDIM` satirinda R=OK (cok boyut + preserve dahil).
5. Lane-E: Tip/operator regresyon testlerini gate zorunlu setine ekleme.

W3 kabul kriteri:
1. Operator tablosunda D haric acik hucre kalmaz.
2. Veri tipi tablosunda float disi satirlarda P/S/R/T acigi kalmaz.
3. `REDIM` satiri tam OK olur.

W3 test+gate kaniti:
1. Komut: `cmd /d /c build_64.bat tests\run_dim_redim_exec_ast.bas`
2. Komut: `cmd /d /c build_64.bat tests\run_runtime_intrinsics.bas`
3. Komut: `cmd /d /c build_64.bat tests\run_numeric_type_promotion_exec_ast.bas`
4. Komut: `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild`

### W4 - OOP Cekirdek Tamamlama

Paralel lane hedefleri:
1. Lane-C: OOP tablosunda `METHOD bildirimi`, `THIS/ME modeli`, `Constructor/Destructor`, `Inheritance` satirlarinda P/S/R/T=OK.
2. Lane-C: Program yapisi tablosunda `END CLASS` satirinda S/R/T=OK.
3. Lane-B: Statement + Veri tipi tablolarindaki `CLASS` satirlarinda S/R=OK.
4. Lane-E: OOP test paketini gate zorunlu setine ekleme.

W4 kabul kriteri:
1. OOP cekirdek satirlarinda D haric acik hucre kalmaz (VTable/Interface haric).
2. Statement ve Veri tipi tablolarindaki CLASS satirlari tam OK olur.
3. `END CLASS` satiri tam OK olur.

W4 test+gate kaniti:
1. Komut: `cmd /d /c build_64.bat tests\run_class_method_dispatch_exec_ast.bas`
2. Komut: `cmd /d /c build_64.bat tests\run_class_this_me_binding_exec_ast.bas`
3. Komut: `cmd /d /c build_64.bat tests\run_class_ctor_dtor_exec_ast.bas`
4. Komut: `cmd /d /c build_64.bat tests\run_class_inheritance_virtual_exec_ast.bas`
5. Komut: `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild`

### W5 - FFI Guvenlik ve Koleksiyon Motoru

Paralel lane hedefleri:
1. Lane-D: `CALL(DLL, ...)` satirinda R/T kapanisi (ENFORCE + attestation + fail-closed).
2. Lane-D: `IMPORT(C/CPP/ASM, file)` satirinda S=OK.
3. Lane-B: `INLINE(...) ... END INLINE` satirinda S/T=OK.
4. Lane-B: `LIST/DICT/SET` satirinda S/R=OK.
5. Lane-E: FFI policy ve koleksiyon regresyon gate kosuculari.

W5 kabul kriteri:
1. FFI satirlarinda P/S/R/T acigi kalmaz.
2. Koleksiyon satiri tam OK olur.
3. Inline satiri tam OK olur.

W5 test+gate kaniti:
1. Komut: `cmd /d /c build_64.bat tests\run_cmp_interop.bas`
2. Komut: `cmd /d /c build_64.bat tests\run_inline_x64_backend.bas`
3. Komut: `cmd /d /c build_64.bat tests\run_collection_engine_exec.bas`
4. Komut: `cmd /d /c build_64.bat tests\run_ffi_attestation_exec_ast.bas`
5. Komut: `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild`

### W6 - OOP Ileri + Floating Point Kapanis

Paralel lane hedefleri:
1. Lane-C: `VTable/Polymorphism` ve `Interface` satirlarinda P/S/R/T=OK.
2. Lane-B: `FLOATING POINT` komut satiri ve `F32/F64/F80` tip satirinda P/S/R/T=OK.
3. Lane-B: Operator float semantigi ve promotion kurallari tamamlama.
4. Lane-E: float+oop ileri testlerini gate zorunlu setine baglama.

W6 kabul kriteri:
1. Matrisin tum tablolarda D harici acik hucre kalmaz.
2. HB-01 ve HB-02 kapali degilse W6 kapanmis sayilmaz.
3. Final gate PASS + matriste satir bazli kanit notu zorunlu.

W6 test+gate kaniti:
1. Komut: `cmd /d /c build_64.bat tests\run_float_runtime_exec_ast.bas`
2. Komut: `cmd /d /c build_64.bat tests\run_float_operator_semantics.bas`
3. Komut: `cmd /d /c build_64.bat tests\run_class_virtual_interface_exec_ast.bas`
4. Komut: `powershell -ExecutionPolicy Bypass -File tools/run_faz_a_gate.ps1 -SkipBuild`
5. Komut: `powershell -ExecutionPolicy Bypass -File tools/validate_module_quality_gate.ps1 -Strict`

## 5) Bagimlilik Haritasi (Ne Neyden Once)

1. W1 tamamlanmadan W2/W3 hucre gecisi yapilmaz (semantic taban sozlesme sabitlenmeli).
2. W2 Program Yapisi kapanmadan `CALL(DLL, ...)` ENFORCE tam kapanisi W5'e gecemez.
3. W3 tip/operator kapanmadan W4 OOP runtime stabil kabul edilmez (typed value sozlesmesi).
4. W4 cekirdek OOP kapanmadan W6 VTable/Interface acilamaz.
5. HB-01 kapanmadan W6 float satirlari OK olamaz.
6. HB-02 kapanmadan W6 OOP ileri satirlari OK olamaz.
7. HB-03 kapanmadan W5 FFI satirlari tam OK olamaz.

## 6) RACI-Benzeri Sorumluluk Onerisi (5 Paralel Ajan)

| Is Paketi | R (Responsible) | A (Accountable) | C (Consulted) | I (Informed) |
|---|---|---|---|---|
| Parser/Semantic kapanislari | Agent-ParserSemantic | Agent-BackendLead | Agent-QAGate, Agent-InteropPreprocess | Tum ajanlar |
| Runtime tip/operator kapanislari | Agent-RuntimeCore | Agent-BackendLead | Agent-QAGate, Agent-OOP | Tum ajanlar |
| OOP cekirdek ve ileri | Agent-OOP | Agent-BackendLead | Agent-RuntimeCore, Agent-QAGate | Tum ajanlar |
| FFI + preprocess + program yapisi | Agent-InteropPreprocess | Agent-BackendLead | Agent-ParserSemantic, Agent-QAGate | Tum ajanlar |
| Gate, test matrix, kanit paketleri | Agent-QAGate | Agent-BackendLead | Tum teknik ajanlar | Tum ajanlar |

## 7) Kapanis Kriteri (Program Seviyesi)

1. reports/uxbasic_operasyonel_eksiklik_matrisi.md icinde D haric hicbir P/S/R/T hucresinde `KISMEN`, `YOK`, `PLAN` kalmaz.
2. Her hucre gecisi icin en az bir dedicated test + bir gate kaniti bulunur.
3. Her dalga sonunda `yapilanlar.md` append-only kaydi acilir ve hucre gecisleri tek tek yazilir.
4. Son kapanista strict gate PASS zorunludur.

## 8) Birlesik Plan Delta (2026-04-15)

Bu bolum, onceki plan ile guncel sertlestirilmis plani tek operasyonda birlestirir.

### 8.1 Bu turda yapilan somut kodlama

1. `src/parser/lexer/lexer_preprocess.fbs` icine `%%PLATFORM`, `%%DESTOS`, `%%NOZEROVARS`, `%%SECSTACK` cekirdek davranislari eklendi.
2. `tests/run_percent_preprocess_control_failfast.bas` IFC sozdizimi mevcut parser gercegine uygun hale getirildi (`%%IFC lhs, rhs`).
3. `tests/run_percent_preprocess_ifc_exec.bas` IFC testleri mevcut parser gercegine uygun hale getirildi.
4. `tests/run_percent_preprocess_meta_exec.bas` yeni testi eklendi (meta-komut parse/fail-fast kaniti).

### 8.2 Kanit (bu turda calistirilan testler)

1. `tests/run_percent_preprocess_meta_exec_64.exe` cikis kodu: 0
2. `tests/run_percent_preprocess_control_failfast_64.exe` cikis kodu: 0
3. `tests/run_percent_preprocess_ifc_exec_64.exe` cikis kodu: 0

### 8.3 Hemen sonraki Sprint-1 (W1-W2 koprusu)

1. Lane-A (Parser/Semantic): `INPUT`, `IF/ELSEIF`, `SELECT CASE`, `SUB/FUNCTION`, `CONST` satirlarinin S kapanisi.
2. Lane-D (Interop/Preprocess): meta-komutlarin matrix satirlarinda test/gate kaniti ile S guncellemesi.
3. Lane-E (QA/Gate): matrix-test referans tutarliligi (phantom/orphan) temizligi, strict naming/gate zorunlulugu.

### 8.4 Hard blocker acikligi (gizlenmez)

1. HB-01 (FLOATING POINT): cekirdekte tam parse+semantic+runtime hatti tamamlanmadan OK yazilmaz.
2. HB-02 (VTable/Interface): OOP ileri satirlar W6 oncesi kapanmis sayilmaz.
3. HB-03 (CALL DLL ENFORCE): policy+attestation+marshaling tam olmadan R/T OK yazilmaz.

### 8.5 Operasyon kurali (degismedi)

1. D haric P/S/R/T kapanis hedefi korunur.
2. Test+gate kaniti olmadan matrixte OK guncellenmez.
3. Hard blocker satirlari allowlist ile kalici kapatilmaz; sadece sureli ve sahipli istisna kullanilir.
