# uXBasic Fazli Operasyon Plani

Tarih: 2026-04-11
Kapsam: Dilin tum katmanlarindaki eksikleri sistematik olarak kapatma plani

## 1) Referans Dokumanlar

1. Operasyonel bosluk matrisi: reports/uxbasic_operasyonel_eksiklik_matrisi.md
2. IR + Runtime master plan: spec/IR_RUNTIME_MASTER_PLAN.md
3. Giris kriterleri: spec/NEXT_PHASE_ENTRY_CRITERIA.md

## 1.1) Kanonik Dokuman Modeli

Bu repo artik 3 dosyali kanonik modelle isletilir:

1. `plan.md`: tek aktif faz plani ve is kuyugu.
2. `reports/uxbasic_operasyonel_eksiklik_matrisi.md`: tek operasyonel durum matrisi (D/P/S/R/T).
3. `yapilanlar.md`: append-only gunluk ve kapanan is kanitlari.

Arsiv/ikincil dosyalar (`.plan.md`, `WORK_QUEUE.md`, faz release checklist dosyalari) referans amaclidir; yeni planlama bu dosyalara yazilmaz.

## 1.2) Implementasyon Baslangic Paketi (Audit-Driven)

Bu bolum, "implementasyona basla" talebi icin gerekli somut giris paketini verir.

1. Specific code sections (ilk odak):
   - `src/parser/parser/parser_stmt_decl_core.fbs`
   - `src/parser/parser/parser_stmt_decl_scope.fbs`
   - `src/runtime/memory_exec.fbs`
   - `src/runtime/exec/exec_stmt_flow.fbs`
2. Audit raporundan onceliklendirilen ilk gorevler:
   - `%%DESTOS` ve `%%PLATFORM` satirlari icin parser+semantic kapanisi (`reports/uxbasic_operasyonel_eksiklik_matrisi.md`, PSRT-OK gorev 11)
   - `%%NOZEROVARS` ve `%%SECSTACK` satirlari icin parser+semantic kapanisi (`reports/uxbasic_operasyonel_eksiklik_matrisi.md`, PSRT-OK gorev 12)
   - `INLINE` ve `LIST/DICT/SET` satirlarindaki acik hucrelerin kapanisi (`reports/uxbasic_operasyonel_eksiklik_matrisi.md`, PSRT-OK gorev 19)
3. Ek baglam (ilk dogrulama adimlari):
   - test isimlendirme kontrolu: `tools/validate_test_naming.ps1`
   - Faz A gate: `tools/run_faz_a_gate.ps1`
   - Faz B.2 fail-fast: `tools/run_faz_b2_failfast.ps1`

## 2) Fazlar

Fazlar her turde 5 lane ile paralel ilerler:

1. Statement lane
2. Local function lane
3. Operator lane
4. Type/variable lane
5. Data structure lane

### Faz R0 - Baseline
- Hedef: Mevcut yesil durumu dondurmek.
- Cikti: Sabit test tabani + bosluk matrisi.

### Faz R1 - Akis ve Konsol I/O
- Hedef: IF/SELECT/PRINT/INPUT runtime calisir hale gelsin.
- Cikti: Flow + console runtime test paketleri.
- Durum: KISMEN -> IF/SELECT/PRINT/INPUT ve INPUT# eklendi; SELECT CASE icin CASE IS iliskisel dali parser+runtime+test ile aktif, LOCATE/COLOR/CLS deterministic runtime-state testi eklendi, PRINT zone-parity tamamlandi, INPUT deterministic queue + INPUT# runtime testi eklendi, IF icin dedicated branch runner eklendi.

### Faz R2 - Cagri ve Kontrol Akisi
- Hedef: SUB/FUNCTION, CALL, GOTO/GOSUB/RETURN/END runtime.
- Cikti: Kullanici prosedur cagrisi ve jump testleri.
- Durum: KISMEN -> unary @, LOF/EOF, INKEY/GETKEY minimum runtime modeli + GOTO/GOSUB/RETURN semantigi (jump/call-stack + missing-target fail-fast + duplicate-label guard + user-call jump guard) dedicated test/gate kaniti ile kapatildi + user-defined SUB/FUNCTION call mvp + END semantigi (flow + user-call context propagation + parse fail-fast) kapatildi; ileri semantik ayrintilar acik.
- OOP Paralel: CLASS FIELD + METHOD + PUBLIC/PRIVATE (OOP-1)

### Faz R3 - Veri Alani
- Hedef: DIM/REDIM, DEF*, SETSTRINGSIZE, CLASS mvp.
- Cikti: Degisken ve dizi runtime modeli.
- Durum: KISMEN -> R3.N mini iterasyonu tamamlandi; DIM/REDIM runtime yolu AST deklarasyon modeliyle hizalandi, REDIM dispatch cakisimi kapatildi, REDIM PRESERVE parser+runtime semantigi aktiflestirildi, cok-boyut REDIM bounds yolu eklendi ve dedicated runner ile REDIM satiri D/P/S/R/T tam OK'a cekildi.
- OOP Paralel: CONSTRUCTOR/DESTRUCTOR + NEW/DELETE + THIS (OOP-2)
- OOP Paralel: EXTENDS mvp + ABSTRACT/FINAL/SEALED + OVERRIDE denetimi (OOP-3)

