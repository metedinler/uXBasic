# Orchestrator Rehberi

Amac: Her turda yeniden tam analiz yapmadan, ajanlarin kendi delta notlariyla hizli karar almak.

## Zorunlu Kurallar

1. Her ajan kendi klasorundeki `profile.md`, `rules.md`, `analysis_log.md`, `task_log.md` dosyalarini gunceller.
2. Her ajan her tur en fazla 3 onceki kaydini okur (token disiplini).
3. Her ajan yeni kod yazmadan once `analysis_log.md` icinde `Delta` bolumu acmak zorundadir.
4. Her ajan kod bittiginde ayni dosyada `Post-Update` bolumunu doldurur.
5. Her ajan puani -100 ile 100 araligindadir; tum turlerde toplanir.
6. Her alt ajan analiz/raporlarini sadece kendi alt klasorunde saklar; baska ajan klasorlerine analiz yazamaz.
7. `analysis_log.md` icinde standart baslik zorunludur: `## YYYY-MM-DD Delta`, `### Kapsam`, `### Bulgular`, `### Kanit`, `## YYYY-MM-DD Post-Update`.
8. `task_log.md` maddeleri `DONE/NEXT/BLOCKED` etiketiyle tek satir ve izlenebilir olmalidir.

## Raporlama Formati

- Konum: Her ajan yalnizca kendi klasorunde (`AGENT_*/analysis_log.md`, `AGENT_*/task_log.md`) yazar.
- Baslik disiplini:
	- `## YYYY-MM-DD Delta`
	- `### Kapsam`
	- `### Bulgular`
	- `### Kanit`
	- `## YYYY-MM-DD Post-Update`
- Kanit satirlari test dosyasi + komut + sonuc (PASS/FAIL) icermelidir.

## Puanlama

- Odul: +10 (is zamani tamamlama), +15 (regresyonsuz teslim), +20 (matris hucre gecisi)
- Ceza: -10 (tekrar analiz), -20 (yanlis dosya/yanlis kapsam), -30 (testsiz degisiklik)

Doyum hedefi: ajan basi 500 gorev dongusu.

## Aktif Ajanlar

1. AGENT_SCOPE_RUNTIME
2. AGENT_FFI_CONVENTION
3. AGENT_MATRIX_PLAN
