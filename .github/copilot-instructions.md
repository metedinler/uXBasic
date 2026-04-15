# Copilot Workspace Instructions

## Test Naming Policy (Mandatory)

Tum yeni testler ve test referanslari asagidaki standarda uymak zorundadir:
- Dokuman: `tests/TEST_NAMING_STANDARD.md`
- Dogrulama: `tools/validate_test_naming.ps1`

Kurallar:
- `tests/manifest.csv` icinde sadece `TST-...-NNN` formati kullanilir (buyuk harf/rakam/tire + 3 haneli sira).
- `tests/plan/command_compatibility_win11.csv` icindeki `test_ref` alanlari manifestte var olan test ID'lerine baglanir.
- Yeni test yazildiginda veya test_ ref degistiginde naming validator calistirilir.

## Agent/Subagent Rule

Bu workspace icinde calisan tum ajanlar (ana ajan + alt ajanlar):
- yeni test adlandirmasinda bu standardi kullanir,
- eski/legacy test ID uretmez,
- test naming validator basarisizsa degisikligi tamamlanmis saymaz.

## Zorunlu Yurutme Kurallari

- Tum gorevler varsayilan olarak cok ajanli(multi-agent) ve paralel(parallel) yurutulur.
- Faz kapisi yesil oldugunda bir sonraki faza otomatik gecilir.
- Her kod adiminda semantik kontrol(semantic checks) ve test kosusu zorunludur.
- Runtime once ilkesine uyulur; runtime kirmiziysa yeni ozellik acilmaz.
- Her faz sonunda zorunlu islem: git commit + git push.

## Dil ve Cikti Sozlesmesi

- Program bildirimleri Turkce yazilir.
- Hata bildirimleri Turkce yazilir ve dosyaya yazilir.
- Programin standart cikisi yalnizca komut sonucu olur; ekstra teknik gosterim log dosyasina gider.

## Alt Ajan Aktarim Kurali

- Ana ajan, tum subagent cagrilarinda bu dil/cikti sozlesmesini acik gereksinim olarak yazar.
- Subagent tarafinda uretilen oneriler bu kurala uymuyorsa uygulanmaz.
- Yeni eklenen runtime hata metinleri icin `src/runtime/error_localization.fbs` guncellemesi zorunludur.
