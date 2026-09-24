# uXBasic Adli Karsilastirma (Forensic Comparison) (2026-04-20)

## Kapsam (Scope)
- Mevcut derleyici kaynak kodu ile matris/plan iddialarini karsilastir.
- Odak: UCASE/LCASE, TRY/CATCH/FINALLY/THROW/ASSERT, LIST/DICT/SET.
- Ayrica silinmis dosyalarin git gecmisinde gorunup gorunmedigini kontrol et.

## Yontem (Method)
1. Kaynak agacinda ozellik token ve isleyicilerini (handler) aradim.
2. Matris ve plan ifadeleriyle capraz kontrol yaptim.
3. Mumkun olan yerlerde calistirilabilir kanit testlerini dogruladim.
4. Izlenen (tracked) dosyalar icin git silinme gecmisini inceledim.

## Git Silinme Bulgulari (Git Deletion Findings)
- `git log --diff-filter=D -- src tests reports` komutu bu kapsamdaki izlenen dosyalarda silinme gostermedi.
- Bunun anlami:
  - Ya bu klasorlerde izlenen dosya silinmedi,
  - Ya da kayip, izlenmeyen (untracked) dosyalarda veya uzerine yazma ile oldu.
- `tests/basicCodeTests` su an izlenmiyor (`git ls-files tests/basicCodeTests` => 0). Bu nedenle bu klasor icin gitten dogrudan gecmis geri yukleme yapilamiyor.

## Ozellik Gerceklik Tablosu (Feature Reality Table)

| Ozellik (Feature) | Matris Iddeasi (Matrix Claim) | Kaynak Kod Gercegi (Current Source Reality) | Kanit (Evidence) |
|---|---|---|---|
| UCASE/LCASE | OK | Lexer + parser + runtime metin degerlendirme yolunda mevcut | `src/parser/lexer/lexer_keyword_table.fbs`, `src/parser/parser/parser_shared.fbs`, `src/runtime/exec/exec_eval_text_helpers.fbs`, `tests/run_runtime_intrinsics.bas` |
| LIST/DICT/SET tipleri | OK | Tip sistemi + runtime koleksiyon motoru + testlerde mevcut | `src/semantic/type_binding.fbs`, `src/runtime/memory_exec.fbs`, `src/runtime/exec/exec_eval_builtin_categories.fbs`, `src/runtime/exec/exec_collections.fbs`, `tests/run_collection_engine_exec.bas` |
| TRY/CATCH/FINALLY/END TRY | OK | Parser dispatch + AST + runtime executor zinciri aktif ve testle dogrulandi | `src/parser/lexer/lexer_keyword_table.fbs`, `src/parser/parser/parser_stmt_registry.fbs`, `src/parser/parser/parser_stmt_flow.fbs`, `src/runtime/exec/exec_stmt_flow.fbs`, `tests/run_err_try_throw_assert_exec.bas` |
| THROW | OK | `THROW_STMT` parse ve runtime hata uretimi aktif; CATCH ile yakalanma ve uncaught fail-fast testli | `src/parser/parser/parser_stmt_flow.fbs`, `src/runtime/exec/exec_stmt_flow.fbs`, `tests/run_err_try_throw_assert_exec.bas` |
| ASSERT | OK | `ASSERT_STMT` parse + kosul degerlendirme + mesajli fail-fast akisi aktif | `src/parser/parser/parser_stmt_flow.fbs`, `src/runtime/exec/exec_stmt_flow.fbs`, `tests/run_err_try_throw_assert_exec.bas` |

## Matris ve Kod Tutarlilik Notlari (Matrix vs Code Consistency)
- Matris `TRY/CATCH/FINALLY/END TRY` ve `THROW/ASSERT` satirlari icin kod-zincir uyumsuzlugu kapatildi.
- `reports/forensic_matrix_full_scan_2026-04-20.csv` icinde ilgili satirlar `TUTARLI` durumuna gecti.
- Forensic tarama scriptindeki yanlis-negatif probe mantigi duzeltildi (ozellik-bazli regex probe + token fallback).
- Tam tarama ozeti son durumda `SUPHELI=0`, `EKSIK_TEST_DOSYASI=0`.

## Temel Ornek Dosyalar (Basic Example Files)
- `tests/basicCodeTests/10.bas`: derleyici destekledigi halde UCASE/LCASE ornekleri eksikti (sonradan eklendi).
- `tests/basicCodeTests/17.bas`: TRY/CATCH/FINALLY gostermek yerine sade IF akisina indirgenmis durumda.
- Klasor izlenmedigi icin eski surumler gitten dogrudan geri getirilemez.

## Kesin Sonuclar (Hard Conclusions)
1. UCASE/LCASE destegi kaynakta ve testte gercektir.
2. LIST/DICT/SET destegi kaynakta ve testte gercektir.
3. TRY/CATCH/FINALLY/THROW/ASSERT zinciri parser + runtime + test tarafinda uygulanmis ve calisir durumdadir.
4. Onceki supheli 14 satirin tamaminda rapor-kod tutarliligi dogrulanmis; guncel adli taramada supheli kayit kalmamistir.

## Acil Onarim Yonelimi (Immediate Repair Direction)
1. `tests/run_err_try_throw_assert_exec.bas` testini Faz-A gate listesine kalici ekle.
2. CATCH degiskenine sadece sentinel integer yerine kod/mesaj baglama iyilestirmesi yap.
3. Kod-uretim (CG) tarafindaki `ERR-CG-*` KISMEN satirlari icin emit lane kapanislarini plan sirasiyla tamamla.
