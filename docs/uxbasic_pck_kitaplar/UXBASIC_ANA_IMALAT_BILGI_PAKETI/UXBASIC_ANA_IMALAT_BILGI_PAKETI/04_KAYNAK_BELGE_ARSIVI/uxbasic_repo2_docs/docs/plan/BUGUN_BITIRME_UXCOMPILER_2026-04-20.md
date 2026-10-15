# uXCompiler Bugun Bitirme Plani (2026-04-20)

Bu plan, repo icindeki tum ana planlarin ortak kesitini tek bir uygulama sirasina indirger.
Kaynaklar: plan.md, spec/IR_RUNTIME_MASTER_PLAN.md, spec/PSRT_OK_KAPANIS_MASTER_PLANI.md, reports/uxbasic_operasyonel_eksiklik_matrisi.md, release/RELEASE_CHECKLIST.md.

## 1) Bitirme Tanimlari

### 1.1 Bugun "Bitmis" (RC) tanimi
1. Faz A gate PASS.
2. Module quality gate PASS.
3. Referans ve test adlandirma gate PASS.
4. Mini release paketi uretilmis.

### 1.2 Tam "Tum Planlar Bitmis" tanimi (bugun hedef degil)
1. Matris P/S/R/T kolonlarinda acik hucre kalmamasi.
2. FFI x86 native lane kapanisi.
3. UXSTAT lane kapanisi.
4. MIR/HIR full parity kapanisi.

## 2) Bugunun Kritik Yolu (P0)

### P0-A: Quality Gate Kirmizilarini Kapat
1. src/parser/lexer/lexer_preprocess.fbs: LexerPreprocessSourceImpl fonksiyonunu helper fonksiyonlara bol.
2. src/parser/parser/parser_stmt_decl.fbs: dosyayi modul parcalarina ayir ve orchestrator include modeli koru.
3. src/build/main_frontend_include_bundle.fbs: codegen include bagimliligini build katmanindan cikar.
4. dogrulama: tools/validate_module_quality_gate.ps1

### P0-B: Ana Gate'i Yesile Cek
1. tools/validate_test_naming.ps1
2. tools/validate_reference_integrity.ps1
3. tools/run_faz_a_gate.ps1 -SkipBuild

### P0-C: Release Candidate Paket
1. build.bat src/main.bas
2. build.bat tests/run_manifest.bas
3. tests/run_manifest.exe
4. build_matrix.bat src/main.bas
5. tools/release_mini.bat v0.1.<N>-mini

## 3) Planlanmis Tum Adimlarin Birlesik Sirasi

Asagidaki sira, tum planlarin birlestirilmis master sirasidir:

1. R0 baseline ve matrix dogrulama
2. R1 akis + konsol I/O runtime
3. R2 call/jump/end semantigi ve runtime
4. R3 dim/redim/type/class mvp
5. R4 numeric/float evaluator
6. R5 koleksiyon motoru
7. R6 program yapisi + preprocess
8. FFI-1 import + call(dll) policy
9. FFI-2 inline + backend emit
10. OOP-P0 -> OOP-P2 ilerleyisi
11. ERR/ERR-CG lane kapanislari
12. IR/HIR/MIR parity ve codegen kapanisi
13. release checklist + paketleme

## 4) Bugun Disi Backlog (Sahipli)

1. FFI-CONV-3 native x86 kaniti (host bagimli)
2. UXSTAT-0 ilk resmi DLL
3. CG-1/CG-2 full HIR/MIR parity
4. ERR-CG full unwind/policy derinligi

## 5) Zaman Kutulu Uygulama (Bugun)

1. Blok-1 (90 dk): P0-A.1 + P0-A.2
2. Blok-2 (60 dk): P0-A.3 + quality gate tekrar
3. Blok-3 (75 dk): Faz A gate tam kosu
4. Blok-4 (45 dk): release mini paket
5. Blok-5 (30 dk): matrix/backlog notlari + kapanis raporu

## 6) Dur/Karar Kurali

1. P0-A bitmeden yeni feature yok.
2. Faz A gate kirmiziysa release yok.
3. Release mini gecmeden "bugun bitti" denmez.
4. Bugun disina kalan her is satiri owner + kanit komutuyla backlog'a yazilir.
