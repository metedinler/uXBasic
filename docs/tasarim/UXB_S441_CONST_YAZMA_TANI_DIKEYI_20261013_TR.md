# uXBasic S-441 CONST Yazma Tani Dikey Halkasi

Tarih: 2026-10-13
Sorumlu: Codex
Durum: YAPILDI-DOGRULANDI

## Karar

`CONST` okunabilir bir semboldur; dogrudan veya dolayli olarak yazilabilir bir
hedef degildir. `A = 4`, `A += 1`, `A++` ve `BYREF` parametresine `A` aktarmak
acik derleme hatasi vermelidir. Bu kural AST, canonical MIR, MIR-x64,
AST-x64, JS, WAT/WASM ve run yuzeylerinde ayni semantic sonucu uretir.

Bir alt kapsamda `DIM A` veya parametre `A` varsa, bu degisken ust kapsamda
bulunan `CONST A` adini golgeler. Bu nedenle denetim yalniz metin eslesmesiyle
degil, AST parent zincirinden yeniden kurulan lexical scope ile yapilir.

## Uygulama

`parser_stmt_dispatch.fbs` icindeki ortak parser kapisi su davranislari
denetler:

- `ASSIGN_STMT`, `INCDEC_STMT` ve `INCDEC_EXPR` dugumlerinin dogrudan IDENT
  hedefleri.
- Bilinen SUB/FUNCTION cagrisinda `BYREF` olarak bildirilen parametreye verilen
  dogrudan IDENT argumani.
- Globalden rutine uzanan CONST gorunurlugu ve yerel DIM/PARAM golgelemesi.

Hata metni `UXB_CONST_ASSIGNMENT:` on ekiyle uretilir. Bu on ek
`error_system_adim45.fbs`, parser tanilama koprusu ve
`main_output_contract_bridge.fbs` tarafindan `UXB_CONST_ASSIGNMENT` canonical
koduna baglanir.

`semantic_step3_gate.fbs` ayni kontrolu ikinci kez yapar. Burada once en yakin
sembol genel turu cozulur; yalniz en yakin sembol `SYM_CONST` ise reddedilir.
Bu ayrim, yerel degiskenin ust kapsam sabitini golgelemesini korur.

## Kanit

`tests/diagnostics/run_const_write_tests.ps1`:

- dogrudan atama: 7/7 hedefte ret,
- bilesik atama: 7/7 hedefte ret,
- yordam icinde atama: 7/7 hedefte ret,
- `BYREF` CONST gecisi: 7/7 hedefte ret,
- yerel golgeleme pozitif ornegi: 7/7 hedefte kabul.

Toplam: **35/35 PASS**.

Yeni binary ile secili regresyon: `numeric_model` 20/20,
`library_type_contract` 38/38, `iterators` 44/44, `routine_scope` 16/16,
`exceptions_cross` 20/20, S-440 diagnostics 15/15 ve S-441 35/35;
toplam **188/188, 7/7 paket**.

## Sinir

Bu halka, S-441 kaydindaki kullanici dili yuzeyini kapatir. Iliskili fakat
ayri isler olan genel readonly kutuphane tipi sozlesmesi, `BYREF` icin daha
gelismis alias/ownership kurallari ve bilinmeyen dinamik rutin hedeflerinin
statik imza cozumlemesi bu kaydin kapsamina alinmamistir.
