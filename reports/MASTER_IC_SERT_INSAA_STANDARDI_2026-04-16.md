# uXBasic Master Ic Insaa Standardi (Sert)

Tarih: 2026-04-16
Surum: IC-MASTER-1.0
Amac: Compiler insa surecini kapanisa goturmek icin tek, sert ve uygulanabilir ic standard.

## 1) Kanonik Hiyerarsi (Cakisma Cozumu)

Belge cakisirsa karar sirasi:

1. `reports/call_family_destek_politikasi_standardi.md`
2. `plan.md`
3. `reports/uxbasic_operasyonel_eksiklik_matrisi.md`
4. `spec/NEXT_PHASE_ENTRY_CRITERIA.md`
5. `spec/IR_RUNTIME_MASTER_PLAN.md`
6. `yapilanlar.md`
7. Diger tum dokumanlar (`WORK_QUEUE.md`, checklist/release/backlog notlari, PCK2/PCK3, planyap/*)

## 2) Izlenecek Plan Belgeleri (Tam Liste)

Zorunlu izleme seti:

1. `plan.md`
2. `reports/uxbasic_operasyonel_eksiklik_matrisi.md`
3. `reports/call_family_destek_politikasi_standardi.md`
4. `spec/NEXT_PHASE_ENTRY_CRITERIA.md`
5. `spec/IR_RUNTIME_MASTER_PLAN.md`
6. `yapilanlar.md`
7. `release/RELEASE_CHECKLIST.md`
8. `reports/faz_b2_done_checklist.md`
9. `reports/faz_next_backlog.md`
10. `WORK_QUEUE.md`
11. `PCK2.MD`
12. `PCK3.MD`
13. `planyap/dll_plani.md`

## 3) Baseline Durum (Bugun)

1. Faz A gate PASS (yesil).
2. CLASS lane temel runtime zinciri aktif (THIS/ME baseline + ctor/dtor + dispatch testleri PASS).
3. Module quality gate kirmizi degil (layer ve uzunluk ihlalleri kapatildi).
4. FFI x86 lane resolver/proof aktif, native host proof kismen host kosuluna bagli.
5. CALL politika kilidi aktif: `CALL(API,...)` en son backlog maddesi.

## 4) Tam Kalan Is Envanteri (Matrix Kaynakli)

Asagidaki satirlar henuz tam kapanmamis durumdadir:

### 4.1 Hata Yonetimi Cekirdegi (ERR)
1. TRY/CATCH/FINALLY/END TRY -> P/S/R/T = PLAN
2. THROW -> P/S/R/T = PLAN
3. ASSERT -> P/S/R/T = PLAN

### 4.2 FFI Kalanlar
1. Calling convention secimi satiri -> R = KISMEN (no-op/dis cagrida tam icra kapanisi acik)
2. x86 stdcall/cdecl satiri -> P/S/R/T = KISMEN (native host proof kismi)
3. Ilk resmi DLL: uXStat -> P/S/R/T = PLAN

### 4.3 Codegen/MIR Kalanlar
1. HIR olusumu -> P/S/T = KISMEN
2. MIR olusumu -> P/S/R/T = KISMEN
3. MIR interpreter dispatch -> P/S/R/T = KISMEN
4. x64 emitter passthrough INLINE -> R/T = KISMEN
5. CALL register/stack passing -> R = KISMEN
6. Win64 ABI satiri -> R = KISMEN
7. Regression gate (interp vs compiled parity) -> P/S/R/T = KISMEN
8. TRY/CATCH unwind emit -> PLAN
9. THROW emit -> PLAN
10. ASSERT emit -> PLAN

### 4.4 Grup Bazli Codegen Satirlari
1. Akis grubu codegen -> KISMEN
2. Deklarasyon grubu codegen -> PLAN
3. I/O grubu codegen -> PLAN
4. Bellek grubu codegen -> PLAN
5. FFI codegen -> KISMEN
6. Hata yonetimi -> PLAN

## 5) Basit Eksiklikler (Hizli Kazanc Listesi)

Asagidaki maddeler yuksek teknik risk olmadan kapatilabilir:

1. Dokuman drift temizligi:
- `WORK_QUEUE.md` agirlikli tarihsel, aktif backlog ile hizasiz maddeler iceriyor.
- `reports/faz_next_backlog.md` guncel matrix onceligiyle yeniden siralanmali.

2. Checklist tutarlilik temizligi:
- `release/RELEASE_CHECKLIST.md` ve matrix/gate ciktilari arasinda her sprint sonrasi otomatik capraz kontrol eklenmeli.

3. Native lane rapor standardi:
- `reports/ffi_conv3_native_lanes_report.md` satirlari SKIP/BLOCKED/PASS anlam sozluguyla birlikte tek formatta kalmali.

4. PCK dokumanlarinda karar kilidi uyumu:
- PCK2/PCK3 icindeki tarihsel cumlelerde kalan sert/celisik ifadeler karar kilidine gore tekleyerek sadeleştirilmeli.

## 6) Sert Uygulama Kurallari

1. Matrix satiri acmadan kod yazilmaz.
2. Her kod adimi icin zorunlu: build + run + gate.
3. PASS olmayan testte kolon ilerletilmez.
4. `CALL(API,...)` lane'i en son backlogdur; erken acilmaz.
5. Plan guncellemesi olmadan "tamamlandi" kaydi dusulmez.
6. `yapilanlar.md` append-only; gecmis kayit degistirilmez.
7. Kapanis formati: Dosya -> Test -> Gate -> Matrix -> Yapilanlar.

## 7) Adim Adim Kapanis Plani (Compiler Tamamlama)

## P0 (hemen)

### P0.1 ERR-1 Parser/Semantic/runtime MVP
1. TRY/CATCH/FINALLY parser node setini ac.
2. THROW parser arity/type guard ac.
3. Runtime unwind iskeleti (single-level) ac.
4. Testler: pozitif + fail-fast.
5. Matrix ERR satirlarini PLAN -> KISMEN/OK cek.

Kapanis kaniti:
1. Yeni ERR test kosuculari PASS.
2. Faz A gate PASS.

### P0.2 ASSERT lane
1. ASSERT expr[, message] parser/semantic/runtime ac.
2. Debug/release policy switch netlestir.
3. Fail-fast hata formatini tekle.

Kapanis kaniti:
1. ASSERT pozitif/negatif test PASS.
2. Matrix ASSERT satiri ilerler.

### P0.3 FFI-CONV-3 native lane stabilizasyonu
1. Host kosulu netlestirme: x86-32 zorunlu kosul check.
2. Native cleanup proof ve symptr patch proof deterministik kosu akisi.
3. SKIP/BLOCKED reason kodlarinin rapor standardi.

Kapanis kaniti:
1. Native lane raporunda iki probe icin deterministic state.
2. Matrix FFI-CONV-3 satirinda not/sutun tutarliligi.

## P1 (kisa vade)

### P1.1 uXStat lane (UXSTAT-0)
1. Ilk resmi DLL API sozlesmesini dondur.
2. IMPORT + CALL(DLL) policy ile minimum operasyon seti ac.
3. uXStat smoke test ve allowlist/attestation uyumu.

### P1.2 HIR/MIR dar kapsam kapanisi
1. HIR node coverage checklist cikart.
2. MIR basic block + branch lowering mvp.
3. MIR interpreter dispatch icin secili statement parity.

### P1.3 Regression parity gate
1. Interp vs compiled cift-mod test seti olustur.
2. Fark raporu ureten otomatik script ekle.

## P2 (orta vade)

### P2.1 CG lane yayginlastirma
1. Akis/deklarasyon/I-O/bellek codegen satirlarini lane lane kapat.
2. Win64 ABI satirini KISMEN -> OK cek.

### P2.2 ERR-CG lane
1. TRY/CATCH unwind emit
2. THROW emit
3. ASSERT emit

## 8) Her Sprintte Zorunlu Ritueller

1. Baslangic: matrixten 1 P0 + 1 P1 lane sec.
2. Uygulama: en az 1 kod + 1 test ekle.
3. Dogrulama: ilgili kosucular + Faz A gate.
4. Belgeleme: matrix satiri + yapilanlar kaydi + gerekiyorsa plan notu.
5. Kapanis: bir sonraki sprint P0/P1 secimini net yaz.

## 9) "Tamamlandi" Tanimi

Bir lane ancak su 5 kosulla tamamlanmis sayilir:

1. Kod uygulamasi mevcut.
2. Pozitif/negatif test mevcut.
3. Gate PASS.
4. Matrix kolonlari guncel.
5. Yapilanlar kaydi eklendi.

Bu 5 kosuldan biri eksikse lane "tamamlandi" denmez.