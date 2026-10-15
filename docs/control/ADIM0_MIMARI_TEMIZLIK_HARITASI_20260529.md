# UXBc Mimari ve Sistematik Temizlik Haritasi (Guncel)

Tarih: 2026-05-29
Kural: Dosya silme yok, sadece kontrollu tasima (`Move-Item`).

## 1) Kanonik Mimari (Derleyici Omurgasi)
- Kanonik kaynak kok: `uxb/src/`
- Katman akisi:
  - `uxb/src/parser/lexer/` -> lexer + preprocess
  - `uxb/src/parser/` -> parser + AST
  - `uxb/src/semantic/` -> semantic, HIR bridge, MIR model/lowering/verify
  - `uxb/src/symbols/` -> scope/symbol cozumleme
  - `uxb/src/backend/` + `uxb/src/codegen/` -> x64/JS/WAT/WASM uretimi
  - `uxb/src/runtime/` + `uxb/runtime_ext/` -> runtime servisleri/dis bagimliliklar

## 2) Kanonik Operasyon Alanlari
- Aktif rapor/gate ciktilari: `uxb/reports/control/current/`
- Calisma/analiz run alani: `uxb/_work/projects/default/`
- Araclar: `uxb/tools/`
- Testler: `uxb/tests/`

## 3) Python Arac Siniflari (amaca gore)
- Envanter/temizlik destek:
  - `uxb/tools/inventorymake.py`
  - `uxb/tools/envanter_uretici.py`
- Run/test analizi:
  - `uxb/_work/projects/default/uxbc_runs_analysis_report/uxbrarp.py`
  - `uxb/tools/test_sonuclari_derin_analiz.py`
  - `uxb/tools/beklenen_cikti_karsilastirici.py`
- Arac kataloglama:
  - `uxb/tools/python_arac_siniflandirici.py`

Cikti prensibi: tum yeni audit/analiz ciktilari `uxb/reports/control/current/` altina yazilir.

## 4) Koruma Politikasi (dokunulmayacaklar)
- Plan/patch dokuman setleri korunur:
  - `uxb/UXB_KATMAN_BAZLI_COPILOT_BELGE_SETI/**`
  - patch/plan odakli dokuman klasorleri
- Kanonik kaynak/agac korunur:
  - `uxb/src/**`, `uxb/tools/**`, `uxb/tests/**`, `uxb/docs/**`

## 5) Emeklilik Politikasi
- Geliştirme aninda gerekli olmayan gurultu dosyalari emekliye tasinir:
  - Eski run artefaktlari (`_work/runs` altindaki tarihsel raporlar)
  - Dist/noise dokumanlari ve tekrarli test kalintilari
  - Eski step raporlari ve kökte biriken yardimci dokuman kalintilari
- Hedef:
  - `uxb/_retired/workspace_cleanup_<timestamp>/...`
- Her tasima adimi icin CSV manifest uretilir:
  - `uxb/reports/control/current/adim0_retired_*_moves_<timestamp>.csv`

## 6) Bu Tur Sonunda Durum Ozeti
Yapilan kontrollu tasima gruplari:
- Kök arsiv/exe/log gurultuleri emekliye tasindi.
- `verify_*` tarihsel analiz klasorleri emekliye tasindi.
- Runtime `deps/*.zip` kalintilari emekliye tasindi.
- Icerik siniflamasina gore `.md/.txt` gurultu dosyalari emekliye tasindi (plan/patch alanlari haric).

## 7) Mimarinin Temel Isletim Kurali
Hedef akış:
`Lexer/Parser -> AST -> Semantic/Step3 -> HIR bridge -> MIR -> (zorunlu gate) -> Backend`

Temizlik hedefi:
- Derleyici davranisini degistirmeden,
- Calisma alanindaki dosya gurultusunu azaltmak,
- Rapor ve arac ciktilarini tek kanonik rapor alaninda toplamak.