### Faz R4 - Sayisal Model ve Float
- Hedef: Numeric promotion, float evaluator, intrinsic runtime.
- Cikti: Float semantik ve operator oncelik testleri.
- Durum: KISMEN -> R1.M kapanisiyla INKEY/GETKEY ve LOF/EOF satirlari OK'a cekildi; CASE IS satiri D/P/S/R/T=OK olarak kapatildi; LOCATE/COLOR/CLS satirlari semantik dahil tam OK'a cekildi; CDBL/CSNG/FIX/SQR runtime kapsami deterministic assertionlarla dogrulandi; STR + UCASE/LCASE + CHR + LTRIM/RTRIM + MID + SPACE/STRING text-context runtime yolu (PRINT/POKES + nested intrinsic) aktif; SIN/COS/TAN/ATN + EXP/LOG runtime intrinsicleri ve LOG domain fail-fast aktif; RND ve TIMER runtime/test kapsami tamamlandi; float expression evaluator henuz acik.
- OOP Paralel: INTERFACE/IMPLEMENTS + SUPER + INSTANCEOF (OOP-4)

### Faz R5 - Koleksiyonlar
- Hedef: LIST/DICT/SET mvp runtime.
- Cikti: Koleksiyon API testleri.
- OOP Paralel: VIRTUAL/vtable + OPERATOR overload + MIXIN/DECORATOR/sihirli metotlar (OOP-5)

### Faz R6 - Program Yapisi ve Meta-Komutlar
- Hedef: NAMESPACE/MODULE/MAIN bloklari ve END kapanis kurallari.
- Hedef: %% ile baslayan derleyici meta-komutlarin preprocess katmanini kurmak.
- Cikti: Program yapisi parser+semantic + preprocess test paketleri.
- Durum: KISMEN -> NAMESPACE/MODULE/MAIN/USING/ALIAS parser MVP + MAIN tek giris + USING/ALIAS fail-fast semantik denetimleri + CLASS icin RESTRICTED/FRIEND parser+semantic MVP + parse test kosuculari eklendi.
- Not: OOP erisim ve modul siniri semantiklerinin dogru islemesi icin kritik bagimlilik fazidir.
- Ek hedef: `MAIN` ile tek giris noktasi sozlesmesi + legacy ust-duzey akis uyumlulugu.
- Ek hedef: `RESTRICTED` kapsamini namespace+project siniriyla netlemek, `FRIEND` istisna modelini cakismasiz sabitlemek.
- Ek hedef: `ALIAS yeni = eski` modelini komut/fonksiyon/blok/FFI hedefleri icin parser+semantic seviyede acmak.
- Ek hedef: `MAIN/NAMESPACE/MODULE/ALIAS` komutlarini preprocess degil yapi-meta direktifi olarak ayristirmak.

### Faz FFI-1 - IMPORT Birinci Dalga
- Hedef: IMPORT(C/CPP/ASM, file) ile dis toolchain baglantisi.
- Cikti: Build/link orkestrasyonu ve ABI policy.
- Ek hedef: `CALL(DLL, ...)` canonical formu + allowlist tabanli runtime policy (report-only -> enforce).
- Ek hedef: DLL path canonicalization, hash/signer dogrulama ve audit log sozlesmesi.
- Durum: KISMEN -> `CALL(DLL, ...)` canonical parser formu + semantic fail-fast + mode-aware policy (`REPORT_ONLY`/`ENFORCE`) deny davranisi aktif; allowlist dosya-kaynagi (`dist/config/ffi_allowlist.txt`) strict `UXB_FFI_ALLOWLIST_V1` header ile calisiyor, DLL canonicalization (path-segments/absolute-path/invalid-char fail-fast) eklendi; policy satiri hash/signer alanlarini kabul ediyor, `ENFORCE` modunda attestation metadata zorunlu, hash/signer mismatch deny kodlari ayristirildi (`9211`/`9212`) ve extraction-failure kodlari eklendi (`9213`/`9214`), audit log sozlesmesi `event=ffi_policy_decision` alanlariyla yapilandirildi; gercek DLL signer/hash extraction ve marshaling/ABI bridge acik.

### Faz FFI-2 - INLINE Ikinci Dalga
- Hedef: INLINE(C, text) feature flag ile kontrollu acilim.
- Cikti: Guvenlik ve deterministic build kurallari.

### Son Madde - CLASS OOP Ozellikleri
- OOP-P0: PUBLIC/PRIVATE, METHOD, THIS/ME
- OOP-P1: Constructor/Destructor, tekli inheritance mvp
- OOP-P2: VTable/polymorphism, interface sozlesmesi
- Kural: OOP-P0 tamamlanmadan OOP-P1/P2 acilmaz.

## 3) Sayisal Oncelik ve Birliktelik

Bu plan su operator semantigini referans alir:

1. Parantez ve cagri
2. Unary + - NOT @
3. Us alma **
4. Carpma grubu * / \\ MOD %
5. Toplama grubu + -
6. Kaydirma ve dondurme
7. Karsilastirma
8. AND
9. XOR
10. OR

Birliktelik:

- Unary ve ** sagdan sola
- Digerleri soldan saga

## 4) Isletim Kurali

Her faz kapanisinda asagidaki uc adim zorunludur:

1. Matris guncellemesi
2. Test runner ekleme ve gate entegrasyonu
3. yapilanlar.md append-only kaydi

## 5) Otonom Cok Ajanli Paralel Isletim

Bu plan su sekilde otomatik yurur:

1. Her turde en az iki lane paralel kodlanir.
2. Her tur sonunda durum yalnizca YOK/KISMEN/PLAN -> OK donusumu olarak raporlanir.
3. Her turde en az bir kod imalati + bir test/gate adimi zorunludur.
4. Bir lane riskli ise diger lane'ler paralel devam eder, ilerleme durmaz.
