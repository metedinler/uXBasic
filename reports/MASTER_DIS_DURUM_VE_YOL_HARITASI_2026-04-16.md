# uXBasic Dis Durum ve Yol Haritasi (Sert Ozet)

Tarih: 2026-04-16
Surum: DIS-MASTER-1.0
Kitle: paydaslar, inceleyiciler, yeni katilan gelistiriciler

## 1) Nerede Duruyoruz

1. Compiler cekirdegi aktif ve Faz A gate yesil.
2. Parser/semantic/runtime temel BASIC kapsami buyuk oranda operasyonel.
3. CLASS lane temel ozellikleri calisiyor (THIS/ME baseline, ctor/dtor, method dispatch).
4. FFI lane policy tabanli yapida calisiyor; x86 native proof host kosullarina bagli kismi acik kalemler var.
5. CALL politika kilidi sabit: `CALL(API,...)` en son backlog maddesi.

## 2) Neler Tamamlandi (Yuksek Etki)

1. Akis ve I/O cekirdegi (IF/SELECT/PRINT/INPUT vb.) testli.
2. Cagri/jump ailesi (CALL/GOTO/GOSUB/RETURN/END) testli.
3. Veri alani temel modeli (DIM/REDIM/CONST/core types) testli.
4. Preprocess cekirdegi ve fail-fast politikasi testli.
5. Quality gate sertlestirmesi yapildi (katman/uzunluk ihlalleri kapandi).

## 3) Kalan Ana Basliklar

## A) Hata Yonetimi (ERR) - En Kritik
1. TRY/CATCH/FINALLY/END TRY
2. THROW
3. ASSERT

Neden kritik:
1. Dilin guvenli calisma davranisini tamamlar.
2. Codegen ve runtime parity yolunu acar.

## B) FFI Derin Kapanis
1. Calling convention satirinda runtime no-op kalintisini kapatma
2. x86 native proof lane'ini host-bagimsiz/tekrarlanabilir hale getirme
3. uXStat resmi DLL lane'ini acma

## C) HIR/MIR/Codegen Genisleme
1. HIR kapsami
2. MIR CFG/basic block kapsami
3. MIR interpreter dispatch
4. Akis/deklarasyon/I-O/bellek codegen lane'leri
5. Regression parity gate (interp vs compiled)

## 4) Basit Eksikler (Hizli Kapatilabilir)

1. Plan dokumanlari arasinda tarihsel drift temizligi.
2. Backlog/checklist belgelerinde aktif-oncelik sirasi tekleme.
3. Native lane raporunun SKIP/BLOCKED/PASS semantiklerinin tek formatta sabitlenmesi.
4. PCK ailesinde karar kilidiyle celisen tarihsel cumlelerin sadeleştirilmesi.

## 5) Sert Yonetim Kurallari

1. Matrixte satiri olmayan is acilmaz.
2. Testsiz degisiklik kabul edilmez.
3. Gate PASS olmadan satir kapatilmaz.
4. Plan ve yapilanlar kaydi olmadan "bitti" denmez.
5. CALL politika kilidi ihlal edilmez (`CALL(API,...)` en son).

## 6) Yol Haritasi (Adim Adim)

## Faz 1 (hemen): ERR cekirdegi
1. TRY/CATCH/FINALLY parser+semantic+runtime MVP
2. THROW parser+runtime MVP
3. ASSERT parser+runtime MVP
4. ERR test paketi + gate entegrasyonu

Basari olcutu:
1. ERR satirlari PLAN'dan en az KISMEN'e cekilir.
2. Faz A gate yesil kalir.

## Faz 2 (kisa vade): FFI kapanis
1. FFI-CONV runtime no-op kalintisini azaltma
2. x86 native proof lane stabilizasyonu
3. uXStat DLL pilot entegrasyonu

Basari olcutu:
1. FFI-CONV satirlari KISMEN -> OK yoluna girer.
2. Native lane raporu host nedeni ile de olsa deterministic uretilir.

## Faz 3 (orta vade): HIR/MIR/codegen
1. HIR coverage plan -> uygulama
2. MIR basic block + dispatch
3. Codegen lane lane kapanis
4. Interp vs compiled parity gate

Basari olcutu:
1. CG satirlarinda KISMEN/PLAN oraninin belirgin dusmesi.
2. Parity gate stabil PASS.

## 7) Riskler ve Onlemler

1. Host bagimli native test riski:
- Onlem: SKIP/BLOCKED sebeplerini standart kodla raporla.

2. Dokuman/calisan kod drift riski:
- Onlem: her sprintte matrix + yapilanlar zorunlu guncellemesi.

3. Faz atlama riski:
- Onlem: P0/P1/P2 sirasini sert uygula; en kritik satir once kapanir.

## 8) Inceleme ve Onay Mekanizmasi

Her teslimde zorunlu paket:

1. Degisen dosyalar listesi
2. Calistirilan test komutlari
3. Gate sonucu
4. Matrix satir degisimi
5. Yapilanlar kaydi

Bu besli paket yoksa teslim teknik olarak eksik kabul edilir.

## 9) Referans Plan Seti

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

Bu yol haritasi bu referans setine baglidir; guncellemeler bu setle birlikte yapilir.