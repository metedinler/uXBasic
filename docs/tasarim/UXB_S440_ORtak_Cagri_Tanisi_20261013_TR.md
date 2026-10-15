# uXBasic S-440: Ortak Parantezli Cagri Sozlesmesi

## Karar

`SUB`, `FUNCTION` ve metot cagrilari uXBasic kaynak yuzeyinde parantezli yazilir.
`Selam("Ayse")`, `o.Selam()` ve acik `CALL Selam("Ayse")` gecerlidir.
`Selam`, `Selam "Ayse"`, `o.Selam` ve `o.Yaz 5` bir dil ozelligi degildir;
sessizce yok sayilmaz ve derleme hatasi verir.

## Uygulama noktasi

Parser'in `ParseExpressionStatement` yolu tek basina kalan `IDENT` ve
`FIELD_EXPR` dugumlerini daha once no-op `EXPR_STMT` olarak uretiyordu. Bu,
acik `CALL` yolundaki parantez zorunluluguyla celisiyordu. Artik ortak parser
sinirinda `UXB_CALL_PAREN_REQUIRED` kodu uretilir.

## Tanilama sozlesmesi

Kod `error_system_adim45.fbs` katalog ve inference tablosundadir. Parser tanisi,
parser JSON'u ve ortak `all-diagnostics` failure ciktilari bu kodu korur.
Backend'ler bu kaynak reddini yeniden yorumlamaz; AST, MIR, MIR-x64, AST-x64,
JS ve WAT/WASM ayni frontend tanisini gorur.

## Kabul kaniti

`tests/diagnostics/run_parenless_call_tests.ps1` iki parantezsiz ornegi yedi
hedef fiilinde dener: 14 negatif + 1 pozitif kontrol = 15/15 PASS.
Pozitif ornek `Selam("Ayse")` ile calisir. Secili davranis regresyonu
138/138 PASS'tir.

## Acik sinir

Bu karar yalniz callable-shaped tekil statement yuzeyini kapsar. Bilesik
ifadeler (`a + b`) expression statement olarak kalir. Metot cozumu veya
operator MAGIC davranisi bu kaydin konusu degildir.
