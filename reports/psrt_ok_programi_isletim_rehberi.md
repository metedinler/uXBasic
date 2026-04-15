# PSRT OK Programi Isletim Rehberi

Tarih: 2026-04-14
Kapsam: uXBasic_repo icin PSRT envanter + validation + closure operasyonu.

## 1) Gunluk Workflow (zorunlu)

Gunluk akis her zaman su sirada calistirilir:

1. Inventory
2. Prioritize
3. Implement
4. Test
5. Gate
6. Matrix update

Kural:
- Gate PASS olmadan hicbir satir OK'a cekilmez.
- Matrix update, kanit komutlari ve test_ref guncellenmeden tamam sayilmaz.

## 2) Referans Scriptler

Mevcut gate scripti:
- `tools/run_faz_a_gate.ps1`

Yeni PSRT scriptleri:
- `tools/perf_runtime_benchmark.ps1`
- `tools/runtime_memory_benchmark.ps1`
- `tools/memory_runtime_snapshot.ps1`
- `tools/benchmark_selected_execs.ps1`

Validation ve closure scriptleri:
- `tools/validate_test_naming.ps1`
- `tools/validate_module_quality_gate.ps1`
- `tools/run_faz_b2_failfast.ps1`
- `tools/phase_commit_push.ps1`

Matrix ve plan dosyalari:
- `reports/uxbasic_operasyonel_eksiklik_matrisi.md`
- `tests/plan/command_compatibility_win11.csv`
- `reports/faz_next_backlog.md`
- `spec/IR_RUNTIME_MASTER_PLAN.md`

## 3) Komutlar (Exact PowerShell)

### 3.1 Hazirlik

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
```

### 3.2 Inventory

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\perf_runtime_benchmark.ps1 -Executables tests/run_call_user_exec_ast_64.exe,tests/run_class_method_dispatch_exec_ast_64.exe,tests/run_class_method_dispatch_call_expr_exec_ast_64.exe,tests/run_percent_preprocess_exec_64.exe,tests/run_collection_engine_exec_64.exe -Repeat 3 -TimeoutSeconds 30 -OutputCsv reports/runtime_perf_dispatch_preprocess_collections.csv
```

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\runtime_memory_benchmark.ps1 -Executables tests/run_call_user_exec_ast_64.exe,tests/run_class_method_dispatch_exec_ast_64.exe,tests/run_class_method_dispatch_call_expr_exec_ast_64.exe,tests/run_percent_preprocess_exec_64.exe,tests/run_collection_engine_exec_64.exe -Repeat 3 -TimeoutSeconds 30 -OutputCsv reports/runtime_memory_dispatch_preprocess_collections.csv
```

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\memory_runtime_snapshot.ps1 -Executables tests/run_manifest_64.exe,tests/run_memory_exec_ast_64.exe -Repeat 2 -TimeoutSeconds 20 -SampleIntervalMs 20 -OutputCsv reports/runtime_memory_snapshot.sample.csv
```

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\benchmark_selected_execs.ps1 -Iterations 30 -OutCsv reports/perf_selected_execs.csv
```

### 3.3 Prioritize (severity triage)

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
Get-Content .\reports\runtime_perf_dispatch_preprocess_collections.csv
Get-Content .\reports\runtime_memory_dispatch_preprocess_collections.csv
Get-Content .\reports\uxbasic_operasyonel_eksiklik_matrisi.md
```

### 3.4 Implement

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
git checkout -b psrt/<kisa-konu>
```

### 3.5 Test (satir bazli)

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
cmd /d /c "build_64.bat tests\run_flow_io_exec_ast.bas & if errorlevel 1 exit /b 1 & tests\run_flow_io_exec_ast_64.exe"
```

Not: Satir hangi teste bagliysa ayni pattern ile ilgili `tests/run_*` kosucusu calistirilir.

