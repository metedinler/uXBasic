# Prompt 0 — UXBc Baseline Kilitleme

Bu paket yeni özellik eklemez. Amaç mevcut sistemi analiz etmek ve raporlamaktır.

## Çalıştırma

UXBc klasörünü yeni bir yere aç:

```bat
cd /d C:\Users\mete\Downloads\UXBc
run_prompt0_baseline.bat
```

MSYS2/GCC gerektiren ağır FP runtime testini atlamak istersen:

```bat
run_prompt0_baseline.bat --skip-heavy-runtime
```

Sadece klasör/dosya durumunu görmek, test çalıştırmamak istersen:

```bat
run_prompt0_baseline.bat --no-run
```

## Çıktılar

```text
uxb\dist\baseline\baseline_status.md
uxb\dist\baseline\baseline_status.json
uxb\dist\baseline\baseline_checks.csv
uxb\dist\baseline\logs\*.log
```

## Ne kontrol eder?

- `uxb/src` dosya sayısı, boyut, build çıktısı var mı?
- `uxb/runtime_ext` F80/F128/BIGF/BIGD/BALL dosyaları var mı?
- `uxb/tests` test kaynakları var mı?
- `uxb/vscode-extension` var mı?
- Compiler build scriptleri çalışıyor mu?
- Mevcut smoke scriptleri çalışıyor mu?
- Hangi test geçti?
- Hangi test diagnostic verdi?
- Hangi test build/runtime kırdı?
- Hangi test toolchain eksikliği nedeniyle çalışmadı?

## Durum sınıfları

```text
PASS
PASS_WITH_DIAGNOSTIC_TEXT
EXPECTED_OR_EXPLICIT_DIAGNOSTIC
TOOLCHAIN_OR_FILE_MISSING
BUILD_OR_RUNTIME_FAIL
FAIL
```

## Bana göndermen gerekenler

Önce şu dosyayı açıp içeriğini gönder:

```text
uxb\dist\baseline\baseline_status.md
```

Eğer hata varsa ilgili log dosyasını da gönder:

```text
uxb\dist\baseline\logs\...
```
