# uXBasic S-464: AST/MIR BOTH karşılaştırma kapısı

**Tarih:** 2026-10-14  
**Durum:** Uygulandı; canlı eşleşme ve başarısızlık yolları doğrulandı  
**Kapsam:** `run --interpreter-backend BOTH`

## Sorun

`BOTH` modu AST ve MIR yorumlayıcılarını çalıştırıp `interpreter_compare.json`
içinde `status: FAIL` üretebiliyordu; fakat iki yorumlayıcı da süreç açısından
başarılı göründüğünde derleyici yine çıkış 0 verip genel başarı mesajı yazıyordu.
Bu, karşılaştırma sonucunu gözlenebilir bir artifact'e indirgiyor ve otomatik
koşucunun süreç durumuna güvenmesini engelliyordu.

## Bağlayıcı sözleşme

1. AST ve MIR ikisi de `PASS` olmalı.
2. Program çıktıları satır sonu farkı yok sayılarak aynı olmalı.
3. Bu iki koşuldan biri sağlanmazsa `BOTH` başarılı sayılamaz.
4. AST/MIR ön koşulu başarısızsa mevcut `rc=25` davranışı korunur.
5. İki yorumlayıcı `PASS` olduğu halde çıktıları farklıysa süreç `rc=25`
   ile biter; `UXB_INTERPRETER_COMPARE_MISMATCH` ortak tanısı terminale,
   katman olayına ve `all_diagnostics.json` listesine yazılır.

`result_type` ve `return_value`, yorumlayıcı sarmalayıcı metadatasıdır; programın
gözlenebilir çıktısının yerine karşılaştırma ölçütü değildir.

## Uygulama

- `UXBInterpreterCompareOutputsMatch`, `interpreter_execution_artifacts.fbs`
  içinde satır sonu normalizasyonu ile tek karşılaştırma yardımcısıdır.
- `main_program_entry_part2.fbs`, karşılaştırma JSON'u yazıldıktan sonra bu
  sonucu saklar ve runtime trace yazıldıktan sonra başarısızlık kapısını uygular.
- `error_system_adim45.fbs` katalog ve çıkarım eşlemesini taşır.
- `main_output_contract_bridge.fbs`, ortak structured diagnostic code'u taşır.
- `run_s464_interpreter_compare_tests.ps1` merkezi model koşucusuna bağlandı.

## Kanıt

Yeni binary ile:

- `s510_mir_f32_rounding.uxb`: AST/MIR `PASS`, `stdout_match=true`, süreç
  çıkışı `0`.
- `s444_uncaught_assert.uxb`: AST/MIR `FAIL`, compare `FAIL`, süreç çıkışı
  `25`; sessiz başarı yok.
- S-464'ün eski karışık sayı/metin örneği artık S-459/S-460 tip kapısında
  `UXB_MIXED_STRING_NUMERIC` ile çıkış `1` verir; bu eski davranış artık
  karşılaştırma aşamasına ulaşmaz.

Güncel korunmuş pozitif AST/MIR kümelerinde iki yorumlayıcı da `PASS` iken
farklı program çıktısı veren canlı bir fixture kalmamıştır. Bu nedenle yeni
karşılaştırma-mismatch dalı kaynakta uygulanmış, eşleşme ve ön koşul hata yolları
gerçek koşuyla sınanmış; gelecekteki ilk gerçek ayrışma bu ortak kodla kapanacaktır.