### 3.6 Validation + Gate

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\validate_test_naming.ps1
```

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\validate_module_quality_gate.ps1
```

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\run_faz_a_gate.ps1
```

### 3.7 Matrix update

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
code reports/uxbasic_operasyonel_eksiklik_matrisi.md tests/plan/command_compatibility_win11.csv
```

### 3.8 Closure

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\run_faz_b2_failfast.ps1 -SkipBuild
```

```powershell
Set-Location "c:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo"
powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\phase_commit_push.ps1 -Message "PSRT: <satir-adi> OK closure"
```

## 4) Severity Karar Tablosu (Critical/High/Medium)

| Severity | Kosul | Oncelik | Maks aksiyon suresi | Zorunlu aksiyon |
|---|---|---|---|---|
| Critical | Gate kirmizi, runtime crash, veri kaybi, row regression (OK -> KISMEN/YOK) | P0 | Ayni gun | Derhal fix + tekrar test + gate + matrix notu |
| High | Satir KISMEN ve test fail var, semantik/runtime uyumsuzlugu var, release riski var | P1 | 24 saat | Dedicated test + fix + gate + row update |
| Medium | Dokuman drift, non-blocking perf dususu, backlog tipi iyilestirme | P2 | 3 is gunu | Planla, backlog'a yaz, gate yesil tut |

Karar kurali:
- Ayni issue birden fazla kosulu sagliyorsa en yuksek severity secilir.

## 5) Matrix Row Definition of Done (her satir icin)

Bir satirin OK kapanisi icin tum maddeler isaretli olmalidir:

- [ ] Satirin hedef D/P/S/R/T kolonlari acikca tanimlandi.
- [ ] Satira bagli `tests/run_*.bas` kosucusu PASS.
- [ ] Ilgili negatif/fail-fast senaryosu PASS (varsa).
- [ ] `tools/validate_test_naming.ps1` PASS.
- [ ] `tools/validate_module_quality_gate.ps1` PASS.
- [ ] `tools/run_faz_a_gate.ps1` PASS.
- [ ] `reports/uxbasic_operasyonel_eksiklik_matrisi.md` satiri guncellendi.
- [ ] `tests/plan/command_compatibility_win11.csv` test_ref alanlari guncellendi.
- [ ] Kanit komutlari ve cikti yollari not edildi (reports/*.csv veya test ciktilari).
- [ ] Mimari blokaj yoksa satir OK'a cekildi; blokaj varsa escalation protokolu uygulandi.

## 6) Escalation Kurallari (mimari kisit nedeniyle OK olmuyorsa)

Satir architecture constraint nedeniyle OK'a cekilemiyorsa su kurallar zorunludur:

1. Satiri zorla OK yapma. Durum `KISMEN` kalir.
2. Not alanina `ARCH-BLOCKED` etiketi ve teknik neden yazilir.
3. Blokaj kaydi eklenir:
   - `reports/faz_next_backlog.md`
   - `spec/IR_RUNTIME_MASTER_PLAN.md`
4. En az bir gecici emniyet adimi uygulanir:
   - fail-fast guard, veya
   - kapsam siniri (scope limit), veya
   - explicit unsupported hatasi.
5. Gate yine yesil olmak zorundadir (`tools/run_faz_a_gate.ps1`).
6. Asagidaki durumlardan biri varsa mimari escalasyon acilir:
   - 1 is gunu icinde cozumlenemeyen blocker,
   - 2+ katman (parser+semantic+runtime) kirici refactor gereksinimi,
   - mevcut language contract ile celisen gereksinim.
7. Escalasyon sonucunda tek satir karar verilir:
   - `KAPSAM-DISI (bu faz)` veya
   - `MIMARI-REFATOR GEREKLI (sonraki faz)`.

## 7) Operasyon Notlari

- Build komutlarinda PowerShell yerine `cmd /d /c` pattern'i deterministik davranis verir.
- Test binary kosulari repo kokunden (`uXBasic_repo`) yapilmalidir.
- Script ciktilari `reports/` altina yazilmali, adlandirma stabil tutulmalidir.
