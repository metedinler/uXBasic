---
applyTo: "uxb/**"
description: "uXBasic katman bazli yurutme kurallari (00-04)"
---

Kaynak belge seti: UXB_KATMAN_BAZLI_COPILOT_BELGE_SETI 00-04.

1) Calisma sirasi zorunlu
- 01_GENEL_KURALLAR
- 02_COPILOT_EMIRLERI
- 03_STATU_SOZLUGU
- 04_DOSYA_VE_CIKTI_DUZENI
- Sonraki adima gecmeden once o adimin rapor/test/gate ciktilari alinacak.

2) Mutlak kurallar
- Dosya/klasor silme yok.
- Kullanici acikca sil komutu verse ve teknik izinler mevcut olsa bile, silme uygulanmadan once "bu dosyalar silinecek" uyarisi zorunlu olarak verilecek.
- Silme yerine tasima veya emekliye ayirma secenegi varsa once o onerilecek.
- Silme kacınılmazsa, silinen her dosya/klasor icin neden silindigi, ne oldugu ve hangi riskin giderildigi rapora yazilacak.
- Yeni mimari icat etme yok, mevcut dizin duzeni kullanilacak.
- Silent skip yok.
- Gercek handler ve test yoksa IMPLEMENTED yazilmayacak.
- Placeholder/fake success yasak.

3) Status ve gate kurali
- Her hucre dolu olacak.
- Sadece statu sozlugundeki degerler kullanilacak.
- MISSING/BROKEN/UNKNOWN/EMPTY/fake implemented gate blocker sayilir.
- PARTIAL nihai hedefte kabul edilmez.

4) Lifecycle zorunlulugu
- Surface ogeleri icin lifecycle_route, implementation_owner, target_status, positive_test, negative_test alanlari zorunlu.
- Runtime davranisi olan ogelerde en az bir gercek execution yolu olacak.

5) Test zorunlulugu
- Her adimda pozitif + negatif test birlikte olacak.
- Beklenen/gercek cikti veya beklenen/gercek hata karsilastirmasi yapilacak.

6) Dizin ve cikti duzeni
- Kaynak: src/**
- Araclar: tools/audit, tools/control, tools/release
- Matrix/docs: docs/matrix, docs/control
- Rapor: reports/control/current, reports/control/history/<run_id>, reports/step1
- Cikti: dist, dist/loglar, dist/interop
- Emekli planlari: _retired/** (silme yerine tasima/plani)

7) Rapor seti zorunlulugu
- reports/control/current/<step>_changed_files.csv
- reports/control/current/<step>_layer_matrix.csv
- reports/control/current/<step>_blockers.csv
- reports/control/current/<step>_positive_tests.csv
- reports/control/current/<step>_negative_tests.csv
- reports/control/current/<step>_gate.json
- reports/control/current/<step>_gate.md
