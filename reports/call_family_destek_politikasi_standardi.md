# CALL Familyasi Destek Politikasi Standardi (Tek Sayfa)

Tarih: 2026-04-16  
Durum: Karar kilidi (kod degisikligi yok, policy standardi)

## 1) Amac

Bu standart, CALL ailesi icin gecerli, legacy ve future durumunu tek yerde sabitler.
Hedef: mevcut parser/runtime gercegini bozmadan, kirilma yaratmadan ilerlemek.

## 2) DECLARE Politikasi (Kirilmasiz)

- Ic cagri, kucuk/tek dosya modul: DECLARE opsiyonel.
- Ic cagri, cok dosya/modul: DECLARE onerilir.
- Dis cagri FFI/API: DECLARE zorunluya yakin standart (imza + calling convention + fail-fast).

Not:
- Bu politika parser/runtime kirilmasi olusturmadan uygulanir.
- Tum SUB/FUNCTION icin zorunlu DECLARE su anda policy degil; istege bagli team-standard olabilir.

## 3) 4 Gecerli Syntax Karari

Asagidaki 4 kullanim modeli gecerli kabul edilir:

1. Basit ic SUB deklarasyonu
- DECLARE SUB LogLine(msg AS STRING)

2. Basit ic FUNCTION deklarasyonu
- DECLARE FUNCTION Add(x AS I32, y AS I32) AS I32

3. FFI wrapper modeli
- DECLARE FUNCTION Tick() AS I32
- ALIAS Tick = CALL ( DLL , "kernel32.dll" , "GetTickCount" , I32, STDCALL )

4. Scope icinde kullanim
- NAMESPACE/MODULE/USING/ALIAS + MAIN/CALL(Tick) akisi

## 4) CALL Familyasi Destek Matrisi

### 4.1 Gecerli (Current)

- CALL(name, ...): Gecerli (parser + runtime).
- CALL(DLL, ...): Gecerli (parser + semantic + runtime policy/guard).
- CALL(aliasName, ...): Gecerli (alias hedefi CALL(DLL, ...) ise runtime cozumlenir).

### 4.2 Legacy

- CALL name(...): Gecerli tutulur (kanonik form CALL(...), legacy form geri uyumluluk icin acik).

### 4.3 Future

- CALL(API, ...): Parser tarafinda generic CALL olarak gecse de runtime destekli degil.
- Bu madde planin en son maddesi olarak kalir.

## 5) ALIAS yeni = eski Kurali (Durum Netlestirme)

- Parser/semantic katmaninda ALIAS hedef metni genel olarak kabul edilir; alias zinciri/cycle denetimi vardir.
- Runtime cagrida ise garanti edilen executable yol: ALIAS hedefinin CALL(DLL, ...) olmasidir.
- Sonuc:
  - ALIAS yeni = eski yazimi parser/semantic seviyede gecerli.
  - Runtime cagrida calisma garantisi su an ALIAS -> CALL(DLL, ...) hedefi icindir.

## 6) USING ve ALIAS Ayrimi

- USING: namespace import/cozumleme.
- ALIAS: yeni callable isim baglama.
- DLL sembolunu yerel callable isme baglamak icin ALIAS kullanilir.

## 7) DIM Baslangic Degeri Notu

- DIM ... AS TYPE [= expr] soz dizimi standartta gecerlidir.
- Koleksiyon/array icin literal tabanli baslangic degerleri (ornek: tuple/list benzeri toplu atama) parser/runtime kapsaminda ayrica netlestirilmelidir.
- Bu konu CALL policy kapsaminda degil; Faz R3 veri alani backlogunda takip edilir.

## 8) Kanit Referanslari

- ParseCallStmt: src/parser/parser/parser_stmt_basic.fbs
- ParseUsing/ParseAlias/ParseNamespace/ParseModule/ParseMain: src/parser/parser/parser_stmt_decl_scope.fbs
- ParseDeclareStmt: src/parser/parser/parser_stmt_decl_proc.fbs
- CALL(DLL) semantic validasyon kapisi: src/parser/parser/parser_stmt_dispatch.fbs
- Alias runtime cozumleme (CALL(DLL) beklentisi): src/runtime/memory_exec.fbs
- CALL(API) unsupported testi: tests/run_call_api_unsupported_exec_ast.bas

## 9) Isletim Karari

- Bu belge ile birlikte CALL familyasi karar metni sabitlenmistir.
- Sonraki kodlama adimlari bu standarda gore, kirilmasiz migration prensibiyle ilerletilir.