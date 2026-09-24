# Faz Sonrasi Backlog (B.2 Devralim)

Tarih: 2026-04-11
Kaynak: B.2 artefaktlari ve gate ciktilari

## P0 (Yuksek Oncelik)
- TB-NEXT-001: Runtime nested adresleme kapsamini derinlestir
  - Kapsam: `VARPTR(root)+OFFSETOF(path)` ile 3+ seviye nested TYPE/ARRAY senaryolari
  - Dosyalar: `src/runtime/memory_exec.fbs`, `tests/run_memory_exec_ast.bas`
  - Cikis: Pozitif/negatif test vektorleri + gate yesil

- TB-NEXT-002: FOR EACH pointer stride test matrisini genislet
  - Kapsam: cok boyutlu ve farkli align kombinasyonlari
  - Dosyalar: `tests/run_each_exec.bas`, `tests/run_memory_stride_failfast.bas`
  - Cikis: En az 6 yeni stride vektoru (2 pozitif, 4 fail-fast)

## P1 (Orta Oncelik)
- TB-NEXT-003: Width mismatch mesajlarini kodlu hata formatina gecir
  - Kapsam: `expected/got/fieldType/path` + sabit kod
  - Dosyalar: `src/semantic/layout.fbs`, `src/runtime/memory_exec.fbs`
  - Cikis: Geriye uyumlu mesaj + testler

- TB-NEXT-004: Runtime hata prefix standardini tum runtime modullerine yay
  - Kapsam: `exec:` normalizasyonunun dosya I/O ve diger runtime modullerinde teklesenmesi
  - Dosyalar: `src/runtime/*.fbs`
  - Cikis: tek prefix sozlesmesi ve smoke kontrolu

- TB-NEXT-005: B.2 fail-fast suite performans/kararlilik iyilestirmesi
  - Kapsam: `tools/run_faz_b2_failfast.ps1` timeout/log iyilestirmeleri
  - Dosyalar: `tools/*.ps1`
  - Cikis: daha kararlı CI kosusu

## P2 (Dusuk Oncelik)
- TB-NEXT-006: Test helper paketini genislet
  - Kapsam: `tests/helpers/runtime_test_common.fbs` icine tekrarli fixture patternlerinin alinmasi
  - Cikis: test dosyalarinda tekrar azalmasi

- TB-NEXT-007: B.2 artefakt envanteri otomatik rapor
  - Kapsam: release not + done checklist sinkron rapor
  - Dosyalar: `reports/`
  - Cikis: tek komutla guncellenebilen rapor
