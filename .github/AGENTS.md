# Agent Coordination Rules

## Shared Test Naming Contract

Tum ajanlar su dosyayi normatif kaynak kabul eder:
- `tests/TEST_NAMING_STANDARD.md`

Uygulama zorunlulugu:
- Manifest test ID'leri standart format disina cikamaz.
- Compatibility test_ref degerleri manifest test ID'leri ile bagli olmalidir.
- Her test-related degisiklikten sonra `tools/validate_test_naming.ps1` calistirilir.

## Enforcement

Ajanlar naming standardina uymayan degisiklikleri bitmis kabul etmez.

## Otomatik Yurutme Kurallari (Zorunlu)

- Tum isler varsayilan olarak cok ajanli(multi-agent) ve paralel(parallel) yurutulur.
- Faz kapisi yesilse bir sonraki faza otomatik gecilir; kullanicidan tekrar onay beklenmez.
- Her adimda semantik kontrol(semantic checks) + test + gate kosusu zorunludur.
- Runtime once ilkesi gecerlidir: runtime kirmiziyken yeni dil ozelligi acilmaz.
- Faz sonu zorunlu: git commit ve git push.

## Dil ve Bildirim Sozlesmesi

- Program bildirim metinleri Turkce yazilir.
- Hata bildirimleri Turkce yazilir ve dosyaya loglanir.
- Programin standart cikisi, komut sonucunun kendisi disinda ek bilgi basmaz.

## Tum Ajanlara Zorunlu Aktarim

- Ana ajan, baslattigi her alt ajana bu sozlesmeyi prompt icinde acikca aktarir.
- Alt ajanlarin urettigi kod/mesaj bu kurallarla celisiyorsa sonuc kabul edilmez.
- Runtime ve test kodunda yeni hata metinleri eklenirse Turkce yerellestirme kaydi zorunludur.
